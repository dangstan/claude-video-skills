# tech-interview-screen -- video autopsy

REDACTION NOTE. This is a published copy of a self-review autopsy of a private recording. Four
sections built entirely from the candidate's own private records (a behavioural profile, a claims
ledger, an assist-tool log, and the analysis host's own filesystem/process state) have been removed
whole and replaced with a one-line declared shell, because every line of them was external to the
footage: Behavioural check, Claims-ledger consistency, Assist dependence, Run notes. One further
individual claim, inside a section that otherwise survives, has been removed in place and replaced
with a declared hole, because it depended on a private prior note rather than on the footage. Names,
the counterparty's employer, exact dates and clock times, the meeting code, and the recording
filename have been scrubbed or coarsened throughout; the substance of what was said in the recording
has not been altered. Two further quantities were removed in sanitization because each recovers the
recording's exact duration by arithmetic -- the total extracted frame count (divided by the stated
frame rate) and the raw per-mode frame counts in the screen-forensics table. **What the coarsening
does NOT achieve, stated plainly rather than left for a reader to discover: the phase decomposition
below runs to a named boundary in the thirty-second minute, so the recording's length is still
recoverable from this document to within a few seconds.** That was not redacted because the phase
timeline is the analysis -- moving those boundaries would mean recomputing every per-phase rate,
which is a findings edit and is not permitted here. The exact duration is therefore published
knowingly, and the header's "about 30 minutes" should be read as the intended coarsening rather
than as an achieved one.

## Header

- **Recording.** A single Google Meet call, `[recording filename redacted]`, duration about 30
  minutes, captured locally at 1280x1392 from a 30 fps source. [MEASURED: ffprobe]
- **Recorded.** August 2026.
- **Participants.** Two humans and one bot. The recruiter (a recruiting role at the Company; her
  title is legible on a LinkedIn profile page that appears in the capture at 27:26) and the
  candidate. The third tile is the recruiter's AI notetaker bot, which carries no camera and never
  speaks after its joining message. [FRAME 8230 / 27:26] [TRANSCRIPT 00:00]
- **MODE 1 (Step 0a): the EXCHANGE.** Two participants in conversation; no material is being
  taught and no artifact is being built. This is the right package. Confirmed before frame
  extraction from a 16-point coarse sweep across the whole recording, every sample of which showed
  a two-party call UI.
- **MODE 2 (Step 0a): SELF-REVIEW.** The recording is a job-interview round the candidate sat, and
  the candidate's own profile, claims ledger and tracker are configured for this run. The
  self-review overlay is open. Every section it adds is marked below.
- **Source provenance (Step 0b): PRIVATE.** This recording is not published and the counterparty
  did not publish herself. The PUBLICATION gate in the package applies to any copy of this
  document that leaves the operator, on both triggers (self-review, and a private source).
- **Face-to-name map, and the evidence for it.** The recruiter is the top-left tile; the candidate
  is the bottom-centre tile; the note-taker bot is the top-right tile. Each human is bound
  from **two disjoint sources**: the nameplate Google Meet renders inside each tile, and the
  active-speaker border lighting on that tile at times when the caption panel attributes the line
  to that person. The map was verified at 02:00, re-verified at 10:00, and re-verified again at
  28:20 -- more than half the recording away from the first check. Grid order, nameplates and tile
  geometry are unchanged at all three. [FRAME 601 / 02:00] [FRAME 3001 / 10:00] [FRAME 8501 / 28:20]
- **Transcript tier.** VERBATIM, faster-whisper large-v3 on CUDA in float16, `language="en"`,
  `vad_filter=True`, `condition_on_previous_text=True`. 530 segments, 197.7 s of wall clock =
  9.57x realtime. Coverage runs from 0:00 to the end of the recording, about 100% of it, with no
  timestamp gap above 8 s,
  mean `avg_logprob` -0.2806. Quality gate PASSED. A second decode of the same model with
  `language="pt"` covers the two Portuguese spans and is the text of record for them.
  [MEASURED]
