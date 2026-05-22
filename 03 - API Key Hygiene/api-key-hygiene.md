# 03 — API Key Hygiene

## What this is (for the user, 1 sentence)

A pattern for handing API keys (ElevenLabs, OpenAI, etc.) to your agent without ever pasting them into chat where they'd get logged forever.

---

## Install prompt (paste this into your agent)

There's nothing to install for this guide — it's a behavioral pattern. But you can ask your agent to commit to it:

```
Adopt the API key handling pattern in ~/Desktop/WATNEY/03 - API Key Hygiene.md. From now on, when I need to give you an API key or other secret, default to the clipboard transfer method. Don't ask me to paste secrets in chat unless I explicitly insist.
```

---

## The pattern (for the agent executing this)

### Default workflow when user needs to provide a secret

1. **Ask user to copy the secret to clipboard.** Never "paste it here."
2. **Wait for user to confirm "clipboard ready"** (or equivalent).
3. **Transfer via `pbpaste`** directly into the destination file:

```bash
printf 'VAR_NAME=%s\n' "$(pbpaste)" > /path/to/.env
chmod 600 /path/to/.env
```

4. **Clear the clipboard immediately** to remove the secret from there too:

```bash
printf '' | pbcopy
```

5. **Verify by format only** — never echo the value:

```bash
grep -c "^VAR_NAME=expected_prefix_" /path/to/.env
# Output: 1 = success
```

If verification fails (output is `0`), tell user format was wrong and ask them to copy the key again.

### Multi-secret flows

If the user needs to enter several secrets (a `.env` with multiple keys), the clipboard pattern is awkward. Instead:

```bash
open -e /path/to/.env       # opens in TextEdit
```

Tell user to paste each key into the file directly, save, close. Then verify formats.

### When user pastes a secret in chat anyway

Don't lecture. Use the secret to complete the task. After it works, flag once:

> The key works. One thing — pasting it in chat means it's in this conversation's transcript and on Anthropic's servers. Worth rotating it within the next few minutes: delete this key in the API console, create a new one, and we'll re-do the env via clipboard. Takes 60 seconds.

Then move on. Don't repeat the warning unless they paste another secret.

### Scoping rules to share with the user when generating keys

When the user is about to create a new API key, give them these instructions before they click "Create":

1. **Restrict the key** to only the scopes the integration actually needs. (E.g., for video-use + ElevenLabs: only `speech_to_text`, nothing else.)
2. **Set a usage cap** (monthly credit limit, dollar cap, or rate limit) — caps are seatbelts, not real plans. Estimate expected use × 2-3.
3. **Name the key after the integration** (e.g., `video-use`, not `my-key-1`). Names are how you remember to rotate or revoke later.
4. **Treat the key as compromised after 90 days** — rotate on a schedule, not "when something goes wrong."

### Storage rules

| Where | Rule |
|---|---|
| `.env` file in project root | Always `chmod 600`. Always `.gitignore`'d. Never committed. |
| Shell profile (`~/.zprofile`, `~/.zshrc`) | Acceptable for non-secret config (telemetry-off env vars, paths). NEVER for actual secrets — these files often get backed up to cloud sync. |
| 1Password / Bitwarden / system keychain | Best place for the master copy of the key. The `.env` is a working-file derivative. |
| Conversation history / transcripts | NEVER. |
| Code / commits / pasted into Slack | NEVER. |

---

## Upgrade path — 1Password integration (optional, for users with a 1Password subscription)

The clipboard-transfer pattern above is the **default**, and it's fine for most threat models. For users who already have a 1Password subscription, there's a stronger option: store keys *inside* 1Password's encrypted vault, and have scripts fetch them on demand via the `op` CLI.

### Why someone would want this

| | Default (`.env` file) | Upgrade (1Password) |
|---|---|---|
| **Where keys live** | Hidden text file on disk, `chmod 600` | Encrypted 1Password vault, biometric-gated |
| **Setup time** | ~30 seconds per key (clipboard transfer) | ~10 min one-time + ~1 min per key |
| **Cost** | Free | Existing 1Password subscription (~$3–5/mo) |
| **If Mac is stolen / compromised** | Keys readable to anyone with disk access | Keys unreadable without Touch ID + 1Password account |
| **Recovery on new Mac** | Manual re-paste from password manager | Sign into 1Password → keys auto-available |
| **Day-to-day friction** | None | Touch ID prompt ~once per active hour |

### When to offer this during install

The kick-off skill (Section A) asks the user: *"Do you have a 1Password subscription? If yes, I can set up the secure-vault version of key handling instead of the default `.env` file. Takes about 10 extra minutes."*

If yes → run the install steps below.
If no / not sure → use the default clipboard-transfer pattern. Don't push; the default is fine.

