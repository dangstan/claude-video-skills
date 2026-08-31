---
name: watch-video
description: Watch a video (local file or URL) and learn from it -- produces a knowledge document plus a human-facing HTML report. Triggers on "/watch-video <path-or-url>", "watch this video", "learn from this video", or being handed a tutorial, talk, or conference-recording URL. HEADLINE BEHAVIOR -- reuses an existing transcript whenever one is available (a transcript you supply, a sidecar file next to the video, or platform captions fetched with the video) and treats whisper transcription as the LAST RESORT, used only when none of those exist. Does NO audio, prosody, or behavioral analysis of any kind -- no tonality, no diarization, no talk-time, no micro-expressions. For multi-party recording forensics or any audio/behavioral analysis, use the heavier sibling skill "watch-video-max" instead.
---

# watch-video

Point this at a video and come away KNOWING what it teaches. The deliverable is a knowledge
document an agent can be handed as context (so it comes away knowing the content, not knowing
that a video exists) plus a human-facing HTML report. This skill does not analyze how anything
SOUNDED -- no pace, pitch, energy, emotion, or speaker-behavior work of any kind, and no
multi-party recording forensics. If you need any of that, stop here and use the sibling skill
**watch-video-max** instead.

The other thing this skill does differently from a naive "download and transcribe" pipeline:
**it does not transcribe if it does not have to.** A transcript that already exists -- one you
hand it, one sitting next to the video file, or the platform's own captions -- is reused. Whisper
transcription only runs as the last resort, and every deliverable states plainly which tier
produced its transcript.

## Configuration (read once, applies everywhere below)

Every `${WV_*}` placeholder in this file resolves in this fixed order:

1. **Environment variable** of the same name (e.g. `$WV_PYTHON`).
2. **Config file** for this skill (key of the same name, lower-cased, e.g. `wv_python` ->
   `python`).
3. **Auto-detection** on the host, where a sane one exists (e.g. `which ffmpeg`).
4. **Documented default** below.

This is the SAME resolution order, SAME config-file locations, and SAME `WV_` environment prefix
used by the sibling package `watch-video-max` -- a single config file works for both. This
package just never reads that sibling's forensics-only keys (`recordings_dir`, `transcript_dir`,
`forensics_fps`, `forensics_delete_source`); if they happen to be present in a shared config file,
they are silently ignored.

| Placeholder | Meaning | Auto-detect | Default |
|---|---|---|---|
| `WV_PYTHON` | Interpreter used for transcript parsing and (last resort) `faster_whisper`/`ctranslate2` | `which python3` | `python3` |
| `WV_FFMPEG` | ffmpeg binary | `which ffmpeg` | `ffmpeg` |
| `WV_FFPROBE` | ffprobe binary | `which ffprobe` | `ffprobe` |
| `WV_YTDLP` | yt-dlp executable (zipapp or installed package) | `which yt-dlp` | `yt-dlp` |
| `WV_JS_RUNTIME` | JS runtime yt-dlp needs for extraction (e.g. deno, node) | `which deno` then `which node` | empty -- the flag is omitted entirely (passing a runtime that is not installed breaks extraction) |
| `WV_WORK_DIR` | Scratch directory for all intermediate files | -- | `${TMPDIR:-/tmp}/watch-video` |
| `WV_OUTPUT_DIR` | Where this skill writes its deliverables | -- | `$HOME/watch-video/reports` (anchored to $HOME on purpose: output must not depend on the directory you invoked from) |
| `WV_WHISPER_MODEL` | The verbatim-tier whisper model name (Tier D escalation only) | -- | `large-v3` |
| `WV_WHISPER_DEVICE` | `cuda` or `cpu` (Tier D only) | probe for a CUDA device | `cuda` if a compatible GPU is free, else `cpu` |
| `WV_WHISPER_COMPUTE` | ctranslate2 compute type (Tier D only) | -- | `float16` on `cuda`, `int8` on `cpu` |
| `WV_KNOWLEDGE_FPS` | base frame rate | -- | `1` |

## Step -1 -- PREFLIGHT (run this FIRST, before spending anything)

```bash
bash preflight.sh [--url] [--fps N] [--transcript <path>]
```

Run this from the skill's own directory (or point at it -- it resolves `lib/config.sh` relative
to its own location, so it works from any working directory). Non-zero exit means STOP -- do not
download, do not extract frames. The gate exists because every dependency failure otherwise
surfaces LATE: ffmpeg happily writes thousands of frames and only then does an unneeded
`import faster_whisper` die, or a needed one turn out to be missing after the video is already
downloaded.

Pass `--transcript <path>` at preflight time whenever you already have one in hand -- this is the
single biggest thing that changes the verdicts below, because it tells the gate that Tier D
(whisper) will not be needed for this run at all.

**Requirements contract:**

