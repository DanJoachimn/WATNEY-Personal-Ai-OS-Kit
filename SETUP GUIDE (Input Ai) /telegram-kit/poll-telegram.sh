#!/bin/bash
# poll-telegram.sh — standalone Telegram poller for [AI_NAME]
#
# Hits Telegram's getUpdates API, writes each new message to the AI's inbox as
# a markdown file, downloads voice-note attachments, captures the reply chat id,
# and (optionally) wakes a headless Claude to reply. Designed to run unattended
# under launchd every 60 seconds on a non-developer's Mac, so it fails SOFT:
# a network hiccup skips a cycle, it never wedges.
#
# Usage: launchd runs it every 60s. Also runnable by hand: ./poll-telegram.sh
# Config: ~/.config/[ai-name]/telegram/.env  (TELEGRAM_BOT_TOKEN, optional AUTO_REPLY=off)
# Inbox : ~/[ai-name]/inbox/telegram/
# Requires: bash, curl, jq.

set -euo pipefail

# launchd starts jobs with a minimal PATH — put Homebrew + Claude's install
# locations on it explicitly, or jq / claude won't be found at 2 AM.
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

# ---- Config --------------------------------------------------------------

AI_NAME="${AI_NAME:-mira}"                         # overridable for testing
AI_HOME="${HOME}/${AI_NAME}"
CONFIG_DIR="${HOME}/.config/${AI_NAME}/telegram"
ENV_FILE="${CONFIG_DIR}/.env"
ALLOWLIST_FILE="${CONFIG_DIR}/allowlist.txt"
OFFSET_FILE="${CONFIG_DIR}/offset"
LOCK_DIR="${CONFIG_DIR}/.poll.lock"
INBOX_DIR="${AI_HOME}/inbox/telegram"
VOICE_DIR="${INBOX_DIR}/voice"
LOG_FILE="${AI_HOME}/logs/telegram-poller.log"
AUTO_REPLY_LOG="${AI_HOME}/logs/auto-reply.log"
CHAT_ID_FILE="${AI_HOME}/.config/telegram-chat-id"

if ! mkdir -p "${CONFIG_DIR}" "${INBOX_DIR}" "${VOICE_DIR}" "${AI_HOME}/.config" "$(dirname "${LOG_FILE}")"; then
  echo "poll-telegram: cannot create working dirs under ${AI_HOME} / ${CONFIG_DIR}" >&2
  exit 1
fi

log() { echo "[$(date -Iseconds)] $*" >> "${LOG_FILE}"; }

# Keep logs from growing unbounded over months of unattended use.
rotate_log() {
  local f="$1" max="${2:-2000}" lines
  [ -f "$f" ] || return 0
  lines=$(wc -l < "$f" 2>/dev/null || echo 0)
  if [ "${lines:-0}" -gt "$max" ]; then
    tail -n "$((max / 2))" "$f" > "${f}.tmp" 2>/dev/null && mv "${f}.tmp" "$f" 2>/dev/null || true
  fi
}
rotate_log "${LOG_FILE}"
rotate_log "${AUTO_REPLY_LOG}"

# Read a KEY=value from an env file WITHOUT sourcing it (a stray `KEY = val`
# typo would otherwise execute as a command and kill the whole poller).
read_env() {
  local file="$1" key="$2" v
  [ -f "$file" ] || return 0
  v=$(grep -E "^${key}=" "$file" 2>/dev/null | head -1 | cut -d= -f2- || true)
  v="${v//\"/}"; v="${v//\'/}"
  echo -n "$v" | xargs 2>/dev/null || echo -n "$v"
}

# ---- Single-instance lock (guards manual run overlapping the scheduled one) -
if ! mkdir "${LOCK_DIR}" 2>/dev/null; then
  if [ -n "$(find "${LOCK_DIR}" -maxdepth 0 -mmin +30 2>/dev/null)" ]; then
    log "WARN: stale poll lock (>30 min) — reclaiming."
    rmdir "${LOCK_DIR}" 2>/dev/null || true
    mkdir "${LOCK_DIR}" 2>/dev/null || { log "Could not acquire lock; exiting."; exit 0; }
  else
    exit 0   # another instance is running — yield quietly
  fi
