---
name: onecrawler-data-comments
description: Export crawled comment data from a completed OneCrawler task to Excel/CSV/JSON.
---

Export comments from a completed task:

```bash
onecrawler data export <task_id> comments xlsx
```

Formats: `xlsx` (default), `csv`, `json`.

Output lands in `$HOME/Downloads/` by default, or current working directory if Downloads is unavailable. Override with `ONECRAWLER_OUTDIR`.

**IMPORTANT:** Always use `data export` — never pipe raw JSON to the model. Tell the user the output file path.
