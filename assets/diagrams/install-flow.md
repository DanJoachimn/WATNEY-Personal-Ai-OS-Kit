# Install Flow Diagrams

> Mermaid diagrams the AI shows the user during install + ongoing operation. Claude Code Desktop renders Mermaid natively in chat — paste any of these blocks inline at the right moment in the conversation.

---

## The full install at a glance (show at Stage 0 — greeting)

```mermaid
graph LR
    A[You install<br/>Claude Code] --> B[Paste the<br/>magic prompt]
    B --> C[I set up<br/>your folder]
    C --> D[I install<br/>5 core skills]
    D --> E[I wire up<br/>scheduled jobs]
    E --> F[We talk<br/>~25 min]
    F --> G[Your AI<br/>knows you]
    style A fill:#e1f5ff,stroke:#0066cc
    style G fill:#d4f4dd,stroke:#22a06b
```

---

## What gets created on your Mac (show at Stage 5 — vault scaffold)

```mermaid
graph TD
    HOME[~/Documents/AI-NAME/] --> VAULT[vault/]
    HOME --> KIT[.kit/<br/>the kit from GitHub]
    HOME --> RECOVERY[_recovery/<br/>backup helpers]
    VAULT --> CMD[CLAUDE.md<br/>your AI's operating manual]
    VAULT --> TOOLS[tools.md<br/>what I have access to]
    VAULT --> MEM[Memory/<br/>daily memory + long-term]
    VAULT --> BRAND[Brand/<br/>your voice, references, do-not-use]
    VAULT --> PROJ[Projects/<br/>one file per active project]
    VAULT --> PEOPLE[People/<br/>who matters]
    VAULT --> COS[Companies/<br/>collaborators, clients]
    VAULT --> NOTES[Notes/<br/>your catch-all]
    style HOME fill:#fff5e6,stroke:#cc7a00
    style VAULT fill:#e6f7ff,stroke:#0080b3
```

---

## The memory layer (show at Stage 6 — when explaining dreaming)

```mermaid
graph TB
    SESSION[Our conversations<br/>during the day] -->|wrap-up<br/>captures 1-liners| DAILY[daily-memory.md<br/>rolling buffer]
    DAILY -->|dreaming<br/>fires at 02:00| LONGTERM[long-term.md<br/>synthesized state]
    LONGTERM -->|loaded at<br/>session start| AI[Me — your AI]
    AI -->|knows yesterday's<br/>context| SESSION
    style DAILY fill:#fff9e6,stroke:#cc9900
    style LONGTERM fill:#e6ffe6,stroke:#22a06b
    style AI fill:#e6f0ff,stroke:#0052cc
```

---

## The four subagents (show during kick-off Section A intro)

```mermaid
graph TB
    YOU[You] -->|talk to| ORCH[Me — the orchestrator]
    ORCH --> R[Research<br/>subagent<br/>deep-dives, sources]
    ORCH --> C[Content<br/>subagent<br/>drafts, copy]
    ORCH --> Q[QA<br/>subagent<br/>fresh-eyes review]
    ORCH --> D[Developer<br/>subagent<br/>scripts, technical builds]
    style YOU fill:#fff5e6,stroke:#cc7a00
    style ORCH fill:#e6f0ff,stroke:#0052cc
```

---

## Where API keys live (show in Guide 03 — API Key Hygiene context)

```mermaid
graph LR
    SOURCE[OpenAI<br/>website] -->|you copy| CLIPBOARD[clipboard]
    CLIPBOARD -->|pbpaste| ENVFILE[~/.config/AI-NAME/.env<br/>chmod 600]
    ENVFILE -->|sourced by| SCRIPTS[scripts that need the key]
    NEVER[NEVER<br/>chat history]
    style ENVFILE fill:#fff5e6,stroke:#cc7a00
    style NEVER fill:#ffe6e6,stroke:#cc0000,stroke-width:3px
```

---

## With 1Password upgrade (show when upgrade installed)

```mermaid
graph LR
    SOURCE[OpenAI<br/>website] -->|you paste once| VAULT[1Password<br/>Agents vault]
    VAULT -->|op read<br/>Touch ID gate| SCRIPTS[scripts that need the key]
    style VAULT fill:#d4f4dd,stroke:#22a06b,stroke-width:3px
```

---

## The update flow (show when /update runs)

```mermaid
sequenceDiagram
    participant U as You
    participant AI as Me
    participant GH as GitHub repo
    U->>AI: /update
    AI->>GH: git fetch
    GH-->>AI: New commits available
    AI->>AI: Read UPDATE.md from repo
    AI->>U: "3 things changed — want to see?"
    U-->>AI: Yes
    AI->>U: Lists changes, asks per-skill consent
    U-->>AI: Approve / skip per skill
    AI->>AI: Apply approved changes
    AI->>U: ✅ Update complete
```

---

## How to add a new diagram

1. Pick a moment in the install/operation where a picture would help
2. Write the mermaid block here with a clear heading
3. Reference it from the relevant playbook (INSTALL.md, kick-off SKILL.md, a guide)
4. The AI fetches this file when it needs the block and pastes it inline in chat

Mermaid syntax reference: https://mermaid.js.org/

---

*Diagrams are show-don't-tell. Use them at structural moments: "here's what I'm about to build for you," "here's how this thing works," "here's what just happened." Not for every step.*