fi
trap 'rmdir "${LOCK_DIR}" 2>/dev/null || true' EXIT

# ---- Preflight -----------------------------------------------------------

if ! command -v jq >/dev/null 2>&1; then
  log "FATAL: jq not installed. Run: brew install jq"
  exit 1
fi
if ! command -v curl >/dev/null 2>&1; then
  log "FATAL: curl not found on PATH."
  exit 1
fi

TELEGRAM_BOT_TOKEN="$(read_env "${ENV_FILE}" TELEGRAM_BOT_TOKEN)"
AUTO_REPLY="$(read_env "${ENV_FILE}" AUTO_REPLY)"; AUTO_REPLY="${AUTO_REPLY:-on}"

if [ -z "${TELEGRAM_BOT_TOKEN}" ]; then
  log "FATAL: TELEGRAM_BOT_TOKEN missing/empty in ${ENV_FILE}."
  exit 1
fi

API_BASE="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

# Allowlist. Empty file/list = not locked down yet; the first sender ever
# (trust-on-first-use) locks the bot to their Telegram account.
if [ -f "${ALLOWLIST_FILE}" ]; then
  ALLOWED_USERS=$(grep -v '^#' "${ALLOWLIST_FILE}" 2>/dev/null | grep -v '^$' || true)
else
  ALLOWED_USERS=""
fi

# ---- Offset handling -----------------------------------------------------

OFFSET=0
if [ -f "${OFFSET_FILE}" ]; then
  OFFSET=$(cat "${OFFSET_FILE}" 2>/dev/null || echo 0)
fi
[[ "${OFFSET}" =~ ^[0-9]+$ ]] || OFFSET=0   # guard against a truncated/corrupt file

# ---- Poll Telegram (guarded — a network blip skips this cycle, never dies) --

RESPONSE=$(curl -s --max-time 30 "${API_BASE}/getUpdates?offset=${OFFSET}&timeout=0" || echo '{"ok":false,"_curl":"failed"}')

if ! echo "${RESPONSE}" | jq -e '.ok == true' >/dev/null 2>&1; then
  log "WARN: getUpdates failed (network or API). Skipping this cycle. Response head: $(echo "${RESPONSE}" | head -c 200)"
  exit 0
fi

UPDATE_COUNT=$(echo "${RESPONSE}" | jq '.result | length' 2>/dev/null || echo 0)
if [ "${UPDATE_COUNT:-0}" -eq 0 ]; then
  exit 0    # nothing new
fi

log "Got ${UPDATE_COUNT} update(s)."

# ---- Process each update -------------------------------------------------

MAX_UPDATE_ID=0
NEW_MESSAGES=0

