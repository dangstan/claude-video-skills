# Examples

Real run output. Each directory below is **one clean run of one skill on one video**, produced by a
process that had no knowledge of any earlier run of that source. Nothing here is a mock-up, and
nothing here has been improved after the fact: defects, deviations and refusals are annotated where
they occur rather than repaired, because provenance is the only thing an example has.

**This tree is being rebuilt and is incomplete.** Two of the nine planned runs have landed. The rest
are queued and will be added as they finish; this file is rewritten from the actual outputs each
time, never from a description of what they were expected to contain.

## The plan: three skills against three sources

| Source | what it is | `watch-video` | `watch-video-max` | `video-autopsy` |
|---|---|---|---|---|
| `harness-comparison-explainer` | a published solo explainer, [youtu.be/UsfCe5fJK6A](https://youtu.be/UsfCe5fJK6A) | **shipped** | pending | pending -- scope-gate refusal expected |
| `tech-interview-screen` | a real screening interview, about 31 minutes; private recording, anonymized, transcript withheld | **shipped** | pending | pending |
| `founder-interview-podcast` | a published founder interview, [youtu.be/utb7zYbK10c](https://youtu.be/utb7zYbK10c) | pending | pending | pending |

`video-autopsy` against the explainer is expected to refuse on its MODE 1 scope gate rather than
produce a deliverable. That refusal is a result, and it will ship as one.

## What has landed

### [`watch-video/harness-comparison-explainer/`](watch-video/harness-comparison-explainer/)

An 18-minute single-presenter explainer comparing two agent harnesses. The run resolved its
transcript at **tier C** -- platform captions, 4,556 words at 253 wpm after rolling-window
deduplication -- so whisper was never loaded, which is the entire point of this package's transcript
ladder. It read 1,082 base frames at 1 fps and escalated to 22 image reads, 4 dense contact sheets,
and 14 crop-and-upscale reads for small on-screen text.

Two findings in it are worth naming because neither is in the narration: the video's headline speed
claim is confounded -- both sides ran the same model, but reasoning effort read **High** in one
composer and **Default** in the other, visible in both screenshots -- and a `TOOL_TIMEOUT` appears on
the first call of the run being held up as the fast one, visible in the trajectory view and
unmentioned.

**One deviation, recorded rather than hidden.** The skill instructs the run to write the full
verbatim transcript to disk. This run declined to reproduce the video's spoken content wholesale and
wrote a provenance-and-citation record instead: tier attribution, the deduplication audit, a full
map of the caption corruption, a timestamped segment index with per-beat on-screen readings, and the
fragments the analyses actually cite. Every citation in the other two documents remains checkable
against it. The file therefore carries the `_transcript.txt` name without being a verbatim
transcript, and that mismatch is left in place rather than papered over.

### [`watch-video/tech-interview-screen/`](watch-video/tech-interview-screen/)

A real screening call, recorded with all parties' knowledge of recording. No transcript existed for
it -- no supplied file, no sidecar, and platform captions do not exist for a local recording -- so
the ladder fell to **tier D** and transcribed with faster-whisper large-v3.

The run's own most useful finding is a transcription hazard: pinning whisper to `language="en"` over
a recording that switches language does not fail loudly, it silently *translates* the non-English
spans, returning fluent English prose that reads exactly like a transcript and is not one. The
recording switches language twice, and the document records how the resulting transcript was rebuilt
in three language-pinned passes.

Only the knowledge document and the HTML report are published here. **The recording and its
transcript are withheld.**

## Sanitization, stated openly

Only `tech-interview-screen` needs the identity scrub; the published sources ship as produced --
with one exception that applies to every document here. Each knowledge document ends with a value
map against the operator's own private projects and tooling, which is external to the video by
construction, so that section is redacted in EVERY example regardless of whether its source was
public. Three rules,
applied in this order, and the order is the point -- a scrub keyed on IDENTIFIERS cannot contain a
leak whose problem is PROVENANCE:

1. **External-record content is stripped by SOURCE, before anything else.** Passages that draw on
   records not in the recording -- an employment history, a prior-rounds profile, an outcome tracker
   -- are removed whole and replaced by a declared shell. Removing names from such a passage is not
   enough: a sentence like "the ledger contradicts an earlier round" names nobody and still
   publishes a private record's existence and content.
2. **Identities are anonymized.** Personal names, employers, company identifiers, compensation
   figures and private file references are replaced or redacted, along with company
   quasi-identifiers -- headcount, founding year, country split, team size -- which together
   re-identify a company as surely as its name. Compensation figures are redacted, not generalized.
   Every metric, timestamp, correction and provenance tag is unmodified run output.
3. **The "value map" section is redacted line by line, not removed whole.** That section maps the
   video against private projects and tooling by construction. The half of each item that came from
   the recording is kept; the half describing private systems is redacted in place and marked. A
   shell demonstrates nothing, and the section is worth showing.

Both shipped directories pass `video-autopsy/publish_check.sh` with 0 FAIL, run from the canonical
tree rather than an installed copy, plus a supplementary sweep for credential shapes and third-party
personal data -- a category that gate does not cover and that matters for skills whose job is
reading text off a shared screen. Both HTML reports were rendered headless and read from the
screenshot, because a defect gated behind an entry animation is invisible in the markup.

One judgement call is disclosed rather than buried: in the screening-call report, the stated word
count and words-per-minute recover the recording's exact duration to within a second. With the
company, the participants, the date and the filename all removed, a bare duration identifies
nothing on its own, so the metrics were left unmodified per rule 2.
