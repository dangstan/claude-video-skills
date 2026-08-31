---
name: watch-video-max
description: Deep study of a single video (local file or URL) at full depth -- ALWAYS a verbatim transcript, a high frame rate, and reconstruction of what was actually on screen rather than a summary of what was said about it. Produces <slug>_knowledge.md (agent-ingestible, provenance-tagged), <slug>_report.html (human-facing), and <slug>_transcript.txt. Explicit trigger: "/watch-video-max <path-or-url>", or "study this video properly", "go deep on this video", "I need to actually learn this one". There is exactly one depth and it is the deepest available -- do not ask what depth is wanted. USE THE LIGHTER SIBLING "watch-video" INSTEAD when a transcript already exists and reusing it is good enough: that package's headline is the transcript ladder (a transcript you supply, a sidecar, platform captions) and it treats whisper as a last resort. USE THE SIBLING "video-autopsy" INSTEAD for behavioural or technical forensics on a recording of people talking and/or sharing a screen -- meetings, panels, podcasts, conference talks, pair-programming sessions, interviews, sales calls -- where the question is about the participants or the working session rather than the material: talk-share and turn-taking, silence and pace per phase, prosody, micro-expression bursts, and live-coding screen forensics. This package does NO audio, prosody, diarization, or behavioural analysis of any kind. What it does: extract frames ONCE at a high rate, transcribe verbatim with faster-whisper, walk the whole transcript with a guided read that escalates to the frames wherever the words alone do not settle what happened, reconstruct the on-screen artifacts (code, diagrams, charts, configs, commands) and ANALYSE them, then deliver both an agent-ingestible knowledge document and a human-facing HTML report. On a URL input it also fetches the platform caption track as a CROSS-CHECK ARTIFACT -- a second ASR engine whose disagreements with the verbatim transcript are sent to the frames to adjudicate, producing the Corrections section -- never as a transcript source and never as a fallback tier. Cleanup follows a single provenance rule: never delete an input the pipeline did not create.
---

# watch-video-max

**Deep study of one video.** Verbatim transcript, high frame rate, full reconstruction of what was
on screen -- then an analysis of the material itself, not a summary of the narration.

This package exists for the case where a video is worth actually learning: the artifacts on screen
are load-bearing, exact wording matters, and a transcript summary would lose the thing you came
for. It pays for that with a whisper pass on every run and roughly five times the frames of its
light sibling.

Read this file start to finish. It is the single source for the whole pipeline -- there are no
reference files to route to.

**Which package is this, and which is the other one.**

- **`watch-video`** -- the cheap path. Its headline is transcript REUSE: a transcript you supply,
  a sidecar beside the video, or platform captions, with whisper only as a last resort. Reach for
  it when a transcript already exists and reusing it is good enough.
- **`watch-video-max`** (this one) -- the deep path. Always verbatim, always high fps, artifact
  reconstruction. Reach for it when the screen matters and exact quotes matter.
- **`video-autopsy`** -- the behavioural/technical path. Talk-share, turn-taking, silence and pace
  per phase, prosody, micro-expressions, live-coding screen forensics, on any recording of people
  talking and/or sharing a screen. Reach for it when the question is about the PEOPLE or the
  WORKING SESSION rather than the material.

**A tombstone, so the next author does not re-add what was deliberately removed.** Until
2026-08-30 this package ran ONE ingest under TWO selectable output lenses, KNOWLEDGE and FORENSICS,
and carried a four-tier transcript resolution ladder that treated whisper as a last resort. Both
are gone, on purpose:

- **The forensics lens moved out**, whole, into `video-autopsy`. It did not shrink and it was not
  cancelled -- it is a full package now, and it covers every recording that lens covered. Keeping
  a second copy here is how the two drift apart. If you find yourself wanting behavioural analysis
  in this package, you want `video-autopsy`; add it THERE.
- **The transcript ladder went with it.** A package whose stated positioning is "always verbatim"
  cannot also ship an ordered preference list that puts whisper fourth -- the list is the concrete
  instruction and it is what gets followed, so the positioning would have been decoration. The
  ladder still exists, in full, in `watch-video`, which is the package it actually describes. What
  remains here is a verbatim requirement plus a RECOVERY chain for when whisper output is bad,
  which is a different thing from a cheaper alternative to whisper.
- **The caption FETCH came back on 2026-08-30. The caption TIER did not, and must not.** Deleting
  the ladder also deleted the only second reading of the audio this package had, and with it the
  disagreement signal that produced the Corrections section in every earlier run that had one. Two
  decisions had been run together: "whisper is the transcript of record" (right) and "captions are
  not worth fetching" (wrong). Captions are fetched again in Step 0 and consumed at exactly one
  place, Step 5, as a CROSS-CHECK ARTIFACT -- a second ASR engine whose disagreements with the
  verbatim transcript nominate timestamps for the frames to settle. They are never a transcript,
  never a tier, never a fallback, and a failed fetch costs the run nothing but the cross-check. Do
  not fold this back into a tier, and do not delete it again as ladder residue: it is the mechanism
  that catches a wrong proper noun before it reaches a deliverable.

## Configuration (read once, applies everywhere below)

Every `${WV_*}` placeholder used in this file resolves in this fixed order:

1. **Environment variable** of the same name (e.g. `$WV_PYTHON`).
2. **Config file** key of the same name, lower-cased and un-prefixed (e.g. `WV_PYTHON` ->
   `python`).
3. **Auto-detection** on the host, where a sane one exists (e.g. `which ffmpeg`).
4. **Documented default** below.

Config file, first that exists: `$WV_CONFIG`, `./.watch-video.json`,
`${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json`. This is the same family config file
`watch-video` and `video-autopsy` read -- pin the toolchain once and all three use it.

