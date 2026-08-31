# watch-video

A Claude Code skill that watches a video (a local file or a URL), reads what is on screen
alongside the transcript, and produces a knowledge document plus a human-readable report.

## What it does

Point it at a video and it:
1. Resolves a transcript using a reuse-first ladder (see below) instead of always
   transcribing from scratch.
2. Extracts frames at a low base rate and does a guided read of the transcript, checking
   frames whenever the words alone do not carry the meaning (diagrams, live demos, numbers read
   off a chart, on-screen code).
3. Writes two deliverables to an output directory:
   - `<slug>_knowledge.md` -- an agent-ingestible, declarative summary with provenance tags
     (`[ON-SCREEN]` / `[STATED]` / `[WEAK]` / `[INFERRED]`) so a fresh assistant can be handed the
     file as context and come away knowing the content.
   - `<slug>_report.html` -- a dark-themed, human-readable review with an executive summary,
     structured walkthrough, key insights, and applicability notes.
4. Cleans up everything it created or downloaded, keeping only the two deliverables plus a
   copy of the transcript.

Trigger phrases: `/watch-video <path-or-url>`, "watch this video", "learn from this video", or
handing it the path or URL of a tutorial, talk, or conference recording.

## The transcript resolution ladder (the headline feature)

This skill does not transcribe by default -- it looks for a transcript that already exists
first, and only reaches for `faster-whisper` as a last resort. In order:

- **Tier A -- a transcript you supply.** Pass `--transcript <path>` (`.txt`, `.srt`, or `.vtt`).
  If given, this is used and whisper never runs.
- **Tier B -- a transcript sitting next to the video.** `<video-basename>.txt/.srt/.vtt/.json`
  next to the input file, or in the configured output directory from a prior run. Used
  automatically if found, and the run says so.
- **Tier C -- platform captions fetched with the video.** For URL input, `yt-dlp
  --write-auto-subs` grabs the platform's own auto-captions at essentially no extra cost. Parsed,
  deduplicated (auto-captions repeat a rolling window of the previous cue), and used, with an
  explicit note that auto-captions mangle technical terms -- garbled spans get checked against
  the frames.
- **Tier D -- `faster-whisper` transcription. LAST RESORT ONLY**, reached only if none of the
  above exist. Defaults to GPU (`device="cuda", compute_type="float16"`) when available, falling
  back to CPU `int8` (roughly 20x slower). Uses `distil-large-v3` (batched) for clean English
  narration, escalating to `large-v3` for non-English or hard audio. Runs one job at a time,
  never in parallel.

Every deliverable states which tier produced its transcript.

## Requirements

| Tool | Needed for | Missing behavior |
|---|---|---|
| `ffmpeg` / `ffprobe` | always | FATAL -- nothing runs without these |
| a python3 interpreter | parsing `.srt`/`.vtt` files, and (last resort) running whisper | FATAL only if this run actually needs it -- a plain `.txt` transcript supplied via `--transcript` needs neither |
| `faster-whisper` (python package) | Tier D transcription ONLY | **OPTIONAL if a transcript already exists.** Not required at all when `--transcript` is supplied; WARN (not fatal) when no transcript is supplied but the run is a `--url` run, since platform captions can still carry it; FATAL only when the input is a local file with no supplied transcript and no caption source |
| `ctranslate2` + a CUDA-capable GPU | fast Tier D transcription | WARN -- falls back to CPU, roughly 20x slower |
| `yt-dlp` + a JS runtime (deno or node) | URL input only | FATAL for URL runs, irrelevant for local files |
| free disk on the working directory | frame (and, if Tier D runs, audio) scratch space | FATAL if too little headroom |

**Whisper is optional infrastructure here, not a hard dependency.** If your videos always come
with captions or you always supply your own transcript, you can use this skill fully without
`faster-whisper` installed at all.

None of this is installed for you. See "No auto-install policy" below.

## Install

Drop this directory (or a clone of it) into your skills location, for example:

```
~/.claude/skills/watch-video/
```

or wherever your Claude Code plugin/skill directory convention points. The skill is
self-contained: `SKILL.md` describes the whole workflow in one file (there is no `references/`
directory -- with only one analysis mode, everything fits in the skill body), and
`preflight.sh` + `lib/config.sh` handle configuration and dependency checks. Nothing here assumes
a particular installation path -- `preflight.sh` locates its own `lib/config.sh` relative to
itself, so the directory can be copied or symlinked anywhere.

No build step, no package manager step for the shell layer itself. The only thing you may need to
install is the python package `faster-whisper` (see below, and only if you expect to hit Tier D),
and optionally `yt-dlp` and a JS runtime if you plan to feed it URLs.

## Configuration

Every setting is resolved through the same four-step order, checked in order, **first hit
wins**:

1. **Environment variable** (e.g. `WV_PYTHON=/opt/venv/bin/python3`)
2. **Config file key** (e.g. `"python"` in a JSON config file)
3. **Auto-detection** (probe the machine: `command -v`, python imports, GPU tooling)
4. **Documented default** (a plain, always-safe fallback)

