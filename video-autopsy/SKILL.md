---
name: video-autopsy
description: FULL-DEPTH behavioural and technical forensics on a recording of people talking and/or sharing a screen -- meetings, panels, podcasts, conference talks, pair-programming sessions, user interviews, sales calls, lectures, job interviews you sat yourself. Triggers on the keyword "autopsy", "run the autopsy" (optionally naming the recording), "run forensics on this recording", "do a forensics pass", "the whole evaluation treatment", or the explicit form "/video-autopsy <path>". The keyword ALONE runs the complete max-depth treatment with no re-explanation and no asking what depth is wanted -- there is exactly one depth and it is the deepest available. Produces a written analysis (<slug>_autopsy.md, agent-ingestible and evidence-tagged), a human-facing HTML report (<slug>_autopsy.html), and a verbatim transcript (<slug>_transcript.txt). Covers talk-share and turn-taking, continuous-monologue blocks, disfluency counts, silence and pace PER PHASE, speech rate, prosody where diarization supports it, micro-expression bursts at key moments, and screen-share and live-coding forensics read FROM PIXELS (screen-mode classification, typing activity, on-screen errors with the theme control, artifact reconstruction). When the recording is a round the OPERATOR THEMSELVES sat, a self-review overlay adds an outcome estimate with quoted timestamped evidence, a behavioural check against their own profile, a claims-ledger consistency pass, and an assist-dependence measurement -- that overlay is opt-in per run and is never assumed, and its deliverables are PRIVATE BY DEFAULT because they cross-reference the operator's own records rather than the recording (publishing one requires the ordered PUBLICATION gate: strip external-record content FIRST, then scrub identifiers). Transcription is ALWAYS the verbatim whisper tier -- a supplied or platform transcript does NOT satisfy this skill, because cleaned-up transcripts strip the disfluencies and blur the segment timings this analysis is built on. IF THE RECORDING IS CONTENT-BEARING -- one presenter, and the subject is the MATERIAL rather than the exchange (a tutorial, talk, lecture, demo, screencast) -- USE THE SIBLING PACKAGE "watch-video-max" INSTEAD: every behavioural metric here is degenerate by construction on a single-presenter edited screencast. For a cheap content pass that reuses an existing transcript, use "watch-video".
---

# video-autopsy

Point this at a recording of people talking and/or sharing a screen, and come away knowing what
actually happened in it -- not what the transcript says was said. The deliverable is an
evidence-tagged analysis: what the exchange actually was, who did the talking, what landed, how it
was received, what the screen showed while the words claimed something else, and what the evidence
could not settle.

**What this is for.** Meetings, panels, podcasts, calls, negotiations, pair-programming sessions,
user interviews, sales calls, conference Q&A -- any recording where the subject is the EXCHANGE or
the WORKING SESSION rather than the material being presented. It reads the audio for pace and
silence, the frames for reactions and screen state, and the pixels for what the code and artifacts
actually contained.

**The one case that is a different package.** If the recording is one presenter teaching material
-- a tutorial, talk, lecture, demo, screencast -- this is the wrong tool and it will produce
degenerate numbers by construction. That is `watch-video-max`. Measured on 2026-08-29 across two
single-presenter screencasts, every behavioural metric here was degenerate and all the useful output
was content. **Step 0 below** (MODE 1) forces that decision before anything is spent -- it is the
first question of the run, and answering "the material" stops the run and routes to the sibling.

**The self-review overlay.** When the recording is a round the OPERATOR THEMSELVES sat -- a job
interview, a review, a pitch -- an additional layer becomes available: an outcome estimate, a
behavioural check against their own profile, a claims-ledger consistency pass, and an
assist-dependence measurement. That layer assumes the operator owns the profile, the ledger and the
history it compares against, so it is **decided per run and never assumed** (Step 0). On a
third-party recording it simply does not open. This is the layer that makes an uncomfortable read
possible; it is not for evaluating other people.

**Relationship to the sibling packages.** The INGEST mechanism -- the guided read, the three-tier
frame escalation, contact-sheet tiling, crop-and-upscale for on-screen text, background-task
discipline, and **the HTML design direction** -- is defined ONCE in `watch-video-max` and referenced
here rather than copied. This package carries what is specific to a behavioural/technical autopsy:
the verbatim-only transcript rule, speaker attribution and offset calibration, the metric passes,
the screen forensics, and the self-review overlay. **If a mechanism feels general, it belongs in
`watch-video-max` and must be changed there.** Copying is how two packages drift apart, and drift is
how a fix lands in one and not the other.

The behavioural machinery used to live in `watch-video-max` as a selectable FORENSICS lens. It moved
here whole on 2026-08-30 and this package is now its only home -- do not re-add a lighter copy of it
there.

## Configuration (read once, applies everywhere below)

Every `${WV_*}` and `${VA_*}` placeholder resolves in this fixed order:

1. **Environment variable** of the same name.
2. **Config file** key of the same name, lower-cased and un-prefixed (e.g. `VA_PROFILE_PATH` ->
   `profile_path`) -- with TWO deliberate exceptions, because the plain rule would collide with the
   sibling packages inside the shared config file: `VA_OUTPUT_DIR` reads `autopsy_output_dir` (not
   `output_dir`, which belongs to `watch-video`) and `VA_FPS` reads `autopsy_fps` (not `fps`). The
   two tables below name the config key wherever it is not the plain lower-cased form, and that is
   the contract. Pinning `output_dir` expecting an autopsy to land there files it to this package's
   DEFAULT instead, which for a self-review document is the one place it must not go.
