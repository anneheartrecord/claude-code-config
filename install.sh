#!/bin/bash
set -e

CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backup_$(date +%Y%m%d_%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 Claude Code 配置安装脚本"
echo "================================"

# 创建 ~/.claude 目录
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "📁 创建 $CLAUDE_DIR ..."
    mkdir -p "$CLAUDE_DIR"
fi

# 备份现有配置
NEED_BACKUP=false
for f in settings.json CLAUDE.md writing-style.md mcp_servers.json; do
    if [ -f "$CLAUDE_DIR/$f" ]; then
        NEED_BACKUP=true
        break
    fi
done

if [ "$NEED_BACKUP" = true ]; then
    echo "📦 备份现有配置到 $BACKUP_DIR ..."
    mkdir -p "$BACKUP_DIR"
    for f in settings.json CLAUDE.md writing-style.md mcp_servers.json; do
        if [ -f "$CLAUDE_DIR/$f" ]; then
            cp "$CLAUDE_DIR/$f" "$BACKUP_DIR/$f"
            echo "   ✅ 已备份 $f"
        fi
    done
fi

# 复制配置文件
echo "📝 安装配置文件 ..."

cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
echo "   ✅ settings.json → 权限与行为配置"

cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "   ✅ CLAUDE.md → 全局指令记忆（模板）"

cp "$SCRIPT_DIR/writing-style.md" "$CLAUDE_DIR/writing-style.md"
echo "   ✅ writing-style.md → 写作风格 DNA（模板）"

cp "$SCRIPT_DIR/mcp_servers.json" "$CLAUDE_DIR/mcp_servers.json"
echo "   ✅ mcp_servers.json → MCP 工具配置"

# 安装 hooks
mkdir -p "$CLAUDE_DIR/hooks"
if [ -d "$SCRIPT_DIR/hooks" ]; then
    cp "$SCRIPT_DIR/hooks/"* "$CLAUDE_DIR/hooks/" 2>/dev/null
    chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null
    echo "   ✅ hooks/ → 敏感信息拦截等 Hook 脚本"
fi

echo ""
echo "📋 项目级配置示例已放在仓库 examples/ 目录，需要时手动复制到项目根目录"

echo ""
echo "================================"
echo "🎉 安装完成！"
echo ""
echo "⚠️  重要：请修改以下文件中的个人信息"
echo "   - $CLAUDE_DIR/CLAUDE.md  （用户画像、语言偏好、项目目录）"
echo "   - $CLAUDE_DIR/writing-style.md  （你的写作风格，可选）"
echo ""
echo "🔄 重启 Claude Code 即可生效"

if [ "$NEED_BACKUP" = true ]; then
    echo ""
    echo "📦 旧配置已备份到: $BACKUP_DIR"
fi