- **Audio-capture check.** `mean_volume -14.0 dB`, `max_volume 0.0 dB`, `histogram_0db 2238062`
  over the whole file. Both participants are audible throughout and neither side is missing, so no
  talk-share number in this document is void for capture. [MEASURED: ffmpeg volumedetect]
- **Multi-channel decision, with all three numbers and the branch taken.** The file carries two
  audio channels. `rms(L)=6525.6893`, `rms(R)=6525.5868`, `rms(L-R)=52.6197`, giving a difference
  ratio of **0.8063 %**; correlation at lag 0 is **0.999967**; the cross-correlation peak sits at
  **lag 0 samples** over a +/-100 ms search on a 60 s window from the middle of the file.
  **Branch 1 was taken**: correlation at or above 0.999 with a zero peak lag means the two channels
  are the same signal whatever the ratio says, so a plain `-ac 1` downmix is lossless and no
  alignment or subtraction work was done. [MEASURED]
- **Attribution method, and the independent signal that settled it.** Primary attribution comes
  from a speaker-separated Tactiq export of this meeting, which is exact where it is legible. The
  **independent** signal is Google Meet's own active-speaker tile border, read from pixels on all
  every extracted frame as blue-channel excess over a 4-pixel strip at the top edge of each tile.
  The two signals are unrelated: one is a caption-derived text export, the other is a rendered UI
  element. Their per-second **agreement rate over the English window is 1361/1488 = 91.5 %**, and
  the two methods' aggregate talk-share for that window differs by **0.2 percentage points**
  (70.3 % against 70.5 %). The border is never lit on both tiles in any frame of the recording
  (zero frames in the recording), which is a structural check that the probe is reading one
  indicator rather than two
  brightness artifacts. [MEASURED]
- **Measured windows and their coverage.** Two, because the recording is bilingual and the two
  instruments fail on different spans.
  - **Export-derived metrics** (word counts, disfluency counts, exact turn text, monologue blocks):
    **0:48-25:44**, about **80%** of the recording. Outside it the export is word salad.
  - **Frame-derived attribution**: the whole recording minus the 34.8 s in which the capture shows
    a window other than the call -- about **100%** coverage.
  Every aggregate below repeats its window.
- **Frame rate.** 5 fps, the package floor; `f_NNNNNN` maps to second
  `(NNNNNN - 1) / 5`. Reaction bursts were cut at 0.75 fps over 12 s windows on top of that.

---

## The analysis

### What this exchange actually was

This is a **recruiter screening call that was conducted in a borrowed language, and the two most
consequential things in it happened outside that language.** Everything a reader would normally
call "the interview" -- the company pitch, the CV walkthrough, five open behavioural questions --
runs in English across 0:48-25:44. Then, at 25:45, the interviewer thanks the candidate for
speaking English for her and both revert to Portuguese, and in the next six minutes they settle
the contract structure, the salary number, the entire remaining hiring pipeline, the competing-offer
question, and the candidate's own three prepared questions.

That the English was a borrowed frame is not an inference. It was negotiated explicitly in the
first minute, in Portuguese, before any of it: The recruiter asks *"E a gente pode fazer o restante da
conversa em ingles?"* and The candidate answers *"Sim, sim. Eu ate prefiro, porque eu estou acostumado
mais em dar essas entrevistas em ingles"* -- yes, and I actually prefer it, because I am more used
to giving these interviews in English. [TRANSCRIPT 00:38, verbatim Portuguese decode] The English
window is therefore a deliberate exercise for both of them, and the Portuguese close is the two of
them dropping the exercise once the evaluative part is over and the transactional part begins.

