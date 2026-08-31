#!/usr/bin/env bash
# watch-video preflight gate.
#
# Run this BEFORE any download, frame extraction, or transcription. Every dependency the
# pipeline needs is checked here, at second zero, while nothing has been spent yet. The whole
# point is that a missing package fails NOW instead of after ffmpeg has written gigabytes of
# frames and the first whisper import dies.
#
# FAIL LOUD: any hard requirement that is missing exits non-zero and prints the exact remedy.
# This script NEVER installs anything -- see the "no auto-install" section in README.md for why.
#
# Usage:
#   bash preflight.sh                              # local-file input, default fps
#   bash preflight.sh --url                         # URL input (also checks yt-dlp + a JS runtime)
#   bash preflight.sh --fps 2                       # override the frame rate for THIS run only
#   bash preflight.sh --transcript /path/to/t.vtt   # a transcript is already in hand (Tier A) --
#                                                    # this changes the faster_whisper verdict below
#
# This package has ONE mode (learn / understand-the-video) -- there is no {learn|forensics}
# positional the way the heavier sibling package (watch-video-max) has, because the forensics head
# does not exist here. Every argument is an optional flag.
#
# faster-whisper transcription is the LAST RESORT in this package (see the transcript resolution
# ladder in SKILL.md: a supplied transcript, a sidecar transcript, or platform captions are all
# tried first). This gate reflects that: whisper is skipped entirely when a transcript is
# supplied at the command line, is only a WARN when platform captions remain possible, and is
# FATAL only when the run has no transcript, no supplied path, and no caption source at all.
#
# Portability notes: this script avoids GNU-only flags (no `df -Pm`, no `readlink -f`, no
# `grep -P`) so it runs unmodified on macOS/BSD as well as Linux.

set -uo pipefail

URL_INPUT=""
FPS_OVERRIDE=""
TRANSCRIPT_PATH=""

usage() {
  echo "usage: bash preflight.sh [--url] [--fps N] [--transcript <path>]" >&2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --url)          URL_INPUT="--url" ;;
    --fps)          shift; FPS_OVERRIDE="${1:-}" ;;
    --fps=*)        FPS_OVERRIDE="${1#--fps=}" ;;
    --transcript)   shift; TRANSCRIPT_PATH="${1:-}" ;;
    --transcript=*) TRANSCRIPT_PATH="${1#--transcript=}" ;;
    -h|--help)      usage; exit 0 ;;
    *) echo "unknown argument: $1" >&2; usage; exit 2 ;;
  esac
  shift 2>/dev/null || break
done

# A per-invocation --fps beats config and env for THIS run only. Validate it: a non-numeric or
# zero value silently disabling frame extraction would be far worse than refusing here.
if [ -n "$FPS_OVERRIDE" ]; then
  if ! echo "$FPS_OVERRIDE" | grep -Eq '^[0-9]+(\.[0-9]+)?$' \
     || [ "$(awk -v v="$FPS_OVERRIDE" 'BEGIN{print (v>0)?1:0}')" -ne 1 ]; then
    echo "FAIL  --fps must be a positive number, got: $FPS_OVERRIDE" >&2
    exit 2
  fi
  WV_KNOWLEDGE_FPS="$FPS_OVERRIDE"
  export WV_KNOWLEDGE_FPS
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# shellcheck source=lib/config.sh
source "$SCRIPT_DIR/lib/config.sh"

FAIL=0
WARN=0

ok()   { printf 'OK    %s\n' "$1"; }
skip() { printf 'SKIP  %s\n' "$1"; }
warn() { printf 'WARN  %s\n' "$1"; WARN=$((WARN+1)); }
fail() { printf 'FAIL  %s\n'   "$1"; printf '      REMEDY: %s\n' "$2"; FAIL=$((FAIL+1)); }

echo "=== watch-video preflight ==="
wv_config_dump
echo ""
echo "=== checks ==="

