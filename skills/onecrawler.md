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
Returns: `Task submitted: <task_id>`. After submitting, tell the user to check progress with `onecrawler-task-status`.

Use `--no-comments` to skip comment fetching. Use `--save-option json` or `--save-option jsonl`.

## Check Task Status

```bash
onecrawler task status <task_id>
```

Key fields: `status` (pending|running|completed|failed|paused), `progress.total_notes_fetched`, `progress.current_page`.

## Get Results

```bash
onecrawler task result <task_id>
onecrawler task list
```

## Account Management

```bash
onecrawler account list xhs
onecrawler account health <account_id>
```

**Login:** The server first tries to extract cookies from the browser.
If already logged in, it outputs "Already logged in — cookies extracted from browser" — no scan needed.
Otherwise it returns a QR code (base64 image or URL):

```bash
onecrawler account login xhs
```

Tell the user: open the URL, scan with the platform app, and the server will auto-detect login.

Force re-login (skip browser cookie extraction):

```bash
onecrawler account login xhs --force
```

## Diagnostics

If a task stays `pending` too long, check accounts:

```bash
onecrawler account list xhs
```

- No healthy accounts → use `onecrawler-account-login` skill.

## Query Data

Export crawled data from completed tasks. Never pipe raw data to the model.

```bash
# Posts (Excel)
onecrawler data export <task_id> posts xlsx

# Comments (Excel)
onecrawler data export <task_id> comments xlsx

# Also supports fmt=csv and fmt=json
```

Output defaults to `$HOME/Downloads/`, falls back to `$PWD`. Override with `ONECRAWLER_OUTDIR`.
Tell the user the file path.
