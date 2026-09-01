# DeepSeek Harness versus Claude Code: what an open-source agent harness changes, and what it does not

Source: "100 Hours Testing Deepseek Harness vs. Claude Code. What You Need to Know." -- Nate Herk
(channel: Nate Herk | AI Automation), published 2026-08-23, 18:02 runtime,
https://youtu.be/UsfCe5fJK6A
Topic tags: agent harnesses, DeepSeek Harness (DSH), Claude Code, Codex, OpenRouter, plugin
architectures, model-agnostic tooling, agentic evaluation, knowledge work automation
Transcript: platform captions (tier C), YouTube auto-generated English `en-orig` track,
rolling-window deduplicated. Auto-captions mangle product names heavily in this source; every
product name, number and quoted UI string below was re-derived from video frames rather than from
the caption text. See "Corrections" for the specific caption failures.

---

## Core thesis

An agent harness -- the loop, tool set, prompt scaffolding, context injection and UI that wrap a
language model -- is a separate and independently consequential layer from the model itself. The
same model driven by two different harnesses produces measurably different work: different
latency, different token accounting, and different interpretations of the *same* instruction file.
DeepSeek Harness makes that layer fully open and re-composable, which buys enormous customization
and a large speed advantage on retrieval-shaped tasks, at the cost of preview-grade reliability.
It is not a free Claude Code; it is a different harness that happens to be free, and choosing it
is a decision about the harness layer, not about saving money on the model layer.

---

## 1. What a harness is, and why the distinction matters

**What it is.** A harness is everything around the model: the agentic loop, the tool definitions
and their dispatch policy, the system prompt, the context-injection rules, session and workspace
storage, sandboxing, and the interface. The model is swappable inside it.

**The taxonomy shown.** Three harnesses were drawn side by side, each as a box containing a
vendor mark and an interchangeable "AI Model" slot: Codex (OpenAI mark), Claude Code (Anthropic
mark), and DeepSeek Harness (DeepSeek whale mark). Three further marks -- Zed, a "K" wordmark
(Kilo Code), and the Meta mark -- were placed beneath as additional entrants in the same
category. [ON-SCREEN, src 00:45]

**Native versus configurable models.** Each harness ships with models it is built and marketed
around, but all three accept others. DeepSeek Harness natively targets DeepSeek models and accepts
anything you can reach through a provider key; Claude Code and Codex can likewise be pointed at
other models, they are simply neither designed nor promoted for it. [STATED, src 00:53-01:14]

**Why the distinction matters.** This is not new technology -- it is a new harness. The
significance is that this one is open source, so the layer that was previously fixed becomes
editable. [STATED, src 01:14-01:24]

**The car analogy, as drawn.** A closed-source harness is a sealed vehicle: you sit in it, drive
it, and swap the engine (the model), but you cannot move anything around -- the slide labels it
"Fixed system / Not easily changed". An open-source harness is the same vehicle presented as an
exploded parts diagram -- steering, dashboard, tools module, memory module, wheels,
battery/electronics, panels -- all individually replaceable, with the caption "Same model" to make
explicit that only the wrapper changed. [ON-SCREEN, src 02:00]

---

## 2. DeepSeek Harness: what it actually is

**Positioning, verbatim from the product page.** The page headline is "Everything is a plugin",
under the standfirst "DeepSeek Harness developer preview", and it states that the harness is in
developer preview for agent harness developers worldwide with source code included. Its capability
list reads: models, tools, skills, sessions, sandboxes, storage, loops, scheduling, and the UI --
all described as plugins that can be swapped or recomposed. The page carries four links (View on
GitHub, Developer docs, Community plugins, Cordis paper) and an EN / Chinese language toggle.
[ON-SCREEN, src 01:55-02:10]

**Install.** The page's Quick start tab gives a single command, with an "Install from source" tab
beside it:

```
npx @deepseek-ai/dsh web
```

[ON-SCREEN, src 02:05]

