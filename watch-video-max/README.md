# watch-video-max

A Claude Code skill for the deep study of one video: always a verbatim transcript, always a high
frame rate, and reconstruction of what was actually on screen -- then an analysis of the material
itself rather than a summary of the narration.

## What it does

Point it at a video (a local file or a URL) and it produces:

- `<slug>_knowledge.md` -- an agent-ingestible, declarative knowledge document with provenance
  tags (what came from the transcript vs. the on-screen pixels vs. inference). Written so it can
  be handed to a fresh agent as context.
- `<slug>_report.html` -- the human-facing document.
- `<slug>_transcript.txt` -- the verbatim transcript of record.

The pipeline: probe, extract frames ONCE at `max_fps` (default 5), extract audio, transcribe
verbatim with faster-whisper, do a blind visual sweep, cross-check the platform caption track
against the verbatim transcript on URL inputs, then walk the entire transcript with a guided read
that escalates to the frames wherever the words alone do not settle what happened --
reconstructing on-screen code, diagrams, charts and configs with crop-and-upscale and ANALYSING
them.

The caption cross-check is not a transcript source and cannot become one: it runs after the
verbatim transcript already exists, and its only output is a list of timestamps where two ASR
engines heard different proper nouns, numbers or commands -- which the frames then settle. That is
where the Corrections section in the knowledge document comes from. On a local file, or a video
with no published captions, the run says the cross-check was unavailable and continues.

Trigger phrases: `/watch-video-max <path-or-url>`, "study this video properly", "go deep on this
video", "I need to actually learn this one". The trigger alone runs the full treatment: there is
exactly one depth, it is the deepest available, and the skill does not ask for confirmation first.

See `SKILL.md` -- it is the single source for the whole pipeline. There are no reference files.

### Which of the three packages is this

- **`watch-video`** -- the cheap path. Its headline is transcript REUSE: a transcript you supply,
  a sidecar beside the video, or platform captions, with whisper only as a last resort. Use it
  when a transcript already exists and reusing it is good enough.
- **`watch-video-max`** (this one) -- the deep path. Always verbatim, always high fps, artifact
  reconstruction. Use it when the screen matters and exact quotes matter.
- **`video-autopsy`** -- the behavioural/technical path. Talk-share and turn-taking, silence and
  pace per phase, prosody, micro-expression bursts, live-coding screen forensics, on any recording
  of people talking and/or sharing a screen. Use it when the question is about the PEOPLE or the
  WORKING SESSION rather than the material.

### What changed on 2026-08-30

This package used to run one ingest under two selectable lenses, KNOWLEDGE and FORENSICS, and
carried a four-tier transcript ladder that treated whisper as a last resort. **The forensics lens
moved out whole into `video-autopsy`** -- it did not shrink, and every recording it covered is
still covered. **The transcript ladder went with it**, because a package whose positioning is
"always verbatim" cannot also ship an ordered list that puts whisper fourth: the list is the
concrete instruction and it is what actually gets followed. The ladder still exists, in full, in
`watch-video`. `--knowledge`, `--forensics` and `--transcript` are now refused by `preflight.sh`
with a pointer to the right package.

Later the same day, the caption FETCH came back -- as a cross-check artifact, not as a tier.
Removing the ladder had also removed the only second reading of the audio this package had, and
with it the disagreement signal that produced its Corrections sections. Captions are fetched again
in a separate, allowed-to-fail yt-dlp call and are read at exactly one place, after the verbatim
transcript exists. They are never quoted and never substituted for it.

## Requirements

| Tool | Needed for | Missing behavior |
|---|---|---|
| `ffmpeg` / `ffprobe` | always | FATAL -- nothing runs without these |
| a python3 interpreter | always | FATAL |
| `faster-whisper` (python package) | transcription | FATAL always -- this package has no caption tier and no supplied-transcript tier to fall back to |
| `ctranslate2` + a CUDA-capable GPU | fast transcription | WARN -- falls back to CPU, roughly 20x slower |
| `yt-dlp` + a JS runtime (deno or node) | URL input only | FATAL for URL runs, irrelevant for local files |
| free disk on the working directory | frame/audio scratch space, scaled to `max_fps` | FATAL if too little headroom |

None of this is installed for you. See "No auto-install policy" below.

## Install

Drop this directory (or a clone of it) into your skills location, for example:

```
~/.claude/skills/watch-video-max/
```

or wherever your Claude Code plugin/skill directory convention points. The skill is
self-contained: `SKILL.md` describes the whole workflow, and `preflight.sh` +
`lib/config.sh` handle configuration and dependency checks. Nothing here assumes a particular
installation path -- `preflight.sh` locates its own `lib/config.sh` relative to itself, so the
directory can be copied or symlinked anywhere.