# ---------------------------------------------------------------- transcript-supplied check
# Tier A of the resolution ladder: a transcript handed in explicitly on the command line. If it
# resolves, whisper (Tier D, the last resort) drops out of this run's requirements entirely.
HAVE_SUPPLIED_TRANSCRIPT=0
if [ -n "$TRANSCRIPT_PATH" ]; then
  if [ -f "$TRANSCRIPT_PATH" ]; then
    case "$TRANSCRIPT_PATH" in
      *.txt|*.srt|*.vtt) ok "transcript supplied: $TRANSCRIPT_PATH (recognized extension)" ;;
      *) warn "transcript supplied: $TRANSCRIPT_PATH -- extension is not .txt/.srt/.vtt; it will
      be read as plain text. Rename or convert it if that is wrong." ;;
    esac
    HAVE_SUPPLIED_TRANSCRIPT=1
  else
    fail "--transcript path does not exist: $TRANSCRIPT_PATH" \
         "pass a real file path, or drop --transcript to fall through to the sidecar / caption / whisper tiers"
  fi
fi

# Whether a .srt/.vtt cue file needs a parser at all (a plain .txt supplied transcript needs
# nothing further from python).
NEEDS_TRANSCRIPT_PARSE=1
if [ "$HAVE_SUPPLIED_TRANSCRIPT" = "1" ]; then
  case "$TRANSCRIPT_PATH" in
    *.txt) NEEDS_TRANSCRIPT_PARSE=0 ;;
    *) NEEDS_TRANSCRIPT_PARSE=1 ;;
  esac
fi

# ---------------------------------------------------------------- media tooling
if command -v "$WV_FFMPEG" >/dev/null 2>&1; then
  ok "ffmpeg: $(command -v "$WV_FFMPEG")"
else
  fail "ffmpeg not found (resolved: '$WV_FFMPEG')" \
       "install ffmpeg (e.g. 'apt install ffmpeg', 'brew install ffmpeg') or set WV_FFMPEG / the 'ffmpeg' config key"
fi

if command -v "$WV_FFPROBE" >/dev/null 2>&1; then
  ok "ffprobe: $(command -v "$WV_FFPROBE")"
else
  fail "ffprobe not found (resolved: '$WV_FFPROBE')" \
       "ffprobe ships with ffmpeg -- install ffmpeg, or set WV_FFPROBE / the 'ffprobe' config key"
fi

# ---------------------------------------------------------------- interpreter
# python is FATAL only when this run will actually need it: to run whisper (Tier D), or to parse
# a .srt/.vtt cue file (supplied, sidecar, or platform-caption). A plain .txt transcript supplied
# via --transcript needs neither, so python becomes merely informational in that one case.
PYTHON_NEEDED=1
if [ "$HAVE_SUPPLIED_TRANSCRIPT" = "1" ] && [ "$NEEDS_TRANSCRIPT_PARSE" = "0" ]; then
  PYTHON_NEEDED=0
fi

PYTHON_OK=0
if command -v "$WV_PYTHON" >/dev/null 2>&1 && "$WV_PYTHON" -V >/dev/null 2>&1; then
  ok "python: $WV_PYTHON ($("$WV_PYTHON" -V 2>&1))"
  PYTHON_OK=1
elif [ "$PYTHON_NEEDED" = "1" ]; then
  fail "python interpreter not runnable (resolved: '$WV_PYTHON')" \
       "install python3, or set WV_PYTHON / the 'python' config key to a valid interpreter path"
else
  skip "python interpreter not runnable (resolved: '$WV_PYTHON') -- not needed for a plain-text
      transcript supplied via --transcript"
fi

# ---------------------------------------------------------------- transcription stack
# faster-whisper is Tier D of the resolution ladder -- the LAST RESORT, tried only after (A) a
# supplied transcript, (B) a sidecar transcript next to the video, and (C) platform captions have
# all come up empty. This gate cannot see the actual video file (no video path is a preflight
# argument -- only --transcript / --url describe the run), so it cannot check for a Tier B
# sidecar itself; it can only know about a Tier A transcript you passed explicitly.
if [ "$HAVE_SUPPLIED_TRANSCRIPT" = "1" ]; then
  skip "faster_whisper: not needed (transcript supplied via --transcript)"
