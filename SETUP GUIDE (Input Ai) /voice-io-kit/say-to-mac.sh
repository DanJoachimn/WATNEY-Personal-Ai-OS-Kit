#!/bin/bash
# say-to-mac.sh — render text to an audio file (mp3).
#
#   Primary path : ElevenLabs (the AI's real voice) when a key + voice id exist.
#   Fallback path: macOS `say` (built-in, robotic) — only when ElevenLabs
#                  isn't configured or is unavailable (e.g. free credits spent).
#
# Usage:  say-to-mac.sh "<text>" "<output.mp3>"
# Prints the output path on success. Exits 1 on failure.
#
# Optional config (enables the good voice):
#   ~/.config/<ai-name>/elevenlabs/.env  containing:
#     ELEVENLABS_API_KEY=...
#     ELEVENLABS_VOICE_ID=...
#     ELEVENLABS_MODEL_ID=eleven_multilingual_v2   # optional, this is the default
#
# The AI name is derived from this script's own location
# (~/<ai-name>/scripts/say-to-mac.sh), overridable via the AI_NAME env var.

set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

TEXT="${1:-}"
OUT="${2:-}"

if [[ -z "$TEXT" || -z "$OUT" ]]; then
  echo "Usage: $0 \"<text>\" \"<output.mp3>\"" >&2
  exit 1
fi

# Derive AI name from script path unless provided.
if [[ -z "${AI_NAME:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  AI_NAME="$(basename "$(dirname "$SCRIPT_DIR")")"
fi

EL_ENV="${HOME}/.config/${AI_NAME}/elevenlabs/.env"

_read_env() {  # _read_env <file> <KEY>  → prints value, quotes/space stripped
  local v
  v=$(grep -E "^$2=" "$1" 2>/dev/null | head -1 | cut -d= -f2- || true)
  v="${v//\"/}"; v="${v//\'/}"
  echo -n "$v" | xargs 2>/dev/null || echo -n "$v"
}

render_elevenlabs() {
  [[ -f "$EL_ENV" ]] || return 1
  local KEY VOICE MODEL HTTP
  KEY="$(_read_env "$EL_ENV" ELEVENLABS_API_KEY)"
  VOICE="$(_read_env "$EL_ENV" ELEVENLABS_VOICE_ID)"
  MODEL="$(_read_env "$EL_ENV" ELEVENLABS_MODEL_ID)"
  [[ -n "$KEY" && -n "$VOICE" ]] || return 1
  [[ -n "$MODEL" ]] || MODEL="eleven_multilingual_v2"

  HTTP=$(curl -s -w '%{http_code}' -o "$OUT" --max-time 60 \
    -X POST "https://api.elevenlabs.io/v1/text-to-speech/${VOICE}?output_format=mp3_44100_128" \
    -H "xi-api-key: ${KEY}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg t "$TEXT" --arg m "$MODEL" '{text:$t, model_id:$m}')")

  if [[ "$HTTP" == "200" && -s "$OUT" ]]; then
    return 0
  fi
  # Non-200 (401 bad key, 429 out of credits, etc.) → discard partial, fall back.
  rm -f "$OUT"
  return 1
}

render_say() {
  local AIFF SAY_VOICE VOICE_PREF
  AIFF="$(mktemp -t sayXXXX).aiff"
  VOICE_PREF="${HOME}/${AI_NAME}/.config/voice-preference"
  SAY_VOICE=""
  [[ -f "$VOICE_PREF" ]] && SAY_VOICE="$(cat "$VOICE_PREF" 2>/dev/null || true)"
  if [[ -n "$SAY_VOICE" ]]; then
    say -v "$SAY_VOICE" -o "$AIFF" "$TEXT"
  else
    say -o "$AIFF" "$TEXT"
  fi
  ffmpeg -y -loglevel error -i "$AIFF" -codec:a libmp3lame -qscale:a 2 "$OUT"
  rm -f "$AIFF"
}

if render_elevenlabs; then
  echo "$OUT"
  exit 0
fi

# Fallback chosen — surface it on stderr so the installer/AI can tell the user
# honestly ("using Mac's built-in voice for now; upgrade to ElevenLabs anytime").
echo "note: ElevenLabs not configured or unavailable — using macOS built-in voice." >&2
render_say
echo "$OUT"
exit 0