| Requirement | Missing -> |
|---|---|
| `${WV_FFMPEG}` / `${WV_FFPROBE}` | FATAL, always |
| `${WV_PYTHON}` | FATAL only if this run actually needs it (Tier D whisper, or parsing a `.srt`/`.vtt` cue file); a plain `.txt` transcript supplied via `--transcript` needs neither |
| `faster_whisper` (on `${WV_PYTHON}`) | not required at all if `--transcript` supplied (SKIP, no warning); WARN if no transcript is supplied but the run is a `--url` run (platform captions can still carry it); FATAL if the run is a local file with no supplied transcript and no caption source |
| `ctranslate2` + CUDA device | preferred for Tier D; WARN, fall back to CPU int8 (~20x slower) |
| `${WV_YTDLP}` + `${WV_JS_RUNTIME}` | required for URL input | FATAL for `--url` runs, irrelevant for local files |
| `${WV_WORK_DIR}` headroom | FATAL (scales with configured/overridden fps against a 60-minute-source, ~3 GB baseline at 1 fps) |

**faster-whisper is the last resort in this package, full stop.** The gate is built around that:
supply a transcript and the whisper check disappears entirely, rather than merely becoming a
warning. This is the main behavioral difference from the heavier sibling package, where whisper
transcription is always in play.

**The gate NEVER auto-installs, by design -- do not "helpfully" add that.** Two reasons: (1) you
may not have write access to `${WV_PYTHON}`'s site-packages -- it may be owned by another user or
a shared install; (2) `${WV_PYTHON}` may be an environment used for other work entirely -- `pip
install faster-whisper` pulls ctranslate2, tokenizers and onnxruntime and can bump shared
dependencies underneath work that has nothing to do with this skill. The gate prints the exact
remedy command and flags the blast radius so the alternative (a dedicated environment) stays
visible.

Note that the GPU path runs through **ctranslate2, not torch** -- a CPU-only torch build in the
same interpreter is fine and does not block float16 inference on the card. Do not "fix" the
torch build on the strength of a CPU tag.

## Usage

```
/watch-video <local .mp4/.mkv/.webm path>
/watch-video <url>
/watch-video <url> --keep-video               # do not delete the downloaded copy at cleanup
/watch-video <url> --out <dir>                 # override the report output directory
/watch-video <path-or-url> --transcript <t>   # you already have a transcript -- use it, never whisper
```

Default output directory: `${WV_OUTPUT_DIR}/<slug>/` (slug = kebab-case of the video title,
date-prefixed, e.g. `2026-08-16_building-agents-with-mcp`). Working artifacts live under
`${WV_WORK_DIR}/<slug>_frames/`, `${WV_WORK_DIR}/<slug>_audio.wav` (if extracted),
`${WV_WORK_DIR}/<slug>.mp4`.

NEVER delete a user-supplied local video file (see cleanup, below).

## Step 0 -- Input resolution

Local path: verify it exists and `${WV_FFPROBE}` reads it.

URL (YouTube or anything yt-dlp supports): download with `${WV_YTDLP}` (if the system default
python is too old for the yt-dlp zipapp, point `${WV_YTDLP}` at `${WV_PYTHON} <path-to-zipapp>`
instead):

```bash
# metadata first (report header + slug + duration budget):
${WV_YTDLP} --print "%(title)s|%(channel)s|%(upload_date)s|%(duration)s" --no-download "<url>"
# then the video, capped at 1080p (screen-content readability), merged to mp4:
${WV_YTDLP} --js-runtimes deno:${WV_JS_RUNTIME} \
  --extractor-args "youtube:player_client=tv,android,ios,web_embedded" \
  -f "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[ext=mp4]/b" --merge-output-format mp4 \
  -o "${WV_WORK_DIR}/<slug>.%(ext)s" "<url>"
# then, as a SEPARATE call, the captions -- ONE language track, never a wildcard set:
${WV_YTDLP} --js-runtimes deno:${WV_JS_RUNTIME} \
  --extractor-args "youtube:player_client=tv,android,ios,web_embedded" \
  --skip-download --write-auto-subs --sub-langs "<lang>-orig" \
  -o "${WV_WORK_DIR}/<slug>.%(ext)s" "<url>"
```

**Fetch captions in a SEPARATE call, and ask for ONE track.** yt-dlp treats a subtitle download
failure as FATAL to the whole invocation, so a caption error aborts the VIDEO download that was
bundled with it. Measured on 2026-08-29: `--sub-langs "en.*,pt.*"` expanded to four tracks
(`en`, `pt-orig`, `pt`, `pt-PT`), the third came back `HTTP Error 429: Too Many Requests`, and the
run ended with no video and no captions -- twice, on two different sources, in the same session.
Splitting the calls makes a caption failure cost nothing but the captions, and asking for a single
track is what keeps the rate limiter quiet. Pick the track from the language yt-dlp lists for the
video (`--list-subs`); prefer the `-orig` variant when one exists -- it is the original-language
track rather than a machine translation of it, and machine-translated captions lose exactly the
technical terms Tier C is already weakest on.