The shape of the English window is monologue-and-response, and the split is lopsided in both
directions in turn. The recruiter opens with a **4 m 04 s continuous company overview** [MEASURED:
1:23-5:27, both methods agree to one second]. The candidate then holds the floor for **the next six
minutes almost without interruption** and answers five open questions at length. Across the whole
English window he takes **70.3 % of the speaking time by the export and 70.5 % by the frames**, on
**65.7 % of the words** -- he is speaking more of the time than his words alone account for,
which is the arithmetic signature of a slower, more heavily paused delivery rather than a faster
one.

The call is warm and it goes well. The single strongest moment is unprompted and, in a way the
recording could not have anticipated, self-referential: asked how he stays current, the candidate spends
five minutes describing his own multi-agent orchestration setup and ends on a tool he built to make
an assistant watch a video for him -- *"I even created a skill which I called watch video... you can
say, transcribe the audio, read the transcription, then every time you feel like you want to see
what is happening in the video while you are reading the transcription, extract a frame from the
video for that specific moment."* [TRANSCRIPT 19:39-20:27] That is, almost step for step, the
pipeline that produced this document. The recruiter's reply is specific rather than a polite backchannel:
*"Nice, nice. Okay, cool, cool. I recently got more into, like, creating skills at Claude for work,
so I'm super like him. So that is amazing. It helps me so much."* [TRANSCRIPT 19:59] It is the only
point in the recording where the interviewer volunteers something about her own practice.

The thing the exchange does badly is attention at the moment of highest information density. From
**27:12.2 to 27:30.0** the capture stops showing the call and shows LinkedIn -- the candidate's own
feed, then the interviewer's profile page, with a toast reading **"Invitation sent to [REDACTED: name]."**
[FRAME 8230 / 27:26, read from a 2.5x LANCZOS crop] Across exactly those eighteen seconds the recruiter is
describing the remaining stages of the hiring process: pair coding, system design, and an executive
interview with the founder. [TRANSCRIPT 27:15-27:32, verbatim Portuguese decode] Two minutes later
he says so himself: *"Voce ja me falou como e que vao ser as proximas etapas, ne, sao... a gente tem
o, eu nao vou lembrar agora, mas a gente tem o transcript"* -- you already told me the next stages,
we have the, I won't remember now, but we have the transcript. [TRANSCRIPT 29:21-29:26] The screen
and the words close on each other exactly.

### The one thing this recording changes about how it should be read

The **English window is not the interview**. A reader who stops at 25:44 -- which is what every
transcript engine applied to this file does, because all three of them fail on the Portuguese --
comes away with a call in which no salary was discussed, no process was described, and the candidate
asked no questions at the close. All three of those readings are false. He stated a number, he was
given a five-stage pipeline, and he asked three prepared reverse questions and got substantive
answers to all of them. The instruments' failure and the analysis' blind spot coincide precisely,
which is why the language span is treated here as a measured window boundary rather than as a
limitation noted at the end.

---

## Outcome estimate

*(This section is IN-RECORDING by construction and deliberately carries no external-record marker:
it is anchored only in what happened in the round.)*

**Probability of clearing this screen: 85-95 %.** [HYPOTHESIS]

The evidence that produces the upper end is an explicit, in-call commitment to the next step, made
by the interviewer, before the call ended. The recruiter lays out the whole remaining pipeline unprompted,
then offers three concrete send times for the take-home and closes with *"entao eu vou, assim que a
gente ligar aqui, eu te mando"* -- as soon as we hang up here, I'll send it to you.
[TRANSCRIPT 28:29] A recruiter who has not advanced a candidate does not schedule the next artifact
inside the call. Supporting evidence, all in-recording:

- She asks to be kept informed about his competing process -- *"so me da um heads up se tem alguma
  coisa acontecer, se tem alguma coisa avancar ai do seu lado, que ai eu vejo que a gente consegue
  aqui"* [TRANSCRIPT 28:58] -- which is a retention move, not a screening one.
- Her reaction to the multi-agent-harness answer is specific and personal rather than a
  backchannel. [TRANSCRIPT 19:59]
- She laughs, visibly and with a full open smile, at his remark that he had expected a brief
  overview and got a long one. [FRAME burst_0528, frames 7-9 / 05:30-05:34]
