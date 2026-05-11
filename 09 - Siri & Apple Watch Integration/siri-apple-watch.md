# 09 — Siri & Apple Watch Integration

> Talk to your Partner AI by saying "Hey Siri, [name]" — from your iPhone or Apple Watch. Walking, driving, hands full, no screen needed.

---

## What this gives you

- **"Hey Siri, [AI_NAME]"** → dictate a message → it lands in your Partner AI's inbox
- Works on **iPhone** (locked screen, AirPods, CarPlay) and **Apple Watch** (raise wrist, talk)
- Reply comes back as a **voice note** in Telegram (under a minute, default)
- ~10 minutes to set up. Uses your existing Telegram bridge — no new infrastructure.

---

## Honest expectations before you build

**What this IS:**
- A way to TALK TO your Partner AI without opening any app
- A faster path than: pull out phone → unlock → open Telegram → find bot → type/dictate → send
- "Ambient AI" — your partner's reachable from your wrist while you're walking the dog

**What this IS NOT:**
- A real-time voice conversation. You speak, Siri sends, the AI processes, the reply lands in Telegram ~30–60 seconds later
- A replacement for Siri. Siri still exists; we're just adding a custom command alongside it
- Multi-turn (yet). Each message needs its own "Hey Siri, [AI_NAME]" trigger

If you want true voice-call latency (under 2 seconds), that's a separate, bigger build. Park it for now and live with this for a month — most people find this gets them 90% of the value.

---

## Prerequisites

Before you start, you need:

- ✅ Your Partner AI is set up on your Mac (Phases 1–3 done)
- ✅ Telegram bridge is working (Phase 6) — you can text the bot from your phone and your AI replies
- ✅ iPhone running iOS 17 or later
- ✅ Apple Watch (any model — optional but recommended)
- ✅ Both signed in to the same Apple ID

If Telegram isn't working yet, do that first — see [05 - Setting Up Your Partner AI](../05%20-%20Setting%20Up%20Your%20Partner%20AI/setting-up.md) Phase 6.

---

## Setup — iPhone (~5 minutes)

### Step 1: Open the Shortcuts app

It's pre-installed. If you've never used it, just look for the icon — purple, two interlocking squares.

### Step 2: Create a new shortcut

Tap the **+** in the top-right corner → **New Shortcut**.

Tap the title at the top (says "New Shortcut") and rename it to your AI's name. Examples: **Watney**, **Em**, **Coco**. Keep it short — Siri will use this name as the trigger phrase.

### Step 3: Add the dictation action

Tap the search bar at the bottom. Search for **"Dictate Text"** and tap it to add.

In the action settings:
- **Language:** English (or whatever you speak in)
- **Stop Listening:** "After Pause"

This means: when Siri triggers the shortcut, your iPhone listens, you talk, you stop talking, it stops listening. Natural.

### Step 4: Add the Telegram action

Two paths depending on what's installed:

**Path A — if you have Telegram installed on iPhone:**
- Search for **"Send Message"** → look for the Telegram action (icon = paper plane in a blue circle)
- For **Recipient**, pick your bot's contact (the one you DM normally — e.g. `@Dani_Watney_bot`)
- For **Message**, tap and select **"Dictated Text"** (the variable from Step 3)

**Path B — if Telegram action isn't available (some iOS versions):**

Use the bot's HTTP API directly:
- Search for **"Get Contents of URL"** → add it
- For **URL**, paste:
  ```
  https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage?chat_id=<YOUR_CHAT_ID>&text=
  ```
  Replace `<YOUR_BOT_TOKEN>` with your actual bot token. Replace `<YOUR_CHAT_ID>` with your Telegram user ID (same one in your allowlist).
- After the `text=`, insert the **Dictated Text** variable

⚠️ **Path B exposes your bot token in the shortcut.** Anyone with access to your iPhone (or who finds the shortcut backed up to iCloud) can read it. For most people this is fine since the iPhone is already trusted. If paranoid, use a dedicated bot for Siri input only with a tighter allowlist.

### Step 5: Test the shortcut from inside the app

Tap the **▶︎ play button** at the bottom-right. Your iPhone listens. Say something. Stop. The shortcut sends.

Check Telegram — your message should appear in the bot chat. Your Partner AI's poller picks it up within a minute, processes, replies.

If the test message arrives → you're working. Move to Step 6.