`--write-auto-subs` is not optional to drop here even when you expect to use whisper -- it is
what makes Tier C of the transcript ladder (below) possible at near-zero cost, and costs nothing
extra to request.

YouTube bot-gate workarounds (all three were needed the first time this was tried against a
bot-gated channel -- keep all three, do not drop any as "probably not needed this time"): (1) a
configured JS runtime (`${WV_JS_RUNTIME}`) -- without one, extraction is deprecated and fails; (2)
`--extractor-args "youtube:player_client=tv,android,ios,web_embedded"` -- the default web client
can return "Sign in to confirm you're not a bot"; (3) tv/android alone may serve only 360p
(DRM/SABR experiments skip HD formats) -- ffprobe the result and if height < 720, re-download with
the full four-client list and an explicit format id (`-F` to list; e.g. `-f "399+ba"` for 1080p
AV1). A failed mp4 merge is fine: the video-only stream still works for frames, and audio can come
from the first (low-res) download.

**AV1 decodes slowly.** An AV1-encoded download can decode noticeably slower than an equivalent
H.264 file during frame extraction -- budget for it and prefer an H.264 format id when one is
available at the same resolution.

If yt-dlp fails outright (age gate, region lock, extractor breakage): report the exact error and
ask for a direct file or alternative source. Do not scrape around gates. Refresh yt-dlp when
YouTube extraction breaks (`curl -sL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
-o <path to your WV_YTDLP zipapp>`).

## Step 1 -- Probe + budget

`${WV_FFPROBE} -v error -show_entries format=duration -of csv=p=0 <video>` -- sanity-check
duration.

Disk headroom check BEFORE extracting: 1 fps is ~50-150 KB/frame, well under 1 GB for a 60-min
video.

## Step 2 -- Frame extraction

```bash
mkdir -p ${WV_WORK_DIR}/<slug>_frames
${WV_FFMPEG} -hide_banner -i <video> -vf "fps=${WV_KNOWLEDGE_FPS}" -q:v 3 ${WV_WORK_DIR}/<slug>_frames/f_%06d.jpg
```

`${WV_KNOWLEDGE_FPS}` (default 1 fps) base. Frame number maps to time as `f_NNNNNN` = second
`NNNNNN - 1` (frame f_000001 = t=0s). Keep this mapping exact -- every later frame lookup depends
on it.

High-resolution video can decode slowly (roughly 2x-3x video duration for a 1 fps extraction pass
on modest hardware). Start frame extraction FIRST as a background task and do transcript work /
early frame reads on whatever is already extracted -- frames land in order, so later reading can
chase the extractor. See "Background-task discipline" below before launching anything detached.

## Step 3 -- THE TRANSCRIPT RESOLUTION LADDER (headline feature -- work it in order)

**Do not run whisper until you have proven, in order, that tiers A through C are unavailable.**
Whisper (Tier D) is the last resort in this package, not a default. State in the eventual report
header which tier produced the transcript that was actually used.

### Tier A -- a transcript you were handed explicitly

If invoked with `--transcript <path>`, use it. NEVER run whisper when this tier resolves.
Supported formats:
- `.txt` -- already in a usable line format; use as-is (or reformat to `[mm:ss] text` if it
  carries no timestamps and you can derive them from context; otherwise treat it as
  timestamp-free and rely on frame checks more heavily during the guided read).
- `.srt` -- parse numbered cue blocks (`HH:MM:SS,mmm --> HH:MM:SS,mmm` followed by one or more
  text lines) into `[mm:ss] text` lines, one per cue, using the cue START time.
- `.vtt` -- parse `HH:MM:SS.mmm --> HH:MM:SS.mmm` cue blocks the same way; strip the `WEBVTT`
  header and any `NOTE`/style blocks.

Label the transcript header `[source: user-supplied, tier A]`.

### Tier B -- a transcript already sitting next to the video

If no `--transcript` was given, look for `<video-basename>.txt`, `.srt`, `.vtt`, or `.json`
(a whisper/faster-whisper JSON dump, which already carries per-segment timestamps) beside the
input file, and also in `${WV_OUTPUT_DIR}` under the slug from a prior run. If found, say so
explicitly and use it -- parse the same way as Tier A. Label the header
`[source: sidecar file, tier B]`.

### Tier C -- platform captions fetched with the video

If Step 0 downloaded a subtitle file via `--write-auto-subs` (`${WV_WORK_DIR}/<slug>.en.vtt` or
similar language variant), parse it into `[mm:ss] text` format: strip cue headers and style
blocks, and **deduplicate the rolling-window repeats auto-generated captions produce.** Label the header
`[source: platform captions, tier C]` and flag explicitly that **auto-captions mangle technical
terms** -- proper nouns, library/API names, acronyms, and numbers are the most common failure
points. Any span that reads as garbled or nonsensical should be cross-checked against the frames
for that timestamp (an on-screen slide, terminal, or lower-third often disambiguates it) before
being trusted in the knowledge document.


