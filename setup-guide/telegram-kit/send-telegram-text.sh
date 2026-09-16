#!/bin/bash
# send-telegram-text.sh — send a plain text message to Telegram.
#
# Usage:  send-telegram-text.sh <chat_id> "<text>"
#
# Exists so the AI never has to load the bot token itself. A background
# `claude -p` run refuses `source ~/.config/.../.env` as "shell code", so the
# reply died at the send step. Scripts read the token; the AI only calls them.
#
# Token: ~/.config/<ai-name>/telegram/.env  (TELEGRAM_BOT_TOKEN=...).
# The AI name comes from this script's own location (~/<ai-name>/scripts/).

set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

CHAT_ID="${1:-}"
TEXT="${2:-}"
if [[ -z "$CHAT_ID" || -z "$TEXT" ]]; then
  echo "Usage: $0 <chat_id> \"<text>\"" >&2
  exit 1
fi

if [[ -z "${AI_NAME:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  AI_NAME="$(basename "$(dirname "$SCRIPT_DIR")")"
fi

TOKEN_FILE="${HOME}/.config/${AI_NAME}/telegram/.env"
[[ -f "$TOKEN_FILE" ]] || { echo "Telegram token file not found at $TOKEN_FILE" >&2; exit 1; }
BOT_TOKEN=$(grep -E '^TELEGRAM_BOT_TOKEN=' "$TOKEN_FILE" | head -1 | cut -d= -f2- || true)
BOT_TOKEN="${BOT_TOKEN//\"/}"; BOT_TOKEN="${BOT_TOKEN//\'/}"
BOT_TOKEN="$(echo -n "$BOT_TOKEN" | xargs 2>/dev/null || echo -n "$BOT_TOKEN")"
[[ -n "$BOT_TOKEN" ]] || { echo "TELEGRAM_BOT_TOKEN not found in $TOKEN_FILE" >&2; exit 1; }

RESP=$(curl -s --max-time 30 -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=${TEXT}" || echo '{"ok":false}')

if [[ "$(echo "$RESP" | jq -r '.ok' 2>/dev/null)" == "true" ]]; then
  echo "$RESP" | jq -r '.result.message_id'
else
  echo "Telegram send failed: $(echo "$RESP" | head -c 200)" >&2
  exit 1
fi
