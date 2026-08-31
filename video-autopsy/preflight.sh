#!/usr/bin/env bash
# video-autopsy preflight gate.
#
# Run this BEFORE extracting a single frame. An autopsy extracts at 5 fps minimum and transcribes
# at the verbatim tier, so a missing dependency discovered late costs a full re-ingest of a
# recording that may be an hour long. Everything the run needs is checked here, at second zero.
#
# FAIL LOUD: any hard requirement that is missing exits non-zero and prints the exact remedy.
# This script NEVER installs anything -- see README.md for why that is deliberate.
#
# This package does ONE thing, so there are no lens flags and no URL path. An interview recording
# is a local file produced by a recorder you control.
#
# Usage:
#   bash preflight.sh                          # check the newest recording in IA/WV_RECORDINGS_DIR
#   bash preflight.sh --file /path/to/rec.mp4  # check a specific recording
#   bash preflight.sh --fps 10                 # override the frame rate for THIS run only
#
# Portability: avoids GNU-only flags (no `df -Pm`, no `readlink -f`, no `grep -P`) so it runs
# unmodified on macOS/BSD as well as Linux.

set -u

usage() {
  sed -n '2,21p' "$0" | sed 's/^# \{0,1\}//'
}

REC_FILE=""
FPS_OVERRIDE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --file)       REC_FILE="${2:-}"; shift 2 ;;
    --fps)        FPS_OVERRIDE="${2:-}"; shift 2 ;;
    -h|--help)    usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n\n' "$1"; usage; exit 2 ;;
  esac
done

# A per-invocation --fps beats config and env for THIS run only. Validate it: a non-numeric or
# zero value silently disabling frame extraction would be worse than refusing here.
if [ -n "$FPS_OVERRIDE" ]; then
  case "$FPS_OVERRIDE" in
    ''|*[!0-9.]*) printf 'FAIL  --fps must be a positive number, got: %s\n' "$FPS_OVERRIDE"; exit 2 ;;
  esac
  if [ "$(awk -v v="$FPS_OVERRIDE" 'BEGIN{print (v>0)?1:0}')" != "1" ]; then
    printf 'FAIL  --fps must be greater than zero, got: %s\n' "$FPS_OVERRIDE"; exit 2
  fi
  VA_FPS="$FPS_OVERRIDE"
  export VA_FPS
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/config.sh
. "$SCRIPT_DIR/lib/config.sh"

echo "=== video-autopsy preflight ==="
wv_config_dump
echo
echo "=== checks ==="

FAIL=0
WARN=0
ok()   { printf 'OK    %s\n' "$1"; }
warn() { printf 'WARN  %s\n' "$1"; WARN=$((WARN+1)); }
fail() { printf 'FAIL  %s\n' "$1"; printf '      REMEDY: %s\n' "$2"; FAIL=$((FAIL+1)); }
note() { printf '      %s\n' "$1"; }

# ---------------------------------------------------------------------------------------------
# 1. the ingest toolchain
# ---------------------------------------------------------------------------------------------

if command -v "$WV_FFMPEG" >/dev/null 2>&1 || [ -x "$WV_FFMPEG" ]; then
  ok "ffmpeg: $WV_FFMPEG"
else
  fail "ffmpeg not found at: $WV_FFMPEG" \
       "install ffmpeg, or set WV_FFMPEG / the \"ffmpeg\" config key to its path"
fi

if command -v "$WV_FFPROBE" >/dev/null 2>&1 || [ -x "$WV_FFPROBE" ]; then
  ok "ffprobe: $WV_FFPROBE"
else
  fail "ffprobe not found at: $WV_FFPROBE" \
       "install ffmpeg (ffprobe ships with it), or set WV_FFPROBE / the \"ffprobe\" config key"
fi

PY_OK=0
if $WV_PYTHON -c 'import sys' >/dev/null 2>&1; then
  PY_VER="$($WV_PYTHON -c 'import sys;print("Python %d.%d.%d"%sys.version_info[:3])' 2>/dev/null)"
  ok "python: $WV_PYTHON ($PY_VER)"
  PY_OK=1
else
  fail "python not usable at: $WV_PYTHON" \
       "set WV_PYTHON / the \"python\" config key to an interpreter that has faster-whisper"
fi

# ---------------------------------------------------------------------------------------------
# 2. the verbatim transcript tier -- REQUIRED, not optional
# ---------------------------------------------------------------------------------------------
#
# There is no supplied-transcript escape hatch in this package, and that is a deliberate
# difference from its siblings. Disfluency counts need the "um" and "uh" that every cleaned-up
# transcript strips, and the behavioural read needs per-segment timestamps precise enough to
# measure pause length. A platform export or a tidied transcript silently invalidates both while
# looking perfectly usable. So whisper is a hard requirement here.

