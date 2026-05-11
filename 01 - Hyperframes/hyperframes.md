# 01 — Hyperframes

## What this is (for the user, 1 sentence)

Lets you describe an animated video in plain English and get an MP4 back — title cards, captions, motion graphics, transitions.

---

## Install prompt (paste this into your agent)

```
Install Hyperframes for me using the steps in this file. After install, run the verification command and tell me when it's ready.
```

---

## Manual install (for the agent executing this)

### Prerequisites — verify first

```bash
node --version    # require >= 22; if missing or older, instruct user to install LTS from nodejs.org
ffmpeg -version   # required; if missing, run: brew install ffmpeg-full
```

`ffmpeg-full` is preferred over plain `ffmpeg` because the standard Homebrew formula ships without `libass` (subtitle support) and several advanced filters Hyperframes uses. If user already has plain `ffmpeg` installed, replace it:

```bash
brew uninstall ffmpeg --force
brew install ffmpeg-full
ffmpeg -filters 2>&1 | grep -q "subtitles" && echo "ffmpeg-full OK"
```

### Steps

**1. Disable telemetry first** (Hyperframes sends anonymous usage data by default):

```bash
grep -q "HYPERFRAMES_NO_TELEMETRY" ~/.zprofile || cat >> ~/.zprofile <<'EOF'

# Hyperframes — disable telemetry
export HYPERFRAMES_NO_TELEMETRY=1
export DO_NOT_TRACK=1
export HYPERFRAMES_NO_UPDATE_CHECK=1
EOF
```

For the current shell session (so install proceeds without telemetry):
```bash
export HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1 HYPERFRAMES_NO_UPDATE_CHECK=1
```

**2. Initialize a test project** (the install verifies against this):

```bash
mkdir -p ~/hyperframes-projects && cd ~/hyperframes-projects
npx hyperframes@latest init
```

This downloads the `hyperframes` npm package on first run (~50 MB) and creates a `my-video/` subfolder with a starter composition. User will need to approve the `npx` install prompt the first time.

**3. Install the Claude Code skills** (so the agent knows how to author Hyperframes compositions correctly):

```bash
npx skills add heygen-com/hyperframes
```

This installs five skill files into `~/.claude/skills/hyperframes*/` — agent reads these when authoring video compositions.

### Verification

```bash
cd ~/hyperframes-projects/my-video && npx hyperframes lint 2>&1 | grep -E "0 errors|errors\)"
```

Expected output: `0 errors, 0 warnings`. Anything else is a fail.

### Common failures + fixes

| Error | Fix |
|---|---|
| `ffmpeg: command not found` | `brew install ffmpeg-full` |
| `ffmpeg subtitles filter unavailable` | `brew uninstall ffmpeg --force && brew install ffmpeg-full` |
| `Node version too old` | Tell user to install Node 22 LTS from nodejs.org, then retry. |
| `EACCES` permission errors on npx | User shouldn't `sudo npx`. If `~/.npm` is owned by root, run `sudo chown -R $(whoami) ~/.npm` then retry. |
| `lint` reports `gsap_infinite_repeat` | Composition uses `repeat: -1`; replace with finite count. See SKILL.md "Hard Rules" section. |
| `lint` reports `gsap_animates_clip_element` | Animating opacity/visibility on `class="clip"` element; wrap content in a child `<div>` and animate that instead. |
| Studio won't start: "Address already in use" | `lsof -ti:3000 \| xargs kill -9` then retry. |

---

## What the user can do once installed

The user gives the agent jobs like:

- *"Using `/hyperframes`, create a 15-second vertical (1080×1920) intro for my podcast 'Show Name'. Fade-in title with show name in bold, my name as subtitle below, dark background, cream text, fade-out at end."*
- *"Make a 9:16 hook video about [topic]. Karaoke captions. Energetic pacing."*
- *"Take this CSV and turn it into a bar chart race using Hyperframes."*
- *"Convert this article URL into a 60-second animated explainer."*

The agent uses the `/hyperframes` skill to author the composition, opens a preview in the browser at `http://localhost:3000`, iterates based on user feedback, and renders to MP4 on confirmation.

---

## Notes for the agent

- **Authoring uses HTML + GSAP**, not React. Compositions live in `<project>/index.html`. Sub-compositions use `data-composition-src`.
- **Hard Rules from SKILL.md must be followed** — they're correctness-critical, not style. Read `~/.claude/skills/hyperframes/SKILL.md` before writing compositions.
- **Always run `npx hyperframes lint` before declaring a render ready.** Lint catches: infinite GSAP repeats (breaks the deterministic capture engine), clip-element opacity animation (framework reserves visibility for clip lifecycle), missing scene visibility kills, overlapping tweens.
- **Default render settings have evolved.** The standard render outputs at 30fps / CRF 18 (modified from package default of 24fps/CRF 20 for sharper social-platform results). If the user asks for cinematic/film look, opt back to 24fps with `--fps 24`.
- **Subtitle style override:** the package default is "2-word UPPERCASE chunks Helvetica 18 Bold." For Netflix-style longer captions with warm yellow tint and natural casing, use the patched defaults in `~/Developer/video-use/helpers/render.py` (FontSize=14, PrimaryColour=`&H00B5E5F8`, longer chunks). See `02 - Video Use.md` if installed.
- **For vertical video output, source must be vertical.** Don't accept jobs that ask for vertical (Reels/TikTok/Shorts) reformat from horizontal source — flag the constraint and refer to `04 - Pre-Production Rules.md`.
