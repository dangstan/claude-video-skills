#!/usr/bin/env bash
# video-autopsy cleanup.
#
# Removes the scratch surface a run creates. Callable on ANY terminal state -- success, failure,
# or interruption -- which is the point: the skill's own clean phase only runs after deliverables
# are written, so a run that dies midway would otherwise leave its frames behind forever. A
# an autopsy extraction runs at 5 fps or higher and can orphan tens of gigabytes.
#
# It NEVER touches the output directory, and never touches an input the pipeline did not create.
#
# Usage:
#   bash cleanup.sh <slug>                 # remove this run's scratch
#   bash cleanup.sh <slug> --keep-video    # keep a downloaded video copy, remove everything else
#   bash cleanup.sh <slug> --dry-run       # print what would be removed, remove nothing
#   bash cleanup.sh --stale [DAYS]         # list orphaned scratch older than DAYS (default 1)
#   bash cleanup.sh --stale [DAYS] --force # ...and remove it

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# shellcheck source=lib/config.sh
source "$SCRIPT_DIR/lib/config.sh" >/dev/null 2>&1 || true
# Default must match SKILL.md's documented default. A bare-/tmp default here is exactly how
# 8.5 GB of orphaned *_frames dirs accumulated unseen (found 2026-08-30 on a 97%-full disk):
# runs that never exported WV_WORK_DIR scattered scratch where no reaper looked.
WORK="${WV_WORK_DIR:-${TMPDIR:-/tmp}/video-autopsy}"

SLUG=""; KEEP_VIDEO=0; DRY=0; STALE=0; STALE_DAYS=1; FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --keep-video) KEEP_VIDEO=1 ;;
    --dry-run)    DRY=1 ;;
    --force)      FORCE=1 ;;
    --stale)      STALE=1
                  case "${2:-}" in [0-9]*) STALE_DAYS="$2"; shift ;; esac ;;
    -h|--help)    sed -n '2,16p' "$0"; exit 0 ;;
    -*)           echo "unknown argument: $1" >&2; exit 2 ;;
    *)            if [ -z "$SLUG" ]; then SLUG="$1"; else echo "unexpected argument: $1" >&2; exit 2; fi ;;
  esac
  shift 2>/dev/null || break
done

# --------------------------------------------------------------------------- stale-run reaper
if [ "$STALE" = "1" ]; then
  echo "=== scratch in $WORK older than ${STALE_DAYS} day(s) ==="
  FOUND=0
  LEGACY="${TMPDIR:-/tmp}"
  SCAN=("$WORK"/*_frames "$WORK"/*_audio.wav)
  # Legacy sweep: pre-2026-08-30 runs wrote scratch to bare /tmp; keep reaping there too.
  [ "$LEGACY" != "$WORK" ] && SCAN+=("$LEGACY"/*_frames "$LEGACY"/*_audio.wav)
  for d in "${SCAN[@]}"; do
    [ -e "$d" ] || continue
    if [ -n "$(find "$d" -maxdepth 0 -mtime "+${STALE_DAYS}" 2>/dev/null)" ]; then
      SZ="$(du -sh "$d" 2>/dev/null | cut -f1)"
      echo "  ${SZ:-?}  $d"
      FOUND=$((FOUND+1))
      [ "$FORCE" = "1" ] && rm -rf -- "$d" && echo "        removed"
    fi
  done
  [ "$FOUND" = "0" ] && echo "  none"
  [ "$FORCE" = "0" ] && [ "$FOUND" != "0" ] && echo "(re-run with --force to remove)"
  exit 0
fi

# --------------------------------------------------------------------------- guards
# An empty or malformed slug would expand the globs below to the whole work directory. This is the
# difference between deleting one run's frames and deleting everything in /tmp. Refuse loudly.
if [ -z "$SLUG" ]; then
  echo "FAIL  no slug given. Refusing to glob the whole work directory." >&2
  echo "      usage: bash cleanup.sh <slug> [--keep-video] [--dry-run]  |  --stale [DAYS] [--force]" >&2
  exit 2
fi
case "$SLUG" in
  */*|*..*|.|..|"*"|"?"*)
    echo "FAIL  slug must be a bare name with no path separators or glob characters: '$SLUG'" >&2
    exit 2 ;;
