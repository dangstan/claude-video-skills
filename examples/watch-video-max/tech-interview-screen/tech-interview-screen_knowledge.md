# The Company -- Lead AI Engineer screening call, August 2026

Source: local recording `[recording filename redacted]` (Google Meet), recorded August 2026,
about 30 minutes. Participants on screen: the recruiter (interviewer), the candidate, and an
automated third participant labelled "the recruiter's AI notetaker bot" showing "Taking notes &
recording". Topic tags: hiring process, AI engineering studio, RLHF data production, RAG,
multi-agent orchestration, quantitative crypto ML, contractor compensation in Brazil.

Transcript source: faster-whisper large-v3, verbatim, GPU float16, beam 5. The recording is
MULTILINGUAL and was transcribed in three language-pinned regions (PT 0:00-0:47, EN 0:47-25:28,
PT 25:28 to the end of the recording) cut at measured silence gaps; two repetition-loop spans and one garbled-proper-noun
span were re-decoded and spliced back at true offsets. See the transcript header for the full
provenance.

Caption cross-check: AVAILABLE BY AN UNUSUAL ROUTE, AND ONLY OVER PART OF THE RECORDING. There is
no platform caption track -- the input is a local file -- but Google Meet's live captions are
burned into the pixels, which makes them a genuine second ASR engine reading the same audio. 14
terms that could change a fact were compared between the two engines; 9 agreed, 5 disagreed, and 4
of the 5 were settled (3 from pixels elsewhere in the frame, 1 by re-decoding). The Meet caption
engine was pinned to English for the whole call, so across the two Portuguese regions -- about
25% of the recording -- it emitted unrelated English text and provided NO cross-check at all. Every
compensation, contract and hiring-process fact below sits inside that uncovered stretch and rests on
a single engine.

Frame rate: 5 fps, the package default. (The total frame count this run reported here has been
removed in sanitization: divided by the frame rate it recovers the recording's exact duration,
which is a declared quasi-identifier for this private source. No figure below depends on it.)

Provenance tags used below: `[ON-SCREEN]` read from pixels, highest trust | `[STATED]` a speaker's
claim, unverified | `[INFERRED]` this pipeline's synthesis | `[UNRESOLVED]` heard but not settled.

---

## Core thesis

The Company is a 25-person, profit-funded AI engineering studio and startup incubator in Brazil
hiring a Lead AI Engineer into a five-person AI team, on a Brazilian contractor (PJ) basis, through
a six-stage process whose second stage is a written take-home rather than a coding exercise. The
role is deliberately 60% hands-on, which is the specific attribute the candidate said had been
missing from the leadership role he left. The technical substance of the call is a comparison of
two ways of working with frontier models: producing training data for frontier labs, which never
puts you in contact with a model in production, versus building a retrieval pipeline yourself,
which does.

---

## The Company: what it is

**What it is.** An AI engineering studio and a startup incubator operating as one business
`[STATED]`. It builds products for paying customers and also helps launch new companies. Founded
2021 `[STATED]`. On LinkedIn the company is "the Company" with a stylised S mark; the profile
banner reads "live in the future then build what's miss[ing]" `[ON-SCREEN]`.

**How it is funded, and why that matters.** Sustained by its own profits, with no venture capital
`[STATED]`. The stated consequence is the operating point rather than the financing: no external
growth pressure, decisions made by the owners on their own judgement, and in exchange a larger
share of the responsibility carried internally. Quoted directly: "we are sustained by our own
profits, so we don't have any type of venture capital hype or pressure ... that gives us a lot of
freedom, a lot of autonomy, but of course, a lot of responsibility too" (src 01:38).

**Shape of the organisation** `[STATED]`:

- 25 people total, split between Brazil and the United States.
- Fully remote, with at least one in-person gathering per year (offsites, or events the company
  attends).
- A dedicated AI team of 5 people, for AI-specific products: building from scratch with AI, or
  improving a client's workflows with LLMs.