- The one substantive concern he raised in the round -- that he needs hands-on work and left his
  previous role when it went fully to leadership -- is resolved in his favour by her within thirty
  seconds, and upward: he says he is glad at least 40 % is hands-on, she corrects him to 60 %.
  [TRANSCRIPT 22:23-22:54]

What holds the estimate off the ceiling is that nothing in the recording tests competence. This is
a fit-and-logistics gate with no technical evaluation in it, so the round's own evidence cannot
speak to any later stage, and a recruiter's in-call warmth is a weaker predictor than an in-call
commitment. The 10-point width of the range is the space between "she advanced him" and "she says
that to most people she interviews", which the recording alone cannot separate.

**Two things this estimate deliberately does not use.** It does not use any later state of the
thread; and it does not use the previously recorded estimate for this same round, which is
discussed separately below under its own external-record marker.

---

## Behavioural check

[Content removed under publication rule 1.] This section compared the round against the candidate's private interview-behavioral profile -- prior-round patterns, a verbosity trend and a filler-rate history. Because it is built entirely from records outside this recording, it is withheld whole rather than partially redacted.

---

## Claims-ledger consistency

[Content removed under publication rule 1.] This section cross-checked claims made in the round against the candidate's private role file and employment-history record. Because it is built entirely from records outside this recording, it is withheld whole rather than partially redacted.

---

## Assist dependence

[Content removed under publication rule 1.] This section measured which AI tools were running during the call against the candidate's private assist-tool logs. Because it is built entirely from records outside this recording, it is withheld whole rather than partially redacted.

---

## What landed and what did not

**Landed: the unprompted tooling answer.** [TRANSCRIPT 19:39-20:27] The recruiter's response is the only
volunteered personal disclosure she makes in the call. [TRANSCRIPT 19:59] It landed by coincidence
rather than by design -- he was answering a question about staying current, not about tooling -- and
that is the actionable part.

**Landed: the gentle push-back on her own length.** After a four-minute overview he says *"I was
expecting a brief overview, and you gave me a lot, so I thank you for that."* [TRANSCRIPT 05:36]
The burst shows the recruiter moving from a neutral speaking face through to a broad, open, eye-crinkling
smile across the following eight seconds while he is still talking, and he is smiling back.
[FRAME burst_0528, frames 4-9 / 05:26-05:34] Reading a mild criticism as charm is a risk; the frames
say it was received as charm.

**Landed: the word he could not find.** Asked about ideal company culture he stalls -- *"I, I can't.
I, I didn't find the word in English. I would say, how do you translate?"* -- and the recruiter answers
*"I don't know."* [TRANSCRIPT 23:20-23:47] Read from the transcript alone this is the worst moment
in the round. The frames disagree: both are smiling within four seconds and the recruiter is still smiling
eight seconds later. [FRAME burst_2312, frames 4-9 / 23:12-23:20] The two longest measured pauses in
the whole English window, 2.30 s and 2.01 s, sit at 23:10 and 23:36, inside this exchange.
[MEASURED] It cost him time, not rapport.

**Did not land, in the sense of not being registered: the process description.** Covered above and
under narration-vs-screen.

**Did not land, neutrally: the salary number.** No visible reaction of any kind.
[FRAME burst_2610 / 26:10-26:18] That is a genuine null and it is reported as one: the recording
cannot say whether 8,000 was above, below or at her expectation. [NULL]

**Ambiguous: the hardest question.** The feedback question at 21:13 produces a visible think-pause
-- hand to chin, fingers to mouth, eyes down for four consecutive burst frames -- and two silences
of 2.00 s and 1.97 s at 21:26 and 21:30. [FRAME burst_2117, frames 4-9 / 21:17-21:25] [MEASURED]
The recruiter's face is neutral-attentive throughout, with no warmth signal and no negative signal, so the
frames locate the effort but do not settle how the answer was received. [NULL]

---

## The metric passes

