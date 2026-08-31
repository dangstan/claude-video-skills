# DeepSeek Harness vs Claude Code: the same model, two harnesses, measured

**Source:** "100 Hours Testing DeepSeek Harness vs Claude Code" -- YouTube, published 2026-08-23,
18m02s, https://youtu.be/UsfCe5fJK6A
**Topic tags:** agent harness, DeepSeek Harness, Claude Code, plugin architecture, runtime modes,
verification, trajectory logging, cost-to-completion, harness benchmarking
**Transcript source:** faster-whisper large-v3, verbatim, 5,480 words. Frames at 5 fps (5,408).
**Caption cross-check:** run; no fact-level disagreement survived.
**Provenance tags:** `[ON-SCREEN]` read from pixels | `[STATED]` narrator claim from his own testing
| `[MEASURED]` a side-by-side run he performed and showed | `[INFERRED]` this document's synthesis.

## Core thesis

This is the only video in the batch that runs the experiment the rest of them imply: it holds the
model fixed and varies the harness. The result is that the harness materially changes speed, output
shape, confidence calibration and what the system is even capable of attempting -- with the same
weights underneath. DeepSeek Harness is dramatically faster and infinitely more customisable;
Claude Code produces work the tester trusts more. The deciding difference is not intelligence, it is
that one harness can look at what it made and the other cannot.

## Concept 1: what DeepSeek Harness is

`[STATED]` A harness is the wrapper: Codex is a harness whose native models are GPT-5.6 variants;
Claude Code is a harness whose native models are Claude; DeepSeek Harness is a harness whose native
models are DeepSeek V4 Flash and V4 Pro. OpenClaw and Hermes Agent are also agent harnesses. "It's
not groundbreaking new tech, it's just a new harness."

**What makes this one different** `[STATED]` `[ON-SCREEN]`: it is open source and free, and
**everything is a plugin** -- not just skills and MCP servers, but every capability: tools, skills,
sessions, sandboxes, storage, **loops**, and the UI.

**The analogy he uses, which is the clearest framing of the closed/open harness split** `[STATED]`:
a closed harness like Claude Code has prompting rules, tool calls, loops and an agentic harness you
cannot touch -- "a car we can sit in, we can drive it, we can change out the model of the engine,
but we can't move things around". With the open harness "we can switch out the seats, we can switch
out the steering wheel... we can change the way the agent actually behaves under the hood".

`[INFERRED]` That is the precise boundary. Both harnesses let you swap the model. Only one lets you
swap the loop. Since the loop is where verification lives, an open harness is the only place a user
can add verification the vendor did not ship -- and, equally, the only place a user can remove
verification the vendor did ship.

## Concept 2: setup and billing

`[STATED]` `[ON-SCREEN]` Installation was itself delegated: he handed an agent the GitHub link and
said "help me set this up". It runs on localhost with a chatbot-style UI, projects on the left,
sessions manageable. Then Settings -> Models -> add a key; he used an OpenRouter key, which exposes
every model OpenRouter serves.

**The billing constraint, stated twice** `[STATED]`: **you cannot use a Claude or Codex
subscription by default.** It is API billing, per token. He has seen plugins claiming to enable
subscription use and has not tested them.

`[INFERRED]` This is the single most consequential practical fact in the video and it inverts the
"free harness" framing. The harness is free; the inference is not, and it is billed at the API rate
rather than absorbed by a flat subscription. For anyone whose current spend is a fixed monthly fee,
switching to this harness converts a fixed cost into a variable one.

## Concept 3: the four runtime modes

`[ON-SCREEN]` Selectable before a prompt:

| Mode | What it is | What he uses it for |
|---|---|---|
| **standard** | Full coding agent -- file editing, shell, file operations, web search | Most of the time |
| **PTC** | Parallel/multi-chain execution. He compares it to Claude Code's dynamic workflows -- "not exactly that" | A big task with a lot to run in parallel |
| **minimal** | A two-tool coding agent with persistent bash | Quick one-off tasks; "fast, feels cheap" |
| **creator** | Adds the ability to author plugins, build custom agent presets and change the UI from inside the app | Modifying the harness itself |

**The measured difference between standard and minimal** `[MEASURED]` `[ON-SCREEN]`. Same prompt,
"hi, who am I?":
- **standard** immediately performs a context injection: reads `AGENTS.md`, `CLAUDE.md` and
  `CLAUDE.local.md`, then the DeepSeek system prompt, then the skill catalog.
- **minimal** does no context injection at all.