3. **Auto-detection** on the host, where a sane one exists.
4. **Documented default** below.

Config file, first that exists: `$VA_CONFIG`, `$WV_CONFIG`, `./.video-autopsy.json`,
`./.watch-video.json`, `${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json`.

**This package reads the same family config file as `watch-video` and `watch-video-max`.** Pin the
toolchain once and all three use it. `WV_*` keys are the shared ingest toolchain and mean exactly
what they mean in the siblings. `VA_*` keys belong to this package alone.

| Placeholder | Meaning | Default |
|---|---|---|
| `WV_PYTHON` | Interpreter carrying `faster_whisper` / `ctranslate2` | `python3` |
| `WV_FFMPEG` / `WV_FFPROBE` | ffmpeg binaries | `ffmpeg` / `ffprobe` |
| `WV_WORK_DIR` | Scratch for frames, audio, helper scripts | `${TMPDIR:-/tmp}/video-autopsy` |
| `WV_RECORDINGS_DIR` | Where your recordings land | `$HOME/video-autopsy/recordings` |
| `WV_TRANSCRIPT_DIR` | Where platform / meeting-tool transcript exports land | empty |
| `WV_WHISPER_MODEL` | Verbatim model | `large-v3` |
| `WV_WHISPER_DEVICE` / `WV_WHISPER_COMPUTE` | `cuda`/`cpu`, `float16`/`int8` | auto |
| `VA_OUTPUT_DIR` | Where the autopsy is filed (config key: `autopsy_output_dir`) | `$HOME/video-autopsy/reports` |
| `VA_FPS` | Frame rate. 5 is the floor, not the target (config key: `autopsy_fps`) | `5` |
| `VA_DELETE_SOURCE` | Delete the recording after the run | `false` |
| `VA_WVMAX_DIR` | Path to the sibling package, if not auto-found | auto |

**Self-review overlay keys.** The six below are read ONLY in SELF-REVIEW mode (Step 0a). On a
third-party recording they are not consulted at all, and leaving every one of them empty is a
completely valid setup -- it just means this package runs as a pure third-party forensics tool.

| Placeholder | Meaning | Default |
|---|---|---|
| `VA_PROFILE_PATH` | The operator's own behavioural profile document | empty |
| `VA_ROLES_DIR` | Per-subject notes carrying the claims ledger | empty |
| `VA_TRACKER_PATH` | A tracker to append a row to | empty |
| `VA_ASSIST_LOG_DIR` | Where assist-tool log exports land, if any | empty |
| `VA_TRANSCRIBER_TOOLS` | Comma-separated names of transcribers you use | empty |
| `VA_ASSIST_TOOLS` | Comma-separated names of answer-generating tools you use | empty |

`VA_OUTPUT_DIR` is deliberately separate from `WV_OUTPUT_DIR`. In self-review mode an autopsy is a
private document about your own performance, and filing it beside a report you intend to share is
how it gets shared. Keeping the split unconditional means the safe location is not something you
have to remember to choose on the one run where it matters.

## Trigger

**The keyword alone is the whole trigger.** "autopsy", "run the autopsy", "run the autopsy on the
X recording", "run forensics on this recording", "do a forensics pass", "the whole evaluation
treatment", "like you did it last time" -- all of these run everything below, at full depth, with no
clarifying question about scope or depth. There is exactly one depth and it is the deepest
available. Do not offer a lighter pass; do not ask whether the behavioural analysis is wanted.
Asking is itself a failure of the trigger.

The one thing you DO settle before spending anything is the two mode questions in Step 0. Those are
not depth questions -- they decide whether this is the right package at all, and whether the
self-review overlay opens.

## Step -1 -- PREFLIGHT (run this FIRST, before spending anything)

```bash
bash preflight.sh [--file /path/to/recording.mp4] [--fps N]
```

Non-zero exit means STOP. Warnings are not stop conditions but they are not free either: **every
warning narrows what the report can claim, and each one must be carried into the report's
limitations section rather than disappearing at the gate.** A missing operator profile means no
trend can be reported; a missing roles directory means no claims-ledger check; missing tool names
mean the assist question has to be asked in its weaker, open form.

The gate never installs anything. `${WV_PYTHON}` may be shared with unrelated work, and
`pip install faster-whisper` pulls ctranslate2, tokenizers and onnxruntime underneath it.

## Step 0 -- Two MODE decisions, input resolution, and two checks before any number

### 0a. State the two modes, in one line each, before spending anything

Neither has a default. Both are answered by looking at the recording, and both are written into the
report header. A run that has not stated them is not allowed to proceed to frame extraction.

**MODE 1 -- is the subject the EXCHANGE, or the MATERIAL?**

- **The exchange / the working session** (multiple participants, or one participant building
  something on screen while others watch): this is the right package. Continue.
- **The material** (one presenter teaching, a tutorial, a talk, a lecture, an edited screencast):
  **STOP and say so.** This is `watch-video-max`. Every behavioural metric here is degenerate by
  construction on that footage -- measured 2026-08-29 across two single-presenter screencasts,
  talk-share carried no information and "silence" measured the editor's cuts rather than the
  speaker. Route the user there rather than producing a statistics sheet about a narrator.
- **If you are unsure, it is the material.** That is both the more common case and the one where
  guessing wrong costs more.

