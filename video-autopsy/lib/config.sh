#!/usr/bin/env bash
# video-autopsy: portable configuration resolver.
#
# Source this file, do not execute it:
#   source /path/to/video-autopsy-skill/lib/config.sh
#
# It resolves every WV_* setting the skill needs and exports it, using this order for EVERY
# value (first hit wins):
#   1. environment variable   (e.g. WV_PYTHON)
#   2. config file key        (e.g. "python" in the resolved config file)
#   3. auto-detection         (probe the machine: command -v, python imports, nvidia tooling)
#   4. documented default     (a plain, always-safe fallback)
#
# Config file location, first that exists:
#   1. $VA_CONFIG                                          (explicit override, this package)
#   2. $WV_CONFIG                                          (explicit override, family-wide)
#   3. ./.video-autopsy.json                       (project-local, this package)
#   4. ./.watch-video.json                             (project-local, family-wide)
#   5. ${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json   (user-global, family-wide)
#
# This package deliberately reads the SAME family config file as "watch-video" and
# "watch-video-max". One file configures all three: the toolchain keys (python, ffmpeg, whisper)
# are shared, and this package adds its own VA_* keys on top. Pin WV_PYTHON once and every
# package in the family uses it.
#
# WHY TWO PREFIXES. WV_* keys are the shared ingest toolchain and mean exactly what they mean in
# the sibling packages -- do not redefine them here. VA_* keys are specific to reviewing a
# recorded session: where the recordings live, where the operator profile lives, where the
# evaluation is filed. A reader of a shared config file can tell at a glance which package owns
# which key, which is the whole reason for not folding them into one prefix.
#
# If no config file exists at all, resolution still works: every value falls through to
# auto-detect then default. That "no config file" path is the primary case for a freshly
# downloaded copy of this skill -- it must never hard-fail.
#
# JSON parsing needs no external dependency: it tries `jq` first, then falls back to a small
# python one-liner run through whatever python3/python is on PATH (NOT the resolved WV_PYTHON --
# that would be circular, since the config file can itself set the python key). If neither is
# available, config-file values are simply skipped and resolution continues through
# auto-detect/default; a missing or malformed config file is never a fatal error here.
#
# Call `wv_config_dump` after sourcing to print every resolved key, its value, and which of the
# four sources produced it -- this is the transparency surface for "what did the skill decide
# about my machine."

# ---------------------------------------------------------------------------------------------
# 0. locate a bootstrap JSON parser (independent of the python key we are about to resolve)
# ---------------------------------------------------------------------------------------------

_WV_BOOTSTRAP_PY=""
if command -v python3 >/dev/null 2>&1; then
  _WV_BOOTSTRAP_PY="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
  _WV_BOOTSTRAP_PY="$(command -v python)"
fi

# ---------------------------------------------------------------------------------------------
# 1. find the config file (first that EXISTS, in priority order)
# ---------------------------------------------------------------------------------------------

_wv_find_config_file() {
  if [ -n "${VA_CONFIG:-}" ] && [ -f "${VA_CONFIG:-}" ]; then
    printf '%s' "$VA_CONFIG"
    return 0
  fi
  if [ -n "${WV_CONFIG:-}" ] && [ -f "${WV_CONFIG:-}" ]; then
    printf '%s' "$WV_CONFIG"
    return 0
  fi
  if [ -f "./.video-autopsy.json" ]; then
    printf '%s' "./.video-autopsy.json"
    return 0
  fi
  if [ -f "./.watch-video.json" ]; then
    printf '%s' "./.watch-video.json"
    return 0
  fi
  local xdg_config
  xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json"
  if [ -f "$xdg_config" ]; then
    printf '%s' "$xdg_config"
    return 0
  fi
  printf ''
  return 0
}

WV_CONFIG_FILE="$(_wv_find_config_file)"
if [ -n "${WV_CONFIG:-}" ] && [ ! -f "${WV_CONFIG:-}" ]; then
  WV_CONFIG_NOTE="WV_CONFIG=$WV_CONFIG was set but that path does not exist; fell through to the next candidate."
else
  WV_CONFIG_NOTE=""
fi

# ---------------------------------------------------------------------------------------------
# 2. JSON key lookup (jq, else bootstrap-python, else "not available" -- never fatal)
# ---------------------------------------------------------------------------------------------

