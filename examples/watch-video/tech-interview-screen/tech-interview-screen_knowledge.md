# Lead AI Engineer screening round -- the Company, August 2026

Source: local screen recording `[recording filename redacted]`, about 31 minutes, Google Meet, two
participants (the recruiter, the Company; the candidate) plus a notetaker bot. Transcript:
faster-whisper large-v3 (tier D, last resort -- no supplied transcript, no
sidecar, no platform caption source for a local file). Topic tags: hiring-pipeline,
ai-engineering-studio, contractor-comp, multi-agent-orchestration, rl-data-production,
retrieval-augmented-generation.

SCOPE NOTE. This document records the INFORMATION exchanged in the conversation: what the
Company is, what the role is, what the hiring process consists of, and the technical practice the
candidate described. It contains no analysis of how anyone sounded, no talk-time or pace
measurement, no diarization, and no behavioural read -- that class of work belongs to the
`video-autopsy` package and was deliberately not performed here. Speaker attribution below comes
from the on-screen Google Meet caption panel, which labels every line with a speaker name, not
from any audio diarization.

Provenance tags used throughout: `[ON-SCREEN]` read from pixels (the Meet live-caption panel is
burnt into the recording and labels its speakers); `[STATED]` spoken and captured in audio only;
`[WEAK]` a participant relaying a secondary or AI-generated source; `[INFERRED]` this pipeline's
own synthesis.

---

## Core thesis

The Company is a small, bootstrapped AI engineering studio and startup
incubator hiring a Lead AI Engineer into a small AI team, where the lead title is
deliberately not a management track: sixty percent of the role is hands-on engineering and the
remaining forty is client-facing scoping and decision-making. Its hiring pipeline is six stages
deep and front-loads written reasoning over live coding. The technical substance the candidate
brought to the round -- a layered Claude Code orchestration pattern with a hard context ceiling, a
retrieval pipeline benchmarked across local models, and a reinforcement-learning data-production
workflow -- is reference material in its own right and is documented below independently of who
said it.

---

## The Company: profile

**What it is.** An AI engineering studio and startup incubator that both builds products for
external clients and launches new companies of its own `[ON-SCREEN]`.

**Founding and funding.** Founded in the early 2020s, self-funded, without outside investment
`[STATED]`. The stated consequence of bootstrapping is decision autonomy: the founders own
the company and set direction on what they judge best for it, which the recruiter framed as
freedom and autonomy paid for with correspondingly more responsibility `[STATED]`.

**Size and distribution.** A few dozen people split across two countries, fully remote,
gathering in person at least once a year at an offsite or a shared event `[ON-SCREEN]`.

**Clients.** Startups and companies in the United States and Europe, typically ones building
something new from scratch `[STATED]`.

**Internal structure.** Four distinct lines of business `[STATED]`:

1. A dedicated **AI team** building AI products from scratch and improving client workflows with
   large language models. A handful of people at the time of the conversation `[ON-SCREEN]`.
2. A **generalist full-stack team** on software-development projects, which intersects with the AI
   engineers but sits on the full-stack side.
3. **Staffing**, acting as a headhunting service that connects clients wanting to grow their own
   engineering teams with candidates from the countries it operates in.
4. An **Entrepreneur in Residence programme**, open to employees as well as outsiders. Someone with
   an idea but without resources or a starting point receives initial resources, a launchpad,
   community access, and introductions to other founders. Two projects were active in that
   programme, one of them going to market the month after the conversation. That project originated
   at the previous year's offsite hackathon `[STATED]`.

**Culture claim.** Open communication with founders and leaders, low friction in reaching anyone,
and an explicit position that culture should be created by everyone in the company rather than set
by leadership -- including the expectation that anyone can pick up an initiative or build an
internal tool that improves the team's workflow `[STATED]`.

---

## The Lead AI Engineer role

**Why the role exists.** The AI team is being grown ahead of an expected increase in project
volume. Some existing AI engineers are moving toward people development, which leaves a gap in
technical project leadership `[ON-SCREEN]`.

**The split, stated precisely.** Sixty percent hands-on engineering work; the remainder is client
communication, scoping, and project decision-making `[ON-SCREEN]`. The interviewer stated this
figure twice -- once unprompted in the role overview and once as a correction when the candidate
later recalled it as forty percent `[ON-SCREEN]`.

