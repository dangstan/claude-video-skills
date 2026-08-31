
# video-autopsy: "Ex-Uber Dev Explains His Multi-Agent Workflow" (2026-08-10)

Provenance tags used throughout: `[TRANSCRIPT hh:mm]` quoted verbatim from the whisper transcript |
`[FRAME n / mm:ss]` read directly from extracted-frame pixels | `[MEASURED]` computed, method named |
`[HYPOTHESIS]` inference from partial evidence | `[NULL]` the evidence available could not answer it.

> **Redaction note, added for publication -- not run output.** This is otherwise unmodified run
> output. Five clauses are withheld and marked in place: the local path of the recording (Header),
> and four marked `[... redacted for publication]` -- in the Attribution-method bullet, the
> Diction/ASR bullet, and two Limitations entries. Each described the run's own operating
> environment or the instructions given to the run: the operator's tooling and directory layout,
> host load, and a scoping instruction. All of it is external to the subject by construction and
> none of it is evidence about the recording or its participants; the finding each clause supported
> is published in full.

## Header

- **Recording:** "Ex-Uber Dev Explains His Multi-Agent Workflow", YouTube interview/podcast, published
  2026-08-10, duration 00:45:25.09 (2725.09s, ffprobe-confirmed). Analyzed from a
  local copy (path redacted for publication).
- **Participants:** Florent "Flo" Crivello (guest; founder of Lindy; previously at Uber) and a host
  named David. Two-person, talking-heads podcast/interview format with individual webcam shots
  (not split-screen), heavy motion-graphic/b-roll overlay editing, and three screen-share segments.
- **MODE 1 (Step 0a):** EXCHANGE, not material. Verified before frame spend: the transcript shows
  genuine question/answer turn-taking between two named speakers, direct address by name in both
  directions ("All right Flo...", "...David"), and three embedded screen-share demos. This is an
  interaction-bearing recording (interview) per the skill's own classification -- correctly routed to
  `video-autopsy`, not `watch-video-max`.
- **MODE 2 (Step 0a):** THIRD-PARTY. The operator is not a participant. The self-review overlay does
  NOT apply: no outcome estimate, no touching the operator's behavioural profile, roles directory, or
  tracker. Document-update section (profile/roles/tracker appends) is SKIPPED in full for this reason.
- **Transcript tier:** Verbatim faster-whisper large-v3, REUSED from a prior `watch-video-max` pass on
  this same file (not re-transcribed). Quality-gated PASS: continuous coverage 00:00:00.08 ->
  00:45:24.98, no gaps, no repeated-gibberish spans, coherent throughout a full read of all 1277
  segments. `[MEASURED]`
- **Audio-capture check:** `[MEASURED]` whole-file volumedetect: mean_volume=-28.4dB, max_volume=-3.0dB.
  Per-channel astats RMS: channel 1 = -26.842dB, channel 2 = -26.841dB -- effectively identical, safe
  mono downmix, NOT a duplicated/echoed track (ratio far below the 1% same-signal threshold). Both
  speakers audible throughout; no side silently missing. Talk-time/pace numbers below are valid.
- **Attribution method:** ESTIMATE, not diarization. No platform/meeting-tool transcript export exists
  for this recording `[operator-environment detail redacted for publication]`; this is a
  third-party YouTube video, so its absence is EXPECTED, not a gap. Speaker identity for the two participants was established from ON-SCREEN evidence:
  `[FRAME / 09:12-10:45]` a personalized in-app page reads "Here's what I'm learning about you, Flo"
  while the small picture-in-picture narrator is the same plain-gray-background, headphones,
  nose-tape-across-the-bridge speaker throughout the recording -- this fixes that speaker as Flo
  Crivello. The remaining speaker (beard, glasses, brick-wall-and-window background, standing
  broadcast mic) is David, the host. Per-line turn attribution (who said which clause) was NOT
  attempted at full fidelity -- see "Talk structure" below for what was actually measured instead, and
  the Limitations section for what this means for talk-share numbers.

