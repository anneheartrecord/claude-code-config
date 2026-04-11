#!/bin/bash
# Pre-tool-use hook: 拦截写入文件时包含的敏感信息
# 检查 Write/Edit 工具的内容是否包含 API Key、密码等
#
# 用法：配置到 settings.json 的 hooks.PreToolUse 中
# 匹配 Write 和 Edit 工具调用

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# 只检查 Write 和 Edit 操作
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# 跳过允许包含敏感信息的文件
if [[ "$FILE_PATH" == *"CLAUDE.local.md"* || "$FILE_PATH" == *".env"* || "$FILE_PATH" == *".env.local"* ]]; then
  exit 0
fi

# 敏感信息模式匹配
PATTERNS=(
  'AIzaSy[0-9A-Za-z_-]{33}'           # Google API Key
  'sk-[0-9a-zA-Z]{20,}'               # OpenAI / Anthropic API Key
  'ghp_[0-9a-zA-Z]{36}'               # GitHub Personal Access Token
  'AKIA[0-9A-Z]{16}'                   # AWS Access Key
  'password\s*[:=]\s*["\x27][^"\x27]+' # password = "xxx"
)

for pattern in "${PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qP "$pattern" 2>/dev/null; then
    echo "BLOCKED: 检测到疑似敏感信息（匹配模式: $pattern），请将敏感信息放在 CLAUDE.local.md 或 .env 中"
    exit 2
  fi
done

exit 0
