# DeepSeek Harness (DSH): what it is, how it differs from Claude Code and Codex, and where it wins

Source: "100 Hours Testing Deepseek Harness vs. Claude Code. What You Need to Know." | Nate Herk |
AI Automation | published 2026-08-23 | https://youtu.be/UsfCe5fJK6A | duration 18:02
Topic tags: agent harnesses, DeepSeek Harness, Claude Code, Codex, plugin architecture,
model-agnostic tooling, agent evaluation, context injection, OpenRouter

Transcript source: faster-whisper large-v3, verbatim, CUDA float16, beam_size=5, VAD filtered.
258 segments, 100% duration coverage, zero timestamp gaps over 3 seconds, zero repeated-segment
runs. Audio level check: mean -25.3 dB, max -2.3 dB (live track).

Caption cross-check: YouTube `en-orig` auto-captions, 310 spans after word-overlap dedup,
4,555 caption words against 4,596 verbatim words (99.1% volume), zero dropout spans. Eight
fact-bearing disagreements kept; seven resolved from frames; one kept on the whisper reading and
marked unverified. Ingest cost: 5,408 frames at 5 fps, 8 contact sheets, 11 cropped and
LANCZOS-upscaled artifact reads.

Provenance tags used below: `[ON-SCREEN]` read from pixels; `[STATED]` narrator claim, not
independently verifiable from the recording; `[INFERRED]` this document's own synthesis.

---

## Core thesis

DeepSeek Harness (DSH) is an open-source, free, locally-run agent harness whose distinguishing
property is that every capability is a swappable plugin, including the ones other harnesses treat
as fixed: the agent loop, the tools, the sandbox, the storage layer, and the UI. Because the
harness and the model are separate concerns, DSH can drive any model an OpenRouter key reaches,
including Anthropic's. Against Claude Code running the *same underlying model*, DSH is
substantially faster on retrieval-heavy work over a large personal corpus, materially less
reliable in long sessions, and far more customisable. It is not a free Claude Code, and on the
evidence presented it does not replace one for deep coding.

---

## Concept 1: What a "harness" is, and why it is separable from the model

**What it is.** A harness is the agent scaffolding wrapped around a language model: the system
prompt, the tool definitions, the agentic loop that decides when to call what, the context
management, and the interface. The model supplies reasoning; the harness supplies everything else.

**How it works.** The video's framing device is a three-way diagram in which Codex, Claude Code
and Deepseek Harness are each drawn as a container with an interchangeable "AI Model" slot
`[ON-SCREEN]` (src 00:48). Each harness has models it uses natively, but the slot is the point:
the same model in a different harness is a different product.

**Native pairings as presented** `[STATED]` (src 00:37 to 00:54):

| Harness | Models presented as native |
|---|---|
| Codex | GPT 5.6 Sol, GPT 5.6 Luna |
| Claude Code | Claude Opus, Claude Fable |
| DeepSeek Harness | DeepSeek models, plus anything you configure |

**Why it matters.** The central measured result of the video (Concept 6) is a speed gap between
two harnesses running *the same model*. That result is only interpretable if harness and model are
understood as separable, which is why the diagram comes first.

**Related harnesses named in passing** `[STATED]` (src 01:12): OpenClaw and Hermes Agent are also
agent harnesses. The point made is that DSH is not a new category, only a new and unusually open
entrant.

---

## Concept 2: "Everything is a plugin" -- the actual architectural claim

**What it is.** DSH's own positioning statement, taken verbatim from its landing page
`[ON-SCREEN]` (src 01:58):

```
DeepSeek Harness developer preview

Everything is a plugin

DeepSeek Harness is now in developer preview for agent harness developers
worldwide -- source code included.

Every capability is a plugin that can be swapped or recomposed: models,
tools, skills, sessions, sandboxes, storage, loops, scheduling, and the UI.
```

Install command, from the page's Quick start tab `[ON-SCREEN]` (src 01:58):

```
npx @deepseek-ai/dsh web
```

The page also offers "View on GitHub", "Developer docs", "Community plugins" and a "Cordis paper"
link `[ON-SCREEN]`.

**How it works.** The plugin surface is exposed directly in Settings, which has four sections:
General, Models, Plugins, Agent presets `[ON-SCREEN]` (src 09:05). Individual plugins are
configurable objects, not just on/off toggles. Three read from pixels `[ON-SCREEN]` (src 09:05):