**"Lead" is not a management title here.** Everyone on the AI team is nominally a Lead AI Engineer,
because each may be leading a different project. The distinction inside the team is between members
oriented toward individual-contributor work and members who are hands-on leads. The vacancy is for
the second kind: someone who can hold a position with the client, make decisions, and lead the
other engineers, while still building `[STATED]`. People development is available as a direction but
is explicitly optional -- staying on a purely technical leadership track is acceptable `[STATED]`.

**Allocation.** Not tied to a named client at hiring time. Some clients start in September and early
October, so the placement depends both on when the hire joins and on which strengths the company
identifies in them. It may be an entirely new project or an ongoing one, with a new project the more
likely outcome `[STATED]`.

**Engagement type.** Contractor (PJ, the Brazilian *pessoa juridica* arrangement in which the
worker invoices through their own company rather than being employed) `[STATED]`.

---

## The hiring pipeline, six stages

Stated in full by the interviewer and independently re-decoded to confirm the ordering
`[STATED]`:

1. **Recruiter screen** -- the conversation being recorded here. Company overview, role context,
   candidate background, comp, availability.
2. **Take-home**, sent by email. A *written reflection*, explicitly not a build-from-scratch coding
   exercise. It contains questions about past projects to be elaborated on, plus a section
   requiring a **critical analysis of an agent codebase with proposed improvements**. No code needs
   to be written.
3. **Technical screening with the Head of AI** -- a 30-minute technical conversation.
4. **Pair coding.**
5. **System design.**
6. **Executive interview** with the founder.

**Take-home timing, exactly as described.** The nominal window is 24 hours from the moment it is
sent, but the interviewer characterised this as an internal tracking convention rather than an
enforced constraint: there is no timer, nothing prevents opening it and returning to it later, and
the candidate is not restricted. The recruiter also holds scheduling flexibility over when the
take-home is sent -- immediately after the call, the following morning, or the following evening
`[STATED]`.

**Process communication.** Updates come by email from the recruiter; the candidate may contact
either her or a named colleague for help at any stage `[STATED]`.

---

## Compensation and availability, as negotiated in this round

**Ask.** [compensation figure redacted] per month, stated as the figure the candidate had been asking for consistently
across the selection processes he was then in `[STATED]`. Independently re-decoded from the audio
in isolation to confirm the number, because the on-screen Meet captions had already degraded at
that point in the call (see "Screen findings" below).

**Availability.** Immediate, with flexibility on the candidate's side `[STATED]`.

**Competing-process disclosure.** The recruiter asked directly whether any other process was near a
final stage. The candidate disclosed one at an advanced stage whose contract would only take effect
in about two weeks, and the recruiter asked to be given a heads-up if anything advanced, so that
the Company could adjust its own pace `[STATED]`. `[INFERRED]` The exchange is a straightforward
pipeline-synchronisation request, not a negotiating move: the recruiter offered to accelerate
rather than asking the candidate to wait.

---

## Multi-agent orchestration pattern with Claude Code

This is the most technically specific material in the conversation and the on-screen captions
corroborate it line for line.

**The shape.** A single orchestration session in Claude Code, driven by a top-level agent that is
told what must be done. That orchestrator is normally an Opus 5 or a Fable 5 agent. It dispatches
sub-agents -- usually Sonnet 5 -- to carry out the micro-tasks. A separate Opus 5 sub-agent reviews
the sub-agents' deliveries, and the in-session orchestrator reviews them again on top of that
`[ON-SCREEN]`.

Rendered as a chain:

```
orchestration session (Claude Code)
  orchestrator agent          Opus 5  or  Fable 5     <- receives the human's directive
    |
    +-- sub-agent(s)          Sonnet 5                 <- execute micro-tasks
    |
    +-- reviewer sub-agent    Opus 5                   <- reviews sub-agent deliveries
    |
    orchestrator re-reviews the reviewed deliveries
```

**The operating constraint.** The session must not cross **300,000 tokens** of context. Past that
point the described behaviour is that it "starts to diverge and not answer so well"
`[ON-SCREEN]`. `[INFERRED]` This is an empirical per-session working ceiling adopted from
observation, not a documented model limit; it functions as a budget that forces state to be
written down and the session to be handed off rather than extended.