Nothing here requires a config file to exist. A freshly downloaded copy of this skill with zero
configuration will still run: every value falls through auto-detection and then defaults.

### Config file location

The first of these that exists on disk is used; none is required:

1. `$WV_CONFIG` (an explicit path you set)
2. `./.watch-video.json` (project-local, current working directory)
3. `${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json` (user-global)

**This is the same config file location and key namespace used by the heavier sibling package,
`watch-video-max`.** If you install both, one config file configures both -- this package simply
never reads the sibling's forensics-only keys (`recordings_dir`, `transcript_dir`,
`forensics_fps`, `forensics_delete_source`); if they happen to be present, they are
silently ignored.

Copy `config.example.json` to one of those locations and edit only the keys you want to pin.
JSON has no comment syntax, so the example file carries a `"_comment_<key>"` sibling next to
every real key explaining it -- delete those once you no longer need the explanation.

No `jq` install is required to use a config file: the resolver tries `jq` if it is present on
`PATH`, and otherwise falls back to a small python one-liner run via whatever `python3`/`python`
it finds on `PATH` (deliberately NOT the resolved `WV_PYTHON`, since the config file can itself
set that value). If neither `jq` nor any python is available, the config file is simply skipped
and resolution continues through auto-detection and defaults -- a soft degrade, never a hard
failure.

### Resolution table

| env var | json key | auto-detect | default |
|---|---|---|---|
| `WV_PYTHON` | `python` | first `python3` on `PATH` (then `$CONDA_PREFIX/bin/python3`, then common conda/venv locations) that can `import faster_whisper` | `python3` |
| `WV_FFMPEG` | `ffmpeg` | `command -v ffmpeg` | `ffmpeg` |
| `WV_FFPROBE` | `ffprobe` | `command -v ffprobe` | `ffprobe` |
| `WV_YTDLP` | `ytdlp` | `command -v yt-dlp`, else `<python> -m yt_dlp` if importable | `yt-dlp` |
| `WV_JS_RUNTIME` | `js_runtime` | `command -v deno`, then `command -v node` | (empty -- the yt-dlp `--js-runtimes` flag is omitted) |
| `WV_WORK_DIR` | `work_dir` | -- | `${TMPDIR:-/tmp}/watch-video` |
| `WV_OUTPUT_DIR` | `output_dir` | -- | `$HOME/watch-video/reports` |
| `WV_WHISPER_MODEL` | `whisper_model` | -- | `large-v3` |
| `WV_WHISPER_DEVICE` | `whisper_device` | `cuda` if `ctranslate2` reports >= 1 CUDA device, else `cpu` | `auto` |
| `WV_WHISPER_COMPUTE` | `whisper_compute` | `float16` on cuda, `int8` on cpu | `auto` |
| `WV_KNOWLEDGE_FPS` | `knowledge_fps` | -- | `1` |

### Seeing what got resolved

Source the config layer and dump it:

```bash
source lib/config.sh
wv_config_dump
```

This prints every `WV_*` variable, its resolved value, and which of the four sources produced it
(`env`, `config`, `detect`, or `default`). `preflight.sh` prints this table automatically before
running its checks.

## First run

1. Make sure `ffmpeg` is installed and on `PATH` (`ffmpeg -version` should work).
2. Run the preflight gate before doing anything else:
   ```bash
   bash preflight.sh                              # local file input, default fps
   bash preflight.sh --url                         # URL input (checks yt-dlp + a JS runtime too)
   bash preflight.sh --transcript /path/to/t.srt   # you already have a transcript in hand
   ```
3. Read the printed configuration table. If a path looks wrong (wrong python, wrong work
   directory), either export the matching `WV_*` environment variable or write a small config
   file (`.watch-video.json` next to where you run the command is the quickest option) and
   re-run preflight.
4. Resolve any `FAIL` lines -- the script prints the exact remedy command for each one. `WARN`
   lines do not block you, but read them: they usually mean a slower fallback path is about to
   be used (CPU transcription instead of GPU, a caption tier instead of a supplied transcript,
   etc.).
5. Once preflight exits 0, follow `SKILL.md` for the full workflow: input resolution, the
   transcript resolution ladder, the guided read, the two deliverables, and the mandatory
   cleanup phase.

If you already have a transcript for the video, pass it with `--transcript` at preflight time (and
again when actually invoking the skill) -- this is the single biggest thing that changes what
preflight requires, since it removes the whisper/GPU/CPU questions from the picture entirely.

## No auto-install policy (and why)

`preflight.sh` never installs anything on your behalf. When a package is missing, it prints the
exact command to run yourself, using whichever python interpreter it actually resolved, for
example:

```
/usr/bin/python3 -m pip install faster-whisper
```

Two reasons this is a deliberate design choice, not an oversight:

1. **The resolved interpreter is often not yours to freely mutate.** It might be a system
   Python, a shared virtual environment, or an interpreter used by other, unrelated projects.
   Silently running `pip install` into it can shift dependency versions underneath work that has
   nothing to do with this skill. `faster-whisper` in particular pulls in `ctranslate2`,
   `tokenizers`, and `onnxruntime`, any of which can bump other installed packages.
2. **A failed auto-install is a worse failure mode than a printed remedy.** If the resolved
   interpreter is not writable by the current user, an automatic install attempt just adds a
   second, more confusing error on top of the first. Printing the command and stopping keeps the
   failure legible.

If the remedy command targets an interpreter you would rather not touch directly, create a
dedicated virtual environment for transcription and point `WV_PYTHON` (or the `python` config
key) at it instead:

```bash
python3 -m venv ~/.venvs/watch-video
~/.venvs/watch-video/bin/pip install faster-whisper yt-dlp
export WV_PYTHON=~/.venvs/watch-video/bin/python3
```

Remember: this only matters at all if you expect to hit Tier D. If your videos always have
captions or you always bring your own transcript, you may never need to install
`faster-whisper`.

## Troubleshooting

**"ffmpeg not found" / "ffprobe not found"** -- install ffmpeg from your package manager
(`apt install ffmpeg`, `brew install ffmpeg`, etc.) or point `WV_FFMPEG` / `WV_FFPROBE` at an
existing install.

**"python interpreter not runnable"** -- the resolved `WV_PYTHON` value is not executable on this
machine. If you supplied a plain-text transcript via `--transcript`, this is only a warning, not
a stop -- python is not needed for that path. Otherwise check `wv_config_dump` to see what was
resolved and from where, then either fix that path or set `WV_PYTHON` explicitly.

**faster_whisper WARN on a `--url` run** -- the run can still finish on Tier C platform captions
alone, but only if the source actually has a usable caption track. If it does not, install
`faster-whisper` using the printed remedy command, or supply a transcript with `--transcript`.

**faster_whisper FAIL on a local-file run** -- this means no `--transcript` was supplied and there
is no caption source (local files have none). If the video actually has a sidecar transcript
file next to it, pass it explicitly with `--transcript` to sidestep this entirely. Otherwise,
install `faster-whisper` using the printed remedy command.

**ctranslate2 reports 0 CUDA devices, or `nvidia-smi` is not found** -- both are warnings, and
only matter if Tier D actually runs. Transcription falls back to CPU `int8`, roughly 20x slower
than GPU `float16` -- budget accordingly. Expected and not a bug on machines with no NVIDIA GPU
(Apple Silicon, AMD GPUs, cloud CPU-only instances).

**yt-dlp / JS runtime FAIL, but only when I pass `--url`** -- intentional: local-file runs never
need yt-dlp or a JS runtime, regardless of which transcript tier applies. Install `yt-dlp`
(`pip install yt-dlp` with your resolved python, or grab the standalone binary from its release
page) and a JS runtime (deno or node) -- recent YouTube extraction is unreliable without one.

**"work_dir has only N MiB free"** -- the estimate scales with the configured fps for a
60-minute source (roughly 3 GB at the default 1 fps). Free up space, point `WV_WORK_DIR` (or the
`work_dir` config key) at a larger volume, or lower the configured fps.

**A config file value does not seem to be taking effect** -- environment variables always beat
the config file. Check whether the matching `WV_*` variable is set in your shell (`env | grep
^WV_`) and unset it if you meant the config file to win. Also confirm which config file was
actually found: `wv_config_dump` prints the exact path, or reports none was found.

**I have `jq` installed but the config file still is not being read** -- confirm the file is
valid JSON (a trailing comma or an unescaped quote will make both `jq` and the python fallback
silently treat the file as unreadable, which degrades to auto-detect/default rather than raising
an error). Validate with `jq . your-config.json` directly.

## When to use a sibling package instead

This package is deliberately narrow: it understands a video's content, reuses an existing
transcript whenever it can, and does not touch audio prosody or behavior at all. Two heavier
siblings cover what it leaves out:

- **`watch-video-max`** -- same question ("what does this video teach me") at full depth: always
  a verbatim whisper transcript, a high frame rate, and reconstruction of what was actually on
  screen rather than a summary of what was said about it. Use it when transcript reuse is not
  good enough and the material deserves a proper study.
- **`video-autopsy`** -- behavioural and technical forensics on a recording of people talking
  and/or sharing a screen (meetings, panels, podcasts, interviews, pair-programming sessions):
  talk-share and turn-taking, silence and pace per phase, prosody, micro-expression bursts, and
  live-coding screen forensics. Use it when the question is about the people or the working
  session rather than the material.

If you are not sure which you need: "what does this video teach me" is `watch-video` (or
`watch-video-max` if it deserves full depth); "how did the people in this recording perform,
sound, or behave" is `video-autopsy`.