```
Shell        -- "Limits every command the agent runs."
Agent loop   -- "How the agent dispatches tool calls."
                Parallel tool calls: 10
                "Upper bound on parallel-safe calls running at once within one step."
Web search   -- "The DeepSeek search provider."
```

A plugin list elsewhere in the same panel shows on the order of a hundred-plus entries with
individual Enabled/Disabled state, including `include`, `timer`, `session`, `agent`,
`agent-default-model`, `llm-retry`, `settings-file`, `credentials-local`, `api-gateway` and
`jobs-local` `[ON-SCREEN]` (src 09:00).

**What for.** The practical significance is that the agent loop itself is a settable object. On a
closed harness, "how many tool calls run at once" is a vendor decision; here it is a numeric field
with a Save button.

**The metaphor the video uses** `[ON-SCREEN]` (src 01:35, diagram at src 02:20): a closed-source
harness is a car you can sit in, drive, and swap the engine of, but whose layout you cannot
change; an open-source harness is the same car exploded into separately replaceable parts --
dashboard, wheels, seats, battery, control modules. The on-screen diagram labels the closed side
"Fixed system / Not easily changed" and notes both sides run the "Same model".

**Security caveat, stated unprompted** `[STATED]` (src 02:19): community plugins are arbitrary
third-party code. The recommendation is to have Claude Code or Codex review any plugin before
installing it. This video deliberately tests only the out-of-the-box configuration, with no
third-party plugins installed `[STATED]` (src 02:13) -- which bounds every finding below.

---

## Concept 3: Setup and model configuration

**How it works** `[STATED]` (src 02:47 to 03:29), with the resulting UI state `[ON-SCREEN]`:

1. Hand the GitHub link to an existing coding agent and ask it to set the project up.
2. It runs on localhost; the deployment is entirely local.
3. In Settings > Models, supply a provider key.

An OpenRouter key was used, which makes every model OpenRouter exposes selectable. The model
picker, read from pixels at two different scroll positions, contained `[ON-SCREEN]`
(src 03:10 and src 03:15):

```
provider: openrouter
  Claude Opus 5            (selected)
  Claude Opus 5 (Fast)
  Anthropic: Claude Sonnet 4
  Anthropic: Claude Sonnet 4.5
  Anthropic: Claude Sonnet 4.6
  Anthropic: Claude Sonnet 5
  Arcee AI: Trinity Large Thinking
  Arcee AI: Virtuoso Large
  Auto
  ... (elsewhere in the same list)
  Amazon: Nova Premier 1.0
  Amazon: Nova Pro 1.0
  Anthropic: Claude 3 Haiku
  Anthropic: Claude Fable 5
  Anthropic: Claude Haiku 4.5
  Anthropic: Claude Opus 4.1
  Anthropic: Claude Opus 4.5
```

**Billing boundary** `[STATED]` (src 03:15 to 03:29): a Claude or Codex *subscription* cannot be
used by default; billing is per-token API billing through the configured provider. Plugins
claiming to bridge a subscription exist but were not tested.

**Composer controls**, visible on every session screen `[ON-SCREEN]`: a workspace selector
(`Herk-2`), a mode selector, a permission scope selector reading `Workspace Write`, and a model
selector reading `Claude Opus 5 Default`. Sessions carry ages in the sidebar and the product
header carries a `Preview` badge.

---

## Concept 4: The four agent modes (highest-value artifact in the video)

Read verbatim from the open mode dropdown `[ON-SCREEN]` (src 04:11):

```
Standard mode
  Full coding agent with file editing, shell, file and web search, skills,
  planning, goals, subagents, and workflows.

PTC mode
  All Standard mode capabilities, with tools exposed through the Code Mode SDK
  so the model can combine multi-step operations in one TypeScript program.

Minimal mode
  Two-tool coding agent with persistent bash and str_replace_editor.

Creator mode
  Built for creating custom agent presets, with all Standard mode capabilities
  plus runtime inspection, plugin experiments, and preset-authoring guidance.
```

**What each is for:**

- **Standard mode** is the default working mode and the one that performs full context injection.
- **PTC mode** exposes the tool surface through a Code Mode SDK so that a chain of tool calls can
  be expressed as a single TypeScript program rather than as a sequence of individual calls. This
  is *code-as-tool-orchestration*, not parallelism. See Corrections.