> **DEFECT NOTE, added for publication -- not run output.** The face-to-name mapping in the bullet
> above is INVERTED, and the error propagates through every visual attribution in this document.
> The nose-tape / headphones / plain-gray-background speaker is **David**, the host; the
> beard-and-glasses speaker at the broadcast mic is **Flo Crivello**, the guest. Three independent
> lines of evidence settle it, none of which the run used:
>
> 1. `[TRANSCRIPT 00:00:37.98]` "I compare it all the time to like, you know, I don't know if
>    you're old enough David" -- spoken by the guest, addressed to David, and the two men differ
>    visibly in age. The younger of the two is therefore David.
> 2. `[FRAME / 02:50-05:30]` the Deep API dashboard in the sponsor segment reads
>    **SIGNED IN david@davidondrej.com**, and the only webcam on screen through that whole segment
>    is the nose-taped speaker. The ad copy closes "go to deepapi.co or click the first link below
>    the video" -- a channel owner's line, not a guest's.
> 3. Both sibling runs of this same source disagree with this document and agree with each other:
>    the `watch-video` knowledge document names the host "David Ondrej" and files the segment as
>    "the video's own paid sponsor", and the `watch-video-max` one states that "the **interviewer**
>    runs a sponsored segment".
>
> The run reached its mapping by reading the wrong one of the two webcams inset beside a
> screen-share: "Here's what I'm learning about you, Flo" is Flo's own Lindy account, shown during
> Flo's share, with BOTH participants' cameras on screen at the time. Consequences carried below:
> the paid Deep API read is attributed to Flo when it was delivered by David; the "david"-prefixed
> API keys are logged as an unresolved ownership question that the same frames answer outright; the
> nasal-strip observation describes David, not Flo; and the `[TRANSCRIPT 00:07]` example under
> "What landed" quotes "Do you have a team David?", which is at 00:01:20 and is spoken TO David, not
> by him. What does NOT change: the measured numbers (silence, wpm, monologue blocks, disfluency
> counts) never depended on which face carried which name, and the finding that a produced sponsor
> segment is spliced into the conversation invisibly to a transcript-only read stands -- only the
> person delivering it is wrong. Flagged rather than rewritten; these examples are unmodified run
> output.

- **Frame rate:** 5 fps floor across the full 45m25s (13,631 frames extracted), with additional targeted
  tiled contact sheets at 0.1-0.3 fps effective sampling over the three screen-share windows, the
  opening, and the close.
- **Diction/ASR-mishearing analysis (evaluation.md section 8):** UNMEASURED. Only one transcript-engine
  reading exists for this run (verbatim whisper large-v3); this run does not
  pursue a second engine (e.g. YouTube's own captions) even though one might be fetchable
  `[run-direction detail redacted for publication]`. No slips are
  logged.
- **Self-review overlay / document updates:** SKIPPED IN FULL (third-party mode). No outcome estimate,
  no behavioural-profile check, no claims-ledger pass, no document writes.

## The analysis of the subject

This is a guest-expertise interview, not a balanced conversation, and every measurable axis in this
autopsy points the same direction: David asks short, well-aimed questions and Flo answers at length,
often for minutes at a stretch, with David's on-record contribution largely limited to prompts and
brief agreement ("100%", "Yes", "That's exactly right", "A hundred percent"). That shape is normal and
expected for the format -- a founder being interviewed about his own product and workflow -- and is not
itself a finding of anything gone wrong. What IS worth reporting is how extreme and how *uniform* the
imbalance is: there is no phase of the 45 minutes where the dynamic meaningfully changes. The opening
exchange, the two product-demo screen-shares, the personal-workflow discussion, the AGI/existential-risk
tangent, and the closing sign-off all show the same pattern -- Flo carries the content, David steers.

The recording's most interesting structural feature is not in the words at all: a produced,
screen-shared sponsor/product-integration segment for a tool called "Deep API" is embedded directly
inside what a transcript-only read would present as one continuous Flo answer about agentic software
`[FRAME / 02:50-05:10]`. Read from the transcript alone, "I hold the belief that soon enough 99% of all
software usage... will be done by agents" flows without any marked break into "this is exactly what I
spent the last two months building with Deep API... go ahead and go to deepapi.co" -- a pivot from
philosophical claim to a scripted call-to-action with a dashboard screen-share, a "What is DeepAPI?"
title card, and pricing detail, delivered by the SAME on-screen narrator (Flo, confirmed by face and
background match to the other two screen-share segments) `[FRAME / 03:10, 03:55, 04:40]`
**[WRONG SPEAKER -- the segment is delivered by David, the host; see the defect note in the Header]**. A
listener working from audio or transcript alone would have no signal that the register changed from
organic answer to integrated promotional copy; only the frames show it. See "Screen and technical
findings" below for the full read, including a naming detail (on-screen API-key labels reading
"david-hermes-agent" / "new-david-global-key") that is flagged but NOT resolved.

