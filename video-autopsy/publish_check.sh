#!/usr/bin/env bash
# publish_check.sh -- the PUBLICATION gate, executable.
#
# The ordered gate lives in SKILL.md under PUBLICATION: partition by SOURCE, then scrub
# identifiers, then verify, on every derived surface. This script is step 3 -- the verification --
# and nothing else. It cannot tell you that step 1 was done well; it can only refuse a copy where
# step 1 or step 2 demonstrably was not.
#
# It exists because the prose version of this gate was believed to have been run twice, and twice a
# private record reached a published copy anyway.
#
# Usage:
#   publish_check.sh <published-dir> [--source private|published] [--private-term STR]...
#   publish_check.sh --self-test
#
# Exit codes: 0 clean | 1 at least one FAIL | 2 usage/environment error
#
# WARN never blocks, but every WARN is a line a human still has to read.

VERSION="1.0"

usage() {
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

# ---------------------------------------------------------------------------
# checks
# ---------------------------------------------------------------------------
# Each check is (NAME, SEVERITY, DESCRIPTION, matcher). One check per failure mode: a shared
# matcher lets an earlier check shadow a later one, and then the message names the wrong cause.

FAILCOUNT=0
WARNCOUNT=0
SCANNED=0

report() { # severity name detail
  local sev="$1" name="$2" detail="$3"
  printf '%s %-28s %s\n' "$sev" "$name" "$detail"
  case "$sev" in
    FAIL) FAILCOUNT=$((FAILCOUNT + 1)) ;;
    WARN) WARNCOUNT=$((WARNCOUNT + 1)) ;;
  esac
}

# grep_check NAME SEVERITY PATTERN DESCRIPTION
# Uses -P so the patterns mean what they look like. Text files only; binaries are skipped by -I.
grep_check() {
  local name="$1" sev="$2" pat="$3" desc="$4"
  local hits
  hits=$(grep -rInP -- "$pat" "$DIR" 2>/dev/null)
  if [ -n "$hits" ]; then
    report "$sev" "$name" "$desc"
    printf '%s\n' "$hits" | head -8 | sed 's/^/      /'
    local n
    n=$(printf '%s\n' "$hits" | wc -l)
    [ "$n" -gt 8 ] && printf '      ... %s more\n' "$((n - 8))"
    return 1
  fi
  return 0
}

run_checks() {
  FAILCOUNT=0; WARNCOUNT=0
  SCANNED=$(find "$DIR" -type f \( -name '*.md' -o -name '*.html' -o -name '*.txt' -o -name '*.json' \) 2>/dev/null | wc -l)

  # --- step-1 residue: the partition did not happen, or happened in one surface only ----------
  grep_check external-record-tag FAIL \
    '\[EXTERNAL-RECORD' \
    'an [EXTERNAL-RECORD] tag survived -- a stripped section leaves no tags behind'
  grep_check external-record-marker FAIL \
    'SOURCE:\s*EXTERNAL-RECORD' \
    'a standing source-marker line survived -- that section should be gone or a declared shell'

  # --- step-2 residue: identifiers -------------------------------------------------------------
  grep_check absolute-home-path FAIL \
    '(/home/|/Users/|/mnt/|/media/)[A-Za-z0-9._-]+/' \
    'an absolute path into somebody home directory survived the scrub'
  grep_check tilde-path FAIL \
    '~/[A-Za-z0-9._-]+/' \
    'a shell-abbreviated private path survived the scrub'

  local term
  for term in "${PRIVATE_TERMS[@]}"; do
    [ -z "$term" ] && continue
    grep_check "private-term" FAIL \
      "$(printf '%s' "$term" | sed 's/[][\\.^$*+?(){}|]/\\&/g')" \
      "a term declared private survived the scrub: '$term'"
  done

  # --- quasi-identifiers: what grep alone was never going to catch -----------------------------
  # These do not name anybody. They let a counterparty match the document against their own
  # calendar, which is the same disclosure by another route. On a PRIVATE source they FAIL; on a
  # source the world can already watch they are only worth a look.
  local qi_sev="FAIL"
  [ "$SOURCE_KIND" = "published" ] && qi_sev="WARN"

  grep_check wallclock-with-timezone "$qi_sev" \
    '\d{1,2}:\d{2}(:\d{2})?\s*(?:[AP]M\s*)?\b(?:UTC|GMT|BRT|BRST|EST|EDT|CST|CDT|PST|PDT|CET|CEST|WET|ART|COT|[A-Z]{3,4}T)\b' \
    'a wall-clock time with a timezone survived -- this pins the session on a calendar'
  grep_check date-plus-time-to-the-second "$qi_sev" \
    '\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}' \
    'a timestamp resolved to the second survived -- coarsen it or drop it'
  grep_check exact-duration "$qi_sev" \
    '\b\d{1,3}m\d{2}s\b|\bduration[^.\n]{0,20}\d{1,2}:\d{2}:\d{2}' \
    'an exact recording duration survived -- round it, or a calendar entry matches it'
  grep_check calendar-date WARN \
    '\b\d{4}-\d{2}-\d{2}\b' \
    'a full calendar date is present -- legitimate for a published source, identifying for a private one'

  # --- house rules ------------------------------------------------------------------------------
  # ASCII: a character-class grep reads GREEN on non-ASCII in several locales, so use iconv, which
  # decides by decoding rather than by matching.
  local f nonascii=""
  while IFS= read -r f; do
    if ! iconv -f ASCII -t ASCII "$f" >/dev/null 2>&1; then
      nonascii="${nonascii}${f}"$'\n'
    fi
  done < <(find "$DIR" -type f \( -name '*.md' -o -name '*.html' -o -name '*.txt' \) 2>/dev/null)
  if [ -n "$nonascii" ]; then
    report FAIL non-ascii 'a file is not ASCII -- the deliverable contract is ASCII only'
    printf '%s' "$nonascii" | sed 's/^/      /'
  fi

  # --- every derived surface --------------------------------------------------------------------
  # A redaction made in the markdown and not the HTML publishes the content anyway, and the HTML is
  # the copy people open. Everything above already walks the whole tree; this only asserts that the
  # HTML mirror is actually present to have been walked.
  local n_md n_html
  n_md=$(find "$DIR" -type f -name '*.md' 2>/dev/null | wc -l)
  n_html=$(find "$DIR" -type f -name '*.html' 2>/dev/null | wc -l)
  if [ "$n_md" -gt 0 ] && [ "$n_html" -eq 0 ]; then
    report WARN html-mirror-absent \
      'markdown is present with no HTML mirror -- if the mirror exists elsewhere it was NOT scanned'
  fi
}