**The rolling-window dedup, exactly.** A YouTube-style auto-caption track is a two-line scrolling
window: each cue repeats the tail of the previous cue as its head, so a naive concatenation of
cues duplicates almost every word. Do not dedup by "cues that look similar" -- collapse on
WORD-LEVEL OVERLAP against the running transcript:

```python
def dedup(cues):                      # cues: list of (start_seconds, [text lines])
    out, acc = [], []                 # acc = trailing words already emitted
    for t, lines in cues:
        w = " ".join(lines).split()
        k = min(len(acc), len(w))     # longest suffix of acc that prefixes w
        while k > 0 and acc[-k:] != w[:k]:
            k -= 1
        new = w[k:]
        if new:
            out.append((t, " ".join(new)))
            acc = (acc + new)[-40:]
    return out
```

**Then check words-per-minute before trusting the result** -- this failure is silent, and the
duplicated transcript reads perfectly well line by line. Divide the final word count by the
source duration in minutes: unhurried narration is roughly 120 wpm, fast presenters reach about
190, and sustained speech above ~250 wpm is not a fast speaker, it is a dedup that did not
collapse. Measured on 2026-08-29: a `startswith`-based collapse left both sources at 220 wpm x 2
= 439 and 441 wpm; the overlap rule above brought them to 220 and 221 wpm, which is what the
audio actually is. Print the wpm next to the tier label so the check cannot be skipped.

### Tier D -- transcribe with faster-whisper (LAST RESORT -- only if A, B, and C all failed)

Reaching this tier means: no `--transcript` was given, no sidecar file exists, and either the
input was a local file (no caption source exists at all) or a `--url` run's caption download came
back empty/unusable. Say so explicitly before starting -- this is the expensive path and the
report should be honest that it was needed.

- **Default to GPU**: `WhisperModel(<model>, device="cuda", compute_type="float16")` when a CUDA
  device is available (check `nvidia-smi` / `ctranslate2.get_cuda_device_count()`). Falls back to
  CPU (`device="cpu", compute_type="int8"`) when no GPU is free -- note explicitly that the CPU
  path is roughly 20x slower and set expectations before starting a long job.
- **Model choice**: `distil-large-v3` with the batched pipeline for clean English narration
  (roughly 6x faster than `large-v3` at near-identical accuracy on clean audio). Distilled models
  are English-focused -- for non-English audio or hard audio (heavy accents, bad mics, crosstalk,
  music-over-speech) use `${WV_WHISPER_MODEL}` (`large-v3` by default) instead, batching still
  recovers some speed:
  ```python
  from faster_whisper import WhisperModel, BatchedInferencePipeline
  model = WhisperModel("distil-large-v3", device="${WV_WHISPER_DEVICE}", compute_type="${WV_WHISPER_COMPUTE}")
  batched = BatchedInferencePipeline(model=model)
  segments, info = batched.transcribe(
      "${WV_WORK_DIR}/<slug>_audio.wav", batch_size=8, vad_filter=True, language="en",
  )
  ```
  Audio extraction, if not already done: `${WV_FFMPEG} -hide_banner -i <video> -vn -acodec
  pcm_s16le -ar 16000 -ac 1 ${WV_WORK_DIR}/<slug>_audio.wav`.
- **Sequential only, never in parallel.** `large-v3` in float16 needs roughly 4.2 GB of an 8 GB
  card; run one whisper job at a time, one model load, in the foreground or watched as a
  background task (see discipline below). Two concurrent large-v3 jobs is a proven failure mode
  even on GPU, and far worse on CPU where they thrash memory bandwidth.
- Run with `${WV_PYTHON}` as a background task if the video is long; first use downloads the
  model (a gigabyte or two) to the local model cache.
- Label the header `[source: faster-whisper <model>, tier D (last resort)]`.

**Transcript quality gate + fallback chain (applies once a Tier C or D transcript exists).** After
whisper/captions land, assess completeness: full-duration coverage? long timestamp gaps? repeated
gibberish? truncated output? silence in the transcript where frames show visible speech?
- Complete and coherent -> proceed to the guided read.
- Degraded -> work the chain in order:
  1. Re-check for a fresher sidecar/platform export that might have appeared since ingestion
     started (Tiers B/C revisited).
  2. Re-run whisper with tuned params: `vad_parameters={"threshold": 0.3}`,
     `no_speech_threshold=0.4`, `condition_on_previous_text=True`, temperature fallback
     `[0.0, 0.2, 0.4, 0.6]`. For isolated bad ranges, cut that span alone
     (`${WV_FFMPEG} -ss <start> -to <end>`) and transcribe it in isolation.
  3. **LAST RESORT: OCR transcript from frames.** The frame sequence often captures on-screen
     captions (platform native captions, or any shared-screen text). Read frames chronologically,
     deduplicate overlapping caption text across consecutive frames, assemble a reconstructed
     transcript with timestamps derived from frame number / fps. Label the source
     `[OCR-from-frames]`.
  Log which fallback path was used and why in the saved transcript file header.

