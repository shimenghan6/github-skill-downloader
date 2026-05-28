# github-skill-downloader

> Git 被封、SSH 被拦、`git clone` 永远 Connection Reset？这个工具绕过一切——GitHub API 读目录，curl 逐文件下载，一个文件都不漏。

**企业防火墙？公司代理？统统挡不住。有网就能装 GitHub 上的任何技能。**

### 谁需要这个

| 你 | 为什么你需要 |
|----|------------|
| 公司网络封了 Git/SSH 协议 | API 和 raw 通常不封，绕过限制 |
| `git clone` 一直失败 | curl 逐文件下载，不走 git 协议 |
| 只想下载 GitHub 项目中某几个文件 | 按需下载，不拉整个仓库 |

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
