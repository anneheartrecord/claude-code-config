[English](./README_EN.md)

# Claude Code 配置最佳实践

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.1-blue)
![Language](https://img.shields.io/badge/language-中文%20%7C%20English-orange)
![Config](https://img.shields.io/badge/config-battle--tested-red)

大部分人装完 Claude Code 之后做的第一件事是什么？找别人的配置抄。

这很正常。Claude Code 的配置体系非常灵活，settings.json、CLAUDE.md、Skills、MCP、Hooks 五个维度加在一起，组合空间巨大。但官方文档只告诉你每个选项是什么意思，不告诉你应该怎么配。**从能用到好用，中间差的就是一份经过实战验证的配置。**

这个仓库是我作为 Claude Code 重度用户的完整配置，每一条都附带了为什么这么配的解释。

## 一行命令安装

```bash
git clone https://github.com/anneheartrecord/claude-code-config.git && cd claude-code-config && bash install.sh
```

`install.sh` 会自动备份你的现有配置，然后把核心文件复制到 `~/.claude/`。安装完重启 Claude Code 即可生效。

## 配置概览

### 1️⃣ settings.json：权限与行为

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

**为什么用 bypassPermissions？** 个人开发机场景，每次工具调用都弹窗确认严重打断心流。bypassPermissions 让 Agent 自由执行，效率提升巨大。如果你是在共用机器上或企业环境，建议用 `acceptEdits` 模式。

**为什么 allow 列了所有工具？** bypassPermissions 下其实不需要 allow 列表，但显式列出有两个好处：临时切到其他权限模式时这些规则仍然生效；让配置的意图更清晰。

**为什么 deny 只有四条？** 这四条是真正不可逆的底线。`rm -rf /` 防误删根目录，`git push --force origin main/master` 防误覆盖主分支历史。

**attribution.commit 为什么是空字符串？** 关掉 commit message 里自动添加的 `Co-Authored-By: Claude` 签名。

### 2️⃣ CLAUDE.md：全局指令记忆

这是 Claude Code 配置中**最重要的文件**，决定了 Agent 的行为模式和工作规范。

仓库里提供了一份**模板**，包含以下板块：

**用户画像。** 告诉 Agent 你是谁、做什么工作。Agent 会自动适配你的技术背景和专业水平。

**语言偏好。** 明确告诉 Agent 你常用的编程语言。需求不明确时 Agent 会主动问，而不是自己猜。

**思维方式。** 要求 Agent 用第一性原理思考，不知道的事情直接说不知道。**这两条极其重要。** 没有这个约束，Agent 会倾向于给你一个听起来合理但可能是编造的答案。

**Git 提交规则。** 提交时的行为约定，比如是否加 Co-Authored-By、commit message 格式等。

**GitHub 仓库规范。** 比如中英双语 README、shields.io badge。写进 CLAUDE.md 后 Agent 每次创建仓库都会自动遵循。

**写作任务规范。** 如果你用 Claude Code 做写作，可以定义输出格式和扩展规则。

**项目目录。** 列出常用项目的路径，Agent 可以快速定位，不需要每次都问。

安装后请根据你的实际情况**修改 CLAUDE.md 中的个人信息**。模板里的内容是示例，你需要替换成自己的。

### 3️⃣ writing-style.md：写作风格 DNA（可选）

如果你用 Claude Code 做大量写作，可以把你的写作风格提炼成一份画像文件。需要时让 Agent 读取：

```
读一下 ~/.claude/writing-style.md，用我的风格写一篇关于 xxx 的文章
```

**为什么不放在 CLAUDE.md 里？** 写作风格只在写作时有用，放在 CLAUDE.md 里每次对话都会加载，白白消耗 token。单独放一个文件按需加载更高效。

仓库里的 writing-style.md 是模板，你可以用 `/extract-memory` Skill 从自己的文章中自动提取风格画像。

### 4️⃣ mcp_servers.json：外部工具

```json
{
  "playwright": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@playwright/mcp@latest"]
  }
}
```

目前只配了 Playwright 做浏览器自动化。MCP 生态还在早期，大部分需求 Claude Code 内置工具就能覆盖。

### 5️⃣ 推荐 Skills

| Skill 集合 | 安装命令 | 包含什么 |
|-----------|---------|---------|
| **baoyu-skills** | `gh repo clone JimLiu/baoyu-skills /tmp/bs && cp -r /tmp/bs/skills/* ~/.claude/skills/` | 翻译、发推、生成图片、YouTube 转录等 19 个 |
| **follow-builders** | `gh repo clone zarazhangrui/follow-builders ~/.claude/skills/follow-builders` | AI 行业 builder 动态追踪 |
| **frontend-design** | `gh repo clone anthropics/skills /tmp/as && cp -r /tmp/as/skills/frontend-design ~/.claude/skills/` | Anthropic 官方前端设计 Skill |

安装后重启 Claude Code 即可识别新 Skill。

## 仓库结构

```
claude-code-config/
├── install.sh                   # 一键安装脚本
├── README.md                    # 你在看的这个文件
├── README_EN.md                 # English version
├── settings.json                # 权限和行为配置
├── CLAUDE.md                    # 全局指令记忆（模板）
├── writing-style.md             # 写作风格 DNA（模板，可选）
└── mcp_servers.json             # MCP 工具配置
```

## 配置哲学

**效率优先，安全兜底。** bypassPermissions 追求极致效率，deny 规则守住不可逆操作的底线。收益可以激进追求，但风险必须有硬性止损。

**显式优于隐式。** CLAUDE.md 里的每一条规则都是明确的指令，不依赖 Agent 猜测你的偏好。你写得越清楚，Agent 的表现越稳定。

**记忆分层，按需加载。** 全局规则放 CLAUDE.md，写作风格放独立文件，项目特定规则放项目级 CLAUDE.md。不同层级的信息有不同的加载策略，避免上下文浪费。

## 适合谁

- 刚装完 Claude Code 不知道怎么配的新手
- 用了一段时间但觉得 Agent 不够听话的老用户
- 想参考别人配置思路的开发者
- 同时用 Claude Code 做开发和写作的人

## 不适合谁

- 需要严格权限管控的企业环境，bypassPermissions 不适合多人共用的机器
- 只用 Claude Code 做简单问答的用户，默认配置就够了

## License

MIT
