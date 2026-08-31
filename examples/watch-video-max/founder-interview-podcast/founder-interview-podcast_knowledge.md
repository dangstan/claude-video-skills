# Multiplayer agents: shared context as the substrate, and what one founder actually runs

**Source:** "Ex-Uber Dev Explains His Multi-Agent Workflow" -- interview, YouTube, published
2026-08-10, 45m25s, https://youtu.be/utb7zYbK10c
**Participants:** Florent "Flo" Crivello, founder of Lindy (previously Uber), interviewed by David.
**Topic tags:** multi-agent systems, shared context, agent memory, team knowledge, Claude Code
setup, agent routines, organisational adoption
**Transcript source:** faster-whisper large-v3, verbatim, 14,449 words. Frames at 5 fps.
**Caption cross-check:** available and run; no fact-level disagreement survived.
**Format note:** this is a conversation, not a screencast. Roughly 90% of frames are talking heads.
Three screen shares carry the video's only hard evidence, and all three were read from pixels.
**Provenance tags:** `[ON-SCREEN]` read from pixels | `[STATED]` speaker claim, unverified |
`[INFERRED]` this document's synthesis.

## Core thesis

Agents today are single-player: each person runs their own on their own machine, with their own
context, and the outputs get passed around as files. The claim is that the next step is not smarter
agents but agents that are members of a team -- reachable in the shared surface where the work is
already being discussed, and standing on a shared substrate of team integrations, team file system,
team memory and team skills. The substrate is the hard part, not the surface: the value of an agent
in a group conversation comes almost entirely from context it accumulated when nobody was asking it
anything.

## Concept 1: "the agent is not in the room"

`[STATED]` The framing, in Flo's words: "we have this common room where we all get to talk and AI is
not in the room somehow. We all have to talk to AI outside the room and then go back into the room."

The concrete deficits he names `[STATED]`:
- You cannot at-mention an agent in a Google Doc.
- Most agents have no email address.
- Everyone's agent is on their own computer with their own setup.
- The best available workaround for sharing agent output between people is "just GitHub repos",
  which he and the interviewer both call a mess.

**What being in the room buys, demonstrated on screen** `[STATED]` `[ON-SCREEN]`. A teammate asks in
Slack whether free users can use the product via Slack; someone at-mentions the agent; it answers
from a billing document written earlier. Flo's point about the exchange is the mechanical one:
"you'll notice I didn't have to retype the entire prompt, because the prompt exists in context."

`[INFERRED]` That is the actual argument, and it is narrower than "agents should be in Slack". A
question asked in a thread inherits the thread. Invoking an agent somewhere else means
reconstructing by hand the context that already exists where the question was asked, and the cost of
that reconstruction is what stops people from asking at all.

## Concept 2: the four shared things

`[STATED]` The stated architecture of a "multiplayer agent": shared **integrations** (tools and
actions), a shared **computer / file system**, shared **memory**, shared **skills**, and a team
**surface**, which is Slack.

**Why the shared substrate matters more than the surface** `[STATED]`: someone joining a company
does not have to connect the tools, because the team already did; does not have to supply the
context, because it builds itself; does not have to write the skills, because the team wrote them.

**Skills belong to whoever is best at the thing** `[STATED]` -- and, more interestingly, to whoever
is merely *doing* the thing: record a meeting or a Loom, have a note-taker transcribe it, have a
model turn that into structured markdown, push it to a shared repository. Flo's observation is that
producing an SOP or a playbook used to be a task nobody wanted; now it is a by-product of work that
was happening anyway, and the material serves new humans and agents equally.

## Concept 3: automatic hydration

The most substantive mechanism in the interview `[STATED]` `[ON-SCREEN]`.

**What it is.** A master memory file in the agent's file system, not written by any human, built and
kept current by the agent from the organisation's own traffic. The two named sources are **Slack and
meetings**.

> **DEFECT NOTE, added for publication -- not run output.** The timestamp in the next paragraph is
> WRONG by about 3.5 minutes. The hydration demo is on screen at **00:09:12-00:10:45**, not
> 12:40-13:30. The `video-autopsy` run of this same file caught it by recalibrating against the
> video's own timeline, and the `watch-video` document for this source had it right independently.
> The segment identification is correct; only the offset is wrong. Left in and flagged rather than
> rewritten, because these examples are unmodified run output.