While any whisper tier runs, do the blind visual sweep (below) -- do not sit idle.

## Blind visual sweep (transcript-independent)

Before (or while) reading the transcript, skim the base-fps frames at a coarse stride (every
30-60s; roughly 60-120 frame reads for an hour of video) to build a visual map: talking head vs
slides vs live demo vs code vs charts, and WHERE the visual-dense segments are. Two reasons: (a)
the transcript cannot flag visuals the speaker never verbalizes ("as you can see here"); (b) the
map tells you where the guided read will need frame work, so you pace it.

## Guided read: transcript + proactive frame checks (THE CORE of this skill)

Walk the ENTIRE transcript start to finish, whichever tier it came from. At every moment where the
words alone do not carry the meaning, look at the frame(s) for that timestamp. Trigger phrases and
situations that REQUIRE a frame check:

- deictic language: "this", "here", "as you can see", "on the right", "this line", "like so"
- anything being demonstrated live: code typed/run, terminal output, UI walkthrough, config
- slides with diagrams, architecture boxes, tables, benchmark charts, formulas
- numbers read aloud from a chart (verify the chart actually says that)
- any segment the visual-sweep map marked visual-dense, even if the narration sounds
  self-contained

Lookup: second `t` -> `${WV_WORK_DIR}/<slug>_frames/f_{t+1:06d}.jpg` (Read the image). Small
on-screen text (code, terminal): crop the region and upscale ~2.5x with LANCZOS before reading;
raw frames of an editor are often unreadable at native size.

**Zoom-burst when the base frame rate is not enough.** If the moment is fast (typing, scrolling,
a chart transition, a quick demo) or the single frame is ambiguous, extract a dense burst around
it and read until the moment is actually understood:

```bash
mkdir -p ${WV_WORK_DIR}/<slug>_frames/burst_<mmss>
${WV_FFMPEG} -hide_banner -ss <t-2> -t 4 -i <video> -vf "fps=10" -q:v 3 \
  ${WV_WORK_DIR}/<slug>_frames/burst_<mmss>/b_%03d.jpg
```

That is 2s before to 2s after at 10 fps = 40 frames. To read them efficiently, tile first (one
Read = 9 frames -- a 3x3 contact sheet):

```bash
${WV_FFMPEG} -ss <t-2> -t 4 -i <video> -vf "fps=2.25,scale=640:-1,tile=3x3" \
  -frames:v 1 ${WV_WORK_DIR}/<slug>_frames/sheet_<mmss>.jpg
```

Open individual burst frames only where the sheet shows something worth pixel-level reading.
Widen the window or raise fps if the burst still does not settle it -- the bar is "I could
re-explain what happened on screen," not "I glanced at it."

Keep running NOTES as you go (a scratch section per segment: claim made, what the screen showed,
whether they agree). Discrepancies between narration and screen are findings, not noise -- flag
them in the report.

## Background-task discipline

- **A subagent that spawns a detached job and then stops WILL NEVER WAKE UP.** Either block on
  transcription/extraction in the foreground or poll for its output file; a "waiting" agent does
  not resume itself. When orchestrating, watch the job yourself and message the agent when the
  artifact is ready.
- A waiter watching a PID fires when that PID is KILLED, which is a FALSE completion signal --
  prefer waiting on a sentinel string (e.g. `DONE`) written to the job's log at the end of the
  script.
- `pkill -f <pattern>` matches your OWN shell if the pattern appears in your command line -- kill
  by exact PID instead.
- One whisper job at a time, run sequentially even on GPU (see Tier D).
- Long videos (2h+): announce any whisper ETA up front, run it in background, and front-load the
  visual sweep so the wait is productive.

## Deliverables (BOTH, always: one for agents, one for humans)

Write both documents to the output dir; in chat give ONLY the paths + a <=2-line summary --
never paste report prose into chat. Deliverables are full descriptive prose. ASCII only. Also
copy the final transcript to the output dir as `<slug>_transcript.txt`, with its tier-A/B/C/D
source label preserved in its header.

### 1. `<slug>_knowledge.md` -- THE PRIMARY DELIVERABLE

Agent-ingestible knowledge document (markdown, for feeding to assistants). The whole point of
watching is that this file can be handed to a FRESH agent as context and that agent comes away
KNOWING the content -- not knowing that a video exists. Rules:

- Written DECLARATIVELY, as reference documentation of the knowledge itself. "The tool enforces
  five controls: ..." -- never "the narrator explains that...". No watch-review meta: no verdict,
  no audience-fit, no "worth watching", no walkthrough-of-the-video frame.
- SELF-CONTAINED: define every term on first use; include the exact artifacts captured from
  frames (skill/prompt texts, commands, code, checklists, configs, numbers, URLs) in code blocks
  verbatim. A reader with zero prior context must be able to APPLY the content.
- Provenance-tagged inline so the ingesting agent knows what to trust:
  `[ON-SCREEN]` read from pixels (highest trust) | `[STATED]` narrator claim, unverified |
  `[WEAK]` narrator citing secondary/AI-generated sources | `[INFERRED]` this pipeline's own
  synthesis. Tag at least every number, product claim, and benchmark.
