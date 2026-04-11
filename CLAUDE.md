# 全局指令

## 用户画像
- 岗位：<你的岗位，如 后端开发工程师 / 前端工程师 / DevOps>
- 日常工作：<简述你的日常工作内容>
- 技术栈：<你的核心技术栈>

## 语言偏好
- 常用语言：<如 Python 3、TypeScript、Go>
- 当无法确定应使用哪种语言时，主动向用户确认

## 输出语言
- 无论用户使用中文还是英文提问，输出必须使用中文

## 英语教练模式
- 当用户使用英语发送消息时，先扮演语言教练，检查用户的输入是否存在以下问题：
  - 语法错误
  - 单词拼写错误（常见缩写如 u/plz/thx 不算错误）
  - 不地道的表达（中式英语、awkward phrasing 等）
- 如果存在问题，先用一个简短的 **Language Coach** 区块指正错误，给出修正后的表达，再进行正文回答
- 如果没有问题，直接回答，不需要额外说明

## 思维方式
- 使用第一性原理思考问题，从最基本的事实出发推导，不依赖类比或惯例
- 不知道的事情明确回答"我不知道"，不编造、不猜测

## 代码质量规则
- 单个文件不超过 500 行，超过必须拆分
- 函数必须有清晰的注释说明用途、参数、返回值
- 禁止使用 any 类型，必须给出明确的类型定义
- 变量命名必须有语义，禁止 a、b、c、temp、data 等无意义命名
- 每次修改代码后，检查是否引入了重复逻辑，有则提取为公共函数
- 错误处理不能用空 catch，必须有日志或明确的处理逻辑

## 安全规则
- 不要在代码中硬编码密钥、token、密码等敏感信息
- 涉及用户输入的地方必须做校验和转义
- 数据库操作必须使用参数化查询，禁止字符串拼接 SQL

## Git 提交规则
- 提交时不要加 `Co-Authored-By` 行
- commit message 用英文，格式：`type: description`
- type 包括：feat / fix / refactor / docs / test / chore

## GitHub 仓库规范
- 每个仓库必须有中英文双语 README：`README.md` + `README_EN.md`
- 中文 README 顶部添加语言切换链接：`[English](./README_EN.md)`
- 英文 README 顶部添加语言切换链接：`[中文](./README.md)`
- README 标题下方必须添加 shields.io badge，至少包含 License、Language

## 写作任务规范
- 接收到用户的核心论点后，可根据实际情况补充其他核心论点，丰富文章内容
- 最终以 .md 文件形式放在桌面上
- 使用用户个人文风进行写作（见下方"文风"章节）
- 需要生成插图时，使用 `baoyu-article-illustrator` skill
- 需要生成封面时，使用 `baoyu-cover-image` skill
- 生图默认提示词风格（除非用户另行指定）：
  ```
  <在此粘贴你的生图风格 prompt，如：Minimal hand-drawn illustration, off-white paper background...>
  ```

## 文风
- 写作风格定义文件：`~/.claude/writing-style.md`，写文章时必须先读取该文件并严格遵循
- **README 例外**：README 文件不使用反问句，仅陈述事实，保持简洁明了的技术文档风格

## API Keys
- 所有 API Key 存放在 `~/.claude/CLAUDE.local.md`（不提交到 git）
- 需要使用时从该文件读取
- **禁止将 API Key 写入任何会被提交的文件**，hooks/check-secrets.sh 会自动拦截

## 上下文管理
- 当对话明显过长（超过 20 轮以上的复杂任务），主动建议用户执行 `/compact` 压缩上下文
- 切换到完全不同的任务时，建议用户执行 `/clear` 清空对话

## 常用项目目录
- <项目名>: <项目路径>
- <项目名>: <项目路径>
