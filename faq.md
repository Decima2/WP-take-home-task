# Candidate FAQ — Northwind Coffee Co. take-home

Common questions before and during the exercise. Your task brief is in
[`scenario-brief.md`](scenario-brief.md); setup steps are in [`README.md`](README.md).

---

## Before you start

### Which site am I fixing?

**`newsite.com` only.** `oldsite.com` is the working reference — use it to see
how the site should look and behave. Do not “fix” oldsite or treat it as the live
target.

### Is there a checklist of bugs?

No. Part of the task is deciding what “production-ready” means and being
thorough. Compare the two domains, test key flows, and fix what’s wrong.

### Can I use AI tools?

Yes — we use them too. Mention briefly in your notes where AI helped (e.g.
drafting nginx rules, grep across the codebase). You’re still responsible for
verifying every fix.

### How long should this take?

Most strong candidates spend **3–6 hours** on Part 1. Part 2 is separate prep
for the live demo. Submit notes and book your slot **within two weeks**.

---

## Setup & environment

### The site won’t load / I get “connection refused”.

1. Run `./start.sh` (or `.\start.ps1`) and wait for containers to finish starting.
2. Add both hostnames to your hosts file (see README §2).
3. Visit **https://newsite.com** (not localhost).

### I see a certificate warning.

Expected — it’s self-signed. Either run `./trust-cert.sh` (macOS) /
`.\trust-cert.ps1` (Windows, as Admin) and restart the browser, or bypass the
warning (Chrome/Edge: click the page, type `thisisunsafe`).

### Port 80 or 443 is already in use.

Stop the other service (common culprits: Apache, another Docker stack, local
nginx), or set `HTTP_PORT` / `HTTPS_PORT` in `.env` — but then you’ll need those
ports in the URL, which isn’t how the exercise is meant to run. **Freeing 80/443
is preferred.**

### I ran this before and the site looks already fixed.

Reset to the planted broken state:

```bash
docker compose down -v
./start.sh
```

### Do I need a `.env` file?

`start.sh` should create one from `.env.example`. If Compose warns about missing
variables, copy it manually: `cp .env.example .env`.

### Can I work on Windows?

Yes. Use PowerShell scripts (`start.ps1`, `trust-cert.ps1`, etc.) and the
Windows hosts-file command in the README.

---

## Part 1 — What to fix & how deep to go

### The junior already updated `siteurl` and `home`. Is that enough?

No — that’s the starting point of the scenario, not the finish line. Real
migrations leave URLs, assets, email, redirects, and config issues elsewhere.

### Should I redesign or add features?

No. Match `oldsite.com` functionally. If it works on oldsite and is broken on
newsite, fix it. If it’s the same on both (including shared quirks), leave it.

### Do I need to fix things on oldsite.com?

No. Oldsite is intentionally the “good” reference. Your deliverable is a
production-ready newsite.

### How do I know when I’m done?

A reasonable bar:

- Side-by-side check: Home, About, Contact, Blog, Shop (desktop and mobile)
- No links or assets still pointing at `oldsite.com` on newsite
- HTTPS enforced; no mixed-content warnings in DevTools
- Legacy URLs you’d expect to work (e.g. old `/blog/...` paths) handled
  appropriately
- Contact form email actually received (see below)
- Short **production recommendations** section in your notes (see scenario-brief)

You don’t need a perfect production runbook — tie recommendations to what you
found.

### The contact form says “sent” but I’m not sure email works.

A browser success message is not enough. Outbound mail is captured locally:

- **Inbox UI:** http://localhost:8025 (Mailpit; port is in `.env` as
  `MAILPIT_PORT`)
- Submit the form on **newsite.com/contact**, then confirm the message appears
  there

### Can I install plugins?

You can, but you don’t need to. You have WP-CLI, DB, filesystem, and nginx. Use
whatever you’d normally use in a real migration — just be ready to explain your
choices in the interview.

### I changed nginx config but nothing happened.

Restart nginx: `docker compose restart nginx`.

### I changed files under `wp-content/` but nothing changed.

That folder is mounted live — a browser refresh is usually enough. If you edited
the DB, flush cache:

```bash
docker compose exec wpcli wp cache flush
```

### What if something needs DNS or real hosting I don’t control here?

Describe exactly what you’d do in production and why. That counts — especially
for TLS, SMTP, and edge redirects.

---

## Part 1 notes — what to send

### What format?

Plain email is fine. For each issue: **problem → how you diagnosed → fix → how
you verified**. Add a final **Production recommendations** section (client +
Decima2 hosting), tied to your audit.

### Do I send code or a PR?

No PR required. Send notes only. Keep the environment running — you’ll demo fixes
live on the site in the interview.

### How polished should the notes be?

Clear and honest beats polished. We’re assessing how you think, not your template
design.

---

## Part 2 — AI & automation demo

### Do I send Part 2 code beforehand?

No. Demo it live in the interview.

### Is a search-replace script enough?

No. We want something that shows real leverage — reusable across migrations, not
a one-liner hardcoded to this site.

### I already have a relevant tool. Can I use Option B?

Yes — show something you’ve built that uses AI/automation for WordPress, web
ops, or similar. Be ready to explain architecture and what you’d do next.

### Do I need to build Part 2 before the interview?

Yes — come with something working (or a clear demo path). You won’t have time to
build from scratch in the 60 minutes.

---

## Interview day

### What happens in the 60 minutes?

1. Live walkthrough of Part 1 fixes (on your running environment)
2. Part 2 demo
3. Further technical questions (we’ll send more detail after you book)

### What if my laptop/docker isn’t working on the day?

Contact us as soon as possible. Ideally have a backup (screenshots, notes,
recorded walkthrough) — but a working local stack is strongly preferred.

### Can I use my notes during the walkthrough?

Absolutely — they’re your notes. We want to hear you explain what you found, not
read slides verbatim.

---

## Quick reference

| Item | Value |
|------|-------|
| Site to fix | https://newsite.com |
| Reference | https://oldsite.com |
| Admin | https://newsite.com/wp-admin |
| Login | `admin` / `admin_pass_change_me` |
| WP-CLI | `docker compose exec wpcli wp <command>` |
| Mail inbox | http://localhost:8025 |
| Book interview | https://calendly.com/torty-sivill9/30min |
