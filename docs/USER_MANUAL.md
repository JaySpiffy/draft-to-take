# Draft to Take User Manual

This manual describes the current Draft to Take beta, whether you start from the Windows installer preview or the Docker launcher fallback. The main workflow is:

```text
Studio -> Script Canvas -> Timeline -> Download Mix
```

Older saved projects should now open into Script Canvas through compatibility loading. New work should start in Script Canvas. Voice assets and SFX/ambience/music assets each have their own focused pages so the Studio sidebar stays calmer.

## Quick Start

1. Install Draft to Take from the latest GitHub prerelease, or start the Docker fallback with `start.bat`.
2. Open the app from the Start Menu or at `http://localhost:3000`.
3. Use `Try Demo Project` on Home if you want a ready-made short scene to inspect first.
4. Add prepared speaker WAV files in `shared/audio/speakers`, create synthetic voices in `Voices`, or prepare a source clip into a reusable voice.
5. Open `Studio -> Script Canvas` and choose the creative flow: Script, Audiobook, or Speech.
6. Paste `Speaker: line` text directly into the canvas, open the demo, or import a Markdown script.
7. Make sure each speaker label has a prepared voice assigned. Use the Script Canvas Voice Browser to click `Assign voice`, then click or drag a prepared voice onto that missing label.
8. Follow the Script Canvas next-action strip: match voices, place the timeline, generate, judge, and export.
9. Use chapters and scenes for longer scripts.
10. Place the active scene or full episode on the timeline.
11. Detect emotions if you want Qwen to set IndexTTS2 delivery vectors.
12. Generate dialogue and any SFX/ambience/music cues.
13. Judge takes, listen, lock the good lines, and retry weak unlocked lines.
14. Download the final mix from the timeline controls.

## Home And Projects

- `New Blank Project` clears the active Script Canvas draft, chat thread, linked timeline state, and locally cached draft session.
- `Try Demo Project` opens a bundled short scene with dialogue plus SFX, ambience, and music markers. It stays local until you press `Save Project`.
- `Open Script Canvas` opens the current Studio canvas without changing saved projects.
- `Recent Projects` shows saved sessions from `shared/data/project_saves`.
- Script Canvas can derive a project title from AI-generated work and autosave it.
- Autosaved projects preserve title, chat thread, chapter/scene structure, selected cast, generation preset, and timeline links.
- If an old project appears after `New Blank Project`, hard refresh once before assuming backend data is wrong.

## Script Canvas

Script Canvas is the main writing-to-audio surface.

### Creative Flow

- `Script / Episode` is for chapter and scene based dialogue, sitcoms, plays, podcasts, and screen-style work.
- `Audiobook` is for book chapters and page-sized narration sections, so long prose can be processed page by page instead of as scenes.
- `Speech / Monologue` is for speeches, talks, presentations, and single-speaker pieces split into sections and spoken beats.
- Saved projects remember the selected flow. The normal public workflow does not require the experimental AI Thread.

### Advanced Experimental AI Thread

- The visible AI Thread is a lab feature, experimental, and off by default.
- Leave it off for the normal manual/demo/import Script Canvas workflow.
- Enable it only from `Settings -> Script Analysis Provider -> Experimental writing assistant -> Enable experimental AI Thread in Script Canvas`.
- When enabled, use the chat composer to ask for a plan, request a scene, continue a chapter, or rewrite selected text.
- `Send` and `Stop` live inside the chat box.
- The model selector uses your configured Script Analysis provider.
- The refresh button reloads available local analysis models.
- The assistant should use the visible local speaker labels.
- The assistant should write short, speakable lines and split long thoughts at natural punctuation.
- When the assistant asks a question, answer in the thread or use the quick-choice buttons.
- Production actions stay on the canvas and timeline, not as permanent LLM action buttons.

### Layout

- When the experimental AI Thread is enabled, it is separated from Script Canvas by a draggable vertical divider.
- `Collapse AI` gives the canvas more room.
- `Collapse Canvas` gives the AI Thread more room.
- `Double View` returns to the side-by-side layout.
- With the AI Thread off, Script Canvas opens as one clean production surface.
- The left Studio tool rail currently exposes working sections only: `Edit`, `Chapters`, and `Voices`.