if [ "$PY_OK" = "1" ]; then
  if $WV_PYTHON -c 'import faster_whisper' >/dev/null 2>&1; then
    FW_VER="$($WV_PYTHON -c 'import faster_whisper as f;print(getattr(f,"__version__","?"))' 2>/dev/null)"
    ok "faster_whisper: $FW_VER (verbatim tier available)"
  else
    fail "faster_whisper not importable on $WV_PYTHON" \
         "$WV_PYTHON -m pip install faster-whisper"
    note "BLAST RADIUS: this pulls ctranslate2, tokenizers and onnxruntime. If that interpreter"
    note "is shared with other work, install into a dedicated environment and point WV_PYTHON at it."
    note "This package will NOT install it for you, by design."
    note "There is no fallback: a supplied or platform transcript does NOT satisfy this package."
  fi

  if $WV_PYTHON -c 'import ctranslate2' >/dev/null 2>&1; then
    CT_VER="$($WV_PYTHON -c 'import ctranslate2 as c;print(getattr(c,"__version__","?"))' 2>/dev/null)"
    NDEV="$($WV_PYTHON -c 'import ctranslate2 as c;print(c.get_cuda_device_count())' 2>/dev/null || echo 0)"
    if [ "${NDEV:-0}" -gt 0 ] 2>/dev/null; then
      ok "ctranslate2 $CT_VER, CUDA devices: $NDEV (GPU tier available)"
    else
      warn "ctranslate2 $CT_VER present but no CUDA device visible -- CPU int8 fallback"
      note "A one-hour interview on CPU int8 runs roughly 20x slower than on a GPU."
      note "Set expectations before starting, and never run two whisper jobs in parallel."
    fi
  else
    warn "ctranslate2 not importable -- whisper will fall back to whatever backend it finds"
  fi
fi

# GPU headroom. nvidia-smi is NOT assumed to exist: Apple Silicon, AMD and CPU-only hosts are all
# valid targets, so its absence is informational, never a crash.
if command -v nvidia-smi >/dev/null 2>&1; then
  GPU_NAME="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)"
  GPU_FREE="$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits 2>/dev/null | head -1)"
  if [ -n "${GPU_FREE:-}" ]; then
    if [ "$GPU_FREE" -ge 4500 ] 2>/dev/null; then
      ok "GPU: $GPU_NAME, ${GPU_FREE} MiB free (>= 4500 MiB preferred for large-v3 float16)"
    else
      warn "GPU: $GPU_NAME, only ${GPU_FREE} MiB free (large-v3 float16 wants ~4200 MiB)"
      note "Free the card or accept the CPU path. Do NOT run two whisper jobs to work around this."
    fi
  fi
else
  note "nvidia-smi not present -- skipping GPU headroom check (fine on non-NVIDIA hosts)"
fi

# ---------------------------------------------------------------------------------------------
# 3. the shared ingest mechanism lives in the sibling package
# ---------------------------------------------------------------------------------------------
#
# This package composes on watch-video-max rather than forking it. The guided read, the frame
# escalation tiers, the contact-sheet and crop techniques, the screen-share metrics and the HTML
# design direction are defined ONCE there and referenced here. If it is missing, this skill can
# still run -- SKILL.md and references/evaluation.md carry the analysis in full -- but it loses the
# ingest mechanism it was written against, so say so loudly rather than degrading in silence.

WVMAX_DIR=""
for cand in \
  "${VA_WVMAX_DIR:-}" \
  "$SCRIPT_DIR/../watch-video-max" \
  "$HOME/.claude/skills/watch-video-max" \
  "$HOME/.config/claude/skills/watch-video-max"
do
  [ -n "$cand" ] && [ -f "$cand/SKILL.md" ] && { WVMAX_DIR="$cand"; break; }
done

if [ -n "$WVMAX_DIR" ]; then
  ok "watch-video-max found: $WVMAX_DIR"
  # NOTE: this used to also check for $WVMAX_DIR/references/forensics.md. That file was DELETED on
  # 2026-08-30 when the forensics lens moved into THIS package -- the behavioural mechanism now
  # lives in references/evaluation.md here, which is checked below. Do not re-add the old check: it
  # would warn on every single run forever, against a file that is never coming back.
