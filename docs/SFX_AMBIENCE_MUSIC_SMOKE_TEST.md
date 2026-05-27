# SFX, Ambience, And Music Sidecar Smoke

Use this smoke test after changes to SFX Studio, Script Canvas sound cues, `/api/sfx/*`, or timeline SFX/ambience/music tracks.

## Purpose

Verify that Script Canvas can place sound-design cues, call the optional real-model sidecar, and keep SFX/ambience/music separate from dialogue timing.

## Preconditions

- The normal Docker stack is healthy.
- The optional SFX/ambience/music profile is running:

```powershell
docker compose -f docker/docker-compose.yml -f docker/docker-compose.gpu.yml --profile sfx up -d --build sfx backend frontend
```

- `GET http://localhost:8001/api/sfx/status` reports the sidecar as reachable.
- You have at least one local prepared voice for dialogue testing.

## Steps

1. Open `Studio -> Script Canvas`.
2. Import or write a short scene with dialogue plus one SFX marker, one ambience marker, and one music marker.
3. Example cue markers:

```text
[[SFX: short wooden door creak, close microphone, dry room | duration=1.5]]
[[AMBIENCE: steady rain on windows, loopable, no voices | scene]]
[[MUSIC: low uneasy horror pulse, sparse, no vocals | duration=12]]
```

4. Click `Build Full Episode Timeline` or `Place Timeline`.
5. Confirm dialogue, SFX, ambience, and music appear as separate timeline track types.
6. Click `Detect Timeline Emotions` if dialogue vectors are missing.
7. Click `Generate Audio`.
8. Confirm dialogue renders first, then SFX/ambience/music generation runs as a batch.
9. Play the generated SFX, ambience, and music assets from the canvas/timeline if controls are available.
10. Preview the full mix and confirm SFX/ambience/music can overlap dialogue.
11. Download the exported mix.
12. Stop the sidecar when finished if you do not need more sound generation:

```powershell
docker compose -f docker/docker-compose.yml -f docker/docker-compose.gpu.yml stop sfx
```

## Expected Results

- The app does not invent procedural placeholder sounds.
- If the sidecar cannot generate, the UI shows a clear error state and leaves the cue editable.
- Generated SFX are saved under `shared/audio/sfx`.
- Generated ambience beds are saved under `shared/audio/ambience`.
- Generated music beds are saved under `shared/audio/music`.
- Dialogue timeline sync is not broken by SFX/ambience/music overlaps.
- The final downloaded mix includes dialogue and any successfully generated SFX/ambience/music assets.

## Notes

Woosh and MusicGen output can vary. A passed smoke test means the integration path works, not that every generated take is artistically final.