- Errors in the source become a "Corrections" section stating the RIGHT fact first and the
  source's error second -- so an ingesting agent learns the correction, not the mistake.
- Structure: header (one source line: title/author/date/URL + topic tags, PLUS the transcript
  tier used, e.g. "transcript: platform captions (tier C)") -> "Core thesis" (2-4 sentences) ->
  the knowledge organized by CONCEPT (not by video chronology), each concept = WHAT it is, HOW it
  works, WHAT FOR / when to apply, exact artifacts -> "Insights and intakes" (the non-obvious
  takeaways, stated declaratively) -> "Corrections" -> "Boundaries" (what the source does NOT
  cover / where its advice stops applying) -> "Value map: your environment" (final section,
  REQUIRED): map each major intake to the reader's own stated projects and working context -- how
  it could add value, or explicitly does not, across the reader's own work environment, agent
  orchestration, architecture, working style, daily routine, ongoing projects, and any deliberate
  skill-building the reader has told you about. Honest per-area assessment; "no value here because
  <reason>" is a first-class answer. Do not hardcode a project list -- pull the reader's actual
  projects/context from what they have told you this session (or from their own notes, if you have
  access to them). This section exists so an assistant ingesting the doc knows not just the
  content but where to deploy it.
- What stays OUT of the knowledge doc: watch-worthiness verdicts, audience-fit talk,
  video-chronology narration -- that is report.html material.
- Length: whatever completeness requires; typically 150-450 lines. Timestamps optional and only
  as citations, e.g. (src 04:24) -- never as the organizing spine.

### 2. `<slug>_report.html` -- the HUMAN-facing document

There is no report.md -- the only markdown deliverable is the knowledge doc.

**This is a DIDACTIC PRESENTATION, not a formatted dump of the markdown.** Its job is to make the
source's central idea land with someone who has not seen it. A page of stat tiles, section cards
and colour-coded callouts is a template and reads as one. Instead:

- **Name three directions, pick one, and say why.** Before any CSS, write one line each for THREE
  art directions this subject could support, named concretely ("wire-bound field notebook",
  "oscilloscope trace on grid paper", "1960s technical manual") -- never as a count. Asking
  yourself for "three versions" without naming them produces three of the same thing; the naming
  is what forces them apart. Choose one in a sentence, on a reason drawn from the material. The
  two you rejected cost three lines and are the only reliable defence against reaching for the
  house style by reflex.
- **Lock the palette and type scale AFTER the direction, never before.** A token set fixed up
  front decides the page before the subject has had a say, and every page built that way comes
  out the same. Freeze the values into `:root` custom properties once the direction and the
  signature element exist, so the rest of the page stays consistent with what you actually built.
- **Ground the design in the subject.** Name the single idea the page exists to teach, and design
  outward from the subject's own world -- its materials, artifacts, vocabulary.
- **Build ONE signature element that TEACHES**: a diagram, trace, comparison or interactive model
  that makes the central idea visible in a way prose cannot. Everything else stays quiet and
  disciplined so that element carries.
- **Colour carries meaning, not decoration.** Assign each accent to a concept in the material,
  use it for nothing else, and introduce it in a legend.
- **Type is the biggest single lever, and offline is where it gets hard.** A self-contained report
  cannot fetch a webfont and the reader's machine is not yours, so a stack naming a distinctive
  family first will silently substitute on half the machines that open it. Pull the lever with
  what survives substitution: SCALE (a display size that is genuinely large, not a timid 1.5x
  body), WEIGHT CONTRAST, TRACKING, MEASURE (~65 characters, not full-bleed text), and CASE. Set a
  real stack ending in a generic family (`Charter, "Bitstream Charter", Georgia, serif`) rather
  than a bare `sans-serif`, and reserve a distinct face for data and labels. Embedding a face
  base64 is the only way to guarantee it offline; it costs the font's weight in page size and a
  licence that permits embedding, so decide it deliberately or not at all.
- **If there is motion, there is exactly one moment of it.** Scattered micro-interactions are the
  tell that a page was assembled rather than designed. Animate transform and opacity only --
  animating layout properties is where the jank comes from -- and honour `prefers-reduced-motion`
  by removing the motion, not shortening it.
- **Structural devices must encode something true.** Numbered sections only when the content is
  genuinely a sequence.
- **The prose is half of it.** A page can be typeset well and still announce itself as machine-made
  in the first sentence. Copy gives it away through a promise so broad it would fit any subject,
  no concrete evidence where a number or example belongs, interchangeable vocabulary ("leverage",
  "seamless", "journey", "unlock", "robust"), and the smooth unrevised cadence of a first draft.
  The test that catches all four: **if a sentence would survive being moved to a report about a
  different subject, it is not saying anything.** Cut it or make it specific. Applies hardest to
  the headline, the standfirst, and section openers.