else
  warn "watch-video-max not found -- the shared ingest mechanism is unavailable"
  note "Looked in: \$VA_WVMAX_DIR, ../watch-video-max, ~/.claude/skills/watch-video-max"
  note "This package defines the behavioural analysis itself and can proceed, but the guided read,"
  note "frame-escalation tiers and HTML design direction it cites live in that package."
  note "Install it, or set VA_WVMAX_DIR to its path."
fi

# This package's OWN reference files. The behavioural mechanism moved here from watch-video-max on
# 2026-08-30, so these are load-bearing rather than supplementary: without evaluation.md there is no
# metric-pass definition, no red-pixel control and no report contract, and a run would silently
# produce a shallower pass that still looks like a finished report.
for ref in evaluation pitfalls; do
  if [ -f "$SCRIPT_DIR/references/$ref.md" ]; then
    ok "references/$ref.md present"
  else
    fail "references/$ref.md MISSING from this package ($SCRIPT_DIR/references/)" \
         "restore it from the package source -- evaluation.md defines the metric passes, the screen
      forensics and the report contract; pitfalls.md carries the measurement traps. A run without
      them produces a shallower pass that still reads like a finished report."
  fi
done

# ---------------------------------------------------------------------------------------------
# 4. the recording
# ---------------------------------------------------------------------------------------------

if [ -z "$REC_FILE" ]; then
  if [ -d "$WV_RECORDINGS_DIR" ]; then
    REC_FILE="$(ls -1t "$WV_RECORDINGS_DIR"/*.mp4 "$WV_RECORDINGS_DIR"/*.mkv "$WV_RECORDINGS_DIR"/*.webm 2>/dev/null | head -1)"
    if [ -n "$REC_FILE" ]; then
      ok "newest recording: $REC_FILE"
      # CONFIRM THE MTIME. Picking "newest in directory" silently analyses the wrong session when
      # the expected recording failed to save -- which reads exactly like a successful run.
      MT="$(ls -l "$REC_FILE" 2>/dev/null | awk '{print $6, $7, $8}')"
      note "modified: $MT -- CONFIRM this matches the session you mean to review before proceeding."
    else
      warn "no .mp4/.mkv/.webm found in $WV_RECORDINGS_DIR"
      note "Pass --file explicitly, or set WV_RECORDINGS_DIR / the \"recordings_dir\" config key."
    fi
  else
    warn "recordings dir does not exist: $WV_RECORDINGS_DIR"
    note "Pass --file explicitly, or set WV_RECORDINGS_DIR / the \"recordings_dir\" config key."
  fi
fi

if [ -n "$REC_FILE" ] && [ -f "$REC_FILE" ]; then
  if command -v "$WV_FFPROBE" >/dev/null 2>&1 || [ -x "$WV_FFPROBE" ]; then
    DUR="$("$WV_FFPROBE" -v error -show_entries format=duration -of csv=p=0 "$REC_FILE" 2>/dev/null | cut -d. -f1)"
    if [ -n "${DUR:-}" ] && [ "$DUR" -gt 0 ] 2>/dev/null; then
      ok "readable, duration: $((DUR/60))m $((DUR%60))s"
    else
      fail "ffprobe could not read a duration from: $REC_FILE" \
           "check the file is a complete recording, not a zero-byte or in-progress capture"
    fi

    # AUDIO CAPTURE CHECK, before any talk-time number is ever computed. A recorder configured
    # with the wrong source produces a file that plays fine and is missing half the conversation;
    # a naive word count then reports the wrong speaker as dominant. This check is cheap and it
    # has caught real failures.
    NCH="$("$WV_FFPROBE" -v error -select_streams a:0 -show_entries stream=channels -of csv=p=0 "$REC_FILE" 2>/dev/null)"
    if [ -z "${NCH:-}" ]; then
      fail "no audio stream in: $REC_FILE" \
           "an autopsy without audio can only be reconstructed from on-screen captions -- see SKILL.md"
    else
      ok "audio stream present: ${NCH} channel(s)"
      [ "${NCH:-1}" -gt 1 ] 2>/dev/null && \
        note "MULTI-CHANNEL: measure per-channel RMS and correlation BEFORE any downmix (SKILL.md)."
      note "Run the volumedetect/astats capture check in SKILL.md before computing any talk-time."
    fi
  fi
fi

# ---------------------------------------------------------------------------------------------
# 5. the evaluation layer -- optional, but say what will be missing
# ---------------------------------------------------------------------------------------------
#
# None of these are fatal. The point of naming them is that their absence changes the REPORT: an
# autopsy with no profile cannot report a trend, and one with no roles dir cannot check claims
# against what was said in earlier rounds. Better to know that now than to read a report that
# quietly omitted half its job.