_wv_json_get() {
  local key="$1"
  if [ -z "${WV_CONFIG_FILE:-}" ] || [ ! -f "${WV_CONFIG_FILE:-}" ]; then
    printf ''
    return 0
  fi
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg k "$key" '.[$k] // empty' "$WV_CONFIG_FILE" 2>/dev/null
    return 0
  fi
  if [ -n "$_WV_BOOTSTRAP_PY" ]; then
    "$_WV_BOOTSTRAP_PY" -c '
import json, sys
path, key = sys.argv[1], sys.argv[2]
try:
    with open(path) as f:
        data = json.load(f)
except Exception:
    sys.exit(0)
if not isinstance(data, dict):
    sys.exit(0)
val = data.get(key)
if val is None:
    sys.exit(0)
sys.stdout.write(str(val))
' "$WV_CONFIG_FILE" "$key" 2>/dev/null
    return 0
  fi
  # no parser available at all: degrade gracefully, config file is simply not consulted
  printf ''
  return 0
}

# ---------------------------------------------------------------------------------------------
# 3. generic resolver: env -> config -> detect (lazy, only run if needed) -> default
# ---------------------------------------------------------------------------------------------

_wv_resolve() {
  local resultvar="$1" envname="$2" jsonkey="$3" detectfunc="$4" defaultval="$5"
  local envval=""
  eval "envval=\"\${${envname}:-}\""
  if [ -n "$envval" ]; then
    printf -v "$resultvar" '%s' "$envval"
    printf -v "${resultvar}_SOURCE" '%s' "env"
    return 0
  fi
  local jsonval=""
  jsonval="$(_wv_json_get "$jsonkey")"
  if [ -n "$jsonval" ]; then
    printf -v "$resultvar" '%s' "$jsonval"
    printf -v "${resultvar}_SOURCE" '%s' "config"
    return 0
  fi
  local detectval=""
  if [ -n "$detectfunc" ]; then
    detectval="$("$detectfunc" 2>/dev/null)"
  fi
  if [ -n "$detectval" ]; then
    printf -v "$resultvar" '%s' "$detectval"
    printf -v "${resultvar}_SOURCE" '%s' "detect"
    return 0
  fi
  printf -v "$resultvar" '%s' "$defaultval"
  printf -v "${resultvar}_SOURCE" '%s' "default"
  return 0
}

# ---------------------------------------------------------------------------------------------
# 4. auto-detect functions
# ---------------------------------------------------------------------------------------------

