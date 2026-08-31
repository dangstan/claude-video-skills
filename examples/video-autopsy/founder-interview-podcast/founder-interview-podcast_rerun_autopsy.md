# Founder interview podcast -- autopsy (re-run)

## Header

**Recording**: David Ondrej interviews Flo Crivello, founder and CEO of Lindy, formerly of Uber.
Published on David Ondrej's YouTube channel at `https://youtu.be/utb7zYbK10c`.

**Recorded**: 2026-08-10. `[FRAME 04:18]` The sponsor segment shows a received email whose body opens
"24-hour ticker brief -- August 10, 2026", timestamped 8:25 PM, sent to `david@davidondrej.com`.
That is the recording date read off the screen rather than off a publication field.

**Duration**: 2725.04 s video / 2725.08 s audio, aligned to 40 ms. 1920x1080.

**MODE 1 -- what kind of recording**: THE EXCHANGE. A two-participant interview. This package is the
correct one; the material is the conversation and the people in it, not the subject matter.

**MODE 2 -- self-review overlay**: THIRD-PARTY. The overlay does not open. There is no outcome
estimate, no behavioural profile check, no claims ledger, no tracker append and no assist-dependence
analysis in this document, and the three same-session document updates are skipped because there is
no private history to write for someone else's podcast.

**Source provenance**: PUBLISHED. The publication gate does not apply. Naming the video and the
participants is the point of the document, and every claim below is traceable to the public
recording or to a measurement over it. There are no `EXTERNAL-RECORD` tags in this document, which
is what a third-party autopsy of a published source should look like.

> **DEFECT NOTE, added for publication -- not run output.** The clause "the publication gate does
> not apply" is wrong, and the two sentences after it were wrong when written. The gate applies to
> every copy that leaves this machine regardless of how public the recording is, because what it
> refuses is the RUN's residue, not the subject's privacy: run from the canonical package tree
> against this document, `video-autopsy/publish_check.sh` refused it on `external-record-tag`,
> `external-record-marker` and `coverage-denominator`. There were six `EXTERNAL-RECORD` tags in
> the document, in the "Run notes" section, at the moment it claimed there were none. That section
> is the declared shell you will find at the end of this file; the tags went with it. (Both
> surviving mentions of the tag name, here and in the sentence above, are printed without their
> square brackets: the gate keys on the literal opening bracket and cannot tell a tag from a
> mention of one. No other word of either sentence was changed.) The claim
> below it -- that naming the video and the participants is the point of a third-party autopsy --
> is the part that survives.

**Face-to-name map, and the evidence for it**:

- **David Ondrej (host)**: nose tape, over-ear headphones, plain grey wall, black polo.
- **Flo Crivello (guest)**: beard, rimless glasses, Shure broadcast microphone with a green LED ring,
  window-and-brick San Francisco background, navy tee.

This is the **reverse** of what the 2026-08-10 published autopsy of this same source states. That
document is annotated with the correction. Six independent settlers agree, and they are listed in
full in "The face map, settled six ways" below.

**Transcript tier**: verbatim, faster-whisper large-v3, CUDA, float16, `vad_filter=True`,
`condition_on_previous_text=True`. 1064 segments, detected language English at p=1.000. One
hallucination loop, annotated in place in the transcript of record and recovered by re-transcription
(see "The transcript defect that erased a delivery").