`[INFERRED]` Two things follow. First, the harness reads Claude Code's own context files
unmodified, which is why he "plugged it into my AIOS and didn't have to change anything" -- the
de-facto context-file format has become portable across harnesses. Second, the mode selector is a
context-budget dial exposed to the user, which is a design idea worth stealing regardless of the
tool: the same agent with and without its standing instructions, chosen per task.

## Concept 4: the measured comparison

All of the following hold the model fixed and vary only the harness. This is the experiment.

**Speed** `[MEASURED]` `[ON-SCREEN]`:
- Retrieval from a large personal wiki, identical prompt fired simultaneously at both:
  **DeepSeek Harness ~50 seconds; Claude Code still searching after 5+ minutes.** He states this
  outcome has been consistent across repeated trials.
- A YouTube-analytics-to-Excel task, **Opus 5 under both**: **DeepSeek Harness ~3 minutes;
  Claude Code ~17 minutes.**

`[STATED]` "These are both using the same model. So the harness here just works so much more
efficiently." He reports the same consistency when fanning out subagents for research.

**Output quality, same task, same model** `[MEASURED]`:

| | DeepSeek Harness | Claude Code |
|---|---|---|
| Excel deliverable | Trailing 3 months; colour-coded views and engagement columns; top-10 and bottom-10 charts; monthly trend; tag analysis; notes and sources. "Easy to interpret, not word vomit" | Last 90 days; deeper drill-down; more tabs; **all 467 videos** plus top 50 and monthly trend. "As far as quality, a better output", but "a bit word vomit" |
| Research report (same skill) | ~4,400 words; **14 load-bearing sources** (about 22 found); relatable and practical framing; sometimes **"too confident"** | ~5,000 words; **26 sources**; more scientific and in-depth; **"more conservative with its findings and its facts"** |

**His verdict** `[STATED]`: "Overall, which one of these do I trust more? I trust the Claude Code
one more. I'd probably be more willing to give the Claude Code deliverable to a client or to my
team."

**The caveat he supplies himself** `[STATED]`: the skills being used were built for Claude Code, and
"when you upgrade your model or you switch harnesses, the skills are interpreted a little bit
different every time". A skill written for DeepSeek Harness would likely do better and be faster.

## Concept 5: the capability gap that is not about intelligence

The most important finding in the video for anyone comparing harnesses `[STATED]` `[ON-SCREEN]`.

He built a website with DeepSeek V4 Flash in DeepSeek Harness. It matched his brand guidelines and
had the right feel -- and it also had a visible defect. His explanation:

> "This is where something that Codex or Claude Code would have never let happen, because of the
> **verification checks**, and because of the ability to **screenshot, look, reason, iterate**.
> There's a lot of things when it comes to a UI and design perspective that the DeepSeek models
> will not be very good at because **it can't screenshot, it can't look**."

He is careful about attribution `[STATED]`: "that doesn't mean DeepSeek Harness couldn't be good at
design. It just means that the models you're putting inside there, you have to be aware of what
their strengths and weaknesses are."

`[INFERRED]` The distinction he draws is exactly right and worth stating generally: **a verification
loop requires a modality, not just a rule.** Generate-screenshot-compare-correct is only available
to a harness whose model can see the screenshot. A harness can ship the loop and still be unable to
run it, because the capability lives in the model. This is the one axis on which harness and model
cannot be separated, and it is the reason the "everything is a plugin" pitch has a hard floor.

## Concept 6: cost-to-completion, not cost-per-token

`[STATED]` The harness is free and could run 24/7 without charge; inference is not. DeepSeek models
are cheap and V4 Flash and Pro are both good. But:

> "If it's not an efficient harness, or if the model is so bad that it's not running efficiently,
> then ultimately that's not really that cheap. Those million-input, million-output numbers can be
> deceiving, because it's also about **efficiency and cost to completion** rather than just cost
> for tokens."

`[INFERRED]` This is the correct unit and almost nobody uses it. Price per million tokens is
comparable across models and meaningless across harnesses, because the harness determines how many
tokens a task consumes. The video's own speed measurements are the evidence: a harness that finishes
in 3 minutes what another takes 17 minutes to do has changed the denominator.

## Concept 7: reliability

`[STATED]` `[ON-SCREEN]` The application itself labels this a **developer preview**, and it behaves
like one:
- It stopped working outright on occasion.
- **Compaction bugs** and **context regressions** in long sessions -- "it completely forgot what I
  was talking about". He concedes some of this may be user error from deliberately probing
  context-rot territory.
