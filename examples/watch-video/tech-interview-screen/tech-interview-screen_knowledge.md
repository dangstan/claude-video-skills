# the company Screening Call -- the recruiter x the candidate, Lead AI Engineer Role

> SANITIZED EXAMPLE: real output of a real run, with personal names, employers, company identifiers,
> compensation figures and private file references replaced or redacted. The source recording and
> transcript are withheld.

Source: local recording, 2026-08-25, Google Meet screening call, 31.5 minutes (1892.7s).
Participants: the recruiter (Talent Acquisition and People Ops Manager, the company) and the
candidate (candidate, Lead AI Engineer role). Transcript: prior faster-whisper large-v3 verbatim
decode, reused from an earlier watch-video-max run against the same source file (no whisper
re-run in this pass); independently checked in this pass against the burned-in Google Meet
caption track visible in the recording's frames, without reading the prior run's own knowledge
document first. Topic tags: job-interview, screening-call, AI-engineering-hiring.

## Core thesis

This is a first-round recruiter screening call for a Lead AI Engineer opening at the company, a
bootstrapped Brazil/US AI engineering studio and startup incubator. The call has two halves: the
recruiter explains the company's business, team structure, and hiring process; the candidate walks
through his background (Employer A, Employer B, Employer C, and a year-long personal crypto-trading
ML project), answers behavioral questions, and the two agree on next steps (a take-home assignment)
and confirm compensation expectations and availability. The call switches from English to Portuguese
partway through once the "get to know you" portion ends and the recruiter moves into
administrative/process territory, then switches back to English for a final substantive question
about the role.

## the company -- company facts [STATED by Recruiter]

- AI engineering studio and startup incubator, founded 2021.
- Bootstrapped: "sustained by our own profits," no venture capital, no VC-driven pressure; the
  team are described as the owners making their own decisions.
- 25 people total, split between Brazil and the United States, fully remote; the team gathers in
  person at least once a year for an offsite.
- Culture is described as bottom-up: "the culture within the company should be created by everyone,
  not only the leaders or the people team" -- anyone can propose initiatives or internal tooling.
- Clients are based in the US or Europe, typically startups building something new from scratch.

### Team structure [STATED]

- A dedicated AI team (5 people as of this call) building AI products from scratch or improving
  client workflows with LLMs.
- A larger, more generalist full-stack team doing broader software development work; some of
  those engineers also touch AI work but skew generalist.
- A staffing/headhunting service: the company connects clients who want to grow their own
  engineering teams with Brazilian candidates.
- The Entrepreneurial Residency Program (open to outside applicants and to existing employees):
  provides initial resources, a "launchpad," and connections to other founders for people with an
  idea they want to develop but lack resources or a starting point. Two projects are currently in
  this program; one is going to market the following month at the time of the call. That project
  originated at the previous year's company offsite hackathon -- an engineer who "didn't even
  think he was going to ever be an entrepreneur" ended up building a company out of it.

### The open role [STATED]

- Lead AI Engineer. The AI team is being grown because the company expects more AI project volume
  soon; some existing AI engineers are moving toward people-development/leadership work, creating a
  gap for engineers who can absorb technical delivery plus client communication and project-scope
  decisions.
- The recruiter first states the role is roughly 40% hands-on technical work with the balance in
  leadership/client management, then corrects herself moments later in the same call: "Actually,
  it's 60% hands-on... And then the rest is leadership or client management, things like that."
  Take the 60%/40% split as the operative figure -- it is the one she settled on, and it is also
  the number the candidate responded positively to.