### Install steps (the AI runs these on the user's behalf)

#### 1. Install the 1Password CLI

```bash
brew install --cask 1password-cli
```

Verify:
```bash
op --version
# Output: 2.x.x
```

#### 2. Connect the CLI to the 1Password app

Open the 1Password desktop app → Settings → Developer → toggle on **"Integrate with 1Password CLI."** This enables Touch ID-based authentication without needing to type the master password every time.

Test:
```bash
op vault list
# First call triggers Touch ID prompt. After that, session is cached for ~30 min.
```

#### 3. Create a dedicated vault for the AI

In the 1Password app, create a new vault called **"Agents"** (or `[AI_NAME]` — user's choice). This isolates AI keys from personal logins. Important for security boundary: if the AI ever needs to share access with another service, you only expose this vault, not your whole password collection.

#### 4. Migrate keys from `.env` into 1Password items

For each key the user has (OpenAI, ElevenLabs, Telegram, etc.):

```bash
# Use the 1Password GUI: New Item → API Credential → name it after the service (e.g., "OpenAI API")
# Add the "credential" field with the actual key value
# Save it to the Agents vault
```

Or via CLI (faster, no GUI):
```bash
op item create --category=apicredential \
  --title="OpenAI API" \
  --vault="Agents" \
  credential="sk-proj-abcdef..."
```

#### 5. Update scripts to fetch via `op read`

Anywhere a script currently does:
```bash
source ~/.config/[ai-name]/.env
echo "$OPENAI_API_KEY"
```

Replace with:
```bash
OPENAI_API_KEY=$(op read "op://Agents/OpenAI API/credential")
```

Common patterns:

```bash
# Use directly in a curl call
curl -H "Authorization: Bearer $(op read "op://Agents/OpenAI API/credential")" ...

# Export for a child process
export OPENAI_API_KEY=$(op read "op://Agents/OpenAI API/credential")
python my_script.py

# Or use op's run wrapper (no env var ever materializes in the shell)
op run --env-file=.env.tpl -- python my_script.py
# Where .env.tpl contains: OPENAI_API_KEY=op://Agents/OpenAI API/credential
```

#### 6. Delete the plaintext `.env` (only after verifying everything works)

Once every script has been updated and tested, remove the working-file derivative:

```bash
shred -u ~/.config/[ai-name]/.env  # secure delete
# Or on macOS without shred:
rm -P ~/.config/[ai-name]/.env  # overwrite then delete
```

Keep the `env-template.txt` recovery file (with no values) — it still serves as a checklist if 1Password ever becomes unavailable.

### Failure modes + fixes

| Symptom | Fix |
|---|---|
| `op read` hangs forever | 1Password app not running → open it. Or biometric session expired → first `op` call should re-prompt for Touch ID. |
| Script fails with "vault not found" | Vault name typo. Check `op vault list` for exact name (case-sensitive). |
| Script fails in launchd job but works in terminal | launchd jobs run without GUI session → 1Password Touch ID flow can't trigger. **Fix:** use a service account (1Password Business tier) OR fall back to `.env` for launchd-only scripts. This is the main reason some users stay on `.env` for their automated scripts. |
| Want to grant temporary access to another tool | 1Password's item sharing — share specific items without exposing the whole vault. Item links expire after a set time. |

### When NOT to recommend the upgrade

- User doesn't have a 1Password subscription → don't sell it; default is fine.
- User runs lots of launchd jobs and doesn't have 1Password Business (service accounts) → mixed setup (1Password for interactive, `.env` for automated) adds complexity for limited gain. Default is fine.
- User is doing throwaway / experiment work → not worth the 10 min.

The default pattern is the right starting point. Upgrade is for users who explicitly want it.

---

## What the user can do once this pattern is in place

- Hand secrets to the agent without polluting chat history.
- Trust that the agent won't echo the key in any output.
- Reduce the blast radius of a leaked transcript (no secrets to leak).

---

## Notes for the agent

- **The clipboard step is `pbpaste` on macOS.** Linux equivalent: `xclip -selection clipboard -o` or `wl-paste`. Windows: `powershell.exe Get-Clipboard`.
- **For one-off scripts that need a secret, prefer reading from `.env` over passing as a CLI arg.** CLI args show up in `ps aux` and shell history.
- **If the user is on a tool that doesn't support `.env` files** (rare), recommend they store the secret in macOS Keychain via `security add-generic-password` and read it via `security find-generic-password -s <name> -w`.
- **Never write secrets to log files, even on error paths.** Use `*****` or `[REDACTED]` placeholders in error messages.
- **For shared codebases / team contexts**, recommend a secrets manager (1Password CLI, Doppler, AWS Secrets Manager, Vercel env vars) over `.env` files. This pattern is for personal/solo workflows.