- UI bugs, including creator mode instantly switching back when selected, requiring a restart.
- One incident where it **locked his mouse** into a small square, which he had Codex diagnose.

## Concept 8: traceability

`[ON-SCREEN]` A **trajectory** view alongside the chat, showing granular intermediate steps in one
place for the whole session, downloadable as a session log.

**What he identifies it as for** `[STATED]`, and this is a genuinely good idea: because the whole
session's steps are captured in one artifact, you can say *"did you see what happened in this
session? Can we build a plugin to fix X, Y and Z that just happened, so that next time your harness
agentic loop runs, this doesn't happen."*

`[INFERRED]` That closes a loop nothing else in this batch closes: the trace of a failure becomes
the input to a modification of the harness that produced it. It requires both the trace and the
mutability, which is why only an open harness can do it.

## Concept 9: the plugin security warning

`[STATED]` Unprompted and correct: "if people are giving out all these open source plugins, you
don't know what might be in there. So be smart, have Claude Code or have Codex review the plugins
before you ever install anything like that off the internet."

`[INFERRED]` Note what this implies about the architecture. When every capability -- including the
loops and the storage -- is a plugin, an installed plugin is not an extension running in a sandbox;
it is a replacement for part of the agent's control flow. The blast radius of a malicious plugin in
this design is larger than in a conventional one, and the mitigation offered is "have another agent
read it", which is advice, not a mechanism.

## Insights and intakes

- **Hold the model fixed and vary the harness.** This video is the experiment everyone else in this
  batch talks around, and it produces large effects: 50 seconds against 5+ minutes, 3 minutes
  against 17, on identical prompts with identical weights.
- **A verification loop needs a modality, not just a rule.** Screenshot-compare-correct is
  unavailable to a harness whose model cannot see. Shipping the loop is not the same as being able
  to run it.
- **Cost-to-completion is the only comparable unit across harnesses.** Price per token compares
  models; the harness sets how many tokens a task takes.
- **Open harness means the loop is editable -- in both directions.** You can add verification the
  vendor did not ship, and remove verification it did.
- **A session trace plus a mutable harness closes a loop nothing else closes:** the record of a
  failure becomes the input to a fix in the machinery that produced it.
- **Context files have become portable.** `AGENTS.md`, `CLAUDE.md` and `CLAUDE.local.md` are read
  by a competing harness unmodified.
- **A mode selector is a context-budget dial.** Same agent, with or without its standing
  instructions, chosen per task.
- **"Free harness" does not mean free.** Losing subscription billing converts a fixed monthly cost
  into a variable per-token one.
- **When every capability is a plugin, a plugin is part of the control flow,** and the blast radius
  of an untrusted one is correspondingly larger.

## Corrections

- **This is not "a free Claude Code" and the video says so explicitly.** "This is just a free
  harness, and you can switch out different cheap models if you want -- which, by the way, you can
  also do inside Claude Code and Codex, you just have to configure it."
- **The speed and quality figures are single-operator, single-trial observations,** shown on camera
  but not controlled. They are the best evidence in this batch and they are still anecdote: no
  repeated runs, no variance reported, no held-out task set.
- **The quality comparison is confounded, by his own admission.** The skills under test were
  authored for Claude Code.
- **Model names in this era are rendered inconsistently by whisper** ("GBT 5.6 Sol", "Cloud Fable",
  "deep sea harness", "Deep Sea Karnas"). Read them as GPT-5.6, Claude Fable, DeepSeek Harness.
- **The mouse-locking incident is reported, not diagnosed.** It is offered as an anecdote about
  preview-quality software; no cause was established.

## Boundaries

- **One week, one operator, one workload.** His stated use is video editing, research, knowledge
  work and document creation -- not building software products. He says plainly that he has never
  felt a gap in Claude Code where he wished he could customise the harness, and that if you are a
  hardcore developer you probably have.
- **Out-of-the-box only.** He deliberately installed no third-party plugins, which means the
  headline feature -- the plugin ecosystem -- is assessed from its documentation and not from use.
- **No security testing.** The plugin warning is given and not acted on.
- **No cost figures.** Despite a section on cost, no dollar amount for any run is given.
- **No verification of his own comparisons.** Both deliverables are judged by reading them.

## Value map: your environment

*[Section redacted for publication. In a real run this section maps every concept in the video against the operator's own projects, tooling and standing practices -- per-concept relevance verdicts ending in adopt / borrow / ignore actions. It is inherently personal, so the published example withholds it.]*