**How the reviewer actually installed it.** He handed the GitHub link to Codex and asked it to set
the project up; the result runs on localhost, fully local. [STATED, src 02:52-03:02]

**License and cost of the software.** The harness itself is open source and free. [STATED,
src 00:31]

**Interface.** A conventional chat application: workspace list and session history on the left, a
composer in the centre. The home screen reads "Into the Unknown" with a "Preview" badge. The
composer carries four chips: workspace, mode, permission preset ("Workspace Write"), and model
("Claude Opus 5", marked Default). [ON-SCREEN, src 03:10]

---

## 3. Credentials and model selection

Models are configured under Settings > Models by supplying a provider key. With an OpenRouter key
in place, the model picker exposes the whole OpenRouter catalogue; the DeepSeek section of that
picker listed DeepSeek V3 0324, V3.1, R1, R1 0528, V3.1 Terminus, V3.2, V3.2 Exp and V4 Flash.
[ON-SCREEN, src 03:10]

By default there is no way to authenticate against an existing Claude or Codex *subscription* --
billing is per token through the API. Third-party plugins claiming to bridge a subscription exist
but were not tested. [STATED, src 03:13-03:24]

**Settings surface.** Four sections: General, Models, Plugins, Agent presets. The Plugins section
has a "Plugin configuration" tab exposing individual subsystems as editable cards -- Shell (limits
on every command), Agent loop (how the agent dispatches), and a numeric "Parallel tool calls"
setting, observed at 10, described as an upper bound on parallel dispatch. There is also an
"Open configuration file" affordance. [ON-SCREEN, src 09:00-09:07]

A second Plugins list showed roughly two dozen individually toggleable plugins, all enabled,
almost all prefixed `ui-`: `ui-deliverables`, `ui-workspace`, `ui-input-trigger`, `ui-commands`,
`ui-skill`, `ui-subagent`, `ui-reference`, `ui-jobs`, `ui-goal`, `ui-message-feedback`,
`ui-model-selection`, `ui-permission-presets`, `ui-agent-preset`, `ui-settings-plugins`,
`ui-plan`, `ui-user-questions`, `ui-trajectory`, `agent-presets`, a directory-picker pair,
`web-search-perplexity`, and `hmr`. The practical meaning of "everything is a plugin" is visible
here: the model selector, the permission presets and the plan view are themselves plugins that
can be switched off. [ON-SCREEN, src 09:00]

---

## 4. The four agent modes

The mode picker sits in the composer and is switched before a prompt is sent. Descriptions are
quoted from the dropdown itself. [ON-SCREEN, src 04:08]

| Mode | On-screen description | When to use |
|---|---|---|
| Standard mode | Full coding agent with file editing, shell, file and web search, skills, planning, goals, subagents, and workflows. | Default; the mode you are on most of the time. |
| PTC mode | All Standard mode capabilities, with tools exposed through the Code Mode SDK so the model can combine multi-step operations in one TypeScript program. | Large tasks with many operations that can be composed and run together rather than dispatched one call at a time. |
| Minimal mode | Two-tool coding agent with persistent bash and `str_replace_editor`. | Quick one-off tasks; drops most context injection, executes faster and cheaper. |
| Creator mode | Built for creating custom agent presets, with all Standard mode capabilities plus runtime inspection, plugin experiments, and preset-authoring guidance. | Building plugins, agent presets, or UI changes for the harness itself. |

The acronym "PTC" is not expanded anywhere on screen; only the Code Mode SDK reference is given.
[ON-SCREEN, src 04:08]

**Creator mode as a self-repair loop.** The intended pattern is that when the harness misbehaves,
you switch to Creator mode and have the harness build a plugin that fixes its own behaviour, so
the failure does not recur on the next run of the agentic loop. [STATED, src 10:31-10:41]

---

## 5. Context injection: the mechanism behind harness-agnostic portability

This is the most transferable finding in the source, because it is what makes an existing
Claude-Code-shaped setup work unchanged inside a different harness.