> **DEFECT NOTE, added for publication -- not run output.** The attribution in the bullet above is
> WRONG. It is annotated rather than rewritten, because these examples are unmodified run output.
> The recording has the RECRUITER stating "60 percent of the time is hands-on" at src ~315s; the
> CANDIDATE paraphrasing it down to "at least 40% of this position" at src ~1344s, seventeen minutes
> later; and the RECRUITER correcting him back to 60% at src ~1367s. So there was no self-correction,
> the initial figure was never 40%, and the two moments are not "moments" apart. The 60%/40% split
> itself is correct; only the attribution and the ordering are wrong. The `video-autopsy` run of this
> same recording resolved the sequence correctly (see its "Hands-On percentage resolution" entry) --
> which is exactly why all three runs of one source are published side by side.

- Everyone on the AI team effectively carries a "Lead" designation because each person may lead a
  different project; within that, some lean further toward hands-on AI engineering and others
  further toward the client-facing Lead role. The company is looking for someone who can do both:
  position directly with the client, make decisions, and lead other engineers.
- Engagement type: PJ / independent-contractor arrangement (Brazilian contractor structure), the
  same arrangement the candidate had at his previous employer (Employer C).
- Project assignment for this specific candidate is not yet fixed: the company has clients starting
  September/early October, and where a new hire lands depends on timing and on which of the
  candidate's strengths get identified during the process. It could be an entirely new
  incubator-style project or an existing one, with new-project odds described as high.

## Hiring process [STATED by Recruiter, disclosed mid-call]

1. This screening call with the recruiter (People Ops) -- completed.
2. A take-home assignment, sent by email: a written-reflection exercise, not from-scratch coding.
   Includes questions elaborating on past projects, and a section asking for a critical analysis
   of an existing agent's code with proposed improvements. Framed as roughly a 24-hour window once
   sent, but explicitly not a hard timer -- the candidate can start, pause, and resume.
3. A technical screening: a roughly 30-minute technical conversation with a senior engineer (name
   given verbally, transcribed unreliably [WEAK], treat as unverified until confirmed).
4. A pair-coding round.
5. A system-design round.
6. An executive interview with the founder.

The recruiter commits to keeping the candidate updated by email at each stage and offers herself,
plus a colleague, as points of contact for help during any stage.

## Candidate background -- the candidate [STATED]

- Data scientist / machine learning engineer, 6+ years of experience across four companies.
- Employer A: described as the top car-rental company in Brazil.
- Employer B: fraud-detection and security services provider; almost all major Brazilian banks are
  described as Employer B clients for this type of service.
- Employer C: 3+ years, starting as an individual contributor (IC), then team lead, then project
  lead. Employer C is described as specialized in supplying labeled/RL training work to top
  frontier AI labs. The candidate was one of the first hires on this line of work and had recurring
  direct discussion with client teams to scope new projects: defining project scope and timeline,
  sizing the number of ICs needed, setting expected throughput, and defining what counted as a
  "high quality" task. Each project ran as a reinforcement-learning environment: an SFT (supervised
  fine-tuning) phase first, where ICs manually built conversation trajectories with the available
  tools against a target prompt whose request had to be fulfilled by the end of the trajectory
  (this became a test fed to the model); followed by an RLHF phase, where the model itself
  generated trajectories that the IC team evaluated for quality, iterating until the client was
  satisfied with model performance on that task or benchmark.
- Personal project, ongoing roughly one year at the time of this call: a machine learning pipeline
  for predicting cryptocurrency price changes and deriving trading strategies from the model
  output. Described as having grown far more complex than originally expected. Some live-money
  trades were attempted early on, but the candidate is not yet confident enough to trade live
  consistently and is revisiting pipeline phases before doing so. The immediate next step (at the
  time of the call) is a two-week paper-trading phase: an hourly production inference pipeline
  that opens, holds, or closes simulated positions without real money, as the confidence gate
  before moving to live trading.
