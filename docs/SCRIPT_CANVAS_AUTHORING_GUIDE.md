# Script Canvas Authoring Guide

Use this guide when a human or another AI needs to write scripts that import cleanly into Draft to Take Script Canvas.

Script Canvas expects production text first: short speakable dialogue, clear voice-role labels, optional emotion vectors, and optional sound markers placed exactly where they should happen.

## Core Format

Write dialogue as one production line per row:

```text
Speaker Label: spoken words go here
```

Rules:

- Use a clear voice-role label, for example `Narrator`, `Mara`, `Jonas`, `Professor Plink`, or `Captain Quibble`.
- The label does not need to match a prepared voice filename. Assign readable roles to prepared voices later in the Script Canvas Voice Workbench.
- If you already know the exact prepared voice label you want, you can use that label directly.
- Only put a colon after a deliberate voice role. If prose contains a colon, keep it under the chosen role, for example `Narrator: The automated response blared from overhead speakers. "All systems nominal."`
- Keep one speaker per line.
- Keep one spoken thought per line.
- Aim for roughly `6` to `18` words per line.
- Split long thoughts at natural breath points.
- Do not write stage directions as spoken text.
- Do not write `Beat 1`, `Beat 2`, or structural placeholders as character dialogue.

Good:

```text
Captain Quibble: Nobody panic. Houses cannot remember names.
Bolt Crumple: Then why did the letterbox whisper my punishment nickname?
```

Bad:

```text
Beat 1: The heroes enter the house.
Captain Quibble: (angrily yelling) Nobody panic while the door opens and thunder crashes.
```

## Chapters And Scenes

Markdown import can create long episodes from headings.

```text
## Chapter 1: The Door That Remembers

### Scene 1: Arrival in the Rain
Professor Plink: Rain climbed Harrow House in silver threads.
```

Use headings when writing a full episode. Keep scenes short enough to review and regenerate without rebuilding the whole project.

## SFX, Ambience, And Music Markers

Put sound markers inside the line where they should happen.

The app strips these markers before dialogue TTS, then places them on separate timeline tracks so they can overlap speech.

SFX marker:

```text
Dr. Nerva Mopp: The brass knocker has a pulse. [[SFX: wet brass heartbeat under fingertips, close microphone | duration=2.0]]
```

Music marker:

```text
Professor Plink: Rain climbed Harrow House in silver threads. [[MUSIC: cold rain horror bed, low bowed metal, no vocals | duration=12]]
```

Ambience marker:

```text
Professor Plink: Rain climbed Harrow House in silver threads. [[AMBIENCE: steady cold rain outside, distant road water, no voices | scene]]
```

Rules:

- Put the marker in the dialogue line at the phrase where it should start.
- Use `SFX` for short one-shot effects like doors, knocks, sparks, impacts, machinery hits, or creature sounds.
- Use `AMBIENCE` for scene-wide environmental beds like rain, parks, room tone, traffic, crowd murmur without speech, spaceship hum, or outside night air.
- Use `MUSIC` for beds, stings, tension pulses, transitions, or longer atmosphere.
- Prefer `AMBIENCE` for background beds. Draft to Take also accepts `AMBIANCE`, `BACKGROUND`, and `BG`, but docs and UI use `AMBIENCE`.
- Keep prompts concrete and audio-focused.
- Include duration when timing matters, either as `| duration=1.5` or `| 1.5s`. Use `| scene` for ambience when you want the bed to cover the current scene.
- Prefer short SFX durations: `0.5` to `3.0` seconds.
- Prefer ambience as a location bed, not a jump-scare or event.
- For ambience, describe a stable acoustic place: location, steady texture, distance, and room tone. Do not pack foreground actions into ambience prompts.
- Avoid adding speech or voice words to ambience unless the scene truly needs indistinct walla. The sidecar already appends no-speech and loopability guidance for ambience generation.
- Prefer music bed durations: `8` to `30` seconds.
- Avoid vague prompts like `scary sound`; write what should be heard.
- One imported/generation batch can contain up to 200 sound markers. For bigger episodes, split sound design into passes by chapter.

Good SFX prompts:

```text
[[SFX: heavy old door folding inward, rain abruptly cut off | duration=2.6]]
[[SFX: dry wallpaper scratching itself into letters | duration=2.0]]
[[SFX: soft shadow sliding over wet stone, close and quiet | duration=1.8]]
```

Good music prompts:

```text
[[MUSIC: reversed music box lullaby, thin and distant, no vocals | duration=12]]
[[MUSIC: low uneasy horror pulse, sparse strings, no vocals | duration=18]]
```

Good ambience prompts:

```text
[[AMBIENCE: steady park birds and soft distant traffic, no voices | scene]]
[[AMBIENCE: old house room tone, slow rain at windows, low air movement | scene]]
[[AMBIENCE: damp harbor street ambience, steady winter wind, distant wooden cart rumble | scene]]
[[AMBIENCE: quiet dockside office room tone, muffled harbor wind outside, old wooden walls | scene]]
```

Avoid:

```text
[[SFX: boom]]
[[MUSIC: scary]]
[[AMBIENCE: harbor, quill scratch, rope creak, ship bells, crowd voices]]
```

## Emotion Vectors

Script Canvas can import or detect IndexTTS2 emotion vectors.

Official vector order:

```text
joy, anger, sadness, fear, disgust, low_mood, surprise, calm
```

Limits:

- Each emotion should be `0.0` to `0.5`.
- The total vector sum must stay at or below `1.5`.
- Most natural lines should use subtle values, not all max values.
- Strong emotion should usually mean one main emotion plus one or two small supporting emotions.

Inline Markdown emotion comment:

```text
Bolt Crumple: Tell it to stop borrowing my lungs. I use those. <!-- emotion: fear=0.22 anger=0.1 joy=0.06 -->
```

Examples:

```text
Captain Quibble: We step in together. If the house counts, we make the math difficult. <!-- emotion: calm=0.28 fear=0.14 anger=0.04 -->
Zini Spark: It called me little matchstick in my grandmother's voice. <!-- emotion: fear=0.3 sadness=0.12 surprise=0.08 -->
Dr. Nerva Mopp: The brass knocker has a pulse. Slow, warm, and pleased. <!-- emotion: disgust=0.16 fear=0.3 calm=0.06 -->
```

Do not overdrive:

```text
Professor Plink: Welcome to the museum. <!-- emotion: joy=1.4 -->
```

Better:

```text
Professor Plink: Welcome to the museum. <!-- emotion: joy=0.22 surprise=0.08 calm=0.06 -->
```

## Writing For The LLM Harness

When another AI writes for Script Canvas, prefer the full copy-paste prompt in [SCRIPT_CANVAS_AI_SYSTEM_PROMPT.md](SCRIPT_CANVAS_AI_SYSTEM_PROMPT.md). For a short instruction, give it this:

```text
Write for Draft to Take Script Canvas.
Use exact Speaker: line formatting.
Use readable voice-role labels, or exact labels provided by the user.
Do not require a separate Characters workflow.
The human can assign roles to prepared voices later in the Script Canvas Voice Workbench.
Keep lines short and speakable.
Place [[SFX: ... | duration=...]], [[AMBIENCE: ... | scene]], or [[MUSIC: ... | duration=...]] inside the line where the cue should start.
Use AMBIENCE for continuous scene beds and SFX for short events.
Do not make sound cues into separate speakers.
Do not write stage directions into dialogue.
If adding emotion comments, use only joy, anger, sadness, fear, disgust, low_mood, surprise, calm.
Keep each emotion <= 0.5 and total <= 1.5.
```

## Full Mini Example

```text
## Chapter 1: The Door That Remembers

### Scene 1: Arrival in the Rain
Professor Plink: Rain climbed Harrow House in silver threads. [[AMBIENCE: steady cold rain outside, distant road water, no voices | scene]] [[MUSIC: cold rain horror bed, low bowed metal, no vocals | duration=12]] <!-- emotion: fear=0.28 low_mood=0.14 calm=0.04 -->
Captain Quibble: Nobody panic. Houses cannot remember names. <!-- emotion: calm=0.28 fear=0.1 joy=0.04 -->
Bolt Crumple: Then why did the letterbox whisper my punishment nickname? <!-- emotion: fear=0.3 surprise=0.12 anger=0.04 -->
Dr. Nerva Mopp: The brass knocker has a pulse. [[SFX: wet brass heartbeat under fingertips, close microphone | duration=2.0]] <!-- emotion: disgust=0.16 fear=0.3 calm=0.06 -->
Professor Plink: Captain struck the knocker, and the door answered from inside the wood. [[SFX: deep knock answered by a hollow knock inside wood | duration=2.4]] <!-- emotion: fear=0.34 surprise=0.12 calm=0.04 -->
```

## What Happens In The App

1. Markdown import creates chapters, scenes, dialogue lines, emotion vectors, and sound markers.
2. The Script Canvas Voice Workbench assigns readable script roles to prepared voices when labels do not match directly.
3. `Build Full Episode Timeline` places dialogue, SFX, ambience, and music into one timeline.
4. Dialogue lines render with IndexTTS2.
5. SFX, ambience, and music markers render through the optional sound-design sidecar.
6. SFX, ambience, and music live on separate timeline tracks and can overlap dialogue.
7. Ambience beds can cover a whole scene even when the generated bed is shorter.
8. The final mix exports all placed dialogue, SFX, ambience, and music assets together.
