---
name: onecrawler-data-comments
description: Query crawled comment data from OneCrawler with filters for platform, note_id, keyword, date range, and pagination.
---

```bash
onecrawler data comments --platform xhs --page 1 --page-size 20
```

## Parameters

| Param | Description |
|-------|-------------|
| `--platform` | xhs, dy, ks, bili, wb, tieba, zhihu |
| `--note-id` | Filter comments for a specific post |
| `--keyword` | Filter by comment content match |
| `--date-from` / `--date-to` | Date range (YYYY-MM-DD) |
| `--page` / `--page-size` | Pagination (default 1/20, max 200) |

Add `--json` for raw JSON output.
