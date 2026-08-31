# video-autopsy

A full-depth, evidence-tagged behavioural and technical forensics pass on a recording of people
talking and/or sharing a screen.

You come out of a meeting, a panel, a working session or an interview with an impression. The
impression is built from the two or three moments you happen to remember, weighted by how they
felt, and it is usually wrong about the thing that mattered. This skill reads the recording instead:
who actually did the talking, how long the longest single answer really was, where the silence went,
what a face did at the moment that counted, and -- when a screen was shared -- what the code
actually did, as opposed to what was said about it.

It produces three files: a written analysis, a human-facing HTML report, and the verbatim
transcript.

## What it is for, and the one case it is not

**For:** meetings, panels, podcasts, calls, negotiations, pair-programming sessions, user
interviews, sales calls, conference Q&A, job interviews -- any recording where the subject is the
EXCHANGE or the WORKING SESSION rather than the material being presented.

**Not for:** one presenter teaching material -- a tutorial, a talk, a lecture, an edited screencast.
That is the sibling package `watch-video-max`. Every behavioural metric here is degenerate by
construction on that footage: measured across two single-presenter screencasts, talk-share carried
no information and "silence" measured the editor's cuts rather than the speaker. The skill forces
that decision in Step 0 before anything is spent, and routes you out if the answer is "the
material". **If you are unsure, it is the material.**

## The self-review overlay

When the recording is a round **the operator themselves sat**, an additional layer opens: an
outcome estimate with quoted timestamped evidence, a behavioural check against their own profile,
a claims-ledger consistency pass against what they have already told that company, an
assist-dependence measurement, and updates to the documents they keep about their own performance.

That layer assumes the operator owns the profile, the ledger and the history it compares against,
so it is **decided per run and never assumed**. On a third-party recording it simply does not open:
no outcome estimate, no profile, no ledger, no tracker. Pointed at a recording of somebody else
being interviewed, the overlay would be a surveillance apparatus with none of the context that
makes its output meaningful -- and the skill's own house rules say so.

Every `VA_*` overlay key can be left empty. That is a completely valid setup: it means this package
runs as a pure third-party forensics tool.

## The one-line trigger

Say **"autopsy"** (or "run the autopsy", "run forensics on this recording", "do a forensics pass").
That alone runs the complete treatment. There is exactly one depth and it is the deepest available
-- the skill will not ask whether you want the behavioural analysis, and it will not offer a
lighter pass. The only thing it settles first is the two Step 0 mode questions, which decide whether
this is the right package at all and whether the self-review overlay opens.

## What it measures

- **Talk-share and turn-taking**, per speaker, with word counts.
- **Continuous monologue blocks** at or above 60 seconds. Usually the single most actionable number
  in the report: a talk-share of 60/40 looks survivable right up until you see it contained one
  nine-minute answer.
- **Disfluency counts**, from a speaker-separated export where you have one, because whisper's VAD
  strips most fillers.
- **Silence and pace PER PHASE**, never as a call average. One round measured 43.2% silence in its
  coding window against 7.8% in the theory window of the same call. Averaged, both disappear.
- **Prosody**, where speaker attribution supports it, and marked as inference where it does not.
- **Micro-expression bursts** at every key moment -- each pointed question, each interruption, the
  hardest probe, the close -- read as 3x3 contact sheets. The coarse tier LOCATES a reaction; only
  the dense 15 fps burst RESOLVES it.
- **Screen-share and live-coding forensics from pixels**: screen-mode classification per second
  FIRST, typing activity from editor-region pixel delta, on-screen errors with a mandatory control
  against the editor's own problem counter, what the code actually did, what an in-platform
  assistant said, and whether the work was finished. On a technical session this is the main event,
  not a side channel.
- **Narration-vs-screen discrepancies** -- every place the words and the screen disagreed. These are
  the highest-value findings the package produces.

**In the self-review overlay only:** an outcome estimate with quoted timestamped evidence; a
behavioural check against your own profile, promoting a pattern to "confirmed" only when it repeats
across rounds; a claims-ledger consistency pass against what you have already told that company; and
assist-tool dependence, measured by n-gram overlap against an exported log or explicitly marked
UNMEASURED.

## Install

```
video-autopsy/
  SKILL.md              the protocol
  README.md             this file
  preflight.sh          the gate -- run it first
  publish_check.sh      the publication gate -- run it before anything leaves the machine
  cleanup.sh            scratch removal, callable on any terminal state
  config.example.json   every key, documented
  lib/config.sh         the configuration resolver
  references/
    evaluation.md       the metric passes and the evaluation rubric
    pitfalls.md         failures that have actually happened, and the checks that catch them
```

Copy the directory to wherever your agent loads skills from (for Claude Code, `~/.claude/skills/`).
Copy `config.example.json` to `${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json` and edit.

