# IndexTTS2 Prompting Guide

This guide is the house standard for writing text that will be spoken by Draft to Take through IndexTTS2.

It combines the local app workflow with the official IndexTTS2 behavior documented by the IndexTTS team.

## Verified Sources

- Official repo: <https://github.com/index-tts/index-tts>
- Official model card: <https://huggingface.co/IndexTeam/IndexTTS-2>
- Official demo code: <https://github.com/index-tts/index-tts/blob/main/webui.py>
- Paper: <https://arxiv.org/abs/2506.21619>

## Model Reality

IndexTTS2 separates speaker identity from emotion better than older zero-shot TTS models.

For Draft to Take, treat these as separate jobs:

- Speaker label chooses the local voice prompt.
- Spoken text gives the line content and light prosody.
- Emotion vectors, emotion text, or emotion reference audio steer delivery.
- Timeline placement controls real timing, gaps, overlap, and playback arrangement.

Do not ask the script LLM to solve everything inside the spoken text. The app has better controls for delivery and timing.

## Best Script Shape

Use this format:

```text
SpeakerLabel: Clear spoken line.
OtherSpeaker: Another clear spoken line.
```

Rules:

- Use exact local speaker labels.
- Use one speaker per line.
- Use one utterance per line.
- Aim for 6 to 18 words.
- Avoid going past 22 words unless there is a good reason.
- Split long thoughts where a real person would breathe, react, or be interrupted.
- Use natural punctuation as a soft prosody hint.
- Keep raw spoken text free of bracketed stage directions.

## What To Avoid

Avoid this:

```text
SpeakerOne: (angrily slamming table) I told you this would happen!!!
SpeakerTwo: [whispering nervously] I do not know what to do...
```

Prefer this:

```text
SpeakerOne: I told you this would happen.
SpeakerOne: Nobody listened.
SpeakerTwo: Keep your voice down.
SpeakerTwo: I do not know what to do.
```

Why:

- Parenthetical directions may be spoken literally or destabilize delivery.
- Punctuation spam can sound forced.
- Short lines give the model cleaner phrase boundaries.
- Emotion should be controlled by wording and app-side emotion controls.

## Emotion Prompting

IndexTTS2 supports multiple emotion-control paths in the official demo/inference code:

- speaker/reference emotion
- emotion reference audio
- custom emotion vectors
- emotion text

Draft to Take should use those controls instead of stuffing direction tags into the script.

Good `emotion_text` examples:

- `quiet concern`
- `dry disbelief`
- `barely contained panic`
- `warm narrator`
- `tired sarcasm`

Bad `emotion_text` examples:

- `He is angry because the app crashed in scene two`
- `Make this sound like the famous clip from that movie`
- `Say it at exactly 3.2 seconds`

Keep emotion text short. Describe delivery, not plot.

## Punctuation

Punctuation is useful, but it is not a full timing system.

- Comma: light pause or turn in thought.
- Period: clean stop.
- Question mark: questioning contour.
- Exclamation mark: occasional emphasis.
- Ellipsis: hesitation or trailing off, used sparingly.

For exact timing, use the timeline, not punctuation tricks.

## Spoken Text Normalization

Draft to Take keeps the user's canvas text natural, but normalizes the text sent
to IndexTTS2 before inference.

The generation path now expands common contractions and removes markdown-like
markup because community testing has shown apostrophes, smart quotes, and
decorative emphasis can trigger unstable pronunciation or breakups.

Examples:

- `We're ready` is sent as `We are ready`.
- `It'll work` is sent as `It will work`.
- `Manager's desk` is sent as `Managers desk`.
- `*very serious*` is sent as `very serious`.

## Generation Presets

Use `Balanced` as the default preset for Script Canvas work. In a small local
A/B run on JoeRogan, kajsa, and Pr.D.Trump voice prompts, `Balanced` produced
the best automated quality score for all three. Human listening still wins:
the `Pr.D.Trump.wav` Clone Fidelity take `spk_1777013836.wav` was preferred by
ear despite its lower automated quality score. Treat `Clone Fidelity` as a
targeted voice-match tradeoff rather than a general quality upgrade.

Script Canvas can apply known voice-specific overrides while the global preset
stays `Balanced`. Today, `Pr.D.Trump.wav` uses `Clone Fidelity` when lines are
placed on the timeline because human listening feedback preferred that take.

## Automatic Audio Judge

Draft to Take now treats SpeechBrain as the voice-match judge, not the whole
quality judge. The backend combines speaker similarity with deterministic audio
health checks and the existing robotic-speech heuristic.

The judge looks for:

- weak speaker similarity
- clipping or overloaded peaks
- near-silent takes
- long internal silence or dropout risk
- abrupt clicks that may sound like breakup
- overly long script lines
- rushed or slow delivery based on rough words-per-minute

Use this as triage, not as a replacement for listening. A `pass` verdict means
the take looks healthy by automatic checks. A `review` verdict means listen
before locking. A `regenerate` verdict means the take has a measurable problem
such as clipping, silence, weak voice match, or high roboticity.

CLI example inside the backend container:

```bash
python3 backend/scripts/audio_quality_judge.py \
  --audio shared/audio/outputs/spk_1777013836.wav \
  --reference shared/audio/speakers/Pr.D.Trump.wav \
  --text "The line that should be spoken."
```

## Source Clip Prompting

The speaker prompt audio still matters a lot.

Best source clip:

- 8 to 20 seconds
- one clear speaker
- dry audio, low room noise
- natural pace
- no background music
- no heavy reverb
- no overlapping voices

If a voice sounds weak, robotic, or unstable, fix the speaker prompt before over-tuning the script.

## Long Episodes

For sitcoms, podcasts, audiobooks, or long scenes:

- plan chapters and scenes first
- draft one scene at a time
- carry continuity context into the next scene
- keep lines short even when the episode is long
- build timeline clips per scene
- lock good takes before regenerating weaker ones

The LLM should preserve continuity, but the TTS text should stay line-level and speakable.

## LLM Harness Summary

The Script Canvas assistant should always know:

- The output is parsed before TTS.
- Raw script text becomes spoken text.
- Stage directions should not be in spoken text.
- Emotion and timing have dedicated app controls.
- IndexTTS2 benefits from short, natural, punctuation-aware lines.
- Speaker labels are production voice labels, not necessarily character names.