# Process substitution so the loop runs in the CURRENT shell (a pipe would
# fork a subshell and lose MAX_UPDATE_ID / NEW_MESSAGES).
while read -r UPDATE; do
  UPDATE_ID=$(echo "${UPDATE}" | jq -r '.update_id // 0')
  if [ "${UPDATE_ID}" -gt "${MAX_UPDATE_ID}" ]; then
    MAX_UPDATE_ID="${UPDATE_ID}"
  fi

  # Only handle real messages. Skip edited_message / channel_post / member
  # updates etc. — but MAX_UPDATE_ID above already advanced past them, so the
  # offset moves on and we don't re-fetch them forever.
  if [ "$(echo "${UPDATE}" | jq -r 'has("message")')" != "true" ]; then
    continue
  fi

  USER_ID=$(echo "${UPDATE}" | jq -r '.message.from.id // empty')
  USER_NAME=$(echo "${UPDATE}" | jq -r '.message.from.first_name // "unknown"')
  CHAT_ID=$(echo "${UPDATE}" | jq -r '.message.chat.id // empty')
  MSG_ID=$(echo "${UPDATE}" | jq -r '.message.message_id // empty')
  MSG_DATE=$(echo "${UPDATE}" | jq -r '.message.date // empty')
  TEXT=$(echo "${UPDATE}" | jq -r '.message.text // empty')
  VOICE_FILE_ID=$(echo "${UPDATE}" | jq -r '.message.voice.file_id // empty')

  # Allowlist gate — trust-on-first-use.
  if [ -z "${ALLOWED_USERS}" ]; then
    if [ -n "${USER_ID}" ]; then
      printf '%s\n' "${USER_ID}" > "${ALLOWLIST_FILE}"
      ALLOWED_USERS="${USER_ID}"
      log "LOCKED: bot locked to first sender ${USER_ID} (${USER_NAME}). Only this account can talk to it now."
    fi
  elif ! printf '%s\n' "${ALLOWED_USERS}" | grep -qx "${USER_ID}"; then
    log "BLOCKED: message from unauthorized user ${USER_ID} (${USER_NAME}). Dropped."
    continue
  fi

  TIMESTAMP=$(date -u -r "${MSG_DATE}" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -Iseconds)
  LOCAL_STAMP=$(date -r "${MSG_DATE}" +"%Y-%m-%d-%H%M%S" 2>/dev/null || date +"%Y-%m-%d-%H%M%S")
  INBOX_FILE="${INBOX_DIR}/${LOCAL_STAMP}-${UPDATE_ID}.md"

  # Voice note: download the .oga file. Failure logs + skips (never dies).
  VOICE_PATH=""
  if [ -n "${VOICE_FILE_ID}" ]; then
    FILE_INFO=$(curl -s --max-time 15 "${API_BASE}/getFile?file_id=${VOICE_FILE_ID}" || echo '{}')
    FILE_PATH=$(echo "${FILE_INFO}" | jq -r '.result.file_path // empty' 2>/dev/null || echo "")
    if [ -n "${FILE_PATH}" ]; then
      VOICE_PATH="${VOICE_DIR}/${LOCAL_STAMP}-${UPDATE_ID}.oga"
      if curl -s --max-time 30 -o "${VOICE_PATH}" "https://api.telegram.org/file/bot${TELEGRAM_BOT_TOKEN}/${FILE_PATH}"; then
        log "Downloaded voice note -> ${VOICE_PATH}"
      else
        log "WARN: voice download failed for update ${UPDATE_ID} — leaving as text note."
        rm -f "${VOICE_PATH}"; VOICE_PATH=""
      fi
    else
      log "WARN: could not resolve voice file path for update ${UPDATE_ID}."
    fi
  fi

  {
    echo "---"
    echo "source: telegram"
    echo "update_id: ${UPDATE_ID}"
    echo "chat_id: ${CHAT_ID}"
    echo "message_id: ${MSG_ID}"
    echo "from_user_id: ${USER_ID}"
    echo "from_name: ${USER_NAME}"
    echo "received_at: ${TIMESTAMP}"
    echo "type: $([ -n "${VOICE_PATH}" ] && echo voice || echo text)"
    [ -n "${VOICE_PATH}" ] && echo "voice_path: ${VOICE_PATH}"
    echo "processed: false"
    echo "---"
    echo ""
    if [ -n "${TEXT}" ]; then
      echo "${TEXT}"
    elif [ -n "${VOICE_PATH}" ]; then
      echo "[Voice note — transcribe via voice-io skill. File: ${VOICE_PATH}]"
    else
      echo "[Non-text, non-voice message.]"
    fi
  } > "${INBOX_FILE}"

  log "WROTE: ${INBOX_FILE}"
  NEW_MESSAGES=$((NEW_MESSAGES + 1))

  # First contact: record the chat id so Stage 8's voice note + every reply
  # know where to send. Atomic write, idempotent.
  if [ ! -f "${CHAT_ID_FILE}" ] && [ -n "${CHAT_ID}" ]; then
    printf '%s\n' "${CHAT_ID}" > "${CHAT_ID_FILE}.tmp" && mv "${CHAT_ID_FILE}.tmp" "${CHAT_ID_FILE}"
    log "Captured chat id ${CHAT_ID}."
  fi
