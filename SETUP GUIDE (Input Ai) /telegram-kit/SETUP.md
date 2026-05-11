# Telegram Poller — Setup Guide

*The duct-tape-but-reliable Phase 4. Lets [PARTNER_NAME] text and voice-note her AI from her phone. Works TODAY, unlike the broken official plugin.*

---

## What this is

Three files:

- `poll-telegram.sh` — bash script that asks Telegram every minute "any new messages?" and writes each one to her AI's inbox folder as a markdown file. Voice notes get downloaded as `.oga` audio files.
- `com.partner.ai-name.telegram-poller.plist` — launchd job that runs the script every 60 seconds in the background.
- `check-telegram-skill.md` — a skill her AI uses to process the inbox when she asks "check my Telegram."

**How it behaves in practice:**

- She texts her bot at 14:02. At 14:02:something the poller grabs it and drops it into `~/[ai-name]/inbox/telegram/`.
- Next time she opens Claude Code and says *"[AI_NAME], check my Telegram"*, her AI reads everything in the inbox, responds, marks messages processed.
- **Not real-time** — but for a time-squeezed founder, that's often better. It's a drainable queue, not an interruption stream.

---

## Prerequisites

- Homebrew installed (`brew --version` works).
- `jq` installed: `brew install jq`
- The AI's folder exists at `~/[ai-name]/` (Phase 1 done).
- A Telegram bot token from @BotFather (see main guide Phase 4, step 1).

---

## Install steps

### 1. Copy the script into her AI's folder

```bash
mkdir -p ~/[ai-name]/scripts
cp poll-telegram.sh ~/[ai-name]/scripts/
chmod +x ~/[ai-name]/scripts/poll-telegram.sh
```

### 2. Create the config folder and .env

```bash
mkdir -p ~/.config/[ai-name]/telegram
cat > ~/.config/[ai-name]/telegram/.env <<'EOF'
TELEGRAM_BOT_TOKEN=PASTE_HER_TOKEN_HERE
EOF
chmod 600 ~/.config/[ai-name]/telegram/.env   # lock it down
```

### 3. Set up the allowlist (critical — don't skip)

**Why:** anyone who finds her bot's username on Telegram can DM it. Without an allowlist, their messages would land in her AI's inbox. Allowlist = only her user ID accepted.

**Find her Telegram user ID:**

1. She DMs her bot once from her phone (*"hello"*).
2. You run (on her Mac, after saving the .env above):
   ```bash
   curl -s "https://api.telegram.org/bot$(grep TELEGRAM_BOT_TOKEN ~/.config/[ai-name]/telegram/.env | cut -d= -f2)/getUpdates" | python3 -m json.tool
   ```
3. In the output, find `"from": {"id": 123456789, ...}` — that number is her user ID.

**Add it to the allowlist:**

```bash
cat > ~/.config/[ai-name]/telegram/allowlist.txt <<'EOF'
# Telegram user IDs authorised to message [AI_NAME].
# One per line. Comments start with #.
123456789
EOF
```

Anyone not on this list gets silently dropped. Log shows a `BLOCKED:` line.

### 4. Install the launchd job

Open `com.partner.ai-name.telegram-poller.plist` in a text editor. Find-replace:

- `[PARTNER_USERNAME]` — her macOS username (run `whoami` in Terminal if unsure).
- `[AI_NAME]` — the AI's folder name (e.g. `mira`).
- `[PARTNER]` — short identifier (e.g. `julie`).

Save to `~/Library/LaunchAgents/com.[partner].[ai-name].telegram-poller.plist`.

Load it:

```bash
launchctl load ~/Library/LaunchAgents/com.[partner].[ai-name].telegram-poller.plist
launchctl kickstart -k gui/$(id -u)/com.[partner].[ai-name].telegram-poller
```

### 5. Verify it's working

```bash
# Check the launchd job is loaded
launchctl list | grep telegram-poller

# Tail the poller log
tail -f ~/[ai-name]/logs/telegram-poller.log
```

She sends a test message from her phone. Within ~60 seconds you should see a `WROTE: ...` line in the log, and a new file in `~/[ai-name]/inbox/telegram/`.

### 6. Install the inbox-check skill

Copy `check-telegram-skill.md` to her AI's skills folder:

```bash
mkdir -p ~/[ai-name]/.claude/skills/check-telegram
cp check-telegram-skill.md ~/[ai-name]/.claude/skills/check-telegram/SKILL.md
```

Now she can say *"[AI_NAME], check my Telegram"* and her AI processes the inbox.

---

## How to reply back to her on Telegram

When her AI processes an inbox message and wants to reply, it calls Telegram's `sendMessage` API directly. That's a one-line curl the AI can run itself:

```bash
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id=${CHAT_ID} \
  -d text="Reply text here"
```

The `CHAT_ID` is in the frontmatter of every inbox message file. The token is in `~/.config/[ai-name]/telegram/.env`.

(This is documented in the `check-telegram-skill.md` — her AI reads it and knows the pattern.)

---

## Troubleshooting

### Poller log shows nothing

- Is launchd actually running the job? `launchctl list | grep telegram-poller`
- Did the .env get sourced correctly? Try running the script manually: `AI_NAME=[ai-name] ~/[ai-name]/scripts/poll-telegram.sh` — errors go to stdout.
- Is the token valid? `curl -s "https://api.telegram.org/bot${TOKEN}/getMe"` should return her bot info.

### Messages arrive but she doesn't see them

- Check the inbox: `ls ~/[ai-name]/inbox/telegram/`
- If files exist but her AI isn't reading them, the skill isn't installed — do step 6.

### Voice notes aren't downloading

- Check the log for `WARN: could not resolve voice file path`. Usually this is Telegram rate-limiting — try again.
- Make sure `~/[ai-name]/inbox/telegram/voice/` exists and is writable.

### Multiple AIs on her Mac conflicting

- Each AI gets its own poller job, its own bot token, its own config folder. As long as the `Label` field in the plist is unique and the config paths use distinct `[AI_NAME]` values, they don't interfere.

---

## When the official plugin gets fixed

Eventually Anthropic's telegram plugin will ship a working polling loop. At that point:

1. Unload this launchd job: `launchctl unload ~/Library/LaunchAgents/com.[partner].[ai-name].telegram-poller.plist`
2. Install the official plugin per the main guide.
3. Her AI behaviour changes from "reads inbox on request" to "reacts in real time."
4. She doesn't have to re-learn anything on her end — bot username stays the same.

The inbox folder becomes a historical archive, not a live queue. Both patterns can coexist.
