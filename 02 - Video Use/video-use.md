# 02 — Video Use

## What this is (for the user, 1 sentence)

Cuts filler words and dead space from a raw recording, generates word-level transcripts, and hands a clean trimmed file to Hyperframes (or any other tool) for finishing.

---

## Install prompt (paste this into your agent)

```
Install Video Use for me using the steps in this file. When you reach the ElevenLabs API key step, ask me — I'll grab one and put it on my clipboard. After install, run the verification command and tell me when it's ready.
```

---

## Manual install (for the agent executing this)

### Prerequisites — verify first

```bash
python3 --version              # require >= 3.10
ffmpeg -version                 # required; install via brew install ffmpeg-full if missing
command -v uv                   # preferred Python package manager; install via: brew install uv
command -v git                  # required
```

If `uv` is missing: `brew install uv` (or `pip install uv`).

### Steps

**1. Clone the repo to a stable location:**

```bash
mkdir -p ~/Developer
test -d ~/Developer/video-use || git clone https://github.com/browser-use/video-use.git ~/Developer/video-use
cd ~/Developer/video-use
```

If the repo already exists, agent should run `git pull --ff-only` and continue.

**2. Install Python dependencies:**

```bash
cd ~/Developer/video-use && uv sync
```

This installs `requests`, `librosa`, `matplotlib`, `pillow`, `numpy`, and the `video-use` package itself in an isolated env.

**3. Symlink into the agent's skills directory** (so the agent auto-discovers the skill):

```bash
ln -sfn ~/Developer/video-use ~/.claude/skills/video-use
```

For Codex users: `ln -sfn ~/Developer/video-use ~/.codex/skills/video-use`.

**4. Install yt-dlp** (optional — only needed if user wants to pull source from YouTube/podcast hosts):

```bash
brew install yt-dlp
```

**5. ElevenLabs API key — ASK USER**.

This is the only step the agent must pause for. Tell the user:

> I need an ElevenLabs API key for transcription. Steps:
> 1. Go to https://elevenlabs.io/app/settings/api-keys (free tier works for testing)
> 2. Click **Create API Key**
> 3. Name it `video-use`
> 4. **Toggle Restrict Key ON** → tick **Speech to Text** only (least-privilege)
> 5. **Set Monthly cap to 250000** credits (~5 hours of audio — your safety cap)
> 6. Copy the key to your **clipboard** (do NOT paste it into chat — protects it from leaking into transcript history)
> 7. Tell me "clipboard ready"

When user says clipboard is ready, write the key to the env file via `pbpaste`:

```bash
printf 'ELEVENLABS_API_KEY=%s\n' "$(pbpaste)" > ~/Developer/video-use/.env
chmod 600 ~/Developer/video-use/.env
printf '' | pbcopy   # clear clipboard immediately after
```

Verify format without echoing the key:

```bash
grep -c "^ELEVENLABS_API_KEY=sk_" ~/Developer/video-use/.env
```

Should output `1`. If `0`, key wasn't pasted correctly — ask user to retry.

### Patches to apply (post-install)

The default render settings produce 24fps output, which looks chunky on social platforms. Patch for 30fps:

```bash
sed -i.bak 's/"-pix_fmt", "yuv420p", "-r", "24",/"-pix_fmt", "yuv420p", "-r", "30",/' ~/Developer/video-use/helpers/render.py
sed -i.bak 's/"-c:v", "libx264", "-preset", preset, "-crf", crf,/"-c:v", "libx264", "-preset", preset, "-crf", "18",/' ~/Developer/video-use/helpers/render.py
```

Caption style default (2-word UPPERCASE) is loud for most use cases. Patched default is Netflix-style (smaller, longer chunks, warm yellow tint). The patch is in `SUB_FORCE_STYLE` and `build_master_srt` — apply via the helper script:

