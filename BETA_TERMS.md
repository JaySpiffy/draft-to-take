# Draft to Take Beta Notes

Draft to Take beta is early-access software for testing the local Windows installer preview and Docker fallback workflow. These notes are a plain-English beta policy, not legal advice.

## What You Are Testing

- Windows installer setup, launch, model downloads, and uninstall preservation.
- Local Docker startup on real Windows machines for fallback/container users.
- First-run model downloads.
- Voice setup and Script Canvas workflow.
- Timeline generation, review, retry, and export.
- Optional local Qwen support for emotion detection and AI Thread workflows.
- Optional OmniVoice sidecar for reusable voice design.
- Optional SFX/music tools, if you deliberately enable them.

## Important Limits

- This beta is not a finished commercial release.
- It may break, take a long time to download models, or fail on some hardware.
- Do not use it for client-critical production work without checking results by ear.
- Do not post private scripts, voice samples, API keys, or personal audio in public issues.
- Generated voices and outputs remain your responsibility.
- Third-party models have their own licenses. Draft to Take does not grant extra rights to those models or their outputs.

## Creator Output Rights

Draft to Take does not claim ownership of scripts, projects, voice samples, source clips, prepared voices, generated audio, SFX, ambience, music, or exported mixes created or provided by users.

You may use outputs you create with Draft to Take for commercial or non-commercial creative projects, provided you have the necessary rights to the input material and comply with any applicable third-party model licenses.

You are responsible for making sure you have permission to use any scripts, voices, samples, characters, trademarks, music, SFX, or other material you put into the app. You are also responsible for lawful and ethical use of synthetic or cloned voices, including impersonation, consent, publicity, privacy, and copyright rules that may apply where you live or publish.

Attribution to Draft to Take is appreciated when practical, especially in public demos or videos, but these beta notes do not require attribution for ordinary creator outputs unless a separate written agreement says otherwise.

## App Ownership And Redistribution

The public launcher, docs, and helper scripts are released under the repository license. That does not grant ownership of Draft to Take, access to private source code, resale rights, redistribution rights for the full app, sublicensing rights, or the right to repackage Draft to Take as your own product.

Special permissions, founding-tester arrangements, sponsorship terms, or private commercial agreements must be granted separately in writing by JaySpiffy.

## SFX And Music Notice

SFX/music generation is optional, experimental, and heavier than the core dialogue path. The Docker launcher can enable it automatically when GPU support is available; the Windows installer Full Studio path can download the related model packs, but native sound-design support is still preview-level.

Some model-backed SFX/music engines may use non-commercial or research-only weights. Treat generated SFX/music as license-dependent unless you have checked the active model terms for your intended use.

## Feedback

Please use the public release repository Issues tab for:

- startup failures
- model download problems
- GPU/VRAM issues
- confusing UI steps
- broken exports
- bad error messages
- feature ideas that would make the workflow easier

When reporting a bug, include your Windows version, GPU, VRAM, whether you used the installer or Docker launcher, Docker Desktop version if relevant, and whether you ran diagnostics.