### Chapters And Scenes

- Use `Chapters` to create or rename chapters and scenes.
- The active scene controls the script shown in the raw editor.
- Scene metadata can include summary, narrator setup, target length, emotion strength, and linked timeline ID.
- For longer episodes, continue scene by scene with a short story-so-far summary.
- Keep narrator lines as normal `Narrator: text` lines when you want narration rendered by TTS.
- Markdown import can create chapters/scenes, attach manual emotion vectors, and preserve SFX/ambience/music markers.

### Canvas Review

- The canvas expects production lines in `Speaker: text` format.
- The next-action strip shows the safest current step, from matching voices through export.
- If speaker labels do not match prepared voices, Script Canvas offers `Assign Existing Voice` and `Rename Speaker Label` actions.
- In the Voice Browser, click `Assign voice` beside a missing label, then click a library voice or drag a voice onto that label. This lets readable script roles use real prepared voice files without renaming the script.
- `Place Timeline` turns the active scene into dialogue clips and placeholder sound cues.
- `Build Full Episode Timeline` places every drafted chapter and scene into one timeline project.
- `Detect Active Scene Emotions` applies Qwen-generated IndexTTS2 vectors to the active scene.
- `Detect Timeline Emotions` applies vectors across the loaded Script Canvas timeline.
- `Generate Audio` renders missing dialogue first, then batches SFX/ambience/music generation at the end.
- `Judge Takes` scores existing placed audio without regenerating it.
- The take filter row can show all lines, lines needing audio, flagged review takes, locked takes, or script lines not yet placed.
- Each line gives a plain reason when something needs attention, such as missing voice, not placed, missing audio, judge not run, low similarity, too quiet, clipping, or silence gaps.
- `Play` previews a generated line.
- `Lock` protects a good take from batch regeneration.
- `Regenerate` reruns one unlocked line.
- `Retry Bad Takes` preserves locked and passing lines while rerunning unlocked missing/review/regenerate lines.
- Quality badges are triage signals; human listening is still the final decision.
- The raw editor remains available underneath the cleaner production-line view.
- If script edits make the timeline stale, use `Update Matched Clips` for safe one-line text edits or `Rebuild Scene` when line count, speaker order, or clip identity changed.
- If you manually set emotion sliders on a line, `Generate Audio` should not overwrite them unless that clip has no vectors.

### Markdown Import

Use `Import MD` when you want to prepare a script outside the LLM or keep precise structure under source control.

- Use headings for chapters and scenes.
- Use normal `Speaker: line` entries for dialogue.
- Optional emotion rows can set the official IndexTTS2 vector order: `joy`, `anger`, `sadness`, `fear`, `disgust`, `low_mood`, `surprise`, `calm`.
- Each emotion is clamped to `0.5`, and the total vector sum is capped at `1.5`.
- Place inline cues where sound should happen: `[[SFX: short metal latch click | duration=1.2]]`, `[[AMBIENCE: steady rain outside, no voices | scene]]`, or `[[MUSIC: low dread pulse | duration=12]]`.
- Imported SFX, ambience, and music cues become separate timeline tracks so they can overlap dialogue.
- Ambience is for scene-wide environment beds. It usually does not need a duration because the timeline stretches it to the current scene and loops a shorter generated bed during export.
- Prefer `AMBIENCE` in scripts for background beds. `AMBIANCE`, `BACKGROUND`, and `BG` are accepted aliases, but the UI labels the track as Ambience.

### Timeline Drawer And Export

- The bottom timeline drawer shows generated clips in sequence.
- The drawer can expand/collapse and has a resize handle.
- Use playback to check timing before export.
- Clicking a Script Canvas-sourced timeline clip jumps back to the matching chapter, scene, and line when source metadata exists.
- Dialogue, SFX, ambience, and music can occupy separate tracks and overlap in time.
- Regenerated dialogue can push later timeline clips forward if the new take is longer than the old estimate.
- Export/download creates the final mix.
- If a generated episode is shorter than requested, continue with the next scene rather than forcing one giant generation.

