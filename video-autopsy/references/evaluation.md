# video-autopsy -- the metric passes and the evaluation

You arrive here after the shared core in `../SKILL.md`: input resolved, the audio-capture check
done, frames extracted at `${VA_FPS}` (5 minimum), the verbatim transcript produced and
quality-gated, speaker attribution settled and the timestamp offset calibrated. This file defines
what to compute, how each measurement fails, and what the written report must contain.

The last section -- **the self-review overlay** -- applies to exactly one case: a recording of a
round the operator themselves sat, reviewed against their own profile and claims ledger. Everything
before it applies to any recording.

## FIRST: what kind of recording is this

**The output of this skill is an ANALYSIS OF THE RECORDING'S SUBJECT, not a report about the
measurements you took.** Measurement is how you learn things; it is not the deliverable. A report
whose body is pace, silence and pixel statistics -- with a paragraph of actual content -- has
failed, no matter how correct the numbers are.

Classify before measuring, because it decides where the effort goes. Say which class you picked and
why, in one line, before computing anything.

**Interaction-bearing recordings** -- multiple participants where the SUBJECT IS THE EXCHANGE: a
meeting, panel, podcast, call, negotiation, pair-programming session, interview, discussion. This
is what this package is for. Talk-share, turn-taking, silence per phase, prosody and reaction
reading are the main event; content analysis is the supporting layer.

**Working recordings** -- live coding, pair programming, a walkthrough, a SQL or notebook session:
anything where an artifact is on screen and being built. **The frame pass is the main event, not a
side channel.** The reason is specific and was learned expensively: an audio-only pass on a
technical session concluded the work was largely unfinished and blamed a vague "detour". The frames
showed the problem had been SOLVED, that the entire multi-minute stall came from one bracket in the
participant's own data-loading code shaping the target array wrong, that they SAID "let me print the
shapes" while actually running `len()`, and that an on-screen assistant panel had already handed
them the correct root cause which they never acted on. **None of that is audible.** Two findings
flipped and the overall assessment changed substantially.

**Mixed recordings are common and must be split at the phase boundary, then measured separately.**
A single set of numbers across a session that was half conversation and half coding describes
neither half.

**Content-bearing recordings** -- one presenter, where the SUBJECT IS THE MATERIAL: a tutorial,
talk, lecture, demo, screencast, code walkthrough. **This is the wrong package.** Use
`watch-video-max`, which is built for exactly that and will reconstruct the artifacts properly.
Running the behavioural machinery here on a single-presenter edited screencast produces degenerate
numbers by construction -- measured on 2026-08-29 across two such sources, EVERY behavioural metric
was degenerate and all the useful output was content. Speech density read 99% and 96%; that number
describes the EDITOR, not the speaker.

**If you are unsure, the recording is content-bearing** -- that is both the more common case and the
one where getting it wrong is more costly. A viewer who wanted the material explained and received a
statistics sheet about the speaker got the worst possible trade.

**A degenerate metric is reported in one line and dropped, not explained at length.** "One speaker,
so talk-share carries no information" is the whole entry. Do not spend a section justifying a
measurement that could not have said anything.

## The metric passes

### 1. Talk-share and turn-taking

Per speaker: total speaking time, word count, share of each. Report the split as a ratio, not a
percentage alone -- "69/31" carries more than "69%". This is about understanding conversational
dynamics, not scoring a participant: a 69/31 split and an 8.5-minute monologue were the core
evidence for one session's imbalance.

**Failure mode: attribution.** With a speaker-separated export this is exact. Without one it is an
ESTIMATE derived from content plus frame sampling, and it must be labelled as one everywhere it
appears, including in the HTML report. An estimate presented as a measurement is worse than no
number.

**Failure mode: audio capture.** If the capture check in `../SKILL.md` found one side missing,
every number in this section is void. Say so and stop; do not compute a share of a conversation you
only half recorded.

### 2. Continuous monologue blocks

The longest uninterrupted run by each speaker, and every block at or above 60 seconds. **This is
usually the single most actionable number in the report.** Talk-share can look reasonable while
hiding one nine-minute answer, and a nine-minute answer is a different problem from consistently
talking slightly too much.