# ---------------------------------------------------------------------------
# self-test: every check gets its own fault, and the clean fixture must pass
# ---------------------------------------------------------------------------
# A gate that has never been observed to refuse is indistinguishable from a gate that cannot.

self_test() {
  local tmp rc fails=0
  tmp=$(mktemp -d) || exit 2
  trap 'rm -rf "$tmp"' EXIT

  mk_clean() {
    rm -rf "$tmp/pub"; mkdir -p "$tmp/pub"
    cat > "$tmp/pub/x_autopsy.md" <<'EOF'
# Autopsy: a screening call

- Recording: local recording, about 30 minutes, one mixed audio track.
- Talk-share [MEASURED]: the candidate 65.9 percent, the recruiter 34.1 percent.
- The strongest moment [TRANSCRIPT 19:59-20:10] is a clean resolution of the one concern raised.
EOF
    cat > "$tmp/pub/x_autopsy.html" <<'EOF'
<!doctype html><html><body><h1>Autopsy: a screening call</h1>
<p>Talk-share: the candidate 65.9 percent.</p></body></html>
EOF
  }

  # positive control: the clean fixture must pass, or every refusal below proves nothing
  mk_clean
  DIR="$tmp/pub"; SOURCE_KIND="private"; PRIVATE_TERMS=()
  clean_out=$(run_checks 2>&1)
  if ! printf '%s' "$clean_out" | grep -q '^FAIL '; then
    printf 'PASS  %-28s clean fixture exits clean\n' "control:clean"
  else
    printf 'FAIL  %-28s clean fixture was refused -- the gate cannot pass\n' "control:clean"
    fails=$((fails + 1))
    printf '%s\n' "$clean_out" | sed 's/^/      /'
  fi

  # one fault per control, each asserted to trip ITS OWN check by name
  red() { # label file content expected_check [extra-arg...]
    local label="$1" file="$2" content="$3" expect="$4"; shift 4
    mk_clean
    printf '%s\n' "$content" >> "$tmp/pub/$file"
    DIR="$tmp/pub"; SOURCE_KIND="private"; PRIVATE_TERMS=()
    [ "$#" -gt 0 ] && PRIVATE_TERMS=("$@")
    # judge from the OUTPUT, not from FAILCOUNT: a command substitution runs in a subshell and the
    # counter set inside it never reaches this scope. Reading the counter here made every one of
    # these controls report "not caught" while the gate was in fact refusing correctly.
    local out
    out=$(run_checks 2>&1)
    if ! printf '%s' "$out" | grep -q '^FAIL '; then
      printf 'FAIL  %-28s planted fault was NOT caught\n' "$label"; fails=$((fails + 1)); return
    fi
    if printf '%s' "$out" | grep -q "^FAIL $expect"; then
      printf 'PASS  %-28s refused, and named %s\n' "$label" "$expect"
    else
      printf 'FAIL  %-28s refused, but not by %s (shadowed by another check)\n' "$label" "$expect"
      fails=$((fails + 1))
    fi
  }

  red red:tag        x_autopsy.md   'The ledger check [EXTERNAL-RECORD: profile] shows a contradiction.' external-record-tag
  red red:marker     x_autopsy.md   '> SOURCE: EXTERNAL-RECORD -- the operator profile.'                 external-record-marker
  red red:homepath   x_autopsy.md   'Frames landed in /home/someone/scratch/frames.'                     absolute-home-path
  red red:tildepath  x_autopsy.md   'The profile lives at ~/records/profile.md.'                          tilde-path
  red red:wallclock  x_autopsy.md   'The meeting started 17:13:23 BRT.'                                  wallclock-with-timezone
  red red:datetime   x_autopsy.md   'Session began 2026-08-25 17:13:23 by the export header.'            date-plus-time-to-the-second
  red red:duration   x_autopsy.md   'Recording length 31m32s end to end.'                                exact-duration
  red red:privterm   x_autopsy.md   'The call was with Acme Robotics.'                                   private-term "Acme Robotics"
  # the surface control: the fault exists ONLY in the HTML mirror
  red red:html-only  x_autopsy.html '<p>Profile note [EXTERNAL-RECORD: profile].</p>'                    external-record-tag

  # non-ASCII gets its own fixture because it cannot be planted as an ASCII heredoc line
  mk_clean
  printf 'An em dash \xe2\x80\x94 slipped in.\n' >> "$tmp/pub/x_autopsy.md"
  DIR="$tmp/pub"; SOURCE_KIND="private"; PRIVATE_TERMS=()
  out=$(run_checks 2>&1)
  if printf '%s' "$out" | grep -q '^FAIL non-ascii'; then
    printf 'PASS  %-28s refused, and named non-ascii\n' "red:non-ascii"
  else
    printf 'FAIL  %-28s non-ASCII byte was not caught\n' "red:non-ascii"; fails=$((fails + 1))
  fi

  # scope control: a quasi-identifier is a FAIL on a private source and a WARN on a published one
  mk_clean
  printf 'The meeting started 17:13:23 BRT.\n' >> "$tmp/pub/x_autopsy.md"
  DIR="$tmp/pub"; PRIVATE_TERMS=()
  SOURCE_KIND="published"; run_checks >/dev/null 2>&1; pub_fails=$FAILCOUNT; pub_warns=$WARNCOUNT
  SOURCE_KIND="private";   run_checks >/dev/null 2>&1; prv_fails=$FAILCOUNT
  if [ "$pub_fails" -eq 0 ] && [ "$pub_warns" -gt 0 ] && [ "$prv_fails" -gt 0 ]; then
    printf 'PASS  %-28s private FAILs, published WARNs -- the scope switch moves the verdict\n' "control:source-scope"
  else
    printf 'FAIL  %-28s scope switch inert (published fails=%s warns=%s, private fails=%s)\n' \
      "control:source-scope" "$pub_fails" "$pub_warns" "$prv_fails"
    fails=$((fails + 1))
  fi

  printf '\n'
  if [ "$fails" -eq 0 ]; then
    printf 'SELF-TEST GREEN -- every control observed, every planted fault refused by its own check\n'
    return 0
  fi
  printf 'SELF-TEST RED -- %s control(s) failed\n' "$fails"
  return 1
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
DIR=""
SOURCE_KIND="private"
PRIVATE_TERMS=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --self-test) self_test; exit $? ;;
    --source) SOURCE_KIND="$2"; shift 2 ;;
    --private-term) PRIVATE_TERMS+=("$2"); shift 2 ;;
    -h|--help) usage ;;
    -*) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
    *) DIR="$1"; shift ;;
  esac