No build step, no package manager step for the shell layer itself. The only thing you may need
to install is the python package `faster-whisper` (see below), and optionally `yt-dlp` and a JS
runtime if you plan to feed it URLs.

## Configuration

Every setting the skill needs is resolved through the same four-step order, checked in order,
**first hit wins**:

1. **Environment variable** (e.g. `WV_PYTHON=/opt/venv/bin/python3`)
2. **Config file key** (e.g. `"python"` in a JSON config file)
3. **Auto-detection** (probe the machine: `command -v`, python imports, GPU tooling)
4. **Documented default** (a plain, always-safe fallback)

Nothing here requires a config file to exist. A freshly downloaded copy of this skill with zero
configuration will still run: every value falls through auto-detection and then defaults. A
config file exists only to let you pin something auto-detection would otherwise guess (or guess
slowly, e.g. scanning for a python interpreter with the right packages installed).

### Config file location

The first of these that exists on disk is used; none is required:

1. `$WV_CONFIG` (an explicit path you set)
2. `./.watch-video.json` (project-local, current working directory)
3. `${XDG_CONFIG_HOME:-$HOME/.config}/watch-video/config.json` (user-global)

This search order is shared with the sibling skill "watch-video" -- both packages read the same
config file, so values you pin once apply to both. Unknown keys in a shared config file are
ignored silently by whichever package does not use them -- never an error.

Copy `config.example.json` to one of those locations and edit only the keys you want to pin.
JSON has no comment syntax, so the example file carries a `"_comment_<key>"` sibling next to
every real key explaining it -- delete those once you no longer need the explanation.

No `jq` install is required to use a config file: the resolver tries `jq` if it is present on
`PATH`, and otherwise falls back to a small python one-liner run via whatever `python3`/`python`
it finds on `PATH` (deliberately NOT the resolved `WV_PYTHON`, since the config file can itself
set that value -- using the resolved interpreter to parse the file that configures it would be
circular). If neither `jq` nor any python is available, the config file is simply skipped and
resolution continues through auto-detection and defaults -- this is a soft degrade, never a hard
failure.

### Resolution table

| env var | json key | auto-detect | default |
|---|---|---|---|
| `WV_PYTHON` | `python` | first `python3` on `PATH` (then `$CONDA_PREFIX/bin/python3`, then common conda/venv locations) that can `import faster_whisper` | `python3` |
| `WV_FFMPEG` | `ffmpeg` | `command -v ffmpeg` | `ffmpeg` |
| `WV_FFPROBE` | `ffprobe` | `command -v ffprobe` | `ffprobe` |
| `WV_YTDLP` | `ytdlp` | `command -v yt-dlp`, else `<python> -m yt_dlp` if importable | `yt-dlp` |
| `WV_JS_RUNTIME` | `js_runtime` | `command -v deno`, then `command -v node` | (empty -- the yt-dlp `--js-runtimes` flag is omitted) |
| `WV_WORK_DIR` | `work_dir` | -- | `${TMPDIR:-/tmp}` |
| `WV_OUTPUT_DIR` | `output_dir` | -- | `$HOME/watch-video-max/reports` |
| `WV_WHISPER_MODEL` | `whisper_model` | -- | `large-v3` |
| `WV_WHISPER_DEVICE` | `whisper_device` | `cuda` if `ctranslate2` reports >= 1 CUDA device, else `cpu` | `auto` |
| `WV_WHISPER_COMPUTE` | `whisper_compute` | `float16` on cuda, `int8` on cpu | `auto` |
| `WV_MAX_FPS` | `max_fps` | -- | `5` |

`max_fps` is named that, and not `knowledge_fps`, on purpose: `knowledge_fps` belongs to
`watch-video`, which legitimately wants 1 fps. Sharing one key would force both packages to the
same rate in a shared family config file and silently drop this one to the cheap default. A
`recordings_dir` / `transcript_dir` / `delete_source` key left over in a shared config from the
forensics era is ignored here without warning -- `video-autopsy` reads those now.

### Seeing what got resolved

Source the config layer and dump it:

```bash
source lib/config.sh
wv_config_dump
```

This prints every `WV_*` variable, its resolved value, and which of the four sources produced it
(`env`, `config`, `detect`, or `default`). `preflight.sh` prints this table automatically before
running its checks -- it is the transparency surface for "what did the skill decide about my
machine," and it is the first thing to look at when something behaves differently than expected.

## First run

