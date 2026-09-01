# Autopsy -- founder-interview-podcast

A forensic read of a published 45-minute founder interview: what the exchange actually was, how the
talking was distributed, and what the shared screen showed while the narration claimed something
else.

---

## Header

| Field | Value |
|---|---|
| Source | `https://youtu.be/utb7zYbK10c` |
| Title | "Ex-Uber dev explains his Multi-Agent Workflow" |
| Channel | David Ondrej |
| Uploaded | 2026-08-10 |
| Duration | 45m 25s (2725.094 s) |
| Container | 1920x1080, 24 fps, AV1 video; AAC stereo 44.1 kHz |
| Recording platform | Riverside (`riverside.com` window visible on the shared screen) `[FRAME 2911 / 09:42]` |
| **MODE 1 (Step 0a)** | **THE EXCHANGE.** Two participants in conversation, with screen-share demo segments. Not one presenter teaching material, so this package applies rather than `watch-video-max`. |
| **MODE 2 (Step 0a)** | **THIRD-PARTY.** The operator is not a participant and their own performance is not the question. The self-review overlay does NOT open: no outcome estimate, no behavioural profile, no claims ledger, no tracker, no assist-dependence section. |
| **Source provenance (Step 0b)** | **PUBLISHED.** Anyone can watch it. The publication gate at the end of the skill therefore does not apply to this document. |
| Participants | **David Ondrej** (host, channel owner). **Flo / Florent Crivello** (guest; the video's "ex-Uber dev"; founder of Lindy). |
| Frame rate | 5 fps, the documented floor, giving 13,625 frames (2725 x 5, exact). Raised locally where a moment needed it: 0.75 fps 3x3 reaction-arc sheets at flagged timestamps. |
| Measured window | **0:00-45:25, the whole recording, 2725.1 s = 100% coverage.** No language switch, no dropped channel and no degraded span cut a window out of this file. The only exclusions are 14 whisper segments (1.0 s, 0.04% of speech) that neither attribution signal could settle, and they are reported as UNRESOLVED rather than dropped. |

### Layout: both faces are on screen at once

This is not a recording where the camera cuts to whoever is speaking. `[MEASURED: layout
classification over all 13,625 frames]` The dominant layout is a persistent side-by-side composite,
two 960-wide panels separated by a white divider bar:

| Layout class | Time | Share |
|---|---|---|
| SPLIT -- both participants side by side | 2169.4 s | 79.6% |
| FULL -- continuous single-speaker shot | 384.8 s | 14.1% |
| SHARE -- screen share, dark or light UI | 170.8 s | 6.3% |

That matters twice over. It means "who is on camera" carries no attribution information for four
fifths of the file, so attribution had to be built. And it means the 14.1% of FULL footage, where
the editor did choose one face, is an independent signal the audio side never saw -- which is
exactly what the control below uses.

### Face-to-name map, and the evidence for it

- **LEFT panel = DAVID ONDREJ** -- younger, over-ear headphones, nose strip, plain studio wall.
- **RIGHT panel = FLO (Florent Crivello)** -- rimless glasses, beard stubble, bay window with San
  Francisco Victorians behind him, large microphone with a green LED ring.

Bound from **two disjoint sources**, as the guardrail requires, and re-verified 44 minutes away
from the first binding:

1. **The editor's own speaker-inset over B-roll.** At `[FRAME / 00:19-00:22]` a circular inset of
   the RIGHT-panel person sits over motion-graphic B-roll carrying burned-in captions ("or a
   business of the past") that match the transcript line at `[TRANSCRIPT 00:19]`, which the audio
   clustering had independently assigned to cluster 1. At `[FRAME / 00:26]` the inset shows the
   LEFT-panel person over the line at `[TRANSCRIPT 00:26]`, assigned to cluster 0.
2. **Aggregate mouth-region motion per panel.** `[MEASURED: per-frame pixel delta in the mouth box
   of the largest connected skin component per panel, aggregated per voice cluster]` Cluster 0
   reads mean z(LEFT) +0.895 against z(RIGHT) +0.156; cluster 1 reads +0.134 against +0.801. Welch
   t = 14.3, p = 6.0e-41.

Names attach to clusters by **direct address**, which a speaker does not normally use on
themselves: cluster 0 says "All right Flo" `[TRANSCRIPT 00:23]`; cluster 1 says "David" at
`[TRANSCRIPT 00:37]`, `[TRANSCRIPT 01:20]` and `[TRANSCRIPT 20:20]`. Corroborated at `[FRAME 2911 /
09:42]`, where the shared screen addresses its owner by name -- a personalised surface, which names
the SHARER and is treated here as corroboration only, never as the primary binding.

**Re-verified** at 30:00, 35:00, 40:00, 43:20, 44:40 and 45:00: the panels never swap.

### Transcript tier

Verbatim only, as this package requires. `faster-whisper` 1.2.1, `large-v3`, CUDA float16,
sequential (not batched, not distilled), `language="en"`, `vad_filter=True`,
`condition_on_previous_text=True`. 1694 segments, 10,637 words, coverage 0.08 s to 2724.94 s,
largest inter-segment gap 1.3 s, mean `avg_logprob` -0.123. **Quality gate PASSED on the first
pass**; no fallback path was used. Language identification was run over the OUTPUT TEXT per window
-- English throughout, no code-switching span. Confidence was deliberately not used as the detector.

A second ASR reading (YouTube auto-captions, `en-orig`, 749 cues) was fetched and used only for the
diction cross-check. It carries **zero `>>` speaker markers**, so the caption-alternation route to
attribution was unavailable here -- which is just as well, since that route is the one the
guardrails record inverting at an editor's cut.

### Audio capture

`[MEASURED: ffmpeg volumedetect on the mono downmix]` mean_volume -28.4 dB, max_volume -3.0 dB.
Healthy, both parties present, no half-captured side. Every talk-time number below is therefore
live rather than void.

The file is stereo, so it was **measured before any preprocessing**: rms(L) 1243.19, rms(R)
1243.21, rms(L-R) 21.24 on the int16 scale, giving a difference ratio of **1.7084%**; correlation
at lag 0 **0.999854**; cross-correlation peak lag **0 samples** over a +/-100 ms search. This lands
squarely in the documented dead zone -- too high for "below about 1%", not remotely "clearly below
1" on correlation -- so the ordered test decides it: **branch 1, the channels are the same signal**,
and a plain `-ac 1` downmix is lossless for these purposes. A rule thresholding on the ratio alone
would have reported "genuinely different" and sent the run into pointless alignment work.

### Attribution method, and its control

No speaker-separated export exists for this recording, so attribution was constructed from two
signals and then controlled against itself.

- **Signal A (audio).** 13-coefficient MFCCs computed per whisper segment over voiced frames only,
  mean and standard deviation concatenated, 2-means clustering. 1676 of 1694 segments clustered.
- **Signal B (frames).** Where the editor cut to a continuous single-speaker full-frame shot, the
  person shown is identified from background alone (studio wall against bay window; blueness
  medians -3.7 and 75.7 respectively) -- 384.8 s of such footage.

Fusion: signal B overrides where it exists (223 segments), signal A carries the rest (1457
segments), 14 segments remain UNRESOLVED.

**The control.** Signal B never consulted signal A. Over the 219 segments lying wholly inside
single-speaker full-frame footage -- **268.8 s of the recording** -- the two agree on 212.
**Agreement 96.8%.** Stratified by segment length: 94.7% under 1 s, 98.6% at 1-2 s, 100% above 2 s.
The disagreements are all sub-second fragments, and on every one of them the frame reading is the
credible one.

---

## What this exchange actually was

The video is titled as a workflow explainer -- an ex-Uber developer explaining his multi-agent
setup -- and that framing is the first thing the evidence complicates. Measured across the whole
file, **Flo does 67% of the talking and David 33%** `[MEASURED]`, which is an ordinary interview
ratio. But the shape underneath that ratio is not an interview shape. Flo's median turn runs 12.8
seconds against David's 3.5 `[MEASURED]`, and there are **sixteen continuous blocks of 60 seconds
or longer, thirteen of them Flo's** `[MEASURED]`. What the numbers describe is a guest delivering a
worldview in long, prepared-feeling movements, and a host whose dominant conversational act is a
short assent that hands the floor straight back.

The worldview itself is coherent and worth stating plainly, because it is the actual content of the
exchange. Flo's argument is that AI tools are currently **single-player** -- everyone runs their own
agent on their own machine and passes files around -- and that the next transition is to
**multiplayer**: an agent with a Slack account, an email address, a shared file system, shared
skills and shared memory, addressable by any teammate in the surface the team already uses
`[TRANSCRIPT 01:36, 05:07]`. He argues the bottleneck is not model intelligence but **context**,
illustrated with a von Neumann analogy -- the smartest person in the world, dropped into your
office with no context, is less useful than an average colleague who knows what is going on
`[TRANSCRIPT 12:22]`. From there he derives an operating stance: embrace chaos, let engineers build
their own competing workflows, reward it publicly, and spend at least twenty hours a week
hands-on-keyboard or your company will die `[TRANSCRIPT 27:22]`.

The most striking thing about the exchange is how little of it is resistance. Across 45 minutes,
**David does not once push back on a claim**. His turns are of three kinds: assent tokens
("A hundred percent", "1,000%", "That's exactly right"), elaborations that extend Flo's point in
the same direction, and topic-switch questions. The one moment that reads structurally like a
challenge -- "Maybe I should ask you, but like I hold the belief that soon enough, 99% of all
software usage and tools will be done by agents" `[TRANSCRIPT 02:10]` -- is a stronger version of
Flo's own position offered for agreement, and it gets "1,000%" `[TRANSCRIPT 02:34]`. This is not a
criticism of the host so much as a description of the genre: the recording is a **jointly
constructed thesis**, not an interrogation of one, and a viewer who came for a stress-test of the
multiplayer-agent claim will not find one here.

The title's promise is delivered, but it is a small part of the runtime. The segment that actually
answers "his multi-agent workflow" runs roughly **19:05-22:48** -- about three and a half minutes of
forty-five -- and its content is deflationary in an interesting way. Asked to describe his setup,
Flo's answer is that he is confused by people with complex ones: Claude Code works out of the box,
he has added some MCP servers, and **his `CLAUDE.md` is now basically empty** `[TRANSCRIPT 19:16]`.
The complexity in his workflow does not live in the coding agent at all; it lives in a set of
always-on cloud routines -- daily brief by text, email drafting, email labelling, meeting notes,
meeting prep -- which are, as the screen shows, product features he toggles on rather than
apparatus he assembled `[FRAME 6026 / 20:05]`. That is a genuinely useful finding for the viewer
the title recruited, and it is buried in the middle of the video.

There is also a structural fact about the recording worth naming: **the host's own product occupies
133 seconds of the guest's interview**. At 02:35, four minutes into a conversation with a guest,
David pivots into an uninterrupted 132.3-second read for Deep API, his own product, with a live
screen demo. `[MEASURED]` It is the single longest continuous David block in the file and the
second-longest block overall, and during it the editor removes Flo from the screen entirely. The
transition is smoothed by having Flo hand over the cue ("1,000%") immediately before it. This is
ordinary creator-economy practice and it is disclosed by the demo itself; it is recorded here
because the numbers do not otherwise explain why one of the three long host blocks is not
conversation at all.

> **DEFECT, annotated rather than repaired (found in review, not by the run).** The two
> sentences above call Deep API "the host's own product". **The recording does not establish
> that, and its own evidence points the other way:** the host says he spent two months building
> *with* Deep API `[TRANSCRIPT 02:46]`, describes what an agent unlocks "the moment he has a
> single API key from Deep API" `[TRANSCRIPT 04:30]`, and closes by directing viewers to "click
> the first link below the video" `[TRANSCRIPT 04:43]` -- the phrasing of a paid placement, not of
> a founder demonstrating his own company. The `watch-video-max` document on this same recording
> reads it that way: a paid advertisement for a third product, read by the host. **The safe claim,
> and the one the evidence supports, is that the segment is a sponsor read the host delivers, and
> that the ownership question is not settled by the recording.** Ownership is a materially heavier
> claim about a named, identifiable person than sponsorship is, which is why it is corrected here
> rather than left to a reader. Everything else in this section -- the 132.3 s duration, its rank
> among the host's blocks, and the editor removing the guest from screen -- is measured and stands.


---

## What landed and what did not

**The disclaimer that got no reaction.** At `[TRANSCRIPT 08:40]` Flo opens a demo with "I promise to
your viewers this isn't set up." The reaction-arc sheet across 08:38-08:50 `[FRAME burst 518 /
08:38-08:50]` shows him delivering it with a raised open palm held toward camera -- an oath gesture
-- and a smile, repeated across most of the twelve seconds. On the left panel, David's face
registers nothing across the entire window: mouth closed, gaze down and neutral, no nod, no smile,
no brow movement. The disclaimer is performed for the audience, not for the person in the room, and
the room does not respond to it.

**The strongest rapport moment is a shared confession.** At `[TRANSCRIPT 20:36-20:42]` Flo asks
whether David also texts an agent all day; David answers that he does it through Discord rather
than iMessage and tracks all his calories that way. This is the only exchange in the file where
information moves from host to guest and the guest asks a follow-up. It is brief and it is where
the two sound most like peers rather than interviewer and subject.

**The close is flat.** `[FRAME burst 2700 / 45:00-45:12]` shows both participants neutral-faced
through the wrap: no laughter, no visible warmth spike, mouths closed in most tiles. The words match
-- "I want to be respectful of your time, we have two minutes left, where should people go"
`[TRANSCRIPT 45:07]`, a one-line answer, a mention of links below, and "thank you so much for having
me" `[TRANSCRIPT 45:23]`. Worth noting as an observation rather than a fault: **David announces two
minutes remaining and the recording ends 19 seconds later** `[MEASURED: 45:07 to 45:26]`. The
closing segment is the part of a recording that routinely gets skipped as admin; here it confirms
that the session ended on the host's schedule rather than on an exhausted topic.

**What did not land: the AGI question.** David's one attempt at a personal-stakes question -- how
worried are you, how are you preparing `[TRANSCRIPT 35:41]` -- gets a pre-formed answer. Flo says he
tries not to think about it, has "been the AGI guy since 2015", and reduces the space to a rehearsed
binary, "death or house cat" `[TRANSCRIPT 36:30]`, then explicitly declines to discuss it further
unless someone has something original to say `[TRANSCRIPT 39:03]`. The question was a good one and
it bounced off a prepared surface. That the answer is polished is itself the finding: this is
material the guest has delivered before.

---

## The metric passes

**The measured window is 0:00-45:25, the whole recording, 2725.1 s -- 100% coverage.** Every
aggregate below is over that window unless a phase is named.

### Talk-share and turn-taking

| | FLO | DAVID | UNRESOLVED |
|---|---|---|---|
| Speaking time | 1754.2 s (66.6%) | 876.9 s (33.3%) | 1.0 s (0.04%) |
| Words | 6,996 (65.8%) | 3,614 (34.0%) | 27 |
| Turns | 59 | 59 | -- |
| Median turn | 12.8 s | 3.5 s | -- |
| Mean turn | 30.6 s | 15.4 s | -- |
| Longest turn | 135.6 s | 132.3 s | -- |

Ratio **67/33 by time, 66/34 by words** `[MEASURED]`. Total speech is **2632.0 s of 2725.1 s =
96.6% of the runtime** -- see the silence section, because that number is about the editor.

The turn counts are equal at 59 each while the median lengths differ by 3.7x. That is the whole
dynamic in two numbers: the two men take the floor equally often, and one of them keeps it nearly
four times as long each time.

### Continuous monologue blocks (>= 60 s)

Sixteen blocks, **thirteen Flo, three David** `[MEASURED]`.

| Speaker | Window | Length | Opens with |
|---|---|---|---|
| FLO | 27:22-29:38 | 135.6 s | no-meeting days, the electricity/shoe-factory analogy |
| DAVID | 02:35-04:48 | 132.3 s | the Deep API sponsor read and demo |
| FLO | 12:22-14:23 | 121.3 s | infinite context windows, the von Neumann analogy |
| FLO | 08:40-10:40 | 120.7 s | "this isn't set up", the memory-hydration demo |
| FLO | 05:07-06:56 | 109.0 s | the multiplayer product, agents in Slack |
| DAVID | 10:41-12:22 | 101.0 s | humans versus agents at memory |
| FLO | 19:05-20:35 | 90.4 s | his actual setup, then the routines list |
| FLO | 16:56-18:26 | 89.5 s | the agent that wrote its own integration |
| FLO | 35:57-37:25 | 87.8 s | "death or house cat" |
| FLO | 43:53-45:07 | 74.0 s | the rotation of capital into hardware |
| FLO | 33:03-34:09 | 65.8 s | working on the machine, not in it |
| FLO | 23:20-24:23 | 63.4 s | breaking computers as a kid |
| FLO | 15:26-16:29 | 63.3 s | why he is bullish on Slack |
| DAVID | 30:20-31:23 | 62.7 s | the middle-ages comparison, translators |
| FLO | 24:24-25:26 | 62.3 s | his father's magazine company |
| FLO | 25:32-26:33 | 61.5 s | "let a thousand flowers bloom" |

**Every long block was inspected by hand** rather than trusted from the merge, as the guardrail
requires. All sixteen are genuine single-speaker holds; none is an artifact of a merge across a
degraded span, and none straddles a window boundary because there are no excluded windows in this
file. The placement is informative: the three longest Flo blocks sit at 27:22, 12:22 and 08:40 --
none of them on the hardest question, all of them on material he is fluent in.

### Silence and pace, per phase

The whole-recording silence figure is the single most diagnostic number in this file, and it needed
a control before it could be believed.

`[MEASURED: ffmpeg silencedetect]` At `noise=-35dB:d=1.5` the parse returned **zero events**. Zero
silence reads exactly like a broken parse, so it was controlled: the same command at `d=0.5`
returns 390 event lines, at `-30dB:d=0.5` returns 516, and at `-20dB:d=0.5` returns 1656. The parse
is live. **The zero is real: there is not one pause of 1.5 seconds or longer anywhere in this
45-minute recording, and the longest silence of any kind is 1.07 s.**

That is a measurement of the **editor**, not of the speakers, and it must not be read as fluency.
Every breath, every hesitation and every dead beat has been cut. It is also why speech occupies
96.6% of the runtime.

Per-phase, using the 0.5 s threshold that this material can actually resolve:

| Phase | Window | Dur | FLO | DAVID | Silence | wpm FLO | wpm DAVID | Longest block |
|---|---|---|---|---|---|---|---|---|
| P1 cold-open montage | 0:00-0:23 | 23.5 s | 100% | 0% | 3.9% | 301 | -- | 22.2 s |
| P2 multiplayer premise | 0:23-2:35 | 131.5 s | 61.4% | 38.6% | 0.5% | 250 | 244 | 50.8 s |
| P3 sponsor read (Deep API) | 2:35-4:48 | 133.0 s | 0.6% | 99.4% | 4.3% | -- | 223 | 132.3 s |
| P4 post-agent hardware / Lindy | 4:48-8:40 | 232.0 s | 68.0% | 32.0% | 2.5% | 242 | 255 | 109.0 s |
| P5 shared context + demo | 8:40-14:23 | 343.0 s | 70.8% | 29.2% | 3.3% | 241 | 268 | 120.7 s |
| P6 distribution / Slack | 14:23-19:05 | 282.0 s | 55.9% | 44.1% | 2.4% | 261 | 248 | 89.5 s |
| P7 Flo's actual setup | 19:05-22:48 | 223.0 s | 72.2% | 27.8% | 3.7% | 248 | 262 | 90.4 s |
| P8 play, break stuff | 22:48-27:22 | 274.0 s | 79.6% | 20.4% | 8.2% | 225 | 253 | 63.4 s |
| P9 chaos operating model | 27:22-30:20 | 178.0 s | 81.6% | 18.4% | 6.6% | 240 | 247 | 135.6 s |
| P10 middle ages / the machine | 30:20-35:41 | 321.0 s | 49.6% | 50.4% | 4.1% | 230 | 235 | 65.8 s |
| P11 AGI: death or house cat | 35:41-40:55 | 314.0 s | 73.1% | 26.9% | 5.4% | 240 | 249 | 87.8 s |
| P12 what to build | 40:55-45:07 | 252.0 s | 90.5% | 9.5% | 5.9% | 228 | 280 | 54.8 s |
| P13 close | 45:07-45:25 | 18.1 s | 34.8% | 65.2% | 10.2% | 162 | 282 | 6.9 s |

Read across the phases rather than down them. **P2 at 0.5% silence is the tightest window in the
file** -- the opening exchange has been cut to essentially zero air. **P8 and P9 at 8.2% and 6.6%
are the loosest**, and both are Flo-dominated stretches on autobiographical material (breaking
computers as a kid, his father's company, his own week) where the editor left more room. **P10 is
the only balanced phase in the recording** at 49.6/50.4 -- and it is the one where the two men are
building a comparison together rather than one explaining to the other. **P12 at 90.5% Flo is the
most lopsided**, which is expected: it is the "what should people build" question, and the answer
belongs to the guest.

### Speech rate

`[MEASURED: whisper segment boundaries, per segment, segments longer than 1 s]`

| | Median | p25 | p75 | n |
|---|---|---|---|---|
| FLO | 223 wpm | 174 | 273 | 538 |
| DAVID | 239 wpm | 199 | 288 | 255 |

Both sit well above the 120-180 wpm band usually quoted for conversational English, and the useful
reading is against each speaker's own baseline rather than that band. Two deltas stand out.
**David's cold-open-adjacent and closing phases run fastest** -- 282 wpm in P13 and 280 in P12 --
which is the pace of someone wrapping. **The cold-open montage itself reads 301 wpm for Flo**,
about 35% above his own median; that is not Flo talking faster, it is the editor having removed the
gaps between three separate utterances (see the edit forensics below). Pace, monologue length and
pause structure agree with each other everywhere in this file, which is the sign that the
measurement is behaving: the phases with the longest blocks (P9) are also the ones with the most
retained silence, because they are the phases the editor cut least.

### Disfluencies

`[MEASURED, and it is a FLOOR]` Whisper's VAD strips most "um"/"uh", so counting fillers from this
transcript under-reports by construction: FLO 10 tokens over 29.2 min of own speech (0.34/min),
DAVID 0 over 14.6 min (0.00/min). A zero here means the instrument found nothing, not that nothing
was said, and no speaker-separated export exists to give the real count. **Treat the filler row as
uninformative.**

What the transcript does preserve faithfully is **discourse markers**, which whisper keeps:

| Marker | FLO | DAVID |
|---|---|---|
| "like" | 425 (14.54/min) | 218 (14.92/min) |
| "you know" | 69 (2.36/min) | 49 (3.35/min) |
| "basically" | 15 (0.51/min) | 4 (0.27/min) |
| "literally" | 6 (0.21/min) | 6 (0.41/min) |

The result is a genuine null worth stating: **the two speakers use "like" at statistically
indistinguishable rates** (14.54 vs 14.92 per minute), despite one talking twice as long as the
other. The verbal register of this conversation is shared, not a property of either man.

### Prosody

**Not reported.** Tier 2 (F0 mean and variance, energy dynamics) requires diarization of a
single mixed track before any per-speaker statistic means anything, and the 2-means MFCC
clustering used here for attribution is not a diarizer -- it assigns pre-cut whisper segments, it
does not find speaker boundaries. Computing pitch statistics over this file would measure a blend.
Tier 3 categorical speech-emotion classification was not run and is not recommended. Every claim
about delivery in this document is therefore derived from content and frames and is labelled as
such. `[NULL]`

---

## Screen and technical findings

Screen share occupies 170.8 s (6.3%) of the file across five spans, plus B-roll inserts. `[MEASURED:
layout classification]` The substantive spans are the Deep API demo (02:35-04:48), Flo's Slack
thread (07:17-07:46), Flo's memory-hydration demo (roughly 09:30-10:40) and Flo's routines list
(around 20:00-21:40).

**The Deep API demo, in the host's own sponsor read.** Three tasks are shown in a Codex-style
agent UI on `david@davidondrej.com`'s account.

- Task 1, the contractor scrape. The prompt on screen reads "100 active licensed general
  contractors in Austin, Texas from the state licensing records. name, website, phone, email.
  table." `[FRAME 1026 / 03:25]` The agent's completion summary reads "Created 100 unique Austin
  contractors:" with a linked markdown table `[FRAME 1036 / 03:27]`, and a coverage line reading
  "...88 websites, 98 phone numbers, and 40 publicly listed emails. Missing details are clearly
  labeled." `[FRAME 1041 / 03:28]`
- Task 2, eight stock tickers with news and sentiment, emailed out. The screen shows "Worked for 4m
  44s" `[FRAME 1191 / 03:58]` and "Email sent to david@davidondrej.com" with three attached files
  `[FRAME 1201 / 04:00]`.
- The Deep API dashboard shows $149.9352 total spent, 3,869 requests and a 99% success ring, broken
  out as 3,828 succeeded / 40 failed / 1 excluded `[FRAME 901 / 03:00]`. **That arithmetic checks
  out**: 3,828 of 3,869 is 98.9%, and rounding it to 99% is honest.

**Flo's memory-hydration demo.** The shared window is a Slack message from a colleague containing a
CleanShot screen recording dated 2026-07-24, being played back `[FRAME 2911 / 09:42]`. Inside it,
a Lindy onboarding screen summarises what the agent has inferred about its owner from the team's
Slack, alongside a force-directed graph of people, teams, projects and initiatives. A status line
at the foot of the panel reads "Still learning - 1,284 messages and 18 channels reviewed."

**Flo's routines.** The Lindy Routines screen `[FRAME 6026 / 20:05]` shows eight built-in routines,
all toggled on: Daily briefs, Email drafting, Email labeling, Meeting note taking, Meeting prep,
Meeting scheduling, Email alerting, Follow-up bumps, with a "Custom" section below the fold.

**No live coding occurs in this recording**, so the typing-activity and on-screen-error passes do
not apply. In particular the red-pixel error heuristic was **not run**: there is no editor with a
problem counter anywhere in the file, so the control that heuristic requires could not have been
performed, and running it uncontrolled would have produced exactly the confident nonsense the method
warns about. `[NULL]`

### Edit forensics

`[MEASURED: phrase matching across the transcript]` The 22-second cold open is not a single
utterance. It is spliced from **at least three separate later moments**:

| Cold-open phrase | Its real position |
|---|---|
| "eat your lunch" / "reinvent your company from scratch" / "other side of AGI" / "nothing like what it was" | 24:29-24:37 |
| "business of the future" | 31:59 |
| "bottleneck at this point" / "your own adoption" | 32:20-32:23 |

This is ordinary podcast practice, and it is recorded because it has two measurable consequences.
It explains the anomalous 301 wpm reading for P1. And it provides a free control on the
attribution -- see the limitations below, where it catches a real error.

---

## Narration-versus-screen discrepancies

These are the highest-value findings this package produces, and this recording has three.

**1. A 30-minute claim against a 13-minute screen. `[VERIFIED(frame crop, f_001036, 5 fps index)]`**

> "So it ran for 30 minutes." `[TRANSCRIPT 03:20]`
> "So in this case, after 30 minutes, it created a hundred unique contractors." `[TRANSCRIPT 03:35]`

The run-duration label directly above that task in the same screenshot reads **"Worked for 13m"**
`[FRAME 1036 / 03:27]`. The claim is made twice, fifteen seconds apart, and both times it is
2.3x the figure on screen.

This is a real discrepancy rather than a misreading on my part, and the control that establishes
that is the *other* task in the same demo: for the ticker job David says "Ran for four minutes"
`[TRANSCRIPT 03:54]` and the screen reads "Worked for 4m 44s" `[FRAME 1191 / 03:58]` -- accurate,
rounded down. The same speaker, the same UI, the same minute of video, one figure right and one
wrong by a factor of two.

**2. The demo's headline premise is contradicted by the agent's own output on screen.
`[VERIFIED(frame crop, f_001036)]`**

The prompt asks for licensed contractors "from the state licensing records", and the narration
repeats the framing. Two lines above the "Created 100 unique Austin contractors" summary, the
agent's own text reads:

> "Texas does not issue statewide general-contractor licenses. Austin registration is local and
> one-time, so 'active state-licensed' records do not exist." `[FRAME 1036 / 03:27]`

The agent is saying, on screen and unprompted, that the source the demo claims to have queried does
not exist. The 100 rows were assembled some other way. The narration never mentions this, and the
same screenshot's coverage line puts the delivered table at 88 websites, 98 phone numbers and **40
emails out of 100 rows** -- against a prompt that asked for name, website, phone and email. This is
the strongest finding in the recording: **the flagship result of a sponsor demo is qualified into
near-meaninglessness by the tool's own output, in text large enough to read, while the voiceover
calls it a win.**

**3. "Updating live" against a frozen counter. `[VERIFIED(frame crops f_002861..f_002961)]`**

> "And you can see it's updating its learnings live." `[TRANSCRIPT 09:39]`

The status line reads **"Still learning - 1,284 messages and 18 channels reviewed"** and is
**bit-identical at t = 09:32, 09:36, 09:46 and 09:52** -- four samples across 20 seconds, no
change. `[MEASURED]` The artifact being shown is, per its own Slack header, a CleanShot `.mp4`
recorded on 2026-07-24 and posted by a colleague, played back during the call. Nothing on screen is
updating in real time.

Two mitigations belong beside this, and they matter. Flo's very next sentence says "at this point
of **the video**" `[TRANSCRIPT 09:44]`, which is consistent with playback and not with a live
session -- he is not concealing the medium. And his numeric claim is **accurate**: he says "it's
only looked at, like, 1,200 messages" against 1,284 on screen. The discrepancy is confined to the
word "live", and it is a framing slip rather than a fabrication.

### Claims that check out

An honest discrepancy list needs its complement, or it is just a search for faults.

- The routines Flo lists aloud at `[TRANSCRIPT 20:04-20:17]` -- daily brief by text, email drafting,
  email labelling, meeting notes, meeting prep, a message before this podcast -- map **one-to-one**
  onto the enabled toggles at `[FRAME 6026 / 20:05]`. Every item he names is on screen and switched
  on. The only nuance worth recording is phrasing: he says "I have an agent that..." for each, and
  what the screen shows are the product's built-in routines toggled on rather than agents he built.
- The 99% success figure on the Deep API dashboard is arithmetically consistent with its own
  breakdown `[FRAME 901 / 03:00]`.
- The 4m 44s run duration matches "four minutes" `[FRAME 1191 / 03:58]`.
- Flo's "1,200 messages" matches 1,284 on screen `[FRAME 2911 / 09:42]`.

---

## Limitations

**Attribution fragments on rapid exchanges, and the recording measures it for us.** The
segment-level fusion is 96.8% accurate on its control, but that control is dominated by clean
single-speaker footage. On fast back-and-forth it visibly fragments: at 31:24-31:27 and again at
37:44-38:08 the mechanical output alternates speakers mid-sentence, splitting what is plainly one
person's utterance across both labels. `[MEASURED]` 1310 of 1694 segments (77.3%) are shorter than
2.0 s; of those, 145 are voice-attributed with a cluster margin below 0.5, together carrying 109.6 s
= 4.2% of speech. **Treat any single sub-2-second attribution as unreliable; the aggregates are
sound because the error is not systematically biased toward either speaker.**

One instance is *proved* rather than suspected, and it is worth stating because it shows the failure
mode concretely. The fusion labels "the bottleneck at this point" at 32:20 as DAVID and the
continuation "is no longer the technology, it's you, it's your own adoption" at 32:21 as FLO. The
cold-open montage replays the identical audio at 00:12 as one continuous Flo utterance. The
32:20 label is therefore **wrong**, and it is left uncorrected in the transcript of record so that
document remains the mechanical output, with the error flagged in its header.

**Prosody is absent, not weak.** No diarizer was run, so no per-speaker pitch or energy statistic
can be computed on this mixed track. Every delivery claim above rests on frames and content.
`[NULL]`

**Disfluency counts are a floor and, for David, uninformative.** Whisper's VAD strips fillers and no
speaker-separated export exists for this recording. The measured zero for David establishes nothing.
`[NULL]`

**Diction is UNMEASURED as a speaker property.** The two-engine rule needs both engines to mangle a
term before a speaker slip can be logged. Both engines here converge on non-canonical renderings for
several product names -- "cloud code" for Claude Code (9 occurrences in whisper, 9 in the captions),
"NA10" for n8n (3 and 3), "11 Labs" for ElevenLabs (5 and 5), "whisper flow" for Wispr Flow --
but two ASR systems agreeing on the same phonetic reading is evidence about the audio, **not**
evidence that the speaker mispronounced anything; "Claude" and "cloud" are near-homophones. None of
these terms is legible on screen at the moment it is spoken, so the frames cannot adjudicate either.
**No diction slip is logged.** `[NULL]`

**The 1,284-message counter was checked over 20 seconds, not over the whole demo.** A slow-updating
counter would not have moved in that window either. The stronger evidence for playback is the
CleanShot filename in the Slack header, which is unambiguous; the frozen counter corroborates it.

**Micro-expression work is bounded by the source, not by the extraction.** At 5 fps the frames
resolve reaction arcs and gross facial state, which is what the reaction findings above rest on.
But this is an edited, colour-graded, upload-compressed 1080p file in which each participant
occupies a 960-wide panel, and true micro-expressions (40-500 ms) are not reliably recoverable from
it at any rate the source can support. No claim above rests on one.

**No preflight warning was carried forward**: the gate returned 0 failures and 0 warnings, so
nothing from it narrows this report.

**Assist-dependence analysis does not apply.** This is a THIRD-PARTY recording; there is no assist
question to ask about someone else's podcast and no substitute guess was made.

**The self-review overlay did not open, and the three document updates did not run.** No outcome
estimate, no behavioural profile comparison, no claims-ledger pass, no tracker row. These are
correct omissions for MODE 2 = THIRD-PARTY, not skipped work.

---

## Run notes

Withheld from this published copy. The section recorded the analysis host's own filesystem, process
table and toolchain -- the run's environment, not the recording -- which is out of scope for a
document about the video and is external-record content in this package by construction, on any
source. Nothing withheld here changes a finding: the attribution method and its independent control
are reported in full, with their own measured numbers, under "Attribution method, and its control"
above.