elif [ "$PYTHON_OK" = "1" ]; then
  FW_VER="$("$WV_PYTHON" -c 'import faster_whisper; print(faster_whisper.__version__)' 2>/dev/null)"
  if [ -n "$FW_VER" ]; then
    ok "faster_whisper: $FW_VER"
  else
    REMEDY_FW="$WV_PYTHON -m pip install faster-whisper
      If '$WV_PYTHON' is a shared or managed environment (a system interpreter, a team/production
      environment used for other work, etc.), prefer creating a dedicated virtualenv for
      transcription instead of installing into that interpreter directly -- faster-whisper pulls
      in ctranslate2, tokenizers, and onnxruntime, and can shift other installed package versions."
    if [ "$URL_INPUT" = "--url" ]; then
      warn "faster_whisper NOT importable -- this run can still complete on Tier C platform
      captions (yt-dlp --write-auto-subs) ALONE, with no whisper at all. If the source turns out
      to have no usable caption track, this becomes a hard stop. REMEDY: $REMEDY_FW"
    else
      fail "faster_whisper NOT importable -- a local file has no platform-caption tier (that only
      exists for URL input via yt-dlp), and no --transcript was supplied, so this run has no
      fallback left besides whisper. If the video actually has a sidecar transcript
      (<basename>.txt/.srt/.vtt) sitting next to it, pass it explicitly with --transcript to
      avoid this stop entirely." "$REMEDY_FW"
    fi
  fi

  # GPU path runs through ctranslate2, not torch. Informational: only matters if Tier D actually
  # runs, which is not yet known at preflight time (a sidecar transcript may still make it moot).
  CT_INFO="$("$WV_PYTHON" -c 'import ctranslate2 as c; print(c.__version__, c.get_cuda_device_count())' 2>/dev/null)"
  if [ -n "$CT_INFO" ]; then
    CT_VER="${CT_INFO%% *}"; CUDA_N="${CT_INFO##* }"
    if [ "${CUDA_N:-0}" -ge 1 ] 2>/dev/null; then
      ok "ctranslate2 $CT_VER, CUDA devices: $CUDA_N (GPU tier available if whisper runs)"
    else
      warn "ctranslate2 $CT_VER reports 0 CUDA devices -- if whisper ends up running (last
      resort), it falls back to CPU int8, roughly 20x slower. Confirm this is acceptable before
      relying on Tier D for a long video."
    fi
  else
    warn "ctranslate2 not importable -- it ships with faster-whisper; resolve the faster_whisper
      item above if whisper ends up being needed"
  fi
else
  warn "cannot verify faster_whisper -- no runnable python interpreter to import it with (see the
      python item above)"
fi

# ---------------------------------------------------------------- GPU headroom
# large-v3 in float16 needs roughly 4.2 GB. Check FREE memory, not total: another job may hold
# the card. nvidia-smi is NOT assumed to exist -- Apple Silicon, AMD, and CPU-only hosts are all
# valid targets for this skill, and its absence is a warning, never a crash. Only relevant if
# Tier D (whisper) actually runs.
if command -v nvidia-smi >/dev/null 2>&1; then
  GPU_FREE="$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')"
  GPU_NAME="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)"
  if [ -n "${GPU_FREE:-}" ] && [ "$GPU_FREE" -ge 4500 ] 2>/dev/null; then
    ok "GPU: ${GPU_NAME:-unknown}, ${GPU_FREE} MiB free (>= 4500 MiB preferred for large-v3 float16, if whisper runs)"
  else
    warn "GPU: ${GPU_NAME:-unknown}, only ${GPU_FREE:-unknown} MiB free -- if whisper ends up
      running, large-v3 float16 prefers ~4500 MiB free; CPU int8 fallback applies otherwise
      (roughly 20x slower)."
  fi
