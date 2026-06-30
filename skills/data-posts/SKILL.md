---
name: onecrawler-data-posts
description: Export crawled post/video data from a completed OneCrawler task to Excel/CSV/JSON.
---

Export posts from a completed task:

```bash
onecrawler data export <task_id> posts xlsx
```

Formats: `xlsx` (default), `csv`, `json`.

Output lands in `$HOME/Downloads/` by default, or current working directory if Downloads is unavailable. Override with `ONECRAWLER_OUTDIR`.

**IMPORTANT:** Always use `data export` — never pipe raw JSON to the model. Tell the user the output file path.
