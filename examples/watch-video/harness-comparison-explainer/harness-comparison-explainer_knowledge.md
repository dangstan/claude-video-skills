SOURCE: "100 Hours Testing DeepSeek Harness vs Claude Code" (local file: 2026-08-23_100-hours-testing-deepseek-harness-vs-claude-code.mp4)
CHANNEL/PRESENTER: not stated verbatim in the transcript or in any on-screen chrome (no title card, no channel handle shown). The presenter's on-screen personal brand is a lit "AIS" sign and an "AI Native" book visible on his shelf [ON-SCREEN]. The presenter is self-referential: he describes "the video I made about the different levels of my AI second brain," and the DeepSeek Harness demo run later in this same video retrieves a file titled "Every Level of a Claude Second Brain Explained" [ON-SCREEN] -- so this is the same creator revisiting his own prior content mid-demo.
DURATION: 18:01 (1081.7s)
TRANSCRIPT: tier B (sidecar file already sitting next to the source video, `2026-08-23_100-hours-testing-deepseek-harness-vs-claude-code_transcript.txt`), produced by faster-whisper large-v3, verbatim, single continuous narrator (talking-head monologue with screen-share cutaways -- no diarization needed). No whisper re-run performed for this ingest.
TOPIC TAGS: DeepSeek Harness, agent harness architecture, Claude Code, Codex, harness customization, plugin systems, open-source agent tooling, coding-agent benchmarking

## Core thesis

DeepSeek Harness (package `@deepseek-ai/dsh`, tagline "Everything is a plugin") is an open-source, self-hostable agent harness -- distinct from any DeepSeek model -- that can run any model behind an OpenRouter (or other) API key, including Anthropic and OpenAI models. Its differentiator against closed harnesses like Claude Code and Codex is that every internal capability (tools, skills, sessions, sandboxes, storage, loop logic, scheduling, the UI itself) is a swappable/recomposable plugin rather than a fixed product surface. Tested head-to-head against Claude Code on identical prompts and the identical underlying model (Claude Opus 5), DeepSeek Harness was consistently and substantially faster at agentic retrieval/search tasks, while Claude Code produced deliverables the presenter judged more thorough and more trustworthy. The harness itself is free; only inference is billed. The source frames it as a genuinely promising but still-rough "developer preview" -- not a replacement for Claude Code, but a live proof that harness-level engineering (not just model quality) materially changes agent behavior on the same model.

## Concepts

### What DeepSeek Harness is (and is not)

DeepSeek Harness is an agent harness -- the orchestration layer that wraps an LLM with tools, loops, memory, and a UI -- from the DeepSeek team, released open source. It is explicitly analogous to Codex (OpenAI's harness) and Claude Code (Anthropic's harness): each harness natively promotes its own maker's models (Codex -> GPT models; Claude Code -> Claude models) but DeepSeek Harness is architected to run DeepSeek's own models (DeepSeek R1, DeepSeek V4 Flash, DeepSeek V4 Pro) AND any other provider's models added via API key -- Claude Opus, GPT models, Kimi, even Meta/Llama models [STATED]. This is not unique in kind (OpenClaw and Hermes Agent are cited as other open agent harnesses [STATED]) but DeepSeek Harness's specific claim is total internal openness: "every capability is a plugin" [ON-SCREEN, from the official DeepSeek Harness developer-preview landing page, headline "Everything is a plugin," subhead "DeepSeek Harness is now in developer preview for agent harness developers worldwide -- source code included. Every capability is a plugin that can be swapped or recomposed: models, tools, skills, sessions, sandboxes, storage, loops, scheduling, and the UI."].

Install command shown on that landing page [ON-SCREEN]:
```
npx @deepseek-ai/dsh web
```
This launches a local web UI (self-hosted, runs on localhost) [STATED]. The landing page also links "View on GitHub," "Developer docs," "Community plugins," and a "Cordis paper" [ON-SCREEN] -- the last suggesting an accompanying research paper (Cordis) describing the harness's design; not explored further in this video.

A useful mental model given verbatim by the presenter: a closed harness like Claude Code is "a car you can sit in, drive, and change the engine (swap models) -- but you can't move things around." DeepSeek Harness is the same car with "the seats, the steering wheel, everything" swappable -- you can change how the agent actually behaves under the hood [STATED].