**MODE 2 -- is this SELF-REVIEW, or a THIRD-PARTY recording?**

- **SELF-REVIEW**: the operator is a participant AND their own performance is the question (a job
  interview they sat, a review, a pitch they gave). The self-review overlay in
  `references/evaluation.md` opens: outcome estimate, behavioural check against
  `${VA_PROFILE_PATH}`, claims-ledger consistency, assist dependence, and the document updates.
- **THIRD-PARTY**: anything else -- a podcast, a panel, a meeting the operator is not the subject
  of, someone else's recording. The overlay does NOT open. Do not produce an outcome estimate, do
  not open the profile, do not touch the ledger or the tracker. The analysis stops at what the
  recording shows.

**Ask if the recording does not settle it.** A meeting the operator attended is not automatically
self-review; a call is self-review only when the point is to evaluate their own performance in it.
Guessing SELF-REVIEW on a third-party recording writes a private-performance document about someone
who did not ask for one; guessing THIRD-PARTY on the operator's own round silently drops the most
valuable half of the analysis. One question costs nothing next to either.

### 0b. Input resolution

Default input: the newest recording in `${WV_RECORDINGS_DIR}`. **Confirm the file's mtime matches
the session you mean to review.** "Newest in directory" silently analyses the wrong session when
the expected recording failed to save, and a wrong-session autopsy reads exactly like a correct
one.

**RECORD THE SOURCE PROVENANCE, in the header, in one word.** `PUBLISHED` -- the recording is
already public and anyone can watch it. `PRIVATE` -- it is not, whoever made it. This is not a mode
question and it changes nothing about the analysis; it decides only whether the PUBLICATION gate at
the end of this file applies, and a run that never wrote it down forces a later guess about people
who cannot be asked. When it is not obvious, it is PRIVATE.

**CHECK AUDIO CAPTURE BEFORE COMPUTING ANY TALK-TIME NUMBER.** A recorder pointed at the wrong
source produces a file that plays fine and is missing one side of the conversation entirely; a
naive word count then confidently reports the wrong speaker as dominant.

```bash
${WV_FFMPEG} -hide_banner -nostats -i <video> -af volumedetect -f null - 2>&1 | grep -E 'mean_volume|max_volume'
```

State the result in the transcript header. If one side is missing, say so before anything else and
treat every talk-share number as void.

**MULTI-CHANNEL: MEASURE BEFORE YOU PREPROCESS.** If the recording carries more than one audio
channel, do not reach for de-echo or de-duplication on a report that a voice sounds "doubled".
Split the channels and measure first -- per-channel RMS, the RMS of their difference, and
correlation at lag 0:

```bash
${WV_FFMPEG} -i <video> -filter_complex "[0:a]channelsplit=channel_layout=stereo[l][r]" \
  -map "[l]" -ar 16000 /tmp/ch_l.wav -map "[r]" -ar 16000 /tmp/ch_r.wav
```

Note that a single `-ar` applies only to the FIRST output, so resample each explicitly.

**Judge the difference as a RATIO, never as an absolute number.** The test is
`rms(L - R) / rms(L)`: below about 1% the two channels are the same signal and a plain `-ac 1`
downmix is lossless. An absolute threshold does not survive a change of sample representation --
measured on one real recording, int16 samples gave `rms(L)=1114.8` and `rms(L-R)=3.36`, which is
0.30% and clearly identical, while the same audio as normalised floats would put that difference
near 1e-4. A rule written against either raw figure misclassifies the other. Correlation at lag 0
is the corroborating check and should read ~1.0.

A residual autocorrelation peak at 10-150 ms is ordinary room reverb, not a duplicated track. Only
channels that genuinely differ -- a difference ratio well above 1%, correlation clearly below 1, or
one channel lagging the other -- justify alignment or subtraction.

## Step 1 -- Frame extraction, at 5 fps MINIMUM

```bash
mkdir -p ${WV_WORK_DIR}/<slug>_frames
${WV_FFMPEG} -hide_banner -i <video> -vf "fps=${VA_FPS}" -q:v 3 \
  ${WV_WORK_DIR}/<slug>_frames/f_%06d.jpg
```

`%06d`, not `%04d`: 5 fps x 60 minutes is 18,000 frames. Frame number maps to time as
`f_NNNNNN` = second `(NNNNNN - 1) / ${VA_FPS}`. Keep that mapping exact -- every later lookup
depends on it.

**Raise the rate above 5 where the content warrants it** -- rapid speaker switches, live coding,
screen sharing with fast scrolling, any moment where 5 fps would miss a meaningful transition.
5 fps is the floor for talking-head segments, not a target. Below 5 fps, micro-expression and
typing-cadence work stops resolving and every frame-derived behavioural finding must be labelled
DEGRADED.

Start extraction FIRST as a background task and do transcript work on whatever has landed --
frames arrive in order. See background-task discipline in `watch-video-max/SKILL.md` before
launching anything detached.

## Step 2 -- The transcript MUST be verbatim. There is no ladder here.

This is the sharpest difference from the sibling packages, and it is deliberate. `watch-video`
prefers a transcript you already have and treats whisper as a last resort; `watch-video-max`
accepts a supplied transcript for its knowledge lens. **Neither is acceptable here.**

- **Disfluency counts need the fillers.** Every cleaned-up transcript strips "um", "uh" and false
  starts. Counting them from a tidied source reports zero and reads as a clean result.