The second most interesting structural feature is the near-total absence of dead air. Silence
detection at a 1.0-second threshold found essentially zero qualifying pauses across every phase sampled
(see "Silence and pace" below) despite a speech rate that runs 215-272 words/minute blended across both
speakers in every phase -- well above the 120-180 wpm conversational baseline the evaluation reference
cites, and with no phase standing out as slower or more relaxed than any other. Together these two
measurements (near-zero silence, uniformly fast pace) describe a tightly cut edit that has trimmed
natural breathing room throughout, not a naturally paced conversation that happens to be brisk in
places. That is a legitimate finding about the recording's editing, not about either speaker's live
delivery, and it is stated as such.

## What landed and what did not

Reaction-reading is limited by format: this is two single-person webcam feeds, not a shared room, so
neither speaker's reaction to the other is visible in the same frame the way a two-shot would show it.
Within that limit:

- The close reads as warm and low-friction. `[FRAME / 44:30-45:11]` David is visibly smiling and using
  open, appreciative hand gestures through the sign-off ("Thank you so much for having me, David." /
  "Thank you as well."); Flo is more visually reserved/neutral but shows no sign of discomfort or
  wanting to end early. No awkward beat is visible at the close, which the skill flags as commonly the
  highest-signal footage -- here it is unremarkable, which is itself the finding: nothing about the
  ending contradicts the friendly tone of the rest of the recording.
- Several of David's short interjections land as genuine engagement rather than filler -- e.g. `[TRANSCRIPT 00:07]` **[WRONG -- this line is at 00:01:20 and is spoken TO David, not by him; see the defect note in the Header]** "Do you have a team David?" / "Yes." / "Are you experiencing the same thing?" is a real, if brief, exchange rather than a pure backchannel, and the Slack screen-share at `[FRAME / 07:16]` shows David granting the screen-share ("Yeah, of course.") before Flo starts narrating -- a real, if small, negotiated moment rather than an edit-around.
- `[NULL]` Whether the audience-facing aside at `[TRANSCRIPT 00:03:19]` "I promise to your viewers this isn't set up" was received as reassuring or as itself slightly undercutting the demo's spontaneity cannot be read from the available evidence (no visible audience, no comment-track). Logged as a genuine unresolved moment, not guessed at.

## The metric passes, per phase

Six phases were used, keyed to the recording's own structure rather than arbitrary time buckets:
P0 teaser/cold-open (00:00-00:24), P1 opening exchange (00:24-02:35), P2 sponsor/Deep-API
screen-share segment (02:35-05:28), P3 product-demo block / two back-to-back screen-shares
(05:28-10:45), P4 extended discussion (10:45-44:48), P5 close (44:48-45:25).

### 1. Talk-share and turn-taking