- **Minimal mode** strips the agent to two tools -- a persistent bash session and
  `str_replace_editor`. It skips context injection entirely, which makes it fast and cheap and
  suitable for one-off tasks `[STATED]` (src 04:43 and src 05:36).
- **Creator mode** is the self-modification mode: it is how you author agent presets and plugins,
  and it carries runtime inspection. The intended loop is that when the harness misbehaves, you
  switch to Creator mode and build a plugin that fixes it `[STATED]` (src 10:34).

**Observed defect** `[STATED]` (src 08:52): Creator mode would not stay selected -- clicking it
reverted the selector to the previous mode. Presumed fixable by restarting the harness; not
retried on camera.

---

## Concept 5: Context injection and cross-harness portability

**What it is.** In Standard mode, DSH performs an explicit context-loading step before answering,
and it displays that step in the transcript rather than hiding it. Three injection lines were read
from pixels `[ON-SCREEN]` (src 05:00):

```
Context injection - AGENTS.md, CLAUDE.md, CLAUDE.local.md
Context injection - @deepseek-ai/dsh-system-prompt
Context injection - skill-catalog
```

**Why this is the load-bearing interoperability result** `[INFERRED]`: DSH reads Claude Code's own
context files by their real names. An existing Claude Code setup -- its `CLAUDE.md`, its local
overrides, its skills -- is picked up with no migration step. The video's claim that an existing
personal agent system "plugged in and I didn't have to change anything" `[STATED]` (src 05:19) is
directly supported by these three lines.

**Mode-dependent behaviour** `[STATED]` (src 05:30 to 05:44), consistent with the mode definitions
above: the same identity question in Minimal mode produces no context injection at all, so the
agent answers from the conversation only. Standard mode is what makes it feel like a continuation
of an existing agent environment; Minimal mode deliberately is not.

**Permission model** `[ON-SCREEN]`: sessions run under a named scope shown in the composer, here
`Workspace Write`. A session log is downloadable from the session header.

---

## Concept 6: The head-to-head speed result (the video's strongest evidence)

**Setup** `[STATED]` (src 11:36 to 12:04): the identical prompt was issued at the same time to DSH
and to Claude Code, against a large personal knowledge repository. The task was to locate a
YouTube transcript from a vague description and return a two-sentence summary.

**The frame that settles it** `[ON-SCREEN]` (src 12:30), both panels visible simultaneously:

DeepSeek Harness (right) -- finished:
```
Found it. The transcript is in projects/claude-code-second-brain-levels/transcript/
Transcript location
  projects/claude-code-second-brain-levels/transcript/transcript-timestamped.txt  (582 lines, with timestamps)
  projects/claude-code-second-brain-levels/transcript/transcript.txt              (plain text)
  projects/claude-code-second-brain-levels/transcript/transcript.json             (structured)
Published title: "Every Level of a Claude Second Brain Explained"
Two sentence summary  [present]

Deep diving... 52s
1 turns - 4 steps | LLM 15.3s - Tool call 33.4s | TTFT avg 1.7s - 92 tok/s
| Cache hit 52% | Input 156K tok
```

Claude Code (left) -- still running:
```
I'll look for that transcript.
Ran 2 commands
No obvious match there. Let me search wider.
Searching repo for second brain references
53s - 158 tokens - 1 running task - Running tools...

Herk-2.0  master   +38,503  -1,862   Create PR
Auto                                 Opus 5   High
```

**What is verified and what is not.** The same-model claim is verified from pixels: the left panel
reads `Opus 5` and the right reads `Claude Opus 5 Default`. The "roughly 50 seconds versus still
searching" claim is verified: 52s complete against 53s still running. The broader claim of
"one minute versus five-plus minutes, multiple times" `[STATED]` (src 11:57) is not verifiable
from the recording -- only this single trial is shown, and its Claude Code leg is never shown
completing.

**The mechanism the numbers suggest, which the narration does not mention** `[INFERRED]`: DSH's
own footer attributes 33.4s of the 52s to tool calls and only 15.3s to LLM time, on 156K input
tokens at 52% cache hit. The gap on this task is therefore mostly a *retrieval strategy* result --
DSH went straight to two `Grep` calls with targeted regexes, while Claude Code's visible trace
shows it ran two commands, failed to match, and widened the search. This is a search-planning
difference, not raw model speed, and it would not necessarily generalise to tasks that are not
corpus lookups.