### Model/provider setup

Settings > Models lets you register one or more providers by API key [ON-SCREEN]. The presenter's instance has two providers configured: "DeepSeek" (native) and "openrouter" (added via "+ Add provider"), each with Edit/Delete controls; a separate "+ Add a custom provider" button exists for anything not in the built-in list [ON-SCREEN]. Registering an OpenRouter key is what exposes the full catalog of non-DeepSeek models (Claude, GPT, Kimi, etc.) inside the harness [STATED]. As of this recording, DeepSeek Harness cannot natively bill against an existing Claude Pro/Max subscription or a ChatGPT/Codex subscription -- all non-DeepSeek-native usage is metered API billing (token-based) [STATED]. The presenter mentions unverified third-party plugins that claim to bridge a Claude subscription in, but had not tested one himself [STATED, unverified by presenter's own admission].

### The four operating modes

Selectable from a dropdown beside the workspace selector, before sending a prompt. Verbatim definitions read directly from the harness UI [ON-SCREEN]:

- **Standard mode** -- "Full coding agent with file editing, shell, file and web search, skills, planning, goals, subagents, and workflows." This is the default/most-used mode; it performs a context-injection step immediately on the first turn.
- **PTC mode** -- "All Standard mode capabilities, with tools exposed through the Code Mode SDK so the model can combine multi-step operations in one TypeScript program." The presenter compares this loosely to Claude Code's dynamic-workflow behavior, but stresses it's not the same mechanism; his framing is "big task, lots of stuff to run in parallel, multi-chain -> reach for PTC over Standard."
- **Minimal mode** -- "Two-tool coding agent with persistent bash and str_replace_editor." Deliberately strips context/ceremony for speed; the presenter's own words: "gets rid of some of the context and it just kind of executes faster... it's fast, it feels cheap." Confirmed on screen: asking "Hi, who am I?" in Minimal mode returns a generic answer with zero context injection ("You're the user I'm chatting with -- I don't have any personal information about you...") in 3.6s LLM time (1 turn, 1 step, 41 tok/s, cache hit 94%, input 1.4K tok / output 96 tok) [ON-SCREEN].
- **Creator mode** -- "Built for creating custom agent presets, with all Standard mode capabilities plus runtime inspection, plugin experiments, and preset-authoring guidance." This is the mode for building new plugins/presets for the harness itself, not for normal task work.

### Context injection (Standard mode) vs no injection (Minimal mode)

In Standard mode, the very first turn triggers automatic context loading before the model answers, visible as three explicit "Context injection" chips in the trajectory log [ON-SCREEN]:
1. `AGENTS.md, CLAUDE.md, CLAUDE.local.md` -- i.e. it reads the SAME agent-instruction files Claude Code would read in a project.
2. `@deepseek-ai/dsh-system-prompt` -- the harness's own system prompt.
3. `skill-catalog` -- the available skills index.

This is the mechanism behind the presenter's claim that switching harnesses "didn't require changing anything" to keep using his existing Claude-authored skills and CLAUDE.md context: DeepSeek Harness in Standard mode reads the exact same convention files. In Minimal mode this injection step is skipped entirely -- confirmed by the "Hi, who am I?" test above returning zero personalization.

### Live per-turn performance telemetry (UI feature)

Every response in DeepSeek Harness's chat view ends with a compact stats line, e.g. `1 turns - 1 steps | LLM 3.6s | TTFT avg 1.3s - 41 tok/s | Cache hit 94% | Input 1.4K tok - Output 96 tok` [ON-SCREEN]. On multi-step tool-using turns this expands, e.g. `1 turns - 5 steps | LLM 20.7s - Tool call 33.4s | TTFT avg 1.6s - 88 tok/s | Cache hit 65% | Input 222K tok - Output 1.1K tok` [ON-SCREEN]. This telemetry (time-to-first-token, tokens/sec, cache-hit rate, input/output token counts, wall time broken into LLM-time vs tool-call-time) is surfaced directly in the chat UI on every turn -- not something the narration calls out verbally, but visible on nearly every screenshot of the product. [INFERRED: this is a meaningful UX differentiator worth noting independently of the narration, since neither Claude Code's nor Codex's default chat UI surfaces this level of per-turn cost/latency breakdown inline.]

