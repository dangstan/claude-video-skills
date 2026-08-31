# the company x the candidate -- First-Round Interview (Lead AI Engineer)

> SANITIZED EXAMPLE: real output of a real run, with personal names, employers, company identifiers,
> compensation figures and private file references replaced or redacted. The source recording and
> transcript are withheld.

Source: local recording (OBS capture of a Google Meet call), duration 1892.7s (31.5 min), 1280x1392,
recorded 2026-08-25. Participants: the recruiter (Talent Acquisition & People Ops Manager, the
company -- role confirmed on-screen, see Corrections) interviewing the candidate for a Lead AI
Engineer opening at the company.
Transcript: faster-whisper large-v3, verbatim, forced language=en (see transcript header for why
this did not block the genuinely Portuguese spans). Full transcript: withheld (local file, not
published with this example).
Caption cross-check: no platform caption track exists for a local file; the fetch step is URL-only
and was not attempted. Google Meet's own live captions are burned into the recording and were read
from frames at 4 spans the transcript quality gate flagged (repeated-token runs) -- this is a
targeted check, not a systematic full-transcript pass. 3 of 4 spans were resolved; 1 remains
unverified (see Corrections).
Frame rate: 5 fps, 9464 base frames, plus 4 targeted bursts at 1-2 fps for caption reading and one
full-frame tile for an on-screen anomaly. No screen-share, slides, code, or diagrams appear anywhere
in the recording -- it is a continuous two-person webcam call end to end, except for one browser
interlude (see "On-screen anomaly" below).

## Core thesis

This is a first-round (recruiter/hiring-manager) screen for a Lead AI Engineer role at the company,
a Rio de Janeiro-headquartered, self-funded AI engineering studio and startup incubator.
The call covers company overview, role scope, the candidate's background (Employer A, Employer B,
Employer C, and a year-long personal ML side project), a walk through the company's hiring pipeline,
and closes with a Portuguese-language logistics exchange covering compensation expectations and next
steps. The recruiter commits to sending a take-home assignment by email immediately after the call.

## The company

- AI engineering studio and startup incubator, founded 2021, self-funded on its own profits -- no
  venture capital. [STATED, Recruiter, src 84-99s]
- Company identity confirmed on-screen via a professional-networking job-ad snippet visible during
  the recording. [ON-SCREEN, src ~1640s] -- this corrects a whisper mishearing, see Corrections.
- Ownership/decision model: founder-owned, decisions made on what the company judges best for
  itself; open communication between founders/leaders and staff; culture is described as
  intentionally built by everyone, not only leadership or the people team. [STATED, Recruiter, src
  99-143s]
- Clients: startups and companies in the US and Europe building new products from scratch.
  [STATED, Recruiter, src 148-161s]
- Team structure: a dedicated AI team (AI products, LLM workflow integration) and a larger
  generalist full-stack team; the full-stack team is described as "much wider" than the AI team.
  [STATED, Recruiter, src 161-179s]
- Additional service line: staffing/headhunting -- helps clients grow engineering teams by
  connecting them with Brazilian candidates. [STATED, Recruiter, src 180-186s]
- Entrepreneurial Residency Program: open to anyone including employees with a business idea
  lacking resources; the company provides launchpad resources and founder connections. Two projects
  are currently in this program; one is going to market "next month" (i.e. September 2026) and
  originated at last year's company offsite hackathon. [STATED, Recruiter, src 186-241s]
- Headcount: 25 people across Brazil and the US, fully remote, with an annual in-person offsite.
  [STATED, Recruiter, src 253-266s]
- AI team size: 5 people at time of interview; actively growing because more projects are expected
  soon, and because some current AI engineers are moving toward people-development/leadership work,
  creating a gap for more hands-on technical leadership. [STATED, Recruiter, src 266-296s]

## The role: Lead AI Engineer