**Windows first.** Export-derived metrics are scoped to **0:48-25:44, about 80% of the recording**.
Frame-derived attribution is scoped to about **100%** of the recording. Both
windows are repeated on every aggregate below. The Portuguese spans are **VOID for export-derived
metrics** because the export returns word salad there, and the reason is visible in the frames
rather than merely inferred: the on-screen Google Meet live captions at 28:20 read "Titan.",
"And complements. The.", "Make, follow." -- the same nonsense the export contains at the same
timestamps. [FRAME 8501 / 28:20]

### 1. Talk-share and turn-taking

| Window | Export time D/I | Export words D/I | Frames time D/I |
|---|---|---|---|
| English window 0:48-25:44 (1496 s) | 1050/444 s = **70.3 % D** | 2342/1220 = **65.7 % D** | 1051/439 s = **70.5 % D** |
| P2 company overview 0:48-5:36 | 19/267 s = 6.6 % D | 68/832 = 7.6 % D | 22/265 s = 7.7 % D |
| P3 background 5:36-11:52 | 363/13 s = **96.5 % D** | 832/24 = 97.2 % D | 356/15 s = 96.0 % D |
| P4 English Q&A 11:52-25:44 | 668/164 s = 80.3 % D | 1442/364 = 79.8 % D | 673/159 s = 80.9 % D |
| Portuguese close 25:44-31:32 | VOID (export is word salad) | VOID | 114/208 s = **35.4 % D** |

The ratio for the English window is **70/30**, and the inversion in the Portuguese close --
**35/65**, her floor -- is the numerical form of the reading above: the evaluative part of the call
is his, the transactional part is hers. [MEASURED]

### 2. Continuous monologue blocks (>= 60 s, 3 s backchannel tolerance)

| Method | Candidate, English window | Recruiter, English window |
|---|---|---|
| Export | 5 blocks, 743 s total, longest **226 s (3 m 46 s)** at 6:24-10:10 | 1 block, **244 s (4 m 04 s)** at 1:23-5:27 |
| Frames | 4 blocks, 854 s total, longest **328 s (5 m 28 s)** at 6:26-11:54 | 1 block, **244 s (4 m 04 s)** at 1:24-5:28 |

The two methods agree to one second on the recruiter's single block and diverge on his, because the export
absorbs her one-word backchannels into whichever line precedes them while the frame signal sees her
indicator light for a second and breaks the run. Both are reported; the export's is the narrower and
governs any claim.

**A block that straddled the window boundary was inspected by hand and discarded.** The export
produces an apparent 71 s block attributed to the candidate at 28:46-29:57, inside the Portuguese
span. Turn-by-turn
inspection against the verbatim Portuguese decode shows the recruiter holding the floor for most of that
range and the two of them trading full turns. The block is an artifact of the merge running over
garbled lines, exactly the failure the package warns about, and it is excluded. The inspection is
reported whether or not it changed the result; here it did. [MEASURED]

### 3. Disfluency counts

Export-derived, English window, normalised per minute of each speaker's **own** speech.

| | `um` | `uh` | `you know` | `like,` | `basically` | immediate word repeats | own speech | `um`+`uh` per min | repeats per min |
|---|---|---|---|---|---|---|---|---|---|
| Candidate | 84 | 14 | 4 | 4 | 4 | **49** | 1050 s | **5.60** | **2.80** |
| Recruiter | 30 | 9 | 11 | 4 | 1 | **1** | 444 s | 5.27 | **0.14** |

The filler rates are close. The **restart** rate is not: 2.80 per minute against 0.14, a factor of
twenty on the same recording with the same instrument. That, not the filler count, is the measurable
form of the self-interrupting pattern. [MEASURED]

These counts are a **floor**, not a total: they come from the caption-derived export, which keeps
fillers but does not keep every one, and the whisper tier's VAD strips most of them. They are VOID
across both Portuguese spans.

### 4. Silence and pace, PER PHASE