**What Standard mode does on the first turn.** Sending a trivial prompt in Standard mode triggers
three labelled context injections before the model answers, each expandable in the transcript:

1. `AGENTS.md, CLAUDE.md, CLAUDE.local.md` -- all three shown with a `loaded` marker, wrapped in a
   `<system-reminder>` block stating that the workspace instructions may be relevant, that more
   specific instructions take precedence over broader ones, and that they do not override system,
   developer or direct user instructions.
2. `@deepseek-ai/dsh-system-prompt` -- the harness's own system prompt, delivered as a package.
3. `skill-catalog` -- the available skills, injected as a catalogue rather than as full text.

[ON-SCREEN, src 05:02]

**What Minimal mode does.** No context injection on the first turn. Asked the same identity
question, the agent answered that it has no personal information and offered to inspect the
machine (Windows user account, hostname) instead. Minimal mode therefore gives genuinely stateless
one-off chats. [ON-SCREEN, src 05:22-05:34]

**The portability consequence.** Because DSH reads `AGENTS.md`, `CLAUDE.md` and `CLAUDE.local.md`
directly, an existing Claude-Code workspace -- its instruction files, its skills, its accumulated
context -- was picked up with no migration work at all. The harness is genuinely a swappable layer
for a setup already written to those conventions. [ON-SCREEN + STATED, src 05:12-05:52]

**Runtime context is versioned, not appended.** The trajectory view exposes a context event
reading "Current runtime context. This snapshot supersedes earlier runtime-context snapshots" --
so the harness replaces its runtime snapshot rather than accumulating them. [ON-SCREEN, src 13:14]

---

## 6. The trajectory view: per-step observability

Every session has a Chat tab and a Trajectory tab. The Trajectory tab renders the run as typed,
filterable events (filters: Duration, Turns, Calls, plus free-text search) over a horizontal
timeline banded into three lanes -- Input, Model, Tools -- so the shape of a run is legible at a
glance. Event rows are typed `SYSTEM`, `USER`, `CONTEXT`, `ASSISTANT` and `TOOL`, and tool rows
show the call arguments as JSON alongside the returned result. Observed rows from one retrieval
run included `glob`, `grep` (with the actual regex, e.g. a case-insensitive alternation over
"second brain", "levels of", "level 1", "level one"), `pwsh` running `Get-ChildItem`, and `read`
with a full file path. The whole session log is downloadable. [ON-SCREEN, src 12:49-13:24]

**Why this is the feature to copy.** The stated use is to close the loop: read the trajectory,
identify what the loop did badly, and then ask the harness to turn that session into a skill or
into a plugin that prevents the same failure next time. [STATED, src 13:02-13:24]

**Failures are visible in the trajectory that are invisible in the chat.** The first tool call of
the observed run, a `glob`, returned `TOOL_TIMEOUT` in red. Nothing in the chat view or the
narration surfaced it. [ON-SCREEN, src 13:14]

**Live run metrics.** A status bar under the composer reports, per session, turns and steps, LLM
time, tool-call time, time-to-first-token, tokens per second, cache hit rate, and input/output
token counts. Two readings taken about 45 seconds apart in the same session:
`1 turns - 4 steps | LLM 15.3s - Tool call 33.4s | TTFT avg 1.7s - 92 tok/s | Cache hit 52% |
Input 156K tok` and later `1 turns - 5 steps | LLM 20.7s - Tool call 33.4s | TTFT avg 1.6s -
88 tok/s | Cache hit 65% | Input 222K tok`. Note that tool-call time dominates LLM time in both.
[ON-SCREEN, src 12:29 and 13:14]

---

## 7. The head-to-head evaluations

Three comparisons were run, all with Claude Opus 5 as the model on both sides.

### 7.1 Retrieval across a large personal knowledge vault