Report: count of blocks >= 60s, the longest, and where each sat in the recording. A long block early
means something different from a long block on the hardest question (flailing) or at the close (not
letting the session end).

### 3. Disfluency counts

Count "um", "uh", restarts and abandoned clauses.

**Use the speaker-separated export if one exists.** Meeting transcribers typically keep fillers;
whisper's VAD strips most of them. Counting from whisper alone under-reports, sometimes severely.
If whisper is the only source, count anyway and state plainly that the figure is a floor.

**Void on an OCR transcript.** Captions never show fillers. If the transcript came from
`[OCR-from-frames]`, this section is a NULL, not a zero. A zero here reads as a clean result.

Normalise per minute of that speaker's own speech, not per minute of the recording -- otherwise the
number moves when someone else talks more.

### 4. Silence and pace, PER PHASE

**Compute per phase and never as a whole-recording average.** The single most diagnostic number
from one session was 43.2% silence in a live-coding window against 7.8% in the theory-discussion
window of the SAME recording and 2.7% in a talk-only technical segment recorded the same day. A
whole-recording average would have hidden all three.

```bash
${WV_FFMPEG} -hide_banner -nostats -i <video> -af silencedetect=noise=-35dB:d=1.5 -f null - 2>&1 \
  | grep silencedetect
```

**Two traps in that one command.** Capture with `-hide_banner -nostats ... 2>&1 | grep
silencedetect`; a bare `2>&1 | grep silence_start` can come back EMPTY because the progress stream
swallows it. And an empty parse silently yields "0.0% silence", which reads as a clean result rather
than a broken measurement. **Sanity-check that the event count is non-zero before believing any
silence figure.**

Interpretation is directional, not absolute:
- **Zero long silences** is not automatically good. It can mean no dead air, and it can equally
  mean no breathing room -- filling every pause is itself a finding.
- **High silence in a coding window** is only a problem if someone asked for think-aloud. Check
  whether they did before calling it one.

On any live-coding segment, compute the coding window separately from everything else.

### 5. Prosody and delivery: what is measurable, and what is not

**Whisper does not measure tone, emotion, or affect.** It is a speech-to-text model: it returns text
and timestamps. Any claim about how something SOUNDED has to come from the signal itself or from a
separate model. Do not let a transcript's wording stand in for delivery -- reading "I'm not sure" as
hesitant is an inference from words, not a measurement of voice.

Three tiers, in increasing cost and decreasing reliability. Run tier 1 always.

**TIER 1 -- SPEECH RATE AND PACE. Free: the data is already in the transcript. ALWAYS RUN THIS.**
Every whisper segment carries `start`, `end` and text, which is a delivery measurement nobody has to
install anything for:

```python
# words per minute per segment, from the transcript already produced
import re
out = []
for start, end, text in segments:          # (start, end, text) from the whisper segments
    words = len(re.findall(r"[A-Za-z0-9']+", text))
    dur   = max(end - start, 1e-6)
    out.append((start, words / dur * 60.0))
```

Report pace **per phase**, the same way silence is, and against the speaker's OWN baseline rather
than an external "normal" -- conversational English spans roughly 120-180 wpm and individual
baselines vary far more than the signal you are looking for. What carries information is the DELTA:
a phase running well above that same speaker's median indicates rushing. The useful cross-check is
whether the fast phases coincide with long monologue blocks and low-silence windows. **Pace,
monologue length and pause structure are three views of one behaviour** and are far stronger read
together than separately; a change in one without the others usually means a measurement problem
rather than a behavioural one. Note that whisper's VAD strips hesitation sounds, so wpm computed
this way slightly understates true syllable rate.

**TIER 2 -- PITCH AND ENERGY DYNAMICS. Requires diarization first, and that is not optional.** This
is the tier that answers "was the delivery monotone or modulated": fundamental frequency (F0) mean
and especially F0 VARIANCE over a speaker's own segments, plus RMS energy dynamics. Modulation is F0
variance; a flat pitch contour across a long answer is the measurable form of "monotone".

