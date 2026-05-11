#!/bin/bash
# poll-telegram.sh — standalone Telegram poller for [AI_NAME]
#
# Why this exists: the official Claude Code telegram plugin (v0.0.6) is
# mid-architecture-transition and doesn't reliably auto-start its polling
# loop. This is the duct-tape fallback. It hits Telegram's getUpdates API,
# writes each new message to the AI's inbox as a markdown file, and
# downloads voice-note attachments. The AI processes the inbox when
# invoked ("check my Telegram").
#
# Usage: called by launchd every N minutes. Also runnable by hand for
# testing: ./poll-telegram.sh
#
# Config: reads ~/.config/[ai-name]/telegram/.env for TOKEN and allowlist.
# Inbox destination: ~/[ai-name]/inbox/telegram/
#
# Requires: bash, curl, jq (install via: brew install jq)

set -euo pipefail

# ---- Config --------------------------------------------------------------

AI_NAME="${AI_NAME:-mira}"                         # overridable for testing
AI_HOME="${HOME}/${AI_NAME}"
CONFIG_DIR="${HOME}/.config/${AI_NAME}/telegram"
ENV_FILE="${CONFIG_DIR}/.env"
ALLOWLIST_FILE="${CONFIG_DIR}/allowlist.txt"
OFFSET_FILE="${CONFIG_DIR}/offset"
INBOX_DIR="${AI_HOME}/inbox/telegram"
VOICE_DIR="${INBOX_DIR}/voice"
LOG_FILE="${AI_HOME}/logs/telegram-poller.log"

mkdir -p "${CONFIG_DIR}" "${INBOX_DIR}" "${VOICE_DIR}" "$(dirname "${LOG_FILE}")"

log() {
  echo "[$(date -Iseconds)] $*" >> "${LOG_FILE}"
}

# ---- Preflight -----------------------------------------------------------

if [ ! -f "${ENV_FILE}" ]; then
  log "FATAL: missing ${ENV_FILE}. Create it with TELEGRAM_BOT_TOKEN=...."
  exit 1
fi

# shellcheck disable=SC1090
source "${ENV_FILE}"

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ]; then
  log "FATAL: TELEGRAM_BOT_TOKEN is empty in ${ENV_FILE}."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  log "FATAL: jq not installed. Run: brew install jq"
  exit 1
fi

API_BASE="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

# Read allowlist into a bash-friendly grep pattern. If file missing, empty
# list = accept NOTHING (safe default — prevents randoms on the internet
# who find the bot from dumping messages into her AI).
if [ -f "${ALLOWLIST_FILE}" ]; then
  ALLOWED_USERS=$(grep -v '^#' "${ALLOWLIST_FILE}" | grep -v '^$' || true)
else
  ALLOWED_USERS=""
fi

# ---- Offset handling -----------------------------------------------------

if [ -f "${OFFSET_FILE}" ]; then
  OFFSET=$(cat "${OFFSET_FILE}")
else
  OFFSET=0
fi

# ---- Poll Telegram -------------------------------------------------------

# NOTE: omitting allowed_updates because curl chokes on unescaped brackets
# (URL-malformed → curl exit 3). Telegram defaults are fine; we filter for
# .message in jq below.
RESPONSE=$(curl -s --max-time 30 \
  "${API_BASE}/getUpdates?offset=${OFFSET}&timeout=0")

if ! echo "${RESPONSE}" | jq -e '.ok == true' >/dev/null 2>&1; then
  log "ERROR: getUpdates failed. Response: ${RESPONSE}"
  exit 1
fi

UPDATE_COUNT=$(echo "${RESPONSE}" | jq '.result | length')
if [ "${UPDATE_COUNT}" -eq 0 ]; then
  exit 0    # nothing new, exit quietly
fi

log "Got ${UPDATE_COUNT} new update(s)."

# ---- Process each update -------------------------------------------------

MAX_UPDATE_ID=0

