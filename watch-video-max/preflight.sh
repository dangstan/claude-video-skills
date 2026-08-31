#!/usr/bin/env bash
# watch-video-max preflight gate.
#
# Run this BEFORE any download, frame extraction, or audio extraction. Every dependency the
# pipeline needs is checked here, at second zero, while nothing has been spent yet. The whole
# point is that a missing package fails NOW instead of after ffmpeg has written gigabytes of
# frames and the first whisper import dies.
#
# FAIL LOUD: any hard requirement that is missing exits non-zero and prints the exact remedy.
# This script NEVER installs anything -- see the REMEDY notes below and README.md for why.
#
# This package runs ONE pipeline at ONE depth. The two-lens machinery (KNOWLEDGE / FORENSICS) and
# the --transcript flag were removed on 2026-08-30: forensics moved out whole into `video-autopsy`,
# and with it the transcript resolution ladder that made whisper optional. This package always
# transcribes verbatim, so faster-whisper is a HARD requirement here with no conditional path.
#
# Usage:
#   bash preflight.sh                # local file input
#   bash preflight.sh --url          # URL input (also checks yt-dlp + a JS runtime)
#   bash preflight.sh --fps 10       # override the frame rate for THIS run only
#
# Portability notes: this script avoids GNU-only flags (no `df -Pm`, no `readlink -f`, no
# `grep -P`) so it runs unmodified on macOS/BSD as well as Linux.

set -uo pipefail

usage() {
  echo "usage: bash preflight.sh [--url] [--fps N]" >&2
}

URL_INPUT=""
FPS_OVERRIDE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --url)          URL_INPUT="--url" ;;
    --fps)          shift; FPS_OVERRIDE="${1:-}" ;;
    --fps=*)        FPS_OVERRIDE="${1#--fps=}" ;;
    --knowledge|--forensics)
      echo "FAIL  $1 is no longer a flag. This package has one depth and one output set." >&2
      echo "      For behavioural/technical forensics on a recording of people talking or" >&2
      echo "      sharing a screen, use the sibling package: video-autopsy." >&2
      exit 2 ;;
    --transcript|--transcript=*)
      echo "FAIL  --transcript is no longer a flag. This package always transcribes verbatim." >&2
      echo "      To reuse a transcript you already have, use the sibling package: watch-video." >&2
      exit 2 ;;
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
  WV_MAX_FPS="$FPS_OVERRIDE"
  export WV_MAX_FPS
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

echo "=== watch-video-max preflight ==="
wv_config_dump
echo ""
echo "=== checks ==="

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
# python is ALWAYS needed here: this package always runs whisper, so there is no path on which
# the interpreter is merely informational.
PYTHON_OK=0
if command -v "$WV_PYTHON" >/dev/null 2>&1 && "$WV_PYTHON" -V >/dev/null 2>&1; then
  ok "python: $WV_PYTHON ($("$WV_PYTHON" -V 2>&1))"
  PYTHON_OK=1
else
  fail "python interpreter not runnable (resolved: '$WV_PYTHON')" \
       "install python3, or set WV_PYTHON / the 'python' config key to a valid interpreter path"
fi

# ---------------------------------------------------------------- transcription stack
# faster-whisper is REQUIRED, unconditionally. This package's transcript of record is the verbatim
# whisper pass; there is no caption tier and no supplied-transcript tier to fall back to, so a
# missing faster_whisper is a hard stop rather than a downgrade.
if [ "$PYTHON_OK" = "1" ]; then
  FW_VER="$("$WV_PYTHON" -c 'import faster_whisper; print(faster_whisper.__version__)' 2>/dev/null)"
  if [ -n "$FW_VER" ]; then
    ok "faster_whisper: $FW_VER (verbatim transcript tier available)"
  else
    fail "faster_whisper NOT importable -- this package REQUIRES it. It always transcribes
      verbatim; there is no caption or supplied-transcript fallback here. If reusing an existing
      transcript is what you actually want, use the sibling package 'watch-video' instead." \
         "$WV_PYTHON -m pip install faster-whisper
      If '$WV_PYTHON' is a shared or managed environment (a system interpreter, a team/production
      environment used for other work, etc.), prefer creating a dedicated virtualenv for
      transcription instead of installing into that interpreter directly -- faster-whisper pulls
      in ctranslate2, tokenizers, and onnxruntime, and can shift other installed package versions."
  fi

  CT_INFO="$("$WV_PYTHON" -c 'import ctranslate2 as c; print(c.__version__, c.get_cuda_device_count())' 2>/dev/null)"
  if [ -n "$CT_INFO" ]; then
    CT_VER="${CT_INFO%% *}"; CUDA_N="${CT_INFO##* }"
    if [ "${CUDA_N:-0}" -ge 1 ] 2>/dev/null; then
      ok "ctranslate2 $CT_VER, CUDA devices: $CUDA_N (GPU tier available)"
    else
      warn "ctranslate2 $CT_VER reports 0 CUDA devices -- transcription falls back to CPU int8,
      which is roughly 20x slower. Confirm this is intended before starting a long job."
    fi
  else
    warn "ctranslate2 not importable -- it ships with faster-whisper; resolve the faster_whisper item above"
  fi
else
  fail "cannot verify faster_whisper -- no runnable python interpreter" \
       "install python3, or set WV_PYTHON / the 'python' config key to a valid interpreter path"
fi

# ---------------------------------------------------------------- GPU headroom
# large-v3 in float16 needs roughly 4.2 GB. Check FREE memory, not total: another job may hold
# the card. nvidia-smi is NOT assumed to exist -- Apple Silicon, AMD, and CPU-only hosts are all
# valid targets for this skill, and its absence is a warning, never a crash.
if command -v nvidia-smi >/dev/null 2>&1; then
  GPU_FREE="$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')"
  GPU_NAME="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)"
  if [ -n "${GPU_FREE:-}" ] && [ "$GPU_FREE" -ge 4500 ] 2>/dev/null; then
    ok "GPU: ${GPU_NAME:-unknown}, ${GPU_FREE} MiB free (>= 4500 MiB preferred for large-v3 float16)"
  else
    warn "GPU: ${GPU_NAME:-unknown}, only ${GPU_FREE:-unknown} MiB free -- large-v3 float16 prefers
      ~4500 MiB free. CPU int8 fallback applies (roughly 20x slower); wait for the card if you
      want the GPU tier instead."
  fi
else
  warn "nvidia-smi not found -- cannot verify GPU headroom (expected on Apple Silicon, AMD, or
      CPU-only hosts). CPU fallback applies."
fi

# ---------------------------------------------------------------- URL tooling
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
# One extraction pass at WV_MAX_FPS. The disk estimate is anchored on the measured 5 fps / 12000
# MiB figure for a 60-minute source and scales linearly from there.
EFF_FPS="${WV_MAX_FPS:-5}"

BASE_FPS=5
BASE_MB=12000
NEED_MB="$(awk -v b="$BASE_MB" -v cf="$EFF_FPS" -v bf="$BASE_FPS" \
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
      source at ${EFF_FPS} fps)"
else
  fail "work_dir ($WV_WORK_DIR) has only ${FREE_MB} MiB free; ${EFF_FPS} fps needs an estimated
      ~${NEED_MB} MiB for a 60-minute source" \
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