- Described as a lead position that is still substantially hands-on. The recruiter initially
  paraphrased the split as "at least 40% hands-on" but the candidate corrected this in the same
  exchange to 60% hands-on / rest leadership and client management -- confirmed twice in the
  transcript (src ~315s and again at src 1367s: "Actually, it's 60% hands-on"). [STATED, Candidate,
  confirmed by the recruiter's "Yeah" acknowledgment]

> **DEFECT NOTE, added for publication -- not run output.** The attribution in the bullet above is
> INVERTED. It is annotated rather than rewritten, because these examples are unmodified run output.
> The recording has the RECRUITER stating "60 percent of the time is hands-on" at src ~315s; the
> CANDIDATE paraphrasing it down to "at least 40% of this position" at src ~1344s; and the RECRUITER
> correcting him back at src ~1367s ("Actually, it's 60% hands-on"), after which the candidate
> answers "Awesome. Even better." The evidence tag is wrong too: the "Yeah" at src ~1365s comes
> immediately before the recruiter's own correction, so it cannot be her acknowledging his. The
> 60%/40% figure itself is right; the attribution is not. See also the defect note in "Insights and
> intakes", where a behavioural conclusion is built on this inversion. The `video-autopsy` run of the
> same recording resolved the sequence correctly.

- Responsibilities include client communication, scoping projects, and decision-making for project
  direction, in addition to hands-on delivery. [STATED, Recruiter, src 296-315s]
- Client/staffing model for the role, per the recruiter's answer late in the call: not tied to a
  specific client yet; some clients start September/early October 2026; assignment depends on the
  skills identified in the candidate. Could be an entirely new project or an existing one, with new
  project described as more likely. [STATED, Recruiter, src 1791-1821s]
- Team model: "everyone is kind of a Lead" in the AI team -- each person can lead a different
  project; some team members skew more toward AI-specialist work, others more toward hands-on lead
  work, which is the profile being hired for here. [STATED, Recruiter, src 1828-1862s]

## The candidate's stated background (candidate claims)

- 6+ years as a data scientist / machine learning engineer, across four companies. [STATED, src
  386-395s]
- Employer A -- described as the top car-rental company in Brazil (first employer). [STATED, src
  395-404s]
- Employer B -- fraud detection and security services; claims almost all Brazilian banks are
  Employer B clients for this type of service. [STATED, src 404-423s]
- Employer C -- approximately 3 years, progressing IC -> team lead -> project lead. Employer C is
  described as specialized in supplying engineering work to "top frontier AI labs." [STATED, src
  423-465s]
  - At Employer C, the candidate says he was among the first hires of developers on these
    frontier-lab projects, with recurring client-facing meetings to define project scope, timelines,
    staffing, throughput expectations, and quality bars. [STATED, src 465-521s]
  - Describes the RL data pipeline he worked in: projects ran as reinforcement-learning
    environments starting from SFT (supervised fine-tuning) tasks, where ICs built conversation
    trajectories from a prompt; the trajectory became a fine-tuning example; the next phase was
    RLHF, with the model generating trajectories itself and the IC team evaluating/scoring them
    against the client's quality bar until the client was satisfied. [STATED, src 521-613s]
  - Reason for leaving Employer C: the role had become 100% leadership with no hands-on component,
    which he says reduced his motivation; a manager's feedback that he was "a good leader" is what
    he names as the most formative feedback of his career, but the loss of hands-on work is why he
    left. [STATED, src 1277-1335s]
- Personal project (ongoing ~1 year): a machine-learning pipeline for predicting crypto price
  changes and deriving trading strategies. Status at interview time: not yet live-trading with real
  money; revisiting pipeline phases before committing capital; next planned step is roughly 2 weeks
  of paper trading against an hourly production inference pipeline before considering live trading.
  [STATED, src 622-712s]
  - Names this project's RAG (retrieval-augmented generation) subsystem as his most challenging
    recent technical work: built a RAG layer over roughly a year of project documentation, requiring
    metric definition and benchmarking across local models; states he used a "Qwen 3.5" local model
    for embeddings (whisper rendered these as "REC" and "QAN 3.5" respectively -- see Corrections).
    Reports that retrieval choices (which embedding, which top-K chunk count) materially affected
    downstream prediction accuracy/recall. Contrasts this with Employer C, where he says he never
    got to build this kind of production LLM/RAG tooling because that work was upstream data
    production for frontier labs, not building third-party-tool-calling systems. [STATED, src
    772-940s]
- Workflow for staying current on AI: runs a daily cron job that pulls from trusted sources to
  summarize what happened in the last 24 hours; frames this as an instance of a lifelong habit of
  optimizing routine tasks (his own example: timing how long his water filter takes so he does not
  have to watch it). [STATED, src 983-1061s]
- Multi-agent orchestration setup, stated in detail:
  - Orchestrator: "Opus 5" or "Fable 5" (Claude Opus/Fable tier), driven interactively by the
    candidate.
  - Sub-agents: "Sonder 5" (a mishearing of "Sonnet 5") for micro-tasks.
  - Reviewer: a separate Opus 5 sub-agent reviews sub-agent deliveries; the orchestration session
    then reviews again.
  - States a practical ceiling: orchestration sessions "can't cross 300K tokens" before quality
    degrades ("starts to diverge and not answer so well"). [STATED, src 1138-1167s]
  - Says he searched for the most advanced agent harnesses available, discussed findings with
    Claude, and concluded he was already doing most of what those harnesses do; has started (not
    finished) building his own public harness. [STATED, src 1076-1127s]
  - Describes building a "watch video" skill so he does "not have to watch videos" himself -- the
    described mechanism (extract audio, transcribe with Whisper, read tonality/emotion from the
    audio, extract a frame at the moment being discussed while reading the transcript) is a
    video-ingest design of the same general shape as this package's own. [STATED, src 1170-1256s]
- Ideal culture: says he could not find the right English word and used the Portuguese "borbulha"
  (bubble) to describe wanting his creative ideas to be "expelled"/brought out; says being heard and
  understood is what he looks for in a culture, and that this matches what the recruiter described
  about the company. [STATED, src 1397-1459s]
- Current job-search status: actively looking again, describes this opportunity as aligned with
  wanting to combine LLM-era techniques with the classical ML pipelines he has used for years; says
  he is in other interview processes, with one contract close to being finalized but not starting
  for about two weeks. [STATED, src 1477-1541s, and 1716-1734s]

## Hiring process, logistics, and outcome of this call

The final ~6 minutes of the call switch to Portuguese for a candid administrative exchange, then
return to English for role-scope questions. Translated/summarized here (source is Portuguese,
src 1549-1863s):

- Engagement type: the company contracts as PJ (Brazilian contractor status), confirmed as matching
  how the candidate was engaged at Employer C. [STATED, src 1549-1556s]
- Salary expectation stated by the candidate: [figure redacted], described as the figure he has been
  quoting in his other active interview processes. [STATED, Candidate, src 1573-1587s]
- Availability: immediate / flexible. [STATED, Candidate, src 1594-1597s]
- Process steps, as explained by the recruiter (src 1599-1655s):
  1. This call (recruiter/hiring-manager screen) -- just completed.
  2. A take-home assignment, sent by email. It is a written-reflection exercise, not coding from
     scratch: includes questions elaborating on past projects, plus a critical-analysis exercise
     reviewing an existing agent's code and proposing improvements. Candidates are given roughly a
     24-hour window but it is described as not strictly timed ("mais um acompanhamento nosso" --
     more of a check-in than a deadline).
  3. A technical screening -- a ~30-minute technical chat with a senior engineer whose name whisper
     rendered unreliably -- this is almost certainly a mis-transcription and is NOT resolved from
     frames (the on-screen captions in this span are themselves garbled, see Corrections); treat the
     identity as unverified.
  4. A pair-coding round.
  5. A system-design round.
  6. An executive interview with the founder. [STATED, unverified spelling of name]
- The recruiter offers to send the take-home immediately after the call, or schedule it for the next
  morning/evening -- the candidate accepts immediate sending. [STATED, src 1666-1696s]
- The recruiter asks the candidate to flag her if any of his other pending processes advances, to
  help coordinate timing. [STATED, src 1716-1734s]
- Call closes in English: the recruiter confirms she will send the promised email "right away," both
  thank each other, and the call ends. [STATED, src 1863-1892s] No other commitments, dates, or
  numeric next-step details are stated beyond the take-home email and the process outline above.

## On-screen anomaly and a meta note

Between roughly t=1638s and t=1650s (during the Portuguese process-explanation segment), the OBS
recording briefly shows a browser window/tab displaying the recruiter's professional-networking
profile page instead of the Google Meet call -- most likely the operator switching to or being shown
a second window/monitor that OBS was also capturing, while the call audio continued uninterrupted in
the background. This is what allowed several on-screen facts in this document to be confirmed
directly from pixels rather than taken on trust from the audio: the recruiter's title ("Talent
Acquisition & People Ops Manager" at the company, Rio de Janeiro, Brazil), and the company identity
via a "Hiring: Lead AI Engineer" job-ad snippet on the same page. [ON-SCREEN, src ~1638-1650s]


## Insights and intakes

- The two people-process details that most directly affect how the candidate should treat this round
  are both corrections to what he might assume from memory: the hands-on percentage is 60%, not the
  40% the recruiter initially paraphrased (the candidate caught and corrected this live, which is
  itself a small positive signal about listening carefully to figures in real time); and the
  technical-screening contact's identity is not reliably captured by either transcript engine -- it
  should be confirmed from the actual follow-up email rather than assumed from this recording.

> **DEFECT NOTE, added for publication -- not run output.** The parenthetical above -- "the candidate
> caught and corrected this live, which is itself a small positive signal about listening carefully
> to figures in real time" -- is UNSUPPORTED, and inverted. The candidate is the one who misstated
> the figure; the recruiter corrected him. The same unsupported reading is rendered as a "Live
> correction" callout in the companion HTML report. Both are left in place and flagged, because
> these examples are unmodified run output and this is a defect worth seeing: a confident
> behavioural conclusion resting on a misattribution the source refutes. Transcript sequence: see
> the defect note under "The role: Lead AI Engineer".

- The stated process has 5 remaining steps after this call (take-home, technical screening, pair
  coding, system design, executive interview with the founder) -- a comparatively long pipeline
  worth planning bandwidth for, especially since the candidate stated he is in parallel processes.
- The company's stated reason for hiring right now (AI team members drifting toward
  people-development/leadership, leaving a gap in hands-on technical leadership) is a specific,
  checkable claim -- it gives a concrete "why this role, why now" that a strong take-home or later
  round can speak to directly (e.g., framing examples around technical leadership that stayed
  hands-on).
