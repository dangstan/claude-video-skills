# Multiplayer AI Agents: Shared Context, Memory, and Routines (Flo Crivello / Lindy AI)

Source: podcast conversation between host David Ondrej and Flo Crivello (founder/CEO of Lindy AI,
a "multiplayer agentic scaffold"; previously worked in Uber's self-driving group). Local file
`2026-08-10_ex-uber-dev-explains-his-multi-agent-workflow.mp4`, duration 45:24. No further
platform metadata (title/channel/upload date) was embedded in the file or discoverable without a
source URL.
Topic tags: multiplayer AI agents, Lindy AI, shared team context, agent memory, Claude Code
personal setup, AI-native company building, sponsor segment (DeepAPI).
Transcript: tier A (user-supplied path), a verbatim faster-whisper large-v3 transcript reused from
a prior ingest run found in the output directory (originally produced under
`2026-08-10_ex-uber-dev-explains-his-multi-agent-workflow_transcript.txt`); whisper was NOT
re-run for this pass. Ingest cost for this pass: 2725 base frames read at 1 fps, ~46-frame coarse
visual sweep plus ~24 finer-grained frames and 5 zoom crops around 3 screen-share windows
(00:03:00-00:06:00, 00:09:00-00:10:30, 00:19:50-00:21:10); no whisper compute spent.

## Core thesis

Individual ("single-player") coding agents such as Claude Code and Codex already work well; the
next competitive edge is "multiplayer" AI -- agents that share context (memory, files, skills,
integrations) across a whole team the same way humans already collaborate through Slack or Google
Docs, instead of everyone hand-configuring an isolated agent and passing files/HTML exports back
and forth. Whoever builds the system that becomes the durable "nexus" for a team's accumulated
context wins disproportionately, partly because switching costs rise and partly because being the
established first mover gets that tool's patterns baked into the training data of future model
generations. For both individuals and companies, the argument is that model capability is no
longer the bottleneck -- adoption speed and willingness to "break things" while learning are.

## Concepts

### 1. Single-player vs. multiplayer AI agents

Single-player: each person runs their own isolated agent (Claude Code, Codex, ChatGPT) on their
own machine with no shared state across teammates. Multiplayer: an agent embedded in a shared team
surface with five components the speaker names explicitly: an agent, integrations/tools/actions
shared across the team, a team computer/file system, a team memory, and team skills, all reachable
through a team surface such as Slack (src 05:26-06:19). The stated problem multiplayer solves is
that current collaboration tools (Slack, Google Docs, GitHub) were built pre-agent, for humans
only, so today teams work around the gap by manually forwarding HTML files and other AI output
back and forth on Slack -- "it's a mess" (src 01:26-01:35).

Lindy's own product surface, read directly from its sidebar [ON-SCREEN]: Home, Chat, Meetings,
Files, Routines, Skills, Agents, Integrations.

### 2. Automatic context hydration / self-building company wiki

A memory system that updates itself from ambient signal (Slack history, meeting transcripts)
instead of requiring a human to write and maintain a wiki. Flo's stated critique of wikis: "the
moment you write a wiki, it's out of date" (src 09:08-09:11). Lindy's agent is described as having
scanned "something like 20,000 messages" of the team's historical Slack workspace [STATED,
src 09:36-09:40], continuously ingesting new meetings and emails to keep a "master memory file"
current.

On-screen file layout of the memory store [ON-SCREEN, captured at ~09:20-09:30]: a `.memory`
folder (toggle between "Personal" and "Team" scope) containing a `references` subfolder,
`.index.md`, `memory.md`, and `memory2.md`.

The onboarding/profile view titled "Here's what I'm learning about you, Flo" [ON-SCREEN, captured
~09:40-09:50] states: "I pulled this from your team's Slack. This gives me a head start, and you
can correct anything just by telling me." Each bullet carries an inline edit icon. Exact bullets
captured:
- "You're focused on the teammate experience. You're shaping how new customers connect Slack,
  learn what Lindy found, and get value before onboarding ends."
- "You turn messy product questions into concrete decisions. You pull engineering, design, and
  go-to-market context into one clear next step."
