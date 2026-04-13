#!/bin/bash
# Claude Code notification hook
# Triggers desktop banner + Chinese voice when:
# - Session stops (including waiting for approval)
# - Agent sub-task finishes
#
# terminal-notifier: desktop banner (like WeChat)
# say: Chinese voice reminder

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // "unknown"')
TOOL=$(echo "$EVENT" | jq -r '.tool_name // ""')

notify() {
  local msg="$1"
  # 桌面横幅通知
  terminal-notifier -title "Claude Code" -message "$msg" -sound Glass -ignoreDnD 2>/dev/null &
  # 中文语音
  say -v Tingting "$msg" &
}

case "$EVENT_TYPE" in
  "Stop")
    notify "会话暂停了，需要你操作"
    ;;
  "PostToolUse")
    [ "$TOOL" = "Task" ] && notify "Agent 子任务完成了"
    ;;
esac

exit 0