**Why two review layers.** `[INFERRED]` The pattern separates *doing* from *judging* and then
separates *judging* from *accepting*: the cheaper model produces, a stronger model reviews the
production, and the orchestrator -- which alone holds the original directive -- decides whether the
reviewed work satisfies what was actually asked. A single reviewer that also holds the directive
collapses those two questions into one.

**Model names, corrected.** Both ASR sources mangle them. The captions render Opus 5 as "oppos5",
Sonnet 5 as "Sona 5", and Claude Code as "Cloud code". The correct names are Opus 5, Fable 5,
Sonnet 5, and Claude Code.

---

## Staying current: a scheduled daily fetch

**The mechanism.** A daily scheduled job -- a cron job, rendered by both ASR sources as "Chrome
job" -- that runs once every 24 hours to fetch from a set of trusted sources and summarise what
happened in the field over the preceding day: which tool or finding was most discussed
`[STATED]`.

**What it replaces.** `[INFERRED]` Ad-hoc reading. The design point is that the currency problem in
a fast-moving field is a scheduling problem before it is a sourcing problem, so it is solved with a
timer and a fixed source list rather than with attention.

**The stated disposition behind it.** A general optimisation habit, offered with a deliberately
mundane example: measuring how long a water filter takes to fill so that an alarm can be set and
the wait spent elsewhere, rather than watching it `[STATED]`.

---

## Building a skill so an agent can watch video

**The problem named.** Asking a coding assistant to "watch a video for me" is refused, because
watching video is not something it does `[STATED]`.

**The resolution.** Refusal is a function of how the request is framed, not of capability. Decompose
the request into operations the agent can actually perform and it becomes executable. The
decomposition described `[STATED]`:

```
1. extract the audio from the video
2. transcribe the audio with a tool such as Whisper
3. read the transcription
4. whenever the transcript alone does not carry the meaning,
   extract the frame at that specific timestamp and look at it
```

That sequence, packaged as a named skill ("watch video"), lets the material be absorbed without
sitting through the recording `[ON-SCREEN]`.

`[INFERRED]` The generalisable principle is that a capability boundary and a framing boundary look
identical from the outside. The correct probe is to ask which primitive operations the request
decomposes into and whether each is individually available -- the composite verb being unavailable
says nothing about the parts.

The interviewer noted independently that she had recently started building skills for Claude for
her own work `[ON-SCREEN]`.

---

## Reinforcement-learning data production, as practised at Employer C

The candidate's account of contract work producing training data for frontier AI labs. Useful as a
description of the workflow itself.

**Project shape.** Each project was a reinforcement-learning environment built for a client lab,
and ran in two phases `[STATED]`:

*Phase 1 -- SFT (supervised fine-tuning).* Individual contributors construct conversation
trajectories by hand, using the tools available inside that reinforcement-learning environment.
Each trajectory begins from a specific prompt, and by the end of the trajectory that prompt's
request must be fulfilled. The completed trajectory becomes a task fed to the model to learn from.

*Phase 2 -- RLHF (reinforcement learning from human feedback).* The model now builds the trajectory
itself. The same contributors evaluate the model's trajectory against the expected quality bar. The
loop repeats until the client is satisfied with the model's performance on that task or benchmark.

**The scoping vocabulary.** Client-facing project definition covered, explicitly `[STATED]`:

- how a project is started from scratch, and how it is defined and scoped
- the duration it will run for
- what constitutes a task
- how many resources to allocate, and how many individual contributors should work on it
- the expected throughput
- the guidelines that define task quality -- what a high-quality task is

**A stated capability boundary of that work.** Producing high-quality training data for frontier
labs meant never calling a third-party model or tool, because the work product WAS the data. As a
consequence, production LLM application experience was not something that role could provide
`[STATED]`. `[INFERRED]` This is a real and non-obvious gap signature: data-production work at a
frontier-lab vendor builds deep familiarity with training objectives and evaluation criteria while
building no experience of serving, latency, cost, or retrieval in production.

---

## Retrieval-augmented generation build

Described as the most challenging LLM project undertaken, and built to make a year of accumulated
project documentation queryable `[STATED]`.

**Why it was hard.** Gathering and organising a year of documentation from an ongoing project;
defining the metrics to evaluate retrieval against; and benchmarking the available local models
against each other rather than defaulting to one `[STATED]`.

**Pipeline stages.** Ingestion, embedding, and generation, understood end to end as one pipeline
rather than as separable parts `[STATED]`.

