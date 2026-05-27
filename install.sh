#!/bin/bash
set -e
SKILL="github-skill-downloader"
DIR="$HOME/.claude/skills/$SKILL"
URL="https://raw.githubusercontent.com/shimenghan6/$SKILL/master/SKILL.md"

echo "安装 $SKILL ..."
mkdir -p "$DIR"
curl -fsSL "$URL" -o "$DIR/SKILL.md"
echo "✅ 完成。重启 Claude Code 即可使用。"