- **The behavioural read needs precise segment timings.** Pause length, monologue-block detection
  and speech rate all come from segment boundaries; a summarised transcript blurs them while
  looking perfectly usable.

So: run whisper, always.

```python
from faster_whisper import WhisperModel
model = WhisperModel("${WV_WHISPER_MODEL}", device="${WV_WHISPER_DEVICE}",
                     compute_type="${WV_WHISPER_COMPUTE}")
segments, info = model.transcribe(
    "${WV_WORK_DIR}/<slug>_audio.wav",
    language="<the language actually spoken>",
    vad_filter=True, condition_on_previous_text=True, word_timestamps=False,
)
```

Audio extraction: `${WV_FFMPEG} -hide_banner -i <video> -vn -acodec pcm_s16le -ar 16000 -ac 1
${WV_WORK_DIR}/<slug>_audio.wav`.

- **Do not use the batched pipeline, and do not use a distilled model.** Both trade exactly the
  fidelity this package depends on. Plain sequential `large-v3` in float16 measures roughly
  10-12x realtime on a mid-range GPU, which is fast enough.
- **GPU, sequentially.** `large-v3` float16 needs about 4.2 GB. One job at a time, one model load
  for all files. Two concurrent jobs is a proven failure mode on GPU and far worse on CPU. The CPU
  path is roughly 20x slower -- announce the ETA before starting.
- **Preserve per-recording settings**, especially `language`. Not every interview is in English,
  and a wrong language tag produces fluent, confident, wrong text.

**A RECORDING CAN CHANGE LANGUAGE MID-WAY, AND `language=` IS SET ONCE.** The parameter above is
a single value for the whole file, so a call that switches languages part-way gets fluent, confident,
wrong text for the switched span -- and, because the words are wrong, every word-count metric over
that span measures ASR failure rather than behaviour. This is not exotic: it happens whenever two
speakers share a first language and drop into it for the logistics at the end.

Detect it rather than discovering it in the numbers:

- Scan the segment stream for a span where the average segment confidence drops, repetition rises,
  or the text stops being responsive to what the frames show. Re-transcribe that span alone with the
  other language and compare -- the correct language produces coherent text and the wrong one does
  not, and the difference is not subtle.
- **Mark the span, and carry it as a boundary into Step 6, not into Limitations.** Its start time is
  the end of the measured window (see "Declare the measured window BEFORE the numbers").
- Speaker-separated exports fail here too, and usually harder: an English-only engine returns
  garbage for the span AND no speaker labels for it, so attribution across that boundary is
  inferred from turn logic, never measured. Say which.
- On a real 31-minute call this cost the last 5m40s of every word-count metric. Reporting those
  numbers would not have been slightly wrong; it would have been a measurement of the ASR.

**Transcript quality gate.** Assess completeness before trusting it: full-duration coverage, no
long timestamp gaps, no repeated gibberish, no silence where the frames show someone speaking.
If degraded, work the chain in order: (1) ask for the platform's own transcript export and
re-check `${WV_TRANSCRIPT_DIR}`; (2) re-run with `vad_parameters={"threshold": 0.3}`,
`no_speech_threshold=0.4`, temperature fallback `[0.0, 0.2, 0.4, 0.6]`, and cut isolated bad spans
with `-ss/-to` to transcribe alone; (3) **last resort, OCR from frames** -- at 5 fps the platform's
own live captions are nearly continuously legible. Label it `[OCR-from-frames]` and flag that
**disfluency counts are void** on an OCR transcript, because captions never show "um". Log which
path was used in the transcript header.

## Step 3 -- Speaker attribution, and the offset that breaks it

Whisper output is mixed-mic: it is verbatim but it does not say who spoke.

**If a speaker-separated export exists in `${WV_TRANSCRIPT_DIR}`, use BOTH** -- the export for
who-said-what, whisper for verbatim text and fillers. Look for it; do not ask.

**Its absence is expected, not a missing input.** Many meeting transcribers only attach to one
platform, so recordings from another will simply never have one. Fall back to attribution from
whisper content plus frames: the recording shows who is on screen and most platforms render an
active-speaker indicator, so sample frames at speaker transitions to pin turns. **Talk-time then
becomes APPROXIMATE and must be labelled as an estimate**, with the frame sampling leaned on
harder.

**BIND FACES TO NAMES EXPLICITLY, AND WRITE THE MAP INTO THE HEADER.** Every frame-derived claim
in the report -- who reacted, who smiled, who was reading, who delivered a given line -- rests on a
map from a position on screen to a person. That map is usually built once, early, from whatever was
convenient, and then never questioned. It is the single highest-consequence unchecked assumption
this package makes: in a shipped run on 2026-08-31 the two participants of a published interview were
swapped, and the report credited the video's paid sponsor read to the person who did not deliver it.
Every individual observation in that report was correct. The map was not.

- **Bind each participant from TWO DISJOINT sources.** A rendered name label or nameplate is one. A
  frame whose transcript line is unambiguous, showing mouth movement or the platform's own
  active-speaker highlight on that tile, is the other. A name label alone is not enough -- labels
  follow tiles, and tiles move.
- **Re-verify the map at a second timestamp at least half the recording away from the first.** Grid
  order changes when someone pins a speaker, turns a camera on or off, or starts sharing. A map
  correct at 02:00 can be wrong at 40:00 with nothing on screen announcing the change.