`[HYPOTHESIS]` No reliable percentage split is reportable. This recording has no platform transcript
export (expected -- third-party YouTube source) and diarization tooling was not run, so any
line-by-line speaker split would be a guess dressed as a measurement. A first attempt at a
content-signal proxy (flagging lines that address a participant by name or match host-style question
phrasing) returned a 98.6%/1.4% split in Flo's favor -- implausibly extreme, because it only catches
David's explicit-address and fixed-phrase questions and misses the much larger volume of his short,
unaddressed backchannel words ("Yeah," "100%," "Exactly"). That number is reported here only to be
explicitly REJECTED as unreliable, not used. What IS measurable and defensible is the monologue-block
statistic below, which measures the same underlying imbalance from a angle that does not require
attributing every line.

### 2. Continuous monologue blocks -- MEASURED, the single most actionable number here

Method: treat every transcript line ending in "?" as a probable David-question turn boundary (135
such lines across the recording), and measure the question-free stretches between them as candidate
single-speaker (Flo) runs. `[MEASURED]`

- 10 distinct stretches of 60 seconds or longer with no question asked, totaling 970.6s = **16.2
  minutes**, or **35.9% of the live interview** (excluding the 23.6s cold-open teaser).
- Longest: **00:14:32.54 -> 00:17:41.92, 3.16 minutes** unbroken, covering Flo's "an agent with context
  can tell you a decision doesn't matter" anecdote through his "the web UI is dying" multiplayer-future
  prediction `[TRANSCRIPT 00:14:32-00:17:42]`.
- Second-longest: 00:03:58.16 -> 00:07:06.88, 3.15 minutes -- this stretch straddles the tail of the
  Deep API sponsor segment and the opening of the Slack screen-share, i.e. two different registers
  (ad copy, then organic product description) that the question-mark proxy cannot distinguish. Flagged
  as a proxy limitation, not silently merged.