The blocker is attribution, not extraction. These recordings are often a single mixed track with
multiple parties on it, so F0 statistics computed over the whole file measure a blend of voices and
mean nothing about any one speaker. **Diarize first** (pyannote.audio is the usual tool), attribute
segments to speakers, then compute per-speaker statistics over that speaker's segments only. F0
extraction needs a pitch tracker -- librosa's `pyin` or praat/parselmouth are the standard choices;
neither is a heavy install, but see the dependency policy in `../README.md` before adding them to a
shared interpreter.

**Without diarization, tier 2 output is not weak evidence -- it is invalid, and must not be reported
at all.** On mixed-mic audio with no diarization, every tone claim is HYPOTHESIS-grade and derived
from content and frames, not from the signal. Say which it is.

**TIER 3 -- CATEGORICAL SPEECH EMOTION RECOGNITION. Available, and deliberately NOT recommended.**
wav2vec2-style SER classifiers will happily emit "angry 0.72" for any audio you hand them. They are
trained largely on acted emotion corpora, they degrade badly on spontaneous conversational speech
recorded through a laptop microphone and compressed by a meeting platform, and they have no notion
of who is speaking unless you diarize first anyway. The failure mode is the dangerous kind: a
confident-looking label that is close to noise, entering a document that informs real decisions.

If you run one anyway, treat every output as HYPOTHESIS, never as a finding; report the model name
and its training corpus alongside any number; and check it against the frames, because a visible
expression at the same timestamp is stronger evidence than a classifier score. An honest "the audio
cannot answer this" remains a valid and preferable result.

### 6. Screen-share and live-coding: THE FRAME PASS IS THE MAIN EVENT

After one pass that leaned on audio and sampled only about 14 frames of a 65-minute technical
session, the follow-up finding was that a technical or live-coding segment needs much more frame
analysis than audio, precisely because the content is technical. For any segment where code is on
screen, budget effort accordingly and compute these FROM PIXELS (the reference case worked from
1280x1392-class frames at 5 fps):

- **Screen-mode classification per second FIRST** (call UI vs notebook vs SQL editor vs slides vs
  browser), from mean brightness of two or three fixed probe regions. **Every later region metric is
  meaningless until you know which application was foregrounded** -- a naive "editor" crop during a
  call-UI segment measures webcam motion and reports it as typing.
- **Typing activity = mean absolute pixel delta of the editor region between consecutive samples**,
  with a small threshold. This separates "thinking quietly" from "not typing": in one measured
  session it read 14.0% typing across a coding window and 3.6% across a SQL window of the same
  recording.
- **Errors on screen = fraction of reddish pixels in the editor region** (r>70, r-g>25, r-b>25),
  giving total red-on-screen time and per-episode durations -- 4.8 minutes total, one 162-second
  block, in the reference case. **THIS METRIC IS THEME- AND LANGUAGE-DEPENDENT AND MUST BE
  CONTROLLED BEFORE IT IS BELIEVED.** It was derived from one setup where errors surfaced as red
  underlines and the visible code happened to contain few string literals. On a 2026-08-28 run
  against an editor whose theme paints string literals a warm salmon, the test matched the literals
  instead of the errors and inverted completely: the frame with the MOST red (0.372%) had ZERO
  problems reported by the editor, while the frame that genuinely had three problems showed five
  times less red (0.075%), and a frame with no literals and no problems read 0.000%. The metric was
  anti-correlated with what it names.

  **Control it like this, every time, before reporting a single red-derived number:** find two or
  three frames where the editor's own problem/error counter is legible (most editors show it in a
  status bar), and check that the red fraction tracks that counter. If it does not, the heuristic is
  measuring syntax highlighting on this material -- discard it and read the editor's counter
  directly, which is the value the heuristic was only ever standing in for. Reporting red-pixel
  episodes without this control produces confident, precisely-quantified nonsense.
- **Read the actual code at every transition**: crop the editor region and upscale ~2.5x with
  LANCZOS before viewing (shared technique, see `watch-video-max/SKILL.md`) -- otherwise the text is
  unreadable.
- **Read any on-screen assistant or chat panel too.** Some screen-share sessions include an
  on-screen AI assistant or chat panel; it is a verbatim record of what was asked and what the
  participant was told, and it timestamps their real diagnostic state at that moment. In the
  reference case it contained the answer they never used.