esac
if [ "${#SLUG}" -lt 3 ]; then
  echo "FAIL  slug '$SLUG' is too short to be safe as a glob prefix (minimum 3 characters)." >&2
  exit 2
fi

# --------------------------------------------------------------------------- collect targets
TARGETS=""
add() {
  [ -e "$1" ] || return 0
  # a path can be matched by both an explicit name and a glob below; list it once
  case "$TARGETS" in *"
$1
"*|"$1
"*) return 0 ;; esac
  TARGETS="$TARGETS
$1
"
}

for p in "$WORK/${SLUG}_frames" "$WORK/${SLUG}_audio.wav" "$WORK/transcribe_${SLUG}.py" \
         "$WORK/parse_vtt_${SLUG}.py" "$WORK/${SLUG}_transcript.txt"; do add "$p"; done
for p in "$WORK/${SLUG}"*.vtt "$WORK/${SLUG}"*.srt "$WORK/${SLUG}"*.part "$WORK/${SLUG}"*.temp.mp4 \
         "$WORK/${SLUG}"*_cut*.wav "$WORK"/*_"${SLUG}".py; do add "$p"; done
# Catch-all for any other slug-prefixed scratch this run wrote (segment dumps, metric json,
# intermediate text). The explicit list above documents the known surface; this sweeps whatever a
# future step adds, so the verification below cannot fail on a file nobody remembered to list.
for p in "$WORK/${SLUG}"_*; do
  case "$p" in *_frames) continue ;; esac      # already added above, keeps the listing tidy
  add "$p"
done

if [ "$KEEP_VIDEO" = "0" ]; then
  for p in "$WORK/${SLUG}"*.mp4 "$WORK/${SLUG}"*.webm "$WORK/${SLUG}"*.mkv; do add "$p"; done
fi

if [ -z "$TARGETS" ]; then
  echo "nothing to clean for slug '$SLUG' in $WORK"
  exit 0
fi

echo "=== cleanup for '$SLUG' in $WORK ==="
TOTAL="$(du -shc $(echo "$TARGETS" | tr '\n' ' ') 2>/dev/null | tail -1 | cut -f1)"
echo "$TARGETS" | sed '/^$/d' | sed 's/^/  /'
echo "  (total: ${TOTAL:-unknown})"

if [ "$DRY" = "1" ]; then
  echo "dry run -- nothing removed"
  exit 0
fi

echo "$TARGETS" | sed '/^$/d' | while IFS= read -r p; do rm -rf -- "$p"; done

# --------------------------------------------------------------------------- verify it worked
# A cleanup that silently failed reads exactly like one that succeeded. Check.
LEFT=0
for p in "$WORK/${SLUG}"*; do [ -e "$p" ] && { echo "REMAIN  $p"; LEFT=$((LEFT+1)); }; done
if [ "$LEFT" -gt 0 ]; then
  if [ "$KEEP_VIDEO" = "1" ]; then
    echo "=== $LEFT item(s) remain (expected: --keep-video was passed) ==="
    exit 0
  fi
  echo "=== FAIL: $LEFT item(s) still present after cleanup ===" >&2
  exit 1
fi
echo "=== clean: no scratch remains for '$SLUG' ==="

# A live extractor or whisper job will recreate what was just deleted. Match by pattern, but
# EXCLUDE this script, its shell, and its parent: the slug is in our own command line, so a naive
# `pgrep -f "$SLUG"` always matches itself and reports a false positive every single run.
if command -v pgrep >/dev/null 2>&1; then
  SELF_PIDS=" $$ ${PPID:-0} "
  HITS=""
  while IFS= read -r line; do
    pid="${line%% *}"
    case "$SELF_PIDS" in *" $pid "*) continue ;; esac
    case "$line" in *cleanup.sh*) continue ;; esac
    HITS="$HITS$line
"
  done <<EOF
$(pgrep -fa "$SLUG" 2>/dev/null)
EOF
  if [ -n "$(echo "$HITS" | tr -d '[:space:]')" ]; then
    echo "WARN  a process referencing '$SLUG' is still running -- it may recreate scratch files:" >&2
    echo "$HITS" | sed '/^$/d' | cut -c1-120 >&2
  fi
fi
exit 0