```bash
python3 - <<'PY'
import re
from pathlib import Path
p = Path.home() / "Developer/video-use/helpers/render.py"
src = p.read_text()
# SUB_FORCE_STYLE patch
src = src.replace(
    'FontName=Helvetica,FontSize=18,Bold=1,"\n    "PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,BackColour=&H00000000,"\n    "BorderStyle=1,Outline=2,Shadow=0,"\n    "Alignment=2,MarginV=90',
    'FontName=Helvetica,FontSize=13,Bold=0,"\n    "PrimaryColour=&H00B5E5F8,OutlineColour=&H00000000,BackColour=&H80000000,"\n    "BorderStyle=1,Outline=1,Shadow=1,"\n    "Alignment=2,MarginV=50'
)
p.write_text(src)
print("patches applied")
PY
```

### Verification

Generate a 3-second test video and run the full transcribe pipeline:

```bash
cd /tmp
ffmpeg -y -f lavfi -i "sine=frequency=440:duration=3" -f lavfi -i "color=c=black:s=320x240:d=3" -c:v libx264 -c:a aac -shortest test-clip.mp4 2>/dev/null
cd ~/Developer/video-use
uv run python helpers/transcribe.py /tmp/test-clip.mp4 --edit-dir /tmp
```

Expected output ends with: `saved: test-clip.json (...) in <N>s`. Cleanup:

```bash
rm /tmp/test-clip.mp4 /tmp/test-clip.json /tmp/test-clip.wav 2>/dev/null
```

### Common failures + fixes

| Error | Fix |
|---|---|
| `Scribe returned 401: missing_permissions` | API key lacks `speech_to_text` scope. User needs to recreate key with that scope enabled. |
| `Scribe returned 401: invalid_api_key` | Wrong key or `.env` malformed. Verify with `grep ELEVENLABS .env`. |
| `Scribe returned 429` | Rate limit / out of credits. User needs to upgrade plan or wait. |
| `pip install` fails / no `uv` | Install uv: `brew install uv`. Fall back to `pip install -e .` if uv unavailable. |
| `ModuleNotFoundError: librosa` | Run `uv sync` again from inside the repo dir. |
| Symlink error: `~/.claude/skills` doesn't exist | `mkdir -p ~/.claude/skills` then re-run the symlink. |

---

## What the user can do once installed

The user gives the agent jobs like:

- *"Edit `~/Desktop/raw.mp4` into a clean 90-second version — cut filler words, retakes, and dead air."*
- *"Take this 60-minute podcast episode and pull out the 3 strongest 30-90s clips for social. Hook + payoff structure."*
- *"Trim this recording, then hand the clean version to Hyperframes for title cards and captions."*

The agent reads the source via `transcribe.py` → packs phrase-level transcripts via `pack_transcripts.py` → proposes cuts in plain English → waits for user approval → renders trimmed output via `render.py`.

---

## Notes for the agent

- **Strategy confirmation is mandatory before cutting** (Hard Rule from SKILL.md). Never produce an output without the user approving the plain-English cut plan first.
- **Outputs always land in `<source-folder>/edit/`** — never in the video-use repo dir.
- **Transcripts are cached per source.** Never re-transcribe the same file unless the file's mtime changed.
- **Cut padding:** 50–80ms for conversational, tighter for fast-paced. Working window is 30–200ms. Cut edges must snap to word boundaries from the Scribe transcript (Hard Rule 6).
- **Audio fades:** 30ms in/out at every segment boundary baked in by `render.py`. If user reports audible pops, check that `afade` filter survived a custom render command.
- **Outro padding for shorts:** when the source has insufficient natural silence at the end, post-process with `ffmpeg -vf "tpad=stop_mode=clone:stop_duration=1.0" -af "apad=pad_dur=1.0"` for a 1s freeze-frame outro with silent audio.
- **Privacy:** audio (not video frames) is sent to ElevenLabs Scribe for transcription. Safe for public content (essays, podcasts, marketing). NOT for sensitive client material, NDA recordings, or strategy calls. Local Whisper backend exists in `ffmpeg-full` (`--enable-whisper`) but video-use doesn't yet wire it; track upstream issues #4/#12/#22 for native local mode.
- **The skill ships a `manim-video/` sub-skill** for math-style animations. Only loads when invoked. Most workflows won't need it.
- **For overlays/animations on top of trims**, prefer Hyperframes (see `01 - Hyperframes.md`) over the bundled Remotion path — better suited for HTML-first agent authoring.
