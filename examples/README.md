# Examples

Real outputs of real runs -- not mockups. **Three source videos, each processed by all three
skills.** Every skill directory contains the same three example names, so any source can be
compared across skills by following its slug:

| Source | watch-video | watch-video-max | video-autopsy |
|---|---|---|---|
| `tech-interview-screen` -- a real 31-minute screening interview (private recording; anonymized, transcript withheld) | content pass | full-depth pass | self-review forensics |
| `founder-interview-podcast` -- a published founder interview, [youtu.be/utb7zYbK10c](https://youtu.be/utb7zYbK10c) | content pass | full-depth pass | third-party forensics |
| `harness-comparison-explainer` -- a published solo explainer, [youtu.be/UsfCe5fJK6A](https://youtu.be/UsfCe5fJK6A) | content pass | full-depth pass | scope-gate REFUSAL (by design) |

Three sanitization rules, stated openly. They run in this order, and the order is the point --
a scrub keyed on IDENTIFIERS cannot contain a leak whose problem is PROVENANCE:

1. **External-record content is stripped by SOURCE, before anything else.** `video-autopsy`'s
   self-review overlay compares the recording against records that are not in the recording: an
   employment-history ground truth, a behavioural profile built over prior rounds, an outcome
   tracker. Those sections are removed whole and replaced by a declared shell. Removing names from
   them would not have been enough -- "the ledger contradicts an earlier round" names nobody and
   still publishes a private record's existence and content.
2. **The interview examples are anonymized.** The screening-interview source is a real recording
   (made and analyzed with all parties' knowledge of recording). Personal names, employers,
   company identifiers, compensation figures and private file references are replaced or
   redacted, and the recording and its transcript are withheld. Every metric, timestamp,
   correction and piece of reasoning is unmodified output.
3. **"Value map" / applicability sections are redacted line by line, not removed whole.** Every
   knowledge document ends by mapping the video against the operator's own projects, tooling and
   working context. That section is a required part of the knowledge-doc contract and is external
   to the recording by construction. In the `tech-interview-screen` pair (`watch-video` and
   `watch-video-max`) it is published as a LINE-BY-LINE redaction: the half of each item that came
   from the recording is kept -- every such fact is already tagged `[STATED]` in the body above it
   -- and the half that describes private systems is redacted in place and marked. A shell
   demonstrates nothing, and the section is worth showing. The two third-party sources still carry
   a whole-section shell, in the markdown and in the HTML report alike; giving them the same
   line-by-line treatment is pending review.

### The re-run pairs, and the gate that refused the first pass

TWO sources ship a re-run pair: a first video-autopsy run, and a second pass over the same recording
under a hardened version of the skill. Each is here for what it corrected, not for what it confirmed.

`tech-interview-screen` ships TWO video-autopsy documents. The first is the original run. The second,
`_rerun_autopsy.md`, is a second pass over the same recording under a hardened version of the skill,
and it is here because of what it corrected rather than what it confirmed:

- The first pass said both ASR engines degraded across a mid-call language switch. Measured, whisper
  did not: it transcribed the switched span in the other language, coherently, at BETTER than the
  file's mean confidence. The engine that failed was the language-locked meeting export.
- The detection rule the skill had just gained -- find the switch by a drop in confidence -- was
  refuted by the recording it was written for. It flagged three minutes of fluent correct English and
  missed both switched minutes. The rule now runs language identification over the output text.
- A phase the first pass marked VOID turned out to be a real measurement.

Both documents were also re-published through `video-autopsy/publish_check.sh`, which **refused the
first pass** on three quasi-identifiers -- an exact start time with a zone, a timestamp to the
second, and an exact duration -- none of which names anybody and all of which let a person who was
in that meeting match the document against their own calendar. They have been coarsened.

`founder-interview-podcast` ships the second pair. Its first run inverted the two participants'
faces -- the defect note in that document is the largest one in this tree -- and the re-run is the
pass that settled the map from the frames and found how the inversion happened. The route was not
the one the skill had already been hardened against:

- The first pass read identity off a personalised surface. The re-run walked into the OTHER route
  to the same wrong answer: caption `>>` markers mark THAT the speaker changed, never TO WHOM, and
  alternating over them from a confidently identified opening turn is only valid if no boundary was
  ever missed. Measured on this file, 68 markers were correct for seven turns and then inverted at a
  hard cut into a pre-recorded sponsor read -- a cut is not a speaker change any caption model can
  see -- and stayed wrong for the rest of the recording.
- That is the lesson the re-run is published for: hardening one route to a wrong map does not harden
  the others. The rule now in `video-autopsy/SKILL.md` Step 3 came out of this run.
- Its caption cross-check also produced a NEGATIVE result worth as much as the positive ones. The
  dropout detector -- caption text with no whisper counterpart -- returned zero flagged bins while
  whisper was in fact emitting a hallucination loop. A detector keyed on ABSENCE cannot see a
  wrong-value failure; what found it was a run of segments of exactly 1.00 s and the compression
  ratio.

The gate refused this pair too, and on a different failure class: not quasi-identifiers but SOURCE.
The run's "Run notes" section is external by construction -- it describes the machine the run
executed on -- so it is a declared shell here, and the transcript of record and the reproduction
scripts are not published for the same reason. That refusal exposed a defect in the document's own
header, flagged in place: it declares "the publication gate does not apply" because the recording is
public, and states that it carries no external-record tags while carrying six of them. The gate
applies to what the RUN leaves behind, not to the subject's privacy. The exact-duration and
calendar-date warnings are NOT coarsened here, unlike the `tech-interview-screen` pair: this
recording is a published video anyone can watch and time, and its sibling document in the same
directory has shipped the same duration since it was published. `publish_check.sh` encodes that
distinction itself -- quasi-identifiers FAIL on `--source private` and only WARN on
`--source published`.

**One mismatch between the shipped examples and the current skill, so it is not read as a defect.**
Every example here except `founder-interview-podcast_rerun_autopsy.*` predates the requirement,
added 2026-08-31, that a report and transcript header name the signal that cross-checked the speaker
attribution and its agreement rate. Under the honesty policy below these documents are not re-run to
conform; a header that does not carry that line is a document written before the rule, not a run
that skipped it.

### Honesty policy: defects are flagged, never rewritten

These are unmodified run outputs. When a document gets something wrong, the error stays and a
**defect note** is added beside it, marked as an editorial addition rather than run output. Nothing
in the original analysis is edited to look better after the fact -- a showcase that quietly repairs
its own mistakes is not evidence of anything.

Six defects are flagged this way. Every one was found by reading the two or three documents of a
single source against each other, or by looking at a rendered page; no identifier grep or automated
check found any of them.

- Two are the same defect seen from opposite sides. `watch-video` and `watch-video-max` disagree
  with each other about who corrected the 60/40 hands-on split in the screening call, and both are
  wrong. `video-autopsy`, run on the same recording, resolved it correctly.
- `watch-video-max` puts a demo segment of the founder interview ~3.5 minutes off; the
  `video-autopsy` run of that source recalibrated and corrected it.
- `watch-video-max` repeats the founder interview's false claim that Lotus Notes is still a
  billion-dollar-a-year IBM business, and uses it as a supporting point; the `watch-video` run of
  the same source caught it and filed it under Corrections. Note the direction of that pair: on
  this source the cheap package caught a factual error the deep one propagated, while the deep one
  caught a screen-read error the cheap one took on trust. Neither package dominates the other.
- The largest one is in `video-autopsy`'s founder-interview report: it swapped the two
  participants' faces, and so attributes the video's paid sponsor read to the guest when the host
  delivered it. Both sibling runs of that source had it right and agree with each other. The note
  sets out the three pieces of evidence that settle it and marks every place the error reaches.
- The same report's phase timeline draws four of the ten blocks its own caption claims, plots one of
  the four at the wrong time, and collides its phase labels. That one only shows up in a render;
  reading the markup does not surface it.

Real pipelines have defects. What the examples are meant to show is that a second evidence pass
catches them -- and that the second pass has to be a reading of the documents against each other and
a look at the rendered page, because not one of these was reachable by a string search.

## watch-video (cheap path, transcript-reuse-first)

- [`tech-interview-screen/`](watch-video/tech-interview-screen/) -- transcript reused from a
  prior deep run (no whisper invocation). Notable: two whisper hallucination loops caught and
  corrected against the meeting client's burned-in live captions, and an English -> Portuguese ->
  English code-switch independently verified from two signals. Carries a **defect note**: the
  document misattributes the 60/40 hands-on correction to the recruiter. Left in and flagged, not
  rewritten -- see the honesty policy above.
- [`founder-interview-podcast/`](watch-video/founder-interview-podcast/) -- notable: frame reads
  captured on-screen artifacts (a memory-file layout, verbatim app text) the audio never
  mentions.
- [`harness-comparison-explainer/`](watch-video/harness-comparison-explainer/) -- notable:
  honest uncertainty handling -- a garbled product name is flagged as unresolvable rather than
  guessed.

## watch-video-max (full-depth study)

- [`tech-interview-screen/`](watch-video-max/tech-interview-screen/) -- verbatim whisper
  transcription (GPU, 7.3x realtime), 9,464 frames at 5 fps, targeted cross-checks of flagged
  transcript spans against the burned-in captions. Compare with the watch-video copy of the same
  source to see what the extra depth buys. Carries the more serious of the two **defect notes**:
  it inverts who corrected the 60/40 hands-on figure and then draws a behavioural conclusion from
  the inversion. Left in and flagged -- see the honesty policy above.
- [`founder-interview-podcast/`](watch-video-max/founder-interview-podcast/) -- honesty note,
  left in deliberately: this document contains a timestamp error (~3.5 minutes off on one demo
  segment) that the `video-autopsy` run of the same source later caught from the frames and
  corrected in its own deliverable rather than propagating. Real pipelines have defects; the
  interesting part is that a sibling skill's evidence pass caught it.
- [`harness-comparison-explainer/`](watch-video-max/harness-comparison-explainer/) -- the
  deliverable type the autopsy's scope-gate refusal routes to for this footage.

## video-autopsy (behavioural / technical forensics)

- [`tech-interview-screen/`](video-autopsy/tech-interview-screen/) -- **the run that got the
  60/40 correction right**, where both sibling runs of the same recording got it wrong in opposite
  directions. The self-review overlay on
  the operator's own interview: talk-share and monologue-block measurement, per-phase pacing, a
  claims-consistency pass with timestamps, an outcome estimate argued purely from in-call
  evidence, and a screen-forensics anomaly (a 12-second capture bleed-through). Anonymized per
  rules 1 and 2: the sections that cross-reference the operator's private
  records (claims ledger, profile check, outcome calibration) are redacted to declared shells,
  because those are external to the recording and no amount of name-scrubbing makes them
  publishable. The HTML report was regenerated from the redacted analysis, so the two files carry
  the same redactions rather than one leaking what the other withheld.
- [`founder-interview-podcast/`](video-autopsy/founder-interview-podcast/) -- third-party mode:
  edit-pattern detection (a sponsor segment spliced into an apparently organic answer --
  invisible in the transcript, visible in frames), an honest "talk-share unmeasurable, here is
  the defensible proxy" call, and evidence contact sheets. Carries the largest **defect note** in
  the tree: the run swapped the two participants' faces and so credits the sponsor read to the
  wrong man. Left in and flagged, with the evidence that settles it -- see the honesty policy
  above. It also carries a second note on its phase timeline, which draws four of the ten blocks
  its own caption claims. It ships a **re-run pair**: `_rerun_autopsy.md/html` is the
  second pass that settled the face map from the frames, found the route the inversion took, and
  produced the turn-boundary rule now in the skill -- see the re-run section above.
- [`harness-comparison-explainer/`](video-autopsy/harness-comparison-explainer/) -- what the
  skill does when pointed at footage it is not for: it stops before spending compute and routes
  to the right sibling. No autopsy deliverable exists for this source *because the run refused to
  produce a degenerate one* -- [`REFUSAL.md`](video-autopsy/harness-comparison-explainer/REFUSAL.md)
  is the record of that verdict. The refusal is a feature; read this one first.
