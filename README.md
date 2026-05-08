[English](./README_EN.md)

# Claude Code 配置最佳实践

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.1-blue)
![Language](https://img.shields.io/badge/language-中文%20%7C%20English-orange)
![Config](https://img.shields.io/badge/config-battle--tested-red)

装完 Claude Code，第一件事找别人的配置抄。这很正常。

settings.json、CLAUDE.md、Skills、MCP、Hooks 五个维度，组合空间巨大，官方文档只告诉你每个选项是什么意思，不告诉你怎么配才好用。**从能用到好用，中间差的就是一份经过实战验证的配置。**

## 一行安装

```bash
git clone https://github.com/anneheartrecord/claude-code-config.git && cd claude-code-config && bash install.sh
```

自动备份现有配置 → 复制到 `~/.claude/` → 重启生效。

## 这份配置做了什么

### 1️⃣ settings.json：效率拉满，底线守住

| 配置项 | 值 | 为什么 |
|-------|---|-------|
| defaultMode | `bypassPermissions` | 个人开发机，弹窗确认打断心流，全部放开 |
| allow | 全部 10 个工具 | bypassPermissions 下不需要，但切模式时兜底 |
| deny | 12 条不可逆操作 | `rm -rf /`、`git push --force`、`git reset --hard`、`chmod 777`、`dd`、`mkfs` |
| hooks | PreToolUse 拦截 | 二次防护，双保险拦截危险 rm 命令 |
| hooks | Stop + PostToolUse | cmux 桌面通知：会话暂停/Agent 子任务完成时推送 |
| attribution | 空字符串 | 关掉 commit 里的 Co-Authored-By 签名 |

**核心思路：收益可以激进追求，风险必须有硬性止损。**

### 2️⃣ CLAUDE.md：Agent 的操作手册

这是 Claude Code 里 **最重要的文件**。Agent 每次启动都会读它，你写什么它就照做。

模板包含 11 个板块：

| 板块 | 作用 |
|-----|------|
| 用户画像 | 告诉 Agent 你是谁，它会适配你的技术水平 |
| 语言偏好 | 不确定用什么语言时会问你，而不是猜 |
| 思维方式 | 第一性原理 + 不知道就说不知道，**这两条极其重要** |
| 代码质量规则 | 单文件 500 行上限、禁止 any、禁止空 catch |
| 安全规则 | 禁止硬编码密钥、必须参数化查询 |
| Git 规则 | commit 格式、不加 Co-Authored-By |
| GitHub 规范 | 双语 README、shields.io badge |
| 写作任务 | 文风引用、生图 Skill 配置、默认 prompt 风格 |
| 推文 / Markdown 发布流转 | 区分初稿和定稿，final 版同步到 personal-site |
| 文风 | 指向 writing-style.md，README 写作例外规则 |
| 项目目录 | 常用项目路径，Agent 直接定位 |

安装后 **必须改** `<占位符>` 里的个人信息。

### 3️⃣ writing-style.md：写作风格 DNA

用 Claude Code 写作的人才需要这个。把你的写作风格提炼成画像，需要时让 Agent 读取：

```
读一下 ~/.claude/writing-style.md，用我的风格写一篇关于 xxx 的文章
```

模板内置了 8 条 **AI 痕迹禁忌**，专门针对 AI 生成文本的常见特征：

| 禁忌 | AI 的坏习惯 |
|------|-----------|
| 转折句式 | "不是……而是……" |
| 引号强调 | 用""包词语做标注 |
| 括号注释 | 用()补充说明 |
| 破折号 | 用——串句子 |
| 三段排比 | "首先…其次…最后…"工整三件套 |
| 总结开头 | "总的来说"、"归根结底"起手 |
| 连接词滥用 | "然而"、"因此"、"与此同时"硬串段落 |
| 万能升华 | "在这个XX时代，我们更需要XX" |

另外限制了反问句频率：一篇文章最多 1-2 处，放在最有冲击力的位置。

为什么不塞进 CLAUDE.md？写作风格只有写作时有用，放 CLAUDE.md 每次对话都加载，白白烧 token。**记忆分层，按需加载。**

### 4️⃣ mcp_servers.json：三个 MCP 工具

| 工具 | 干什么 |
|------|-------|
| **Playwright** | 浏览器自动化，截图、填表、爬页面 |
| **Context7** | 查第三方库最新文档，防止模型用过时 API |
| **Sequential Thinking** | 强制多步推理，适合复杂架构决策 |

### 5️⃣ 项目级配置示例

`examples/project-CLAUDE.md` 提供了一份项目级配置模板。放在项目根目录，只对当前项目生效，团队共享。

包含项目信息、代码规范、测试要求、目录结构、部署命令。直接抄，改成你的项目信息就能用。

### 6️⃣ 推荐 Skills

| Skill | 安装 | 内容 |
|-------|------|------|
| **baoyu-skills** | `gh repo clone JimLiu/baoyu-skills /tmp/bs && cp -r /tmp/bs/skills/* ~/.claude/skills/` | 翻译、发推、生图等 19 个 |
| **follow-builders** | `gh repo clone zarazhangrui/follow-builders ~/.claude/skills/follow-builders` | AI builder 动态追踪 |
| **frontend-design** | `gh repo clone anthropics/skills /tmp/as && cp -r /tmp/as/skills/frontend-design ~/.claude/skills/` | Anthropic 官方前端设计 |

## 仓库结构

```
claude-code-config/
├── install.sh                          # 一键安装
├── settings.json                       # 权限 + Hooks + deny 规则
├── CLAUDE.md                           # 全局指令模板
├── writing-style.md                    # 写作风格模板
├── mcp_servers.json                    # MCP 工具配置
├── hooks/
│   ├── check-secrets.sh                # 敏感信息写入拦截
│   └── cmux-notify.sh                  # cmux 桌面通知（会话暂停/任务完成）
├── examples/
│   └── project-CLAUDE.md               # 项目级配置示例
├── README.md                           # 中文
└── README_EN.md                        # English
```

## 配置哲学

**效率优先，安全兜底。** bypassPermissions 追求极致效率，12 条 deny + Hooks 双保险守住底线。

**显式优于隐式。** 你写得越清楚，Agent 表现越稳定。不要指望它猜你的偏好。

**记忆分层，按需加载。** 全局规则放 CLAUDE.md，写作风格放独立文件，项目规范放项目级 CLAUDE.md。不同层级不同加载策略，不浪费上下文。

## 适合谁 / 不适合谁

**适合：** 个人开发机上追求效率的 Claude Code 用户。

**不适合：** 企业环境、共用机器、需要严格权限管控的场景。bypassPermissions 是给信任自己开发环境的人用的。

## License

MIT