done < <(echo "${RESPONSE}" | jq -c '.result[]')

# Persist the offset ATOMICALLY, and BEFORE any auto-reply, so a slow/failed
# reply can never cause the same batch to be re-fetched.
if [ "${MAX_UPDATE_ID}" -gt 0 ]; then
  printf '%s\n' "$((MAX_UPDATE_ID + 1))" > "${OFFSET_FILE}.tmp" && mv "${OFFSET_FILE}.tmp" "${OFFSET_FILE}"
  log "Offset -> $((MAX_UPDATE_ID + 1))."
fi

# ---- Auto-reply: the answering machine -------------------------------------
# When new messages from an allowlisted sender arrived, wake a headless Claude
# to process the inbox via the check-telegram skill. The single-instance lock
# above serialises reply runs. Requires a populated allowlist (so a stranger
# who guesses the bot can never trigger autonomous replies / burn usage).
#
# Note on failure: the offset is already advanced, so Telegram won't redeliver.
# The check-telegram skill sweeps ALL 'processed: false' files, so a message
# left unprocessed by a failed run is picked up the next time ANY message
# arrives. Turn the whole thing off with AUTO_REPLY=off in the telegram .env.

if [ "${NEW_MESSAGES}" -gt 0 ] && [ "${AUTO_REPLY}" != "off" ] && [ -n "${ALLOWED_USERS}" ]; then
  CLAUDE_BIN="$(command -v claude || true)"
  if [ -z "${CLAUDE_BIN}" ]; then
    log "AUTO-REPLY: claude CLI not on PATH — ${NEW_MESSAGES} message(s) queued for the next live session."
  elif ! cd "${AI_HOME}"; then
    log "AUTO-REPLY: cannot cd to ${AI_HOME} — skipping."
  else
    log "AUTO-REPLY: ${NEW_MESSAGES} new message(s) — waking Claude."
    REPLY_PROMPT="New Telegram message(s) arrived in ~/${AI_NAME}/inbox/telegram/. Use the check-telegram skill: process every unprocessed message, reply on Telegram, mark each processed. Background run — no human in this session, so skip the interactive summary and exit when the inbox is clear."
    TMO="${REPLY_TIMEOUT:-900}"
    TBIN="$(command -v timeout || command -v gtimeout || true)"
    if [ -n "${TBIN}" ]; then
      if "${TBIN}" "${TMO}" "${CLAUDE_BIN}" -p "${REPLY_PROMPT}" --max-turns "${REPLY_MAX_TURNS:-15}" >> "${AUTO_REPLY_LOG}" 2>&1; then
        log "AUTO-REPLY: run finished."
      else
        log "AUTO-REPLY: run failed or timed out (>${TMO}s) — messages stay queued for next sweep."
      fi
    else
      # No timeout binary available — run with a manual watchdog so a hung
      # claude process can never permanently wedge the poller.
      "${CLAUDE_BIN}" -p "${REPLY_PROMPT}" --max-turns "${REPLY_MAX_TURNS:-15}" >> "${AUTO_REPLY_LOG}" 2>&1 &
      CLAUDE_PID=$!
      WAITED=0
      while kill -0 "${CLAUDE_PID}" 2>/dev/null; do
        sleep 5; WAITED=$((WAITED + 5))
        if [ "${WAITED}" -ge "${TMO}" ]; then
          kill "${CLAUDE_PID}" 2>/dev/null || true; sleep 2; kill -9 "${CLAUDE_PID}" 2>/dev/null || true
          log "AUTO-REPLY: timed out after ${TMO}s — killed."
          break
        fi
      done
      wait "${CLAUDE_PID}" 2>/dev/null && log "AUTO-REPLY: run finished." || log "AUTO-REPLY: run ended non-zero — messages stay queued."
    fi
  fi
fi

exit 0
