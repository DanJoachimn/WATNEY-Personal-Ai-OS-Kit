#!/bin/bash
# health-check — the deadman switch for [AI_NAME]'s background jobs.
#
# WHY THIS EXISTS (a real outage, 2026-06): a weekly health-audit job ran on the
# same Python venv as the jobs it was meant to watch. A Homebrew upgrade deleted
# that Python's framework and every maintenance job crashed at once — INCLUDING
# the audit. Everything still *looked* fine day to day, so nobody noticed for a
# week. The lesson, paid for the hard way:
#
#     THE ALARM MUST LIVE ON A DIFFERENT SUBSTRATE THAN THE THINGS IT WATCHES.
#
# So this script depends on nothing but /bin/bash and /usr/bin/osascript — both
# shipped with macOS, never touched by brew, pip, npm, a venv, or Claude itself.
# If the AI's whole stack breaks, THIS still runs and still tells you.
#
# Do NOT "improve" this by rewriting it in Python or having it call `claude -p`.
# That reintroduces the exact bug it exists to catch.
#
# Set HEALTH_DRYRUN=1 to print findings without firing the dialog (for testing).

set -u

AI="[AI_NAME]"                     # the AI's folder name, lowercase
USER_NAME="$(whoami)"              # resolved at runtime — never a placeholder
HOME_DIR="$HOME/${AI}"
LOGS="${HOME_DIR}/logs"
NOW=$(date +%s)
ALERTS=()

# Ask launchd itself for a job's last exit code. "-" means it has never failed.
exit_of(){ launchctl list 2>/dev/null | awk -v l="$1" '$3==l{print $2; f=1} END{if(!f) print "MISSING"}'; }
newest(){ local n=0 m; for f in "$@"; do [ -e "$f" ] || continue; m=$(stat -f %m "$f" 2>/dev/null) || continue; [ "$m" -gt "$n" ] && n=$m; done; echo "$n"; }
age_h(){ echo $(( (NOW - $1) / 3600 )); }

# --- three kinds of check ---------------------------------------------------

# check_loaded <name> <label>
# For jobs that run often and are legitimately SILENT when there's nothing to do
# (the Telegram poller writes no log on a quiet cycle). Freshness would cry wolf,
# so we only ask: is it loaded, and did its last run exit clean?
check_loaded(){
  local name="$1" ex; ex=$(exit_of "$2")
  if [ "$ex" = "MISSING" ]; then ALERTS+=("$name — NOT LOADED in launchd"); return; fi
  if [ "$ex" != "-" ] && [ "$ex" != "0" ]; then ALERTS+=("$name — last run FAILED (exit $ex)"); fi
}

# check <name> <label> <max_age_seconds> <freshest_epoch>
# Loaded + clean exit + the artifact it produces is actually recent.
check(){
  local name="$1" max="$3" ts="$4" ex; ex=$(exit_of "$2")
  if [ "$ex" = "MISSING" ]; then ALERTS+=("$name — NOT LOADED in launchd"); return; fi
  if [ "$ex" != "-" ] && [ "$ex" != "0" ]; then ALERTS+=("$name — last run FAILED (exit $ex)"); return; fi
  if [ "$ts" -eq 0 ]; then ALERTS+=("$name — no output on record"); return; fi
  if [ $(( NOW - ts )) -gt "$max" ]; then ALERTS+=("$name — no fresh output in $(age_h "$ts")h"); fi
}

# check_marker <name> <label> <max_age_s> <logfile> <success_marker>
# The strongest check: fresh log AND the marker the job prints only once it has
# genuinely written its output. Catches the nastiest failure — "exit 0 but
# produced nothing" — which a bare timestamp check waves straight through.
check_marker(){
  local name="$1" max="$3" log="$4" marker="$5" ex ts; ex=$(exit_of "$2")
  if [ "$ex" = "MISSING" ]; then ALERTS+=("$name — NOT LOADED in launchd"); return; fi
  if [ "$ex" != "-" ] && [ "$ex" != "0" ]; then ALERTS+=("$name — last run FAILED (exit $ex)"); return; fi
  ts=$(newest "$log")
  if [ "$ts" -eq 0 ]; then ALERTS+=("$name — no log on record"); return; fi
  if [ $(( NOW - ts )) -gt "$max" ]; then ALERTS+=("$name — no fresh run in $(age_h "$ts")h"); return; fi
  if ! tail -25 "$log" 2>/dev/null | grep -q "$marker"; then
    ALERTS+=("$name — ran but produced nothing (missing \"$marker\")")
  fi
}

# --- the jobs this kit installs ---------------------------------------------
#
# THRESHOLDS are deliberately generous. A laptop that sleeps overnight or spends
# a weekend closed will legitimately skip runs. A watchdog that cries wolf gets
# ignored, which defeats the entire point of having one. These still catch a
# genuinely dead job within about a day.

# Dreaming — nightly 02:00. 30h tolerance covers one skipped night.
check "dreaming" "com.${USER_NAME}.${AI}.dreaming" $(( 30 * 3600 )) \
  "$(newest "${HOME_DIR}/vault/Memory/long-term.md")"

# Consolidating — weekly. 9 days covers one missed week.
check "consolidating" "com.${USER_NAME}.${AI}.consolidating" $(( 9 * 86400 )) \
  "$(newest "${LOGS}"/consolidating*.log "${LOGS}"/consolidating*.err)"

# Telegram poller — every 60s, silent when idle. Loaded + clean exit is the
# meaningful signal here; see check_loaded above.
check_loaded "telegram bridge" "com.${USER_NAME}.${AI}.telegram-poller"

# Leave a trace that the watchman itself showed up. If this file goes stale, the
# watchdog is the thing that died — and that's worth being able to see.
mkdir -p "${HOME_DIR}/.heartbeats" 2>/dev/null
date +%s > "${HOME_DIR}/.heartbeats/health-check" 2>/dev/null

# --- report ------------------------------------------------------------------

if [ ${#ALERTS[@]} -eq 0 ]; then
  echo "$(date '+%F %T')  ✅ all background jobs healthy"
  exit 0
fi

echo "$(date '+%F %T')  🔴 PROBLEMS:"; printf '   - %s\n' "${ALERTS[@]}"

if [ "${HEALTH_DRYRUN:-0}" = "1" ]; then
  echo "(dry run — dialog suppressed)"
  exit 1
fi

# A MODAL dialog, not a banner. Banners are easy to miss and are silently
# suppressed under some notification settings — and a missed alarm is no alarm.
# Deliberately NOT a Telegram message: the bridge may be the thing that's dead.
LIST=$(printf '• %s\n' "${ALERTS[@]}")
/usr/bin/osascript <<OSA 2>/dev/null
tell application "System Events"
    activate
    display dialog "⚠️  Some of [AI_NAME]'s background jobs have stopped.

${LIST}
[AI_NAME] still works when you talk to it — but the parts that run on their own (overnight memory, weekly tidy-up, phone messages) aren't running properly.

Open [AI_NAME] and say: \"run a health check\"." with title "[AI_NAME] — health check" buttons {"Later", "OK"} default button "OK" with icon caution giving up after 900
end tell
OSA
exit 1
