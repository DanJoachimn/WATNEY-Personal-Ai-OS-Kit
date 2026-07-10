---
name: voice-io
description: Voice both ways. Transcribe voice notes (ElevenLabs Scribe, or OpenAI Whisper fallback) when processing a Telegram voice note or when [PARTNER_NAME] hands you an audio file; and render spoken replies (ElevenLabs voice, or macOS say fallback) via the companion scripts.
---

# Voice I/O — in and out

**Scope:** this skill covers voice **in** (audio → text) and points to voice **out** (text → spoken reply). Three scripts live at `~/[AI_NAME]/scripts/`:

- `transcribe.sh <audio>` — voice IN. ElevenLabs Scribe first (same free account as voice-out), OpenAI Whisper fallback.
- `say-to-mac.sh "<text>" <out.mp3>` — render text to speech. ElevenLabs voice first, macOS `say` fallback.
- `send-voice-note.sh <chat_id> <audio>` — send an audio file to Telegram as a native voice note.

**Why ElevenLabs-first for both:** one free ElevenLabs signup (done in install Stage 7) covers transcription AND the AI's real voice, so there's usually nothing else to configure. The old Whisper/OpenAI path still works as a fallback if an `OPENAI_API_KEY` is present. Costs are pennies either way.

## When to invoke

- A Telegram inbox file has `type: voice` in its frontmatter. Voice audio is at the `voice_path` field.
- [PARTNER_NAME] says "listen to this audio file" or "transcribe this m4a/mp3/oga."
- She records a voice memo and drops the path in chat.

## How to use

The tool is a shell script at `~/[AI_NAME]/scripts/transcribe.sh`. Run it with the audio file path as the only argument:

```bash
~/[AI_NAME]/scripts/transcribe.sh /path/to/audio.oga
```

It prints the transcript to stdout. Errors go to stderr.

## Workflow for a Telegram voice note

1. Read the inbox file (`~/[AI_NAME]/inbox/telegram/YYYY-MM-DD-HHMMSS-UPDATEID.md`).
2. Extract `voice_path` from the frontmatter.
3. Run `transcribe.sh "${voice_path}"` via Bash tool.
4. Capture the output — that's the transcript.
5. Append the transcript to the inbox file body, below a `## Transcript` heading:
   ```markdown
   ## Transcript
   [the transcript text here]
   ```
6. Now treat the file as a text message — proceed with the `check-telegram` skill's workflow.

## Workflow for an ad-hoc audio file

1. [PARTNER_NAME] gives you a path (drag-drop into chat, or types it).
2. Run `transcribe.sh /that/path`.
3. Show her the transcript in chat.
4. Ask: "want me to act on this, or just keep the transcript?"

## Requirements

- An OpenAI API key in `~/.config/[AI_NAME]/.env`:
  ```
  OPENAI_API_KEY=sk-...
  ```
- `jq` installed (`brew install jq`) — same requirement as the Telegram poller.
- `curl` — comes with macOS.

## Setup (run once)

```bash
# Copy the script
mkdir -p ~/[AI_NAME]/scripts
cp transcribe.sh ~/[AI_NAME]/scripts/
chmod +x ~/[AI_NAME]/scripts/transcribe.sh

# Add the API key
mkdir -p ~/.config/[AI_NAME]
echo 'OPENAI_API_KEY=sk-your-key-here' >> ~/.config/[AI_NAME]/.env
chmod 600 ~/.config/[AI_NAME]/.env

# Test
AI_NAME=[ai-name] ~/[AI_NAME]/scripts/transcribe.sh /path/to/any/voice-note.m4a
```

## Hard rules

- **Never re-transcribe a file you've already transcribed** — check the inbox file; if it already has a `## Transcript` heading, use that text.
- **Never share transcripts outside of [PARTNER_NAME]'s sessions.** Voice notes are private.
- **If the transcript is empty or nonsense** (Whisper sometimes fails on silence or very short clips), tell her: "couldn't transcribe — audio might be too short or too quiet. Want to try again?"
- **Multi-language:** Whisper auto-detects. If [PARTNER_NAME] speaks Danish, the transcript is in Danish. Don't translate unless she asks.

## Voice out — spoken replies (built)

To reply with a voice note instead of text:

```bash
~/[AI_NAME]/scripts/say-to-mac.sh "Your reply text" /tmp/reply.mp3
~/[AI_NAME]/scripts/send-voice-note.sh "${CHAT_ID}" /tmp/reply.mp3
```

`say-to-mac.sh` uses the ElevenLabs voice chosen at install if it's configured, else the Mac's built-in `say` voice (and prints a note to stderr when it falls back, so you can tell [PARTNER_NAME] honestly). `CHAT_ID` comes from the Telegram message frontmatter or `~/[AI_NAME]/.config/telegram-chat-id`.

**When to voice-reply vs text-reply:** default to text (instant, free, easy to skim on a phone). Reserve voice replies for when they add something — a warm check-in, a reply to a voice note, a moment that lands better spoken. Don't voice-reply to everything.
