# github-skill-downloader

免 git clone 安装 GitHub 技能。当公司网络封了 Git 协议时，用 GitHub API + curl 逐文件下载安装。

## 安装

```bash
cp SKILL.md ~/.claude/skills/github-skill-downloader/
```

## 使用

在 Claude Code 中说：

> "从 GitHub 下载 xxx"
> "安装 xxx 技能"
> "clone 替代方案"
> "github 下载 xxx"

Agent 自动：
1. 用 GitHub API 查仓库目录结构
2. 提取所有文件的 `download_url`
3. 用 curl 逐文件下载到 `~/.claude/skills/`

## 适用场景

- 公司网络封了 Git 协议（`git clone` 报 Connection reset）
- SSH 端口被封
- 企业 VPN 限制

## License

MIT
