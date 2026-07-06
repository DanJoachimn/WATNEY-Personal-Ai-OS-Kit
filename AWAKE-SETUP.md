# Keeping your AI awake — the always-on setup

> Your AI lives on your Mac. It's awake exactly when your Mac is awake. This SOP makes sure the user *ends the install knowing that* — and set up for the always-on behavior they expect — instead of finding out the hard way (our first bare-laptop install did: an overnight lid-close silently killed the Telegram bridge → "worked yesterday, dead today").
>
> **For the installing AI:** run this right after the Telegram bridge is wired — the user's first "text me from anywhere" moment is exactly when the awake question becomes real. **Detect the hardware, branch, set expectations.**

## The one sentence the user must leave with
> *"[AI_NAME] runs on your Mac, so it's reachable whenever your Mac is awake. Powered off, it's off — that's the trade for keeping everything private and on your own machine. Let's make sure it stays awake the way you need."*

## Step 1 — Detect the setup (don't ask what you can check)
Run: `system_profiler SPDisplaysDataType | grep -i resolution`
- More than one display / an external resolution → user has an **external monitor** (clamshell-capable).
- Only the built-in Retina → **bare laptop**.

## Step 2 — Branch

### Path A — Has an external monitor (clamshell, zero extra software)
> *"Good news — you've got an external monitor, so you already have always-on for free. When you close your lid with the charger and monitor connected, your Mac doesn't sleep — it keeps running and just uses the monitor. That's 'clamshell mode.' [AI_NAME] stays awake and reachable with the lid shut. Nothing to install."*

Confirm: charger connected **+** monitor connected = lid-closed safe.

### Path B — Bare laptop (no external monitor)
> *"On a bare laptop, closing the lid puts the Mac to sleep — and a sleeping Mac can't run [AI_NAME] or answer your texts. Three ways to handle it, easiest first:"*
1. **Keep the lid open + plugged in** when you want [AI_NAME] reachable. Free, nothing to install.
2. **Install Amphetamine** (free, Mac App Store) and set the **power-adapter trigger** so it keeps the Mac awake *only when plugged in* — never always-on (a closed laptop running in a bag is the one real overheat risk). The bare-laptop equivalent of clamshell. Heads-up: Amphetamine is a menu-bar app [AI_NAME] *can't* click for you, so it's a **guided manual setup** — full step-by-step in **[AMPHETAMINE-SETUP.md](./AMPHETAMINE-SETUP.md)**.
3. **Dedicate an always-on Mac** (a cheap Mac mini left on) for true 24/7 — the serious-operator setup.

Help them pick; if Amphetamine, walk the install + the one toggle (via computer-use if available).

**"Is keeping it awake safe?" — the calibrated truth (only relevant to Path B):**
- For what most people actually want — [AI_NAME] **reachable** (replies, the morning brief, light tasks) — the Mac sits idle ~99% of the time and barely warms. **Negligible risk. Don't overthink it.** Lead with the 24/7 magic, not the caveat.
- The heat note only matters if you'll *regularly run heavy projects lid-closed* (long builds, big agent jobs). Even then a Mac **throttles and sleeps to protect itself before any damage** — there's no epidemic of laptops cooked this way; the warnings are precautionary. The three rules that erase the risk for heavy use: **plugged in · hard, ventilated surface (never a bed or couch) · a ~$15 vertical laptop stand** if you do it often. Fanless MacBook Airs warm fastest, so the stand helps most there.
- **Don't let a rare edge case mute the best feature.** Most users just want their AI accessible — give them that without the fear.

## Step 3 — Set the sleep/queue expectation honestly
> *"While the Mac IS asleep, texts you send don't vanish — they wait in line, and the moment your Mac wakes, [AI_NAME] catches up and answers them. So even overnight-asleep, nothing's lost; it just waits for morning."*

(True **only** if the Telegram poller is a `KeepAlive` launchd job — see telegram-kit. Don't promise it otherwise.)

## Step 4 — Powered off = off (the honest line that sells the trade)
> *"And if the Mac is fully shut down, [AI_NAME] is off too — there's no cloud server keeping a copy running. That's deliberate: it's why your data, your notes, your keys never leave this machine. You traded 'always-on no matter what' for 'nobody else's computer ever holds my life.' For most people that's the right trade — and if you ever want bulletproof 24/7, that's the always-on Mac in Path B."*

## Why this exists
The first bare-laptop install (no monitor) closed the lid overnight → Mac slept → Telegram auto-reply died. The kit's author runs a docked MacBook + external ultrawide, which gave him **silent clamshell always-on for months** — so the kit was built blind to the bare-laptop reality. This SOP closes that blind spot: detect the hardware, set the matching path, never let a user assume 24/7 they didn't configure.

## Hard rules
- **Detect before asking** (check the display; don't quiz).
- **Never imply cloud-style always-on.** The honest frame — local + private, awake when the Mac's awake — is the brand, not a weakness.
- The *"messages queue and catch up on wake"* promise is valid **only** with the KeepAlive poller. Ship them together.
