# Autopsy: tech company screening call, recruiter x candidate (2026-08-25)

> SANITIZED EXAMPLE: real output of a real run, with personal names, employers, company identifiers,
> compensation figures and private file references replaced or redacted. The source recording and
> transcript are withheld.

## Header

- **Recording**: local recording, 31m32s, Google Meet, OBS local capture (desktop + mic, one audio
  track).
- **Participants**: the recruiter -- Talent Acquisition & People Ops Manager, the company (an AI
  engineering studio and startup incubator) -- interviewing the candidate for Lead AI Engineer. A
  third non-participant, a notetaker bot, joined to record/transcribe; it never speaks substantively
  and is excluded from every talk-share and disfluency count below.
- **Date/time**: meeting started 2026-08-25 17:13:23 BRT, per the meeting-transcriber export header.
- **MODE 1 (subject)**: the exchange -- a two-participant screening call. Correct package.
- **MODE 2 (self-review)**: SELF-REVIEW, operator-decided. The overlay below (outcome estimate,
  behavioural check, claims ledger) is included.
- **Transcript tier**: dual-source. PRIMARY = a meeting-transcriber speaker-separated export,
  cross-verified against the secondary before it was trusted (see Limitations). SECONDARY =
  faster-whisper large-v3 verbatim, reused from a prior `watch-video-max` ingest of this exact file,
  used for phase-level pace/silence and to recover two spans where the transcriber's English-only
  engine fails on Portuguese speech.
- **Audio-capture check**: `volumedetect` mean=-14.0dB, max=0.0dB -- healthy, both speakers present
  in the mixed single-track capture. Channel-identity check: ratio `rms(L-R)/rms(L)` = 0.81%,
  correlation 0.99997 -- the two channels are the same signal, a mono downmix is lossless, no
  echo/duplication artifact.
- **Attribution method**: meeting-transcriber speaker labels for 0:00-25:52 (the clean English
  portion); inferred from turn logic and content for the two recovery spans (25:52-29:39 Portuguese,
  29:39-31:32 English closing), where neither engine attributes speakers.
- **Frame rate**: 5 fps, 9464 frames, this run's own extraction (a leftover directory from an
  earlier ingest existed but held only ~1893 files at ambiguous provenance/fps, so it was not
  trusted -- re-extracted clean rather than risk a timestamp-mapping error).

## The analysis of the subject

This was a warm, low-friction screening call that ran almost entirely as a monologue-response
interview: the recruiter opened with a roughly four-minute company overview, then asked seven
open-ended questions (background, a challenging LLM project, how he stays current, past feedback,
ideal culture, current job-search status, salary), each of which the candidate answered at length --
often for two to four minutes uninterrupted. The call closes in Portuguese for its final six
minutes, covering contractor terms, a specific salary figure, the process pipeline, and a
competing-offer check-in, before a short English return for role-structure Q&A and a warm goodbye.

Two things make this call more than a generic "candidate talks, recruiter nods" screen. First, at
16:12-21:01 the candidate volunteers a five-minute, unprompted description of his personal Claude
Code multi-agent harness, including a video-ingest design of his own -- extract the audio,
transcribe it, pull a frame at the moment under discussion, and call the result "watching a video".
The recruiter's reaction is immediate, specific and
enthusiastic [TRANSCRIPT 19:59-20:10], and it lands as the single strongest moment in the recording
given the company's own stated interest in AI coding assistants. Second, the Portuguese closing
segment -- which both ASR engines and Google Meet's own live captions all degrade on -- turns out on
recovery to be far more than a logistics close: it carries a specific salary ask, a competing-offer
disclosure, and concrete process commitments. The stretch the measurement had to discard is the
stretch holding the densest content in the call.

## What landed and what did not

**Landed:**
- The AI-harness tangent [TRANSCRIPT 16:12-21:01], reaction at 19:59: "Nice, nice... I recently got
  more into, like, creating skills at Claude for work, so I'm super like him. So that is amazing. It
  helps me so much." This is the recruiter matching his enthusiasm from her own stated experience,
  not a polite backchannel -- the strongest positive signal in the call.
- The Hands-On percentage resolution. The recruiter frames the role as 60% hands-on at 05:25 and
  again at 22:54; the candidate's relief at hearing that is audible both times ("I'm glad that you
  said that... I needed to feel that I'm contributing").
- The employment-history answer -- delivered cleanly, with no hedge and no implied current
  employer.