If not → check the Path A/B setup. Most common issue: wrong bot in the recipient field, or Path B URL has wrong token/chat ID.

### Step 6: Add the Siri trigger phrase

Back on the shortcut's main screen, tap the **settings icon** (i) at the top → **"Add to Siri"**.

Record your trigger phrase. Best phrases:
- *"Hey Siri, [AI_NAME]"* (e.g. "Hey Siri, Watney") — short, no ambiguity
- *"Hey Siri, message [AI_NAME]"* — more descriptive

Avoid generic phrases ("Hey Siri, message") that might collide with built-in Siri behaviors.

Save. Done with iPhone.

---

## Setup — Apple Watch (~2 minutes)

The shortcut you just created automatically syncs to your Apple Watch. You don't have to do anything special.

To use it on the watch:

**Option 1 — Hey Siri (easiest):**
Raise wrist, say *"Hey Siri, [AI_NAME]"* → watch listens → you talk → done.

**Option 2 — Shortcuts complication (faster, no voice):**
1. Long-press the watch face → **Edit** → **Complications** → **add Shortcuts**
2. Pick your shortcut from the list
3. Tap the complication on your watch face → it runs immediately
4. Watch listens for your voice → you talk → done

I recommend option 1 (Hey Siri) for hands-free, option 2 if Siri is being deaf or you're in a quiet room.

---

## How it actually works in your day

You're walking the dog. You think *"I should follow up with that supplier about the broken muslin batch."*

- **Old way:** stop, pull out phone, unlock with face, open Telegram, find the bot, type or hold-to-dictate, send. ~25 seconds plus losing the thought halfway.
- **New way:** raise wrist → *"Hey Siri, Watney. Draft a follow-up to [supplier name] about the broken muslin batch — firm but warm, ask for replacement timeline."* → keep walking. ~6 seconds.

Your AI processes the message in the background. ~30 seconds later, a voice note from the bot lands in your Telegram. AirPods read it back to you. You either approve, edit, or scrap.

That's the loop.

---

## Common issues + fixes

| Problem | Fix |
|---|---|
| **"Hey Siri, [AI_NAME]" triggers regular Siri instead of the shortcut** | Re-record the trigger phrase. Speak clearly. Avoid trigger words Siri "owns" (call, text, message, message someone). |
| **The shortcut runs but the message doesn't reach your AI** | Check Path A: is the right bot picked as recipient? Check Path B: token + chat ID correct in the URL? |
| **Replies don't come back** | Your Partner AI's poller might not be running. On your Mac: `launchctl list \| grep telegram-poller`. If empty, it's not loaded — see Phase 6 troubleshooting. |
| **Apple Watch says "I can't help you with that"** | Either Siri didn't recognize the phrase, or your iPhone is too far away (the watch sometimes routes Siri requests through the phone). Try the Shortcuts complication route instead. |
| **Voice note replies feel slow** | Polling is every 35 seconds. Worst case: 60–90 seconds round-trip. If always slow, check that the poller is running on your Mac and not stuck. |

---

## What you don't need to worry about

- **Battery drain:** Siri shortcuts are free. They wake your phone for ~3 seconds when triggered. Negligible.
- **Privacy:** the dictation goes through Apple's servers (same as any Siri command). The message content goes through Telegram's servers (same as any Telegram message). Nothing new is exposed.
- **Multiple AIs:** you can build separate shortcuts for separate Partner AIs. *"Hey Siri, Watney"* talks to one, *"Hey Siri, Em"* talks to another. They share Siri but have separate inboxes.

---

## When you'll outgrow this setup

When you find yourself thinking *"I wish I could just have a real conversation with [AI_NAME] while I'm walking, not a one-shot dictate-and-wait."* That's the signal to build the sub-2-second voice loop — a separate, bigger project that exposes the AI through a custom Siri Intent with full voice I/O baked in.

For 95% of people, this never becomes necessary. Live with this for a month before deciding.

---

## See also

- [05 - Setting Up Your Partner AI](../05%20-%20Setting%20Up%20Your%20Partner%20AI/setting-up.md) — Phase 6 (Telegram) is the bridge this depends on
- [03 - API Key Hygiene](../03%20-%20API%20Key%20Hygiene/api-key-hygiene.md) — relevant if you go the Path B route (bot token in shortcut)