| Placeholder | Meaning | Auto-detect | Default |
|---|---|---|---|
| `WV_PYTHON` | Interpreter with `faster_whisper`/`ctranslate2` importable | `which python3` | `python3` |
| `WV_FFMPEG` | ffmpeg binary | `which ffmpeg` | `ffmpeg` |
| `WV_FFPROBE` | ffprobe binary | `which ffprobe` | `ffprobe` |
| `WV_YTDLP` | yt-dlp executable (zipapp or installed package) | `which yt-dlp` | `yt-dlp` |
| `WV_JS_RUNTIME` | JS runtime yt-dlp needs for extraction (e.g. deno, node) | `which deno` then `which node` | empty -- the flag is omitted entirely (passing a runtime that is not installed breaks extraction) |
| `WV_WORK_DIR` | Scratch directory for all intermediate files | -- | `${TMPDIR:-/tmp}/watch-video-max` |
| `WV_OUTPUT_DIR` | Where deliverables are written | -- | `$HOME/watch-video-max/reports` (anchored to $HOME on purpose: output must not depend on the directory you invoked from) |
| `WV_WHISPER_MODEL` | The verbatim-tier whisper model name | -- | `large-v3` |
| `WV_WHISPER_DEVICE` | `cuda` or `cpu` | probe for a CUDA device | `cuda` if a compatible GPU is free, else `cpu` |
| `WV_WHISPER_COMPUTE` | ctranslate2 compute type | -- | `float16` on `cuda`, `int8` on `cpu` |
| `WV_MAX_FPS` | Frame extraction rate for this package | -- | `5`. See the note below -- this is the measured rate at which on-screen artifacts stay legible, and it is what makes this package "max" |

Every placeholder either has a working default or is FATAL-if-unset at preflight; never invent a
literal path in place of a placeholder that has none.

**Why the default frame rate is 5 and not 1.** Measured on 2026-08-29 across two screencasts:
three on-screen artifacts that were load-bearing to the content were ILLEGIBLE at 1 fps and
readable at 5. The light sibling defaults to 1 fps because it is optimising for cost; this package
is optimising for not missing the thing you came for. Lowering `WV_MAX_FPS` below 5 is allowed and
the resolver warns rather than clamping -- but a run below 5 fps must say so in the report header
and treat any claim about a briefly-shown artifact as possibly incomplete.

## Depth: this is the default, not an upgrade

**The trigger alone runs everything below, at full depth.** `/watch-video-max <path>`, "study this
video properly", "go deep on this one", or a recorded synonym ("the full treatment", "like you did
it last time") -- all of these run the complete pipeline with no clarifying question about scope or
depth. There is exactly one depth and it is the deepest available. Do not offer a lighter pass; do
not ask whether the frame work is wanted. Asking is itself a failure of the trigger.

If a lighter pass is genuinely what is wanted, that is a different package -- `watch-video` -- not
a reduced mode of this one.

## Cost

- **Frames.** One extraction pass at `${WV_MAX_FPS}` (default 5). Disk scales linearly: roughly
  12000 MiB for a 60-minute source at 5 fps, so ~24000 MiB at 10 fps and ~4800 MiB at 2 fps.
  `preflight.sh` computes and prints the actual number for your configured rate -- do not
  hand-calculate it separately.
- **Transcription.** Always. Plain sequential `${WV_WHISPER_MODEL}` (large-v3) in float16 measured
  11.8x and 9.7x realtime on a mid-range GPU using 4,152 MiB, so an hour of source is roughly five
  to six minutes of GPU time. The CPU path is about 20x slower -- announce the ETA before starting.
- **Frame reads.** The guided read is where the wall-clock actually goes on a dense source. Budget
  for it rather than being surprised by it.

Two ways to change the frame rate, in precedence order -- a per-run flag beats an environment
variable, which beats the config file, which beats the default:

```bash
bash preflight.sh --fps 10        # dense pass for a fast screen-share, this run only
WV_MAX_FPS=10 ...                 # this shell
"max_fps": 10                     # config file, every run
```

`--fps` is validated: a non-numeric or non-positive value is refused outright rather than silently
disabling frame extraction. Raise it for fast screen-share, rapid scrolling, or a live-coding
segment where a transition falls between samples.

## Step -1 -- PREFLIGHT (run this FIRST, before spending anything)

```bash
bash preflight.sh [--url] [--fps N]
```

Run this from the skill's own directory (or point at it -- it resolves `lib/config.sh` relative
to its own location, so it works from any working directory). Non-zero exit means STOP -- do not
download, do not extract frames. The gate exists because every dependency failure in this
pipeline otherwise surfaces LATE: ffmpeg happily writes thousands of frames and gigabytes to
`${WV_WORK_DIR}`, and only then does the first `import faster_whisper` die. The gate samples
second zero, when nothing has been spent.

**There is no `--transcript` flag.** This package always transcribes. A transcript you already
have is a reason to reach for `watch-video` instead, not a reason to skip the verbatim pass here.

**Requirements contract.** What this package needs, and what happens when it is missing:

| Requirement | Status | Missing -> |
|---|---|---|
| `${WV_FFMPEG}` / `${WV_FFPROBE}` | required | FATAL |
| `${WV_PYTHON}` | required | FATAL |
| `faster_whisper` (on `${WV_PYTHON}`) | REQUIRED, always | FATAL -- the verbatim transcript IS the transcript of record here, and there is no cheaper tier to fall back to |
| `ctranslate2` + CUDA device | preferred | WARN, fall back to CPU int8 (~20x slower) |
| GPU free VRAM >= 4.5 GB | preferred | WARN, wait for the card or use CPU |
| `${WV_YTDLP}` + `${WV_JS_RUNTIME}` | required for URL input | FATAL for URL runs |
| `${WV_WORK_DIR}` headroom | scales with `${WV_MAX_FPS}` | FATAL |

