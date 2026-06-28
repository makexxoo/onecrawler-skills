---
name: onecrawler-account-list
description: Manage OneCrawler platform accounts — list, check health, and trigger browser login.
---

## List

```bash
onecrawler account list --platform xhs
```

If output shows "No accounts", trigger login:

```bash
onecrawler account login --platform xhs
```

This prints a QR code markdown image — tell the user to scan it with the platform app.

## Health

```bash
onecrawler account health <account_id>
```

## Login without waiting

```bash
onecrawler account login --platform xhs --no-wait
```