`silencedetect=noise=-35dB:d=1.0`, 49 events parsed. The event count is non-zero and the metric is
demonstrably live rather than stuck: sweeping the threshold gives 6.17 % at -25 dB, 4.74 % at
-30 dB, 3.66 % at -35 dB, 2.69 % at -40 dB and 2.12 % at -45 dB, a monotone response across the
range. [MEASURED]

| Phase | Length | Silence | Events | Longest pause |
|---|---|---|---|---|
| P1 Portuguese opening 0:00-0:48 | 48 s | 3.11 % | 1 | 1.49 s |
| P2 company overview 0:48-5:36 | 288 s | 1.20 % | 3 | 1.27 s |
| **P3 background walkthrough 5:36-11:52** | **376 s** | **0.32 %** | **1** | **1.22 s** |
| P4 English Q&A 11:52-25:44 | 832 s | 4.46 % | 27 | 2.30 s |
| P5 Portuguese close 25:44-31:32 | 349 s | 7.49 % | 17 | 5.22 s |
| Whole recording | about 30 min | 3.66 % | 49 | 5.22 s |

**P3 is the finding.** Six minutes and sixteen seconds of speaking with a single pause above one
second in it. A whole-recording average of 3.66 % hides it completely, and so does the
one-and-a-half-second threshold the package's default command uses, which finds no events at all in
P1, P2 or P3 and would have reported three phases of "0.00 % silence" -- a number that reads like a
clean result and is really the instrument's floor. The rise from 0.32 % to 4.46 % to 7.49 % across
three consecutive phases of one call is the shape worth carrying forward: he does not leave room
when he is delivering prepared material, he leaves some when he is being asked things, and the only
phase with normal conversational breathing is the one where the other person is driving.

Nobody in this call asked for think-aloud, so none of these numbers is a fault by itself. The
interpretation that survives is the one the package names: **filling every pause is itself a
finding**, and it is the same behaviour the monologue blocks and the restart rate are measuring from
two other angles.

**Speech rate**, per speaker per phase, from export words over export-attributed seconds:

| Phase | Candidate | Recruiter |
|---|---|---|
| P2 company overview | 214.7 wpm (68 words only -- not interpretable) | **187.0 wpm** |
| P3 background | **137.5 wpm** | 110.8 wpm (24 words -- not interpretable) |
| P4 English Q&A | **129.5 wpm** | 133.2 wpm |

Read against his own baseline rather than an external normal: his rate **falls** by 8 wpm from the
easy phase to the questioned phase, while hers is 54 wpm higher than his in the phase she prepared.
Pace, monologue length and pause structure agree here rather than diverging, which is the
cross-check that says the measurement is behavioural and not instrumental. [MEASURED]

### 5. Prosody

**NOT ATTEMPTED, and not reportable.** The two audio channels are the same signal (correlation
0.999967 at lag 0), so the file is a single mixed-mic track carrying both voices. Tier 2 requires
diarization before any F0 or energy statistic means anything about one speaker, and without it the
output is invalid rather than weak. No tone claim in this document comes from the signal; the
delivery statements above are derived from segment timings, word counts and frames, and are labelled
accordingly. [NULL]

### 6. Screen forensics

There is **no screen share in this recording** and no code on screen, so the live-coding pass does
not apply. Screen-mode classification was still run first, over every extracted frame, and it earned its
place: it found the only pixel-level finding in the autopsy.

Classification used two fixed probe regions with stable signatures -- the note-taker bot's tile
(mean brightness 22.59 in the call UI) and the Meet control bar (43.73) -- and required both to be
within 3.0 of their medians.

| Mode | Share |
|---|---|
| Google Meet call UI | **98.2 %** |
| Something else (a browser window that is not the call) | 1.8 % = 34.8 s |

The raw per-mode frame counts this run reported in that table were removed in sanitization: they
sum to the total, which divided by the frame rate gives the recording's exact duration. The shares
and the 34.8 s are the finding and are unchanged.