**The gate NEVER auto-installs, by design -- do not "helpfully" add that.** Two reasons: (1) you
may not have write access to `${WV_PYTHON}`'s site-packages -- it may be owned by another user or
a shared install; (2) `${WV_PYTHON}` may be an environment used for other work entirely (a
production pipeline, another project's dependencies) -- `pip install faster-whisper` pulls
ctranslate2, tokenizers and onnxruntime and can bump shared dependencies underneath work that has
nothing to do with this skill. Silently mutating an environment that runs something else, to save
one manual step on a video task, is the wrong trade. The gate prints the exact remedy command and
flags the blast radius so the alternative (a dedicated environment for transcription) stays
visible.

Note that the GPU path runs through **ctranslate2, not torch** -- a CPU-only torch build in the
same interpreter is fine and does not block float16 inference on the card. Do not "fix" the
torch build on the strength of a CPU tag.

## Step 0 -- Input resolution

Local path: verify it exists and `${WV_FFPROBE}` reads it.

URL (YouTube or anything yt-dlp supports): download with `${WV_YTDLP}` (if the system default python is too old
for the yt-dlp zipapp, point `${WV_YTDLP}` at `${WV_PYTHON} <path-to-zipapp>` instead):

```bash
# metadata first (report header + slug + duration budget):
${WV_YTDLP} --print "%(title)s|%(channel)s|%(upload_date)s|%(duration)s" --no-download "<url>"
# then the video, capped at 1080p (screen-content readability), merged to mp4:
${WV_YTDLP} --js-runtimes deno:${WV_JS_RUNTIME} \
  --extractor-args "youtube:player_client=tv,android,ios,web_embedded" \
  -f "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[ext=mp4]/b" --merge-output-format mp4 \
  -o "${WV_WORK_DIR}/<slug>.%(ext)s" "<url>"
# LAST, in a SEPARATE call that is allowed to fail: the platform caption track, ONE language.
# This is NOT a transcript and is never used as one -- Step 5 is the only thing that reads it.
${WV_YTDLP} --js-runtimes deno:${WV_JS_RUNTIME} \
  --extractor-args "youtube:player_client=tv,android,ios,web_embedded" \
  --skip-download --write-auto-subs --sub-langs "<lang>-orig" \
  -o "${WV_WORK_DIR}/<slug>_captions.%(ext)s" "<url>" \
  || echo "no caption track -- the Step 5 cross-check is unavailable for this run"
```

**NEVER bundle subtitles into the video call. Fetch them separately, ask for ONE track, and let
that call fail.** yt-dlp treats a subtitle download failure as FATAL to the whole invocation, so a
caption error aborts the VIDEO download bundled with it. Measured on 2026-08-29: `--sub-langs
"en.*,pt.*"` expanded to four tracks, the third returned `HTTP Error 429: Too Many Requests`, and
the run ended with no video and no captions -- twice, on two different sources, in the same
session. Split into its own invocation, a caption failure costs nothing but the captions, which is
why the `||` above is part of the command and not decoration. Pick the track from what yt-dlp lists
for the video (`--list-subs`) and prefer the `-orig` variant where one exists: it is the
original-language track rather than a machine translation of it, and a machine translation destroys
exactly the technical terms the cross-check exists to catch.

**What that file is, and what it is not.** `${WV_WORK_DIR}/<slug>_captions.<lang>.vtt` is a SECOND
ASR ENGINE'S READING of the same audio. It is not a transcript, not a tier, and not a fallback --
this package still runs whisper on every run (Step 4), and `<slug>_transcript.txt` is the only
transcript it has. The caption file has exactly one consumer, the cross-check in Step 5, and the
two names are deliberately different so nothing downstream can confuse them. If the fetch fails, if
the video publishes no captions, or if the input is a local file with no caption source at all, the
run proceeds unchanged and reports the cross-check as unavailable. This is an optional signal whose
absence is not a defect.

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

## Cleanup: one provenance rule

**Cleanup must also run when the run does NOT succeed.** Scratch is created EARLY -- frames land
long before any deliverable exists -- so a run that fails, errors, or is interrupted leaves all of
it behind. At 5 fps that is tens of gigabytes. Whenever a run ends
for ANY reason without reaching the normal clean step, invoke the helper directly:

```bash
bash cleanup.sh <slug>              # remove this run's scratch, verify, report
bash cleanup.sh <slug> --dry-run    # show what would go, remove nothing
bash cleanup.sh --stale 1 --force   # reap orphans from earlier runs older than a day
```

### HARD CLEANUP RULES (non-negotiable; added 2026-08-30)

On 2026-08-30, 8.5 GB of orphaned `*_frames` dirs from July-August runs of this skill family
were found in bare `/tmp` on a 97%-full disk. Cause: a config `work_dir` of bare `/tmp` plus
runs that never invoked the reaper. A run that violates any rule below is INCOMPLETE even if
every deliverable landed.

1. Scratch lives ONLY under `${WV_WORK_DIR}`, which MUST be a dedicated directory -- never bare
   `/tmp` and never a directory shared with anything else. Before extracting a single frame,
   print the resolved `WV_WORK_DIR` and refuse to proceed if it resolves to bare `/tmp` (or
   `$TMPDIR` itself). At this skill's frame rates the scratch is tens of gigabytes; a wrong
   work_dir is a disk incident, not a cosmetic issue.
2. The LAST action of EVERY run -- success, failure, or interruption alike -- is
   `bash cleanup.sh <slug>`, and the run's final report must state what was deleted and what
   remains. Scratch surviving a finished run is a defect to report, not a leftover to ignore.
3. The FIRST action of every run is `bash cleanup.sh --stale 1 --force`; the reaper also sweeps
   the legacy bare-/tmp location where pre-2026-08-30 runs left scratch.
4. Never deleted, ever: inputs the pipeline did not create (the provenance rule) and the final
   deliverables. Everything else this pipeline created is scratch and dies with the run.

It refuses an empty, short, or path-like slug rather than globbing the whole work directory,
verifies afterwards that nothing remains (a cleanup that silently failed reads exactly like one
that succeeded), and warns if a process is still running that could recreate what it just deleted.
`cleanup.sh` only ever touches scratch the pipeline created -- it never touches the output
directory, and never an input the pipeline did not create, which is the same provenance rule
stated below. Run `--stale` at the START of a session too: orphans from an earlier failed run are
otherwise invisible, and they are why a work directory quietly fills up.


**Never delete an input you did not create. There is no setting that overrides this.** The
pipeline deletes ONLY what it created: frames, contact sheets, bursts, extracted audio, scratch
scripts, and any video copy it downloaded itself. A local video handed to this skill as a path is
NOT deleted, ever -- the user may hold the only copy of something that cannot be remade, and this
package has no opt-in to destroy it. `--keep-video` additionally preserves a copy the pipeline
downloaded that would otherwise be deleted.

(A `WV_DELETE_SOURCE` opt-in used to exist here. It went with the forensics lens, whose input was a
recording you owned; a package that only ever downloads its own copies does not need it, and the
rule is strictly safer without it. `video-autopsy` carries that setting now, where the case for it
still applies.)

**Before deleting anything, VERIFY the deliverables actually exist in the output dir.** A clean
phase that runs after a failed write destroys the evidence and leaves the run unreproducible. The
exact list, and the exact scratch paths to delete, are in "FINAL CLEAN PHASE" at the end of this
file.

## Step 1 -- Probe + budget

`${WV_FFPROBE} -v error -show_entries format=duration -of csv=p=0 <video>` -- sanity-check
duration.

Disk headroom check BEFORE extracting -- `preflight.sh` already computed and printed the estimate
for your configured `${WV_MAX_FPS}` (see "Cost" above); confirm
`${WV_WORK_DIR}` has that much headroom before starting, and use `%06d` in the output pattern,
never `%04d` -- at 5 fps for 60 minutes that is 18,000 frames, which overflows a 4-digit counter
and silently truncates/overwrites.

## Step 2 -- Frame extraction

```bash
mkdir -p ${WV_WORK_DIR}/<slug>_frames
${WV_FFMPEG} -hide_banner -i <video> -vf "fps=${WV_MAX_FPS}" -q:v 3 ${WV_WORK_DIR}/<slug>_frames/f_%06d.jpg
```

Extract ONCE, at `${WV_MAX_FPS}`. Frame number maps to time as `f_NNNNNN` = second
`(NNNNNN - 1) / ${WV_MAX_FPS}`. Keep this mapping exact -- every later frame lookup depends on it,
and at a rate above 1 fps the frame number is NOT the second.

**Raise the rate above 5 where the content warrants it** -- live-coding segments, screen-share with
fast scrolling, or any moment where a meaningful visual transition would fall between samples.
Below 5 the resolver warns rather than clamping: a lower rate is permitted, but say so in the
report header and treat any claim about a briefly-shown artifact as possibly incomplete.

High-resolution video can decode slowly (roughly 2x-3x video duration for a 1 fps extraction pass
on modest hardware). Start frame extraction FIRST as a background task and do transcript work /
early frame reads on whatever is already extracted -- frames land in order, so later reading can
chase the extractor.

## Step 3 -- Audio extraction

```bash
${WV_FFMPEG} -hide_banner -i <video> -vn -acodec pcm_s16le -ar 16000 -ac 1 ${WV_WORK_DIR}/<slug>_audio.wav
```

**Sanity-check that the audio is actually there** before spending a whisper pass on it:

```bash
${WV_FFMPEG} -hide_banner -nostats -i <video> -af volumedetect -f null - 2>&1 | grep -E 'mean_volume|max_volume'
```

A file that plays fine can still carry a dead or near-silent track, and whisper will return a
short, plausible-looking transcript from it. State the result in the transcript header.

That is the whole audio step here. Multi-channel splitting, per-channel RMS, correlation-at-lag-0
and the dual-mono downmix question belong to talk-time analysis, which this package does not do --
they live in `video-autopsy`, which needs them because a half-captured conversation silently
inverts a talk-share number. A single narration track needs none of it.

## Step 4 -- Transcript: VERBATIM, always

**Run whisper. Every time.** There is no ladder in this package and no cheaper tier to try first.
The transcript of record is `${WV_WHISPER_MODEL}` (large-v3 by default), produced here, and it is
what every quote in the deliverables is taken from.

The reason is measured, not stylistic. On 2026-08-29, platform captions ran 6.5% short of verbatim
on an English source and only 1.0% short on a Portuguese one -- and the Portuguese track mangled
every product name in the video. **Low volume-loss does not mean safe to quote.** This package
exists to reconstruct and quote exact artifacts: library names, API names, commands, numbers,
configuration keys. Those are precisely what auto-captions destroy, and the damage does not show up
in a word count.

If reusing an existing transcript is good enough for what you need, that is `watch-video`, and it
does it well. Do not reproduce it here.

```python
from faster_whisper import WhisperModel
model = WhisperModel("${WV_WHISPER_MODEL}", device="${WV_WHISPER_DEVICE}",
                     compute_type="${WV_WHISPER_COMPUTE}")
segments, info = model.transcribe(
    "${WV_WORK_DIR}/<slug>_audio.wav",
    language="<the language actually spoken>",
    beam_size=5, vad_filter=True, condition_on_previous_text=True,
)
```

- **GPU is the DEFAULT, not an optimization to consider later.** On a 16-core desktop with an idle
  8 GB consumer GPU, `device="cuda", compute_type="float16"` is a MEASURED 20x improvement over
  CPU int8: three concurrent CPU jobs reached a load average of 22 on 16 cores and covered 87
  seconds of audio in 11 minutes of wall clock; the same three jobs re-run sequentially on GPU,
  one model load, finished in 285 seconds total. Check the GPU is idle (`nvidia-smi`) and use it.
  CPU int8 is documented ONLY as the fallback for when the GPU is busy or unavailable.
- **Sequential only, one model load, never in parallel.** `large-v3` float16 needs roughly 4.2 GB.
  Two concurrent jobs is a proven failure mode on GPU and far worse on CPU, where they thrash
  memory bandwidth and each drop to about 0.3x realtime.
- **Do NOT use the batched pipeline and do NOT use a distilled model.** `distil-large-v3` with
  batching is roughly 6x faster and is the right choice for the light sibling; it is the wrong
  choice here, because both trade exactly the verbatim fidelity and segment-timing precision this
  package's quotes depend on.
- **Preserve per-recording settings, especially `language`.** Not every video is in English, and a
  wrong language tag produces fluent, confident, wrong text.
- Label the transcript header `[source: faster-whisper ${WV_WHISPER_MODEL}, verbatim]`.

Audio extraction is Step 3 above. First use downloads the model (a gigabyte or two) to the local
model cache.

**Transcript quality gate.** Assess completeness before trusting it: full-duration coverage, no
long timestamp gaps, no repeated gibberish, no truncation, no silence in the transcript where the
frames show someone speaking. Complete and coherent -> proceed to the guided read.

**Recovery chain, if and only if the transcript came back degraded.** This is a repair path for a
bad whisper run, not a menu of cheaper alternatives to whisper:

1. **Re-run with tuned parameters**: `vad_parameters={"threshold": 0.3}`,
   `no_speech_threshold=0.4`, `condition_on_previous_text=True`, temperature fallback
   `[0.0, 0.2, 0.4, 0.6]`.
2. **Cut isolated bad spans and transcribe them alone**
   (`${WV_FFMPEG} -ss <start> -to <end>`), then splice the result back at its true offsets.
3. **LAST RESORT: OCR the transcript from frames.** The frame sequence often captures on-screen
   captions or shared-screen text. Read frames chronologically, deduplicate overlapping caption
   text across consecutive frames, and assemble a transcript with timestamps derived from frame
   number / fps. Label it `[OCR-from-frames]` and flag plainly that it is NOT verbatim -- captions
   never show exact wording -- so every quote taken from it is a paraphrase and must be marked as
   one.

Log which path was used, and why, in the saved transcript file header. While whisper runs, do the
blind visual sweep (below) -- do not sit idle.

## Blind visual sweep (transcript-independent)

Before (or while) reading the transcript, skim the base-rate frames at a coarse stride (every
30-60s; roughly 60-120 frame reads for an hour of video) to build a visual map: talking head vs
slides vs live demo vs code vs charts, and WHERE the visual-dense segments are. Two reasons: (a)
the transcript cannot flag visuals the speaker never verbalizes ("as you can see here"); (b) the
map tells you where the guided read will need frame work, so you pace it.

## Shared technique: contact-sheet tiling (batch-read frames in one Read call)

Tile multiple frames into one JPEG so a single `Read` covers 9 frames instead of one:

```bash
${WV_FFMPEG} -ss <t-N> -t <window> -i <video> -vf "fps=<rate>,scale=640:-1,tile=3x3" \
  -frames:v 1 ${WV_WORK_DIR}/<slug>_frames/sheet_<label>.jpg
```

The fps/window pair differs by situation (a coarse survey sheet and a dense burst sheet use
different parameters for different reasons) -- see the exact invocations in the three-tier
escalation further down. Only open individual full-res frames where the tiled sheet shows something
worth pixel-level reading.

## Shared technique: crop + LANCZOS upscale for on-screen text

Raw frames of an editor/terminal are often unreadable at native size. Crop the region of interest
and upscale ~2.5x with LANCZOS before reading. This is the technique that makes artifact
reconstruction possible at all: code, config, terminal output, slide bodies, chart axis labels and
legends are all routinely unreadable without it. Use it at every transition, not once.

## Background-task discipline

- **A subagent that spawns a detached job and then stops WILL NEVER WAKE UP.** Either block on
  transcription in the foreground or poll for its output file; a "waiting" agent does not resume
  itself. When orchestrating, watch the job yourself and message the agent when the artifact is
  ready.
- A waiter watching a PID fires when that PID is KILLED, which is a FALSE completion signal --
  prefer waiting on a sentinel string (e.g. `DONE`) written to the job's log at the end of the
  script.
- `pkill -f <pattern>` matches your OWN shell if the pattern appears in your command line -- kill
  by exact PID instead.
- One whisper job at a time on a given machine, run sequentially even on GPU (see Step 4 memory
  limit).
- Long videos (2h+): announce the whisper ETA up front, run it in background, and front-load the
  visual sweep so the wait is productive.

## Step 5 -- Caption cross-check (the transcript already exists before this step runs)

**This step cannot run until Step 4 has produced a transcript, and it produces no transcript of its
own.** That ordering is the whole defence: there is nothing here that could become the transcript
of record, so it cannot drift into being one. A caption span NEVER replaces a whisper span. Its
only power is to nominate a timestamp for the FRAMES to adjudicate.

**Why a second engine is worth a step.** Whisper is ASR too, and a single verbatim transcript is
not self-checking -- it mangles proper nouns in its own way and gives no signal when it does. A
cheap second reading of the same audio turns silent errors into visible DISAGREEMENTS, and a
disagreement is the cheapest frame trigger there is. Measured on 2026-08-30, running exactly the
procedure below against a 13-minute screencast; every row was then settled from pixels:

| What the screen showed | Captions heard | Verbatim whisper heard |
|---|---|---|
| `build-awwwards-quality-sites` | "Awards quality sites" | "awards quality sites" |
| `ConardLi/garden-skills` | "Connard Lee's Garden skill" | nothing -- 27s dropped |
| `elayadesign/ai-design-skills` | "Elia Design" | "EliaDesign" |
| `jakubkrehel/skills` | "Jakob Krehel" | "yakub krehl" |
| `emil-design-eng`, after Emil Kowalski | "the email design engineering skill" | "Emil design engineering" |
| Claude (the product the video is about) | "Claude" 21x, "cloud" 1x | "cloud" 12x, "Claude" 9x |

Three things that table shows which one transcript cannot. **The verbatim tier is not automatically
the more accurate one:** it rendered the product the whole video is about as "cloud" in 12 of 21
occurrences, which the captions got right 21 times out of 22 -- and an INCONSISTENT error is the
harder one to catch by eye, because the correct spelling is also present. A whisper-only run writes
that into the deliverable with nothing to flag it.
**Some terms neither engine gets:** both flattened "Awwwards" to "awards", so the disagreement list
is a floor and not a ceiling -- a name that matters is worth a frame check even when the two agree.
**A disagreement can mark a HOLE rather than a mistake:** the caption text between 03:28 and 03:55
had no whisper counterpart at all, because whisper dropped 27 seconds there -- which is exactly
where the repository was named.

Run it like this:

1. **Parse and de-duplicate the caption track.** A YouTube-style auto-caption file is a two-line
   scrolling window: each cue repeats the tail of the previous cue as its head, so naive
   concatenation duplicates nearly every word and the alignment below then reports garbage. Collapse
   on WORD-LEVEL OVERLAP against the running text, not on cues that "look similar":

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

   **Then check words-per-minute before using the result**, because this failure is silent and the
   duplicated text reads perfectly well line by line. Unhurried narration is roughly 120 wpm, fast
   presenters reach about 190, and sustained speech above ~250 wpm is not a fast speaker, it is a
   dedup that did not collapse. Measured on 2026-08-29, a `startswith`-based collapse left two
   sources at 439 and 441 wpm -- exactly 2x the 220 and 221 wpm the overlap rule produces.

2. **Align on TIME, not on text order.** For each caption span, take the whisper text covering the
   same seconds. The two engines segment differently, so never expect line-for-line correspondence.
   **A span with caption text and no verbatim text at all is a DROPOUT, not a word-level
   disagreement** -- name the range, treat everything said in it as unquotable, and go back to the
   Step 4 quality gate, which is the check that should have caught it. Measured on 2026-08-30: a
   27-second hole ran from 03:28 to 03:55 with a repeated-segment stutter immediately before it.

3. **Keep only disagreements that could change a fact**: a proper noun, a product or library name,
   an identifier, a command, a number, a unit, a URL. Discard the rest -- filler words,
   contractions, punctuation, capitalisation and segment boundaries always differ between engines,
   and none of them is a finding. A cross-check that reports wording noise buries the four items
   that matter.

4. **Send each survivor to the frames as a trigger**, with its timestamp, using the escalation and
   the crop + LANCZOS upscale defined below. On-screen text settles these: a slide, a terminal, a
   repository name, a lower-third, a URL bar.

5. **Record the outcome, right fact first.** These are the raw material of the Corrections section
   in the knowledge document. If the frames settle it, state the correct term and cite the frame. If
   the term was never on screen, say so explicitly, KEEP the whisper reading, and flag the term as
   unverified -- never silently adopt the caption reading. It is the weaker source and it can
   hallucinate an entire phrase for audio that contains nothing like it, which is precisely what the
   "Connard Lee's Garden skill" case was.

**When the cross-check is unavailable** -- a local file, a video with no published captions, or a
failed fetch -- say so in the deliverable headers and continue. Do not treat its absence as a
failed run, and do NOT manufacture a second opinion by re-running whisper with different settings:
two runs of the same model share the same failure modes, so they agree exactly where a genuine
second engine would disagree, which is worse than having no cross-check at all.

## The guided read (THE CORE mechanism)

Steps 0-4 only produce raw material: a pile of frames and a transcript. The run is not finished
without this interpretive pass -- it is where the analysis actually happens:

**Walk the entire transcript. Wherever the words alone do not settle what happened, go to the
frames for that timestamp. Where one frame does not settle it, escalate to a denser pass and read
until it does.**

A transcript cannot describe a diagram, a chart, a face, or what an editor actually contained --
it only records that someone referred to them. Treat every such reference as an instruction to go
and look. Be proactive about it: extracting an extra burst is cheap, and a finding asserted from
narration that the screen contradicts is expensive.

Lookup: second `t` -> `${WV_WORK_DIR}/<slug>_frames/f_{t*RATE+1:06d}.jpg` at the effective
extraction rate for this run. Both the transcript and the frames come from the same file here, so
there is no clock offset to calibrate -- the whisper timestamps and the frame numbers share one
time base. (That is not true when a transcript comes from a separate recording tool, which is why
`video-autopsy` carries an offset-calibration step and this package does not.)

**Three-tier frame escalation, in order.** Being proactive here is the job: if a moment might
carry a finding, cut the denser pass rather than guessing from one frame.

1. **Single frame** at the effective rate. Enough for "what app was foregrounded," "was a diagram
   up," "who is on screen."
2. **Reaction-arc sheet** -- 9 frames spanning ~12 seconds, one Read:
   ```bash
   ${WV_FFMPEG} -ss <t> -t 12 -i <video> -vf "fps=0.75,scale=640:-1,tile=3x3" \
     -frames:v 1 ${WV_WORK_DIR}/<slug>_frames/sheet_<mmss>.jpg
   ```
   This shows how a moment EVOLVED across ~12 seconds -- an expression building, a demo
   progressing, a chart being scrolled. Note what it is not: at one frame per 1.33 seconds it
   CANNOT catch a micro-expression, which lasts roughly 40-500 ms. Use it to locate the moment,
   then escalate.
3. **Dense burst** -- the tier that actually resolves a fleeting reaction, fast typing, or a quick
   demo:
   ```bash
   mkdir -p ${WV_WORK_DIR}/<slug>_frames/burst_<mmss>
   ${WV_FFMPEG} -hide_banner -ss <t-2> -t 4 -i <video> -vf "fps=15" -q:v 3 \
     ${WV_WORK_DIR}/<slug>_frames/burst_<mmss>/b_%03d.jpg
   ```
   4 seconds at 10 fps = 40 frames across t-2 to t+2 is the normal window here, since the target is
   a fast screen change (a command run, a value appearing, a slide transition) rather than a facial
   micro-expression. Densify to 15 fps only if the moment still does not settle.
   Tile them 3x3 to skim (`fps=3.75,scale=640:-1,tile=3x3`), then open individual frames where the
   sheet shows something worth pixel-level reading. Widen the window or raise the rate further if
   it still does not settle. For small on-screen text, crop and upscale ~2.5x with LANCZOS first
   (see the shared technique above).

**Reading a 3x3 contact sheet**: read left-to-right, top-to-bottom -- that is chronological order
for the tiled window. Small on-screen text inside a sheet tile is often illegible at 640px wide;
that is exactly when you escalate to the individual full-res frame and crop+LANCZOS it, rather
than guessing from the thumbnail.

**The bar is "I could re-explain what happened on screen," not "I glanced at it."** Keep running
notes as you go: moment, what the words claimed, what the screen showed, whether they agree.
Discrepancies between narration and screen are findings, not noise -- they go in the deliverable.
An honest "the frames cannot answer this" is a valid result; a confident reading of an illegible
crop is not.

## Triggers -- what sends you to the frames

The mechanism above is universal; this is the trigger list that invokes it. Escalate to the frames
whenever the transcript contains:

- **Deictic language**: "this", "here", "as you can see", "on the right", "this line", "like so".
  The referent is on screen and nowhere in the words.
- **Live demos**: code typed or run, terminal output, a UI walkthrough, a config being edited.
- **Diagrams, architecture slides, and charts**: boxes, tables, benchmark charts, formulas. If the
  transcript says a diagram is on screen, READ THE DIAGRAM -- do not paraphrase what the speaker
  said about it.
- **Numbers read aloud from a chart** -- verify the chart actually says that. A transposed digit or
  a misheard unit is a common failure mode.
- **Anything the blind visual sweep marked visual-dense**, even where the narration around it
  sounds self-contained. The sweep exists precisely to catch content the speaker never verbalises.
- **A claim about a result, a benchmark, or a number.** If the artifact is on screen, check the
  claim against it.
- **Every disagreement the Step 5 caption cross-check kept.** Those timestamps are already
  filtered down to terms that could change a fact, and the screen is the only thing that can settle
  which engine heard correctly.

**Reconstruct the artifact, then ANALYSE it.** This is the step that separates this package from a
transcript summary. If code is on screen, recover the implementation and review it: walk the edge
cases, check the complexity claims, look for defects, name the costs the presenter did not mention.
If it is a design or an argument, reconstruct it and test it the same way. Anchor every structural
claim to a frame timestamp -- that is what makes the report defensible where a summary is not.

**The bar:** every flagged moment is resolved or explicitly recorded as unresolved. Disagreements
between what was said and what was shown are the highest-value findings this package produces. An
honest "the frames cannot answer this" is a valid result; a confident reading of an illegible crop
is not.

## The HTML report: design direction

The HTML deliverable is a DIDACTIC PRESENTATION, not a formatted dump of the markdown. Its job is
to make one hard idea land with someone who has not seen the source. A page of stat tiles, section
cards and colour-coded callouts is a template, and it reads as one.

**Name three directions, pick one, and say why.** Before any CSS, write one line each for THREE
art directions this specific subject could support -- and name them concretely ("wire-bound field
notebook", "oscilloscope trace on grid paper", "1960s technical manual"), never as counts. Asking
yourself for "three versions" without naming them produces three of the same thing; the naming is
what forces them apart. Then choose one, in one sentence, on a reason drawn from the material. The
two you rejected cost you three lines and are the only reliable defence against reaching for the
house style by reflex.

**Lock the palette and the type scale AFTER the direction, never before.** A token set fixed up
front decides the page before the subject has had a say, and every page built that way comes out
the same. Choose the direction, build the signature element, and only then freeze the values into
`:root` custom properties so the rest of the page stays consistent with what you actually built.

**Ground the design in the subject.** Before writing any CSS, name the single idea the page exists
to teach, and design outward from the subject's own world -- its materials, artifacts, vocabulary.
A page about a data structure should look like that data structure; a page about an argument should
be shaped like the argument.

**Build one signature element that TEACHES.** Spend your boldness in exactly one place: a diagram,
a trace, a comparison, an interactive model that makes the central idea visible in a way prose
cannot. Everything else on the page stays quiet and disciplined so that element carries. If the
reader remembers one thing, it should be this.

**Let colour carry meaning, not decoration.** Assign each accent to a concept in the material and
use it for nothing else, so the palette itself is part of the explanation. Introduce it in a
legend. Do not colour things because they need colouring.

**Type is the biggest single lever, and offline is where it gets hard.** One decisive typographic
treatment does more to stop a page reading as machine-made than any other choice. But a
self-contained report cannot fetch a webfont, and the reader's machine is not yours -- a stack that
names a distinctive family first will silently substitute on half the machines that open it. So
pull the lever with what survives substitution: SCALE (a display size that is genuinely large, not
a timid 1.5x body), WEIGHT CONTRAST, TRACKING, MEASURE (~65 characters, not full-bleed text),
and CASE. Set a real stack with a generic family last (`Charter, "Bitstream Charter", Georgia,
serif`) rather than a bare `sans-serif`, and reserve a distinct face for data and labels so
numbers do not read as prose. If one specific face genuinely carries the direction, embed it
base64 in the file -- that is the only way to have it offline, and it costs you the font's weight
in page size and requires a licence that permits embedding. Decide that deliberately or not at
all.

**If there is motion, there is exactly one moment of it.** Scattered micro-interactions are the
tell that a page was assembled rather than designed. Animate transform and opacity only -- animating
layout properties is where the jank comes from -- and honour `prefers-reduced-motion` by removing
the motion, not by shortening it.

**Structural devices must encode something true.** Numbered sections only when the content really
is a sequence. An eyebrow, a divider or a label earns its place by carrying information.

**Self-contained**: inline CSS and JS, no CDNs, no webfont fetches (a report must render offline
years later). Responsive to mobile, visible keyboard focus, `prefers-reduced-motion` respected.

**The prose is half of it.** A page can be typeset well and still announce itself as machine-made
in the first sentence a reader lands on. Copy gives it away through: a promise so broad it would
fit any subject; no concrete evidence where a number, mechanism or example belongs; interchangeable
vocabulary ("leverage", "seamless", "journey", "unlock", "robust"); and the smooth
unrevised cadence of a first draft. The test that catches all four: **if a sentence would survive
being moved to a report about a different subject, it is not saying anything.** Cut it or make it
specific. This applies hardest to the headline, the standfirst, and section openers -- the places
a reader forms the impression.

**Then critique it by LOOKING at it.** Render and screenshot before delivering -- a picture is
worth a thousand tokens, and layout, contrast and spacing defects are close to invisible in
source. Read the screenshot against these dimensions and write a short, PRIORITISED fix list
naming the dimension for each item, rather than a general impression:

| Dimension | The question it answers |
|---|---|
| Hierarchy | Does the eye land on the one thing the page exists to teach, first? |
| Composition | Is the layout structural, or is it a stack of equal boxes? |
| Typography | Scale, measure, and rhythm -- or default sizes at default spacing? |
| Colour | Does every accent map to a concept, and is the legend honest? |
| Density | Is there real air, or uniform padding everywhere? |
| Craft | Alignment, optical spacing, edge cases at narrow widths |
| Originality | Would this page be recognisable as being about THIS subject with the words removed? |

Then fix what the list says and render again. One pass, not a scoring loop -- the point is to
catch what source review cannot see, not to converge on a number.

**The slop checklist -- run it against the screenshot, not the source.** These are the specific
marks of a machine-made page, and they are worth checking explicitly because each one is
individually defensible and only the COMBINATION is the tell:

- the default interface typeface at default sizes
- a violet-to-indigo gradient (or any gradient) standing in for "technical"
- a centred headline over a centred sub-line over a centred button
- three cards in a row because three is what the grid does, not because there are three things
- one border-radius applied to every card, button and module alike
- frosted glass / translucency used decoratively, carrying no information

An isolated one of these is a choice. Four of them together is the house style of every model on
the market, and the reader recognises the pattern before they read a word of what you wrote.

**Verifying an interactive state:** a headless screenshot runs synchronous page JS but captures
BEFORE any `setTimeout` fires, so a deferred click never happens and the default state is captured
instead -- which reads exactly like "the interaction is broken". Trigger the state SYNCHRONOUSLY at
parse time, in a throwaway copy of the file, never in the deliverable.

**Watch CSS selector specificity.** State classes that layer (selected + special + active) cancel
each other silently: a rule with two classes loses to one with three, and the visual contract the
legend promised is quietly broken. This is the single most common defect the screenshot pass
catches.


## Deliverables (BOTH, always: one for agents, one for humans)

Write both documents to `${WV_OUTPUT_DIR}/<slug>/` (slug = kebab-case of the video title,
date-prefixed, e.g. `2026-08-16_building-agents-with-mcp`). In chat give ONLY the paths plus a
<=2-line summary -- never paste report prose or markup into chat. Deliverables are full descriptive
prose. ASCII only. The transcript is always copied to the output dir as `<slug>_transcript.txt`.

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
  source's error second -- so an ingesting agent learns the correction, not the mistake. Every
  disagreement the Step 5 cross-check resolved from frames belongs here, written the same way: the
  correct term, then what was heard, then the frame that settled it. A disagreement the frames
  could NOT settle is still recorded, marked unverified, keeping the whisper reading.
- Structure: header (one source line: title/author/date/URL + topic tags, PLUS the transcript
  source line and the caption cross-check status -- "cross-check: N disagreements, M resolved from
  frames", or "cross-check: unavailable (local file input)" / "(no caption track published)")
  -> "Core thesis" (2-4 sentences) ->
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

There is NO report.md -- the only markdown deliverable is the knowledge doc.
Comprehensive review, sectioned:

- Header: title, channel/author, date, duration, URL, the frame rate the run used, the
  transcript line with its quality note (e.g. "transcript: faster-whisper large-v3, verbatim" or
  "transcript: [OCR-from-frames] -- degraded, quotes are paraphrases"), and the caption cross-check
  status -- how many disagreements it raised and how many the frames settled, or that it was
  unavailable and why. An unavailable cross-check is stated, not warned about: it is an optional
  signal, and the reader is entitled to know which of the two the page rests on.
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

The list above is the report's CONTENT contract. Its LOOK is decided by "The HTML report: design
direction" earlier in THIS file, which is the single source for it across the whole family -- work
it from there, choosing a direction for this specific source rather than reaching for a fixed
palette. (That pointer read `../SKILL.md` until 2026-08-30, from the era when lens files sat one
directory down and routed back up. There are no lens files and no directory to climb; a pointer to
a path that does not exist is how a reader concludes the design direction is missing and invents
one.)

Two content items that are easy to lose and that this package specifically owes the reader: the
transcript provenance (in the header, where it qualifies everything below it) and the ingest cost
(duration, frames read, bursts cut). Both are provenance, not decoration -- put them where a
reader deciding how much to trust the page will see them, which is near the top and near the
claims they qualify. They do NOT have to be stat tiles; a stat-tile row is the most template-like
way to render them, and the design direction exists to talk you out of it.

**A note on this file's own history.** Until 2026-08-29 this paragraph prescribed a fixed dark
palette (`#0d1117` page, `#161b22` cards, `#58a6ff` accent) plus a table of contents, section
cards, stat cards and colour-coded callouts. That instruction cancelled the design direction it
sits under -- the direction opens by saying a page of stat tiles and colour-coded callouts reads
as a template, and the paragraph then required exactly that, in the same colours, every time. Two
sources reviewed the same week (see the design-direction section) independently name a fixed token
set chosen before the subject as the specific cause of pages that all look alike. It was removed
rather than softened.

## FINAL CLEAN PHASE (mandatory last step)

**Cleanup must also run when the run does NOT succeed.** Frames land early and at 5 fps they are
tens of gigabytes. Whenever a run ends for ANY reason without reaching this step, invoke the helper
directly (see "Cleanup: one provenance rule" above for the flags).

**Before deleting anything, VERIFY the deliverables actually exist** in `${WV_OUTPUT_DIR}/<slug>/`:
`<slug>_knowledge.md`, `<slug>_report.html`, `<slug>_transcript.txt`. A clean phase that runs after
a failed write destroys the evidence and leaves the run unreproducible.

Then delete this run's scratch:

- `${WV_WORK_DIR}/<slug>_frames/` -- base frames, ALL `burst_*` subdirs, ALL `sheet_*.jpg` tiles
- `${WV_WORK_DIR}/<slug>_audio.wav` and any segment cuts made for spot-transcription
- downloaded video copies, INCLUDING partial/fragment files: `${WV_WORK_DIR}/<slug>*.mp4`,
  `.f<id>.mp4` / `.f<id>*.webm` stream fragments, `.temp.mp4`, `.part`
- the caption track fetched for the Step 5 cross-check:
  `${WV_WORK_DIR}/<slug>_captions*.vtt` (and `.srt`, if that is what the platform served)
- helper scripts: `${WV_WORK_DIR}/transcribe_<slug>.py` and any other scratch script for this run
- the raw whisper transcript in `${WV_WORK_DIR}` (the output-dir copy is the keeper)
- **render scratch from the critique pass**: the screenshot(s) you took of the HTML report, any
  cropped or split copies of them, and the throwaway copy of the page used to force an interactive
  state. The design direction REQUIRES rendering and screenshotting, so this scratch exists on
  every run that produces a report -- and it is the one category a slug glob misses if you named it
  anything other than `<slug>_shot*.png`. **Name every scratch file with the slug prefix** or the
  glob will not reach it.

In practice one glob covers the scratch surface --
`rm -rf ${WV_WORK_DIR}/<slug>* ${WV_WORK_DIR}/*_<slug>.py` -- provided the slug is unique; then
VERIFY with `ls ${WV_WORK_DIR}/<slug>* 2>&1` (expect "no such file") and `ls <output-dir>` (expect
exactly the three deliverables). Report the verification result.

**Exceptions:**
- `--keep-video`: keep the downloaded video file, delete everything else on the list.
- **NEVER delete a local video that was handed to this skill as a path.** It belongs to the reader
  or to a third party, not to this pipeline. Only copies the pipeline downloaded itself are
  scratch. This package has no setting that overrides that -- see the provenance rule above.
- Confirm no background task from the run is still alive (frame extractor, whisper):
  `pgrep -fa "<slug>|ffmpeg.*fps="` should come back empty before finishing.

## House rules (no exceptions)

- **ASCII only** -- never unicode arrows, checkmarks, box-drawing, or emoji anywhere (code,
  transcripts, deliverables, chat).
- Deliverable documents (`<slug>_knowledge.md`, `<slug>_report.html`) are full descriptive prose.
- `<slug>_transcript.txt` is always written to the output dir.
- In chat, give ONLY file paths plus a <=2-line summary of what changed -- never paste report
  markup or reproduce artifact prose into chat.
- **This package does no behavioural analysis.** No tonality, no diarization, no talk-time, no
  micro-expressions, no prosody. If the question is about the people in the recording rather than
  the material, that is `video-autopsy` -- route there rather than improvising a lighter version
  of it here.
- Confidence discipline: assert nothing as fact below high confidence. Below that, say what is
  uncertain and why. This applies to what gets WRITTEN into a deliverable, not just to chat.