There is also a dedicated **Trajectory** tab (alongside Chat) per session, showing a granular, colored step-by-step timeline (system prompt, user turn, each CONTEXT/TOOL/ASSISTANT event individually, with the exact tool call and its result) [ON-SCREEN], and a "Session log" download button to export the full run.

### Customization surface (Settings > Plugins)

Settings has four sections: General, Models, Plugins, Agent presets [ON-SCREEN]. Plugins has two tabs: "Plugin configuration" and "Plugin list." Plugin configuration exposes, at minimum:
- **Shell** -- "Limits every command the agent runs."
- **Agent loop** -- "How the agent dispatches tool calls."
- **Web search** -- provider selector (defaults to "The DeepSeek search provider," but can be swapped).

Each is independently expandable/editable [ON-SCREEN]. The presenter frames this as effectively unmatched relative to Claude Code or Codex: "it's not even close... it's way in a different league" -- because in a closed harness you can only swap the model, whereas here you can rewrite the shell policy, the tool-dispatch loop, the search backend, or add arbitrary community-built plugins from GitHub. He explicitly declined to demo any third-party or self-built plugins in this video, wanting to show default/out-of-the-box behavior only, and separately warns: **security caution** -- since plugins are open-source community contributions, have Claude Code or Codex review any third-party plugin's source before installing it, because you don't know what a random open-source plugin might do [STATED].

### Reliability and known rough edges (developer preview)

The product literally self-labels "DeepSeek Harness developer preview" on its own landing page and inside the app ("Preview" badge next to "Into the Unknown," the default new-session placeholder screen) [ON-SCREEN]. Concrete failure modes observed by the presenter during roughly a week of use:
- Full stops / crashes requiring restart.
- A mouse-lock bug: the OS mouse cursor became constrained to a small square region of the screen; the presenter had to ask Codex (a different tool) to help diagnose/fix it, suspecting at first he'd been compromised.
- A UI click bug: clicking into Creator mode instantly bounced back to Standard mode/the home screen, requiring an app restart to actually reach Creator mode. Captured on screen as a rapid flicker between the mode landing page and back [ON-SCREEN].
- Long-session degradation: "compaction bugs and context regressions" -- the model losing track of earlier conversation state during extended sessions, which the presenter partly attributes to genuinely deliberately stress-testing context-rot territory, and partly concedes could be user error.

### Cost model