done

[ -z "$DIR" ] && usage
[ -d "$DIR" ] || { printf 'not a directory: %s\n' "$DIR" >&2; exit 2; }
case "$SOURCE_KIND" in
  private|published) ;;
  *) printf -- '--source must be private or published\n' >&2; exit 2 ;;
esac

# Terms the operator already told the skill are private. Absent config is not an error -- it just
# means this run checks fewer things, and the summary says so.
for v in VA_PROFILE_PATH VA_ROLES_DIR VA_TRACKER_PATH VA_ASSIST_LOG_DIR \
         WV_RECORDINGS_DIR WV_TRANSCRIPT_DIR VA_OUTPUT_DIR WV_WORK_DIR; do
  val="${!v}"
  [ -n "$val" ] && PRIVATE_TERMS+=("$val")
done
IFS=',' read -r -a _tools <<< "${VA_TRANSCRIBER_TOOLS},${VA_ASSIST_TOOLS}"
for t in "${_tools[@]}"; do
  t="$(printf '%s' "$t" | sed 's/^ *//; s/ *$//')"
  [ -n "$t" ] && PRIVATE_TERMS+=("$t")
done

printf 'publish_check %s -- dir=%s source=%s private-terms=%s\n\n' \
  "$VERSION" "$DIR" "$SOURCE_KIND" "${#PRIVATE_TERMS[@]}"

run_checks

printf '\nscanned %s file(s): %s FAIL, %s WARN\n' "$SCANNED" "$FAILCOUNT" "$WARNCOUNT"
if [ "$FAILCOUNT" -gt 0 ]; then
  printf 'REFUSED -- do not publish this copy.\n'
  exit 1
fi
printf 'CLEAN on the mechanical checks.\n'
printf 'Step 3 is not finished: read the survivors for external content carrying NO tag.\n'
printf 'An untagged external claim is the failure this gate cannot see, and it is the one that has bitten twice.\n'
exit 0