**Second head-to-head, deliverable generation** `[STATED]` (src 14:06 to 14:20): the same vague
prompt -- build an Excel breakdown of recently pulled YouTube analytics -- returned in about three
minutes from DSH and about seventeen minutes from Claude Code, both on Opus 5. Neither timing is
shown on screen; both are narrator recall, and the seventeen is explicitly hedged.

**Quality of the two Excel deliverables** `[STATED]` (src 14:20 to 15:36), with the Claude Code
artifact partly `[ON-SCREEN]` (src 15:29):
- DSH: performance data on a trailing three months; colour-coded views and engagement-rate
  columns; a top-10-by-views chart with unlabelled bars; top and bottom tabs; monthly trend; tag
  analysis; notes and sources. Judged simple, readable and not over-written.
- Claude Code: wordier, deeper drill-down, more tabs, more data, no colour coding. The on-screen
  workbook shows tabs `README, Summary, Last 90 Days, All Videos, Top 50, Monthly Trend,
  Duration Buckets, Q2 Daily`, a "Top 50 videos by lifetime views" sheet with a subtotal of
  21,004,045 views / 602,254 likes / 23,765 comments representing 45.57% of catalog views, and a
  provenance line reading "youtube-raw-data.json as of 2026-08-10". The claim that it covered all
  467 videos is `[STATED]` only; the catalog count is not legible in any frame.
- Verdict given: Claude Code's was the better output, at the cost of verbosity and time.

**Third head-to-head, research report** `[STATED]` (src 15:52 to 17:19), with one artifact
`[ON-SCREEN]` (src 16:40): the same in-house "storm research" skill was run in both harnesses on
the effects of sugar on the body. Both followed the skill's structure faithfully, which is
presented as evidence the skill format transfers. Reported differences: about 5,000 words from
Claude Code against about 4,400 from DSH; 26 sources against 14 load-bearing. The DSH report
header is legible and independently confirms the 14:

```
STORM RESEARCH - V2 (VERIFIED)
The Effect of Sugar on the Body
A five-lens synthesis: practitioner, academic, skeptic, economist, and historian.
Every claim independently checked against its primary source before publication.
Method: 5 author-built expert lenses + contradiction map
VERIFIED: All 14 load-bearing citations independently checked against primary
sources on August 23, 2026. Result: 0 fabricated, 6 corrected, 3 demoted. Two
citations were found to be industry-authored or industry-sponsored and are
flagged in place.
```

Character difference reported: Claude Code was more scientific, more in-depth and more
conservative in its claims; DSH was more practical and relatable but occasionally overconfident,
asserting things the author did not agree with. Stated preference: the Claude Code deliverable is
the one he would hand to a client `[STATED]` (src 17:10).

**The confound the video names itself** `[STATED]` (src 17:19): the skills being executed were
authored for Claude Code. A skill written for DSH would plausibly close the quality gap and run
faster. This is a genuine and self-imposed limit on all three comparisons.

---

## Concept 7: The seven-row verdict scorecard

The video's spine is a scorecard filled in row by row. Complete state, read from pixels
`[ON-SCREEN]` (src 10:47):

| Row | Verdict as written |
|---|---|
| Output quality | Entirely depends on the model and effort |
| Cost | Harness is free, inference is not. Deepseek models are cheap. |
| Tokens | Cheap but inefficient tokens = not really cheap |
| Reliability | Promising, but feels like a preview when doing deep coding. |
| Long sessions | Compaction bugs and context regressions |
| Customization | Awesome. Models, tools, loops, subagents, etc. |
| Replace Claude? | No |

Supporting detail per row:

- **Cost** `[STATED]` (src 05:53): the harness itself is free and could run continuously against a
  free model at zero cost; inference is the only charge. DeepSeek V4 Flash and V4 Pro are both
  described as good, Flash cheaper.
- **Tokens** `[STATED]` (src 07:03): the argument is that headline per-token pricing is the wrong
  metric. An inefficient harness or a weak model burns more tokens to reach completion, so
  *cost-to-completion* is the number that matters, not cost per token.
