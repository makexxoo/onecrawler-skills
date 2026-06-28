---
name: onecrawler-data-posts
description: Query crawled post/video data from OneCrawler with filters for platform, keyword, date range, and pagination.
---

```bash
onecrawler data posts --platform xhs --page 1 --page-size 20
```

## Parameters

| Param | Description |
|-------|-------------|
| `--platform` | xhs, dy, ks, bili, wb, tieba, zhihu |
| `--keyword` | Filter by title/desc/content match |
| `--date-from` / `--date-to` | Date range (YYYY-MM-DD) |
| `--page` / `--page-size` | Pagination (default 1/20, max 200) |
| `--sort` | `time` (default), `likes`, `comments` |
| `--order` | `desc` (default), `asc` |

Add `--json` for raw JSON output.
