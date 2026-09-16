---
name: check-telegram
description: Use when [PARTNER_NAME] says "check my Telegram," "any Telegram messages?," or similar — AND when the poller's auto-reply fires this in the background. Processes new messages in the inbox folder, replies on Telegram where appropriate, marks messages processed. Handles text and voice notes.
---

# Check Telegram

[PARTNER_NAME]'s Telegram messages arrive as markdown files in `~/[ai-name]/inbox/telegram/` (written by the launchd poller every 60 seconds). This skill processes them.

## How the inbox works

Every Telegram message becomes a file like:

```
~/[ai-name]/inbox/telegram/2026-04-24-143205-998012096.md
```

With frontmatter:

```yaml
---
source: telegram
update_id: 998012096
chat_id: 5561039396
message_id: 42
from_user_id: 5561039396
from_name: [PARTNER_NAME]
received_at: 2026-04-24T14:32:05Z
type: text            # or "voice"
voice_path: /path/to/.oga   # only if type=voice
processed: false
---

[message body]
```

## Workflow

### Step 1 — List unprocessed messages

```bash
grep -l 'processed: false' ~/[ai-name]/inbox/telegram/*.md
```

If none: tell [PARTNER_NAME] "nothing new on Telegram" and stop.

### Step 2 — For each message, decide what it is

Read the file. Common shapes:

- **Text question / request** — they're asking you something. Answer it. Reply via Telegram.
- **Voice note** — transcribe via the `voice-io` skill, THEN treat as text.
- **Quick note ("add to notes: X")** — save it, confirm back.
- **Task dump ("I need you to draft Y")** — draft it, reply with a confirmation + where the draft landed.
- **Ambient thinking ("just thinking about Z")** — acknowledge briefly, save one line to `vault/Memory/daily-memory.md` if relevant.

### Step 3 — Reply on Telegram when a reply is expected

The token lives at `~/.config/[ai-name]/telegram/.env`; `CHAT_ID` and `message_id` come from the message frontmatter. Don't search for either.

```bash
source ~/.config/[ai-name]/telegram/.env
```

**The phone already shows the message landed.** The poller puts a 👀 reaction on every message the moment it arrives, before you're even woken. You don't need to say "got it".

**If the real answer will take more than about a minute** (research, a draft, anything with steps), send a one-line text first so they aren't left wondering, then do the work:

```bash
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=On it — give me a few minutes."
```

**Then reply by voice. Voice is the default.** A short spoken reply is the whole point of having [AI_NAME] in your pocket:

```bash
~/[ai-name]/scripts/say-to-mac.sh "Your reply, written to be spoken" /tmp/reply.mp3
~/[ai-name]/scripts/send-voice-note.sh "${CHAT_ID}" /tmp/reply.mp3
```

Write it the way you'd say it to a friend on the phone: short, under ~150 words (about a minute), no bullet points, no headings.

**Use text instead only when the reply can't be read aloud:**

| The reply contains | Send |
|---|---|
| Links, file paths, code, email addresses | Text |
| Numbers they'll want to copy or compare (prices, dates in a list, figures) | Text |
| Anything longer than a minute of speech | Short voice note + "full version in your folder", long version saved to `~/[ai-name]/drafts/` |
| They asked for text ("text me", "in writing") | Text |
| Everything else | **Voice** |

```bash
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=Your reply here"
```

Don't send the same reply as both voice and text. `say-to-mac.sh` uses the ElevenLabs voice if it's set up, and falls back to the Mac's built-in voice if not.

### Step 4 — Mark the message processed

Edit the file's frontmatter: `processed: false` → `processed: true`. Append a short processing note:

```yaml
processed: true
processed_at: 2026-04-24T14:35:10Z
action_taken: "Replied with 3-line answer about the [Brand] collab."
```

### Step 5 — Summarise back to [PARTNER_NAME] in chat (interactive runs only)

When [PARTNER_NAME] is in a Claude Code session and asked you to check Telegram, don't just silently process. Tell them what you did:

```
Processed 4 Telegram messages:
- [12:03, voice] asked for a caption draft — drafted in `drafts/caption-12-03.md`, replied "draft ready, see your folder"
- [13:47, text] asked what time the meeting was — replied with the answer
- [14:02, text] note saved to daily-memory.md: "the collab is a north-star, not a next-quarter plan"
- [14:31, voice] quick thought, no action needed — replied "noted"

Anything else you want me to handle?
```

**When the poller fired this in the background (auto-reply mode):** there's no human in the session to summarise to. Just process, reply, mark done, and exit cleanly. The interactive summary is skipped.

## Hard rules

- **Never reply to Telegram as yourself without [PARTNER_NAME] knowing what you said** (in interactive runs, always surface it in the summary; in auto-reply runs, the reply + `action_taken` note in the file are the record).
- **Never send a reply that exceeds ~500 characters on Telegram.** Long content goes to `drafts/`, Telegram gets a pointer.
- **Never process messages from user IDs not in the allowlist.** The poller handles this, but double-check: if you see a message from an unexpected user ID, flag it and don't act.
- **Never delete inbox files.** Mark `processed: true` and leave them.
- **Voice notes must be transcribed before acting.** If the voice-io skill isn't installed yet, note it and leave the file for later.

## When to hand back

After the batch is processed. Don't keep polling on your own — the launchd poller is what watches the inbox.
