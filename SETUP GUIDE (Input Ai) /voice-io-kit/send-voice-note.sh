#!/bin/bash
# send-voice-note.sh — send an audio file to Telegram as a native voice note
# (not a document/audio attachment).
#
# Usage:  send-voice-note.sh <chat_id> <audio_path> [reply_to_message_id]
#
# Input audio can be MP3, OGG, M4A, or any ffmpeg-readable format.
# Output is converted to OGG/Opus (Telegram voice-note spec).
# Prints the Telegram message_id on success. Exits 1 on failure.
#
# Token: ~/.config/<ai-name>/telegram/.env  (TELEGRAM_BOT_TOKEN=...).
# The AI name is derived from this script's own location
# (~/<ai-name>/scripts/send-voice-note.sh), overridable via the AI_NAME env var.

set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

CHAT_ID="${1:-}"
AUDIO="${2:-}"
REPLY_TO="${3:-}"

if [[ -z "$CHAT_ID" || -z "$AUDIO" ]]; then
  echo "Usage: $0 <chat_id> <audio_path> [reply_to_message_id]" >&2
  exit 1
fi
if [[ ! -f "$AUDIO" ]]; then
  echo "Audio not found: $AUDIO" >&2
  exit 1
fi

if [[ -z "${AI_NAME:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  AI_NAME="$(basename "$(dirname "$SCRIPT_DIR")")"
fi

TOKEN_FILE="${HOME}/.config/${AI_NAME}/telegram/.env"
if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "Telegram token file not found at $TOKEN_FILE" >&2
  exit 1
fi

BOT_TOKEN=$(grep -E '^TELEGRAM_BOT_TOKEN=' "$TOKEN_FILE" | head -1 | cut -d= -f2-)
BOT_TOKEN="${BOT_TOKEN//\"/}"; BOT_TOKEN="${BOT_TOKEN//\'/}"
BOT_TOKEN="$(echo -n "$BOT_TOKEN" | xargs 2>/dev/null || echo -n "$BOT_TOKEN")"
if [[ -z "$BOT_TOKEN" ]]; then
  echo "TELEGRAM_BOT_TOKEN not found in $TOKEN_FILE" >&2
  exit 1
fi

# Convert to OGG/Opus (Telegram voice-note format: mono, 48kHz, Opus codec).
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
OGG="$TMP/voice.ogg"
ffmpeg -y -loglevel error -i "$AUDIO" -c:a libopus -b:a 32k -ac 1 -ar 48000 "$OGG"

ENDPOINT="https://api.telegram.org/bot${BOT_TOKEN}/sendVoice"
CURL_ARGS=(-s --max-time 30 -X POST "$ENDPOINT" -F "chat_id=$CHAT_ID" -F "voice=@${OGG}")
[[ -n "$REPLY_TO" ]] && CURL_ARGS+=(-F "reply_to_message_id=$REPLY_TO")

RESPONSE=$(curl "${CURL_ARGS[@]}")
OK=$(echo "$RESPONSE" | jq -r '.ok // false' 2>/dev/null || echo false)
if [[ "$OK" != "true" ]]; then
  echo "Telegram API rejected sendVoice:" >&2
  echo "$RESPONSE" >&2
  exit 1
fi

echo "$RESPONSE" | jq -r '.result.message_id' 2>/dev/null || echo ""
exit 0
