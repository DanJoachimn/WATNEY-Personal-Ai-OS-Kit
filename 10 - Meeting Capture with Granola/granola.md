# 10 — Meeting Capture with Granola

> Your AI is only as smart as the context you give it. Granola records every meeting you take and turns it into structured notes + a verbatim transcript automatically. With the sync script in this kit, those notes flow into your AI's vault — so when you ask *"draft a follow-up to that call I had Tuesday,"* your AI actually knows what was said.

---

## Why this is in the Kit

Without meeting capture, your Partner AI is permanently amnesic about every conversation you've had. You spend half of every prompt re-explaining context.

With Granola + the sync script:

- Every meeting auto-records and auto-transcribes (no clicking, no setup per call)
- Notes + transcripts auto-sync to your AI's vault twice a day
- Your AI reads them on every relevant request — no context re-typing
- Three downstream skills get supercharged:
  - **`document-transformations`** mines client-session transcripts for case-study material as the work happens
  - **`morning-brief`** surfaces what was said in the last 24 hours
  - **`ingest-meeting`** files important meetings into your AI's long-term knowledge base

---

## Honest expectations

**What this IS:**
- Set-and-forget meeting capture. You join a Zoom/Meet/Teams/Granola call, Granola records, you walk away, the file shows up in your AI's vault later that day.
- Compatible with macOS native audio (system-wide capture) — works for any audio source, not just specific apps.
- Tagged automatically — the sync script knows which meetings are "HYROX client work" vs "podcast prep" vs "personal" based on email/domain/keyword rules you set once.

**What this IS NOT:**
- Real-time. Granola's cache updates after the call, the sync runs twice daily — not instantly.
- Free past the trial. Granola is paid (~$18/mo at writing). The first 25 meetings are free.
- Without privacy implications. Granola records audio + transcribes it via their cloud. Don't capture anything you wouldn't share with a transcription service.

---

## Prerequisites