**Caption cross-check**: RUN. The YouTube `en-orig` auto-caption track was fetched with the video and
deduplicated by word-suffix overlap (raw 32,556 words / 716 wpm -> 10,787 words / 239 wpm against
whisper's 10,643). Volume delta +1.4%. It is a cross-check artifact and never a transcript source.

**Audio capture**: both sides present. `rms(L)` = `rms(R)` = 1246.9, `rms(L-R)` = 21.20 (ratio
1.700%), correlation at lag 0 = 0.999855, cross-correlation peak at exactly 0 samples over a
+/-100 ms search. Same signal on both channels; downmixed to mono. This source sits in the dead zone
of the old ratio-first rule, which is why that rule was reordered so correlation and lag decide.

**Attribution method**: SETTLED, not approximate. Turn boundaries come from the caption track's own
speaker-change markers (68 of them); each turn was assigned from content plus a frame-derived
screen-mode classification, with five merged turns split by hand. Independent control below.

**Measured window**: `00:23.52-45:25.04`, minus the sponsor insert at `02:35.60-04:48.08`. That is
**2569.1 s of 2725.1 s = 94.3% coverage**. Both exclusions are stated with their reasons under the
metric passes, and the window is repeated on every aggregate computed over it.

**Frame rate**: 5 fps. 13,625 frames against a 2725.04 s duration, which is the exact expected count.

---

## The analysis

This is not a conversation between a host and a guest. It is a founder's product demonstration with
a host attached, and the recording's own structure says so before any number does. Flo Crivello holds
**71%** of the measured window against David Ondrej's 29%, produces **sixteen** continuous
floor-holds of a minute or more against David's four, and delivers the longest single hold in the
file at **2 minutes 39 seconds**. Two of the three screen shares are his, and both of them are live
demonstrations of the product he is launching in a week.

What makes that interesting rather than merely lopsided is that the imbalance is not a failure of
hosting. It is the format working exactly as designed, and the evidence for that is in the shape of
David's four long holds. They are not answers he was asked for. Three of them are extended
counter-positions -- the training-data moat argument at `18:26`, the 99%-of-slop-comes-from-humans
argument at `32:24`, and the memory-and-eyewitnesses argument at `10:41` -- and each one is delivered
into a conversation that immediately hands the floor back. David's role in this recording is to be a
credible interlocutor who has done the same work, not to extract answers. He earns the floor four
times by disagreeing usefully, and gives it back each time.

The interview has a single, consistent thesis that Flo returns to from eight different directions:
that the current generation of coding agents is **single-player software**, that this is the last
structural constraint left, and that the company which becomes the place where a team's context,
skills and integrations accumulate wins the layer. `[TRANSCRIPT 00:31]` "we are starting to see the
advent of much more multiplayer AI products", with the framing analogy that arrives thirty seconds
later and never leaves: emailing documents back and forth versus a shared Google Doc link. Every
later segment is that analogy applied to a different surface -- Slack as the room the AI is not in,
a wiki that builds itself, routines that fire without being invoked, a team file system, a team
memory.

The strongest passage in the recording is not the thesis, though. It is the twenty seconds at
`22:47` where Flo stops arguing and tells a story about his father, a magazine publisher who rebooted
his business when the internet arrived, fired a lot of people, nearly died several times, and is now
fine while every competitor who did not take the risk is on a slow slide. `[TRANSCRIPT 24:48]` "he
transformed his business for the internet era, and all his competitors who didn't do that, and they
didn't take the risk, and they didn't make the mistakes, it's just a slow death. You just descend
into death, little by little." It is the only claim in forty-five minutes that is backed by
something other than an assertion about the future, and it sits inside his longest floor-hold, which
is the correct place for it.

The second-strongest passage is an admission. `[TRANSCRIPT 13:36]` Flo describes a moment where the
agent told him and his team that the decision they were debating did not matter, and that they were
being distracted from something else. The reason it works is that it is a story about the product
telling its owner he was wrong, which is the only kind of demo claim that is hard to fake.

And the recording has a real seam in it, which is the reason a forensics pass on a promotional
interview is worth running at all. Three separate times the words on the audio track and the pixels
on the screen do not agree, and in every case the screen is less flattering than the narration. Two
of those three are inside the paid sponsor segment. One is inside Flo's own strongest supporting
citation. They are set out in full under "Narration versus screen" and they are the highest-value
output of this pass.

### The face map, settled six ways

The published autopsy of this recording inverted the two participants and, in doing so, credited the
video's paid DeepAPI sponsor read to the guest, who did not deliver it. The rules written in response
-- bind each face from two disjoint sources, re-verify at a timestamp at least half the recording
away, and treat a personalised on-screen surface as naming the SHARER rather than the SPEAKER -- had
never been executed by a run. This run executed them, and the footage turned out to contain far more
than the two disjoint sources the rule asks for.

1. `[TRANSCRIPT 00:23.53]` "All right Flo, so far AI has been more single player."
   `[FRAME burst_addressflo_0020]` puts the nose-taped speaker mid-utterance. The speaker addresses
   Flo by name, so the speaker is not Flo.
2. `[TRANSCRIPT 00:37.93]` "I don't know if you're old enough David."
   `[FRAME burst_agecheck_0032]` shows the bearded speaker delivering it. He is not David.
3. `[FRAME burst_sponsor_0240]` The DeepAPI dashboard reads `SIGNED IN david@davidondrej.com`, with
   API credentials `new-david-global-key` and `david-hermes-agent`. Exactly one webcam is on screen
   through that whole burst and it is the nose-taped participant, visibly speaking. The
   personalised-surface rule's failure mode -- a share frame showing every participant's camera at
   once -- does not hold here, which is precisely why this source is admissible and the one that
   caused the original error was not.
4. `[FRAME 04:18]` The Codex prompt on screen reads "my email is `david@davidondrej.com` btw", and
   the agent's reply reads "Email sent to `david@davidondrej.com`". The sponsor segment's operator
   types his own address into his own agent.
5. `[FRAME 21:36]` On Flo's shared Lindy Routines page, a custom routine reads "Check UXR and
   onboarding calls -- Check tomorrow's calendar for UXR and assistant onboarding calls, **then text
   Flo** to confirm sending". A personalised surface on the guest's side, naming the guest as the
   sharer. This is the mirror image of settler 3 and it is the first one this track has produced from
   the guest's account rather than the host's.
6. **Re-verification 44.7 minutes after the binding.** `[TRANSCRIPT 45:07-45:17]` The nose-taped
   participant says "I want to be respectful of your time... Where should people go?" and the bearded
   participant answers "Go to lindy.ai" `[FRAME burst_reverify_4505]`. Lindy is the guest's company;
   the wrap-up plus "we're also going to include your Twitter and socials below" is channel-owner
   language. `[FRAME 45:13]` shows the lindy.ai landing page as an editor overlay at that moment.

`[MEASURED]` **Verdict on the rule**: executed as written, this footage yields six disjoint binding
sources and all six agree. The rule is executable, not merely well-intentioned. The caveat from the
first session still bounds it -- the correct map was already in the operator's notes before this run
started, so this is not a blind test of whether the rule catches the error. What it does establish,
and what was not contaminated by prior knowledge, is that the evidence the rule demands is actually
present in material of this kind.

`[MEASURED]` **Consequence for the published document**: the DeepAPI sponsor read at `02:35-04:48` is
delivered by **David Ondrej**, the host. Correcting the shipped example was not part of this run.

### The trap that would have re-created the error, and it is not the one that was fixed

The original run identified the wrong speaker from a personalised screen. The rule written in
response guards that path. This run found a **second, independent path to the same wrong answer**,
and it is one nothing currently guards.

The caption track carries 68 speaker-change markers. Reading them as a strict alternation is the
obvious thing to do, it is cheap, and it looks authoritative. `[MEASURED]` Strict alternation
anchored on the unambiguous opening question assigns the **entire sponsor read to Flo Crivello** --
the exact error, arrived at by a completely different route, with no personalised screen involved at
all. The alternation is correct for the first seven turns and then breaks, because the editor's hard
cut into the pre-recorded advertisement is not a speaker change the caption model can see, so the
marker is missing and the parity inverts for everything after it. Four more missing markers do the
same thing later in the file, at `14:24`, `19:02`, `27:10` and `31:28`.

`[MEASURED]` The control that catches it: the frame-derived screen-mode classifier, run over all
13,625 frames, labels `02:35-04:48` as a dark-UI screen share with a single circular webcam inset,
and that inset is the nose-taped participant. Content and pixels agree; the alternation does not.

The general lesson is that a turn-boundary signal is not a speaker-identity signal, and converting
one into the other by alternation silently assumes no boundary was ever missed. Where the recording
is EDITED, that assumption is guaranteed to fail at exactly the cuts that matter most, because a hard
cut is both the place a marker is most likely to be missing and the place the content changes most.

### The transcript defect that erased a delivery, and the detector that could not see it

`[MEASURED]` Four zones in the whisper output consist of runs of consecutive segments whose duration
is exactly 1.00 s: `07:25.50-07:30.50` (5 segments), `12:19.34-12:24.34` (5), `36:12.04-36:40.04`
(28), `41:53.34-41:59.34` (6). Inside the largest zone the text collapses into the literal segment
"Yeah." repeated thirteen times. Zone median compression ratio is 2.041 against 1.821 for the rest of
the file; `avg_logprob` is essentially unchanged at -0.181 against -0.172; `no_speech_prob` is 0.

`[MEASURED]` All four zones were re-transcribed in isolation with `condition_on_previous_text=False`,
same model, same device, same audio file. Three came back clean with no loop. The fourth recovered
coherent speech across the whole span, and the caption track independently agrees with the recovery.
The recovered passage is Flo's existential-risk answer:

> `[TRANSCRIPT 36:26.88-36:49.54, clean re-transcription]` "and I call them like death or house cat,
> right? So death is we all die, you know, man, and house cat is like -- well, just, you know, if you
> have a cat, like they don't do much all day -- and so I think those are the... and even the upside,
> like even the best case scenario, which is the -- even that upside is going to be a shitter."

The passage is not lost from the file: "death or house cat" survives in the original lines before the
loop begins. What the loop destroyed is roughly thirteen seconds of the delivery and the segment
timing across twenty-eight seconds. Both are annotated in place in
the transcript of record, which is not published with this example; the original lines were
left unedited.

`[MEASURED]` **The part worth carrying is the negative result.** The caption cross-check's dropout
detector -- caption text with no whisper counterpart in the same window -- returns **zero** flagged
bins on this file, at any threshold that is not absurd. Whisper did not go silent. It emitted fluent,
short, well-formed text at plausible density, and every time-based check reads clean. A detector
keyed on ABSENCE cannot see a wrong-value failure. The signals that did work were the exact-1.00 s
duration run (which is a structural artifact of the loop, not a content test) and the compression
ratio. Volume delta was +1.4%, which is inside noise and would not have raised a flag on its own.

---

## What landed and what did not

**Landed: the Slack demonstration at `07:17-08:40`.** Flo asks `[TRANSCRIPT 07:17]` "Can I share my
screen real quick?" and gets `[TRANSCRIPT 07:17]` "Yeah, of course" inside a second. What follows is
the strongest thirty seconds of product argument in the recording, because it is not a feature list:
he shows a Slack thread in which a teammate asked a billing question, the agent answered it from a
document, and the correction "It wasn't Lindy. It was Jeremy." happened in-thread with no re-prompting.
`[FRAME 10:20]` confirms the account is his -- the thread is authored by "Flo" at 12:25 AM and the
reply is from the "Lindy" app. `[MEASURED]` David's response is his single longest floor-hold of the
first half, 53 seconds, and it extends the idea rather than acknowledging it. That is what landing
looks like in this format.

**Landed, and it is the moment the format justifies itself: `10:41-12:22`.** David takes the floor
for 101 seconds to make an argument Flo has not made -- that humans are unreliable at memory (court
eyewitnesses), so the delegation case is not about capability but about which faculty is being
delegated -- and then grounds it in his own 15-minute time-tracking practice and what a model found
in 250-300 calendar events. `[MEASURED]` Flo's reply opens "Yeah. A hundred percent" and runs 122
seconds. Neither man is performing agreement; they are building.

**Did not land, and the frames say so: the existential-risk turn at `35:42-38:09`.**
`[FRAME burst_agirisk_3608]` Across a nine-tile burst spanning `36:08-36:20`, Flo delivers the
"biggest topic in human history" and the death-or-house-cat framing with raised eyebrows, open-mouth
laughter in two tiles, and both hands up in three. He is doing a bit. `[FRAME burst_agirisk_3608]`
David, in the same nine tiles, is flat: neutral mouth throughout, eyes down in three of nine, no
mirroring of the humour at any point. `[MEASURED]` David's total contribution across the whole
314-second phase is 80 seconds, 26%, his second-lowest share of any substantive phase. Read from the
transcript alone this passage looks like a sober exchange about AI risk. Read from the pixels it is
one man doing a rehearsed comedy beat and the other waiting for it to end so the interview can
resume. `[HYPOTHESIS]` The most likely explanation is not disagreement but topic fatigue -- Flo says
so himself twenty seconds earlier, `[TRANSCRIPT 35:51]` "I almost try to not think about it too much
anymore... I'm tired. I am so tired" -- and David does not pick the thread up.

**Did not land: `16:30-16:56`.** Flo names n8n twice as a cautionary tale, `[TRANSCRIPT 15:50]` "you
had some videos as well, like [n8n], you know, it was like all the rage last year... we don't hear
like too much about [n8n] anymore. And I think one reason is like, it's just too hard to use." He is
telling a YouTuber that a tool the YouTuber made videos about has faded, on that YouTuber's channel.
`[FRAME burst_n8n_1630]` David's reply is agreement, not defence, and the burst shows him neutral
through it; Flo, on screen for the second half of the burst, spends four of nine tiles drinking from
a can while David talks. `[HYPOTHESIS]` The moment is a small missed opening: the obvious follow-up
-- what specifically made it too hard, and does the multiplayer thesis actually solve that -- is
never asked, and the conversation moves on to a general point about ease of use.

**Never tested: the closing.** `[TRANSCRIPT 45:07-45:26]` Nineteen seconds, two questions, a URL and
a thank-you. `[MEASURED]` The close is 0.7% of the recording. There is no next-step content, no
commitment, and nothing agreed. For a published promotional interview that is the correct length, and
the only reason it is reported at all is that the closing segment is the one this package flags as
routinely skipped -- here it genuinely contains nothing, and saying so is the finding.

---

## The metric passes

**All figures below are computed over the measured window `00:23.52-45:25.04` minus the sponsor
insert `02:35.60-04:48.08` = 2569.1 s of 2725.1 s = 94.3% coverage.** The two exclusions:

- **The cold-open montage, `00:00.00-00:23.52`, 23.5 s.** `[FRAME 00:00-00:23]` An edit montage of
  four separate Flo quotations lifted from `22:47`, `32:00` and elsewhere, cut over title cards. It
  is not conversation and counting it would double-count his words.
- **The sponsor insert, `02:35.60-04:48.08`, 132.5 s.** `[FRAME]` A dark-UI screen share with a
  single webcam inset, no second participant present, no turn-taking. It is a pre-recorded
  advertisement spliced into the interview, delivered by David. Including it would move his talk
  share by roughly five points and would attribute a 132-second uninterrupted monologue to a
  conversation in which he never held the floor that long.

### Talk-share and turn-taking `[MEASURED]` -- ESTIMATE, see the control

| | speech time | share | words | share | rate |
|---|---|---|---|---|---|
| Flo Crivello (guest) | 1811.0 s | 71.4% | 7105 | 70.5% | 235.4 wpm |
| David Ondrej (host) | 724.9 s | 28.6% | 2973 | 29.5% | 246.1 wpm |

**Ratio, by time: 71/29.** Time share and word share agree to within one point, which means the split
is genuinely about floor time and not about one man talking faster.

This is an **ESTIMATE**, because no speaker-separated export exists for a YouTube podcast and
whisper does not diarize. It is a considerably stronger estimate than the label usually implies, and
the reason is the control:

`[MEASURED]` **Control -- does the map agree with who the editor put full-frame?** Over the measured
window there are 368.4 s in which the editor cut to a single speaker filling the frame, which is an
independent signal the attribution never consulted. Agreement:

| frame class | frames | seconds | agree | rate |
|---|---|---|---|---|
| `DAVID_FULL` | 588 | 117.6 | 551 | 93.7% |
| `FLO_FULL` | 1254 | 250.8 | 1209 | 96.4% |
| combined | 1842 | 368.4 | 1760 | **95.5%** |

The residual 4.5% is expected and is not all error: an editor holds a reaction shot on the listener,
and a cut lands a beat before or after the turn does.

### Continuous floor-holds `[MEASURED]`

Consecutive same-speaker spans merged, with backchannels shorter than 4 s absorbed. Every merged
block was inspected by hand, because the merge does not know a window boundary is there; the two
blocks that straddle the sponsor exclusion were checked and neither is an artifact.

**Twenty blocks of 60 s or more: sixteen Flo, four David.**

| | speaker | length | at |
|---|---|---|---|
| 1 | Flo | 158.6 s | 22:47.8-25:26.3 (the magazine-publisher story) |
| 2 | Flo | 137.8 s | 35:51.2-38:09.0 (existential risk) |
| 3 | Flo | 135.0 s | 27:22.7-29:37.8 (the shoe factory) |
| 4 | Flo | 128.2 s | 04:48.2-06:56.5 (Lindy Teammate reveal) |
| 5 | Flo | 122.3 s | 12:22.6-14:24.8 (context, John von Neumann) |
| 6 | Flo | 120.9 s | 08:40.2-10:41.1 (the hydration demo) |
| 7 | **David** | **101.4 s** | 10:41.1-12:22.6 (memory and eyewitnesses) |
| 8 | Flo | 101.3 s | 33:02.4-34:43.7 (work ON the machine) |
| 9 | Flo | 98.8 s | 25:32.1-27:10.9 (let a thousand flowers bloom) |
| 10 | Flo | 96.1 s | 19:02.5-20:38.6 (his own agent setup) |
| 11 | Flo | 93.4 s | 41:05.8-42:39.2 (indie versus VC-backed) |
| 12 | Flo | 89.7 s | 16:56.6-18:26.2 (the ElevenLabs integration story) |
| 13 | Flo | 80.4 s | 43:47.0-45:07.4 (hardware and capital rotation) |
| 14 | Flo | 70.0 s | 20:42.9-21:52.9 (the routines walk-through) |
| 15 | **David** | **67.8 s** | 30:20.6-31:28.4 (the Middle Ages comparison) |
| 16 | **David** | **67.5 s** | 34:43.7-35:51.2 (harness, environment, context) |
| 17 | Flo | 63.8 s | 15:26.2-16:30.0 (bullish on Slack) |
| 18 | **David** | **61.4 s** | 14:24.8-15:26.2 (single-player agents blowing up) |
| 19 | Flo | 61.4 s | 38:45.7-39:47.0 (riding the wave, turpentine) |
| 20 | Flo | 60.4 s | 00:31.0-01:31.4 (the opening thesis) |

**Longest: Flo 158.6 s, David 101.4 s.** The excluded sponsor insert is a 132.5-second David
monologue and would be his longest block if counted; it is not counted, and the distinction matters,
because a pre-recorded advertisement is not a floor-hold in a conversation.

The shape is the finding. Flo's blocks are evenly spread -- one every two to three minutes for the
whole recording -- which is what a founder doing a launch interview looks like. David's four are
clustered in the middle third, between `10:41` and `15:26` and again at `30:20-31:28`, which is
where the conversation is most argumentative and least demonstrative. When the screen shares stop,
the split moves.

### Silence and pace, per phase `[MEASURED]` -- and one of them is VOID

**VOID: the per-phase silence table.** `[MEASURED]` There are exactly **two** inter-segment gaps
above 0.8 s in forty-five minutes: 2.00 s at `36:40` and 1.26 s at `00:22` (the cut out of the cold
open). Speech covers 2682.9 s of 2725.1 s = 98.5%. On this source a silence metric measures the
EDITOR, not the speakers, and reporting it as a behavioural number would describe an unusually
fluent conversation that does not exist. It gets this line and is dropped. Note also that the longer
of the two "gaps" sits at the trailing edge of the hallucination loop, so even the residual silence
signal on this file is partly an artifact of the ASR rather than of the audio.

Speech rate and talk-share per phase do survive, because they are computed inside speech.

| phase | dur | Flo | David | dominant screen |
|---|---|---|---|---|
| P1 cold-open montage | 24 s | VOID (montage) | VOID | share/title 69% |
| P2 single- to multi-player thesis | 132 s | 76 s / 61% / 249 wpm | 48 s / 39% / 243 wpm | split 49% |
| P3 SPONSOR INSERT | 132 s | EXCLUDED | EXCLUDED | dark share 92% |
| P4 hardware + Teammate reveal | 150 s | 125 s / 86% / 238 wpm | 20 s / 14% / 213 wpm | split 64% |
| P5 screen-share demos | 305 s | 150 s / 49% / 218 wpm | 154 s / 51% / 250 wpm | split 54% |
| P6 context, intelligence overrated | 247 s | 184 s / 75% / 257 wpm | 61 s / 25% / 244 wpm | split 85% |
| P7 integrations, moats, first mover | 142 s | 87 s / 64% / 233 wpm | 48 s / 36% / 242 wpm | split 77% |
| P8 personal agent setups | 236 s | 160 s / 70% / 253 wpm | 68 s / 30% / 258 wpm | split 64% |
| P9 reinvention, play, the magazine | 164 s | 156 s / 96% / 220 wpm | 6 s / 4% / 280 wpm | split 85% |
| P10 running a company in chaos | 288 s | 245 s / 85% / 227 wpm | 43 s / 15% / 252 wpm | split 85% |
| P11 diffusion of innovation | 162 s | 56 s / 35% / 219 wpm | 105 s / 65% / 240 wpm | split 88% |
| P12 work ON the machine | 160 s | 102 s / 64% / 237 wpm | 58 s / 36% / 219 wpm | split 91% |
| P13 AGI risk, death or house cat | 314 s | 232 s / 74% / 246 wpm | 80 s / 26% / 261 wpm | split 83% |
| P14 what to build in Q3 2026 | 251 s | 229 s / 91% / 224 wpm | 22 s / 9% / 246 wpm | split 81% |
| P15 close | 18 s | 8 s / 46% / 216 wpm | 9 s / 54% / 267 wpm | split 68% |

Three things fall out of that table that the whole-call number hides.

`[MEASURED]` **P5 is the only balanced phase in the recording (49/51)**, and it is the phase with
both live screen shares in it. A screen share is usually where a guest runs away with the floor. Here
it is the one place David matches him, because a demonstration gives him something concrete to
respond to. Everywhere the screen goes back to two talking heads, the split reverts to 70/30 or worse.

`[MEASURED]` **P11 is the only phase David wins (65/35)**, and it is the one where he brings his own
material -- the Middle Ages comparison, the "99% of slop comes from humans" argument, the anecdote
about telling his own team that everyone now has a world-class engineering team. It is 162 seconds
out of 2569.

`[MEASURED]` **The two most one-sided phases are P9 (96/4) and P14 (91/9)**, and they are the
magazine-publisher story and the closing advice segment -- a narrative and a direct request for
advice. Both are phases where handing over the floor entirely is the right call.

`[MEASURED]` **Speech rate barely moves.** Flo runs 218-257 wpm across every phase, David 213-280.
The whole file averages about 234 wpm. Neither man speeds up under pressure or slows down when
thinking, and the one outlier -- David at 280 wpm in P9 -- is six seconds of backchannel and should
not be read as a rate at all.

### Disfluency `[MEASURED]` -- and this is why it is normalised per speaker

Counted from whisper text and therefore a **FLOOR**: whisper's VAD strips most true fillers, and the
YouTube edit strips more. There is no speaker-separated export for this recording, so these are
under-counts by an unknown amount, and the ratio between speakers is more trustworthy than either
absolute number. Normalised per that speaker's own minute of speech (Flo 29.9 min, David 12.3 min).

| marker | Flo, n | Flo /min | David, n | David /min |
|---|---|---|---|---|
| "like" | 416 | 13.91 | 209 | **17.00** |
| "you know" | 81 | 2.71 | 46 | **3.74** |
| "right?" | 29 | 0.97 | 11 | 0.89 |
| "actually" | 17 | 0.57 | 3 | 0.24 |
| "basically" | 16 | 0.54 | 2 | 0.16 |
| "uh" | 12 | 0.40 | 2 | 0.16 |
| "I mean" | 2 | 0.07 | 6 | **0.49** |
| "um" | 2 | 0.07 | 0 | 0.00 |
| "100%" / "1000%" | 3 | 0.10 | 5 | **0.41** |

`[MEASURED]` **The raw counts and the normalised rates disagree in direction on the two most common
markers.** Flo says "like" twice as often as David in absolute terms, and *less* often per minute of
his own speech: 13.9 against 17.0. Same for "you know": 2.71 against 3.74. A report that printed the
raw column would have said the guest is the more disfluent speaker. The normalised column says the
opposite, and the normalised column is the one that answers the question.

`[MEASURED]` **The profile is discourse-marker-heavy, not um-heavy.** Fourteen instances of "um" and
"uh" combined across the entire file against 625 of "like" and 127 of "you know". On 10,643 words
"like" alone is 5.9% of everything said. Neither man hesitates; both use "like" as a rhythmic filler,
which is a different thing and does not read as uncertainty.

`[MEASURED]` "100%" and "1000%" as a standalone agreement token is David's tic at four times Flo's
rate per minute, which is consistent with the host role -- it is what he says while handing the floor
back.

### Prosody `[NULL]`

Not attempted. A single mixed podcast track with no diarization and no per-speaker channel does not
support it. Every prosodic claim that could be made here would be HYPOTHESIS-grade at best, and the
behavioural readings in this document come from the frames instead, where they are checkable.

---

## Screen and technical findings

`[MEASURED]` **Screen-mode classification, all 13,625 frames, computed first.** Six fixed probe
regions per frame, classified on background colour and brightness: David's flat grey wall, Flo's
blue-sky window, bright UI, dark UI. Reduced to 235 runs.

| mode | frames | seconds | share |
|---|---|---|---|
| SPLIT (both webcams, David left / Flo right) | 9736 | 1947.2 | 71.5% |
| FLO_FULL (guest full-frame) | 1277 | 255.4 | 9.4% |
| SHARE_LIGHT (light-UI share or graphic overlay) | 1082 | 216.4 | 7.9% |
| SHARE_DARK (dark-UI share) | 678 | 135.6 | 5.0% |
| DAVID_FULL (host full-frame) | 594 | 118.8 | 4.4% |
| OTHER (transitions, title cards, hybrids) | 258 | 51.6 | 1.9% |

`[MEASURED]` **The classifier was controlled before any number derived from it was believed.** Six
random samples per class were tiled and read (a tiled validation sheet, not published with this example). SPLIT,
FLO_FULL and DAVID_FULL were correct 6/6 each. SHARE_DARK was correct 6/6 and every one of the six
falls inside the sponsor segment with David's inset visible, which is a seventh corroboration of the
face map arriving as a by-product. SHARE_LIGHT is the loose class: it correctly captures live light-UI
shares but also absorbs editor graphic overlays where one speaker remains on screen, so it is
reported as "light-UI share OR overlay" and no metric is derived from it alone. OTHER is genuinely
mixed and nothing is derived from it.

`[MEASURED]` **The editor cuts to a single face for 13.8% of the recording and shows both for 71.5%.**
The ratio of FLO_FULL to DAVID_FULL is 2.15:1, against a talk-share ratio of 2.50:1. The editor
gives David slightly more screen than his floor time, which is the normal shape of a host-led edit.

**Live screen shares, three of them, all reconstructed:**

**1. The DeepAPI sponsor segment, `02:35-04:48`, David's screen.** `[FRAME 01:35]` A GitHub-style
skills list is on screen before the ad proper: `kimi-ro[uter]`, `tailscal[e-vps-setup]`,
`agent-[fleet-manager]`, each labelled "Claude", with a green "Shell" indicator, under an MIT
licence. `[FRAME 02:14]` A Cloudflare chart titled "AI agent requests (Billions per day)" spanning
June 1 2025 to May 31 2026. `[FRAME 03:20]` The Codex UI with three tasks in the sidebar plus a
fourth ("250 vets") never mentioned aloud.

**2. Flo's Slack thread, `07:17-08:40`.** `[FRAME 10:20]` A thread authored by "Flo" at 12:25 AM
reading "@Lindy catch me up on the highlights from lindy teammate onboarding calls this week", with a
five-paragraph reply from the "Lindy" app naming design partners, the "Chat with 50 meetings"
feature, Skills and routines, per-app approval controls, and memory files. Narration and screen
agree.

**3. The automatic-hydration demo, `08:40-10:41`.** `[FRAME 09:32-09:47]` A Lindy file system, a
"master memory file" headed "Here's what I'm learning about you, Flo.", a live-updating learnings
list ("Slack hydration is your most active initiative right now"; "You care about momentum without
hiding risk. Your threads repeatedly ask what is blocked, what can merge, and what still needs
proof."), a still-learning counter, and a "How your team connects" node graph with labelled nodes
including Reliability. **This is the exact frame class that caused the original inversion** -- a
personalised surface reading "Flo" with BOTH webcam insets visible at bottom-left and bottom-right --
and it is preserved here as the worked example of why the surface names the sharer and not the
speaker.

**4. The Routines page, `20:03-21:36`, Flo's screen.** `[FRAME 21:36]` Reconstructed at 1.9x LANCZOS.
Left nav: Chat, Meetings, Files, Routines, Skills, Agents, Integrations. Built-in routines include
daily briefs, email drafting, email labelling, meeting note-taking, meeting prep, meeting
scheduling, email alerting ("Alerts you to time-sensitive emails") and follow-up ("Drafts a bump when
sent emails get..."). Custom routines, with their toggle states:

| routine | description | state |
|---|---|---|
| Weekly AI authors research and outreach | Research independent AI blog authors, and manage recruiting outreach with follow-up timers | ON |
| On-call issue ticket creation | Evaluate Slack messages for issues, ticket creation in-thread when appropriate | ON |
| Check UXR and onboarding calls | Check tomorrow's calendar for UXR and assistant onboarding calls, then text Flo to confirm sending | ON |
| Weekly meal score | Calculate weekly meal score and send | ON |
| On-call issues human redirect | Create tickets for every on call report | **OFF** |
| Weekly learning digest | Summarize learnings from the Daily L[og] | ON |
| Daily todos reminder | Send text at 5pm with all open loops | ON |

`[MEASURED]` Narration and screen **agree** here, and specifically: `[TRANSCRIPT 21:00]` "I have an
agent every week research new blog posts, like indie blog posts that were written by engineers, and
then send me a list" matches "Weekly AI authors research and outreach"; `[TRANSCRIPT 20:45]` "at the
end of the week, it's like shaming me, it sends me a text with your score for the week" matches
"Weekly meal score". This is the control case for the discrepancy findings below: when Flo narrates
his own screen, he narrates it accurately.

**5. The Listen Labs overlay, `33:44`, 2.8 seconds.** `[FRAME 33:44]` An editor B-roll overlay, not a
live share. Contents reconstructed in "Narration versus screen" below.

**6. The closing overlay, `45:13`.** `[FRAME 45:13]` The lindy.ai landing page, "hey, I'm Lindy / I
take admin work off your plate", with a G2 badge reading 4.9.

**Typing activity, on-screen errors, code reconstruction**: `[NULL]`. No live coding occurs in this
recording. There is no editor region to measure a pixel delta in and no error counter to control a
red-pixel heuristic against, so neither metric is computed. The red-pixel error heuristic is
explicitly NOT reported, because the control it requires -- an editor's own problem counter legible
in the same frames -- does not exist anywhere in this footage.

---

## Narration versus screen

Three discrepancies. All three are places where the screen is less flattering than the words, and two
of the three are inside the paid segment. These are the highest-value findings in this document.

### 1. The sponsor read overstates a run time by 2.3x `[FRAME 03:20]` `[TRANSCRIPT 03:19.96]`

**Narrated, twice**: "So it ran for 30 minutes. It used Deep API to research that." and, seventeen
seconds later, "so in this case, after 30 minutes, it created 100 unique contractors."

**On screen**: `Worked for 13m`.

`[MEASURED]` This is not an ASR artifact and the two-engine rule was applied before it was logged:
the YouTube caption track independently renders both sentences as "30 minutes"
(`[00:03:20.000]` and `[00:03:36.000]`). Two engines agree on the words; the frames disagree with
both. Per the adjudication rule, where the term is visible on screen the frames outrank both engines,
and here what is visible is the number itself.

### 2. The same sponsor read presents as a clean success a result whose own output says the requested source does not exist `[FRAME 03:20]`

**The prompt on screen**: "get me 100 active licensed general contractors in Austin, Texas from the
state licensing records. name, website, phone, email. table."

**Narrated**: "after 30 minutes, it created 100 unique contractors. It outputted a markdown table.
You can see very clearly, boom, all 100 contractors."

**On screen, in the agent's own reply, immediately above the line being pointed at**:

> "Completed. **Texas does not issue statewide general-contractor licenses. Austin registration is
> local and [...] state-licensed" records do not exist.** Created 100 unique Austin contractors:
> [Markdown table / CSV / JSONL with source records / Methodology and official sources]
> **Coverage: 88 websites, 98 phone numbers, and 40 publicly listed emails. Missing details a[re...]**"

`[MEASURED]` The requested source -- state licensing records -- does not exist, and the agent says so
on screen. The requested fields are 40% complete on email and 88% on website, and the agent says that
on screen too. The narration reports the row count and stops. `[HYPOTHESIS]` This is very likely
ordinary advertising compression rather than an attempt to mislead: the agent did produce a hundred
rows, the caveats are visible to any viewer who pauses, and the narrator is reading over a screen he
is also showing. It is still the cleanest example in the recording of what this package exists to
catch, because an audio-only pass produces "the agent got 100 licensed contractors in 30 minutes"
and every one of those four facts is wrong or unsupported.

For balance, the second sponsor task checks out. `[FRAME 04:03]` The prompt reads "check the last 24
hours of news and sentiment on these 8 tickers: NVDA, TSLA, AMD, PLTR, COIN, ASTS, SOFI, MSTR. email
me a short brief"; the screen reads `Worked for 4m 44s` against a narrated "ran for four minutes";
`[FRAME 04:18]` the resulting email is on screen, from `cleanh...@deepapimail.com`, subject "24-hour
news & sentiment: NVDA, TSLA, AMD, PLTR, COIN, ASTS, SOFI, MST[R]", with per-ticker sentiment lines
that match what was claimed. The delivered artifact is real.

### 3. Flo's strongest supporting citation contains, on screen, the qualification he does not make `[FRAME 33:44]` `[TRANSCRIPT 33:39]`

**Narrated**: "Listen Labs, I don't know if you saw, recently had these awesome tweets that had an
intern build like an app. And they had -- well, obviously you have a coding agent build the app, but
then you have a user research agent that continuously gathers feedback from users about the app and
then talks to the coding agent to ask it what to change. And, like, the app is basically completely
self-improving right now."

**On screen for 2.8 seconds**, the Listen Labs post he is citing:

> "In our zero-person company experiment, the agent made every product improvement based on insights
> from real customer conversations.
>
> **There were limitations - the agent didn't properly prioritize which insights to act on and
> rediscovered findings a researcher would've known to** [Show more]"

`[MEASURED]` The citation's own second paragraph is the counter-argument, it is legible in the frame,
and the narration stops at the first paragraph. `[HYPOTHESIS]` The overlay is an editor insert rather
than something Flo chose to put on screen, so this is most likely an editorial accident rather than
selective quotation -- but the effect on a viewer is the same, and it is the only place in the
recording where the evidence for a claim visibly undercuts it.

---

## The ASR ledger, adjudicated

The two-engine requirement was satisfied for the first time on this source: the YouTube auto-caption
track is the second reading. Where the term is visible on screen, the frames outrank both engines.
Fourteen items, plus one new one found by the cross-check itself.

| # | whisper heard | captions heard | settled | how |
|---|---|---|---|---|
| 1 | "in France, businesses like BayStan" | "inference businesses like banan" | **"INFERENCE businesses like Baseten"** | captions on "inference"; both mangle "Baseten"; named beside Fireworks and Together, all inference providers |
| 2 | "more DPUs than we could possibly imagine" | "more GPUs" | **"GPUs"** | captions |
| 3 | "people send each other like .mdb. files" | "MD files" | **".md files"** | captions |
| 4 | "my cloud that MD file is now basically empty" | "my cloud MD file" | **"my CLAUDE.md file"** | captions closer; no screen |
| 5 | "have you not spoken to change your voice" | "have you not spoken to JGBT" | **"ChatGPT"** | captions; NEW, found by the cross-check |
| 6 | "let's jump into Codex" | "let's jump into CEX" | **"Codex"** | `[FRAME 03:05]` the Codex UI is on screen |
| 7 | "cloud code" (throughout) | "cloud code" (throughout) | **"Claude Code"** | `[FRAME 01:35]` each skill on screen is labelled "Claude" |
| 8 | "Ray Keltzweil in 2015" | "Ray Kilz in 2015" | **"Ray Kurzweil"** | both mangle; "AGI guy since 2015", "AI-pilled me" |
| 9 | "Kapasi was talking about this self-building wiki" | "copasy" | **"Karpathy"** | both mangle; semantics |
| 10 | "big rich or big crunch" | "Big Rich or Big Crunch" | **"Big Rip or Big Crunch"** | both mangle; paired cosmology terms |
| 11 | "away from software and two-wheeled hardware" | "two worlds hardware" | **"toward hardware"** | both mangle; the sentence is about a rotation of capital |
| 12 | "like NA10, it was all the rage last year" | "like NA10" | **"n8n"** `[HYPOTHESIS]` | both engines agree on NA10, which is a phonetic rendering of "n-eight-n"; no screen; context is a workflow tool that peaked and became "too hard to use" |
| 13 | "GBD 5.6 Pro" / "Fable 5" | "GBD 5.6 Pro" / "Fable 5" | **not logged as a slip** | both engines agree; "GBD" is transparently a model name but nothing on screen settles it |
| 14 | "my friend Zach Hoggett" | "Zach Hogget" | **UNRESOLVED** | both engines agree on the sound; no screen; a person's name is not guessed |
| 15 | "Pi, OpenClaw, Hermes" (02:17) / "open club blew up" (14:28) | "openclaw" (02:20) | **"OpenClaw"** | captions confirm the first occurrence; whisper spells the same term two ways in one file |

`[MEASURED]` **Fifteen items, and neither engine is reliably the better one.** Captions won 5 outright
(1, 2, 3, 4, 5), whisper won 1 (6), the frames settled 2 (6, 7), semantics settled 4 (8, 9, 10, 11),
and 3 remain HYPOTHESIS or UNRESOLVED (12, 13, 14). The single most consequential row is 7: both
engines write "cloud code" throughout a forty-five minute conversation about Claude Code, and only
the pixels correct it.

---

## Limitations

Every one of these narrows what the document above is allowed to claim.

- **Talk-share is an ESTIMATE, not a measurement.** No speaker-separated export exists. The 95.5%
  frame-agreement control bounds the error but does not eliminate it, and the residual is not
  randomly distributed -- it concentrates on short turns, where a cut lands off the boundary. Any
  single figure in the talk-share table should be read as +/- one to two points, and the sixteen-to-four
  block count is more robust than the 71/29 split.
- **Attribution inside merged turns is hand-adjudicated.** Five caption turns contain two speakers.
  The split points were chosen by reading, at `02:35`, `14:24`, `19:02`, `27:10` and `34:43`. Four of
  the five have frame evidence on both sides of the split; the one at `19:02` does not, and rests on
  content alone (`[TRANSCRIPT 19:55]` "it sends me a message right before this podcast... you're
  meeting with David", which can only be Flo).
- **Two turns are genuinely ambiguous and were assigned to David without frame support**, `16:30` and
  `16:45`. Together they are 26.5 seconds, or 1% of the window. If both are wrong the split moves by
  one point.
- **The per-phase silence table is VOID**, and with it any reading about hesitation, thinking time or
  pace under pressure. The edit removed the evidence. This is the single largest thing this document
  cannot tell you about these two people.
- **Prosody is NULL.** One mixed track, no diarization.
- **Disfluency counts are a FLOOR of unknown depth.** Whisper's VAD strips fillers and the edit strips
  more; the cross-speaker ratio is the trustworthy part, the absolute numbers are not.
- **Segment timing is DEGRADED across four spans** totalling 44 seconds (`07:25-07:30`,
  `12:19-12:24`, `36:12-36:40`, `41:53-41:59`). Anything derived from segment boundaries inside them
  -- and that includes the two surviving silence gaps, one of which sits at the edge of the largest
  zone -- is unreliable. Word content is recovered and annotated.
- **Micro-expression work is bounded by the layout.** For 71.5% of the recording both faces are on
  screen at roughly half width, which resolves expression but not micro-expression. Every visual
  affect claim in this document cites a burst by name and none of them rests on a face smaller than
  a quarter of the frame.
- **The face-map rule was not blind-tested.** The correct map was recorded in the operator's notes
  before this run began. What is established is that the evidence the rule demands exists in this
  footage, not that the rule would have caught the error unaided.
- **`[NULL]` Why the original run inverted the faces is not established by this run.** The
  personalised-screen mechanism is a good explanation and the frame at `09:32` shows exactly the
  ambiguity it describes, but no artifact from the original run was inspected here, so that remains
  the published document's own account rather than something re-verified.
- **The SHARE_LIGHT screen class is loose** (live shares and editor overlays both land in it) and no
  metric is derived from it alone.
- **Typing activity and on-screen error metrics are not computed at all**, because the recording
  contains no live coding and the red-pixel heuristic has no control available in this footage.
  Reporting it uncontrolled would produce confident nonsense.

---

## Run notes

> REMOVED AT PUBLICATION. This section is external by construction: it is built from records
> outside the recording -- the machine this run executed on, its toolchain, and the scripts that
> regenerate the numbers above. None of it is evidence about the video.
