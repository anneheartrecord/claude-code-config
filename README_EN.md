[中文](./README.md)

# Claude Code Configuration Best Practices

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.1-blue)
![Language](https://img.shields.io/badge/language-中文%20%7C%20English-orange)
![Config](https://img.shields.io/badge/config-battle--tested-red)

First thing after installing Claude Code? Copy someone else's config. Totally normal.

settings.json, CLAUDE.md, Skills, MCP, Hooks — five dimensions, massive combination space. The docs explain what each option does, but not how to configure them well. **The gap between "it works" and "it works great" is a battle-tested config.**

## One-Line Install

```bash
git clone https://github.com/anneheartrecord/claude-code-config.git && cd claude-code-config && bash install.sh
```

Auto-backup existing config → copy to `~/.claude/` → restart to apply.

## What This Config Does

### 1️⃣ settings.json: Max Efficiency, Hard Safety Floor

| Setting | Value | Why |
|---------|-------|-----|
| defaultMode | `bypassPermissions` | Personal dev machine, popups kill flow state |
| allow | All 10 tools | Not needed in bypass mode, but catches you when switching modes |
| deny | 12 irreversible operations | `rm -rf /`, `git push --force`, `git reset --hard`, `chmod 777`, `dd`, `mkfs` |
| hooks | PreToolUse interceptor | Double protection against dangerous rm commands |
| hooks | Stop + PostToolUse | cmux desktop notification: push when session pauses or Agent sub-task finishes |
| attribution | Empty string | Disable Co-Authored-By in commits |

**Core principle: pursue gains aggressively, but risks must have hard stop-losses.**

### 2️⃣ CLAUDE.md: The Agent's Operating Manual

The **most important file** in Claude Code. The Agent reads it on every startup and follows what you write.

Template includes 10 sections:

| Section | Purpose |
|---------|---------|
| User Profile | Tell the Agent who you are; it adapts to your skill level |
| Language Preferences | Asks instead of guessing when language is unclear |
| Thinking Style | First principles + admit ignorance — **these two are critical** |
| Code Quality Rules | 500-line file cap, no `any` type, no empty catch |
| Security Rules | No hardcoded secrets, parameterized queries only |
| Git Rules | Commit format, no Co-Authored-By |
| GitHub Standards | Bilingual README, shields.io badges |
| Writing Tasks | Style reference, image generation Skill config, default prompt style |
| Writing Style | Points to writing-style.md, README exception rules |
| Project Directories | Frequently used paths for quick navigation |

**You must replace** all `<placeholders>` with your own info after installation.

### 3️⃣ writing-style.md: Writing Style DNA

Only for people who write with Claude Code. Distill your writing style into a profile, load it on demand:

```
Read ~/.claude/writing-style.md, write an article about xxx in my style
```

Template includes 8 **anti-AI-trace rules** targeting common AI-generated text patterns:

| Rule | AI's Bad Habit |
|------|---------------|
| Pivot phrases | "It's not X, it's Y" |
| Quote emphasis | Wrapping words in "" for emphasis |
| Parenthetical notes | Using () for inline clarification |
| Em dashes | Chaining clauses with — |
| Triple parallelism | "First… Second… Third…" neat triplets |
| Summary openers | "In summary", "At its core", "Fundamentally" |
| Connector overuse | "However", "Therefore", "Meanwhile" gluing paragraphs |
| Generic uplift | "In this era of XX, we need XX more than ever" |

Also limits rhetorical questions: max 1-2 per article, placed at the most impactful position only.

Why not put it in CLAUDE.md? Writing style is only useful when writing. Loading it every conversation wastes tokens. **Layer your memory, load on demand.**

### 4️⃣ mcp_servers.json: Three MCP Tools

| Tool | Purpose |
|------|---------|
| **Playwright** | Browser automation — screenshots, form filling, page scraping |
| **Context7** | Query latest docs for third-party libraries, prevent outdated API usage |
| **Sequential Thinking** | Force multi-step reasoning for complex architectural decisions |

### 5️⃣ Project-Level Config Example

`examples/project-CLAUDE.md` provides a project-level config template. Place it in your project root — applies only to that project, shared with your team.

Includes project info, code standards, testing requirements, directory structure, deploy commands. Copy it, swap in your project details, done.

### 6️⃣ Recommended Skills

| Skill | Install | Contents |
|-------|---------|----------|
| **baoyu-skills** | `gh repo clone JimLiu/baoyu-skills /tmp/bs && cp -r /tmp/bs/skills/* ~/.claude/skills/` | Translation, tweets, image gen — 19 total |
| **follow-builders** | `gh repo clone zarazhangrui/follow-builders ~/.claude/skills/follow-builders` | AI builder tracking |
| **frontend-design** | `gh repo clone anthropics/skills /tmp/as && cp -r /tmp/as/skills/frontend-design ~/.claude/skills/` | Anthropic official frontend design |

## Repo Structure

```
claude-code-config/
├── install.sh                          # One-click install
├── settings.json                       # Permissions + Hooks + deny rules
├── CLAUDE.md                           # Global instruction template
├── writing-style.md                    # Writing style template
├── mcp_servers.json                    # MCP tool config
├── hooks/
│   ├── check-secrets.sh                # Secret leak prevention
│   └── cmux-notify.sh                  # cmux desktop notification (session pause / task done)
├── examples/
│   └── project-CLAUDE.md               # Project-level config example
├── README.md                           # Chinese
└── README_EN.md                        # English
```

## Configuration Philosophy

**Efficiency first, safety as backstop.** bypassPermissions for max speed, 12 deny rules + Hooks double-insurance for the floor.

**Explicit over implicit.** The clearer you write, the more stable the Agent. Don't expect it to guess your preferences.

**Layered memory, loaded on demand.** Global rules in CLAUDE.md, writing style in a separate file, project rules in project-level CLAUDE.md. Different layers, different loading strategies, zero context waste.

## Who This Is For / Not For

**For:** Claude Code users on personal dev machines who want maximum efficiency.

**Not for:** Enterprise environments, shared machines, strict permission requirements. bypassPermissions is for people who trust their own dev environment.

## License

MIT
