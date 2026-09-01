# REFUSAL -- video-autopsy x harness-comparison-explainer

`video-autopsy` refused this source at its MODE 1 scope gate and produced no deliverable. That
is the run's result, and it is published here for the same reason the other eight legs are: a
package that only ever shows its successes is not showing you how it decides.

The text below is what the run wrote when it stopped. Nothing has been added to it and nothing
has been rewritten. The only edits are the removal of the dispatcher's own start and finish
lines, which are about our harness rather than about the video.

---

## REFUSED at Step 0a, MODE 1 -- subject is the MATERIAL, not an exchange

**Video:** "100 Hours Testing Deepseek Harness vs. Claude Code. What You Need to Know." -- Nate Herk | AI Automation, 18m01s, 1280x720, published 2026-08-23. Source provenance: PUBLISHED.

**Preflight:** passed, 0 failures, 0 warnings (GPU tier available, faster_whisper 1.2.1, watch-video-max sibling found).

**Evidence for the gate.** Settled from the recording, not the title. 34 samples spanning the whole 1082s -- one 9-frame sheet at 120s spacing, then a 25-frame sheet at 43s spacing. Every sample: one presenter, either full-frame in his studio or as a webcam inset over an edited screencast. No second participant, no second voice, no reaction shot, no turn anywhere in the file. Hard cuts between shot types, and the Claude-Code-vs-Deepseek-Harness scorecard table fills in progressively across the video -- an authored animated reveal. That is a single-presenter edited screencast: teaching material.

**Why that is a stop and not a caveat.** Every behavioural metric in this package is degenerate by construction on that footage. Talk-share of one speaker carries no information; "silence" would measure the editor's cuts, not the presenter; monologue-block detection would report the whole runtime as one block. The report would be a statistics sheet about a narrator. The skill routes out here rather than improvising a content pass, and its unsure-case rule points the same way.

**Route:** `watch-video-max` -- same URL, same slug. It reads this footage the right way round: verbatim transcript, high-rate frames, and reconstruction of what was actually on screen (the scorecard, the harness UI walkthroughs, the spreadsheet and document artifacts) rather than a summary of what was said about it.

**Deliverables produced: none.** No `_autopsy.md`, no `_autopsy.html`, no `_transcript.txt` -- a refusal at the scope gate is a terminal state, and writing them would be the exact output the gate exists to prevent. Nothing was written to the output root.

**Cleanup (mandatory phase, ran):** `--stale 1 --force` at start, nothing stale. At end, `cleanup.sh harness-comparison-explainer` removed 57M -- the downloaded working copy and both mode-gate contact sheets, all three created by this run. Verified clean, `[scratch directory redacted]/` is empty. The cleanup WARN names only my own dispatcher and this session's process; no third-party job. The published original is untouched on YouTube.