- Most challenging project cited, when asked specifically about LLM/AI work (as opposed to the
  Employer C RL work): a retrieval-augmented-generation system built for the crypto personal
  project (referred to in the transcript as the "REC project" -- near-certainly a mishearing of
  "RAG," i.e. Retrieval-Augmented Generation [INFERRED]). It ingested roughly a year of accumulated
  project documentation. Challenges cited: defining evaluation metrics, benchmarking available
  local models, and choosing an embedding model -- the candidate names "QAN 3.5" as the local model
  used for embedding, near-certainly Qwen 3.5 (Alibaba's open-weight LLM family) [INFERRED]. He
  states that the choice of embedding model and the top-K retrieved-chunk count materially
  affected downstream prediction accuracy and recall. He frames this project as filling a gap left
  by Employer C, where the work was to produce training data FOR frontier labs rather than to build
  and operate an LLM application, so he never got hands-on production-RAG experience there.

## Staying current with AI and personal orchestration workflow [STATED]

- Runs a daily cron job that pulls from a set of trusted sources to summarize what has happened in
  AI over the prior 24 hours.
- Describes himself as habitually optimization-minded across his whole life (his own example: he
  times how long his water filter takes to fill so he can set an alarm and walk away instead of
  watching it).
- Recently researched "the most optimized and most advanced harness" options available, working
  through the comparison in discussion with Claude; concluded that most of what other setups were
  doing, he was already doing in his own harness. Has since started, but not finished, a public
  repository for it.
- Personal orchestration pattern, as described: an orchestration Claude Code session that he
  directs directly, typically running as an "Opus 5" or "Fable 5" agent; that orchestrator calls
  sub-agents (referred to as "Sonder 5" in the transcript -- almost certainly "Sonnet 5"
  [INFERRED]) for micro-tasks; an Opus 5 sub-agent reviews those sub-agent deliveries; and the
  orchestration session itself also reviews the results. He states a specific empirical ceiling:
  the orchestration session starts to diverge and answer less well once it crosses roughly 300K
  tokens of context.
- Describes having built a Claude Code skill he calls "watch video," specifically so he does not
  have to watch videos himself. His own description of it: extract the audio; optionally run a
  tool like Whisper to read embedding/tonal/emotional traits of the audio; transcribe the audio;
  read the transcription; and whenever the transcription references something visual, pull a
  video frame for that specific moment. He states this is exactly what makes it possible to "watch
  a video" through an agent that otherwise refuses ("if you ask, oh, watch a video for me, it says
  I can't... but if you specify what it has to do, then it is able to do it").
- Recently became more active generally in building Claude Code skills at his current work, and
  describes it as materially helpful.

## Behavioral answers [STATED]

- Formative feedback: a superior at Employer C told him he was a good leader, which surprised him
  -- he had not seen himself that way before becoming one there. That same superior also observed
  he was less motivated once his role became 100% leadership work with no hands-on component; the
  candidate states this observation is the direct reason he left Employer C. He responded to the
  recruiter's 60% hands-on figure for the role as directly addressing this: "I needed to feel that
  I'm contributing because it's how I can quantify my delivery and see its impact."
- Ideal culture: describes himself as very creative, generating many ideas that he feels need to
  be "expelled" or brought out (he used the Portuguese word "borbulha" -- roughly "bubbling" or
  "effervescent" -- and could not find a satisfying direct English translation for it on the
  call). States that being heard and understood is the culture trait he looks for most, and that
  the company's stated open/bottom-up culture (as the recruiter described it earlier in the call)
  resonates with that.
- Current job-search status: actively looking again, driven by a mix of two things -- this
  specific opportunity, and a general desire to re-enter the market and combine current
  LLM-era solutions with the classical machine learning pipelines/models he has used for years.

## Logistics confirmed on the call [STATED, Portuguese-language section]

- Compensation: the candidate states his standing ask across current interview processes is
  [figure redacted].
- Contract type: PJ/contractor, matching his prior Employer C arrangement; confirmed as acceptable
  to both sides.
- Availability: the candidate describes himself as flexible, close to immediately available.
- Competing process: the candidate has another process in progress that is close to a final stage;
  if it converts, the resulting contract would only actually start about two weeks out. The
  recruiter asks to be kept informed if that other process advances, so the company can factor it
  in.
- Take-home timing: the recruiter offers to send the take-home assignment either immediately after
  the call or on a delayed schedule (next morning or end of next day); the candidate opts to
  receive it right after the call ends.
- A meeting-transcriber export tool is referenced in passing -- the recruiter asks whether it would
  have been fine to have it running for this call; the candidate says it is not a problem either
  way.

## Corrections

The transcript this document is based on is a whisper large-v3 verbatim decode, and it contains
material hallucinated-repetition defects, independently checked in this pass against the
burned-in Google Meet caption track visible in the video's own frames (Google Meet was running
live English captions with auto-translate throughout the call).