- A separate generalist full-stack team doing software development projects, which intersects with
  the AI engineers rather than being walled off from them.
- Clients are in the US or Europe, typically startups or companies building something new from
  scratch.

**Four revenue and activity lines** `[STATED]`:

1. Product work for customers (the studio proper).
2. AI-specific product work through the dedicated AI team.
3. Staffing: when a client wants to grow its own engineering team, the Company connects them with
   Brazilian candidates and acts as a headhunting service.
4. The Entrepreneur in Residence programme (see below).

**Entrepreneur in Residence programme.** Open to everyone, employees included `[STATED]`. Someone
with an idea but without resources, or without a starting point, is given initial resources, a
launchpad, community, and introductions to other founders. Two projects are currently at an
advanced stage; one goes to market the month after the call. One of the two was born at the
previous year's offsite hackathon, and an engineer on it who had never expected to become an
entrepreneur is now running it. The recruiter names this as the clearest example of the company's culture
producing something.

**Culture, as described.** Open communication with founders and leaders; low friction in reaching
anyone; anyone may pick up initiatives, propose improvements, or build internal tooling for the
team's own workflow; culture is explicitly not owned by leadership or the people team alone
`[STATED]`.

---

## The open role: Lead AI Engineer

**Title and posting.** "Lead AI Engineer", the Company, Brazil (Remote). Read from the recruiter's own
LinkedIn profile card, which shows "Hiring: Lead AI Engineer & 1 other -- the Company - Brazil
(Remote)" `[ON-SCREEN]`, and from her outreach message in the LinkedIn inbox, subject "Opportunity:
Lead AI Engineer at the Company (Full remote,...", dated a few days before this call `[ON-SCREEN]`.

**Hands-on split: 60%.** The recruiter's own figure, given twice. In her overview: "it's a lead position,
but it's very much hands on too, so I would say that 60% of the time is hands on work" (src 05:18)
`[STATED]`. Later the candidate mis-remembers it as 40% and she corrects upward: "Actually it's
60%, uh, hands-on" (src 22:47) `[STATED]`. Both engines agree on the number in both places. The
remaining 40% is leadership and client management.

**Why the role exists.** Some of the existing AI engineers are moving toward people development, so
the team needs more people who can carry technical projects on the technical-leadership side
`[STATED]`. A hire who wants to stay purely on technical leadership rather than move into people
management is explicitly acceptable.

**What "lead" means inside this team.** Asked directly whether a Lead AI Engineer gets a team or
mainly talks to the client, the recruiter's answer is that in the AI team effectively everyone is a Lead AI
Engineer: some lean more toward IC work, others are hands-on leads, and the company is looking for
someone who can do a little of both -- taking a position with the client, making decisions, and
leading other engineers. Each person may be leading a different project, which is why the title is
near-universal on the team rather than a rank (src 30:22) `[STATED]`.

**Allocation.** No specific client is attached to the role. Some clients start in September or early
October; the allocation depends on when the hire joins and which strengths the company identifies in
them. It could be a brand-new project or something already running, with a good chance of being new
(src 29:52) `[STATED]`.

---

## The hiring process

Six stages, described by the recruiter at the end of the call, in Portuguese `[STATED]`. This entire
passage lies in the region where the on-screen caption engine was pinned to the wrong language, so
none of it carries a second-engine cross-check.

| # | Stage | Content |
|---|---|---|
| 1 | Screening call | This call, with the recruiter (Talent Acquisition & People Ops) |
| 2 | Take-home | Sent by email; a WRITTEN REFLECTION, not a build |
| 3 | Technical screening | 30-minute technical conversation with the Head of AI |
| 4 | Pair coding | -- |
| 5 | System design | -- |
| 6 | Executive interview | With the founder |

**The take-home is the unusual stage and the one worth preparing for.** It explicitly involves no
coding from scratch. It contains (a) questions about the candidate's own past projects, asking them
to elaborate, and (b) a section presenting AGENT CODE for the candidate to critique and propose
improvements to. The stated allowance is 24 hours, but the recruiter qualifies that immediately: there is
no timer and nothing enforcing it, the candidate can open it, stop, and continue, and the 24 hours
is "mais um acompanhamento nosso" -- a tracking convention on their side rather than a constraint
(src 27:07).

**Contract and compensation** `[STATED]`:

- Engagement is as **PJ / contractor**, not employment. The candidate confirms this matches how his
  previous engagement worked.
- the recruiter asks for a monthly expectation **in US dollars**.
- The candidate's stated ask: **[compensation figure redacted]**, described as the figure he has been asking
  across his current processes (src 26:15).
- Availability: immediate, with no blocker to proceeding.

**Process hygiene visible in the call.** The recruiter offers to schedule when the take-home lands (now,
tomorrow morning, or end of tomorrow) rather than sending it by default; commits to updating by
email at every stage; asks whether any competing process is near a final stage and asks to be told
if one advances, offering to try to match the timing (src 28:37).

---

## Frontier-lab RL data production, as practised at Employer C

This is the most transferable technical content in the call: a description of how a vendor produces
reinforcement-learning training data for frontier AI labs, given by someone who scoped and led such
projects `[STATED]`.

**Project definition.** Every engagement begins with meetings with the client's teams to settle how
a project is started from scratch: the scope, the duration it will run for, the deadline, how many
tasks it contains, how many resources to gather, how many ICs should work on it, the expected
throughput, and the guidelines that define what a high-quality task actually is. That last item --
a written definition of task quality -- is treated as a first-class deliverable of scoping, not as
something discovered later.

**Every project is a reinforcement learning environment.** Projects then run in two phases.

*Phase 1 -- SFT (supervised fine tuning).* The ICs, who are developers, hand-build the trajectories
of a conversation themselves, using the tools available inside that RL environment. A trajectory
starts from a specific prompt, and by the end of the trajectory that prompt's request must be
fulfilled. The completed trajectory becomes a task that is fed to the model, and the model learns
from it.

*Phase 2 -- RLHF.* The model now builds the trajectory by itself. The IC team evaluates the model's
trajectory to decide whether everything was done well and whether the expected quality was reached.

*Iteration.* The two phases repeat until the client is satisfied with how the model performs on
that specific task or benchmark.

**The structural consequence, and why it is the most interesting thing said in the call.** Because
the deliverable is high-quality data produced FOR the labs, the work never calls the labs' own
products as a third-party tool. In his words: "we would work directly for the top frontier AI labs,
so we would give them, produce them high quality data, so we would never call a tool that would call
them because we wouldn't need this third party tool" (src 15:21). The result is that several years
of frontier-adjacent work can leave a person with no experience of running an LLM in production.
That gap is the reason the personal project below exists.

---

## The RAG pipeline built over a year of personal project documentation

`[STATED]`, offered as the answer to "the most challenging project involving LLMs".

**Corpus.** A year's worth of his own documentation from the personal crypto ML project.

**Method.** He had to define specific metrics, and select local models to work with, then run a lot
of benchmarks against the local models available to him. He settled on a Qwen-family local model for
the embedding step `[UNRESOLVED -- see Corrections]`.

**The two parameters that dominated quality.** Both are retrieval-side, not generation-side:

1. Choice of embedding model.
2. How many top-K chunks to retrieve for a query.

These "really impacted the accuracy and the recall" of the answers produced for each question and
each prompt (src 14:35).

**What it was worth.** Understanding the whole pipeline end to end -- ingestion, then embedding,
then actual generation -- which is the production-LLM knowledge the frontier-lab data work
structurally could not provide.

---

## The multi-agent orchestration pattern in daily use

Given as the answer to "what is your process for staying updated" `[STATED]`. This is a concrete,
reproducible working pattern.

**Harness.** Claude Code, used as a multi-agent orchestration environment.

**Session structure.** One orchestration session, into which the operator dictates what must be
done. Roles:

- **Orchestrator:** an Opus 5 or Fable 5 agent.
- **Sub-agents:** Sonnet 5, doing the micro-tasks.
- **Review:** an Opus 5 sub-agent reviews the sub-agents' deliveries, and then the orchestrator
  reviews them again -- two review passes over the same work, by different agents.

**The one hard constraint.** The session is explicitly capped: "I specifically defined that it can't
cross 300 K tokens because it starts to diverge and not answer so well" (src 19:20). This is a
self-measured operating limit, not a documented product limit.

**Daily news ingestion.** A cron job runs daily to fetch, from sources he trusts, what has happened
in the last 24 hours and what has been most talked about in AI -- tools, findings -- so the update
loop is automated rather than browsed.

**A "watch video" skill, and the decomposition insight behind it.** He wrote a skill so he does not
have to watch videos himself. The reasoning he gives is the generalisable part: an assistant asked
"watch a video for me" will decline, but the same assistant will execute the task if it is
decomposed into tool-shaped steps. The decomposition he describes (src 20:16-20:52):

```
1. extract the audio from the video
2. evaluate the audio -- use a tool like Whisper to read its traits
   (he names tonality and emotion in the voice)
3. transcribe the audio
4. read the transcription
5. whenever you want to see what is happening on screen at a point in the
   transcript, extract a frame from the video for that specific moment
```

The recruiter's response places this in context: she had recently started building skills in Claude for
her own work, so the practice is not exotic on the hiring side of this conversation.

---

## The crypto ML pipeline and its promotion gate

`[STATED]`, given as the current personal project, running about a year.

- A machine learning pipeline predicting crypto coin price changes, with a search for trading
  strategies to take profit from those predictions using the models' output.
- It has become "a lot more complex than I ever imagined" over that year.
- Some live trades were attempted, but confidence was not high enough to commit real money.
- Current state: revisiting phases of the pipeline before proceeding.
- The next gate, stated explicitly, is **two weeks of paper trading**, with the production
  inference pipeline running **every hour**, deciding whether to open trades, close or remove
  positions already established, and buy or sell amounts -- with no real money.
- Live trading only after that gate passes.

This is a staged promotion policy -- backtest, then a fixed-duration hourly paper-trading window,
then capital -- stated as a personal discipline rather than as an institutional requirement.

---

## Insights and intakes

**Producing data for a frontier lab and using a frontier model in production are disjoint skill
sets.** The vendor relationship is precisely what removes the second one: when the deliverable IS
the data, there is no reason for the engagement to ever call the lab's product, so the engineer
accumulates depth in RL environment design and task-quality definition while accumulating zero
production LLM surface. Anyone reading a CV with several frontier-lab years on it should ask which
of the two it represents.

**A written definition of "high-quality task" is a scoping artifact, not a QA afterthought.** In the
pipeline described, guidelines defining task quality are settled in the same conversation as scope,
deadline, headcount and throughput -- before any data is produced. That ordering is what makes
throughput and quality commutable into a delivery plan at all.

**In a retrieval pipeline the quality levers that mattered were both upstream of the model.** The
embedding choice and the top-K retrieval count dominated accuracy and recall. Neither is a prompt
and neither is a model-size decision, which is where attention usually goes first.

**Two review passes by different agents over the same sub-agent output is a cheap orchestration
pattern.** A dedicated Opus 5 reviewer plus the orchestrator's own review means work is checked by
an agent that did not plan it and then by the agent that did -- two different failure modes covered
without a human in the loop.

**A self-measured context ceiling is more useful than a published one.** The 300k-token cap is
derived from observed divergence in his own workload, not from a spec sheet, and it is enforced as
a hard rule on the session rather than as a thing to watch.

**"It will refuse the request but execute the decomposition" is a reusable move.** The watch-video
skill exists because the task was restated as a sequence of tool calls rather than as a capability
request. That reframing, not any single tool, is what made it possible.

**A lead title can be a role shape rather than a rank.** At the Company effectively the whole AI team
carries the Lead AI Engineer title because each person may be leading a different project. A
candidate evaluating the offer should read the 60% hands-on figure, not the title, as the real
description of the job.

**The take-home tests critique, not construction.** Being asked to review agent code and propose
improvements selects for the ability to read someone else's agent design and find its faults -- a
different and rarer skill than writing one, and a sensible filter for a role that is 40% leadership.

---

## Corrections

Stated right-fact-first, as the ingesting agent should learn them. Each entry names what the two ASR
engines heard and what settled it.

**The company's real name is redacted for publication, but the two ASR engines agreed on it.**
Whisper heard the correct name consistently; the Google Meet caption engine got it right in some
places and produced the garbled variant "cieja" in others. Settled from pixels three independent
ways: the recruiter's LinkedIn profile headline "Talent Acquisition & People Ops Manager @the
Company", the company card beside it, and her inbox message "Opportunity: Lead AI Engineer at the
Company (Full remote,..." `[ON-SCREEN, frames f_008226 and f_000195]`.

**The role is Lead AI Engineer.** The Meet caption engine heard "leader engineer". Settled from
pixels: "Hiring: Lead AI Engineer & 1 other -- the Company - Brazil (Remote)" `[ON-SCREEN,
f_008226]`.

**The interviewer's identity (name redacted for publication) is the recruiter**, Talent
Acquisition & People Ops Manager at the Company, based in Rio de Janeiro `[ON-SCREEN, f_008226]`.
Whisper rendered her self-description in Portuguese as a string that is not a real Portuguese word;
the pixel evidence (her job title and company, read directly from her profile) supersedes it
entirely, so no guess at the spoken word is needed.

**The harness is Claude Code.** Both engines wrote "cloud code" at first mention (src 16:09). Whisper
itself then wrote "Claude code session" at src 18:55 and "in discussion with Claude" at src 18:21,
so the transcript's own internal inconsistency settles it. This is the exact failure mode the
package documents: an INCONSISTENT proper-noun error, where the correct spelling is also present and
therefore nothing flags the wrong one.

**The agent models are Opus 5, Fable 5 and Sonnet 5.** Whisper heard "an Opus five or a Fable five
agent ... usually SONF five"; the Meet captions heard "an oppos5 or a fable 5 agent ... sub agents
usually Sona 5". Two engines producing the same three-slot structure with the same two recognisable
names settles the third by position `[INFERRED]`.

**It is a cron job, not a Chrome job.** Both engines wrote "Chrome" -- the captions twice, as
"Process Chrome, a chrome job daily". Neither engine was right and the term is not on screen, so
this is settled by the sentence around it, which describes "a daily process ... that runs daily to
fetch" `[INFERRED]`. Recorded as a correction rather than a certainty: this is a case where the two
engines agreed and were both wrong, which is why agreement alone is a floor and not a ceiling.

**It is a RAG project.** Whisper wrote "RAC project" at src 12:45 and "REC project" at src 14:59;
the captions wrote "Rec project". Settled by the surrounding description -- embeddings, top-K chunk
retrieval, ingestion, generation `[INFERRED]`.

**Stage 3 of the hiring process is with the Head of AI.** The first decode produced "com o RedJI",
which reads as a person's name. Re-decoding that span alone, at two temperature settings, produced
"technical screening com o Head of AI" stably. It is a role, not a name.

**Three past employers are named, and all three are anonymized here as Employer A, Employer B and
Employer C.** The proper nouns themselves are redacted; the ASR finding they carry is not. For
Employer A the caption engine produced a mangled common-noun reading while whisper produced the
correct proper noun despite being pinned to English. Both engines agree on Employer B. Employer C
agrees across both engines at src 07:10 and is corrupted two different ways elsewhere; the agreeing
instance governs.

**The LinkedIn company page visible at 00:37-00:40 is NOT the hiring company.** It is Familiar
(linkedin.com/company/metavoiceio), "The duplex speech model for revenue calls. Formerly MetaVoice",
Artificial Intelligence, San Francisco, 5K followers, 11-50 employees `[ON-SCREEN, f_000195]`. It is
an unrelated browser tab that happened to be foregrounded for 2.8 seconds. Recorded because a
reader skimming frames would otherwise attach it to the interview.

### Not settled

**The embedding model version.** All three readings -- Meet captions, the first whisper pass, and
the tuned re-decode -- agree on the number and disagree on the name: "Queen 3.5", "Queen 3.5", "QAN
3.5". The family is audibly Qwen; the version is heard as 3.5 by every reading, but no Qwen release
is named 3.5 (the shipped families are Qwen2.5 and Qwen3). The term never appears on screen, so the
frames cannot adjudicate it. The whisper reading is kept and the identification is left open
`[UNRESOLVED]`. What IS settled is the word that followed it: the first pass and the captions both
produced "locomotto"/"locomotive", and the tuned re-decode resolved it to "local model".

**The founder's name.** "a executive interview com o team, que e o nosso founder" (src 27:29). Two
independent decodings both produce "team", which does not parse in that Portuguese sentence, where a
first name is expected. Kept as whisper heard it `[UNRESOLVED]`.

**The second contact person (name redacted for publication).** The first pass produced "com o
[REDACTED: contact's name]"; the tuned re-decode produced "com a [REDACTED: contact's name]", with
the feminine article. The re-decode is preferred but the name is not confirmed `[UNRESOLVED]`.

---

## Boundaries

**This document says nothing about how anyone performed.** No talk-share, no turn-taking, no
silence or pace analysis, no prosody, no micro-expressions, no outcome estimate, no behavioural
read of either participant. That is deliberate: this package does no behavioural analysis of any
kind. For a recording of two people talking, where the question is about the participants rather
than the material, the sibling package `video-autopsy` is the correct tool and it covers exactly
that ground. Nothing here should be read as a substitute for it or as a partial version of it.

**The source is a first-stage recruiter screening, not a technical interview.** Every technical
description in it is a candidate's unchallenged self-report, delivered in narrative form under no
verification. The RL pipeline, the RAG parameters, the orchestration pattern and the crypto pipeline
are all `[STATED]` and none was probed, tested, or corroborated by anyone in the call. Stages 3
through 6 of the process are where that would happen and they had not happened yet at recording
time.

**Compensation and process facts have no second source.** They sit in the Portuguese closing
region, which the English-pinned caption engine could not read. Single-engine facts here include the
[compensation figure redacted], the PJ contractor basis, the six process stages, the take-home contents and
the 24-hour convention.

**No code, no diagrams, no artifacts were shared on screen.** The entire recording is a Meet grid
plus live captions, with two brief excursions to LinkedIn (2.8 s and about 20 s) and 5.7 s of a job
board after the call ended. There is no implementation to reconstruct, no benchmark chart to read
and no repository named. Every technical claim above is therefore from speech, with the frames
contributing identity evidence (who, which company, which role) rather than technical evidence.

**The Company's own claims are unverified.** Headcount, founding year, funding model, client
geography and the two incubator projects are all the interviewer's description of her own employer,
given to a candidate. Only the company name, the role title, its remote status and her job title
were confirmed from pixels.

**Nothing here establishes what happened next.** The recording ends 5.7 seconds after the call, with
a job board on screen. There is no record of the take-home arriving, of any later stage, or of an
outcome.

---

## Value map: your environment

Mapped against the projects and working context visible in this session. Honest per-area; "no value
here" is a real answer and is used where it applies.

REDACTION NOTE. Each item below is a mix of the recording's own content (published in full, because
it was said in the recording) and the operator's private working environment (repo paths, private
project names and private file references, which are withheld). The private half is replaced in
place with an inline `[REDACTED: ...]` marker; everything else in the item -- the practice, the
reasoning, the transfer from the recording -- is unredacted.