- **A personalised surface names the SHARER, not the speaker.** A shared screen, a logged-in
  browser, a personal feed, a notification toast, a webcam strip inside somebody else's share --
  all of these tell you whose machine it is, and nothing at all about who is talking over it. A
  single share frame can show every participant's camera at once; reading identity off one is how
  a whole map gets inverted.
- **If the map rests on one source only, say so and tag every attribution `[HYPOTHESIS]`.** An
  unverified map does not make attribution slightly less certain; it makes each attribution a coin
  flip that the report states as fact.

**VERIFY THE TIMESTAMP OFFSET PER RECORDING, BEFORE CUTTING ANY FRAMES.** Recorders commonly start
capturing before the session connects, so export time and video time differ by tens of seconds --
and the offset is NOT a constant you can carry between recordings. In one case an offset that had
been about 55 seconds was actually 130, and every frame extracted on the old assumption pointed at
the wrong passage. Calibrate against a distinctive utterance or an on-screen clock first.

## Step 4 -- ASK WHICH TOOLS WERE RUNNING, BY NAME, BEFORE ANY ASSIST ANALYSIS

**SELF-REVIEW MODE ONLY (Step 0a).** On a third-party recording there is no assist question to ask
and no assist section in the report -- skip this step entirely, and do not substitute a guess about
what someone else may have had open. Say in the report that assist analysis does not apply.

Ask before writing a single word about assistance. And ask **by product name**, using
`${VA_TRANSCRIBER_TOOLS}` and `${VA_ASSIST_TOOLS}`:

> "Was <transcriber A> running? Was <assist tool B> running?"

**"Was anything on?" is too coarse and has produced a false finding in practice.** The categories
are not interchangeable:

- a **TRANSCRIBER** records what was said. It is harmless to an assessment of your own performance.
- an **ASSIST TOOL** generates answers. It changes what the assessment even means.

Conflating them once produced an integrity finding that had to be retracted from five separate
artifacts.

**Absence of a log is not evidence of absence.** Assist-log exports are manual, and a tool's
runtime traces usually live somewhere the analysis host cannot see. An exhaustive search coming
back empty means the export is missing, not that the tool was off -- that exact inference was
written into five artifacts once and was wrong. Gaze direction does not settle it either.

**The only valid measurement of dependence is n-gram overlap between the assist log and what was
actually said** (4-grams work well). If the log is missing, ask for the export; if it does not
arrive, mark dependence **UNMEASURED** and move on. Do not infer in either direction.

## Step 5 -- The guided read

Walk the ENTIRE transcript start to finish, escalating to frames wherever the words alone do not
carry the meaning. The mechanism -- trigger phrases, the three-tier frame escalation, contact-sheet
tiling with `tile=3x3`, crop-and-upscale with LANCZOS for on-screen text, the
"I could re-explain what happened on screen" bar -- is defined in `watch-video-max/SKILL.md`.
**Read it and follow it; do not re-derive it here.**