- "You work most closely with Bruno, Jonathan, and Marvin. Bruno is your main partner on Slack
  behavior; Jonathan shows up around infrastructure and reliability."
- "Slack hydration is your most active initiative right now. The work connects onboarding, memory,
  admin tooling, and the first message Lindy sends to a team [...]" (line ran off-frame)

The same panel showed a force-directed relationship graph (colored nodes/edges) beside the bullets
and a partially legible caption reading approximately "Skill learning: 1,264 messages and 35
channels reviewed" [ON-SCREEN, low confidence on exact digits due to frame legibility].

Rationale given for why this matters more than raw intelligence: humans are unreliable narrators
of their own meetings -- "it's literally like in court, eyewitnesses are the least credible source
of information" (src 10:56-11:00) -- so distilling many meetings/messages is reframed as a task to
delegate to agents rather than to memory.

### 3. Context-in-place beats re-explaining

Invoking an agent inside an existing conversation thread means it inherits the thread's prior
context instead of the user retyping the prompt. Live example narrated on screen: a teammate
asked on Slack "do we allow free users to use Lindy Teammate via Slack?"; Flo replied by
@-mentioning the agent into the same thread ("add Lindy"), and it found a relevant billing
document without being re-prompted from scratch (src 06:59-07:29). [Transcript ambiguity: the
speaker's line "It wasn't Lindy, it was Jeremy" (src 07:30) suggests the teammate's name in this
anecdote is uncertain -- treat as unverified detail, not load-bearing to the mechanism described.]

This generalizes into ad hoc "catch me up" queries against the ingested history. Exact captured
exchange [ON-SCREEN, src ~10:07-10:21]:

```
Flo: @Lindy catch me up on the highlights from Lindy teammate onboarding calls this week

Lindy: Design partners are genuinely excited -- Owen called the shared meetings feature
"beautiful" [...] routines and folders live on the call. The enthusiasm is real, not polite.

"Chat with 50 meetings" is a standout hit -- [a named partner] called it her favorite feature,
and [partners] draft investor updates. No competitor has this.

Skills and routines are landing exactly as intended -- multiple partners flagged Skills as
"the fir[st] [...]" a skills marketplace is already generating excitement before it's even
fully built.

Security guardrails unlocked enterprise conversations -- the new per-app approval controls
[...] understood the value. This is the feature that gets Lindy past IT security reviews.

Memory and context are wowing people -- partners confirmed their memory files looked
accu[rate] [...] team member's Lindy can access is resonating strongly with team leads.
```
(Right edge of the screenshot was cropped by the frame; ellipses mark where text ran off-screen.)

### 4. Routines: productized recurring automations

Pre-built and user-authored recurring automations, individually toggle-enabled, organized under
Personal / Workspace / Discover tabs [ON-SCREEN, captured ~20:00-21:10].

Built-in routines shown: "Daily briefs" (Prepares you for your day), "Meeting note taking" (Joins
your meetings and takes notes), "Email alerting" (Alerts you to time-sensitive emails); partially
visible in the cropped right column: "Email drafting", "Meeting prep", "Follow-up bumps".

Custom (user-authored) routines shown: "Weekly AI authors research and outreach" (Research
independent AI blog authors, and manage recruiting outreach with follow-up timers), "Check UXR and
onboarding calls" (Check tomorrow's calendar for UXR and assistant onboarding calls, then text Flo
to confirm sending...), "On-call issues human redirect" (shown toggled OFF); partially visible:
"Weekly ... score", "Weekly ... digest".

Flo's narrated personal routine stack (src ~20:04-21:46): a daily brief delivered by text; an
agent that drafts email replies; an agent that labels incoming email; an agent that takes meeting
notes and preps him before meetings (it messaged him about the guest's likely topics right before
this recording); a personal iMessage number he texts all day, including food photos, which an
agent logs and turns into a weekly "score" text; a weekly search for indie blog posts written by
engineers, used as a recruiting-sourcing signal, with the agent proposing who to reach out to; and
a routine that intercepts high-value signups (his example: a CEO-level signup) and offers to draft
immediate personal outreach within about 20 minutes of signup.

### 5. Agents can self-provision integrations they were not given