if [ -n "$VA_PROFILE_PATH" ] && [ -f "$VA_PROFILE_PATH" ]; then
  ok "operator profile: $VA_PROFILE_PATH"
else
  warn "no operator profile configured (VA_PROFILE_PATH / \"profile_path\")"
  note "Without it there is no cross-round baseline: the report can describe THIS round but"
  note "cannot promote a pattern to confirmed, and must say so rather than implying a trend."
fi

if [ -n "$VA_ROLES_DIR" ] && [ -d "$VA_ROLES_DIR" ]; then
  ok "roles dir: $VA_ROLES_DIR"
else
  warn "no roles dir configured (VA_ROLES_DIR / \"roles_dir\") -- no claims-ledger check possible"
fi

if [ -n "$VA_TRACKER_PATH" ] && [ -f "$VA_TRACKER_PATH" ]; then
  ok "tracker: $VA_TRACKER_PATH"
else
  note "no tracker configured (VA_TRACKER_PATH) -- the tracker update step will be skipped"
fi

if [ -n "$WV_TRANSCRIPT_DIR" ] && [ -d "$WV_TRANSCRIPT_DIR" ]; then
  NT="$(ls -1t "$WV_TRANSCRIPT_DIR" 2>/dev/null | head -1)"
  ok "platform-transcript dir: $WV_TRANSCRIPT_DIR (newest: ${NT:-none})"
  note "A speaker-SEPARATED export here gives attribution and keeps fillers whisper's VAD strips."
  note "Its ABSENCE is expected for some platforms and is not a missing input."
else
  note "no platform-transcript dir configured -- attribution will come from content + frames"
fi

if [ -z "$VA_ASSIST_TOOLS" ] && [ -z "$VA_TRANSCRIBER_TOOLS" ]; then
  warn "no tool names configured (VA_ASSIST_TOOLS / VA_TRANSCRIBER_TOOLS)"
  note "SKILL.md requires asking which tools were running BY NAME before any assist analysis."
  note "With no names configured you must ask the open question, which is measurably worse:"
  note "\"was anything on?\" has produced a false finding by conflating a transcriber with an"
  note "answer generator. List your tools in the config so the question can be specific."
fi

# ---------------------------------------------------------------------------------------------
# 6. disk headroom at the effective frame rate
# ---------------------------------------------------------------------------------------------

mkdir -p "$WV_WORK_DIR" 2>/dev/null
if [ -d "$WV_WORK_DIR" ]; then
  FREE_MB="$(df -m "$WV_WORK_DIR" 2>/dev/null | awk 'NR==2 {print $4}')"
  # Anchor: 5 fps against a 60-minute source is ~12000 MiB measured. Scale linearly with fps, and
  # with the actual duration when we know it.
  MINUTES=60
  [ -n "${DUR:-}" ] && [ "${DUR:-0}" -gt 0 ] 2>/dev/null && MINUTES=$(( (DUR + 59) / 60 ))
  NEED="$(awk -v f="${VA_FPS:-5}" -v m="$MINUTES" 'BEGIN{printf "%d", (12000/5)*f*(m/60)}')"
  [ "${NEED:-0}" -lt 500 ] 2>/dev/null && NEED=500
  if [ -n "${FREE_MB:-}" ] && [ "$FREE_MB" -ge "$NEED" ] 2>/dev/null; then
    ok "work_dir ($WV_WORK_DIR) free: ${FREE_MB} MiB (>= ${NEED} MiB estimated for ${MINUTES}min at ${VA_FPS} fps)"
  else
    fail "work_dir ($WV_WORK_DIR) free: ${FREE_MB:-unknown} MiB, need ~${NEED} MiB at ${VA_FPS} fps" \
         "free space, set WV_WORK_DIR to a bigger volume, or lower --fps (and label frame-derived findings DEGRADED)"
  fi
fi

# ---------------------------------------------------------------------------------------------
# 7. verdict
# ---------------------------------------------------------------------------------------------

echo
echo "=== preflight: $FAIL failure(s), $WARN warning(s) ==="
if [ "$FAIL" -gt 0 ]; then
  echo "STOP. Fix the failures above before extracting anything."
  exit 1
fi
if [ "$WARN" -gt 0 ]; then
  echo "Preflight passed with warnings. Each warning above narrows what the report can claim --"
  echo "carry them into the report's limitations section rather than letting them disappear here."
  exit 0
fi
echo "Preflight passed."
exit 0