**Task.** Locate the transcript of a specific past video inside a large personal wiki (referred to
as an "AI operating system", workspace `Herk-2`, on Windows), then summarise it in two sentences.
The identical prompt was fired at both harnesses simultaneously.

**Result.** At the 52-second mark, DeepSeek Harness had already located the file, listed three
variants of it (timestamped `.txt` at 582 lines, plain `.txt`, structured `.json`), reported the
published title, and moved into summarising. Claude Code at the same instant was still on
"Searching repo for second brain references", 158 tokens in, tools still running. [ON-SCREEN,
src 12:29]

**Claimed magnitude.** Roughly one minute in DSH against five-plus minutes in Claude Code,
described as reproducible across multiple runs of the same prompt. [STATED, src 11:43-11:55]

**Important confound.** The two sides were not configured identically. Claude Code's composer read
`Opus 5` with effort `High`; the DSH composer read `Claude Opus 5 Default`. The reasoning-effort
setting differed, so the comparison is same-model but not same-configuration. [ON-SCREEN,
src 12:29 and 13:14; see Corrections]

### 7.2 Building a spreadsheet deliverable from YouTube analytics

**Task.** Deliberately vague: find recently pulled YouTube analytics and build an Excel workbook
breaking them down. Chosen because it exercises skills, API calls, and reasoning/structuring
scripts to produce an artifact.

**DeepSeek Harness output.** A workbook titled "YouTube Performance Report - Trailing 3 Months",
tabs Summary / Videos / Top & Bottom / Monthly Trend / Tag Analysis / Notes & Sources.
Multi-colour conditional formatting applied to the views and engagement-rate columns; a top-10 and
bottom-10 by views section with a bar chart; a monthly trend chart. The charts carry the bars but
no data labels, so they read as shape only and have to be cross-referenced against the adjacent
table. [ON-SCREEN, src 14:20-15:01]

**Claude Code output.** A workbook titled "YouTube Channel Report", tabs README / Summary /
Last 90 Days / All Videos / Top 50 / Monthly Trend / Duration Buckets / Q2 Daily / Tag Analysis /
Notes & Sources, plus more beyond the visible strip. The All Videos sheet carried fifteen columns
(Video ID, Title, Published, Type, Runtime, Runtime (sec), Views, Likes, Comments, Days Live,
Views/Day, Like Rate, Comment Rate, Engagement Rate, Tags) across the full catalogue.
[ON-SCREEN, src 15:01-15:34]

**Timing.** DSH approximately 3 minutes; Claude Code approximately 17 minutes. [STATED,
src 14:09-14:20 -- no on-screen timer corroborates either figure]

**Quality verdict.** Claude Code produced the better analytical output -- more drill-down, more
specific, more tabs, more data -- but was noticeably wordier. DSH produced the more immediately
interpretable artifact: simpler, effective, not word vomit. Both were given the same vague prompt;
a specific prompt naming pain points would likely have changed both. [STATED, src 14:51-15:44]

### 7.3 A research report through a user-authored skill

**Task.** Both harnesses were asked to run the same author-built "STORM research" skill to produce
a report on the effects of sugar on the body.

**Structural agreement.** Both outputs render the skill's template correctly -- same title block,
same "five-lens synthesis" standfirst naming the practitioner, academic, skeptic, economist and
historian lenses, same "HOW TO READ THIS" panel, same numbered section spine beginning with a
60-Second Summary, same per-claim badge vocabulary (`SUPPORTED BY`, `CHALLENGED BY`, `CORRECTED`,
and cards carrying labels such as `CONTESTED SIGNAL - MONITOR, DO NOT ASSERT - CONFIDENCE 4/10 -
SPONSORED VENUE`). The skill was followed by both. [ON-SCREEN, src 16:06-16:16]

**Where they diverged, read from the two verification banners.** [ON-SCREEN, src 16:20-16:38]

- Claude Code: 26 sources listed, 25 independently checked; result 8 confirmed clean, 13
  corrected, 2 demoted, 2 figures untraceable to any primary source, 1 carried as an unverified
  lead. Its own summary line concedes that roughly half of what the lenses reported needed a fix.