**[REDACTED: private ML pipeline project].** Direct and immediate. The paper-trading gate described in
the call -- two weeks, hourly production inference, decisions to open, close and size, no real money
-- is the same promotion gate this project already has infrastructure for, and stating it out loud
as a fixed-duration precondition to capital is worth writing into the project's own decision record
rather than leaving as an intention. The RAG finding is the more actionable one: the two parameters
that dominated accuracy and recall were the embedding model and the top-K chunk count, both upstream
of the LLM. If anything in that repository does retrieval over its own documentation, those two are
where to spend tuning effort, and the benchmark-across-available-local-models method is the way to
choose. `[INFERRED]`

**[REDACTED: private performance-engineering track].** Almost no direct value, and the reason is worth
being explicit about. That track's whole method is pre-registration, same-session A/B, and refusing
claims the instrument cannot resolve; nothing in a recruiter screening improves on that. The one
transferable item is the two-review-passes orchestration pattern -- a reviewer agent that did not
plan the work, followed by the planner reviewing it again -- which maps onto that track's habit of
demanding a control that can actually fail. Everything else is orthogonal. `[INFERRED]`

**[REDACTED: private trading-agent project].** Partial. The staged promotion policy transfers directly: a fixed-duration
paper-trading window with the production inference path running on its real cadence, before any
capital, is the same discipline and the same failure it guards against. The RL-environment and
task-quality-guideline material does not apply -- that project is not producing training data.
`[INFERRED]`