- **Reconstruct the artifact and then REVIEW it.** Recover the code as it evolved and check it: did
  it actually work, were the recovered values right, what did the other participants see at each
  point. A session can be scored as unfinished by an audio pass and be finished in the frames.
- **Separate "thinking quietly" from "stuck".** Typing activity plus silence plus what is on screen
  distinguishes them; none of the three does it alone.

### 7. Micro-expression bursts and reactions

Use the three-tier frame escalation defined in `watch-video-max/SKILL.md`. **Do NOT read a fleeting
reaction off the coarse 0.75 fps arc sheet alone** -- that tier LOCATES the moment; the dense burst
(15 fps) is what RESOLVES it. Micro-expressions need the denser pass to resolve at all, which is why
`${VA_FPS}` has a 5 fps floor.

Visual-affect claims cite specific frames or bursts, by number and timestamp. A confident reading of
a 3-pixel face is not a finding.

### 8. ASR-vs-diction discipline

Before logging a "pronunciation slip" or a transcription error, check the SAME phrase in the
verbatim whisper tier -- in one case a platform transcript's ASR heard a nonsense phrase where
whisper large-v3 heard the correct words cleanly. **Only log slips that BOTH engines mangle.**

**The rule needs two engines, so establish that you have two before applying it.** A second reading
exists only when `${WV_TRANSCRIPT_DIR}` holds a platform or meeting-tool export for THIS recording.
When there is none, diction is UNMEASURED: say so and log nothing. A rule that quietly degrades
into "log every slip" the moment its second input is missing is worse than having no rule, because
it reads as a measurement.

**Where the term is visible on screen, the FRAMES outrank both engines** -- a shared document, a
slide, a repository page or a terminal settles it outright. This is the same adjudication
`watch-video-max` runs as its caption cross-check, and that package's measurement is worth carrying
here: neither engine is reliably the better one. On a 2026-08-30 run the verbatim whisper tier
misheard the central product name in 12 of its 21 occurrences while the platform captions had it
right in 21 of 22, and a separate term that NEITHER engine spelled correctly was legible on screen
throughout.

## Triggers -- what sends you to the frames

The guided-read mechanism (walk the transcript start to finish, escalate to frames wherever words
alone do not settle what happened, three-tier escalation) is defined once in
`watch-video-max/SKILL.md`. This package sends you there whenever any of the following appear -- the
list is a floor, not a ceiling:

- **Deictic language from any participant**: "as you can see", "this function", "right here", "that
  error", "this diagram". The referent is on screen and nowhere in the words.
- **Anything shown rather than said**: a diagram, an architecture slide, a chart, code being typed
  or run, terminal output, a shared document. If the transcript says a diagram is on screen, READ
  THE DIAGRAM -- do not paraphrase what the speaker said about it.
- **A challenging or pointed question to any participant.** Check that participant's face as it is
  asked and for 2-3 seconds after the answer starts; that is where genuine reactions live.
- **A participant hedging, expressing doubt, or making a self-critical remark.** Read the reaction,
  not just the words.
- **Laughter, jokes, rapport peaks, and interruptions.** Who interrupted whom, and how it was
  received.
- **Long silences flagged by silencedetect.** Silence is ambiguous in audio and unambiguous on
  screen: thinking, reading, stuck, or typing are four different pictures.
- **Screen-share transitions.** Every one -- they bound the phases every later region metric depends
  on.
- **A claim about work, a result, a number, or a decision.** If the artifact is on screen, verify
  the claim against it.
- **Ambiguous speaker attribution**, especially with no speaker-separated transcript: the platform's
  active-speaker UI in the frames resolves it.
- **The closing segment**, where next steps and commitments are agreed. This is routinely skipped
  because the content sounds like admin, and it is some of the highest-signal footage in the
  recording.

Lookup: second `t` -> `${WV_WORK_DIR}/<slug>_frames/f_{t*VA_FPS+1:06d}.jpg`. **Calibrate the
transcript-to-video offset FIRST** (`../SKILL.md` Step 3) or every lookup lands in the wrong place.