1. Make sure `ffmpeg` is installed and on `PATH` (`ffmpeg -version` should work).
2. Run the preflight gate before doing anything else:
   ```bash
   bash preflight.sh
   # or, for a URL input:
   bash preflight.sh --url
   # denser pass for a fast screen-share, this run only:
   bash preflight.sh --fps 10
   ```
3. Read the printed configuration table. If a path looks wrong (wrong python, wrong work
   directory), either export the matching `WV_*` environment variable or write a small config
   file (`.watch-video.json` next to where you run the command is the quickest option) and
   re-run preflight.
4. Resolve any `FAIL` lines -- the script prints the exact remedy command for each one. `WARN`
   lines do not block you, but read them: they usually mean a slower path is about to be used (CPU
   transcription instead of GPU, for instance). There is no warning that downgrades the transcript
   itself: this package has no cheaper transcript path to fall back to.
5. Once preflight exits 0, follow `SKILL.md` start to finish. It is the whole pipeline.

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
python3 -m venv ~/.venvs/watch-video-max
~/.venvs/watch-video-max/bin/pip install faster-whisper yt-dlp
export WV_PYTHON=~/.venvs/watch-video-max/bin/python3
```

## Troubleshooting

**"ffmpeg not found" / "ffprobe not found"** -- install ffmpeg from your package manager
(`apt install ffmpeg`, `brew install ffmpeg`, etc.) or point `WV_FFMPEG` / `WV_FFPROBE` at an
existing install.

**"python interpreter not runnable"** -- the resolved `WV_PYTHON` value is not executable on this
machine. Check `wv_config_dump` to see what was resolved and from where, then either fix that
path or set `WV_PYTHON` explicitly.

**faster_whisper FAIL** -- not optional here; install it using the printed remedy command before
continuing. This package always transcribes verbatim and has nothing to fall back to. If what you
actually wanted was to reuse a transcript you already have, that is the sibling package
`watch-video`, which is built around exactly that.

**`preflight.sh` refuses `--knowledge`, `--forensics` or `--transcript`** -- those flags were
removed on 2026-08-30 and the gate names the package to use instead. See "What changed" above.

**ctranslate2 reports 0 CUDA devices, or `nvidia-smi` is not found** -- both are warnings, not
failures. Transcription runs on CPU with `int8` compute instead of GPU `float16`, which is
roughly 20x slower for the same audio -- budget accordingly. This is expected and not a bug on machines with no NVIDIA GPU (Apple
Silicon, AMD GPUs, cloud CPU-only instances).

**yt-dlp / JS runtime FAIL, but only when I pass `--url`** -- this is intentional: local-file runs
never need yt-dlp or a JS runtime. Install `yt-dlp` (`pip install yt-dlp` with your resolved
python, or grab the standalone binary from its release page) and a JS runtime (deno or node) --
recent YouTube extraction is unreliable without one.

**"work_dir has only N MiB free"** -- the estimate scales linearly with `max_fps` for a
60-minute source: roughly 12000 MiB at the default 5 fps, 24000 MiB at 10, 4800 MiB at 2. Free up
space, point `WV_WORK_DIR` (or the `work_dir` config key) at a larger volume, or lower the
configured fps. Below 5 fps the config layer warns on stderr rather than clamping: a lower rate is
allowed, but briefly-shown on-screen artifacts may fall between samples and never be captured.

**A config file value does not seem to be taking effect** -- environment variables always beat
the config file. Check whether the matching `WV_*` variable is set in your shell (`env | grep
^WV_`) and unset it if you meant the config file to win. Also confirm which config file was
actually found: `wv_config_dump` prints the exact path, or reports none was found.

**I have `jq` installed but the config file still is not being read** -- confirm the file is
valid JSON (a trailing comma or an unescaped quote will make both `jq` and the python fallback
silently treat the file as unreadable, which degrades to auto-detect/default rather than
raising an error). Validate with `jq . your-config.json` directly.

## When to use a sibling package instead

**`watch-video`** -- when a transcript already exists (you have one, there is a sidecar beside the
video, or the platform has captions) and reusing it is good enough. It defaults to 1 fps and
treats whisper as a last resort, so it is dramatically cheaper. Reach for it for a talk you want
the gist of. Reach for THIS package when the on-screen artifacts are load-bearing and exact
quotes matter -- captions measured 6.5% short of verbatim on one English source and mangled every
product name on a Portuguese one, which is precisely the damage a word count cannot see. That this
package also fetches captions is not the same thing: here they are only ever compared against the
verbatim transcript, never read out of it.

**`video-autopsy`** -- when the question is about the people in the recording or the working
session itself rather than the material: talk-share and turn-taking, silence and pace per phase,
prosody, micro-expression bursts, live-coding screen forensics. This package does none of that,
deliberately, and will not improvise a lighter version of it.