1. **Confirmed hallucination.** Around 356 seconds, the source transcript reads a 6-times-repeated
   phrase, "and to the next level," crammed into about 2 seconds -- not physically possible as
   real speech. The burned-in Meet caption at this exact timestamp shows no such repeat: the real,
   single continuous sentence is "...and to understand more about this internship in entrepreneur,
   um? Uh, occasion, and and how it can help us bring our ideas because I, I see myself as a very
   creative person..." The candidate was connecting "how it can help us" to "bring our ideas," not
   repeating "next level" six times. Corrected in the accompanying transcript file.

2. **Confirmed hallucination.** Spanning roughly 1378-1397 seconds, the source transcript reads an
   18-times-repeated single word, "Yeah." The burned-in Meet caption for the recruiter's speech
   across this exact window shows a single natural sentence with no repeat: "...I'm happy to know
   that as well and. And when you think about an ideal company culture environment(s) that helps
   to bring out the best of you as a professional, what type of company culture comes to your
   mind?" -- followed directly by the candidate's real answer, "I think it resonates specifically
   with that culture because as I said, I am someone who is..." No 18x "Yeah" exchange occurred;
   this reads as a hallucination filling what was likely a brief natural pause. Corrected in the
   accompanying transcript file.

3. **Partially corroborated, NOT corrected.** Spanning roughly 1738-1754 seconds, the source
   transcript reads a 15-times-repeated Portuguese filler, "E..." (a common Brazilian Portuguese
   hesitation marker, roughly "and..."). The burned-in Meet caption for this exact window is
   itself garbled and nonsensical in a way consistent with the live English auto-translator
   failing on genuine, sustained Portuguese speech ("Namaste problem," "Palestination. Atlas,
   California."). This corroborates that the recruiter was genuinely speaking through a real
   hesitation-filled pause at this point, but it does NOT confirm the literal word or the exact
   15x repeat count claimed by the whisper decode. Left as-is in the transcript, flagged as
   uncertain in exact content rather than corrected.

4. **Genuine language switch, verified.** The source transcript decodes roughly 1547-1780 seconds
   as Portuguese despite an English language tag forced at transcribe time, with English resuming
   around 1779-1892 seconds. This is a real code-switch, not a transcription artifact: at the
   boundary (~1547s), the burned-in Meet caption shows the recruiter thanking the candidate for
   speaking English immediately before the switch (matching "Obrigada" -- Portuguese for "thank
   you" -- as the first word after the switch); deeper into the span (~1779s and ~1880s), the Meet
   English auto-translate captions independently degrade into nonsense, corroborating genuine
   non-English speech at those points too.

## Boundaries

This is a single first-round recruiter screening call, not a technical interview -- no coding, no
system design, and no deep technical probing occurred. It establishes company context, role
framing, and logistics, and surfaces the candidate's self-reported background and working style,
but it does not constitute technical evaluation of his skills. The Portuguese-language
administrative segment (process logistics, compensation, scheduling) was decoded by whisper without
a systematic independent transcript-quality pass across its full length -- only the specific
anomalies flagged above were frame-checked; the remainder of that segment (as transcribed) has not
been separately verified against the burned-in captions. The exact identity of the named
technical-screening interviewer, and the exact translation of "borbulha," were not resolved on the
call itself.

## Value map: your environment

> REDACTION NOTE: this section is external by construction -- the knowledge-doc contract ends every
> document by mapping the video against the reader's own projects, tooling and working context. It is
> published here line by line rather than as a shell, because a shell demonstrates nothing and this
> section is a required part of the contract. Kept: the half of each bullet that comes from the
> recording (every such fact is already tagged [STATED] in the body above). Redacted in place and
> marked: the half that describes private systems. What the example is for is the SHAPE -- that the
> section pairs each item against a specific surface and ends in a verdict, not a summary.

- **Crypto-trading ML pipeline** -- *[operator-side project redacted]*. From the recording: a
  year-long ML pipeline predicting cryptocurrency price changes, a two-week paper-trading phase on
  an hourly production inference loop as the confidence gate before live trading, and prior
  hesitance to commit real money [STATED, body above]. Verdict: **nothing to adopt** -- the call
  describes the project at hiring-conversation altitude, not implementation altitude, so there is no
  technique in it to take. Its durable value is the timestamped record of a commitment made out
  loud: two weeks of paper trading, then reassess. *[The comparison against the operator's own
  pipeline state, and the interview-preparation reading of that commitment, are redacted -- private
  project state and personal advice.]*
- **Multi-agent orchestration / model routing** -- *[operator-side convention redacted]*. From the
  recording: an orchestration session the candidate directs himself, running as an "Opus 5" or
  "Fable 5" agent; "Sonnet 5" sub-agents for micro-tasks; a separate Opus 5 sub-agent that reviews
  those sub-agent deliveries; the orchestration session reviewing the results again; and a stated
  empirical ceiling of roughly 300K tokens of context before the session starts to diverge [STATED,
  body above]. Verdict: **nothing to adopt** -- this is a description of a working pattern, not a
  new mechanism. *[The side-by-side against the operator's own routing rules and documented context
  budget is redacted -- internal convention.]*
- **Agent-built video ingestion** -- *[operator-side tooling redacted]*. From the recording: the
  candidate describes a Claude Code skill he calls "watch video", built so that he does not have to
  watch videos himself -- extract the audio, optionally run a tool to read tonal/emotional traits of
  it, transcribe, read the transcription, and pull a video frame whenever the transcription
  references something visual [STATED, body above]. One design observation that stands without any
  environment to compare against: that description folds tonal/emotional reading and content
  extraction into one package, and those are different jobs with different costs -- a
  transcript-plus-frames comprehension pass does not need audio analysis at all. *[The mapping onto
  the operator's own tooling is redacted.]*
- **RAG / retrieval-augmented generation technique** -- *[operator-side project redacted]*. From the
  recording: on a RAG system built over roughly a year of accumulated project documentation, the
  choice of embedding model and the top-K retrieved-chunk count materially affected downstream
  accuracy and recall [STATED, body above]. Verdict: **a real, transferable lesson and still a
  no-adopt here** -- *[the operator-side target has no retrieval or generation component today; its
  architecture is redacted]*, so there is no forced relevance. Recorded rather than dropped: a value
  map that lists only matches has stopped discriminating.
- **Interview-process record** -- *[operator-side records redacted]*. From the recording, the facts
  this call fixes: the compensation figure the candidate gives as his standing ask across current
  processes [figure redacted, body above]; the 60%/40% hands-on/leadership split (60% is the
  operative number -- but see the defect note in the role section above, which this document gets
  wrong about who said what); the five stages that follow this
  screen (take-home -> technical screening -> pair coding -> system design -> executive interview
  with the founder); and the stated reason for leaving Employer C -- the role became
  leadership-only with no hands-on component [all STATED, body above]. *[Which private records those
  facts are logged into, and the interview-preparation guidance that followed from them, are
  redacted -- private records and personal advice.]*