**The watch-video skill family itself.** This is the strangest and most useful loop in the
recording. The decomposition described in the call at src 20:16 -- extract audio, run Whisper,
transcribe, read the transcript, and pull a frame whenever you want to see what was on screen at
that moment -- is the exact pipeline that produced this document. Two things in this run are
evidence that the design holds and one is evidence it is incomplete. It held: the frames settled the
company, the role and the interviewer's identity, none of which the audio could. It is incomplete:
the described decomposition has no second reading of the audio in it, and every correction in the
Corrections section above came from having one. If that skill is being maintained, the item to add
is a cross-check source, and this recording demonstrates an unusual one -- burned-in meeting
captions are a second ASR engine available in the pixels of any recorded Meet or Zoom call, at no
extra cost. It also demonstrates that a single pinned language silently destroys a bilingual
recording, which cost three extra passes here to detect and repair. `[INFERRED]`

**Multi-agent orchestration and daily working routine.** Mostly confirmatory rather than new: the
orchestrator/sub-agent/reviewer split and the Claude Code session model are already the working
pattern. Two items are worth adopting as written. First, the 300k-token session cap as a HARD rule
rather than a thing to notice, on the stated grounds that quality diverges past it. Second, the
daily cron job that fetches the last 24 hours from trusted sources, which converts staying current
from a browsing habit into a pipeline. `[STATED, then INFERRED as applicable]`