- The closing itself: warm, unforced, ends with an immediate concrete commitment stated on-camera
  ("I will send you an e-mail right away... it was great to meet you... thank you, you too, bye
  bye" [TRANSCRIPT ~31:03-31:25]).

**Did not land, or landed only partially:**
- A percentage slip: at 22:23-22:47 the candidate opens with "at least 40 percent of this position's
  work will be Hands-On" -- inverted from the 60% the recruiter had stated seventeen minutes earlier
  at 05:25. The recruiter corrects him gently at 22:54 ("actually is 60"). Minor, but it is a
  same-call recall miss on a number that mattered enough to him to name unprompted.
- One figure stated with a hedge where a precise number was available. The check that identified
  it reads the operator's private records rather than the recording, so it is removed from this
  copy along with the rest of the claims-ledger pass.

## The metric passes (clean-window scoped; see Limitations)

All talk-share, monologue and filler numbers below are scoped to **0:00-25:52**, the portion of the
call both ASR engines transcribe reliably in English. Beyond 25:52 the call is genuinely
bilingual/degraded and word-count-based metrics there would measure ASR failure, not behaviour --
see Limitations.

- **Talk-share** [MEASURED, meeting-transcriber word counts, clean window]: the candidate 65.9%
  (2,355 words, 51 turns); the recruiter 34.1% (1,220 words, 48 turns).
- **Continuous monologue blocks >=60s** [MEASURED, backchannel-tolerant merge, other-speaker turns
  <=4 words do not break the floor]: 8 blocks in the clean window. 7 belong to the candidate,
  totaling 974s (16:14) = **62.8% of the clean window's 25:52 duration**. The 8th, the recruiter's
  opening company overview (01:31-05:36, 245s), is the only non-candidate block. This is the single
  most actionable number in the report: two of every three minutes of usable call time were one
  uninterrupted candidate answer.
  - A 9th apparent block (26:03-30:46, 283s) came out of the raw merge but was **manually verified
    and discarded**: turn-by-turn inspection of that span shows both speakers exchanging turns of
    <=4 words almost every few seconds (Portuguese ASR garbage on both sides), not one continuous
    floor-hold. Reporting it would have been a measurement artifact, not a finding.
- **Disfluency (um/uh) rate** [MEASURED, meeting-transcriber text, clean window]: the candidate
  98 fillers / 2,355 words = 4.16% (~3.79 um-per-minute of clean-window time). The recruiter
  39/1,220 = 3.20%.
- **Speech rate per phase** [MEASURED, whisper segment word counts / phase duration]:
  - A, intro/small talk (0-91s): 171 wpm
  - B, recruiter's company overview (91-336s): 182 wpm
  - C, candidate's background + Q&A, English (336-1552s): 132 wpm
  - D, Portuguese logistics (1552-1779s): **VOID** -- nominal 204 wpm is meaningless, wrong-language
    ASR word counts do not measure speech rate
  - E, English closing (1779-1893s): 160 wpm
- **Silence/pace** [MEASURED, whisper segment gaps]: median inter-segment gap 0.00-0.35s in every
  clean phase, one gap of 2.16s in phase C, otherwise no gap above ~1s. **No dead air anywhere in
  the clean window.** This is a genuinely clean result, not a null -- it stands on its own as a
  pacing observation, with no reading-cadence or gaze-off-camera signature anywhere in the clean
  window.
- **Prosody**: not attempted -- mixed-mic audio with no reliable per-speaker channel makes this
  HYPOTHESIS-grade at best, and nothing in the call's content flagged a moment where it would have
  added signal beyond what the frames already show.

## Screen and technical findings

This is a webcam-gallery screening call, not a technical/coding round -- there was no expectation of
a shared screen, and for nearly the entire recording there is none.

**Anomaly, not a defect in the candidate's conduct: a ~12s browser window.** Between approximately
27:18 and 27:30 [FRAME f_008191-f_008251, verified directly from pixels this run, corroborating an
earlier watch-video-max pass], OBS's capture briefly shows a completely different window: the
candidate's own browser, dark mode, with roughly 20 open tabs, briefly showing a professional-
networking profile page for the recruiter. This happens while the call is still live (it ends at
~31:32, so this is roughly four minutes before close) and while, per the Portuguese-recovery
transcript, the candidate is still actively answering questions through this stretch. The most
likely read [HYPOTHESIS] is a second-monitor/background window bleeding into an OBS capture source
that grabs more than the call window, not an intentional mid-call pause to browse -- there is no gap
in his speech that lines up with it. Whatever the cause, it means the archived recording exposed a
slice of his own browsing history and open-tab count that he presumably did not intend to capture;
worth a note for future recordings (narrow the OBS source to the Meet window only).

## Narration-vs-screen discrepancies

- **An honest null on the screen axis.** This is a webcam-gallery call with no screen share, so
  there is no shown-versus-said contradiction available to find. The section is kept rather than
  dropped because the absence is the result: on this footage the frames corroborate the words and
  cannot contradict them.
- **One cross-source disagreement, on the audio axis.** Both the platform's live captions and the
  speaker-separated export assert English words across 25:52-29:39 where the speech is Portuguese.
  It is carried under Limitations as a measurement boundary rather than counted twice here.
- A third entry in the original run compared the recording against the operator's own private
  records. It was external to the recording and was removed by the publication gate.

## Outcome estimate (self-review overlay)

Per the skill's standing rule, this is estimated **only from in-call evidence**, not from the fact
that a next stage was later scheduled (that fact is recorded separately below, for calibration, not
as input).

**Estimate: 75-85% likelihood of clearing this screen**, based on: sustained positive backchannel
density from the recruiter throughout (no critical or probing pushback observed anywhere in the
clean window), the unusually strong and specific reaction to the AI-harness tangent
[TRANSCRIPT 19:59-20:10], a clean resolution of the one substantive concern raised (hands-on
percentage), and an explicit same-call commitment to send a follow-up email
[TRANSCRIPT ~31:03] stated before the call ended (in-recording evidence, not a downstream
inference). Nothing in the recording reads as a red flag or a stumble the recruiter would need to
escalate.

**Known actual outcome**: *[redacted -- recorded in the operator's private tracker, kept out of the published example; noted here only that the estimate above is derived exclusively from in-call evidence.]*

## Behavioural check against the profile

*[Section redacted for publication. In a real self-review run this section cross-references the operator's PRIVATE records -- employment-history ground truth, the running behavioural profile of prior rounds, and the outcome tracker -- to check spoken claims, compare patterns across rounds, and calibrate the outcome estimate. That content is external to the recording and inherently personal, so the published example withholds it. The in-call analysis above is recording-derived and unmodified.]*

## Claims ledger

*[Section redacted for publication. In a real self-review run this section cross-references the operator's PRIVATE records -- employment-history ground truth, the running behavioural profile of prior rounds, and the outcome tracker -- to check spoken claims, compare patterns across rounds, and calibrate the outcome estimate. That content is external to the recording and inherently personal, so the published example withholds it. The in-call analysis above is recording-derived and unmodified.]*

## Limitations

- **Talk-share, monologue and filler numbers are void beyond 25:52.** The 1552-1779s span is
  genuinely Portuguese and both primary ASR engines (plus Google Meet's own live captions,
  cross-checked at two points from frames) degrade there; the 1779-1893s span recovers cleanly in
  whisper but has no speaker labels from either engine, so attribution there is inferred from
  content, not measured.
- **Attribution rests on a transcript this pipeline did not produce.** The primary source is a
  speaker-separated meeting export, and it was cross-verified before it was trusted: meeting name,
  exact start time, exact duration, participant names, and full cross-consistency with the
  independently produced whisper transcript all match. Verification of that kind establishes the
  file belongs to this call; it does not make the labels this pipeline's own measurement.
- **Prosody was not attempted** -- mixed-mic single-track audio does not support a reliable
  per-speaker read, and nothing in the call flagged a moment where it would have changed a
  conclusion.
- **The frame pass sampled three targeted windows** (opening/cat moment, the AI-harness monologue,
  the closing goodbye) plus the browser-window anomaly, not an exhaustive per-second review; this
  is standard for a non-technical screening call with no code or shared documents to reconstruct,
  but it means any additional on-screen event outside those windows would not have been caught.

## Anomalies

1. **A leftover frame directory of ambiguous provenance** (1893 files, 1280x1392) was found in
   scratch before this run's own extraction. Its file count (~1893) matches neither a 5 fps
   extraction of this 1892s video (~9460 frames) nor any obvious round number, so it was not
   trusted or reused; this run re-extracted its own 9464-frame set instead. Not a problem in
   itself, but a reminder that a stale scratch directory can look plausible enough to reuse by
   mistake.
2. **The span the metrics had to discard is the span carrying the most content.** Every word-count
   metric is void across 1552-1779s because both ASR engines degrade on the language switch there
   -- and that same span holds the salary ask, the competing-offer disclosure and the process
   commitments. A measurement window drawn on transcript quality alone would have thrown away the
   densest part of the call. Recovering it took a second engine plus a frame check against the
   platform's own burned-in live captions.

A third anomaly recorded by the original run compared the recording against the operator's own
private records and pre-run instructions. It was external to the recording by construction and was
removed whole by the publication gate; see the banner at the top of this document.