# Use process substitution so the while-loop runs in the CURRENT shell.
# `cmd | while` would fork a subshell and lose MAX_UPDATE_ID updates.
while read -r UPDATE; do
  UPDATE_ID=$(echo "${UPDATE}" | jq -r '.update_id')
  if [ "${UPDATE_ID}" -gt "${MAX_UPDATE_ID}" ]; then
    MAX_UPDATE_ID="${UPDATE_ID}"
  fi

  USER_ID=$(echo "${UPDATE}" | jq -r '.message.from.id // empty')
  USER_NAME=$(echo "${UPDATE}" | jq -r '.message.from.first_name // "unknown"')
  CHAT_ID=$(echo "${UPDATE}" | jq -r '.message.chat.id // empty')
  MSG_ID=$(echo "${UPDATE}" | jq -r '.message.message_id // empty')
  MSG_DATE=$(echo "${UPDATE}" | jq -r '.message.date // empty')
  TEXT=$(echo "${UPDATE}" | jq -r '.message.text // empty')
  VOICE_FILE_ID=$(echo "${UPDATE}" | jq -r '.message.voice.file_id // empty')

  # Allowlist check — silently drop unauthorized senders
  if [ -n "${ALLOWED_USERS}" ]; then
    if ! echo "${ALLOWED_USERS}" | grep -qx "${USER_ID}"; then
      log "BLOCKED: message from unauthorized user ${USER_ID} (${USER_NAME}). Dropped."
      continue
    fi
  else
    log "WARN: no allowlist set. Accepting message from ${USER_ID}. Add user IDs to ${ALLOWLIST_FILE} to lock down."
  fi

  TIMESTAMP=$(date -u -r "${MSG_DATE}" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -Iseconds)
  LOCAL_STAMP=$(date -r "${MSG_DATE}" +"%Y-%m-%d-%H%M%S" 2>/dev/null || date +"%Y-%m-%d-%H%M%S")

  INBOX_FILE="${INBOX_DIR}/${LOCAL_STAMP}-${UPDATE_ID}.md"

  # Handle voice note: download the .oga file, link it in the markdown
  VOICE_PATH=""
  if [ -n "${VOICE_FILE_ID}" ]; then
    FILE_INFO=$(curl -s --max-time 15 "${API_BASE}/getFile?file_id=${VOICE_FILE_ID}")
    FILE_PATH=$(echo "${FILE_INFO}" | jq -r '.result.file_path // empty')
    if [ -n "${FILE_PATH}" ]; then
      VOICE_PATH="${VOICE_DIR}/${LOCAL_STAMP}-${UPDATE_ID}.oga"
      curl -s --max-time 30 -o "${VOICE_PATH}" \
        "https://api.telegram.org/file/bot${TELEGRAM_BOT_TOKEN}/${FILE_PATH}"
      log "Downloaded voice note -> ${VOICE_PATH}"
    else
      log "WARN: could not resolve voice file path for update ${UPDATE_ID}."
    fi
  fi

  # Write the inbox file
  {
    echo "---"
    echo "source: telegram"
    echo "update_id: ${UPDATE_ID}"
    echo "chat_id: ${CHAT_ID}"
    echo "message_id: ${MSG_ID}"
    echo "from_user_id: ${USER_ID}"
    echo "from_name: ${USER_NAME}"
    echo "received_at: ${TIMESTAMP}"
    echo "type: $([ -n "${VOICE_FILE_ID}" ] && echo voice || echo text)"
    if [ -n "${VOICE_PATH}" ]; then
      echo "voice_path: ${VOICE_PATH}"
    fi
    echo "processed: false"
    echo "---"
    echo ""
    if [ -n "${TEXT}" ]; then
      echo "${TEXT}"
    elif [ -n "${VOICE_PATH}" ]; then
      echo "[Voice note — transcribe via voice-io skill. File: ${VOICE_PATH}]"
    else
      echo "[Non-text, non-voice message. Update dump:]"
      echo '```json'
      echo "${UPDATE}" | jq '.'
      echo '```'
    fi
  } > "${INBOX_FILE}"

  log "WROTE: ${INBOX_FILE}"
done < <(echo "${RESPONSE}" | jq -c '.result[]')

# Persist the new offset (next call picks up after MAX_UPDATE_ID)
if [ "${MAX_UPDATE_ID}" -gt 0 ]; then
  echo $((MAX_UPDATE_ID + 1)) > "${OFFSET_FILE}"
  log "Updated offset to $((MAX_UPDATE_ID + 1))."
fi

exit 0