**The bar:** every flagged moment is resolved or explicitly recorded as unresolved. Keep running
notes as you go -- moment, what the words claimed, what the screen showed, whether they agree.
**Disagreements between what was said and what was shown are the highest-value findings this
package produces.** An honest "the frames cannot answer this" is a valid result.

## The report -- what it must CONTAIN

Every run, whatever the recording:

- **The analysis of the subject**, first and longest. What happened, what it means, what the
  exchange actually was.
- **Talk-time and turn-taking summary**, per speaker, with the evidence numbers -- or one line
  saying it is degenerate and why.
- **Notable moments and reactions**, quoted from the transcript with timestamps and cited to the
  frame or burst that shows the reaction: what landed, what fell flat, how it was received. An
  assertion that something "landed well" with no frame behind it is a guess about another person's
  interior state.
- **Silence, pace and prosody findings, reported PER PHASE**, with the raw numbers stated alongside
  any interpretation, and each tagged with the tier that produced it.
- **Screen and technical findings**, if the recording included a screen share: screen-mode timeline,
  typing activity, on-screen errors (controlled, per section 6), and what the code or artifacts
  actually showed.
- **Narration-vs-screen discrepancies**: every place the words and the screen disagreed, with both
  sides quoted or described.
- **Limitations**: every preflight warning, every degraded metric, every honest null, each with what
  it prevented the report from concluding. **An honest NULL is a valid result.** In one session gaze
  analysis could not distinguish reading from thinking because the head angle was uniformly
  down-tilted with no contrasting baseline; reporting that plainly, with a stated confidence, was
  worth more than a fabricated percentage.

Tag every causal claim `VERIFIED(<command or artifact>)` or `HYPOTHESIS`. The confidence bar applies
to what gets WRITTEN into a living document, not only to what is said in chat.

## The self-review overlay

**This section applies ONLY when the recording is a round the operator themselves sat, and their own
performance is the question.** `../SKILL.md` Step 0 forces that decision before any measurement; do
not open this section on a third-party recording. The apparatus below assumes the operator owns the
profile, the ledger and the history it compares against, and it is meaningless without them.

Each item runs only where the corresponding config key is set. Where one is not, say so in the
report rather than skipping silently.

### Outcome estimate

A probability of advancing, as a range, with the evidence that produced it quoted and timestamped.
Anchor it in what happened IN THE ROUND.

**NEVER infer an outcome from downstream thread state.** A later-stage round being scheduled does
not prove an earlier one cleared -- that inference was made once, upgraded two rounds from
hypothesis to "confirmed pass", and the premise turned out to be false on checking: nothing had been
scheduled and the thread had been silent for a week.

### Behavioural check

Against `${VA_PROFILE_PATH}`. The profile carries the operator's known patterns and their standing
rules -- what they have decided in advance to disclose or refuse.

- **Promote a pattern to "confirmed" only when it repeats across rounds.** One occurrence is a data
  point, not a trait.
- With no profile configured, report this round only and state plainly that no trend can be
  established. Do not imply one from a single round.
- Check the standing rules as rules: were they held or broken, and where.

Recurring axes worth checking every round, whatever the profile says:

- **Verbosity** -- the most common confirmed flaw in this genre. Read talk-share, monologue blocks
  and speech rate together.
- **Compensation discipline** -- was a number stated, and did it match the position decided before
  the round.
- **Reverse questions** -- were any asked, and were they substantive or filler.
- **Self-undercutting** -- volunteered weaknesses, financial pressure, apology framing, hedging on
  claims that were true.
- **Prep deployment under pressure** -- was prepared material actually used when the moment came,
  or did it evaporate.

### Claims-ledger consistency

Every round creates facts that later rounds must not contradict: numbers, dates, scope of
responsibility, tool ownership, availability, compensation. Compare what was said this round against
the ledger in `${VA_ROLES_DIR}/<role>`.

- Flag every contradiction with both versions quoted.
- Flag every NEW claim, so it enters the ledger and future rounds stay consistent with it.
- A claim made loosely in a screen share is still a claim.

### Assist dependence

Measured by n-gram overlap between an assist-tool log and what was actually said, or explicitly
**UNMEASURED**. There is no third option. See `../SKILL.md` Step 4 -- the categories matter, the
absence of a log proves nothing, and inferring from anything else has produced a retraction.
