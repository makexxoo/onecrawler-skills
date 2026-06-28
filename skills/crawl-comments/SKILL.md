---
name: onecrawler-crawl-comments
description: Fetch comments for specific posts on a Chinese social media platform via OneCrawler.
---

Crawl comments for specific posts. Uses detail mode — fetches post data AND comments.

```bash
onecrawler task submit detail --platform xhs --ids "POST_ID_OR_URL" --max-comments 50
```

`--ids` accepts raw IDs, full URLs, or comma-separated list.

Returns `Task submitted: <task_id>`.
