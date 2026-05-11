#!/bin/bash
# transcribe.sh — transcribe an audio file via OpenAI Whisper API.
#
# Usage:
#   transcribe.sh /path/to/audio.oga
#   transcribe.sh /path/to/audio.m4a
#
# Requires: curl, jq, and OPENAI_API_KEY in the environment (or in
# ~/.config/[AI_NAME]/.env).
#
# Prints the transcript to stdout. Errors to stderr.
#
# Cost: ~$0.006 per minute of audio. A 1-minute voice note = ~half a cent.
# A heavy voice-note user doing 5 min/day = ~$1/month. Don't sweat it.

set -euo pipefail

AI_NAME="${AI_NAME:-mira}"
ENV_FILE="${HOME}/.config/${AI_NAME}/.env"

if [ -z "${OPENAI_API_KEY:-}" ] && [ -f "${ENV_FILE}" ]; then
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
fi

if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "ERROR: OPENAI_API_KEY not set. Put it in ${ENV_FILE} or export it." >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 /path/to/audio.{oga,m4a,mp3,wav,ogg,webm}" >&2
  exit 1
fi

AUDIO_FILE="$1"

if [ ! -f "${AUDIO_FILE}" ]; then
  echo "ERROR: file not found: ${AUDIO_FILE}" >&2
  exit 1
fi

# Whisper accepts: mp3, mp4, mpeg, mpga, m4a, wav, webm, ogg (includes .oga)
# No conversion needed for the Telegram poller's .oga files.

RESPONSE=$(curl -s --max-time 120 \
  https://api.openai.com/v1/audio/transcriptions \
  -H "Authorization: Bearer ${OPENAI_API_KEY}" \
  -H "Content-Type: multipart/form-data" \
  -F file="@${AUDIO_FILE}" \
  -F model="whisper-1" \
  -F response_format="json")

# Error shape from OpenAI: {"error": {"message": "...", ...}}
if echo "${RESPONSE}" | jq -e '.error' >/dev/null 2>&1; then
  ERR_MSG=$(echo "${RESPONSE}" | jq -r '.error.message')
  echo "ERROR from OpenAI: ${ERR_MSG}" >&2
  exit 1
fi

# Success shape: {"text": "..."}
echo "${RESPONSE}" | jq -r '.text'