The non-call spans, in full:

| Span | Length | What the pixels show |
|---|---|---|
| 0:33.0-0:44.6 | 11.8 s | LinkedIn: a company page, then a search for the interviewer's name, resolving to her profile card with her title and location. [FRAME 171, 216] |
| 27:12.2-27:30.0 | 17.9 s | LinkedIn: his own feed, then the interviewer's profile page behind a modal, with a toast reading **"Invitation sent to [REDACTED: name]."** [FRAME 8163, 8230] |
| the final 6.2 s | 6.2 s | LinkedIn again, opened immediately after the goodbyes. |

Typing activity, editor-region pixel delta and the red-pixel error heuristic are **all inapplicable**
and are not reported: there is no editor region on screen at any point, so every one of them would
be measuring webcam motion. The red-pixel control question does not arise. One line each, dropped.

---

## Narration-vs-screen discrepancies

**1. The process description he was told and did not retain.** *What the screen showed:* LinkedIn,
continuously, from 27:12.2 to 27:30.0, ending on a sent-invitation confirmation.
[FRAME 8163-8230] *What the words claimed at the time:* nothing -- the recruiter held the floor across the
entire span, so no gap in his own speech marks it. [MEASURED: verbatim Portuguese decode gives her
continuous speech 26:37-27:32] *What the words said two minutes later:* *"eu nao vou lembrar agora,
mas a gente tem o transcript."* [TRANSCRIPT 29:26] The stages she named while he was elsewhere are
exactly the stages he then could not recall. This is the highest-value finding in the run and
neither half of it is audible.

**2. A previously banked comparison has been withheld.** [Content removed under publication rule
1.] The correction that stood here measured this run's frame-derived count of the LinkedIn
episode(s) in this span against a private prior note describing the same span, and corrected the
episode count, duration and which episode contained the name search. Because the comparison depends
on that external record, both the comparison and the record it drew on are removed whole rather
than partially redacted.

**3. What the instruments say happened at the close, against what happened.** All three ASR engines
applied to this file -- Google Meet's live captions, the Tactiq export built on them, and
faster-whisper driven with `language="en"` -- report the last six minutes as either nonsense or as
fluent English that was never spoken. The frames adjudicate the first two directly: the on-screen
captions at 28:20 carry the same word salad the export does. [FRAME 8501 / 28:20] The third is
adjudicated by re-decoding the same audio with `language="pt"`, which returns coherent Portuguese
with the same speaker rhythm. What actually happened in that span is the salary, the pipeline, the
competing-offer question and three reverse questions.