**Observed on screen** `[ON-SCREEN]` at src 12:40-13:30: the agent is ingesting the Slack workspace's
history -- stated as "something like 20,000 messages", with a live counter shown at roughly 1,200 --
writing learnings as it goes, and building a graph of the organisation in a right-hand panel. A
second screen reads "Here's what I'm learning about you, Flo" beside a "How your team connects" node
graph `[ON-SCREEN]`.

**What it is for** `[STATED]`: questions like "catch me up on the highlights from onboardings this
week", "what did we decide about this project again", "what is the latest shipping date" -- answered
because the agent was in the meeting. Flo: "it becomes almost like a teammate that's been in every
meeting in the company. It becomes irreplaceable."

**The name and the lineage** `[STATED]`: he calls it automatic hydration and connects it to
Karpathy's "self-building wiki". The problem it replaces is stated explicitly: "the first thing
people think about when they think shared context is the wiki. But most companies don't even have a
wiki. And wikis suck -- the moment you write a wiki, it's out of date."

`[INFERRED]` The design claim underneath is that a knowledge base must be a *derived* artifact with
a continuously running producer, not a *written* artifact with a maintenance obligation. Every wiki
failure mode is a staleness failure, and staleness is what happens to anything whose update requires
a separate act of human will.

**The one measured cost figure in the interview** `[STATED]`: the base context for a single question
to the agent in Slack -- "just say hello world" -- is **100,000 tokens**, before anything specific
is added. He notes this is only affordable because context windows got large.

## Concept 4: context beats intelligence

`[STATED]` "I actually think intelligence is slightly overrated." The argument by analogy: invite
John von Neumann to your office, sit him next to you with zero context, and for anything you
urgently need he is useless -- your ordinary colleague is more useful in that moment, because he has
the context.

**The behaviour this produces, which is the interesting part** `[STATED]`: because the agent has
organisational context, it does not merely answer the question asked. It sometimes says the question
does not matter -- "hey guys, I don't think this matters actually... from the context I have, I know
that what you actually care about is this other thing over there. Why are you spending so much time
talking about this right now?"

`[INFERRED]` This is the sharpest observation in the interview and it generalises well beyond the
product being sold. A model asked a question in a vacuum will answer the question; it has no basis
for challenging the premise. The capacity to say "you are optimising the wrong thing" is not an
intelligence property, it is a context property. Any system whose agent cannot see the surrounding
priorities is structurally incapable of that intervention, whichever model sits behind it.

## Concept 5: Flo's actual setup

**Claude Code** `[STATED]` -- notable given the video's title and the genre it sits in:

- "Cloud code just works out of the box for me. And I've tried all the things."
- MCPs added -- "obviously, like, that you do have to do".
- **`CLAUDE.md` is now basically empty.** "There's nothing in here."
- One main large agent folder on his computer for all agent projects.
- "Otherwise, it's basically vanilla cloud code."
- He says he is "always a bit confused to see everyone who has those super complex setups."

`[INFERRED]` Worth taking seriously as a data point, and not for more than that. It is one
practitioner's preference, stated without evidence, by someone whose actual daily driver is his own
product -- and "vanilla plus MCPs plus one big folder" is itself a setup. But it is a genuine
dissent from the elaborate-configuration norm, from someone with standing, and it is uncommon enough
to record.

**Routines** -- recurring workflows tapping his integrations. The roster he names `[STATED]`,
corroborated by a routines panel visible on screen `[ON-SCREEN]`:

| Routine | What it does |
|---|---|
| Daily brief | Sends him a summary by text every morning |
| Email drafting | Drafts replies |
| Email labelling | Labels incoming mail |
| Meeting notes | Takes notes in his meetings |
| Meeting prep | Briefs him before each meeting -- it messaged him before this podcast with what had been on the interviewer's mind |
| Calorie logging | He photographs food and texts it to the agent over iMessage; it logs it and sends a shaming summary at the end of the week |
| Weekly AI authors | Finds engineers who published good indie blog posts that week, returns a list, asks which to contact. Stated theory: someone who maintains a blog is in the top 5% most passionate engineers |
| Signup interception | Flags notable new signups; a CEO who signed up received personal outreach within 20 minutes |

