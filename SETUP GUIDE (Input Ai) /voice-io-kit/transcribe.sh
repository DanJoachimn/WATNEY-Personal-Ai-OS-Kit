#!/bin/bash
# transcribe.sh — transcribe an audio file to text.
#
#   Primary path : ElevenLabs Scribe (uses the SAME account/key as voice-out,
#                  so one free ElevenLabs signup covers voice in AND out).
#   Fallback path: OpenAI Whisper, if OPENAI_API_KEY is configured.
#
# Usage:
#   transcribe.sh /path/to/audio.oga
#   transcribe.sh /path/to/audio.m4a
#
# Requires: curl, jq. Keys read from:
#   ~/.config/<ai-name>/elevenlabs/.env   (ELEVENLABS_API_KEY)   — primary
#   ~/.config/<ai-name>/.env              (OPENAI_API_KEY)       — fallback
#
# Prints the transcript to stdout. Errors to stderr.
# The AI name is derived from this script's own location
# (~/<ai-name>/scripts/transcribe.sh), overridable via the AI_NAME env var.

set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

if [ $# -lt 1 ]; then
  echo "Usage: $0 /path/to/audio.{oga,m4a,mp3,wav,ogg,webm}" >&2
  exit 1
fi

AUDIO_FILE="$1"
if [ ! -f "${AUDIO_FILE}" ]; then
  echo "ERROR: file not found: ${AUDIO_FILE}" >&2
  exit 1
fi

if [ -z "${AI_NAME:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  AI_NAME="$(basename "$(dirname "${SCRIPT_DIR}")")"
fi

EL_ENV="${HOME}/.config/${AI_NAME}/elevenlabs/.env"
OPENAI_ENV="${HOME}/.config/${AI_NAME}/.env"

_read_env() {  # _read_env <file> <KEY>
  local v
  v=$(grep -E "^$2=" "$1" 2>/dev/null | head -1 | cut -d= -f2- || true)
  v="${v//\"/}"; v="${v//\'/}"
  echo -n "$v" | xargs 2>/dev/null || echo -n "$v"
}

# ---- Primary: ElevenLabs Scribe -------------------------------------------

try_elevenlabs() {
  local KEY RESPONSE TEXT
  KEY="${ELEVENLABS_API_KEY:-}"
  [ -z "$KEY" ] && [ -f "$EL_ENV" ] && KEY="$(_read_env "$EL_ENV" ELEVENLABS_API_KEY)"
  [ -z "$KEY" ] && return 1

  RESPONSE=$(curl -s --max-time 120 \
    "https://api.elevenlabs.io/v1/speech-to-text" \
    -H "xi-api-key: ${KEY}" \
    -F file="@${AUDIO_FILE}" \
    -F model_id="scribe_v1")

  TEXT=$(echo "${RESPONSE}" | jq -r '.text // empty' 2>/dev/null || true)
  if [ -n "${TEXT}" ]; then
    echo "${TEXT}"
    return 0
  fi
  echo "note: ElevenLabs transcription unavailable ($(echo "${RESPONSE}" | jq -r '.detail.message // .detail // "unknown error"' 2>/dev/null | head -c 120)) — trying fallback." >&2
  return 1
}

# ---- Fallback: OpenAI Whisper ----------------------------------------------

try_openai() {
  local KEY RESPONSE
  KEY="${OPENAI_API_KEY:-}"
  [ -z "$KEY" ] && [ -f "$OPENAI_ENV" ] && KEY="$(_read_env "$OPENAI_ENV" OPENAI_API_KEY)"
  [ -z "$KEY" ] && return 1

  RESPONSE=$(curl -s --max-time 120 \
    https://api.openai.com/v1/audio/transcriptions \
    -H "Authorization: Bearer ${KEY}" \
    -H "Content-Type: multipart/form-data" \
    -F file="@${AUDIO_FILE}" \
    -F model="whisper-1" \
    -F response_format="json")

  if echo "${RESPONSE}" | jq -e '.error' >/dev/null 2>&1; then
    echo "ERROR from OpenAI: $(echo "${RESPONSE}" | jq -r '.error.message')" >&2
    return 1
  fi
  echo "${RESPONSE}" | jq -r '.text'
  return 0
}

if try_elevenlabs; then exit 0; fi
if try_openai; then exit 0; fi

echo "ERROR: no transcription service available. Configure ELEVENLABS_API_KEY in ${EL_ENV} (free — same account as your AI's voice) or OPENAI_API_KEY in ${OPENAI_ENV}." >&2
exit 1
