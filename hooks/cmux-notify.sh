#!/bin/bash
# cmux notification hook for Claude Code
# Triggers desktop notification when:
# - Session stops (including waiting for approval)
# - Agent sub-task finishes

# Skip if not in cmux
[ -S /tmp/cmux.sock ] || exit 0

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // "unknown"')
TOOL=$(echo "$EVENT" | jq -r '.tool_name // ""')

case "$EVENT_TYPE" in
  "Stop")
    cmux notify --title "Claude Code" --body "Session complete — check for pending approval"
    ;;
  "PostToolUse")
    [ "$TOOL" = "Task" ] && cmux notify --title "Claude Code" --body "Agent task finished"
    ;;
esac

exit 0
