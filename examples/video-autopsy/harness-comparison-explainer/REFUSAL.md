# video-autopsy run record: scope-gate refusal (real output)

This is what a video-autopsy run returns when pointed at footage the skill is deliberately not
for. It is included as an example because the refusal is a feature: the alternative is a
statistics sheet about a narrator, every number technically computed and none of it meaning
anything.

## Input

An 18m02s YouTube video: a single presenter, talking-head segments intercut with edited
screen-capture B-roll, walking through a concept-by-concept comparison of two coding-agent
harnesses ("Concept 1... Concept 2..."). The same video used for the `watch-video` example in
`examples/watch-video/harness-comparison-explainer/` (content) and `examples/watch-video-max/harness-comparison-explainer/` (full depth).

## What the run did

Step 0, MODE 1, asks one question before any compute is spent: is the subject of this recording
THE EXCHANGE (a meeting, interview, panel, pair-programming session -- people interacting), or
THE MATERIAL (one presenter teaching)? The run sampled ten frames across the timeline, confirmed
the format (solo presenter, no other participants, heavy post-production cutaways -- one sampled
frame even contained a screen-share from an unrelated earlier video, confirming cut-together
review footage), and classified it as THE MATERIAL with high confidence.

Per the skill's gate:

> **The material** (one presenter teaching, a tutorial, a talk, a lecture, an edited screencast):
> **STOP and say so.** This is `watch-video-max`. Every behavioural metric here is degenerate by
> construction on that footage -- talk-share carried no information and "silence" measured the
> editor's cuts rather than the speaker. Route the user there rather than producing a statistics
> sheet about a narrator.

## What the run did NOT do

- No frame-extraction pass, no metric passes, no autopsy.md / autopsy.html.
- No talk-share, disfluency, silence-per-phase, or prosody numbers: on an edited solo screencast,
  talk share is 100% by construction, "silence" measures the editor, and pacing measures the cut.
- The ten probe frames used to classify the footage were deleted and the deletion verified;
  no run directory was ever opened.

## Why this is the right behavior

The behavioural metrics this skill exists for answer questions about an *exchange*: who talked,
what landed, how it was received, what the screen showed while the words claimed something else.
A published solo explainer has no exchange in it. The content question ("what does this video
teach?") is a different question, and the family has two other packages for it -- the content
deliverables for this exact video live in `examples/watch-video/harness-comparison-explainer/` (content) and `examples/watch-video-max/harness-comparison-explainer/` (full depth).

Contrast with `examples/video-autopsy/founder-interview-podcast/`: same decision gate, opposite
verdict -- a two-person interview with genuine turn-taking passes MODE 1 and gets the full
forensics treatment.
