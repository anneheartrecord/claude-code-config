#!/bin/bash
# Claude Code notification hook
# Triggers desktop banner + audio notification when:
# - Session stops (including waiting for approval)
# - Agent sub-task finishes
#
# Notification: terminal-notifier (desktop banner)
# Audio: custom sound file via afplay, fallback to macOS TTS
#
# Customization:
#   Place your own audio file at ~/.claude/hooks/sounds/notify.m4a
#   Supported formats: .m4a .mp3 .wav .aiff .caf
#   If no custom sound file found, falls back to `say -v Tingting`

HOOKS_DIR="$HOME/.claude/hooks"
SOUND_FILE=""

# Find custom sound file (first match wins)
for ext in m4a mp3 wav aiff caf; do
  if [ -f "$HOOKS_DIR/sounds/notify.$ext" ]; then
    SOUND_FILE="$HOOKS_DIR/sounds/notify.$ext"
    break
  fi
done

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // "unknown"')
TOOL=$(echo "$EVENT" | jq -r '.tool_name // ""')

notify() {
  local msg="$1"
  # 桌面横幅通知
  terminal-notifier -title "Claude Code" -message "$msg" -sound default -ignoreDnD 2>/dev/null &
  # 音频提醒：优先自定义音频，否则用系统 TTS
  if [ -n "$SOUND_FILE" ]; then
    afplay "$SOUND_FILE" 2>/dev/null &
  else
    say -v Tingting "$msg" &
  fi
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