- **Self-contained**: inline CSS/JS, no CDNs, no webfont fetches (it must render offline years
  from now). Responsive, visible keyboard focus, `prefers-reduced-motion` respected.
- **Critique it by LOOKING at it.** Render and screenshot before delivering, then write a short
  PRIORITISED fix list naming a dimension for each item rather than a general impression --
  hierarchy (does the eye land on the one thing the page exists to teach?), composition
  (structural, or a stack of equal boxes?), typography (scale, measure, rhythm, or defaults?),
  colour (does every accent map to a concept?), density (real air, or uniform padding?), craft
  (alignment, optical spacing, narrow widths), originality (recognisable as being about THIS
  subject with the words removed?). Fix and render again. One pass, not a scoring loop. A headless
  screenshot captures BEFORE any `setTimeout` fires, so force any JS-driven state synchronously at
  parse time in a throwaway copy -- never in the deliverable.
- **Run the slop checklist against the screenshot**, not against the source. Each mark below is
  individually defensible; only the COMBINATION is the tell, and the reader recognises the pattern
  before reading a word: the default interface typeface at default sizes; a violet-to-indigo
  gradient (or any gradient) standing in for "technical"; a centred headline over a centred
  sub-line over a centred button; three cards in a row because three is what the grid does rather
  than because there are three things; one border-radius on every card, button and module alike;
  frosted glass used decoratively, carrying no information. One of these is a choice. Four
  together is the house style of every model on the market.
- **Watch CSS selector specificity** where state classes layer: a rule with two classes loses to
  one with three, silently breaking the contract the legend promised.

Content, sectioned:

- Header: title, channel/author, date, duration, URL, and the transcript tier + quality note
  (e.g. "transcript: tier A, user-supplied .srt" or "transcript: tier D, faster-whisper
  distil-large-v3 (last resort -- no existing transcript or captions found)").
- Executive summary: what the video is about and what it teaches -- a standalone paragraph
  someone could read INSTEAD of watching; context (who is speaking, in what setting, for what
  audience) plus the core content.
- Structured walkthrough: the video's argument/content section by section with timestamps,
  integrating what the FRAMES showed (screenshots described, not just narration echoed).
- Key insights: the non-obvious takeaways, each tagged with the timestamp evidence.
- Narration-vs-screen discrepancies, if any.
- Applicability -- daily routine: concrete ways this changes/improves how the reader works day to
  day, if applicable; say "none" honestly if it does not.
- Applicability -- ongoing projects: map insights to the reader's live project surface (pull the
  current list from whatever the reader has told you or from their own notes -- do not hardcode
  one). Per project: what to adopt, what to ignore, and why. Only claim value where a real
  mechanism exists -- no forced relevance.
- Verdict: was it worth the watch; who/what it is actually for; follow-up material named in the
  video worth chasing.

That list is the report's CONTENT contract; its LOOK comes from the design direction above and
nowhere else. Two content items are easy to lose and are owed to the reader: the transcript tier
(in the header, where it qualifies everything below it) and the ingest cost (duration, frames
read, bursts cut). Both are provenance rather than decoration -- put them where a reader deciding
how much to trust the page will see them. They do NOT have to be stat tiles; a stat-tile row is
the most template-like way to render them.

**A note on this section's own history.** Until 2026-08-29 it ended with a prescribed dark palette
(near-black page, lighter cards, a blue accent), a table of contents, section cards, stat cards
and colour-coded callouts. That instruction cancelled the direction it sat under -- the direction
opens by saying a page of stat tiles and colour-coded callouts reads as a template, and the
paragraph then required exactly that, in the same colours, every time. It was removed rather than
softened.

## FINAL CLEAN PHASE (mandatory last step)

**Cleanup must also run when the run does NOT succeed.** The delete-list below is written for the
happy path, but the expensive scratch is created EARLY -- frames land before any deliverable
exists. A run that fails, errors, or is interrupted leaves all of it behind, and at a high frame
rate that is gigabytes. Whenever a run ends for ANY reason without reaching the steps below, invoke
the helper directly:

```bash
bash cleanup.sh <slug>              # remove this run's scratch, verify, report
bash cleanup.sh <slug> --dry-run    # show what would go, remove nothing
bash cleanup.sh --stale 1 --force   # reap orphans from earlier runs older than a day
```

`cleanup.sh` refuses an empty, short, or path-like slug rather than globbing the whole work
directory, verifies afterwards that nothing remains (a cleanup that silently failed reads exactly
like one that succeeded), and warns if a process is still running that could recreate what was
just deleted. Run `--stale` at the START of a session too: orphans from a previous failed run are
invisible otherwise, and they are the reason a work directory quietly fills up.

### HARD CLEANUP RULES (non-negotiable; added 2026-08-30)

On 2026-08-30, 8.5 GB of orphaned `*_frames` dirs from July-August runs were found in bare
`/tmp` on a 97%-full disk. The cause was a config `work_dir` of bare `/tmp` plus runs that never
invoked the reaper. These rules exist so that cannot recur; a run that violates any of them is
INCOMPLETE even if every deliverable landed.