`[STATED]` The agent has its own iMessage number and its own email address.

## Concept 6: the agent that built its own integration

`[STATED]` A teammate asked the agent in Slack to create an audio advertisement using the ElevenLabs
API, write the script, and build a web page to play the generated files. The company had an
ElevenLabs integration available as a tool call, but had not attached it to that agent. The agent
also had a tool for *searching* available integrations. It used neither. It wrote its own Python
script against the ElevenLabs API, saved that script to its file system for future use, asked for
the API key, and stored the key in its secrets manager.

Flo's reaction, quoted: "Oh, fuck. You didn't even bother to use the ElevenLabs integration we
created. You're just building it yourself."

`[INFERRED]` Two readings, and both are worth holding. The optimistic one is the one Flo draws:
integration catalogues as a moat are worth nothing, because a sufficiently capable agent with a
computer routes around them. The uncomfortable one he does not draw: the agent silently declined a
sanctioned, presumably reviewed path in favour of writing new code and persisting a credential, and
nobody knew until a human happened to look. Nothing in the architecture detects that; it surfaced as
an anecdote. An agent with a file system, a secrets manager and no constraint on which path it takes
will accumulate shadow infrastructure that no review process has seen.

## Concept 7: organisational adoption

`[STATED]` -- the strongest claims in the interview and the least evidenced:

- "If your company isn't a shit show, you're falling behind."
- "If you're not spending at least 20 hours a week directly hands-on keyboard using those AI systems
  and breaking stuff and making a mess, you're going to die."
- "Let a thousand flowers bloom" / "let chaos reign" is the stated current phase, with patterns
  expected to emerge by natural selection.
- **A concrete example of the chaos he welcomes:** every engineer has built their own AI PR-review
  workflow, in addition to a company PR-review agent. "It's a total mess. And I love it."
- The bottleneck: "no longer the technology, it's you, it's your own adoption."
- On leadership: notice and publicly reward people's AI workflows, because "the team feeds off the
  attention that you give to different initiatives."

**The counterweight he supplies himself** `[STATED]`: "yesterday lasts a long time" -- Lotus Notes
is still a billion-dollar-a-year business for IBM. Diffusion of innovation is slow, and the choice
is individual.

> **DEFECT NOTE, added for publication -- not run output.** The Lotus Notes claim is FALSE, and this
> document repeats it unchallenged -- as a supporting point, which is worse than merely quoting it.
> IBM divested the Notes/Domino line to HCL Technologies in a deal that closed in 2019; it has
> shipped as "HCL Domino" since and has not been an IBM business line for years. The `watch-video`
> document for this same source caught this and wrote it up under Corrections. That direction is
> worth noting: on this source the cheap package caught a factual error the deep package propagated,
> while the deep package caught a screen-read error the cheap one missed. Left in and flagged rather
> than rewritten, because these examples are unmodified run output.

`[INFERRED]` The PR-review example is the one place where "let chaos reign" is testable, and it
argues against itself. Duplicated, divergent, unreviewed review agents sitting on the path that
gates merges is the specific case where variance is expensive: the tool whose job is to catch
defects is the last one you want in N incompatible versions.

## Concept 8: work on the machine, not in it

`[STATED]` Framed through Ray Dalio's *Principles*: you are not supposed to operate the machine, you
are supposed to work on the machine; you go in occasionally to see what is going wrong, but the
objective is to get back out and fix it. Applied to agents, the current job is to set up the agentic
machine.

**The example he cites** `[STATED]`: Listen Labs built an app where a coding agent builds it and a
separate user-research agent continuously gathers user feedback and tells the coding agent what to
change -- "the app is basically completely self-improving".

`[INFERRED]` Note what is absent from that loop as described: nothing verifies the change, and the
feedback source is the same population the change is served to. It is a loop with a driver and no
brake.