- Mac running macOS 14+ (Granola's minimum)
- A Granola account (free trial available, paid afterward)
- The Partner AI Kit Phase 1+9 done (your AI's folder exists with a vault inside)
- ~10 minutes for setup

---

## Setup — Granola itself (5 min)

1. **Download Granola** from [granola.ai](https://granola.ai) → install → sign in
2. **Grant microphone + system audio permissions** when prompted — Granola needs both to record both sides of a call
3. **Open Settings → Recording**:
   - Enable "Auto-record meetings" so you don't have to remember to start each call
   - Choose your default note style (Granola has templates; "concise" or "decisions and action items" work well for client work)
4. **Take one practice call** to verify it's working. Granola's onboarding includes a self-narrated "test" call — use it.

After step 4, your meetings are being captured. They live inside Granola's app and at `~/Library/Application Support/Granola/cache-v6.json`. Now we get them into your AI's vault.

---

## Setup — the sync script (5 min)

The kit's `_kit/granola-sync-template/` contains a reference implementation. **Or, the simplest path:** point your AI installer at the Dani-deployed reference at `~/.claude/skills/granola-sync/` and ask it to adapt for your partner.

### What the sync does

Reads Granola's local cache twice a day → writes one pair of markdown files per meeting into your vault's `Meeting Notes/` folder:

- `YYYY-MM-DD — [attendee] — [meeting title].md` (Granola's structured summary)
- `YYYY-MM-DD — [attendee] — [meeting title] — transcript.md` (verbatim transcript with timestamps)

Each file gets frontmatter:

```yaml
---
date: 2026-05-05
attendees: [[Sam]], [[Anna]]
client: HYROX Training Clubs
project: Membership Launch
tags: [client-work]
granola_id: abc123
source: granola
generated_by: claude-code
needs_tagging: false
---
```

### Setup steps

1. **Copy the script template** into your AI's skills:
   ```bash
   cp -R [reference granola-sync skill] ~/[ai-name]/.claude/skills/granola-sync/
   ```

2. **Edit `scripts/config.py`** to point at your vault and tag rules:
   ```python
   VAULT_MEETINGS_DIR = "/Users/[username]/Documents/[ai-name]/vault/Meeting Notes"
   USER_EMAILS = ["your@email.com"]   # so the script knows which attendee is YOU

   CLIENT_MAP = {
       "emails": {
           # When this email shows up in attendees, tag the meeting with this client
           "client@example.com": ("Client Name", "Project Name"),
       },
       "domains": {
           # Whole domain match
           "exampleclient.com": ("Client Name", None),
       },
       "names": {
           # Friendly-name match
           "Sam Stephenson": ("Client Name", None),
       },
       "event_keywords": {
           # If meeting title contains this keyword, tag accordingly
           "hyrox": ("HYROX Training Clubs", None),
       },
   }
   ```

3. **Test once manually:**
   ```bash
   cd ~/[ai-name]/.claude/skills/granola-sync
   python3 -m scripts.sync
   ```
   Check `Meeting Notes/` in your vault — your most recent Granola meetings should appear as paired markdown files.

4. **Schedule it** via launchd (twice daily — 12:30 and 17:00):
   - Plist at `~/Library/LaunchAgents/com.[user].[ai-name].granola-sync.plist`
   - `StartCalendarInterval` for both fire times
   - Standard out/err to `~/[ai-name]/logs/granola-sync.{out,err}`
   - `launchctl load` it → done

Your AI installer handles all of this for you. You just verify the test sync produces files.

---

## What your AI does with the synced files

Once meetings are flowing into your vault, three downstream skills activate without further setup:

### `document-transformations` (already in this Kit)

Reads each new client meeting transcript → extracts state-entering / unlock-moments / decisions / commitments → appends to `Areas/[your business]/Clients/[client name]/_case-studies/case-study-log.md`. Over months, builds a library of case study material that writes itself.

### `morning-brief`

Pulls the last 24 hours of meeting notes into your daily log. Open the daily log, see *"yesterday you talked with [client] about X — open threads include [Y, Z]."*

### `ingest-meeting`

Files important meetings into your AI's `_Brain/` knowledge graph (people, companies, concepts). The AI then references those facts forever after.

These skills are pre-installed by the Partner AI Kit. Granola is the input pipe that makes them useful.

---

## Privacy & quiet mode

You're not always going to want a meeting recorded. Coaching sessions, therapy, partner conversations, sensitive deals.

- **In Granola:** turn off auto-record → Granola only records when you explicitly start. Or quit the app for sessions you don't want captured.
- **In the sync script:** if a meeting got captured but shouldn't be in your vault, delete the file from `Meeting Notes/` after sync. The script tracks `granola_id` in `state.json` so it won't re-create deleted files on next run.
- **Belt-and-suspenders:** add a `_trashed/` folder inside `Meeting Notes/`. The sync respects it — anything moved there stays there.

If you're recording client work, **tell them.** Most are fine with it; some aren't. Their consent is the rule, not yours.

---

## Common issues + fixes

| Problem | Fix |
|---|---|
| **Granola records but the sync isn't producing files** | Check the launchd job is loaded: `launchctl list \| grep granola-sync`. Try a manual run: `python3 -m scripts.sync` from the skill folder. |
| **Files appear but the `client` field is blank** (`needs_tagging: true`) | Edit `scripts/config.py` to add the missing email/domain/name/keyword rule, then re-run the sync to re-tag. |
| **The transcript file is huge and bloating my vault** | Granola's transcripts are verbose by design. You can disable transcript syncing in `config.py` if you only want the structured notes — but you lose `document-transformations`'s ability to mine for verbatim quotes. |
| **A meeting got synced that shouldn't have** | Delete the file. The sync's `state.json` won't re-create it. |
| **Granola crashes / cache file gets corrupted** | Granola publishes occasional fixes; quit + relaunch usually clears it. The sync script gracefully handles missing/corrupt cache (logs error, exits non-zero). |

---

## When you'll outgrow this setup

Three signals it's time to upgrade:

1. **You want real-time meeting context** (e.g. live coaching prompts during a call) — that's a different stack (live transcription + AI feedback during the call). Bigger build, separate guide.
2. **You're recording so many meetings the vault is unwieldy** — add an archive job that moves meetings older than 6 months into a separate folder.
3. **You've outgrown Granola for some reason** (privacy concern, pricing, missing feature) — the sync script's input layer is swappable. You can wire it to Otter, Fireflies, Fathom, or any tool with a local cache or API. The downstream skills (`document-transformations`, `morning-brief`, `ingest-meeting`) don't care about the source — they just care that markdown meeting notes show up in `Meeting Notes/`.

---

## See also

- [05 - Setting Up Your Partner AI](../05%20-%20Setting%20Up%20Your%20Partner%20AI/setting-up.md) — the kit's overall setup flow
- [09 - Siri & Apple Watch Integration](../09%20-%20Siri%20%26%20Apple%20Watch%20Integration/siri-apple-watch.md) — voice-only input from your phone (different audio path)
- [03 - API Key Hygiene](../03%20-%20API%20Key%20Hygiene/api-key-hygiene.md) — relevant if you ever swap to an API-based transcription tool