else
  warn "nvidia-smi not found -- cannot verify GPU headroom (expected on Apple Silicon, AMD, or
      CPU-only hosts). CPU fallback applies if whisper ends up running."
fi

# ---------------------------------------------------------------- URL tooling
# Needed to fetch the video itself (and, incidentally, platform captions) -- independent of the
# transcript ladder, since even a supplied transcript still needs the video downloaded for frames.
if [ "$URL_INPUT" = "--url" ]; then
  YTDLP_FIRST_WORD="${WV_YTDLP%% *}"
  if [ -n "${WV_YTDLP:-}" ] && { command -v "$YTDLP_FIRST_WORD" >/dev/null 2>&1 || [ -x "$YTDLP_FIRST_WORD" ]; }; then
    ok "yt-dlp: $WV_YTDLP"
  else
    fail "yt-dlp not found (resolved: '${WV_YTDLP:-<empty>}')" \
         "install yt-dlp (e.g. '$WV_PYTHON -m pip install yt-dlp') or set WV_YTDLP / the 'ytdlp' config key"
  fi
  if [ -n "${WV_JS_RUNTIME:-}" ]; then
    ok "JS runtime: $WV_JS_RUNTIME"
  else
    fail "no JS runtime found -- yt-dlp YouTube extraction is deprecated and fails without one" \
         "install deno (https://deno.land) or node, or set WV_JS_RUNTIME / the 'js_runtime' config key"
  fi
fi

# ---------------------------------------------------------------- disk headroom
# Estimate scales with the CONFIGURED fps against a 60-minute-source baseline (1 fps / ~3 GB).
# If knowledge_fps has been changed from the default, the floor scales with it.
BASE_FPS=1; BASE_MB=3000; CONFIGURED_FPS="$WV_KNOWLEDGE_FPS"
NEED_MB="$(awk -v b="$BASE_MB" -v cf="$CONFIGURED_FPS" -v bf="$BASE_FPS" \
  'BEGIN { v = b * cf / bf; if (v < 1) v = 1; iv = int(v); if (v != iv) iv += 1; printf "%d", iv }' 2>/dev/null)"
[ -z "${NEED_MB:-}" ] && NEED_MB="$BASE_MB"

DF_TARGET="$WV_WORK_DIR"
if [ ! -d "$DF_TARGET" ]; then
  DF_TARGET="$(dirname "$DF_TARGET")"
  [ -d "$DF_TARGET" ] || DF_TARGET="."
fi
FREE_KB="$(df -Pk "$DF_TARGET" 2>/dev/null | awk 'NR==2 {print $4}')"
FREE_MB=$(( ${FREE_KB:-0} / 1024 ))

if [ "$FREE_MB" -ge "$NEED_MB" ] 2>/dev/null; then
  ok "work_dir ($WV_WORK_DIR) free: ${FREE_MB} MiB (>= ${NEED_MB} MiB estimated for a 60-minute
      source at ${CONFIGURED_FPS} fps)"
else
  fail "work_dir ($WV_WORK_DIR) has only ${FREE_MB} MiB free; ${CONFIGURED_FPS} fps needs an
      estimated ~${NEED_MB} MiB for a 60-minute source" \
       "free space, point WV_WORK_DIR / the 'work_dir' config key at a larger volume, or lower the
      configured fps BEFORE extracting frames"
fi

# ---------------------------------------------------------------- verdict
echo ""
echo "=== preflight: ${FAIL} failure(s), ${WARN} warning(s) ==="
if [ "$FAIL" -gt 0 ]; then
  echo "STOP. Resolve the FAIL items above before spending any compute. Do not start extraction."
  exit 1
fi
if [ "$WARN" -gt 0 ]; then
  echo "PROCEED WITH CARE: warnings above change the plan (tier choice, runtime, or fallback path)."
  echo "State explicitly which fallback you are taking before continuing."
fi
echo "Preflight passed."
exit 0