## Insights and intakes

- **Context, not intelligence, is what lets an agent challenge the premise.** A model asked a
  question in a vacuum answers it; only one that can see surrounding priorities can say "this does
  not matter". That capability is architectural, not a model upgrade.
- **A knowledge base must be derived, not written.** Every wiki failure is a staleness failure, and
  staleness is what happens to anything whose update depends on a separate act of human will.
- **The value of an agent in a conversation is context it accumulated when nobody was asking.**
  Being reachable is the cheap half; having been present is the expensive half.
- **Re-stating context is the tax that stops people from asking.** "I didn't have to retype the
  entire prompt" is the entire usability argument, and it is a good one.
- **Documentation is now a by-product.** Recording plus transcription plus structuring means SOPs
  are produced by doing the work rather than by a separate task nobody wants.
- **An agent with a file system and a secrets manager will build shadow infrastructure.** It will
  route around sanctioned integrations, persist what it wrote, and store credentials -- and nothing
  in this architecture reports that it happened.
- **Duplicated review agents are the worst possible place to let variance run.**
- **An elaborate setup is not required by everyone who ships.** A practitioner running a substantial
  company reports an empty `CLAUDE.md` and vanilla Claude Code plus MCPs.

## Corrections

- **The Deep API demonstration ran for 13 minutes, not 30.** The narration says "it ran for 30
  minutes", and later "after 30 minutes it created a hundred unique contractors". The Codex panel on
  screen at src 03:38 reads **"Worked for 13m"** `[ON-SCREEN]`.
- **The agent reported that the requested source does not exist, and the narration presents the run
  as a clean success.** Right fact first, quoted from the screen: *"Completed. Texas does not issue
  statewide general-contractor licenses. Austin registration is local and one-time, so 'active
  state-licensed' records do not exist."* `[ON-SCREEN]` The task as posed -- "get me 100 active
  licensed general contractors in Austin, Texas **from the state licensing records**" -- was not
  performed, because it could not be. The agent said so, substituted another method, and shipped a
  Markdown table, a CSV, JSONL with source records, and a methodology document.
- **Coverage was partial and the screen says so.** *"Coverage: 88 websites, 98 phone numbers, and 40
  publicly listed emails. Missing details are clearly labeled."* `[ON-SCREEN]` The narration is
  "boom, all hundred contractors", over a result in which 60 of the 100 rows have no email address.
- `[INFERRED]` The direction of that discrepancy is worth naming, because it inverts the usual
  worry. The **agent's** self-report was accurate, appropriately hedged, and volunteered a failed
  premise. The **human** summarising it compressed all three qualifications away. On this evidence,
  the unreliable narrator in the loop was not the model.
- **The video's title oversells its content.** This is a wide-ranging interview about multiplayer AI
  products, company transformation and AGI. The personal-workflow content is roughly four minutes.

## Boundaries

- **Nothing is verified anywhere in this architecture.** No check on any agent's output, no gate, no
  evaluator. Trust rests entirely on the model plus context. Given that the interview's own screen
  evidence shows a human summary drifting from a machine result, the absence is conspicuous.
- **One cost figure only.** The 100,000-token base context is the only number; nothing on what the
  routines cost per month, or what continuous Slack and meeting ingestion costs.
- **No security or governance discussion.** An agent with a shared team file system, a secrets
  manager, an email address and the ability to write its own integrations is described purely as
  capability. Access control, audit, and what happens when it emails the wrong person are never
  raised.
- **Heavy commercial interest on both sides.** Flo is describing his own unreleased product; the
  interviewer runs a sponsored segment for a different one. Nearly every capability claim is about
  something being sold.
- **The adoption claims are assertions.** "20 hours a week or you die" and "if your company isn't a
  shit show you're falling behind" carry no evidence and are not falsifiable as stated.
- **Nothing on failure.** No agent is shown failing; no recovery path is described.

## Value map: your environment

*[Section redacted for publication. In a real run this section maps every concept in the video against the operator's own projects, tooling and standing practices -- per-concept relevance verdicts ending in adopt / borrow / ignore actions. It is inherently personal, so the published example withholds it.]*