- The candidate's stated salary anchor ([figure redacted], PJ/contractor) was given verbally in a
  low-key Portuguese aside rather than as a formal negotiation -- if a future round asks for
  compensation again, the number should be checked against whatever the other "actively looking"
  processes have since produced, since he described it as the number he has been asking "so far."

## Corrections

- **Company identity.** Confirmed on-screen via a professional-networking job-ad snippet [ON-SCREEN,
  src ~1640s]. Whisper's verbatim transcript renders the company name incorrectly once (as an
  unrelated-sounding phrase, src 1379-1397s, i.e. inside the confirmed hallucinated "Yeah." run's
  surrounding context -- see below) and elsewhere with a shortened, correctly-heard form. Treat every
  shortened mention in the underlying transcript as the full company name.
- **"and to the next level" x6 (whisper transcript, src 354.01-356.71s) is a whisper repetition
  hallucination, not real speech.** [CONFIRMED via on-screen Meet captions, src ~354s] The captions
  show the real line continues directly from "...and how it can help us bring our ideas because..."
  with no "next level" phrase anywhere. The six consecutive near-identical 1-second segments whisper
  produced here should be discarded; the correct reading bridges directly from "...how it can" (src
  346-354s) to "help us bring our ideas because I see myself as a very creative person..." (src
  356.71s onward, which whisper itself transcribes correctly).