**The two tuning decisions that mattered.** Which embedding model to use, and what value of top-k to
retrieve. Both materially moved accuracy and recall of the answers returned for a given prompt
`[STATED]`.

**Model identification, honestly bounded.** The embedding model is named in the audio as something
both ASR sources render as "Queen 3.5" / "quen 3.5" `[ON-SCREEN]`. `[INFERRED]` The intended family
is Qwen; the exact version is NOT recoverable from this recording. Two independent ASR systems agree
on the digits, and no on-screen artifact disambiguates it, because nothing was screen-shared. Treat
"a Qwen embedding model, version not established" as the recoverable fact and do not quote a version
number out of this source.

---

## Insights and intakes

**A "lead" title says nothing without its hands-on percentage.** The same title covered, in this one
conversation, both a role that is sixty percent building and a prior role that had drifted to one
hundred percent leading. The percentage is the specification; the title is not.

**A hands-on percentage is worth confirming rather than recalling.** The candidate recalled the
figure as "at least 40 percent" some seventeen minutes after being told sixty, and was corrected in
the moment `[ON-SCREEN]`. Numbers stated once early in a call decay quickly.

**A written-reflection take-home tests different ground than a coding take-home.** Asking for a
critical analysis of an existing agent codebase with proposed improvements measures judgement about
someone else's design, which is what a lead actually does, and it cannot be passed by producing
working code.

**A 300k-token session ceiling is an architectural constraint, not a preference.** Once accepted, it
forces every long-running effort to externalise its state into documents, because the session that
holds the context will end before the work does.

**Composite capabilities refuse; decomposed ones execute.** "Watch this video" is declined. "Extract
audio, transcribe, read, and pull the frame at timestamp t when the words are not enough" is a
sequence of individually available operations.

**Bootstrapped ownership was offered as the differentiator.** The pitch led with the absence of
venture capital and the decision autonomy that follows, ahead of product, clients, or technology.

**Data-production work for frontier labs has a specific blind spot.** It builds no production LLM
application experience, by construction, because introducing a third-party model into the workflow
would contaminate the deliverable.

---

## Corrections

Stated right-first, with the source's version second, drawn only from what is in the recording;
the rest are transcription artifacts that would otherwise propagate.