## Voices

Voices is the home for reusable audio assets. A voice is the prepared WAV and label that Script Canvas uses for matching `Speaker: line` text.

- `Create Voice` can make a reusable synthetic voice through the optional OmniVoice sidecar.
- `Voice Library` lists prepared speaker prompts from `shared/audio/speakers`.
- `Source Clips` lists raw clips from `shared/audio/source_clips`.
- Source clip prep can trim, normalize, diagnose, and promote a raw clip into the reusable voice library.
- Voice rows identify whether the asset came from AI synthesis or audio cloning/source prep so large libraries stay easier to scan.
- Voice, source-clip, SFX, ambience, and music libraries support `Compact`, `Roomy`, and `Grid` views. Grid view shows compact cards, up to five per row on wide screens, while the side inspector keeps full metadata readable.
- Select a voice or source clip to see its full details and actions in the inspector. Use library delete actions when you need to remove old prepared voices or source clips from disk.
- If the optional OmniVoice sidecar is running, synthetic voice creation can generate a prepared WAV. Pick an adult/teen preset or tune gender, age, pitch, style, and English accent from dropdowns; the app builds an English-only OmniVoice prompt internally and auto-names the reusable voice asset. The age selector stays limited to teen/adult ranges. The generated WAV is still used by IndexTTS2 in Script Canvas.
- Advanced baseline generation is available from the backend container: `python3 backend/scripts/generate_synthetic_voice_baseline.py --dry-run` shows the full matrix, and running without `--dry-run` creates the voices. The full UI-safe matrix is 480 voice recipes; `--takes-per-combo 3` creates 1,440 variant voice files. Use `--limit`, `--offset`, and the default `--skip-existing` resume behavior when building it over multiple sessions.
- The app does not include bundled voice clones or private speaker packs.

## Legacy Character Profiles

Older builds included a separate Characters workspace for cast profiles. The normal public workflow no longer asks users to create characters.

- Use prepared voice labels directly in Script Canvas.
- Keep `Speaker: line` labels simple and make them match the voice labels you want.
- Existing saved projects that contain character profile data should still load through compatibility paths.
- Use the experimental AI Thread only when deliberately testing advanced writing/profile behavior.

## Speaker Prep

Speaker Prep now lives under the Voices flow. Use it when a voice sounds weak, noisy, robotic, unstable, or less faithful than expected.

### Source Clip Intake

- `Audio File` uploads a local source clip.
- `Optional Save Name` gives the uploaded clip a cleaner filename.
- `Upload Source Clip` imports the clip into the source library.
- `Refresh Clips` reloads source clips from disk.
- Good prompt clips are usually `8 to 20 seconds`, one clear speaker, low noise, and natural pacing.

### Diagnostics

- `Diagnose` runs clone-readiness checks on a clip.
- The score badge gives a quick readiness summary.
- Recommendations explain what to fix before cloning.
- `Apply Recommended Prep` copies recommended cleanup settings into the prep controls.
- `Use Suggested Trim` applies the diagnostic trim window.

### Prepare Clip

- `Trim Start` and `Trim End` isolate the strongest speaking section.
- `Output Name` controls the saved filename.
- Save prepared output to either `shared/audio/speakers` or `shared/audio/source_clips`.
- `Convert to mono` is the safest speaker-prompt default.
- `Normalize loudness` helps weak clips.
- `Noise cleanup` can help noisy clips, but too much cleanup can make clones less natural.
- `Vocal isolation` is a rescue tool for messy clips, not a default.
- `Prepare And Create Speaker` saves the processed result as a live speaker prompt.

## SFX Studio

SFX Studio is optional and heavier than the core dialogue path. The Docker launcher uses the `sfx` Compose profile; the Windows installer Full Studio path can download the related model packs, but native sound-design support is still preview-level.