- DeepSeek Harness: all 14 load-bearing citations checked; result 0 fabricated, 6 corrected, 3
  demoted, with two citations flagged in place as industry-authored or industry-sponsored.

**The divergence is not only in the numbers.** The two runs of the same skill also wrote different
audience definitions into the header -- Claude Code addressed "a health-conscious decision-maker
who also explains this evidence publicly", DSH addressed a "health-conscious general reader &
public-facing content creator" -- and used different date formats. DSH additionally added a
reading-guide bullet of its own distinguishing free and added sugars from intrinsic sugars in
whole fruit. Same skill file, same model, different framing decisions. [ON-SCREEN, src 16:20]

**Character verdict.** Claude Code came out more in-depth, more scientific, more conservative in
its claims; DSH came out more relatable and practical, and at times over-confident to the point of
asserting things the reviewer did not agree with. Word counts: approximately 5,000 (Claude Code)
against approximately 4,400 (DSH). Trust verdict: the Claude Code deliverable is the one he would
hand to a client or a team. [STATED, src 16:40-17:11]

**The confound he names himself, and it is the important one.** The skills being run were
*authored for Claude Code*. Skills are re-interpreted whenever you change model or harness, so a
skill written for one harness is a biased instrument for comparing two. A skill authored natively
for DSH would likely score better and run faster there. [STATED, src 17:11-17:32]

---

## 8. The seven-row assessment

The reviewer's own scorecard, built up row by row on a canvas through the video, completed at
09:17. Cells are quoted as written. [ON-SCREEN, src 11:00]

| Row | Verdict as written |
|---|---|
| Output quality | Entirely depends on the model and effort |
| Cost | Harness is free, inference is not. Deepseek models are cheap. |
| Tokens | Cheap but inefficient tokens = not really cheap |
| Reliability | Promising, but feels like a preview when doing deep coding. |
| Long sessions | Compaction bugs and context regressions |
| Customization | Awesome. Models, tools, loops, subagents, etc. |
| Replace Claude? | No |

---

## 9. Reliability: the observed defects

The product self-describes as a developer preview on its own landing page and carries a "Preview"
badge on the harness home screen, and the reviewer's experience matched that label. [ON-SCREEN,
src 01:55 and 03:10]

**Confirmed on screen: the mode selector does not commit.** Across twelve seconds of continuous
footage the mode dropdown was opened at least five times, "Creator mode" was clicked each time,
and the composer chip continued to read "Standard mode" with the checkmark still on Standard. The
selection silently fails and the menu simply dismisses. The suggested workaround was restarting
the harness. [ON-SCREEN, src 08:44-08:57]

**Reported, not verified on screen:** intermittent hangs; a session in which the mouse cursor
became confined to a small region of the screen, itself resolved by asking Codex to diagnose it;
compaction bugs where the agent appeared to lose the thread of the conversation entirely; context
regressions in long sessions. The reviewer concedes some of this was self-inflicted -- he was
deliberately probing for breaking points and context-rot territory. [STATED, src 07:35-08:15]

---

## 10. Cost and token economics

**The software is free; the inference is not.** Running the harness costs nothing; every token it
consumes is billed by whatever provider you configured. DeepSeek models are cheap and, per the
reviewer, solid. [STATED, src 05:52-06:07]

**Cheap tokens are not the same as cheap work.** The unit that matters is cost to completion, not
cost per token. An inefficient harness, or a model too weak to run efficiently inside it, will
burn enough extra tokens to erase a low per-token price. Headline million-in / million-out pricing
is therefore deceptive in isolation. [STATED, src 07:02-07:25]

**Subscription arbitrage runs the other way.** If you intend to use Opus, a Claude Code
subscription gives materially better value than paying per token for the same model inside DSH.
[STATED, src 10:51-11:02]

---

