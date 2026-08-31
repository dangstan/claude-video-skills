# Autopsy (RE-RUN): tech company screening call, recruiter x candidate

> SANITIZED EXAMPLE: real output of a real run. External-record sections were removed
> whole, identifiers scrubbed, and quasi-identifiers coarsened -- exact start time, exact
> duration and job titles do not appear. The recording and its transcript are withheld.
> COVERAGE IS ROUNDED, and it is rounded for a reason worth stating. This document
> originally published the measured window as a seconds pair whose denominator was the
> recording's exact length to the second, so the coarsened duration above was being
> contradicted three sections below it by arithmetic, and the publication gate did not
> catch it because it was scanning for the duration written as a duration. Dropping the
> denominator alone would not have been enough either: the numerator divided by an exact
> percentage recovers it to within a second. Coverage therefore ships here as the window
> in mm:ss plus a percentage rounded to the nearest five. (This note itself quoted the
> original seconds pair verbatim until the gate refused its own explanation -- a tombstone
> that repeats the removed value re-publishes it.)


This is a second pass over a recording already autopsied on an earlier pass. It was run to exercise the
rules added to the `video-autopsy` skill on the same day the skill was hardened, which had never been executed against real
footage. Where this run disagrees with the earlier one, the disagreement is stated and the
measurement that settles it is given. The subject analysis of the call itself is substantially
unchanged and is not restated at length; what follows concentrates on what the re-run measured.

## Header

- **Recording**: local OBS capture, about 30 minutes, Google Meet, desktop + mic on one audio track.
- **Source provenance**: PRIVATE. The publication gate applies in full.
- **Participants**: the recruiter, from the company's talent and people function, and the candidate, plus
  "the note-taking bot", a recording bot that never speaks substantively and is excluded from
  every count below.
- **MODE 1 (subject)**: the exchange -- a two-participant screening call. Correct package.
- **MODE 2 (self-review)**: SELF-REVIEW, operator-decided. The overlay is included.
- **Face-to-name map** [FRAME 601 / 02:00 and FRAME 7201 / 24:00]: the recruiter = top-left tile;
  the candidate = bottom-centre tile; the bot = top-right, camera off and muted. Each person bound
  from two disjoint sources: the rendered name label on the tile, and the active-speaker border with
  the live-caption attribution on a line whose text matches the export. Re-verified 22 minutes apart;
  the grid order did not change between the two checks.
- **Transcript tier**: dual-source. PRIMARY for attribution = the speaker-separated meeting export.
  SECONDARY = faster-whisper large-v3 float16, `language="en"`, VAD on, transcribed fresh in this run
  (464 segments covering the full recording).
- **Audio-capture check**: two channels present; the earlier run measured mean -14.0 dB with the two
  channels the same signal. Not re-measured this run.
- **Frame rate**: 5 fps, frames extracted fresh this run, and the frame count matches 5 fps across the full duration exactly, so the extraction is complete rather than truncated.
- **Measured window (export-derived metrics)**: 0:00-25:52 = **about 80% of the recording**.
  Whisper-derived metrics are NOT restricted to this window; see the language finding below.

## What this re-run measured, and where it corrects the earlier pass

**1. The language switch does not degrade whisper, and the earlier framing overstated it.** The
earlier autopsy said "both primary ASR engines degrade" across the Portuguese span from 25:52. That
is not what happened. Whisper large-v3, given `language="en"`, transcribed the Portuguese span AS
PORTUGUESE and did so coherently: "Entao, como eu disse, eu to actively looking, ne?" The
`language=` parameter did not force English output. Per-minute confidence over that span averaged
**-0.265 against a -0.381 whole-file mean** -- the switched minutes scored BETTER than the file
average. The engine that actually failed was the speaker-separated export, whose recogniser is
language-locked and which returned word salad plus no speaker labels for the same span.

The consequence is narrower than the earlier document claimed: metrics keyed to the EXPORT
(talk-share, turn counts, disfluency) are void beyond 25:52. Whisper-derived pace and silence are
not void there.

**2. A confidence scan cannot find a language switch.** A per-minute `avg_logprob` sweep over this
recording flagged minutes 8, 11 and 13 -- all three fluent, correct English -- and flagged NEITHER
of the two Portuguese minutes. The detection rule written into the skill earlier the same day said
to scan for a confidence drop; on the only recording available to test it, that rule fires on the
wrong minutes and misses the right ones. It has been rewritten to run language identification over
the output text, with `compression_ratio` (1.98 and 2.26 on the switched minutes against a 1.6-1.8
baseline) as a corroborator only.