**A tenure comparison has been withheld.** [Content removed under publication rule 1.] The
correction that stood here checked a tenure figure the candidate stated in the recording ("I
worked for over three years, I believe") against a private employment record outside the
recording. Because the comparison depends on that external record, both the comparison and the
record it drew on are removed whole rather than partially redacted.

**Three companies are named, not four.** The source opens with "I've gone through four different
companies" and then names Employer A, Employer B, and Employer C. A fourth is not identified
anywhere in the recording. `[INFERRED]` Either the count is loose or the fourth was dropped in
delivery; the recording does not settle which.

**The role is 60 percent hands-on, not 40.** The interviewer stated 60 percent at 05:30 and repeated
it as an explicit correction at 22:46 after the candidate recalled 40 `[ON-SCREEN]`.

**It is a cron job, not a "Chrome job."** Both ASR systems produce "Chrome"; the described mechanism
-- a job that runs daily on a schedule -- is cron.

**The models are Opus 5, Fable 5, and Sonnet 5, running under Claude Code.** The captions render
these as "oppos5", "fable 5", "Sona 5", and "Cloud code" respectively.

**The transcription language behaviour is a pipeline correction, not a source error, and it matters
for anyone re-processing this file.** Pinning a whisper transcription to `language="en"` over a
recording that switches language does not fail loudly -- it silently *translates* the non-English
spans into English, producing fluent output that reads like a transcript and is not one. The
recording is Portuguese for its first 55 seconds, English from there to roughly 25:43 at the
interviewer's request, and Portuguese again to the end. Detect the language across the file before
pinning it.

---

## Boundaries

**No technical assessment occurred.** This is stage one of six. No code was written, no system was
designed, and no technical claim made by the candidate was probed. Nothing here indicates how any of
it would survive scrutiny in stages three through five.

**No artifact was shown.** Nothing was screen-shared at any point in the recording. Every technical
detail above is a spoken description, corroborated at best by an automatic caption of the same
audio. There is no repository, no diagram, no benchmark table, and no configuration to inspect --
which is why the Qwen version above cannot be pinned down.

**The Company's figures are self-reported.** Headcount, founding year, profitability, team size, and the
sixty-percent split all come from one representative in a recruiting conversation, where the
incentive is to present the company well. None is independently verified.

**The role's allocation was explicitly undetermined.** Which client, which project, and which
strengths get used were all deferred to a later decision. The role description above is therefore a
description of a shape, not of a job with known contents.

**Comp is a single data point in one currency and one arrangement.** [compensation figure redacted] per month as a
contractor ask, made by one candidate in one market, disclosed as his standing ask across concurrent
processes. It is not a range, not an offer, and not a benchmark.

**No behavioural, vocal, or temporal analysis is present.** By design. This document cannot support
any claim about how either participant came across, how much either spoke, or how the round went.

---

## Value map: your environment

Mapped against the work this pipeline can see: a machine-learning pipeline in
`[REDACTED: private repo path]`, the RAG build in `[REDACTED: private repo path]`, a systems-performance track, the
`[REDACTED: private repo path]` portable governance kit, and the active job-search track under `[REDACTED: private path]`.

**Job-search track -- high, and immediately actionable.** The six-stage pipeline is now written down
with the take-home's actual content specified: a written reflection with a critical analysis of an
agent codebase. That is preparable in a way "a take-home" is not, and it is the one stage where the
material you already own is directly reusable -- the governance and review patterns in
`[REDACTED: private repo path]` and the guardrail ledger in [REDACTED: private repo] are exactly the vocabulary a
critique of someone else's agent code needs. The 24-hour window is stated to be an internal
convention rather than a timer, and the recruiter holds send-time flexibility, so the window is
schedulable rather than a constraint to absorb.

**Job-search track, the comp line.** [compensation figure redacted] per month as a contractor is
stated in the recording as the candidate's standing ask across concurrent processes.
[Content removed under publication rule 1.] A comparison against the candidate's
employment-status record, and an anticipated background check at a later pipeline stage, stood
here in the original; both draw on records outside the recording and have been withheld whole.

**The ML pipeline -- moderate, and only on one axis.** Nothing about the Company's business or process changes
the pipeline. What is reusable is your own articulation of it under questioning: the RL
data-production account (SFT trajectory authoring, then RLHF trajectory evaluation, iterating to a
client quality bar) is the clearest compact statement of that workflow in your recorded material,
and the scoping vocabulary attached to it -- throughput, task-quality guidelines, IC headcount,
project duration -- is directly transferable to describing that pipeline's own stage structure.

**RAG project -- moderate, with a specific hazard.** The account given here is looser than what the
project actually supports, and the gap runs in the risky direction. [REDACTED: private project
technical detail -- specific chunking, indexing and scale figures for that project were listed
here]. The recording names an embedding model version that cannot
be substantiated from any source in it. Before the Head of AI screening, pin the embedding model
from `[REDACTED: private status file]` rather than from memory, and carry [REDACTED: private
project architecture detail -- the retrieval and reranking design was named here] -- both are
stronger material than the top-k tuning story that was told, and both are verifiable.

**A systems-performance track -- no direct value.** Nothing in this conversation touches
performance engineering, C++, or measurement discipline. The one indirect connection is that
[REDACTED: private review methodology] is the strongest available evidence for the "critical
analysis with proposed improvements" take-home, since it demonstrates review discipline applied to
your own work.

**Portable governance kit -- confirms, does not advance.** The claim made in the round, that a personal
harness repository exists but is not finished, is accurate against the kit's actual state:
[REDACTED: private project status detail]. No correction
needed. If the take-home asks for improvements to an agent codebase, [REDACTED: private project
detail -- the kit's own exclusion/decision record was described here] is a
ready-made demonstration of the reasoning that question is testing.

**Agent orchestration and daily working style -- confirms current practice.** The layered pattern
described in the round is the one in use: an orchestrator holding the directive, Sonnet-class
sub-agents executing, an Opus-class reviewer, and a 300k-token session ceiling that matches the
budget already written into your project instructions. Nothing here suggests a change. The one
observation worth keeping is that the ceiling was described as a divergence threshold discovered by
observation; that is a claim a technical interviewer can reasonably ask you to substantiate, and it
is currently supported by experience rather than by measurement.

**Skill-building -- one concrete follow-up.** The interviewer volunteered that she has recently been
building Claude skills for her own work. That is the single named thread in this conversation worth
picking up in a later stage, because it is common ground with the person controlling the process
rather than with the technical panel.