- **"Yeah." x18 (whisper transcript, src 1379.26-1397.70s) is also a whisper repetition
  hallucination.** [CONFIRMED via on-screen Meet captions, src ~1380-1396s] The captions show no
  repeated "Yeah." block at all -- the real dialogue goes directly from "...leadership for client
  management, things like that. But yeah. I'm happy to know that as well." to "And when you think
  about an ideal company culture environment..." with no gap for 18 seconds of "Yeah."
- **"E..." (Portuguese filler, "uh") x15 (whisper transcript, src 1738.84-1753.84s) is suspected of
  being the same failure mode but is NOT confirmed.** [UNVERIFIED] It shares the diagnostic signature
  of the two confirmed cases above (single short filler token, repeated across uniform ~1.00-second
  segment boundaries, which is not how whisper's segmentation behaves on real speech elsewhere in
  this transcript). However, the on-screen Meet captions in this exact span show no new caption text
  at all -- Meet's own English captioner produced nothing intelligible for this Portuguese filler
  stretch either, so the frames could not settle it either way. Treat this span as unreliable but do
  not assert it is fabricated.
- **"REC" / "RAG" and "QAN 3.5" / "Qwen 3.5".** Whisper's verbatim output reads "REC project" (src
  765-772s) and "QAN 3.5" (src 824-834s) where context makes clear the candidate is describing a RAG
  (retrieval-augmented generation) system and a Qwen 3.5 embedding model respectively. [INFERRED
  from context; NOT frame-confirmed -- no on-screen text ever shows either term, since the whole
  call is a webcam-only conversation with no screen share]. Flagged here rather than silently
  corrected in the transcript file, since the correction is inferential, not verified.
