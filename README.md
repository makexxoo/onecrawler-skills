# OneCrawler Skills

AI agent skills for the OneCrawler REST API — crawl Chinese social media platforms (小红书、抖音、B站、微博、快手、知乎、贴吧) via natural language.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/makexxoo/onecrawler-skills/main/install.sh | bash
```

Installs skills for Codex + Claude Code, plus the `onecrawler` CLI to `~/.local/bin/`.

```bash
curl -fsSL https://raw.githubusercontent.com/makexxoo/onecrawler-skills/main/install.sh | bash -s -- --codex     # Codex only
curl -fsSL https://raw.githubusercontent.com/makexxoo/onecrawler-skills/main/install.sh | bash -s -- --claude    # Claude only
curl -fsSL https://raw.githubusercontent.com/makexxoo/onecrawler-skills/main/install.sh | bash -s -- --cli-only  # CLI only
```

## Copy-Paste AI Prompt

**Paste this into any AI agent to let it install everything automatically:**

```
Install the OneCrawler skills:
1. curl -fsSL https://raw.githubusercontent.com/makexxoo/onecrawler-skills/main/install.sh | bash
2. Verify: ~/.local/bin/onecrawler health
3. Set ONECRAWLER_BASE if your OneCrawler service runs on a non-default host.
```

## Repo Structure

```
onecrawler-skills/
├── bin/onecrawler          # Shell CLI (bash + curl, zero deps)
├── install.sh              # One-command installer
├── README.md
└── skills/
    ├── onecrawler.md       # Root skill — setup, platforms, diagnostics
    ├── account-list/       # Account management
    ├── crawl-comments/     # Fetch comments
    ├── crawl-post/         # Submit crawl tasks
    ├── data-comments/      # Query comment data
    ├── data-posts/         # Query post data
    ├── task-list/          # List all tasks
    ├── task-result/        # Get task results
    └── task-status/        # Check task progress
```

## Skills Included

| Skill | Description |
|-------|-------------|
| `onecrawler` | Root — platform list, CLI bootstrap, diagnostics |
| `onecrawler-account-list` | List accounts, check health, QR login |
| `onecrawler-crawl-post` | Submit crawl tasks (search, detail, creator) |
| `onecrawler-crawl-comments` | Fetch comments for specific posts |
| `onecrawler-data-posts` | Query crawled posts with filters |
| `onecrawler-data-comments` | Query crawled comments with filters |
| `onecrawler-task-list` | List all tasks |
| `onecrawler-task-status` | Check progress + poll until complete |
| `onecrawler-task-result` | Get completed task results |

## CLI Reference

```bash
onecrawler health

# Submit tasks
onecrawler task submit search --platform xhs --keywords "美食" --max-notes 20
onecrawler task submit detail --platform xhs --ids "abc123" --max-comments 50
onecrawler task submit creator --platform xhs --ids "creator_id" --max-notes 20

# Task management
onecrawler task status <task_id>
onecrawler task wait <task_id> 10 5    # 10 polls, 5s interval
onecrawler task result <task_id>
onecrawler task list

# Accounts
onecrawler account list xhs
onecrawler account health <account_id>
onecrawler account login xhs

# Query data
onecrawler data posts --platform xhs --keyword "美食" --page 1
onecrawler data comments --platform xhs --note-id "abc123" --page 1
```

Add `--json` to any command for raw output.

## Configuration

```bash
export ONECRAWLER_BASE=http://your-server:8080   # default: http://localhost:8080
```

## Supported Platforms

| `xhs` | 小红书 | `dy` | 抖音 | `ks` | 快手 |
| `bili` | B站 | `wb` | 微博 | `tieba` | 百度贴吧 |
| `zhihu` | 知乎 |
