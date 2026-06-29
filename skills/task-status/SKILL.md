---
name: onecrawler-task-status
description: Check the status and progress of a OneCrawler crawl task.
---

Check task progress. Poll at most 3 times.

```bash
onecrawler task status <task_id>
```

Key fields: `status` (pending|running|completed|failed|paused), `progress.total_notes_fetched`, `progress.current_page`.

Or wait until completion:

```bash
onecrawler task wait <task_id> 3 5
```

(max 3 polls, 5 seconds interval, defaults to 10 polls / 5s)

If task stays `pending` too long, check accounts:

```bash
onecrawler account list xhs
```

If no healthy accounts, use `account-list` skill to trigger login.