- **Reliability** `[STATED]` (src 07:31): the product self-describes as a developer preview and
  behaves like one. Specific defects reported: intermittent stalls; one incident where the mouse
  was confined to a small region of the screen and required another agent to diagnose; compaction
  bugs; sessions losing the thread of the conversation.
- **Long sessions** `[STATED]` (src 08:10): compaction bugs and context regressions, with the
  honest concession that some of this may be user error from deliberately pushing into context-rot
  territory.
- **Output quality** `[STATED]` (src 03:37): treated as a non-answer by design -- the harness
  cannot rescue a weak model, and the same harness with Fable 5 versus a tiny local model produces
  incomparable output.

---

## Concept 8: Where the model's modality, not the harness, is the limit

**The finding** `[STATED]` (src 06:23 to 06:58), with the artifact `[ON-SCREEN]` (src 06:23): a
brand-guideline-compliant marketing site was built with DeepSeek V4 Flash inside DSH -- a
three-product coffee landing page with scroll behaviour and on-brand styling. It came out
structurally sound but with a visual defect that the author asserts Codex or Claude Code would
have caught.

**The mechanism** `[STATED]`: the DeepSeek V4 models cannot see. Without the ability to screenshot
the rendered page, look at it, and iterate, a design-verification loop is impossible.

**The correct attribution, made explicitly** `[STATED]` (src 06:53): this is not a DSH limitation.
The harness could be excellent at design work; the model placed inside it could not do this task.
The generalisable rule is that when you own the model slot, you also own responsibility for
matching model modality to task.

---

## Insights and intakes

1. **The harness is a variable, and it is a large one.** The same model, same prompt and same
   skill produce materially different deliverables in different harnesses -- different lengths,
   different source counts, different confidence calibration, and, on one retrieval task,
   different completion times by a factor the instrument could actually resolve. Anyone
   benchmarking "a model" without pinning the harness is measuring a pair, not a model.

2. **Free harness does not mean free.** The only cost that disappears is the scaffolding. Inference
   is unchanged, and a per-token subscription is explicitly unusable by default, so a
   subscription-heavy workflow moving to DSH converts a fixed cost into a variable one.

3. **Cost-to-completion beats cost-per-token.** Cheap tokens spent inefficiently are not cheap.
   This is the correct unit of account for agent work and it is rarely the one quoted.

4. **Interoperability arrived through file-format convergence, not through an API.** DSH reads
   `AGENTS.md`, `CLAUDE.md` and `CLAUDE.local.md` directly. The portability is a consequence of
   agreeing on filenames, which is a much lower-friction path than a migration tool.

5. **Skills are portable in structure but not in yield.** The same skill file ran faithfully in
   both harnesses -- the report structure came out identical -- yet produced different research
   depth and different source counts. Structure transfers; behaviour is re-interpreted per harness
   and per model.

6. **Customisation is only worth paying for against a felt constraint.** The most useful piece of
   advice in the video is negative and self-directed: for knowledge work, research, document
   creation and video editing, no gap in the closed harnesses was ever felt, so unlimited
   customisability buys nothing. It is worth the switch for people who have actually hit the wall.

7. **A self-modifying loop is the real prize.** Creator mode plus a downloadable per-session
   trajectory means a failure can be turned into a plugin that prevents its recurrence. That loop
   -- observe the trace, author the fix, install it into the loop itself -- is not available at
   all on a closed harness.

8. **Owning the model slot means owning modality risk.** A vision-incapable model silently cannot
   run a look-and-iterate loop. Nothing in the harness warns you; the output simply comes back
   wrong in a way that no amount of harness quality would fix.

---

## Corrections

Stated right-fact-first. Items 1 to 6 arise from the caption cross-check and were settled from
pixels; items 7 and 8 are narration-versus-screen discrepancies found in the guided read.

1. **The product is Claude Code.** Both ASR engines rendered it "Cloud Code" throughout, and
   whisper was internally inconsistent, switching to "Claude code" only after roughly 10:49. The
   comparison diagram reads `Claude Code` (src 00:48). Neither engine is reliable on this term;
   every occurrence in the raw transcript should be read as Claude.