**3. Phase D is a real measurement, not a void one.** The earlier pass marked the Portuguese close
VOID on the grounds that "wrong-language ASR word counts do not measure speech rate". Since the ASR
was not wrong-language, 208 wpm is a real speech rate for that span. The correct caveat is that word
counts are not comparable ACROSS languages, not that the number is an artifact.

**4. The transcriber's stated start time is not corroborated by the frames.** The export header says
the meeting started at a time withheld. The Google Meet wall clock burned into the frames reads one wall-clock reading at
video second 120 and a later wall-clock reading at video second 1440, which puts video zero at about a time withheld -- and
that matches the recording's own filename. Yet the export's RELATIVE timeline aligns with video to
within about 11 seconds (its 23:49 line is the caption on screen at video 24:00). Both cannot be
true of the same zero point. The relative alignment is the one supported by two independent frames,
so it is what frame lookups use; the absolute header time is uncorroborated and should not be
repeated as fact.

## The metric passes

**Measured window for export-derived metrics: 0:00-25:52, about 80% of the recording.**

- **Talk-share** [MEASURED, export word counts, clean window]: the candidate 65.8% (2,344 words, 50 turns);
  the recruiter 34.2% (1,220 words, 48 turns). The earlier pass reported 65.9/34.1 on the same basis.
- **Continuous monologue blocks >=60s** [MEASURED, backchannel-tolerant merge, other-speaker turns
  of four words or fewer do not break the floor]: 8 blocks. Seven are the candidate's, totalling **974s =
  62.8% of the measured window**. The eighth is the recruiter's opening company overview (01:31-05:36, 245s).
  Two of every three minutes of usable call time were one uninterrupted the candidate answer. This
  reproduces the earlier pass exactly.
- **Disfluency** [MEASURED, export text, clean window]: the candidate 98 fillers / 2,344 words = 4.18%;
  the recruiter 45 / 1,220 = 3.69%. the recruiter's figure is higher than the earlier pass reported (3.20%)
  because this count includes "hmm" and "mmm" alongside "um" and "uh". Same text, different filler
  set -- state the set with the number.
- **Speech rate per phase** [MEASURED, whisper segment word counts over phase duration]:
  A intro 180.0 wpm | B company overview 189.1 | C background and Q&A 142.9 |
  D Portuguese close 208.0 (real, not comparable across languages) | E English tail 183.7.
- **Silence** [MEASURED, whisper segment gaps]: median inter-segment gap 0.00s in every phase. The
  five longest gaps in the whole recording are 4.16s at 27:51, 2.96s at 26:11, 2.88s at 23:35,
  2.32s at 23:10 and 2.00s at 12:55. No dead air anywhere, in either language.
- **Prosody**: not attempted. Mixed-mic single-track audio does not support a per-speaker read.

## Screen and technical findings

- The recording is a full-desktop OBS capture of the candidate's own machine, not a screen share. the recruiter
  could not see any of it. The browser chrome, the tab strip and the extension bar are legible in
  every frame at 5 fps.
- Google Meet's own live captions are on and legible throughout, and they carry speaker attribution.
  They are a third transcript source and were used here to confirm the face map.
- The caption panel labels the candidate's own speech "You". That is a PERSONALISED label: it identifies
  the account that made the recording, not whoever is speaking. It agreed with the active-speaker
  border and the export line at the checked timestamp, so it corroborated the map rather than
  establishing it.

## Outcome estimate

Unchanged from the earlier pass and not re-derived here. Nothing this re-run measured bears on it:
the corrections are all to instrumentation, not to what happened in the call.

## Behavioural check

> REMOVED AT PUBLICATION. This section is external by construction: it is built
> from records outside the recording. It compares this round against the operator's own behavioural profile.


## Claims ledger

> REMOVED AT PUBLICATION. This section is external by construction: it is built
> from records outside the recording. It compares this round against the operator's own record of prior rounds.


## Assist dependence

> REMOVED AT PUBLICATION. This section is external by construction: it is built
> from records outside the recording. It reports what the operator stated about their own tooling.


## Limitations

- **Export-derived metrics are void beyond 25:52** -- but whisper-derived pace and silence are not,
  which is a change from the earlier pass.
- **Attribution across the Portuguese span is inferred from turn logic**, because the export supplies
  no speaker labels there. It is not measured.
- **The audio-capture check was not re-measured this run**; the earlier measurement is carried.
- **The frame pass was targeted, not exhaustive.** Two frames were read, at 02:00 and 24:00, chosen
  to bind and re-verify the face map. This run did not repeat the earlier pass's expression bursts.
- **The outcome estimate, behavioural check and claims ledger were not re-derived.** They are carried
  from the earlier pass and marked as such rather than restated as this run's findings.

## Run notes

> REMOVED AT PUBLICATION. This section is external by construction: it is built
> from records outside the recording. It describes this machine's filesystem and toolchain.