[STATED, not verified on screen] A teammate asked the Lindy agent to build an audio ad using the
11 Labs (ElevenLabs) API. An official ElevenLabs integration already existed for the platform but
had not been added to that specific agent. Rather than calling the "search integrations" tool to
request it, the agent wrote and saved its own Python script that called the ElevenLabs API
directly, asked the team for an API key, and stored the key using a built-in secrets manager
(src ~17:24-18:08). Framed as evidence that integration-count moats (the historical selling point
of tools like Zapier, n8n, Make.com) weaken once an agent with a general-purpose computer and file
system can write its own integration code on demand (src ~17:00-17:09, ~18:59-19:22).

### 6. The "nexus" race and training-data lock-in

Whichever product first accumulates a team's context, skills, and integrations becomes hard to
displace: switching costs rise, and being the established first mover gets that tool's usage
patterns baked into the training data of subsequent model generations, which then default to
recommending it -- drawn as an analogy to today's default AI-coding tech stack recommendations
(src ~30:26-30:51). [STATED / speaker's own inference, not independently verified.]

### 7. "Work on the machine, not in the machine"

Reframes the human's job under heavy agent automation as building/tuning the agentic system rather
than personally executing tasks, citing Ray Dalio's "Principles" ("don't work in your company,
work on your company") as the analogy applied to agent orchestration (src ~34:14-34:27).

[STATED, attributed to a "Listen Labs" tweet, not independently verified, src ~34:32-34:47] An
intern-built app reportedly paired a coding agent with a separate "user research agent" that
continuously gathers user feedback and feeds change requests back to the coding agent, making the
app largely self-improving.

Speaker's prediction: within "a year or two," agents will be capable enough to optimize the
machine themselves, reducing the human's role to something like a passive shareholder collecting
dividends (src ~34:56-34:65). [STATED, speculative.]

### 8. Company-building mindset under fast model iteration

Advises founders/operators to run in "let a thousand flowers bloom" mode -- tolerate duplicated,
chaotic per-engineer agent workflows (his example: multiple engineers independently building their
own PR-review agents on top of a company PR-review agent) rather than prematurely standardizing,
on the theory that useful patterns emerge from that chaos through natural selection once tooling
stabilizes (src ~25:37-26:11).

Concrete adoption bar stated: at least 20 hours/week hands-on-keyboard personally using AI systems
and "making a mess," framed via a shoe-factory / industrial-revolution analogy ("you can keep
doing what you were doing and it's going to be very tidy and you're going to die, or you can move
on to the new way and it's going to be an absolute mess") and via the speaker's account of his
father's magazine-publishing business surviving the early-2000s internet transition by rebuilding
rather than protecting the status quo (src ~28:27-29:38, ~30:56-31:05).

Two variables the speaker says now separate teams (src ~30:06-30:10): (1) skill/vocabulary to
command agents effectively, and (2) ability to afford the token spend that larger, more capable
models require.

### 9. DeepAPI sponsor segment (promotional -- weak trust)

A paid product placement for DeepAPI (deepapi.co), pitched as a single API key giving an agent web
scraping, deep research, browser automation, and its own email address. Demoed tasks (both
self-reported, unverified): (a) compiling 100 licensed general contractors in Austin, TX from
state licensing records into a markdown table, described as a ~30 minute run; (b) checking 24-hour
news/sentiment for 8 named stock tickers (Nvidia, Tesla, AMD, and others the narration did not
enumerate) and emailing the results, described as a ~4 minute run. On-screen dashboard figures
[ON-SCREEN, partially legible]: "$149.9352" total spend, "3,869" total requests, "99%" success
rate, and a "Top capabilities" panel listing endpoints including Web Search, Deep Research (billed
in narration as "better than Perplexity" [STATED]), Scrape, and Email. Tag prominently: these
numbers are presented by the video's own paid sponsor and are not independently verified.

## Insights and intakes

- The transition from single-player to multiplayer AI tooling is framed as directly analogous to
  the historical shift from emailing document attachments back and forth to real-time
  collaborative editing (Google Docs) -- the argument is that most AI agent workflows are
  currently stuck at the "emailing attachments" stage (src 00:37-01:04).
- "99% of slop comes from humans, not AI" -- the framing is that AI faithfully executes bad
  instructions, so the actual bottleneck is knowing what a good product looks like; the speaker
  predicts even that judgment layer becomes agent-automatable soon (src ~32:49-33:07).
- Intelligence is described as "slightly overrated" relative to context: a maximally intelligent
  but context-free participant (the speaker's example: inviting John von Neumann into a meeting
  with zero company context) is described as less useful in the moment than an averagely
  competent teammate who has full context (src ~13:13-13:41).
- Predicted decline of the web front-end: since front-ends exist to be used by humans, and the
  speaker expects a shrinking human role in a future "knowledge economy," natural-language/voice
  interaction with agents is framed as displacing UI-driven interaction (src ~05:02-05:20,
  ~42:56-43:00).
- Infrastructure (compute/hardware, plus "hardware and bio") is argued to be a structurally
  healthier investment category than the application layer going forward -- partly because
  software businesses are quick to spin up (weak moats), and partly because very large investors
  specifically need capital-intensive, comparatively low-risk places to deploy large sums
  (src ~43:40-45:07).
- Two contrasting company-scale outcomes are named side by side as a control case for the "how
  matters more than what" claim: a solo indie developer described as running roughly a
  20-person-startup's worth of output through fast build-commit-push-deploy habits, reportedly
  reaching "seven or eight million ARR" alone [STATED, unverified] (src ~41:54-42:22), versus named
  applicant-tracking-system vendors described as being "in trouble" because their product category
  (a CRM-like ticket tracker) has little value once agents can do the underlying work directly
  (src ~44:24-44:31).

## Corrections

- The transcript renders a name as "Ray Keltzweil" (src ~35:58-36:00). This is almost certainly
  Ray Kurzweil, the futurist and author of "The Singularity Is Near" -- most likely a
  speech-to-text transcription artifact rather than the speaker's own error, noted here so the
  name is not propagated incorrectly.
- The speaker states: "Lotus Notes is a $1 billion a year business for IBM right now" (src
  ~31:45-31:52). This is inaccurate as stated: IBM divested the Notes/Domino product line to HCL
  Technologies in a deal that closed in mid-2019, reportedly for a purchase price around $1.8
  billion -- a one-time acquisition transaction, not an IBM annual recurring-revenue figure. The
  product has been marketed as "HCL Domino" since that sale and has not been an IBM-owned line of
  business since 2019. (Confidence: high that IBM no longer owns/operates it as of the sale; this
  document does not independently verify HCL's current recurring revenue for the product.)

## Boundaries

- This is a two-person conversational podcast, not a tutorial: it contains almost no
  step-by-step technical instructions for building a multiplayer agent system. Screenshots show
  Lindy's UI surface but not its configuration or setup steps.
- Claims about Lindy's own product (memory accuracy, integration self-provisioning, adoption
  numbers, the "20,000 messages" ingestion figure) come from Lindy's own founder/CEO on a podcast
  where he is actively promoting the product. Treat as STATED, not independently verified.
- Contains a paid third-party sponsor segment (DeepAPI, Section 9) whose performance numbers are
  self-reported by the sponsor.
- Does not cover pricing, security/compliance specifics, or implementation details of the
  "multiplayer agent" product being teased as forthcoming "in a week" at recording time (src
  ~05:55-05:56) -- likely the product whose Routines/Files/memory screens are demonstrated later,
  but this is not stated explicitly on screen or in narration.
- No coverage of specific engineering/coding techniques, prompt patterns, or Claude Code
  configuration beyond one passing remark: the speaker says his own CLAUDE.md is "basically empty,"
  he uses a handful of MCPs, and otherwise relies on one large personal "agent folder" for all
  projects rather than per-project configuration (src ~19:11-19:32).
- Does not cover how "team memory," "team skills," or "team file system" are actually
  provisioned, permissioned, or kept consistent across multiple simultaneous human editors --
  the demo shown is single-user (Flo's own "Personal" scope), not a multi-editor team scenario.

## Value map: your environment

*[Section redacted for publication. In a real run this section maps every concept in the video against the operator's own projects, tooling and standing practices -- per-concept relevance verdicts ending in adopt / borrow / ignore actions. It is inherently personal, so the published example withholds it.]*