- A manually-read ~4-minute stretch around 00:33:18-00:37:33 (the "fuck your calendar... reinvent your
  company" riff, read in full during the guided read) does NOT appear as one block in the algorithmic
  list -- the proxy method split it at an intervening question mark the eye-read did not weight the
  same way. The algorithmic number is trusted over the manual read for this report; the discrepancy is
  logged so a later pass with real diarization can reconcile it.

### 3. Disfluency counts -- floor only

`[MEASURED]`, explicitly a floor per the skill (whisper's VAD strips most fillers): whole-file,
case-insensitive whole-word count = **10 "uh"/"Uh", 3 "um"/"Um", total 13** across 45m25s, blended
across both speakers (no platform export exists to separate them). Per-phase breakdown was not
computed separately -- at this density (13 tokens across 2725 seconds) phase-level splitting would not
be statistically meaningful. This count is void as a measure of either speaker's true disfluency rate;
it is only useful as a floor and as one more data point consistent with heavy post-edit cleanup (a
raw, unedited 45-minute two-person conversation would typically show far more than 13 filler tokens
even after VAD suppression).

### 4. Silence and pace, per phase

**Silence** `[MEASURED]`, ffmpeg silencedetect at -35dB / 1.0s minimum duration, sanity-checked non-zero
on a control window before trusting any zero result:
- P1+ opening span (00:00-09:10, includes P0/P1/P2 and the start of P3): **1 event**, 1.03s, at
  00:00:22.6 -> 00:00:23.6 -- exactly the cut from the cold-open teaser into the live interview. No
  other qualifying silence in over 9 minutes of material.
- Hydration-demo screen-share window (09:10-11:20): **0 events**.
- Close (44:30-45:25): **0 events**.
- Mid-conversation block (11:20-44:30, the bulk of the recording, ~33 minutes): **1 event**, 1.07s, at
  00:32:44.54 -> 00:32:45.61.

**Whole-recording total: 2 qualifying silences (>=1.0s) in 45m25s of material** -- one at the
teaser-to-interview cut (00:00:22.6), one mid-conversation (00:32:44.5). Every other transition in the
recording, including three screen-share cuts and dozens of speaker-turn boundaries, produced no gap the
detector could register at this threshold. This is the strongest single piece of evidence for the
"tightly cut edit" reading above -- a naturally paced 45-minute two-person conversation would ordinarily
show far more than two qualifying pauses.

**Speech rate (TIER 1, always run)** `[MEASURED]` from transcript timestamps, words/minute blended
across both speakers per phase (a per-speaker split was not available, see Talk-share above):

| Phase | Duration | Words | wpm (blended) |
|---|---|---|---|
| P0 teaser | 23.6s | 107 | 272.3 |
| P1 opening exchange | 131.4s | 512 | 233.8 |
| P2 sponsor/Deep API segment | 172.8s | 621 | 215.6 |
| P3 product-demo block | 317.2s | 1185 | 224.1 |
| P4 extended discussion | 2043.2s | 8078 | 237.2 |
| P5 close | 36.8s | 140 | 228.5 |

Every phase sits well above the 120-180 wpm conversational baseline the evaluation reference cites, and
the spread across phases (215.6 to 272.3) is narrow -- there is no phase that reads as meaningfully
slower or more deliberate than any other. Read together with the silence result, this describes a
uniformly fast, tightly-edited recording rather than a conversation with a naturally varying rhythm.
Whisper's VAD strips hesitation sounds, so true syllable rate is understated slightly further still.

**Prosody (TIER 2/3)**: `[NULL]`. Not run. Per the skill's own rule, F0/pitch-variance analysis without
diarization is invalid, not merely weak, on mixed-mic audio with two speakers; no diarization was
performed for this run, so tier 2 and tier 3 are both logged as NULL rather than attempted.

## Screen and technical findings

Three screen-share segments were identified and read from pixels:

1. **Deep API sponsor/product segment, ~00:02:35-00:05:27.** `[FRAME / 03:10-04:40]` Full-screen dark-
   themed product dashboard (API key list, spend/request/success-rate tiles, an "Active credentials"
   table) with Flo's own webcam as a small circular picture-in-picture in the corner. Screen contents
   visible and legible at 2.5x crop: account labeled with API keys named "new-david-global-key" and
   "david-hermes-agent", a Gmail inbox showing a received automated email, and a closing "What is
   DeepAPI? / What's your email?" title-card pair consistent with a produced ad unit rather than an
   improvised live demo. `[HYPOTHESIS]` The "david"-prefixed key names could indicate the demo account
   belongs to David rather than Flo, which would mean the account shown is not the on-screen narrator's
   own -- but the account owner is never stated on screen and this is not resolved; logged as
   unconfirmed rather than asserted either way.
   **[WRONG -- the account owner IS stated on screen: the dashboard reads "SIGNED IN
   david@davidondrej.com", and the on-screen narrator here is David. See the defect note in the
   Header.]**
2. **Product-demo block, ~00:07:16-00:10:45**, two back-to-back demos narrated by Flo via PiP:
   - **Slack "Lindy Teammate" thread, ~07:16-09:12** `[FRAME / 07:50-08:40]`: a real Slack thread
     (usernames "Marvin Aziz", "Bruno Steven", "Flo") showing a teammate's question answered by the
     "Lindy" bot with a linked billing doc, plus an app-install permissions panel. Matches the
     transcript's claim `[TRANSCRIPT 00:07:19-00:07:29]` almost exactly -- no discrepancy found here.
   - **"Automatic hydration" master-memory-file demo, ~00:09:12-00:10:45** `[FRAME / 09:30-10:10]`: a
     personalized page reading "Here's what I'm learning about you, Flo" beside a live "How your team
     connects" node graph, a Slack-thread excerpt discussing onboarding calls, and a "Memory" sidebar
     listing concrete standing instructions ("Text me if our CEO sends me an email", "Ask before
     booking over my 1:1 with Bob", "Make sure Monday mornings are free"). This matches the transcript's
     description of an agent-maintained memory file closely; no narration-vs-screen conflict found.
   - **CORRECTION to a prior pass's timestamp.** A previously produced `watch-video-max` knowledge
     document for this same file labels the hydration-demo screen content as occurring at "src
     12:40-13:30". Recalibrating against this video's own timeline (per the skill's explicit warning
     that timestamp offsets are not constant across passes) places the actual on-screen hydration demo
     at 00:09:12-00:10:45 -- roughly 3.5 minutes earlier than that label. The content match is otherwise
     exact, so this reads as a source/offset mismatch from the earlier pass (likely a different timeline
     reference, e.g. an unedited source cut) rather than a wrong identification of the segment itself.
     Anyone citing that earlier document's timestamp for this content should use the corrected one above.
3. **Closing segment, ~44:30-45:25** `[FRAME / 44:35-45:05]`: no screen-share, talking-heads only, David
   gesturing openly, standard sign-off with a URL call-to-action (lindy.ai).

**Typing-activity and on-screen-error metrics (evaluation.md section 6)**: `[NULL]`. Not applicable --
none of the three screen-shares show a code editor or live-coding surface; all three are product
dashboards, a Slack client, and a Gmail inbox. The red-pixel error heuristic was not run because there
is no error-surfacing UI in this recording to control it against.

**Visual observation, unresolved cause**: `[FRAME, all segments]` Flo **[WRONG SPEAKER -- this is
David; see the defect note in the Header]** has a visible strip of tape or a
nasal strip across the bridge of his nose in every frame throughout the recording. This is stated as an
observed visual fact only -- cause (medical tape, an over-the-counter nasal strip, cosmetic, or
something else) is `[NULL]`, not guessed at, and is not evidence of anything beyond what is visible.

## Narration-vs-screen discrepancies

This is the highest-value section this package produces, and there are two real findings:

1. **The Deep API segment's register shift is invisible in the transcript alone.** Detailed above under
   "The analysis of the subject" and screen-share finding 1. A transcript-only or audio-only read of
   this recording would present 00:02:35-00:05:27 as a continuous, organic answer about agentic
   software; the frames show it is a produced sponsor/product segment with its own title cards and
   call-to-action, delivered by the same on-screen speaker without any verbal hand-off cue.
2. **The prior knowledge document's screen-content timestamp does not match this video's own timeline**
   (detailed under screen-share finding 2). Not a discrepancy between narration and screen within THIS
   recording, but a discrepancy between two artifacts describing the same recording -- included because
   it is exactly the failure mode the skill warns is common ("the offset is NOT a constant, recalibrate
   every time") and because leaving it uncorrected would propagate a wrong timestamp forward.

## Limitations

- **Talk-share has no reliable measurement.** No diarization was run and no platform transcript export
  exists for this third-party recording. The monologue-block statistic (35.9% of the interview in
  >=60s question-free stretches) is the best defensible proxy produced here; it is NOT a percentage
  split and should not be read as one.
- **Diction/ASR-mishearing analysis is UNMEASURED** (single transcript engine only for this run
  `[run-direction detail redacted for publication]`).
- **Prosody tiers 2 and 3 are NULL**, not merely weak -- no diarization means no valid per-speaker pitch
  or energy measurement is possible on this mixed-mic audio.
- **Disfluency counts are a floor, not a rate**, and are not split by speaker.
- (Resolved during this run) Mid-conversation silence detection was slow under CPU contention
  `[host-environment detail redacted for publication]` but completed: 1 event, 1.07s, at 00:32:44.5. Whole-recording
  total is 2 qualifying silences (>=1.0s) in 45m25s -- see "Silence and pace, per phase" above.
- **Reaction-reading is limited by the single-webcam format** -- no shared-frame reactions are possible,
  only what each speaker's own feed shows during and after the other speaks.
- **The "david"-prefixed API-key naming in the Deep API demo is unresolved** -- flagged, not asserted
  either way about account ownership.
- **The self-review overlay and its document updates do not apply to this run** and were skipped in
  full, per Mode 2 = THIRD-PARTY.
