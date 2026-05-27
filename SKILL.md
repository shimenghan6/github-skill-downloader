---
name: github-skill-downloader
description: |
  When GitHub git clone fails due to corporate network restrictions, this skill uses
  GitHub API to discover repo file structure, then downloads individual files via
  raw.githubusercontent.com with curl. Designed for installing Claude Code skills
  and plugins from GitHub into ~/.claude/skills/ without needing git or VPN.
  Triggers: "download from github", "install skill from github", "clone替代方案",
  "github 下载", "安装github项目"
---

# GitHub 技能下载器 — 免 git clone 安装法

## 适用场景

公司网络封了 GitHub 的 git/HTTPS 协议（`git clone` 报 `Connection reset` / `Failed to connect`），
但 `raw.githubusercontent.com` 可以直连，或至少 GitHub API 能通。

## 核心思路

```
git clone 失败
    │
    ▼
用 GitHub API 查仓库目录结构
    │
    ▼
拿到每个文件的 download_url（指向 raw.githubusercontent.com）
    │
    ▼
用 curl 逐文件下载保存
```

## 三步操作模板

### 第一步：查目录结构

```bash
# 列出仓库某个目录下的所有文件/子目录
curl -s --connect-timeout 10 \
  "https://api.github.com/repos/{OWNER}/{REPO}/contents/{PATH}?ref=main"
```

返回 JSON，每个文件包含:
- `name` — 文件名/目录名
- `type` — `"file"` 或 `"dir"`
- `download_url` — 如果是文件，这是 raw 下载直链
- `size` — 文件大小

### 第二步：提取文件列表

```bash
# 如果 curl 返回的是目录列表，提取所有文件名
curl -s "https://api.github.com/repos/{OWNER}/{REPO}/contents/{PATH}?ref=main" \
  | grep '"name"' | head -30
```

### 第三步：批量下载

```bash
SKILLS="skill-a skill-b skill-c"
BASE="https://raw.githubusercontent.com/{OWNER}/{REPO}/main/{PATH}"
DEST="C:/Users/{USER}/.claude/skills/{skill-name}"

for skill in $SKILLS; do
  mkdir -p "$DEST/$skill"
  curl -sL --connect-timeout 10 -o "$DEST/$skill/SKILL.md" "$BASE/$skill/SKILL.md"
  size=$(wc -c < "$DEST/$skill/SKILL.md" 2>/dev/null)
  echo "$skill: ${size:-FAIL}"
done
```

## 实战案例：安装 superpowers + claude-code-java

### 案例1：claude-code-java（18个技能）

```bash
# 步骤1: 查目录结构
curl -s "https://api.github.com/repos/decebals/claude-code-java/contents/.claude/skills?ref=main"

# 步骤2: 发现每个技能是子目录，内含 SKILL.md 和 README.md
# 查单个技能的目录内容确认：
curl -s "https://api.github.com/repos/decebals/claude-code-java/contents/.claude/skills/java-code-review?ref=main"

# 步骤3: 批量下载 SKILL.md（注意是大写）
SKILLS="java-code-review api-contract-review architecture-review ..."
BASE="https://raw.githubusercontent.com/decebals/claude-code-java/main/.claude/skills"
DEST="C:/Users/shish/.claude/skills/claude-code-java"

for skill in $SKILLS; do
  mkdir -p "$DEST/$skill"
  curl -sL --connect-timeout 10 -o "$DEST/$skill/SKILL.md" "$BASE/$skill/SKILL.md"
  echo "$skill: $(wc -c < "$DEST/$skill/SKILL.md") bytes"
done
```

### 案例2：superpowers（14个技能）

```bash
# 查目录
curl -s "https://api.github.com/repos/obra/superpowers/contents/skills?ref=main"

# 下载
SKILLS="brainstorming dispatching-parallel-agents executing-plans ..."
BASE="https://raw.githubusercontent.com/obra/superpowers/main/skills"
DEST="C:/Users/shish/.claude/skills/superpowers"

for skill in $SKILLS; do
  mkdir -p "$DEST/$skill"
  curl -sL --connect-timeout 10 -o "$DEST/$skill/SKILL.md" "$BASE/$skill/SKILL.md"
  echo "$skill: $(wc -c < "$DEST/$skill/SKILL.md") bytes"
done
```

## 常见坑

| 坑 | 现象 | 解决 |
|----|------|------|
| **文件名大小写** | 下载全是404（14字节） | Claude Code 技能文件标准是 `SKILL.md`（大写），不是 `skill.md` |
| **文件 vs 目录** | API 显示 `type: "dir"` 但 `download_url: null` | 需要进一步查子目录的 contents |
| **network reset** | curl 报 `Connection reset` | 加 `--connect-timeout 10` 并重试，网络波动正常 |
| **路径拼接** | 403 Forbidden | raw URL 路径要和 API 返回的 download_url 完全一致 |
| **目标目录不存在** | `No such file or directory` | 先 `mkdir -p` 再下载 |

## 适用范围

| 场景 | 能否用 |
|------|--------|
| GitHub 仓库的 Claude Code skill/plugin | ✅ 专门设计的 |
| 任意 GitHub 仓库的文件下载 | ✅ 同样适用 |
| 需要认证的私有仓库 | ❌ 需要 GitHub token |
| 超大文件（>100MB） | ⚠️ curl 可能超时，需要分段下载 |
| Git LFS 文件 | ❌ 不支持 |

## 速记版

下次直接复制这段改参数：

```bash
# === 改这三个变量 ===
OWNER="decebals"
REPO="claude-code-java"
REPO_PATH=".claude/skills"        # 仓库内技能文件所在路径
DEST="C:/Users/shish/.claude/skills/my-skill"  # 本地目标路径

# === 查目录 ===
curl -s "https://api.github.com/repos/$OWNER/$REPO/contents/$REPO_PATH?ref=main" | grep '"name"'

# === 下载（把上面grep出的名字填入SKILLS） ===
BASE="https://raw.githubusercontent.com/$OWNER/$REPO/main/$REPO_PATH"
for skill in skill-a skill-b; do
  mkdir -p "$DEST/$skill"
  curl -sL --connect-timeout 10 -o "$DEST/$skill/SKILL.md" "$BASE/$skill/SKILL.md"
  echo "$skill: $(wc -c < "$DEST/$skill/SKILL.md") bytes"
done
```
