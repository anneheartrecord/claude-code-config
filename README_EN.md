[中文](./README.md)

# Claude Code Configuration Best Practices

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.1-blue)
![Language](https://img.shields.io/badge/language-中文%20%7C%20English-orange)
![Config](https://img.shields.io/badge/config-battle--tested-red)

What's the first thing most people do after installing Claude Code? Copy someone else's config.

That's totally normal. Claude Code's configuration system is incredibly flexible — settings.json, CLAUDE.md, Skills, MCP, and Hooks across five dimensions create a massive combination space. But the official docs only explain what each option means, not how to configure them well. **The gap between "it works" and "it works great" is a battle-tested configuration.**

This repo is my complete configuration as a heavy Claude Code user. Every setting comes with an explanation of why it's configured that way.

## One-Line Install

```bash
git clone https://github.com/anneheartrecord/claude-code-config.git && cd claude-code-config && bash install.sh
```

`install.sh` automatically backs up your existing configuration, then copies the core files to `~/.claude/`. Restart Claude Code after installation to apply.

## Configuration Overview

### 1️⃣ settings.json: Permissions & Behavior

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read(*)", "Edit(*)", "Write(*)",
      "WebFetch(*)", "WebSearch(*)", "Glob(*)", "Grep(*)",
      "NotebookEdit(*)", "Agent(*)"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf /*)",
      "Bash(git push --force origin main)",
      "Bash(git push --force origin master)"
    ]
  },
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

**Why bypassPermissions?** On a personal dev machine, confirmation popups on every tool call severely disrupt flow. bypassPermissions lets the Agent execute freely, massively boosting efficiency. If you're on a shared machine or enterprise environment, use `acceptEdits` mode instead.

**Why list all tools in allow?** Under bypassPermissions, the allow list isn't strictly necessary, but explicitly listing everything has two benefits: these rules still apply when you temporarily switch to other permission modes, and the configuration intent is clearer.

**Why only four deny rules?** These four are truly irreversible bottom lines. `rm -rf /` prevents accidental root deletion; `git push --force origin main/master` prevents accidental overwrite of main branch history.

**Why is attribution.commit an empty string?** Disables the auto-appended `Co-Authored-By: Claude` signature in commit messages.

### 2️⃣ CLAUDE.md: Global Instruction Memory

This is the **most important file** in Claude Code configuration, determining the Agent's behavior patterns and work standards.

The repo provides a **template** with these sections:

**User Profile.** Tell the Agent who you are and what you do. The Agent automatically adapts to your technical background and expertise level.

**Language Preferences.** Explicitly tell the Agent your commonly used programming languages. When requirements are unclear, the Agent will ask instead of guessing.

**Thinking Style.** Require the Agent to think from first principles and say "I don't know" when it doesn't. **These two are extremely important.** Without this constraint, the Agent tends to give plausible-sounding but potentially fabricated answers.

**Git Commit Rules.** Conventions for commits, such as whether to add Co-Authored-By, commit message format, etc.

**GitHub Repo Standards.** Like bilingual READMEs, shields.io badges. Once in CLAUDE.md, the Agent follows these automatically for every new repo.

**Writing Task Standards.** If you use Claude Code for writing, define output format and extension rules.

**Project Directories.** List commonly used project paths so the Agent can quickly locate them without asking every time.

After installation, **modify the personal information in CLAUDE.md** to match your actual situation. The template content is just an example.

### 3️⃣ writing-style.md: Writing Style DNA (Optional)

If you do extensive writing with Claude Code, you can distill your writing style into a profile file. Have the Agent read it when needed:

```
Read ~/.claude/writing-style.md, then write an article about xxx in my style
```

**Why not put it in CLAUDE.md?** Writing style is only useful when writing. Putting it in CLAUDE.md means it loads every conversation, wasting tokens. A separate file loaded on demand is more efficient.

The writing-style.md in the repo is a template. You can use the `/extract-memory` Skill to automatically extract a style profile from your own articles.

### 4️⃣ mcp_servers.json: External Tools

```json
{
  "playwright": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@playwright/mcp@latest"]
  }
}
```

Currently only Playwright is configured for browser automation. The MCP ecosystem is still early-stage; most needs are covered by Claude Code's built-in tools.

### 5️⃣ Recommended Skills

| Skill Collection | Install Command | What's Included |
|-----------------|-----------------|-----------------|
| **baoyu-skills** | `gh repo clone JimLiu/baoyu-skills /tmp/bs && cp -r /tmp/bs/skills/* ~/.claude/skills/` | Translation, tweet, image gen, YouTube transcription, 19 total |
| **follow-builders** | `gh repo clone zarazhangrui/follow-builders ~/.claude/skills/follow-builders` | AI industry builder tracking |
| **frontend-design** | `gh repo clone anthropics/skills /tmp/as && cp -r /tmp/as/skills/frontend-design ~/.claude/skills/` | Anthropic official frontend design Skill |

Restart Claude Code after installation to recognize new Skills.

## Repo Structure

```
claude-code-config/
├── install.sh                   # One-click install script
├── README.md                    # Chinese version
├── README_EN.md                 # You're reading this
├── settings.json                # Permissions and behavior config
├── CLAUDE.md                    # Global instruction memory (template)
├── writing-style.md             # Writing style DNA (template, optional)
└── mcp_servers.json             # MCP tool config
```

## Configuration Philosophy

**Efficiency first, safety as backstop.** bypassPermissions pursues maximum efficiency while deny rules hold the line on irreversible operations. Pursue gains aggressively, but risks must have hard stop-losses.

**Explicit over implicit.** Every rule in CLAUDE.md is a clear instruction, not relying on the Agent to guess your preferences. The clearer you write, the more stable the Agent's performance.

**Layered memory, loaded on demand.** Global rules go in CLAUDE.md, writing style goes in a separate file, project-specific rules go in project-level CLAUDE.md. Different layers of information have different loading strategies, avoiding context waste.

## Who This Is For

- Beginners who just installed Claude Code and don't know how to configure it
- Experienced users who feel the Agent isn't following instructions well enough
- Developers who want to reference others' configuration approaches
- People who use Claude Code for both development and writing

## Who This Is NOT For

- Enterprise environments requiring strict permission controls — bypassPermissions isn't suitable for shared machines
- Users who only use Claude Code for simple Q&A — default configuration is sufficient

## License

MIT
