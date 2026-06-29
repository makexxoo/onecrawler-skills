---
name: onecrawler-account-list
description: Manage OneCrawler platform accounts — list, check health, and trigger browser login.
---

## List

```bash
onecrawler account list xhs
```

If output shows no healthy accounts, trigger login:

```bash
onecrawler account login xhs
```

The server first tries to extract cookies from the browser. If the browser is already logged in, it outputs "Already logged in" — no scan needed.
Otherwise it returns a QR code (base64 image or a URL). Tell the user to open the URL, scan with the platform app, and the server will detect login automatically.

## Health

```bash
onecrawler account health <account_id>
```

## Login (force re-login)

```bash
onecrawler account login xhs --force
```
