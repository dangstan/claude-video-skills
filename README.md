# claude-video-skills

Three production-grade [Claude Code agent skills](https://docs.claude.com/en/docs/claude-code/skills)
for extracting knowledge from video. Each skill is a self-contained package -- workflow definition,
preflight dependency gate, layered configuration, and a cleanup contract -- that drops into
`~/.claude/skills/` and turns "here is a recording" into structured, provenance-tagged deliverables.

They form a ladder, from cheapest to deepest:

| Skill | Question it answers | Headline behavior |
|---|---|---|
| [`watch-video`](watch-video/) | "What does this video teach me?" | **Transcript-reuse-first.** Resolves a transcript through a four-tier ladder (supplied file, sidecar, platform captions, whisper last) so transcription is the exception, not the default. Guided read of the transcript with frame checks wherever words alone do not carry the meaning. |
| [`watch-video-max`](watch-video-max/) | Same question, at full depth | **Always verbatim.** High frame rate, faster-whisper transcription every time, and reconstruction of what was actually *on screen* (code, diagrams, dashboards) rather than a summary of what was said about it. |
| [`video-autopsy`](video-autopsy/) | "How did the *people* in this recording perform?" | **Behavioural and technical forensics.** Talk-share and turn-taking, continuous-monologue blocks, disfluency counts, silence and pace per phase, micro-expression bursts at key moments, and screen-share/live-coding forensics read from pixels. An opt-in self-review overlay adds outcome estimation with quoted, timestamped evidence. |

Every deliverable is written twice: an agent-ingestible markdown knowledge document with
per-claim provenance tags (`[ON-SCREEN]` / `[STATED]` / `[WEAK]` / `[INFERRED]`), and a
human-facing dark-themed HTML report. A fresh assistant can be handed the markdown file as
context and come away knowing the content without ever seeing the video.

## Design principles

These packages share an engineering contract, and it is the part worth reading even if you never
run them:

- **Preflight gates, not runtime surprises.** Each skill ships a `preflight.sh` that resolves
  every tool and path, prints the full configuration table with the *source* of each value, and
  fails loud with the exact remedy command before any work starts. A `WARN` never blocks; a
  `FAIL` always names its fix.
- **Four-layer configuration, first hit wins.** Environment variable, then JSON config key, then
  machine auto-detection, then a documented default. A freshly cloned copy with zero
  configuration still runs. All three skills share one config file and key namespace; each reads
  only the keys it owns.
- **No auto-install, deliberately.** A missing python package produces a printed `pip install`
  command targeting the interpreter that was actually resolved -- never a silent mutation of an
  environment that may not be the skill's to change.
- **Provenance on every claim.** Anything the deliverables assert is tagged with how it is known.
  A number read off a slide is `[ON-SCREEN]`; a speaker's assertion is `[STATED]`; an inference
  is labeled as one. Garbled caption spans get checked against the frames before being repeated.
- **Cleanup is part of the workflow, not an afterthought.** Each skill ships a `cleanup.sh` and
  its SKILL.md ends with a mandatory teardown phase: everything extracted or downloaded is
  removed, and only the declared deliverables survive.
- **Scope discipline.** Each package states what it does *not* do and points to the sibling that
  does. `watch-video` refuses to improvise forensics; `video-autopsy` will not summarize a
  tutorial. The boundaries are enforced in the preflight scripts, not just described in prose.

## Examples -- being regenerated

[`examples/`](examples/) is currently EMPTY, deliberately. The documents that were there were real
run outputs, but not all of them were one clean run of one skill on one video: two were second
passes written knowing what an earlier pass had said, and others had accumulated post-hoc edits
(publication scrubs, coarsened identifiers, editorial defect notes) until a reader could not
reconstruct their provenance. An example whose provenance is unclear demonstrates nothing.

They are being replaced by a fresh run of all three skills against the same three sources -- a
private screening interview, a published founder interview, a published solo explainer -- each run
with no knowledge of any earlier run of that source, and published as produced apart from the
sanitization the private recording requires. `video-autopsy` against the explainer is expected to
refuse on its scope gate, and that refusal ships too: a skill that knows what it is *not* for is
half the engineering. See [examples/README.md](examples/README.md).

Until then the skills are their own documentation: each package's `SKILL.md` states what it
produces and `preflight.sh` states what it refuses.

## Install

Clone into your Claude Code skills directory:

```bash
git clone <this-repo> /tmp/claude-video-skills
cp -r /tmp/claude-video-skills/watch-video     ~/.claude/skills/
cp -r /tmp/claude-video-skills/watch-video-max ~/.claude/skills/
cp -r /tmp/claude-video-skills/video-autopsy   ~/.claude/skills/
```

Then, per skill, run its preflight and follow the printed remedies:

```bash
bash ~/.claude/skills/watch-video/preflight.sh
```

Hard requirements are minimal (`ffmpeg`/`ffprobe` everywhere; `faster-whisper` only where a run
actually needs transcription; `yt-dlp` plus a JS runtime only for URL input). Each skill's own
README carries the full requirements matrix, configuration reference, and troubleshooting guide.

## Usage

Inside a Claude Code session:

```
/watch-video https://www.youtube.com/watch?v=...      # learn from a talk or tutorial
/watch-video-max /path/to/conference-recording.mp4    # full-depth study of one video
/video-autopsy /path/to/meeting-recording.mkv         # forensics on a working session
```

or just say "watch this video", "go deep on this video", or "run forensics on this recording"
with a path or URL -- the trigger phrases are part of each skill's definition.

## Repository layout

```
watch-video/       SKILL.md, README.md, preflight.sh, cleanup.sh, lib/config.sh, config.example.json
watch-video-max/   same layout
video-autopsy/     same layout + publish_check.sh + references/ (evaluation methodology, known pitfalls)
```

`SKILL.md` is the machine-facing workflow the agent follows; `README.md` is the human-facing
operations manual. The `video-autopsy/references/` directory holds the evaluation methodology
and a catalog of measurement pitfalls learned from real runs (timestamp drift between capture
tools, mono-collapsed audio, caption/OCR attribution, and the difference between "no assist log
exists" and "no assist tool ran").

## License

MIT -- see [LICENSE](LICENSE).
