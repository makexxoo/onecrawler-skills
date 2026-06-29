---
name: onecrawler-account-login
description: Login a OneCrawler platform account via browser cookie extraction or QR code scan.
---

Trigger login for a platform:

```bash
onecrawler account login xhs
```

The server first tries to extract cookies from the browser. If the browser is already logged in, it outputs "Already logged in — cookies extracted from browser" — no scan needed.

Otherwise it returns a QR code (base64 image or a URL). Tell the user to open the URL, scan with the platform app, and the server will detect login automatically.

**Force re-login** (skip browser cookie extraction, always show QR):

```bash
onecrawler account login xhs --force
```