The full trigger list this package adds is in `references/evaluation.md` ("Triggers -- what sends
you to the frames"). In outline: every pointed question and the first three seconds of the answer,
every interjection or interruption, deictic language, anything shown rather than said, long silences,
every screen-share transition, ambiguous speaker attribution, and the closing segment -- which is
routinely skipped because it sounds like admin and is some of the highest-signal footage in the
recording.

**In SELF-REVIEW mode, add one more:** any moment the operator's own memory of the session disagrees
with what the transcript says. That disagreement is itself the finding.

**Micro-expression bursts at each of those moments.** One tiled sheet is one Read for nine frames
of expression evolution:

```bash
${WV_FFMPEG} -ss <t> -t 12 -i <video> -vf "fps=0.75,scale=640:-1,tile=3x3" \
  -frames:v 1 ${WV_WORK_DIR}/<slug>_frames/burst_<mmss>.jpg
```

## Step 6 -- The metric passes

Full definitions, failure modes and worked numbers are in **`references/evaluation.md`**. Read it
in full before computing anything.

**DECLARE THE MEASURED WINDOW BEFORE THE NUMBERS, NOT IN LIMITATIONS AFTER THEM.** Almost no
recording is measurable end to end: a language switch, a dropped channel, an unattributable stretch
or a degraded span cuts a window out of it. Open the metric section with the window, its duration,
and the fraction of the recording it covers -- `0:00-25:52 of 31:32 = 82%` -- and repeat the window
on every aggregate computed over it. A reader who stops at a talk-share percentage has already taken
it for the whole call, and a scope stated afterwards cannot reach them.

- **`VOID` is a first-class value with a reason**, not an omission. A phase whose numbers would
  measure ASR failure gets the word VOID and one line saying why. Omitting it silently reads as
  a phase where nothing happened.
- **Any block that straddles the window boundary is inspected by hand before it is reported.** The
  merge that builds monologue blocks does not know the boundary is there and will happily report a
  five-minute floor-hold that is actually both speakers exchanging four-word turns through a
  degraded span. That exact artifact appeared in a real run and was caught only by reading the
  turns; report the inspection either way.
- **Never state a coverage fraction you did not compute.** Covered seconds over total seconds, both
  printed.

In outline:

- **Talk-share and turn-taking**, per speaker, with word counts.
- **Continuous monologue blocks** (>= 60s of one speaker). This is usually the single most
  actionable number in the whole report.
- **Disfluency counts** -- from the speaker-separated export where one exists, because whisper's
  VAD strips fillers. From raw whisper if that is all there is, stated as an under-count.
- **Silence and pace PER PHASE, never per call.** A whole-call average hides everything. Compute
  each phase separately (intro, behavioural, technical, coding window, close) and compare them.
- **Speech rate** per phase, alongside silence and monologue length -- three views of one behaviour.
- **Prosody**, only where attribution supports it, and always HYPOTHESIS-grade on mixed-mic audio.
- **Screen-share and live-coding forensics from pixels**, when code or a shared screen is present.
  There, **the frame pass is the main event, not a side channel**: screen-mode classification FIRST,
  typing activity from editor-region pixel delta, on-screen errors with the red-pixel control that
  stops a theme-dependent heuristic from producing confident nonsense, and artifact reconstruction.
  Full definitions in `references/evaluation.md` section 6.

## Step 7 -- The analysis

This is the deliverable. `references/evaluation.md` carries the full contract; the structure is:

- **The analysis of the subject**, first and longest -- what the exchange actually was. **A report
  whose body is pace, silence and pixel statistics has failed**, however correct the numbers are.
  Measurement is how you learn things; it is not the deliverable.
- **What landed and what did not**, with reactions cited to specific frames or bursts.
- **The metric passes with their numbers**, per phase, each tagged with the tier that produced it.
  A degenerate metric gets ONE LINE and is dropped, not a section justifying it.
- **Screen and technical findings**, and every narration-vs-screen discrepancy with both sides
  quoted. Those discrepancies are the highest-value findings this package produces.
- **Limitations** -- every preflight warning, every degraded metric, every honest null, each with
  what it prevented the report from concluding.

**In SELF-REVIEW mode only (Step 0a), the overlay adds:** outcome estimate, behavioural check
against `${VA_PROFILE_PATH}`, claims-ledger consistency against `${VA_ROLES_DIR}/<role>`, and assist
dependence (measured or explicitly UNMEASURED). Full rubric in `references/evaluation.md`.
**Those sections read the operator's private records rather than the recording**, so they carry the
provenance markers and `[EXTERNAL-RECORD]` tags defined there, without exception.

Three standing rules, all learned expensively:

1. **NEVER infer an outcome from downstream thread state.** A later-stage round being scheduled
   does not prove an earlier one cleared. Estimate only from in-recording evidence.
2. **An honest NULL is a valid result.** When the evidence cannot answer a question, say so with a
   stated confidence. A fabricated percentage is worse than an admitted gap.
3. **Check a suspected diction slip against a second engine before logging it.** ASR noise looks
   exactly like a mispronunciation. Only log a slip that BOTH engines mangle.

## Deliverables

Write all three to `${VA_OUTPUT_DIR}/<slug>/`. In chat, give ONLY the paths plus a summary of at
most two lines -- never paste the report prose or markup into chat. Deliverable documents are full
descriptive prose. ASCII only.

### 1. `<slug>_autopsy.md` -- the primary deliverable

Agent-ingestible and evidence-tagged, written so a later run or another assistant can be handed it
as context. Provenance tags inline: `[TRANSCRIPT hh:mm]` quoted verbatim | `[FRAME n / mm:ss]` read
from pixels | `[MEASURED]` computed, with the method named | `[HYPOTHESIS]` inference | `[NULL]`
the evidence could not answer it | `[EXTERNAL-RECORD: <source>]` taken from a record OUTSIDE the
recording -- the operator's profile, claims ledger, tracker, assist log, personal ground truth,
**their own brief or instructions to this run**, or **private filesystem state** (which files exist,
their mtimes, what a private directory holds) -- naming which one. Tag at least every number, every reaction claim and any outcome estimate.

**`[EXTERNAL-RECORD]` is mandatory and it is not decoration.** Every other tag says the claim came
from the recording; this one says it did NOT. It is the only thing that lets a later publication
pass separate the two provenances mechanically (see PUBLICATION below), and the only thing that
stops a reader from taking a private-record fact for something the footage showed. Any claim in the
document that is not traceable to the transcript, the frames, or a measurement over them carries it.

Structure: header (what the recording is, participants, date, duration, **the two Step 0a modes**,
**the source provenance from Step 0b**, **the face-to-name map and the evidence for it**, transcript
tier, audio-capture result, attribution method, **the measured window and its coverage**, frame
rate) -> the analysis of the subject -> what landed / what did not -> the metric passes with their
numbers, per phase -> screen and technical findings -> narration-vs-screen discrepancies ->
limitations -> run notes.

**`## Run notes` is a section of its own, and it is EXTERNAL-BY-CONSTRUCTION.** Everything the run
learned about the machine rather than the recording goes here and nowhere else: scratch directories
that already existed, file counts and mtimes, which tool version produced what, a stale artifact
that was found and not trusted. None of it is evidence about the recording -- an mtime is evidence
about a disk -- and all of it describes a private filesystem. It therefore opens with the standing
source-marker line and is stripped whole by the publication gate.

**It exists because that content had no home and kept landing in `## Anomalies`,** which is a
findings section about the recording and survives the strip. A shipped example published a scratch
directory's file count and image dimensions that way, through a partition pass that was working
correctly: the class was named as external, and there was still nowhere for it to go.

**In SELF-REVIEW mode only**, insert after the analysis: outcome estimate -> behavioural check ->
claims ledger -> assist dependence. **Every one of those except the outcome estimate itself is
EXTERNAL-BY-CONSTRUCTION** -- built from the operator's private records rather than from the
recording -- and each MUST open with the standing source-marker line defined in
`references/evaluation.md` ("Provenance partition"), with `[EXTERNAL-RECORD: <source>]` on its
individual claims. A run that writes those sections without markers has produced a document that
cannot afterwards be prepared for publication by any mechanical pass.

### 2. `<slug>_autopsy.html` -- the human-facing report

Follow **"The HTML report: design direction"** in `watch-video-max/SKILL.md`. That is the single
source for how these pages are designed and it is not restated here. In particular: name three art
directions and pick one before writing any CSS, lock the palette afterwards, build one signature
element that teaches the recording's central finding, run the seven-dimension critique against a
screenshot, and run the slop checklist. This report has the most evidence of any in the family --
per-phase numbers, expression bursts, timeline structure -- and a page of stat tiles renders none
of it usefully.

### 3. `<slug>_transcript.txt`

The verbatim transcript of record, with a header naming the model, device, compute type, language,
the audio-capture check result, the attribution method, and which fallback path (if any) produced
it.

### Document updates, same session -- SELF-REVIEW MODE ONLY

**These do not run on a third-party recording.** They write into the operator's own private history,
and there is no history to write for someone else's podcast. In THIRD-PARTY mode, skip all three and
say so in one line.

In SELF-REVIEW mode, run each only where the corresponding key is configured. Skip
configured-empty targets, but SAY in the report which updates were skipped and why.

1. Append a data point to `${VA_PROFILE_PATH}` -- **append-only**. The value is the trend across
   rounds, so never rewrite a past entry.
2. Update the role file in `${VA_ROLES_DIR}` with outcome and next steps.
3. Append a row to `${VA_TRACKER_PATH}`.

## PUBLICATION -- run this gate on TWO triggers, not one

**Trigger A -- SELF-REVIEW mode.** The overlay cross-references the operator's private records, so
the document carries a provenance the recording never had. Steps 1 through 5 all apply.

**Trigger B -- the source recording is PRIVATE, in EITHER mode** (Step 0b records this). A
third-party autopsy of a private recording contains no external-record sections, so step 1 finds
nothing to do -- but everything from step 2 onward applies in full. A client call, a teammate's
working session and a stranger's unpublished recording are all documents about people who did not
publish themselves.

The gate does NOT apply to a third-party autopsy of a source the world can already watch. There,
naming the video is the point.

**This scoping was wrong until 2026-08-31.** The section used to open "SELF-REVIEW MODE ONLY", which
left a third-party autopsy of a private recording with no publication gate at all -- the commonest
professional case this package has, and the one where the subjects have the least say.

A self-review autopsy is not a shareable artifact, and nothing in the run should treat it as one.
The overlay cross-references the operator's private records BY DESIGN, so the finished document
carries two provenances at once: what the recording contained, and what their own history contains.
Filing is already split for this reason -- `VA_OUTPUT_DIR` is deliberately not `WV_OUTPUT_DIR` --
but a filing location is not a publication gate.

**When any part of a self-review deliverable is to be published or shown outside the operator --
a portfolio, a public examples tree, a demo, a colleague, a screenshot -- run this gate IN THIS
ORDER:**

1. **Partition by SOURCE first.** Remove, or redact to a stated shell, every section carrying the
   standing EXTERNAL-RECORD marker line, and every individual claim carrying an
   `[EXTERNAL-RECORD: ...]` tag. This is a mechanical pass over markers and tags -- not a judgment
   call about what happens to look sensitive.
2. **Then scrub identifiers** in whatever survived step 1: names, employers, roles, dates, figures,
   local paths, tool names.
3. **Then COARSEN THE QUASI-IDENTIFIERS.** A quasi-identifier names nobody and identifies the
   session anyway, by letting a counterparty match the document against a record they already hold.
   Step 2 does not catch these, because there is no name in them to scrub. Apply this table on a
   PRIVATE source; on a published one, keep whatever the source itself already discloses:

   | Field | Ships as | Never ships as |
   |---|---|---|
   | Start time | dropped entirely | `17:13:23 BRT`, or any wall clock with a zone |
   | Date | the month (`August 2026`) | `2026-08-25` |
   | Duration | rounded to 5 minutes (`about 30 minutes`) | `31m32s`, `1892.7s` |
   | Job title | the family (`a senior engineering role`) | `Lead AI Engineer` |
   | Counterparty title | the function (`a recruiter`) | `Talent Acquisition and People Ops Manager` |
   | Organisation | the sector, if load-bearing | a description narrow enough to name one company |
   | Platform / tooling | keep -- it is method, not identity | -- |

   **The test is stated from the other side: could a person who was in that meeting match this
   document against their own calendar?** Three of these shipped in a real published example on
   2026-08-31, in a copy whose identifier scrub had already passed clean, and the start time alone
   was enough.

4. **Then verify, by running the gate.** Prose verification is what failed twice.

   ```bash
   bash publish_check.sh <published-dir> --source private [--private-term 'A Name']...
   ```

   It exits non-zero on any surviving tag or marker, absolute or tilde path, declared private term,
   quasi-identifier, or non-ASCII byte, and names WHICH check refused. It auto-loads the configured
   `VA_*` / `WV_*` paths as private terms. `--source published` demotes the quasi-identifier checks
   to warnings and leaves everything else hard.

   `bash publish_check.sh --self-test` plants one fault per check and asserts each is refused by its
   own check name, with a clean fixture that must pass. Run it if you change the script: a gate that
   has never been observed refusing is indistinguishable from one that cannot.

   **The gate is step 3 of the ordered pass and nothing more.** A clean exit does NOT mean the copy
   is publishable. Read the survivors yourself for external content carrying NO tag -- an untagged
   external claim is the exact failure the tag exists to make visible, and no grep will find it for
   you. The script says this on every clean run rather than letting a green line stand alone.

5. **Apply all of it to every derived surface.** The HTML report mirrors the markdown. A redaction
   made in one and not the other publishes the content anyway, and the HTML is the copy people
   actually open. Point the gate at a directory holding BOTH; if the mirror lives elsewhere, it was
   not scanned and the gate says so.

**Step 1 cannot be skipped by doing step 2 harder.** A scrub keyed on IDENTIFIERS cannot contain a
PROVENANCE leak. "The ledger shows a claim that contradicts an earlier round" names nobody, passes
every name check, and still publishes both the existence and the content of a private record. That
is not hypothetical: it was found in a real published example on 2026-08-31, after a full identifier
scrub had already been run and had passed clean.

## FINAL CLEAN PHASE (mandatory last step)

**Cleanup must also run when the run does NOT succeed.** Frames land early and at 5 fps they are
tens of gigabytes. Whenever a run ends for ANY reason without reaching this step:

```bash
bash cleanup.sh <slug>              # remove this run's scratch, verify, report
bash cleanup.sh <slug> --dry-run    # show what would go
bash cleanup.sh --stale 1 --force   # reap orphans from earlier runs older than a day
```

`cleanup.sh` refuses an empty, short or path-like slug rather than globbing the work directory,
verifies afterwards that nothing remains, and warns if a process could recreate what was deleted.
Run `--stale` at the START of a session too.

### HARD CLEANUP RULES (non-negotiable; added 2026-08-30)

On 2026-08-30, 8.5 GB of orphaned `*_frames` dirs from July-August runs of this skill family
were found in bare `/tmp` on a 97%-full disk. Cause: a config `work_dir` of bare `/tmp` plus
runs that never invoked the reaper. A run that violates any rule below is INCOMPLETE even if
every deliverable landed. (The recordings and transcripts this skill ingests from the career
directories are USER INPUTS -- rule 4 protects them absolutely; `delete_source` only ever
applies to the pipeline's own working copy.)

1. Scratch lives ONLY under `${WV_WORK_DIR}`, which MUST be a dedicated directory -- never bare
   `/tmp` and never a directory shared with anything else. Before extracting a single frame,
   print the resolved `WV_WORK_DIR` and refuse to proceed if it resolves to bare `/tmp` (or
   `$TMPDIR` itself).
2. The LAST action of EVERY run -- success, failure, or interruption alike -- is
   `bash cleanup.sh <slug>`, and the run's final report must state what was deleted and what
   remains. Scratch surviving a finished run is a defect to report, not a leftover to ignore.
3. The FIRST action of every run is `bash cleanup.sh --stale 1 --force`; the reaper also sweeps
   the legacy bare-/tmp location where pre-2026-08-30 runs left scratch.
4. Never deleted, ever: user-supplied recordings, transcripts, and any other input the pipeline
   did not create, plus the final deliverables (autopsy md/html, transcript). Everything else
   this pipeline created is scratch and dies with the run.

Delete: `${WV_WORK_DIR}/<slug>_frames/` including all `burst_*` sheets;
`${WV_WORK_DIR}/<slug>_audio.wav` and any channel splits or segment cuts;
`${WV_WORK_DIR}/transcribe_<slug>.py` and any other scratch script; and **the screenshots the
HTML critique pass produced**, plus any throwaway copy of the page used to force an interactive
state. Name every scratch file with the slug prefix or the glob will miss it.

**The provenance rule: the pipeline deletes only what it created.** The recording is an input it
did not create. It is deleted ONLY when `${VA_DELETE_SOURCE}` is explicitly `true`, and the default
is `false` -- set it true only when an original survives on the device that recorded it. **Never
delete a platform transcript export**; that is the user's file. Confirm no background task is still
alive before finishing.

## House rules (no exceptions)

- **ASCII only** -- never unicode arrows, checkmarks, box-drawing or emoji, anywhere.
- Deliverable documents are full descriptive prose.
- In chat: file paths plus a <=2-line summary. Never paste report prose or markup.
- **The self-review overlay is opt-in per run, never assumed.** Step 0a decides it. On a
  third-party recording, do not produce an outcome estimate, open the profile, or touch the ledger
  or tracker -- that apparatus assumes the operator owns the history it compares against, and its
  output is a private document about a private performance.
- **A self-review deliverable is PRIVATE BY DEFAULT** and leaves that state only through the
  PUBLICATION gate above: partition by SOURCE (strip EXTERNAL-RECORD sections and tags), THEN scrub
  identifiers, then verify, on every derived surface. The reverse order does not work -- a name
  scrub cannot contain a provenance leak.
- **A report whose body is measurements has failed.** The deliverable analyses the recording's
  subject; the numbers are how you got there. A degenerate metric gets one line and is dropped.
- **This package does not study content.** If the subject turns out to be the MATERIAL rather than
  the exchange, stop and route to `watch-video-max` rather than improvising a content pass here.
- Confidence discipline: assert nothing as fact below high confidence. Below that, say what is
  uncertain and why. This applies to what gets WRITTEN into a living document, not just to chat.