### Dependencies

**Required:** `ffmpeg` / `ffprobe`, and a Python interpreter with `faster-whisper`. There is no
fallback for whisper here -- see "Why the transcript rule is stricter" below.

**Strongly recommended:** a CUDA GPU with about 4.2 GB free. `large-v3` in float16 runs roughly
10-12x realtime on a mid-range card; the CPU int8 path is about 20x slower, which turns a one-hour
hour-long recording into an afternoon.

**Companion package:** [`watch-video-max`](../watch-video-max). This package **composes on it
rather than forking it**. The guided read, the three-tier frame escalation, contact-sheet tiling,
crop-and-upscale for on-screen text, the shared screen-metric definitions and the HTML design
direction are defined once there and referenced here. Preflight looks for it in `../`,
`~/.claude/skills/`, and `$VA_WVMAX_DIR`, and warns rather than failing if it is absent -- the
analysis is complete in this package's own `SKILL.md` and `references/`, but the mechanism it was written
against lives next door.

The three packages share one config file and one `WV_*` prefix for the toolchain, so a value pinned
once applies to all of them. `VA_*` keys belong to this package alone.

### Preflight never installs anything

Two reasons, both deliberate. You may not have write access to the interpreter's site-packages --
it may be a shared or system install. And that interpreter may be doing other work: installing
faster-whisper pulls ctranslate2, tokenizers and onnxruntime, and can move shared dependencies
underneath a project that has nothing to do with this skill. The gate prints the exact remedy and
names the blast radius so that a dedicated environment stays a visible option.

## Why the transcript rule is stricter than in the sibling packages

`watch-video` treats an existing transcript as the preferred input and whisper as a last resort.
`watch-video-max` will accept a supplied transcript for its knowledge lens. **This package accepts
neither**, and that is the single biggest behavioural difference in the family.

- **Disfluency counts need the fillers.** Every cleaned-up transcript strips "um", "uh" and false
  starts. Counting them from a tidied source returns zero, and zero reads as a clean result rather
  than as a broken measurement.
- **The behavioural read needs precise segment boundaries.** Pause length, monologue-block
  detection and speech rate all derive from them, and a summarised transcript blurs all three while
  looking entirely usable.

A speaker-separated export is still valuable -- it is the best source for attribution and for
filler counts -- but it is used *alongside* the verbatim transcript, never instead of it.

## Privacy

Everything personal is configuration or data, and none of it is in this package:

- Your behavioural profile is a file you own, reached through `profile_path`.
- Your claims ledger is a directory you own, reached through `roles_dir`.
- Your recordings, transcripts and reports live in directories you name.
- The tools you use are named in config so the skill can ask about them by name.

The package ships with all of those empty. It runs a complete single-round autopsy with none of
them set; what it cannot do is the cross-round work, and it reports that as a limitation rather
than guessing.

The default for deleting the source recording is `false`. That default matters more here than
anywhere else in the family: the input is a recording of a conversation that may not be repeatable
and you may hold the only copy.

## Output

```
${VA_OUTPUT_DIR}/<slug>/
  <slug>_autopsy.md         evidence-tagged evaluation, written to be re-read
  <slug>_autopsy.html       the human-facing report
  <slug>_transcript.txt     verbatim, with the model, device, capture check and attribution method
```

Every claim in the markdown carries a provenance tag: `[TRANSCRIPT hh:mm]` quoted verbatim,
`[FRAME n / mm:ss]` read from pixels, `[MEASURED]` computed with the method named, `[HYPOTHESIS]`
inference, `[NULL]` the evidence could not answer it.

That last tag is not decoration. **An honest null is a valid result** and the skill is built to
prefer one over a plausible number: in one round gaze analysis could not distinguish reading from
thinking because the head angle was uniformly down-tilted with no contrasting baseline, and
reporting that plainly was worth more than a fabricated percentage would have been.

## Cleanup

A 5 fps extraction of an hour-long recording is tens of gigabytes, and frames land long before any
deliverable exists.

```bash
bash publish_check.sh <dir> --source private   # refuse a copy that is not ready to leave
bash publish_check.sh --self-test             # 12 controls, one planted fault per check

bash cleanup.sh <slug>            # remove this run's scratch, verify, report
bash cleanup.sh <slug> --dry-run  # show what would go
bash cleanup.sh --stale 1 --force # reap orphans from earlier runs older than a day
```

`cleanup.sh` is callable on **any** terminal state, refuses an empty or path-like slug rather than
globbing the work directory, and verifies afterwards -- a cleanup that silently failed otherwise
reads exactly like one that succeeded. Run `--stale` at the start of a session too: orphans from a
previous failed run are invisible until a disk fills.