_wv_detect_python() {
  local candidates="" c
  if command -v python3 >/dev/null 2>&1; then
    candidates="$candidates $(command -v python3)"
  fi
  if [ -n "${CONDA_PREFIX:-}" ] && [ -x "${CONDA_PREFIX}/bin/python3" ]; then
    candidates="$candidates ${CONDA_PREFIX}/bin/python3"
  fi
  for c in "$HOME"/miniconda3/envs/*/bin/python3 "$HOME"/anaconda3/envs/*/bin/python3 \
           "$HOME"/miniforge3/envs/*/bin/python3 \
           "$HOME"/miniconda3/bin/python3 "$HOME"/anaconda3/bin/python3 \
           "$HOME"/.venv/bin/python3 ./venv/bin/python3 ./.venv/bin/python3; do
    [ -x "$c" ] 2>/dev/null && candidates="$candidates $c"
  done
  for c in $candidates; do
    [ -x "$c" ] || continue
    if "$c" -c 'import faster_whisper' >/dev/null 2>&1; then
      printf '%s' "$c"
      return 0
    fi
  done
  printf ''
  return 0
}

_wv_detect_ffmpeg()  { command -v ffmpeg  2>/dev/null; }
_wv_detect_ffprobe() { command -v ffprobe 2>/dev/null; }

_wv_detect_ytdlp() {
  if command -v yt-dlp >/dev/null 2>&1; then
    command -v yt-dlp
    return 0
  fi
  local py="${WV_PYTHON:-python3}"
  if command -v "$py" >/dev/null 2>&1 || [ -x "$py" ]; then
    if "$py" -c 'import yt_dlp' >/dev/null 2>&1; then
      printf '%s -m yt_dlp' "$py"
      return 0
    fi
  fi
  printf ''
  return 0
}

_wv_detect_js_runtime() {
  if command -v deno >/dev/null 2>&1; then
    command -v deno
    return 0
  fi
  if command -v node >/dev/null 2>&1; then
    command -v node
    return 0
  fi
  printf ''
  return 0
}

_wv_detect_whisper_device() {
  local py="${WV_PYTHON:-python3}"
  local n
  if ! command -v "$py" >/dev/null 2>&1 && [ ! -x "$py" ]; then
    printf ''
    return 0
  fi
  n="$("$py" -c 'import ctranslate2 as c; print(c.get_cuda_device_count())' 2>/dev/null)"
  if [ -n "$n" ] && [ "$n" -ge 1 ] 2>/dev/null; then
    printf 'cuda'
  else
    printf ''
  fi
  return 0
}

_wv_detect_whisper_compute() {
  case "${WV_WHISPER_DEVICE:-}" in
    cuda) printf 'float16' ;;
    cpu)  printf 'int8' ;;
    *)    printf '' ;;
  esac
  return 0
}

# ---------------------------------------------------------------------------------------------
# 5. resolve everything, IN DEPENDENCY ORDER (python before ytdlp/whisper_device; output_dir
#    before other derived paths; whisper_device before whisper_compute)
# ---------------------------------------------------------------------------------------------

_wv_resolve WV_FFMPEG  WV_FFMPEG  "ffmpeg"  _wv_detect_ffmpeg  "ffmpeg"
_wv_resolve WV_FFPROBE WV_FFPROBE "ffprobe" _wv_detect_ffprobe "ffprobe"

_wv_resolve WV_PYTHON WV_PYTHON "python" _wv_detect_python "python3"

# NOTE: no yt-dlp / JS-runtime keys here, deliberately. This package analyses a local recording
# produced by a recorder you control. There is no URL path in this package, so there is nothing
# for a downloader to do and no reason to make a user install one.

_wv_resolve WV_WORK_DIR      WV_WORK_DIR      "work_dir"      "" "${TMPDIR:-/tmp}/video-autopsy"
_wv_resolve WV_RECORDINGS_DIR WV_RECORDINGS_DIR "recordings_dir" "" "$HOME/video-autopsy/recordings"
_wv_resolve WV_TRANSCRIPT_DIR WV_TRANSCRIPT_DIR "transcript_dir" "" ""

# VA_OUTPUT_DIR is separate from WV_OUTPUT_DIR on purpose. An autopsy is a private document about
# your own performance; filing it into the same directory a general video-analysis run writes to
# invites it being shared with a report you meant to share. Different sensitivity, different
# default destination.
_wv_resolve VA_OUTPUT_DIR VA_OUTPUT_DIR "autopsy_output_dir" "" "$HOME/video-autopsy/reports"

_wv_resolve WV_WHISPER_MODEL WV_WHISPER_MODEL "whisper_model" "" "large-v3"
_wv_resolve WV_WHISPER_DEVICE WV_WHISPER_DEVICE "whisper_device" _wv_detect_whisper_device "auto"
_wv_resolve WV_WHISPER_COMPUTE WV_WHISPER_COMPUTE "whisper_compute" _wv_detect_whisper_compute "auto"

_wv_resolve VA_FPS VA_FPS "autopsy_fps" "" "5"

# The 5 fps forensics floor is ADVISORY-BUT-LOUD, not a silent clamp. A lower rate is allowed --
# the user may have a good reason (a very long talking-head recording, a tiny disk) -- but below
# 5 fps the forensics lens degrades: micro-expressions and typing cadence stop resolving, and any
# finding derived from them becomes unsupportable. Warn on stderr so the run is never quietly
# downgraded, and require the analysis to label those metrics as degraded.
if [ "$(awk -v v="${VA_FPS:-5}" 'BEGIN{print (v<5)?1:0}' 2>/dev/null)" = "1" ]; then
  echo "WARN  VA_FPS=${VA_FPS} is below the 5 fps floor for behavioural analysis." >&2
  echo "      Micro-expression bursts and typing-cadence metrics will NOT resolve at this rate." >&2
  echo "      Proceed only if you label every frame-derived behavioral finding as DEGRADED." >&2
fi

# Deleting a source the pipeline did NOT create (the recording, or a transcript you supplied) is
# OFF by default and must be opted into. This matters more here than anywhere else in the family:
# the input is a recording of YOU, in a conversation that may not be repeatable, and you may hold
# the only copy. Set to "true" ONLY when an original survives elsewhere -- typically on the device
# that recorded it.
_wv_resolve VA_DELETE_SOURCE VA_DELETE_SOURCE "delete_source" "" "false"

# ---------------------------------------------------------------------------------------------
# 5b. the evaluation layer: where the operator's own context lives, and where findings are filed
# ---------------------------------------------------------------------------------------------
#
# All five are OPTIONAL and default to empty. The package runs a complete autopsy with none of
# them set -- it simply cannot do the cross-round work (trend, ledger consistency, tracker) that
# needs a history to compare against, and it says so in the report rather than guessing.
#
# VA_PROFILE_PATH is the important one. It points at a document describing the OPERATOR: their
# known behavioural patterns, their standing rules (what they will and will not disclose), the
# flaws already confirmed across previous rounds. That file is personal data and belongs to the
# user, which is exactly why it lives outside this package and is reached by configuration.
# A published skill that hardcoded one person's flaws would be useless to everybody else and
# a privacy problem for its author.

_wv_resolve VA_PROFILE_PATH VA_PROFILE_PATH "profile_path" "" ""
_wv_resolve VA_TRACKER_PATH VA_TRACKER_PATH "tracker_path" "" ""
_wv_resolve VA_ROLES_DIR    VA_ROLES_DIR    "roles_dir"    "" ""
_wv_resolve VA_ASSIST_LOG_DIR VA_ASSIST_LOG_DIR "assist_log_dir" "" ""

# Names of the tools that may have been running during the session, so the skill can ask about
# them BY NAME instead of asking "was anything on?" -- a question coarse enough to have produced
# a false finding in practice. Two distinct categories, and conflating them is the failure mode:
#   transcriber  -- records what was said. Harmless to an assessment of your own performance.
#   assist       -- generates answers. Changes what the assessment even means.
# Comma-separated. Leave empty and the skill asks the open question instead, which is worse.
_wv_resolve VA_TRANSCRIBER_TOOLS VA_TRANSCRIBER_TOOLS "transcriber_tools" "" ""
_wv_resolve VA_ASSIST_TOOLS      VA_ASSIST_TOOLS      "assist_tools"      "" ""

export WV_FFMPEG WV_FFPROBE WV_PYTHON
export WV_WORK_DIR WV_RECORDINGS_DIR WV_TRANSCRIPT_DIR
export WV_WHISPER_MODEL WV_WHISPER_DEVICE WV_WHISPER_COMPUTE
export VA_OUTPUT_DIR VA_FPS VA_DELETE_SOURCE
export VA_PROFILE_PATH VA_TRACKER_PATH VA_ROLES_DIR VA_ASSIST_LOG_DIR
export VA_TRANSCRIBER_TOOLS VA_ASSIST_TOOLS

# ---------------------------------------------------------------------------------------------
# 6. transparency surface
# ---------------------------------------------------------------------------------------------

_WV_ALL_KEYS="WV_PYTHON WV_FFMPEG WV_FFPROBE WV_WORK_DIR WV_RECORDINGS_DIR WV_TRANSCRIPT_DIR WV_WHISPER_MODEL WV_WHISPER_DEVICE WV_WHISPER_COMPUTE VA_OUTPUT_DIR VA_FPS VA_DELETE_SOURCE VA_PROFILE_PATH VA_TRACKER_PATH VA_ROLES_DIR VA_ASSIST_LOG_DIR VA_TRANSCRIBER_TOOLS VA_ASSIST_TOOLS"

wv_config_dump() {
  echo "=== video-autopsy resolved configuration ==="
  if [ -n "${WV_CONFIG_FILE:-}" ]; then
    echo "config file : $WV_CONFIG_FILE"
  else
    echo "config file : (none found -- using environment / auto-detect / defaults only)"
  fi
  if [ -n "${WV_CONFIG_NOTE:-}" ]; then
    echo "note        : $WV_CONFIG_NOTE"
  fi
  local k v s display
  for k in $_WV_ALL_KEYS; do
    eval "v=\"\${${k}:-}\""
    eval "s=\"\${${k}_SOURCE:-unknown}\""
    display="$v"
    [ -z "$display" ] && display="(not set)"
    printf '  %-22s %-43s [%s]\n' "$k" "$display" "$s"
  done
  echo "source key: env=environment variable, config=config file, detect=auto-detected on this machine, default=built-in fallback"
  echo "VA_* keys marked (not set) are optional: the autopsy runs without them and reports what it could not do."
}