- SFX generation uses Woosh-DFlow by default. Use `SFX_WOOSH_MODEL_NAME=Woosh-Flow` for the slower higher-quality Woosh option.
- Music generation uses MusicGen: `facebook/musicgen-small`.
- These model-backed generators are license-dependent and should be treated as experimental unless you have checked the active model terms for your intended use. Draft to Take Pro should not be treated as granting extra rights to third-party models or their outputs.
- Generate multiple takes, audition them, lock the best take, and place the asset on a timeline.
- Script Canvas can batch-generate SFX, ambience, and music markers after dialogue generation.
- SFX, ambience, and music are timeline assets, not dialogue clips, so they can overlap spoken lines.
- The sidecar unloads models after generation by default to reduce VRAM pressure.
- SFX/ambience/music generation is CUDA-first. If GPU support is unavailable, the app should show a clear sidecar error instead of quietly making slow CPU renders.
- SFX, ambience, and music libraries have compact, roomy, and grid views so large libraries do not become one giant wall of full-width cards.
- Select a sound asset to open the inspector with prompt, filename, duration, size, engine, status, and actions.
- Use `Delete` from a sound library row/card or the inspector to remove a generated SFX, ambience, or music asset and its metadata.
- Large imported scripts can batch up to 200 sound cues; if you have more than that, split the episode into smaller sound-design passes.
- Woosh is aimed at sound effects, but generated takes still need auditioning. Concrete foley language such as `short dry latch click, close microphone, no music, no speech` still works best.
- Use ambience prompts for location beds such as `steady park birds and soft distant traffic, no voices` or `old house room tone with rain at windows`.

## Embedded Timeline

The old standalone Timeline Editor page has been retired. Timeline work now happens inside Script Canvas so writing, cue placement, audio generation, preview, export, and download stay in one flow.

- Place the active scene or the full episode from Script Canvas.
- Add dialogue, SFX, ambience, and music tracks.
- Move clips in time and shape overlaps.
- Generate missing or selected dialogue audio.
- Batch optional SFX, ambience, and music cues after dialogue.
- Preview and export the final arranged scene.
- Download the rendered mix from the embedded timeline controls.

## Older Saved Projects

Older project-save files are still worth keeping. When opened from `Recent Projects`, they should restore their title and script into Script Canvas rather than requiring the removed Conversation Workflow or Conversation Results screens.

If an old project does not restore as expected:

- hard refresh once to clear a stale frontend bundle
- confirm the save still exists in `shared/data/project_saves`
- open the project from `Recent Projects` again
- rebuild the current Script Canvas timeline with `Place Timeline` if old source metadata is missing

## Runtime Folders

- `shared/audio/speakers` - live speaker prompts.
- `shared/audio/speakers_backups` - backups of replaced speakers.
- `shared/audio/source_clips` - raw prep clips.
- `shared/audio/sfx` - generated/imported SFX assets.
- `shared/audio/ambience` - generated/imported ambience beds.
- `shared/audio/music` - generated/imported music assets.
- `shared/audio/outputs` - final exports.
- `shared/audio/temp_conversation_segments` - per-line temporary generation audio. The folder name is historical.
- `shared/data/project_saves` - saved projects.
- `shared/data/timeline_projects` - saved timelines.
- `shared/models/checkpoints` - IndexTTS2 model files.

## Quality Notes

- Use clean, dry source clips before blaming the model.
- Keep random sampling off when voice identity matters.
- Use natural punctuation and sentence casing.
- Split long lines at natural breath points.
- Qwen emotion vectors are useful, but overdriving them can hurt stability. Manual sliders cap each emotion at `0.5`, and the IndexTTS2 vector total cannot exceed `1.5`.
- SFX/ambience/music generation is model-backed and less predictable than dialogue generation. Use audition/lock like you do for voice takes.
- The automatic judge is a practical safety net, not a replacement for listening.
- Lock good takes before retrying bad ones.

## Local Network Use

From another PC on the same private network, open:

```text
http://<this-computer-lan-ip>:3000
```

If Windows blocks the connection, allow port `3000` on the private network profile.

## If The UI Changes

Update this manual first, then add fresh screenshots or videos only when they show the current Script Canvas-first product. Avoid reintroducing old workflow media as primary documentation.