1. Scratch lives ONLY under `${WV_WORK_DIR}`, which MUST be a dedicated directory -- never bare
   `/tmp` and never a directory shared with anything else. Before extracting a single frame,
   print the resolved `WV_WORK_DIR` and refuse to proceed if it resolves to bare `/tmp` (or
   `$TMPDIR` itself). Never write frames, audio, or helper scripts to any path outside it.
2. The LAST action of EVERY run -- success, failure, or interruption alike -- is
   `bash cleanup.sh <slug>`, and the run's final report must state what was deleted and what
   remains (the helper prints both). Scratch surviving a finished run is a defect to report,
   not a leftover to ignore.
3. The FIRST action of every run is `bash cleanup.sh --stale 1 --force` to reap earlier orphans;
   the reaper also sweeps the legacy bare-/tmp location where pre-2026-08-30 runs left scratch.
4. Never deleted, ever: user-supplied input files (the provenance rule above) and the final
   deliverables in `${WV_OUTPUT_DIR}`. Everything else this pipeline created is scratch and
   dies with the run that created it.


After ALL deliverables are written and the transcript is copied to the output dir, delete EVERY
file the pipeline created or downloaded. The only artifacts that survive a run are the three files
in the output dir: `<slug>_knowledge.md` (agent-feeding), `<slug>_report.html` (human-facing),
`<slug>_transcript.txt`.

Delete-list (walk it explicitly -- stragglers are easy to miss on the first pass):
- `${WV_WORK_DIR}/<slug>_frames/` -- base frames, ALL burst_* subdirs, ALL sheet_*.jpg tiles
- `${WV_WORK_DIR}/<slug>_audio.wav` and any segment cuts made for spot-transcription (Tier D runs
  only -- there is nothing to delete here if a Tier A/B/C transcript was used and audio was never
  extracted)
- downloaded video copies, INCLUDING partial/fragment files: `${WV_WORK_DIR}/<slug>*.mp4`,
  `.f<id>.mp4` / `.f<id>*.webm` stream fragments, `.temp.mp4`, `.part`
- subtitle files: `${WV_WORK_DIR}/<slug>*.vtt` (all language variants) -- once parsed into the
  kept transcript, the raw downloaded caption file is scratch
- helper scripts: `${WV_WORK_DIR}/transcribe_<slug>.py`, `${WV_WORK_DIR}/parse_vtt_<slug>.py`, any
  other scratch script written for this run
- the raw whisper/caption transcript in `${WV_WORK_DIR}` (the output-dir copy is the keeper)
- **render scratch from the critique pass**: the screenshot(s) you took of the HTML report, any
  cropped/split copies of them, and the throwaway copy of the page used to force an interactive
  state. The design direction REQUIRES rendering and screenshotting, so this scratch exists on
  every run that produces a report -- and it is the one category the slug glob below misses if you
  named it anything other than `<slug>_shot*.png`. Name every scratch file with the slug prefix
  for exactly this reason.

In practice one glob covers the scratch surface --
`rm -rf ${WV_WORK_DIR}/<slug>* ${WV_WORK_DIR}/*_<slug>.py` -- provided the slug is unique; then
VERIFY with `ls ${WV_WORK_DIR}/<slug>* 2>&1` (expect "no such file") and `ls <output-dir>` (expect
exactly the three keepers). Report the verification result.

**Exceptions:**
- `--keep-video`: keep the downloaded video file, delete everything else on the list.
- **NEVER delete a user-supplied local video -- only copies the pipeline itself downloaded.** A
  video handed to this skill as a local path usually belongs to the reader or a third party, not
  to this pipeline's own download; this rule has no exceptions in this skill (there is no
  forensics mode here that would ever delete a source recording).
- **NEVER delete a transcript file that was supplied via `--transcript` or found as a Tier B
  sidecar next to the video** -- those belong to the reader, same reasoning as the source video;
  only pipeline-downloaded caption files (Tier C, raw `.vtt`) and pipeline-generated whisper
  output (Tier D) are scratch.
- Also confirm no background task from the run is still alive (frame extractor, whisper):
  `pgrep -fa "<slug>|ffmpeg.*fps=${WV_KNOWLEDGE_FPS}"` should come back empty before finishing.

## House rules (no exceptions)

- **ASCII only** -- never unicode arrows, checkmarks, box-drawing, or emoji anywhere (code,
  transcripts, deliverables, chat).
- Deliverable documents (knowledge.md, report.html) are full descriptive prose.
- In chat, give ONLY file paths plus a <=2-line summary of what changed -- never paste report
  markup or reproduce artifact prose into chat.
- This skill never analyzes tone, pace, pitch, energy, or speaker behavior. If the input turns out
  to be a multi-party recording (a meeting, panel, call, or working session) and the reader wants
  that kind of analysis, stop and point them at **watch-video-max** instead of improvising a
  behavioral read here.