Verbatim summary (presenter's own words, also captured on his live whiteboard recap) [STATED + ON-SCREEN]: "The harness is completely free. You could run this harness 24/7 with a free model and never get charged -- but for inference, that's not free." DeepSeek's own models (V4 Flash, V4 Pro) are described as cheap and solid; Flash is cheaper, Pro is described as "also really good." Both DeepSeek models are text-only -- **no vision/screenshot capability** -- which the presenter identifies as a real limitation for anything design/UI-related, because Claude Code and Codex can screenshot their own output, look at it, and iterate, closing a verification loop that a text-only model cannot close on its own. (This is a model limitation, not a harness limitation -- swapping in a vision-capable model via the harness's plugin/provider system would presumably remove it, though this is not tested in the video.)

On raw token cost: cheap tokens are not the same as cheap completions. Verbatim: "if it's not an efficient harness, or if the model is so bad that it's not running efficiently, then ultimately that's not really that cheap... it's also about efficiency and cost-to-completion rather than just cost-for-tokens." The presenter's own whiteboard recap states this as: "Cheap but inefficient tokens = not really cheap" [ON-SCREEN].

## Head-to-head test 1: identical-prompt retrieval speed (DeepSeek Harness vs Claude Code, same model)

Setup: the exact same prompt was sent at the same time to DeepSeek Harness (web UI, Standard mode) and Claude Code (desktop app, workspace "Herk-2.0"/master branch), **both running Claude Opus 5** (High effort in Claude Code) -- isolating harness efficiency as the only variable [ON-SCREEN, confirmed by the model badges on both panes]. Prompt (verbatim, [ON-SCREEN]): *"Can you find me my YouTube transcript for that video I made about the different levels of my AI second brain? then just give me a quick two sentence summary about that video."*

DeepSeek Harness's trajectory, in order [ON-SCREEN, read from the Trajectory tab]:
1. Context injection: AGENTS.md/CLAUDE.md/CLAUDE.local.md, dsh-system-prompt, skill-catalog.
2. `glob` on `OtherWorlds/youtube-o[s]/transcripts/**/*` -> timed out (TOOL_TIMEOUT).
3. `grep` for a "second brain" pattern -> found 2 matches in a `raw/` transcript folder (not it).
4. `pwsh Get-ChildItem` listing the vault directory -> no obvious "second brain" title.
5. Two more `grep` passes widening the pattern (`(second br...|levels of|level one)`, then `(?i)second.brain`) -> found matches in a `references` folder, then 250 of 314 matches in a broader project transcript store.
6. Located and read the real file: `projects/claude-code-second-brain-levels/transcript/transcript-timestamped.txt` (582 lines, with timestamps); also found sibling `.txt` (plain) and `.json` (structured) versions of the same transcript.
7. Correctly extracted the published title, **"Every Level of a Claude Second Brain Explained,"** and delivered a two-sentence summary.

Final run stats [ON-SCREEN]: 1 turn, 5 steps, LLM time 20.7s + tool-call time 33.4s (~54s wall total), TTFT avg 1.6s, 88 tok/s, cache hit 65%, input 222K tok / output 1.1K tok.

Claude Code, at the matching elapsed-time checkpoint (captured mid-run, same wall-clock window as DeepSeek Harness's finish) [ON-SCREEN]: status line read "52s - 158 tokens - 1 running task - Running tools..." with visible intermediate reasoning "No obvious match there. Let me search wider" / "Searching repo for second brain references" -- i.e. still actively searching at the moment DeepSeek Harness had already completed and delivered the answer.

The presenter's broader claim, stated multiple times across several repeated trials (not just this one capture): DeepSeek Harness "blew Claude Code out of the water... one minute in DeepSeek and five-plus minutes in Claude Code," and that this pattern held "every time," including for parallel sub-agent research tasks [STATED -- the multi-trial "every time" and "5+ minutes" figures are the presenter's aggregate claim across sessions not shown on screen; only the single ~54s-vs-still-running capture above is directly [ON-SCREEN]-verified in this video].

## Head-to-head test 2: Excel deliverable from vague prompt (same model, same data)

Both harnesses were given the identical vague prompt -- verbatim: "create me an Excel sheet showing me the data" -- against the presenter's own YouTube channel analytics, deliberately without extra guidance on what to prioritize (to see default behavior under ambiguity).

DeepSeek Harness's output (Opus 5 under the hood) returned in about 3 minutes; Claude Code's equivalent took about 17 minutes [STATED]. Qualitative comparison [STATED]:
- DeepSeek Harness version: simpler, color-coded columns (views, engagement rate; top/bottom highlighting), a "top 10 by views" chart (unlabeled bars, correlated to a table alongside it), a monthly-trend chart, a tag-analysis section, notes/sources -- "easy to interpret... not word vomit."
- Claude Code version: wordier, more tabs, covered all 467 videos (vs a partial set), included top 50 (not just top 10), a "last 90 days" drill-down, more specific analytics -- but no color coding. Presenter's verdict: "as far as quality, [Claude Code] was a better output," though "a bit word vomit."

A workbook screenshot [ON-SCREEN] shows the actual structure used in this segment: tabs `Summary | Videos | Top & Bottom | Monthly Trend | Tag Analysis | Notes & Sources`; the Summary tab has a HEADLINE METRICS block (videos published, total/median/average views, best/weakest video views, engagement/like/comment rate, publish cadence), a FORMAT SPLIT table (Shorts vs Long-form), and a CHANNEL CONTEXT block (lifetime subscriber/view/video totals), with a footer legend distinguishing values read directly from source JSON (blue) vs Excel-formula-derived values (black). This structure exemplifies the kind of deliverable-formatting skill both harnesses were exercising, not a DeepSeek-Harness-specific capability.

Presenter's explicit caveat: this was a **vague** prompt by design; a more specific prompt with stated pain points would likely have produced more comparable, more tailored outputs from both sides.

## Head-to-head test 3: identical custom skill ("storm research") on both harnesses

Both harnesses were pointed at the presenter's own pre-existing "storm research" skill and asked to produce a report on "the effects of sugar on the body." Because both followed the same skill definition, the two outputs share visual structure (both use the same section template) [STATED]. One captured output [ON-SCREEN] is titled **"STORM RESEARCH -- V2 (VERIFIED): The Effect of Sugar on the Body"**, described as "a five-lens synthesis: practitioner, academic, skeptic, economist, and historian. Every claim independently checked against its primary source before publication," dated 23 August 2026, with a verification banner: "26 sources listed, 25 independently checked against primary sources... Result: 8 confirmed clean, 13 corrected, 2 demoted, 2 figures untraceable to any primary source, 1 carried as an unverified lead." A body section, "The Hidden Connection," reconciles conflicting findings between pooled isocaloric-swap trials (near-null effect) and tightly controlled pediatric studies by Schwarz and Lustig (sugar cut from 28% to 10% of energy, gram-for-gram starch substitution, improvements in liver fat/lipogenesis/insulin/blood pressure/triglycerides within 9 days) by pointing out they sampled different populations at different doses -- concluding "sugar is neither poison nor merely calories: it is a dose-dependent metabolic stressor." [ON-SCREEN reads as one of the two comparison outputs; based on its stated source count of 26 -- which matches the count the narration attributes to the Claude Code output, see below -- this specific captured page is most likely the **Claude Code** output rather than the DeepSeek Harness one; flagged as inferred, not confirmed by an on-screen harness label.]

Quantitative comparison [STATED]: Claude Code's version ran about 5,000 words with 26 sources; DeepSeek Harness's version ran about 4,400 words with at least 14 "load-bearing" sources (22 found in total). Qualitative comparison [STATED]: Claude Code's report skewed more scientific/in-depth and more conservative in how it stated findings; DeepSeek Harness's skewed toward practical/relatable framing, and was at points "too confident" -- the presenter cites one specific claim he personally disagreed with. Overall trust verdict: the presenter would hand the Claude Code output to a client or team over the DeepSeek Harness one.

**Important confound the presenter names explicitly**: the "storm research" skill itself was originally authored/tuned for Claude Code. Skills are interpreted differently across models/harnesses, so a DeepSeek-Harness-native version of the same skill would likely perform meaningfully better and faster on that harness. This head-to-head is therefore a test of "an existing Claude-tuned skill ported as-is to a new harness," not a clean test of the harnesses' ceiling capability.

## Verdict: does DeepSeek Harness replace Claude Code?

Presenter's explicit answer: **no**. Reasoning given [STATED]:
1. For "deep, deep" work, Claude Code's harness "is going to have your back" -- implying maturity/reliability edge for serious/production work.
2. Subscription economics favor Claude Code for Opus usage specifically: using Opus through a Claude Code subscription is described as "a way better bang for your buck" than paying API rates for Opus through DeepSeek Harness.
3. The presenter's own daily work (video editing, research, knowledge work, document creation) has never surfaced a gap in Claude Code/Codex that made him wish for harness-level customization -- he frames DeepSeek Harness's core appeal (deep harness customization) as mainly valuable to "hardcore developers... building products" who hit real day-to-day pain points with fixed harness behavior.
4. He is explicit that DeepSeek Harness is "not a free Claude Code" -- it is a free, fully open **harness** that happens to let you plug in cheap or free models; conflating "free harness" with "free Claude Code" is called out directly as a misconception to avoid.

Despite the "no," the presenter frames the broader trend positively: the excitement around DeepSeek Harness signals a shift toward everyone eventually running fully custom, self-built harnesses, and that when something breaks or annoys you, the DeepSeek Harness answer is "switch to Creator mode, let's build a fix/plugin for this" -- a self-repair loop that closed harnesses structurally cannot offer.

## Insights and intakes

- The clean way to attribute a behavior difference between two agent products running the identical model is to control for the model and vary only the harness -- this video's strongest evidence (the identical-prompt speed test) does exactly that, and is the most trustworthy claim in the source because it is directly reproducible and was captured on screen rather than merely summarized [INFERRED, methodological observation].
- A harness that reads the same convention files another harness reads (AGENTS.md/CLAUDE.md/CLAUDE.local.md) means existing prompt-engineering investment (a CLAUDE.md, a skills library) is NOT harness-locked by default, at least for Standard-mode DeepSeek Harness -- portability of context files across harnesses appears to be real, though skill *performance* still degrades when the skill was tuned against a different harness/model pairing (see the storm-research test).
- Per-turn cost/latency telemetry inline in the chat UI (TTFT, tok/s, cache-hit%, input/output token counts) is a UX pattern that materially helps a user reason about whether a slow response is a network/API problem, a cache-miss problem, or genuinely heavy tool use -- most closed harnesses hide this by default.
- "Cheap tokens" and "cheap completions" are different claims; token price alone is a misleading proxy for total cost without also accounting for tokens-to-completion and time-to-completion.
- Vision/screenshot capability is a hard requirement for any workflow that needs visual self-verification (UI/design work); a harness's flexibility cannot substitute for a model capability the underlying model lacks.

## Corrections

The following are ASR (automatic speech recognition) errors in the Tier B whisper transcript, corrected here so a reader/ingesting agent does not propagate them:

- The product is **"DeepSeek Harness"** (correctly transcribed most places in the source transcript), not "Deep Sea Karnas" as it was mistranscribed once, around the 02:33 mark.
- **"Claude Code," "Claude Opus," "Claude Fable"** (Anthropic's actual product/model names, confirmed directly on screen in the harness UI, e.g. the model selector literally reads "Claude Opus 5") are consistently mistranscribed throughout the source as "Cloud Code[s]," "Cloud Opus," "Cloud Fable" -- a straightforward homophone ASR error ("Claude" heard as "Cloud"). Every instance of "Cloud" in the raw transcript referring to a coding harness or Anthropic model should be read as "Claude."
- **"AIOS"** (the presenter's own personal "AI Operating System"/knowledge base, referenced repeatedly as "my AIOS," matching the on-screen "AIS" branding and his self-referential retrieval demo) is mistranscribed as "iOS" (Apple's mobile operating system) at several points (e.g. ~05:23, ~11:38). Apple's iOS makes no sense in context ("I plugged it into my iOS and didn't have to change anything," "I've got a huge wiki in here, this is my AI operating system"); "AIOS" is the correct reading.
- The two model names transcribed as **"GBT 5.6 Sol"** and **"GBT 5.6 Luna"** (~00:11-00:12) are near-certainly a mis-transcription of spoken "GPT" (whisper rendering "GPT" phonetically as "GBT"); the specific model generation/names intended could not be confirmed from on-screen evidence in this video and are left as uncertain rather than corrected to a specific guess.
- A block of text in the raw transcript at ~17:37-17:50 ("...at least 14 that were considered load bearing... I believe... [contradiction resumes]... and then we had deep sea harness with 14, at least 14 that were considered practical...") contains a near-duplicate repeated clause, characteristic of a whisper repetition artifact rather than the speaker repeating himself twice; read as a single statement (DeepSeek Harness: at least 14 load-bearing sources of 22 found total, framed as "practical").

## Boundaries

This video is a single presenter's subjective week-of-use review, not a controlled benchmark suite: sample sizes for the "every time DeepSeek was faster" claim are not shown (only one trial is captured on screen in full trajectory detail); cost figures in absolute currency are never stated (only relative/qualitative cost claims); no information is given about DeepSeek Harness's security model, sandboxing guarantees, or how community plugins are vetted beyond "be careful, have another AI review it first"; nothing is said about Windows/Mac/Linux platform parity (the captures show a Windows environment, `C:\Users\...`, PowerShell); no mention of team/multi-user features, CI integration, or non-interactive/headless use; and the video explicitly declines to evaluate the plugin ecosystem itself (no third-party or self-built plugins are demoed). Anything about DeepSeek Harness's behavior under those uncovered conditions is out of scope for this source.

## Value map: your environment

*[Section redacted for publication. In a real run this section maps every concept in the video against the operator's own projects, tooling and standing practices -- per-concept relevance verdicts ending in adopt / borrow / ignore actions. It is inherently personal, so the published example withholds it.]*