## 11. Model capability is not harness capability

A landing page for a protein-coffee brand ("PERKFORM", hero line "Coffee that pulls its weight",
20g protein / 150mg caffeine, product cards for Bold Mocha, Vanilla Latte and Salted Caramel) was
built inside DSH using DeepSeek V4 Flash. It correctly consumed the supplied assets and brand
guidelines and produced the intended scroll behaviour and overall feel. It also shipped visible
layout failures: a scroll-driven zoom that overshoots into a full viewport of empty background, a
product image blown up until the can and its label are cropped off, and a stray unstyled rectangle
in the navigation bar. [ON-SCREEN, src 06:19-06:40]

**The mechanism.** Codex or Claude Code would have caught this because their verification loop can
screenshot the rendered page, look at it, reason about it and iterate. The DeepSeek models being
driven here cannot see, so no amount of harness quality closes that gap. The correct conclusion is
not that DSH is bad at design -- it is that visual work requires a model with vision in the slot.
[STATED, src 06:30-06:52]

---

## 12. Insights and intakes

- **The harness is an independent variable, and it is larger than expected.** Holding the model
  fixed at Claude Opus 5 and changing only the harness changed retrieval latency by a large
  multiple and changed how the same skill file was interpreted -- different audience framing,
  different verification depth, different tone. When evaluating agent output, the harness must be
  recorded alongside the model or the result is not reproducible.

- **A speed comparison between harnesses is only as good as its configuration control.** The
  head-to-head here fixed the model and left reasoning effort unequal. Any such test should pin
  effort, permission mode, context-injection set and tool availability, or state explicitly that
  it did not.

- **Skills are harness-coupled, not portable in the way file formats are.** A skill authored
  against one harness carries implicit assumptions about that harness's loop and tools. Running it
  elsewhere measures the mismatch as much as the harness.

- **Portability across harnesses is cheap when your context lives in files.** `AGENTS.md`,
  `CLAUDE.md` and `CLAUDE.local.md` were read by a completely different vendor's harness with zero
  migration. Instruction-as-file is the thing that made the switch free.

- **Per-step trajectory instrumentation is the feature worth stealing.** Typed events with tool
  arguments and results, a three-lane timeline, and a downloadable session log make a run auditable
  after the fact -- and the run examined here contained a `TOOL_TIMEOUT` that the chat view never
  showed. A summary view hides exactly the failures you most need to see.

- **Cost per token is the wrong unit.** Cost to completion is the right one. A cheap model in an
  inefficient loop is not cheap.

- **Customization only pays where you have a felt pain.** The reviewer's own honest position: for
  video editing, research, knowledge work and document creation he has never once wanted to change
  the harness, so unlimited customization buys him nothing today. The value is real for people
  building products who have hit the wall, and for anyone who wants a spillover target when
  approaching subscription limits.

- **Open plugin ecosystems are a supply-chain surface.** Community plugins for an open harness can
  contain anything. The stated discipline is to have Claude Code or Codex review any third-party
  plugin before installing it.

- **"Free harness" and "free Claude Code" are different claims.** DSH is the first; it is not the
  second, and treating it as a cost-saving substitute rather than a different tool is the main
  error the video exists to correct.

---

## 13. Corrections

Stated right-fact-first; the source's version follows.

1. **The head-to-head retrieval test was not configuration-matched.** The correct description is
   "same model, different reasoning effort": the Claude Code side ran Opus 5 at effort `High`, the
   DSH side ran Claude Opus 5 at `Default`, both visible in their respective composers. The source
   describes it as "these are both using the same model" and attributes the entire latency
   difference to harness efficiency. The harness may well be the dominant term, but this
   particular run does not isolate it. [ON-SCREEN, src 12:29 and 13:14]

