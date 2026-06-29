---
name: onecrawler-crawl-post
description: Submit a post/video crawl task (search by keyword, specific IDs, or creator) on a Chinese social media platform via OneCrawler.
---

```bash
onecrawler task submit search --platform xhs --keywords "KEYWORDS" --max-notes 20
onecrawler task submit detail --platform xhs --ids "POST_ID_OR_URL" --max-comments 50
onecrawler task submit creator --platform xhs --ids "creator_id" --max-notes 20
```

Platform: xhs|dy|ks|bili|wb|tieba|zhihu.

Returns `Task submitted: <task_id>`. Use `onecrawler-task-status` skill to check progress.
