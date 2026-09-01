# Examples

Real run output. Each directory below is **one clean run of one skill on one video**, produced by a
process that had no knowledge of any earlier run of that source. Nothing here is a mock-up, and
nothing here has been improved after the fact: defects, deviations and refusals are annotated where
they occur rather than repaired, because provenance is the only thing an example has.

**The tree is complete: three skills against three sources, nine runs, all nine shipped.** An
earlier version of this tree was deleted rather than patched, because two of its documents had been
written as second passes against a known first pass and the rest had accumulated enough post-hoc
edits that the provenance of a given line was no longer reconstructable. Every document below comes
from a run that was told only the skill, the slug and the source, and was never told that any
earlier run existed. This file was written last, from the nine actual outputs, and every number in
it was measured from the files in this tree rather than recalled.

## Three skills against three sources

| Source | what it is | [`watch-video`](watch-video/) | [`watch-video-max`](watch-video-max/) | [`video-autopsy`](video-autopsy/) |
|---|---|---|---|---|
| `harness-comparison-explainer` | published solo explainer, 18:02, [youtu.be/UsfCe5fJK6A](https://youtu.be/UsfCe5fJK6A) | tier-C captions, whisper never loaded | verbatim + caption cross-check | **REFUSED at the scope gate** |
| `founder-interview-podcast` | published two-person interview, 45:25, [youtu.be/utb7zYbK10c](https://youtu.be/utb7zYbK10c) | tier-C captions, 12 concepts | verbatim, 11 concepts | full forensic autopsy, third-party mode |
| `tech-interview-screen` | a real screening call, private, anonymized, transcript withheld | tier-D whisper, the ladder exhausted | verbatim, three language-pinned passes | full autopsy, self-review overlay open |

The refusal is a result and it ships as one. A package that only ever shows its successes is not
showing you how it decides.

## `watch-video` -- the cheap path

The headline of this package is the **transcript ladder**: a transcript you supply (tier A), a
sidecar beside the video (B), platform captions (C), and whisper only as a last resort (D). Frames
are read at 1 fps. There is no audio, prosody or behavioural analysis anywhere in it.

### [`watch-video/harness-comparison-explainer/`](watch-video/harness-comparison-explainer/)

The ladder resolved at **tier C** -- YouTube auto-captions, 1,237 raw cues collapsed by
word-level rolling-window overlap into 619 segments and 4,556 words at 252.7 wpm -- so whisper was
never loaded and no audio was ever extracted. That is the whole point of the package. The
deduplication is audited in the transcript file rather than asserted: the 252.7 wpm rate sits above
the 250 wpm line the package uses as evidence of a failed collapse, so the run escalated to a
structural test (zero adjacent duplicated 6-grams, zero repeated 8-grams across all 4,556 words)
and accepted the transcript on that instead of on the rate.

Two findings are worth naming because neither is in the narration: the video's headline speed claim
is confounded -- both sides ran the same model, but reasoning effort read **High** in one composer
and **Default** in the other, visible in both screenshots -- and a `TOOL_TIMEOUT` appears on the
first call of the run being held up as the fast one, visible in the trajectory view and unmentioned.

**One deviation, recorded rather than hidden.** The skill instructs the run to write the full
verbatim transcript to disk. This run declined to reproduce the video's spoken content wholesale and
wrote a provenance-and-citation record instead: tier attribution, the deduplication audit, a full
map of the caption corruption, a timestamped segment index with per-beat on-screen readings, and the
fragments the analyses actually cite. Every citation in the other two documents remains checkable
against it. The file therefore carries the `_transcript.txt` name without being a verbatim
transcript, and that mismatch is left in place rather than papered over.

### [`watch-video/founder-interview-podcast/`](watch-video/founder-interview-podcast/)

Tier C again, 238.8 wpm over 45:25, and the run's own warning is the useful part: auto-captions
mangle exactly the tokens a reader would want to quote. Its Corrections section repairs them against
pixels rather than guessing -- "deep API" and "deepi.co" are DeepAPI and deepapi.co, "lindtitimate"
is "Lindy teammate" -- and the two it could not settle are listed as unsettled. The knowledge
document is organised as twelve concepts and closes with a Boundaries section naming what the source
does not establish.

**One defect is annotated in place, and one post-run edit is declared.** The knowledge document
sends the reader to a screen-versus-narration contradiction "documented above"; there is no such
passage above, and the sibling report shows **two** such contradictions rather than one. The pointer
is left standing with the correct facts named beside it, because a false cross-surface pointer is a
real failure mode of a pipeline that writes a document and its report in one pass and never resolves
a reference from one into the other. Separately, two clauses in the report described the sponsored
API as the host's own product, which the recording does not establish; because ownership is a
materially heavier claim about a named, identifiable person than sponsorship is, those clauses were
removed and the removal is declared at the site. That is the only place in this tree where a defect
was repaired instead of annotated.

### [`watch-video/tech-interview-screen/`](watch-video/tech-interview-screen/)

A real screening call, recorded with all parties' knowledge of recording. No transcript existed for
it -- no supplied file, no sidecar, and platform captions do not exist for a local recording -- so
the ladder fell to **tier D** and transcribed with faster-whisper large-v3.

The run's most useful finding is a transcription hazard: pinning whisper to `language="en"` over a
recording that switches language does not fail loudly, it silently *translates* the non-English
spans, returning fluent English prose that reads exactly like a transcript and is not one. Language
detection at fifteen-second resolution found the two switch points, and three language-pinned passes
produced the transcript the report is built on.

Only the knowledge document and the HTML report are published here. **The recording and its
transcript are withheld.**

## `watch-video-max` -- deep study of one video

Always verbatim, 5 fps, and reconstruction of what was on screen rather than a summary of what was
said about it. Since the caption *tier* was removed from this package, the caption *fetch* was kept
as a deliberate second reading of the audio: a **caption cross-check** placed far downstream of the
transcript step, whose job is to turn engine disagreements into frame triggers.

### [`watch-video-max/harness-comparison-explainer/`](watch-video-max/harness-comparison-explainer/)

Verbatim whisper large-v3: 258 segments, 100% duration coverage, zero timestamp gaps over 3 s. The
cross-check is the part to read. Against the same source's auto-captions it measured **4,555 caption
words against 4,596 verbatim words -- 99.1% volume, zero dropout spans** -- and then raised eight
fact-bearing disagreements anyway, resolving seven from frames and keeping one on the whisper
reading marked unverified. Low volume loss does not mean the captions are safe to quote, and this
run is the demonstration. Ingest: 5,408 frames at 5 fps, 8 contact sheets, 11 cropped and
LANCZOS-upscaled artifact reads. The highest-value artifact it recovered -- a four-mode agent
breakdown and a seven-row verdict scorecard -- is read off the screen, not off the narration.

### [`watch-video-max/founder-interview-podcast/`](watch-video-max/founder-interview-podcast/)

Verbatim, 99.99% coverage of a 2,725.09 s source, zero gaps above 5 s, no degenerate repetition;
13,625 frames at 5 fps. The cross-check raised 24 caption-only and 35 whisper-only fact-bearing
tokens with zero dropouts, kept 14 disagreements as fact-changing, and settled 3 directly from
pixels and 11 from in-transcript co-occurrence. The document carries a `Narration versus screen`
section for the cases where the two disagreed and the screen won.

### [`watch-video-max/tech-interview-screen/`](watch-video-max/tech-interview-screen/)

The most instructive of the three, because both instruments fail and the document says where. The
recording is bilingual, so the transcript was cut at measured silence gaps into three
language-pinned regions, and two repetition-loop spans plus one garbled-proper-noun span were
re-decoded and spliced back at true offsets.

The cross-check was available **by an unusual route**: there is no platform caption track for a
local file, but Google Meet's live captions are burned into the pixels, which makes them a genuine
second ASR engine reading the same audio. Fourteen fact-changing terms were compared -- 9 agreed, 5
disagreed, 4 of the 5 were settled, 3 from pixels elsewhere in the frame and 1 by re-decoding. And
then the limit is stated plainly rather than buried: the Meet engine was pinned to English for the
whole call, so across the two Portuguese regions -- about a quarter of the recording -- it emitted
unrelated English text and provided **no cross-check at all**, and every compensation, contract and
hiring-process fact in the document sits inside that uncovered stretch on a single engine.

**Transcript withheld.**

## `video-autopsy` -- behavioural and technical forensics

The family's only home for talk-share, turn-taking, silence and pace, prosody, micro-expression
bursts and screen forensics. It decides two things before it spends anything: MODE 1, whether the
subject is an exchange or the material, and MODE 2, whether the operator is a participant. It also
records source provenance -- private or published -- because a publication gate keyed on the
self-review overlay would leave a third-party autopsy of a private recording ungated, which is the
commonest professional case.

### [`video-autopsy/harness-comparison-explainer/`](video-autopsy/harness-comparison-explainer/) -- a refusal

`REFUSAL.md` is the entire deliverable, and it is the run's result. The gate was settled from the
recording rather than from the title: 34 samples spanning the whole 1,082 s, first a 9-frame sheet
at 120 s spacing and then a 25-frame sheet at 43 s spacing, every one of them showing one presenter
with no second participant, no second voice and no turn anywhere in the file.

The reasoning for stopping is the part worth reading. Every behavioural metric in the package is
degenerate by construction on that footage: talk-share of one speaker carries no information,
"silence" would measure the editor's cuts rather than the presenter, and monologue-block detection
would report the whole runtime as one block. The run routed to `watch-video-max` instead of
improvising a content pass, and wrote no `_autopsy.md`, no `_autopsy.html` and no `_transcript.txt`,
because writing them is the exact output the gate exists to prevent.

### [`video-autopsy/founder-interview-podcast/`](video-autopsy/founder-interview-podcast/)

MODE 1 the exchange, MODE 2 **third-party** -- so the self-review overlay does not open and there is
no outcome estimate, behavioural profile, claims ledger or assist-dependence section anywhere in it.
Measured window: the whole 2,725.1 s at 100% coverage, with 14 unresolvable whisper segments (1.0 s,
0.04% of speech) reported as UNRESOLVED rather than dropped.

Its strongest result is an attribution problem solved rather than assumed. Layout classification
over all 13,625 frames found the dominant shot is a persistent side-by-side composite -- **SPLIT
79.6%, FULL 14.1%, SHARE 6.3%** -- so "who is on camera" carries no attribution information for four
fifths of the file and attribution had to be built from the audio. The face-to-name map is then
bound from **two disjoint sources** (the editor's speaker inset over B-roll, and mouth-region pixel
delta per voice cluster) and re-verified at six points across the recording. This matters
concretely: it settles which of the two men delivers the episode's paid sponsor read.

**One defect is annotated rather than repaired.** Two sentences call the sponsored product "the
host's own product". The recording does not establish that and its own evidence points the other
way, so a note at each site it reaches names the correct fact -- the segment is a sponsor read the
host delivers, and the ownership question is not settled by the recording -- rather than merely
admitting an error. The measured content of that section is unaffected and stands.

### [`video-autopsy/tech-interview-screen/`](video-autopsy/tech-interview-screen/)

MODE 1 the exchange, MODE 2 **self-review**: the recording is a round the operator sat, so the
overlay opens and the document is a published copy of a private, self-review autopsy.

The instrument design is the finding. Primary attribution comes from a speaker-separated caption
export, which is exact where it is legible and useless where it is not. The **independent** check is
Google Meet's own active-speaker tile border, read from pixels as blue-channel excess over a
four-pixel strip at the top of each tile -- unrelated to the export, one being caption-derived text
and the other a rendered interface element. Across the English window the two agree on **1,361 of
1,488 decided seconds (91.5%)** and their aggregate talk-shares differ by **0.2 percentage points**.
The border is lit on both tiles in zero frames of the recording, which is the structural check that
the probe reads one indicator rather than two brightness artifacts. Two measured windows are
declared before any number: export-derived metrics cover about 80% of the recording, frame-derived
attribution about 100%.

Its pixel-level finding is eighteen seconds in which the capture stops showing the call and shows a
professional network instead, exactly while the interviewer is naming the stages that remain in the
hiring process -- a span in which no gap appears in the candidate's speech because he had the floor
for none of it.

Four sections built entirely from records outside the footage -- a behavioural comparison against
prior rounds, a claims-ledger consistency pass, an assist-dependence measurement, and the run's
notes about its own host -- were removed whole and replaced by declared shells. **Transcript
withheld.**

## What the three skills actually produce on the same video

Measured from the files in this tree, on `harness-comparison-explainer` (18:02):

| | `watch-video` | `watch-video-max` |
|---|---|---|
| transcript source | platform captions, tier C | verbatim whisper large-v3 |
| transcript volume | 4,556 words | 4,596 words |
| transcript segments | 619 (dedup-collapsed cues) | 258 (whisper segments) |
| frames extracted | 1,082 at 1 fps | 5,408 at 5 fps |
| knowledge document | 5,275 words | 4,972 words |
| fenced code blocks | 1 | 9 |
| inline code spans | 67 | 88 |

Two things fall out of that, and the second is the one people get wrong. **Volume is not the
difference** -- 4,556 against 4,596 words is 0.9%, and the earlier finding that captions run
materially short does not reproduce on this source. **Granularity is** -- the same speech arrives in
619 caption cues or 258 whisper segments, and the deep package's document is *thinner in prose and
denser in artifacts*: fewer words carrying nine times the fenced code and a third more inline
identifiers, because 5 fps resolves on-screen text that 1 fps does not. Do not read that as the deep
package seeing more: the cheap one caught every proper noun its captions mangled, by reading frames,
and committed to conceptual framings the deep one declined to commit to. The delta shows up as
artifact granularity, not as comprehension.

## Sanitization, stated openly

Only `tech-interview-screen` needs the identity scrub; the published sources ship as produced --
with one exception that applies to every document here. Each knowledge document ends with a value
map against the operator's own private projects and tooling, which is external to the video by
construction, so that section is redacted in EVERY example regardless of whether its source was
public. Three rules, applied in this order, and the order is the point -- a scrub keyed on
IDENTIFIERS cannot contain a leak whose problem is PROVENANCE:

1. **External-record content is stripped by SOURCE, before anything else.** Passages that draw on
   records not in the recording -- an employment history, a prior-rounds profile, an outcome
   tracker, the analysis host's own filesystem and process state -- are removed whole and replaced
   by a declared shell. Removing names from such a passage is not enough: a sentence like "the
   ledger contradicts an earlier round" names nobody and still publishes a private record's
   existence and content. This applies on a PUBLISHED source too, which is why the third-party
   autopsy's `## Run notes` is a shell.
2. **Identities are anonymized.** Personal names, employers, company identifiers, compensation
   figures and private file references are replaced or redacted, along with company
   quasi-identifiers -- headcount, founding year, country split, team size -- which together
   re-identify a company as surely as its name. Compensation figures are redacted, not generalized.
   Every metric, timestamp, correction and provenance tag is otherwise unmodified run output.
3. **The "value map" section is redacted line by line, not removed whole.** That section maps the
   video against private projects and tooling by construction. The half of each item that came from
   the recording is kept; the half describing private systems is redacted in place and marked. A
   shell demonstrates nothing, and the section is worth showing.

A redaction is a property of the whole tree, not of one directory. The four private projects behind
the `[REDACTED: ...]` markers are redacted identically in all nine directories; a term left in plain
text in one document while its sibling redacts it does not protect anything, and no per-directory
check can see that -- it is a property of the set.

## Honesty policy

Six things in this tree are wrong, incomplete or edited, and each is disclosed at the place it
occurs as well as here.

1. **The sponsored product's ownership, in `video-autopsy/founder-interview-podcast/`.** The
   document calls it "the host's own product"; the recording does not establish that. ANNOTATED at
   each site in both surfaces, with the correct fact named. Found by cross-reading the three
   documents of that source against each other -- the two siblings read the same segment as a paid
   placement.
2. **The same claim in `watch-video/founder-interview-podcast/`'s report.** REPAIRED rather than
   annotated: two clauses removed, with the removal and the reasoning declared at the site. The only
   repair in the tree, and it is inconsistent with rule 1 above on purpose -- both treatments are
   shown so the difference is visible.
3. **A false cross-surface pointer in `watch-video/founder-interview-podcast/`'s knowledge
   document.** It sends the reader "above" for a contradiction that is documented only in the
   report, and gives the count as one where the report shows two. ANNOTATED. Found by reading, not
   by any gate: nothing in the pipeline resolves a pointer from one surface into the other.
4. **`watch-video/harness-comparison-explainer/`'s `_transcript.txt` is not a verbatim transcript.**
   It is a provenance-and-citation record, written in place of one. Declared above; the file is left
   as the run produced it.
5. **The private recording's exact duration is published, knowingly.** The coarsening to "about 30
   minutes" was attempted and is not achieved. The autopsy's phase decomposition names a boundary in
   the thirty-second minute, and the cheap package's report states a word count and a
   words-per-minute rate whose quotient is the same quantity. Neither can be removed without
   recomputing the findings that rest on them, which is not a permitted edit here. What WAS removed,
   at no cost to any finding and declared at each site, is the casual arithmetic: the extracted
   frame counts, which divided by the stated frame rate gave the duration directly. One document of
   that source says "about 31 minutes" where the other two say "about 30"; the inconsistency is left
   visible rather than harmonised, because harmonising it would suggest a coarsening that this tree
   does not achieve.
6. **`video-autopsy/harness-comparison-explainer/` produced no deliverable.** That is the refusal,
   and it is item six on this list rather than an omission from the tree.

## How this tree was checked before it was published

- `video-autopsy/publish_check.sh` on every directory, run **from the canonical repository tree**
  rather than an installed copy, with the private terms passed explicitly -- the private-term leg is
  inert without them and prints `private-terms=0` while looking like it ran. Every directory reads
  0 FAIL at its own source class, and so does the whole tree scanned as one set.
- A supplementary sweep for credential shapes and third-party personal data, a category that gate
  does not cover and that matters for skills whose job is reading text off a shared screen. One
  warning stands and is accepted: a presenter's own email address, on his own dashboard, in his own
  published video -- which is also part of the evidence settling that video's sponsor attribution.
- A read of every shipped file by a reader that did not write it, cross-reading the two or three
  documents of the SAME source against each other. Every defect in the honesty policy above was
  found this way. No gate found any of them.
- Every HTML report rendered headless and read **from the screenshot**, twice per report: once with
  reduced motion, which is the review pass, and once with stock motion as the control. Content
  present in one and absent in the other is animation timing; absent in both is a real defect. This
  is not optional -- a signature element whose content depends on an entry animation photographs
  empty on a screenshot taken at load, and reading the markup cannot tell you either way.