**4. A claim about his own tooling that the tooling does not support.** Describing how to make an
assistant watch a video, he says *"use a tool like whisper to understand the embedding traits of the
audio to understand modularity, to understand tonality to understand, um, how can I say, emotion in
the voice."* [TRANSCRIPT 20:27] Whisper is a speech-to-text model; it returns text and timestamps
and measures neither tone nor affect. This is a precision slip on his strongest topic, made to an
interviewer who had just said she works with the same product family, and it is the same
under-momentum pattern as the tenure and hands-on-percentage misstatements. [MEASURED against the
model's own interface] Nothing in the recording suggests she noticed.

---

## ASR-vs-diction

Two engines exist for this recording -- the caption-derived export and the whisper tier -- so the
two-engine rule can be applied. The frames cannot adjudicate any of it: no term under dispute is
ever on screen, because there is no screen share.

**Logged, because BOTH engines mangle it:**

- *"a Chrome job daily that runs daily"* (whisper 16:27) and *"Process Chrome, a chrome job daily"*
  (export 16:12). The intended term is **cron job**. Both engines produce "Chrome", which meets the
  rule's necessary condition. It remains HYPOTHESIS-grade rather than established: "cron" and
  "Chrome" are close enough that a shared ASR error is as plausible as a shared correct hearing of a
  mispronunciation, and no frame settles it. [HYPOTHESIS]
- The embedding model name: *"the QAN 3.5 local model for embedding"* (whisper 13:43) and *"the
  Queen 3.5 locomotto for embedding"* (export 13:21). Both mangle the vendor name. The version
  string "3.5" survives both, and no released embedding model in that family carries a 3.5 version,
  so the number itself is a candidate precision slip. [HYPOTHESIS]

**Not logged, because only one engine mangles it** -- these are ASR noise and the rule exists to
keep them out:

- The Company's name: whisper renders it correctly throughout; the export garbles it into several
  different nonsense strings across the recording. [REDACTED: the Company's name]
- The model tier names: the export gets "fable 5" right where whisper gives "Fabo 5"; whisper gets
  "Opus 5" right where the export gives "oppos5"; neither gets "Sonnet 5", giving "SONNE5" and
  "Sona 5" respectively.
- The assistant product name shows the inconsistent-error pattern the sibling package documents:
  whisper renders it "Claude" once and "Cloud" twice in the same passage. Neither reading is
  adopted; the term is flagged unverified.

---

## Limitations

- **Preflight raised zero failures and zero warnings**, so nothing is carried here from the gate
  itself. Everything below was found during the run.
- **79.0 % export coverage.** Word counts, disfluency counts and exact turn text exist only for
  0:48-25:44. The remaining 21.0 % is not missing data -- it is fully recovered by the Portuguese
  decode -- but it is not measurable with the same instrument, so no cross-window word statistic is
  computed and none should be.
- **Speaker attribution in the Portuguese close is frame-derived only.** The export is void there,
  so the 35/65 split for that span rests on the tile-border signal alone. That signal agrees with
  the export at 91.5 % where both exist, which bounds its error but does not eliminate it.
- **One degraded span inside the English window.** faster-whisper fabricates roughly fourteen
  seconds of filler sentences at 13:20-13:42 and enters an exact-repeat loop at 25:56-26:03
  ("I have a lot of money.", seven times). Both are excluded from quotation; the export governs the
  first and the Portuguese decode governs the second. Systematic detection over the whole file finds
  no other exact-repeat run of three or more segments. [MEASURED]
- **The package's own prescribed language-switch detector does not work on this file, and that is a
  finding about the method.** The rubric says to run language identification over the output text
  per window. Driven with `language="en"`, whisper emitted English text for Portuguese speech, so
  language ID over its output reports English everywhere and finds nothing. What did find it: the
  export collapsing, the in-recording line thanking him for speaking English, the repetition loop,
  and a re-decode with `language="pt"`. Confidence-based detection was not used, correctly -- the
  whole-file mean `avg_logprob` is -0.2806 and the switched span is not an outlier against it.
- **Prosody is a null, not a weak result.** Single mixed track, no diarization, tier 2 invalid.
- **Assist dependence is UNMEASURED**, and the frame observation that no assistant surface appears
  in any extracted frame bounds only the captured region, not the machine.
- **Reaction reading is limited to the recruiter.** Her tile is roughly 504x288 pixels and her expressions
  resolve. His tile is comparable in size but he wears glasses that catch the monitor's reflection
  in most frames, so eye-direction claims about him are not made; the hand-to-chin and head-down
  postures cited are gross posture, not gaze. Gaze cannot distinguish reading from thinking here and
  is not used. [NULL]
- **This run did not re-ask the assist question**, because it is not interactive. It is put back to
  the candidate rather than inferred.
- **This document's numbers were computed before the previously banked account of the same round was
  read**, deliberately, so that agreement between them is evidence rather than an artifact of
  reading order. The two agree on talk-share by words to 0.2 percentage points and on the filler
  numerator exactly; they disagree on the filler denominator, on the scope of the LinkedIn episodes,
  and on one decoded proper noun, all recorded above.

---

## Run notes

[Content removed under publication rule 1.] This section described the analysis host's own filesystem and process state -- scratch directories, prior artifacts already on disk, and similar machine details unrelated to the recording. It is withheld whole.