**The career and interview-preparation track.** The highest-value area, and mostly as raw material
rather than as insight. Concrete items to record: the six process stages in order; that stage 2 is a
written take-home with a critique-the-agent-code section and a 24-hour soft window, which is
preparable in advance; that stage 3 is a 30-minute conversation with the Head of AI; that the
engagement is PJ; that the stated ask is on the record as a specific monthly figure [compensation figure redacted]; and that the role is 60%
hands-on, which is the specific attribute named as the reason for leaving the previous role. One
cross-reference worth carrying: the job-board profile visible on screen after the call carries a standing salary
filter `[ON-SCREEN]` [compensation figures redacted], and the annualised form of the figure named
in the call matches it, so the number given in the call is consistent with the standing filter
rather than improvised.

**Behavioural self-review.** No value here, by construction. Any assessment of delivery, hesitation,
answer structure, or how the round is likely to have landed is out of this package's scope and is
not attempted anywhere above. If that is wanted for this recording, it is a separate run of
`video-autopsy` with its self-review overlay explicitly enabled, and it would read the same
recording for entirely different signal.

**[REDACTED: private document-tooling project].** No value here. Nothing in the source touches document rendering, viewer
behaviour, or the problems that project addresses. Listed only so the absence is on the record
rather than looking like an oversight. `[INFERRED]`