2. **The models are Claude Opus and Claude Fable, and the files are `CLAUDE.md` and
   `CLAUDE.local.md`.** Heard as "Cloud Opus", "Cloud Fable", "cloud.md" and "cloud.md local".
   Settled by the model picker (src 03:10) and the context-injection lines (src 05:00).

3. **The product is Codex.** The caption track rendered it "Codeex"; whisper was correct. Settled
   by the comparison diagram (src 00:48).

4. **The model is GPT 5.6 Sol.** Both engines heard "GBT". Settled from the author's own video
   catalog on screen, which contains the title "I Tested GPT 5.6 Sol vs Fable 5: What You Need to
   Know" (src 15:29).

5. **The harness is DeepSeek Harness, abbreviated DSH.** Whisper produced "Deep Sea Karnas" once
   and "Deep Seek"/"Deep sea" variants throughout. Settled by the landing page and the package
   name `@deepseek-ai/dsh` (src 01:58).

6. **OpenClaw is a real product name, not a mishearing.** Both engines agreed, and it is confirmed
   on screen in the author's own catalog title "Claude Code + Paperclip Just Destroyed OpenClaw"
   (src 15:29). Kimi is the one fact-bearing term that could not be settled from any frame; the
   whisper reading "Kimi" is retained over the caption reading "Kimmy" and is marked unverified.

7. **PTC mode is about expressing multi-step tool use as one TypeScript program, not about
   parallelism.** The narration describes it as suited to "a lot of stuff that I want to run in
   parallel" and a "multi-chain" (src 04:18). The on-screen definition instead says tools are
   exposed through a Code Mode SDK so the model can combine multi-step operations in a single
   TypeScript program (src 04:11). Parallelism is a *separate*, orthogonal control: `Parallel tool
   calls: 10` lives under the Agent loop plugin (src 09:05). Reading PTC as "the parallel mode"
   would lead to choosing it for the wrong workloads. The narration is hedged in the source
   ("it's not exactly that"), but the specific mechanism is not conveyed.

8. **The video's own headline number is not supported by its narration.** The title claims 100
   hours of testing. The opening sentence says the harness had been in use "for the past week"
   (src 00:00), and 100 hours in seven days would be over fourteen hours a day. No figure for
   hours spent appears anywhere in the narration or on screen. The author's own catalog, visible
   on screen, contains at least two earlier videos with the same construction -- "100 Hours
   Testing Clawbot vs Claude Code (honest results)" and "100 Hours Testing Claude Code vs
   Antigravity (honest results)" (src 15:29). `[INFERRED]` "100 Hours" is a recurring channel
   title template rather than a measured quantity, and should not be cited as a testing-effort
   figure.

Additional minor gap: the landing page lists `scheduling` among the plugin categories; the
narration's read-back of that list omits it (src 02:04).

---

## Boundaries -- what this source does not establish

- **No third-party plugins were tested.** Every finding describes stock DSH. The customisation
  ceiling that is the product's main selling point is therefore argued from the settings surface,
  not demonstrated.
- **The comparison is n=1 per task.** Three tasks, one trial each shown. Only the first has both
  sides visible on screen, and even there the Claude Code leg is never shown finishing, so the
  size of the gap is a lower bound, not a measurement.
- **All skills used were authored for Claude Code**, which the author names as a confound. No
  DSH-native skill was written or tested, so the quality comparison is loaded against DSH by an
  unmeasured amount.
- **Timings are wall-clock on one machine over a personal corpus**, with no repetition, no
  variance estimate and no control for machine state or network. The three-versus-seventeen-minute
  and one-versus-five-minute figures are narrator recall and are not on screen.
- **Cost is discussed qualitatively only.** No dollar figures, no token counts per task except the
  one on-screen session footer, and no cost-to-completion comparison is actually computed despite
  that being the metric the video argues for.
- **No coding benchmark is run.** The "does not replace Claude Code for deep coding" verdict rests
  on reliability anecdotes and general impression, not on any coding task shown end to end.
- **Nothing is said about multi-user, team, or CI use**, about security review of the harness
  itself as opposed to its plugins, or about what happens when the developer preview changes
  underneath an installed plugin set.
- **The reliability findings have a shelf life.** A developer-preview product's bug list is the
  most perishable content here; the architectural observations are the durable part.

---

## Value map: your environment