2. **The DeepSeek report's verification banner states 14 load-bearing citations and does not state
   a total.** The source says "14, at least 14 that were considered load-bearing. I think in total
   it actually found 22, I believe." The 22 figure appears nowhere in the visible artifact and is
   hedged twice in the narration; treat it as unsupported. The 26-source figure for the Claude Code
   side is confirmed on screen. [ON-SCREEN, src 16:20-16:38]

3. **The Claude Code workbook does use colour.** Its All Videos sheet carries banded blue tinting
   on several columns. What it lacks relative to the DSH workbook is multi-hue conditional
   formatting on the metric columns. The source says "we don't have any colour coding". [ON-SCREEN,
   src 15:22 vs 14:30]

4. **The DeepSeek Harness capability list includes models and scheduling.** The page's own
   sentence enumerates models, tools, skills, sessions, sandboxes, storage, loops, scheduling and
   the UI. The narration recites the list while omitting "models" and "scheduling" -- and "models"
   is the load-bearing one, since a swappable model plugin is the entire premise of the comparison.
   [ON-SCREEN, src 01:58]

5. **The observability tab is called Trajectory.** The narration calls it "directory". The tab
   label, and the plugin behind it (`ui-trajectory`), both read Trajectory. [ON-SCREEN, src 12:49]

6. **"Run it 24/7 with a free model and never get charged" needs a qualifier.** The harness
   software is free and self-hosted, so it bills nothing itself; but "free" models on an
   aggregator are rate-limited and quota-bound rather than unlimited, so continuous operation is
   constrained by the provider even when the per-token price is zero. The source states the
   unqualified version. [INFERRED, src 05:52]

7. **Caption artifacts, listed so an ingesting agent does not inherit them.** The auto-caption
   track mangles nearly every product name in this source. Correct forms: DeepSeek Harness (DSH)
   for "Deep Sea Carness" / "DeepC Carnis" / "Deep Sea Caress" / "DeSseek"; Claude Code for "Cloud
   Code" / "claw code"; Codex for "Codeex" / "CEX"; Claude Fable for "Cloud Fable"; Kimi for
   "Kimmy"; `CLAUDE.md` and `CLAUDE.local.md` for "cloudmd" and "cloudmd local"; ChatGPT for "Chag
   app"; STORM for "storm". Two spoken names could not be verified from any frame and are recorded
   here as caption output only, not as confirmed product names: "OpenClaw" and "Hermes Agent",
   offered as further examples of agent harnesses. The three additional vendor marks that *were* on
   screen in that segment are Zed, Kilo Code and Meta. Likewise the GPT-5.6 variant names rendered
   by the captions as "GBT 5.6 Soul" and "GBT 5.6 Luna" never appeared on screen and should not be
   propagated in that spelling.

---

## 14. Boundaries

- **One week, one operator, one workload.** The evidence base is a single reviewer's week on
  knowledge work, research, document creation and video-adjacent tasks. It is explicitly not a
  hardcore software-development evaluation, and the source says so.
- **Out-of-the-box only.** No third-party plugins and no self-built plugins were installed, by
  design. The entire customization argument -- the harness's central selling point -- is therefore
  assessed from the settings surface and not from a single built artifact. The one thing that would
  most change the verdict is the one thing not tested.
- **Skills tested were foreign to the harness under test.** Every skill exercised was authored for
  Claude Code.
- **No hard measurements.** Every latency figure is a wall-clock impression or a single observed
  side-by-side; there are no repeated trials, no medians, no variance, and no controlled
  configuration. The one instant genuinely captured on screen is the 52-second mark of a single
  retrieval race.
- **Preview software, dated.** Both the reliability findings and the model catalogue are pinned to
  a developer preview as of 2026-08-23 and will decay quickly.
- **Vision-dependent work is excluded.** Anything requiring the agent to look at its own rendered
  output is bounded by the model in the slot, not by anything discussed here.
- **The verdict is explicitly personal.** "Does this replace Claude?" is answered No *for this
  reviewer's workload*, with the counter-case for product builders stated but not tested.

---

## 15. Value map: your environment

