# video-autopsy -- operational pitfalls

Each entry below is a failure that actually happened while running these autopsies, and the check
that would have caught it. They are here because every one of them produces output that looks
correct: a broken measurement in this domain does not throw, it returns a clean-looking number.

## Measurement traps

**A silence parse that comes back empty reads as "0.0% silence".** `silencedetect` output goes to
stderr interleaved with the progress stream, and a bare `2>&1 | grep silence_start` can swallow it
entirely. Capture with `-hide_banner -nostats` and grep for `silencedetect`. Then check the event
count is non-zero BEFORE believing the figure. Zero silence is a plausible result, which is exactly
why a broken parse hides there.

**A call-average hides every per-phase finding.** One round measured 43.2% silence in its coding
window, 7.8% in its theory window and 2.7% in a talk-only round the same day. Averaged across the
call, all three disappear. Always split at phase boundaries.

**Talk-share computed on a half-captured recording names the wrong dominant speaker.** Run the
audio-capture check first, every time, and state the result in the transcript header.

**A multi-channel recording is not automatically a duplicated one.** Measure per-channel RMS,
difference RMS and correlation at lag 0 before reaching for de-echo. Correlation ~1.0 with a
difference RATIO under about 1% means the sources were mixed identically and a plain mono downmix
is lossless. An autocorrelation peak at 10-150 ms is room reverb, not a duplicate track.

**An absolute RMS threshold does not survive a change of sample representation, and this one bit.**
The rule was first written from a measurement on normalised float audio, where an identical pair
gave a difference RMS around 1e-4. Re-running the same test on int16 samples from a real recording
produced `rms(L)=1114.8`, `rms(L-R)=3.36` -- unmistakably the same signal at 0.30%, and a plain
"difference RMS near zero" reading would have called it different and sent the run into an
unnecessary alignment pass. Always divide by the channel RMS and threshold the ratio.

**A red-pixel error heuristic inverts on a different editor theme.** On one run the frame with the
MOST red had ZERO reported problems, because the theme painted string literals a warm salmon; the
frame with three real problems had five times less red. Control it against the editor's own problem
counter on two or three frames before reporting a single red-derived number, and if it does not
track, read the counter directly.

**A naive editor crop during a call-UI segment measures webcam motion and reports it as typing.**
Classify the screen mode per second FIRST. Every region metric is meaningless until you know which
application was foregrounded.

**Timestamp offsets are per-recording, not constant.** A recorder starts before the session
connects. One offset that had been about 55 seconds was actually 130, and every frame cut on the
old assumption pointed at the wrong passage. Calibrate against a distinctive utterance or an
on-screen clock, per recording.

**Disfluency counts from a VAD-filtered transcript are a floor, not a count.** And from an OCR
transcript they are a NULL, not a zero.

## Inference traps

**Downstream thread state does not establish an earlier round's outcome.** Reasoning that a
later-stage round being pending proves an earlier one cleared upgraded two rounds from HYPOTHESIS
to "CONFIRMED PASS". On checking, nothing had been scheduled and the thread had been silent for a
week. Estimate only from in-round evidence.

**Absence of an assist-tool log is not evidence the tool was off.** Exports are manual. One
exhaustive search came back empty and "the tool was off" was written into five artifacts; it was
wrong, and the retraction had to reach all five. Mark UNMEASURED instead.

**A transcriber is not an assist tool.** Answering "was anything on?" with "it was on" once meant a
transcriber, was read as an answer generator, and produced a false integrity finding. Ask by
product name and name the category.

**ASR noise looks exactly like a mispronunciation.** One engine's "Persian in Virgo" was another's
clean "purge and embargo". Check a suspected diction slip against a second engine before logging
it; only log slips both engines mangle.

**Gaze does not distinguish reading from thinking without a contrasting baseline.** A uniformly
down-tilted head angle supports neither conclusion. Report the null.

## Process traps

**A subagent that spawns a detached job and then stops will never wake up.** Only an inbound
message resumes a stopped agent. Either block on transcription in the foreground or poll for the
output file. When orchestrating, watch the job yourself and message the agent when the artifact
lands.

**A waiter watching a PID fires when that PID is KILLED** -- a false completion signal. Wait on a
sentinel string written to the job's log at the end instead.

**`pkill -f <pattern>` matches your own shell** when the pattern appears in your command line. Kill
by exact PID.

**Two whisper jobs in parallel is slower than two in sequence.** Three concurrent CPU jobs once
reached load 22 on 16 cores and covered 1m27s of audio in 11 minutes of wall clock. Re-run
sequentially on the GPU in one process with one model load. `large-v3` float16 needs about 4.2 GB.

**Transcribe on the GPU.** The difference is roughly 20x, not marginal. A default script written
without thinking reaches for `device="cpu", compute_type="int8"` while an idle card sits in the
box.

**When re-running a transcription, preserve the original job's settings** -- VAD threshold,
`condition_on_previous_text`, the temperature ladder, and especially `language` -- and write to the
SAME output path and line format, so a resumed run finds exactly what it expects.

**Frames land before any deliverable exists.** A run that fails, errors or is interrupted leaves
all of them, and at 5 fps that is tens of gigabytes. `cleanup.sh` is callable on any terminal
state and `--stale` reaps what earlier failures left behind.

**The critique pass creates screenshots that no delete-list mentions unless you name them with the
slug.** Name every scratch file `<slug>_*` or the cleanup glob will miss it.
