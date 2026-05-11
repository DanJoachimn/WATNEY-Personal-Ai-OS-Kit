---
name: voice-io
description: Transcribe voice notes (Whisper via OpenAI API). Use when processing a Telegram voice note OR when [PARTNER_NAME] hands a local audio file and says "listen to this" or "transcribe this."
---

# Voice I/O — transcription only (cheapest path)

**Scope:** this skill does ONE thing — takes an audio file, returns text. No text-to-speech (her AI replies in text). If she wants spoken replies later, that's a separate skill to bolt on.

**Why Whisper-only:** it's the cheapest, simplest, and most accurate path. Whisper handles multilingual audio out of the box (Danish, English, anything). Costs ~$0.006/minute. A heavy voice-note user (5 min/day) pays ~$1/month.

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

## Future: if she wants spoken replies

The cheapest TTS path is OpenAI's `tts-1` model (~$15/1M characters = a few dollars/month at moderate use). Add a second script `speak.sh` that takes text and writes an mp3; reply on Telegram with the mp3 via `sendVoice`. Don't build until she asks for it — most people stop wanting spoken replies after the first week.