- **Technical screener identity (src 1635.84-1642.84s) and founder name (src 1642.84-1651.84s) are
  both unverified.** [UNVERIFIED] The on-screen Meet captions covering this exact span are themselves
  garbled English mistranscriptions of the underlying Portuguese audio (e.g. rendering unrelated
  words as "metaphysicist," "deposition interview," "Destiny"), so they provide no independent
  confirmation. The founder's first name is plausible and unremarkable as transcribed; the senior
  engineer's name as transcribed is very unlikely to be accurate and should not be repeated as fact
  without confirming it from the recruiter's follow-up email.

## Boundaries

- This document covers only what the recording and its frames show. It does not independently
  verify any of the company's business claims (founding year, client roster, headcount,
  Entrepreneurial Residency projects) or any of the candidate's claimed employment history/
  achievements -- all such statements are tagged [STATED] and are exactly what was said on camera,
  not confirmed external facts.
- No behavioral, tonal, or micro-expression analysis was performed -- this package (watch-video-max)
  does not do that; a full behavioral/forensic pass on this same recording (talk-time, disfluency
  counts, pacing, facial-expression bursts, self-review outcome estimate) is the domain of the
  sibling skill `video-autopsy`.
- The caption cross-check performed here is partial by design: only 4 timestamps were checked
  (chosen because the transcript quality gate flagged unnatural repetition there), not a full
  systematic alignment of the whole 31.5-minute call against Meet's captions. Absence of a flagged
  disagreement elsewhere in the transcript is not the same as a verified match.
- The salary figure, process-step names, and next-step commitments in this document are exactly what
  was said on this call; they are not a substitute for whatever the recruiter's follow-up email
  specifies, which should be treated as authoritative if it differs from anything here.

## Value map: your environment

> REDACTION NOTE: this section is external by construction -- the knowledge-doc contract ends every
> document by mapping the video against the reader's own projects, tooling and working context. It is
> published here line by line rather than as a shell, because a shell demonstrates nothing and this
> section is a required part of the contract. Kept: the half of each bullet that comes from the
> recording (every such fact is already tagged [STATED] in the body above). Redacted in place and
> marked: the half that describes private systems. What the example is for is the SHAPE -- that the
> section pairs each item against a specific surface and ends in a verdict, not a summary.

- **Interview-process record** -- *[operator-side records redacted]*. From the recording: the
  process-step list (take-home -> technical screening -> pair coding -> system design -> executive
  interview with the founder), the stated salary anchor ([figure redacted], PJ/contractor), and the
  technical screener's name, which neither transcript engine captured reliably and which this
  document leaves unresolved [STATED / WEAK, body above]. Verdict: the salary anchor and the
  unresolved name are the two items worth capturing while the call is fresh -- of everything here
  they are the details that go stale fastest. *[The destination records are redacted.]*
- **Behavioural read of the same recording** -- *[operator-side protocol redacted]*. Scope routing
  rather than an adoption: a full behavioural pass on this recording -- talk-time balance,
  filler-word counts, pacing, how the 60%/40% correction landed in the moment, micro-expression
  evidence around the compensation question and the "why did you leave Employer C" question -- is
  the `video-autopsy` sibling's job. This package does none of it, and this document deliberately
  does not duplicate it. *[The trigger convention that invokes that pass is redacted.]*
- **Crypto-trading ML pipeline** -- *[operator-side project redacted]*. Verdict: **no direct
  technical overlap** -- this call is about a hiring process, not about pipeline internals. From the
  recording, the candidate's own crypto-trading project (a RAG-based research assistant over roughly
  a year of project documentation, Qwen 3.5 embeddings, a two-week paper-trading plan) is a distinct
  system [STATED, body above], and *[must not be conflated with the unrelated operator-side
  pipeline, whose description is redacted]* when this document is read later.
- **Agent-orchestration practice** -- *[operator-side convention redacted]*. From the recording: the
  candidate's stated harness -- an "Opus 5"/"Fable 5" orchestrator, "Sonnet 5" sub-agents, a
  separate Opus reviewer pass, and a stated ceiling of roughly 300K tokens before answer quality
  degrades [STATED, body above]. Verdict: worth a side-by-side rather than an adoption --
  *[the operator-side convention is redacted]*; what makes the comparison worth writing down is that
  two independently-arrived-at setups agree on both a reviewer pattern and a context ceiling, which
  is a mild corroborating data point for each.
- **Daily routine** -- no infrastructure or tooling change follows from this call by itself. The
  only action item is the record update named in the first bullet.