Assessed honestly against the work you have described in this session. Several rows are "no value
here", and those are the useful ones.

**Threaded-trie memtable performance track.** Direct and specific value in one place: the
configuration-control failure in section 7.1 is exactly the failure mode your own guardrails were
written against -- a comparison that fixes the headline variable (the model / the core) and leaves
a second variable (reasoning effort / the argument tail) unequal, then attributes the whole delta
to the intended cause. It is a clean external example of "two spellings of one config read as two
configs" and it cost the source its strongest quantitative claim. Worth keeping as a citable
instance. The DSH trajectory view is a second, weaker parallel to your artifact-plus-summary
discipline: typed, structured events that a prose summary cannot silently smooth over, and a
`TOOL_TIMEOUT` that only the structured view surfaced. No value at all in the harness itself --
your work there is C++ cores and a Python binding under a pinned interpreter, and a different chat
agent harness is orthogonal to it.

**CryptoML pipeline (crypto_ml_v2).** Moderate and indirect. The relevant intake is the harness
layer as a recorded variable: your cascade orchestration and multi-model advisor workflow (Opus
plans, Sonnet builds, Haiku runs bash) is itself a harness composition, and the source's finding
is that swapping that layer changes output character even with the model held fixed. That argues
for recording the orchestration configuration alongside the model id whenever you compare
generated artifacts across sessions. The cost intake also applies directly: cost-to-completion
rather than cost-per-token is the right unit for a cascade that fans out to subagents. Zero value
in the DeepSeek models themselves for this pipeline -- your constraint there is leakage discipline,
offset handling and checkpoint freshness, none of which a harness change touches, and introducing a
second harness into a pipeline with a leakage guardrail would add a large unaudited surface for no
gain.

**Agent orchestration and skill authoring generally.** The strongest transferable finding for you
is section 7.3: skills are harness-coupled and get re-interpreted on any harness or model change.
You maintain a substantial skill surface (`graphify`, `watch-video`, `watch-video-max`,
`video-autopsy`, the `cryptoml-*` family) plus hook-enforced behaviours. If any of those are ever
run under a different harness, expect silent reinterpretation rather than failure -- the divergence
observed here was two headers that both looked correct and specified different audiences. A cheap
mitigation matching how you already work: make the skill state its own invariants explicitly enough
that a drifted interpretation is detectable from the artifact, which several of your skills already
do via mandatory sections.

**Working style: guardrails, pre-registration, stamping.** Reinforcement rather than new
information. The source is a live demonstration of what the ledger discipline exists to prevent:
an interesting, well-observed comparison whose headline number cannot be quoted because nothing was
pinned before the run. Nothing to adopt.

**Daily routine.** Realistically none. You already have a working harness, a settled skill set and
enforcement hooks; installing a preview-grade harness would cost a day and, per the source's own
verdict, replace nothing. The one contingent case the source names that does map to you is the
spillover pattern -- a cheap model in a second harness for bulk knowledge work when approaching
limits -- but with the trajectory-view caveat that its output is the one he would *not* hand to a
client, which is the wrong trade for anything that lands in your governed docs.

**polymarket_agent, claude-doc-reader, worldsim_project.** No mechanism, no value. None of them
are bounded by the harness layer.

**Career / interview track.** Tangential but real: the taxonomy in section 1 -- harness versus
model as separately consequential layers, with concrete evidence that the wrapper moves the result
-- is a well-formed, defensible answer to an interview question about agent architecture, and it
comes with a numeric example and a named confound you can volunteer yourself. That last part is
worth more than the example.

**Deliberate skill-building.** The one habit worth importing is the mode-picker discipline: the
harness makes you choose, before every prompt, between a fully-loaded context injection and a
two-tool stateless agent. That is a decision you currently make implicitly. Asking "does this task
need the whole context surface, or would a stateless two-tool pass be faster and cleaner?" is
cheap, harness-independent, and directly relevant to a working style that routinely delegates to
subagents whose context is not yours.