*Redaction note: this section is published in full for everything derived from the video.
Anywhere it would otherwise name or describe the operator's own private repositories, file paths,
skill names, or pipeline internals, that span is replaced in place with a `[REDACTED: ...]`
marker -- the surrounding reasoning and judgment are kept.*

Assessed against the working context you have described in this session. "No value" is a
first-class answer and is used where it applies.

**[REDACTED: private systems-performance track] (measurement discipline).** The highest-value item is item 1 of the
insights: harness and model are a *pair*, and a number that does not pin both is measuring an
unnamed compound. That is the same failure your own guardrails already name for cores and
harnesses -- "a number is only comparable to another measured the same way". This video is a clean
external illustration of the failure, not a new rule for you. Conversely, the video is a useful
negative example of everything your track forbids: n=1 per condition, no variance estimate, no
pre-registered band, a headline number in the title with no measurement behind it, and a
self-named confound (skills authored for one side) that is acknowledged and then not controlled
for. The three-versus-seventeen-minute claim in particular is exactly the shape your rules would
score as unquotable. **Direct adoption value: none. Illustrative value for the methodology
argument: high.**

**[REDACTED: private ML pipeline].** No mechanism connects here. The pipeline's constraints are leakage control,
checkpoint freshness, multi-offset correctness and Ray cluster throughput; none of those is a
harness-scaffolding problem, and swapping the agent harness you author the pipeline *with* changes
nothing about the pipeline's own correctness properties. The single transferable idea is
cost-to-completion as the unit of account -- which you already apply, in the form of judging
retrain and walkforward runs by wall-clock-to-result rather than by per-step cost. **Value: none
beyond what you already do.**

**Agent orchestration and your multi-model advisor workflow.** This is the strongest fit. Your
advisor pattern already routes work across models by role (one model plans, another builds,
a cheap model runs bash). The video's evidence adds a dimension you are not currently varying: the
*harness* is a variable too, and on retrieval-heavy work over a large corpus the harness dominated
a same-model comparison. Concretely: `Parallel tool calls: 10` as a settable field is the kind of
knob that would let you tune fan-out behaviour explicitly rather than inferring it. Whether that
is worth a migration is answered by insight 6, and the honest answer for you is probably no --
your constraint is measurement rigour and context budget, not harness expressiveness. **Value:
worth knowing, not worth switching for.**

**Skills authoring (the watch-video family, [REDACTED: private knowledge-graph tool], and other project skills).** Insight 5 lands directly.
Your skills are substantial documents with strong procedural contracts, and the finding that a
skill's *structure* transfers across harnesses while its *yield* does not is a real risk to how you
have written them: the watch-video family's contracts assume a reader that will follow an
ordered list and honour "do not skip". A different harness would keep your headings and change
your rigour. If you ever run these skills outside Claude Code, treat the procedural guarantees as
unvalidated until re-tested, exactly as you would a core change. **Value: high, and actionable
today as a caveat to add to the family's shared preamble.**

**Context-file portability.** `AGENTS.md` / `CLAUDE.md` / `CLAUDE.local.md` being read verbatim by
a competing harness is directly relevant to how much of your setup is locked in. Your global
`CLAUDE.md`, [REDACTED: private systems-performance track]'s `CLAUDE.md`, and the skills tree
are, on this evidence, substantially portable as *content*; [REDACTED: private hook and
enforcement mechanism names] are not, because they are harness-specific execution, not files.
That is a useful and previously unstated split in your own setup: your prose is portable, your
enforcement is not. **Value: high as a lock-in assessment.**

**Career / interview track.** No mechanism. The autopsy protocol, the behavioural profile and the
tracker are content and workflow, unaffected by which harness runs them. **Value: none.**

**Daily routine.** One concrete change is available and it is small: when you compare two agent
configurations informally, record which harness *and* which model each side ran, because the video
demonstrates that omitting either makes the comparison uninterpretable. You already do this for
cores. Extending the same habit to agent comparisons costs nothing. Beyond that, nothing here
argues for changing how you work day to day.

**Deliberate skill-building.** If you are building toward owning more of the agent stack, Creator
mode's loop -- read the session trajectory, author a plugin, install it into the agent loop -- is
the concept worth carrying forward regardless of vendor. It is the agentic equivalent of the
pre-registration-then-fix cycle you already run, and it is the one capability in this video that
genuinely does not exist on a closed harness.
