---
name: check-telegram
description: Use when [PARTNER_NAME] says "check my Telegram," "any Telegram messages?," or similar — AND when the poller's auto-reply fires this in the background. Processes new messages in the inbox folder, replies on Telegram where appropriate, marks messages processed. Handles text and voice notes.
---

# Check Telegram

[PARTNER_NAME]'s Telegram messages arrive as markdown files in `~/[AI_NAME]/inbox/telegram/` (written by the launchd poller every 60 seconds). This skill processes them.

## How the inbox works

Every Telegram message becomes a file like:

```
~/[AI_NAME]/inbox/telegram/2026-04-24-143205-998012096.md
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
grep -l 'processed: false' ~/[AI_NAME]/inbox/telegram/*.md
```

If none: tell [PARTNER_NAME] "nothing new on Telegram" and stop.

### Step 2 — For each message, decide what it is

Read the file. Common shapes:

- **Text question / request** — they're asking you something. Answer it. Reply via Telegram.
- **Voice note** — transcribe via the `voice-io` skill, THEN treat as text.
- **Quick note ("add to notes: X")** — save it, confirm back.
- **Task dump ("I need you to draft Y")** — draft it, reply with a confirmation + where the draft landed.
- **Ambient thinking ("just thinking about Z")** — acknowledge briefly, save to `notes.md` if relevant.

### Step 3 — Reply on Telegram when a reply is expected

Read the token and the chat id from the message frontmatter:

```bash
source ~/.config/[AI_NAME]/telegram/.env
```

**Text reply (default — cheap, instant):**

```bash
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=Your reply here"
```

`CHAT_ID` comes from the message frontmatter. Keep replies short — Telegram is a phone interface, not email. If a longer response is needed, reply with "drafted — see your AI folder" and put the long version in `~/[AI_NAME]/drafts/`.

**Voice reply (optional):** if the message was a voice note or [PARTNER_NAME] prefers spoken replies, render + send a voice note instead:

```bash
~/[AI_NAME]/scripts/say-to-mac.sh "Your reply text" /tmp/reply.mp3
~/[AI_NAME]/scripts/send-voice-note.sh "${CHAT_ID}" /tmp/reply.mp3
```

`say-to-mac.sh` uses ElevenLabs if it's set up, else the Mac's built-in voice. Don't voice-reply to every message — reserve it for when it adds something (a voice note back, a warm check-in). Text is the default.

### Step 4 — Mark the message processed

Edit the file's frontmatter: `processed: false` → `processed: true`. Append a short processing note:

```yaml
processed: true
processed_at: 2026-04-24T14:35:10Z
action_taken: "Replied with 3-line answer about the Tekla collab."
```

### Step 5 — Summarise back to [PARTNER_NAME] in chat (interactive runs only)

When [PARTNER_NAME] is in a Claude Code session and asked you to check Telegram, don't just silently process. Tell them what you did:

```
Processed 4 Telegram messages:
- [12:03, voice] asked for a caption draft — drafted in `drafts/caption-12-03.md`, replied "draft ready, see your folder"
- [13:47, text] asked what time the meeting was — replied with the answer
- [14:02, text] note saved to notes.md: "the collab is a north-star, not a next-quarter plan"
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
