---
name: onecrawler
description: Crawl Chinese social media (XHS, Douyin, Bilibili, Weibo, Kuaishou, Zhihu, Tieba). Submit crawl tasks, check progress, retrieve results via REST API.
---

# OneCrawler

OneCrawler is a local web service for crawling Chinese social media platforms.
All commands use the `onecrawler` CLI. Set `ONECRAWLER_BASE` env var to override
the default URL (`http://localhost:8080`).

## CLI Setup

Before running any commands, ensure the CLI is available:

```bash
# Try PATH first
if ! command -v onecrawler &>/dev/null; then
  # Try bundled copy alongside skills
  for cli in "${CODEX_HOME:-$HOME/.codex}/skills/cli/onecrawler" \
             "$HOME/.claude/skills/cli/onecrawler" \
             "bin/onecrawler"; do
    if [ -f "$cli" ]; then
      alias onecrawler="bash $cli"
      echo "Using bundled CLI: $cli"
      break
    fi
  done
fi

# Verify
command -v onecrawler &>/dev/null || echo "NOT_FOUND — install: bash install.sh"
```

## Verify Service

```bash
onecrawler health
```

## Supported Platforms

| Value | Platform |
|-------|----------|
| `xhs` | Xiaohongshu (小红书) |
| `dy` | Douyin (抖音) |
| `ks` | Kuaishou (快手) |
| `bili` | Bilibili (B站) |
| `wb` | Weibo (微博) |
| `tieba` | Baidu Tieba (贴吧) |
| `zhihu` | Zhihu (知乎) |

## Submit a Crawl Task

```bash
onecrawler task submit search --platform xhs --keywords "KEYWORD1,KEYWORD2" --max-notes 20
onecrawler task submit detail --platform xhs --ids "POST_ID_OR_URL" --max-comments 50
onecrawler task submit creator --platform xhs --ids "creator_id" --max-notes 20
```
Returns: `Task submitted: <task_id>`

Use `--no-comments` to skip comment fetching. Use `--save-option json` or `--save-option jsonl`.

## Check Task Status

```bash
onecrawler task status <task_id>

# Or poll until completion:
onecrawler task wait <task_id> --max-polls 5 --interval 5
```

## Get Results

```bash
onecrawler task result <task_id>
onecrawler task list
```

## Account Management

QR code login (remote-friendly — user scans with phone app):

```bash
onecrawler account login --platform xhs
```

This prints a QR code markdown image. Tell the user: "Scan this with your app."

Skip wait:

```bash
onecrawler account login --platform xhs --no-wait
```

Other operations:

```bash
onecrawler account list
onecrawler account list --platform xhs
onecrawler account health <account_id>
```

## Diagnostics

Before polling a pending task, check accounts first:

```bash
onecrawler account list --platform xhs
```

- "No accounts" → `onecrawler account login --platform xhs`
- Poll 2-3 times; if still pending, diagnose rather than polling more

## Query Data

```bash
onecrawler data posts --platform xhs --keyword "美食" --page 1 --page-size 20
onecrawler data comments --platform xhs --note-id "abc123" --page 1 --page-size 20
```

Add `--json` for raw output.
