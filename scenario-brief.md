# Scenario Brief — Northwind Coffee Co.

Common questions: **[`faq.md`](faq.md)**.

## Background

We recently moved the **Northwind Coffee Co.** WordPress website to a new domain
and host.

- **Old domain:** `oldsite.com`
- **New domain:** `newsite.com`

A junior developer carried out the migration. Here is exactly what they told us
they did, in their own words:

> "I exported the database from the old host and imported it on the new server.
> I updated the `siteurl` and `home` values in `wp_options` to the new domain,
> and I pointed the domain at the new host. That's everything."

The site is now running on the staging environment at **`https://newsite.com`**,
and on the surface it loads. However, we are not confident the migration is
actually complete or production-ready.

---

## Part 1 — Migration audit & fix

Treat this as a real client handover. Go through the site as a careful developer
would before sign-off, find whatever is wrong, and **fix everything needed to make
the site genuinely production-ready** on the new domain.

**Important:** `oldsite.com` is your reference — it is the working version of
the site as the client expects it to look and behave. Your goal is to make
`newsite.com` match it functionally. We are not asking you to improve the design,
add features, or change anything that isn't broken. If it works correctly on
`oldsite.com`, it should work the same way on `newsite.com`.

For each issue you find and fix, please keep a short note covering:

- what the problem was
- how you diagnosed it
- what you did to fix it
- how you verified the fix

Check the site on both desktop and mobile before sign-off. Test the **Contact**
page and confirm submissions are genuinely delivered — a success message in the
browser is not sufficient evidence.

There is no checklist and no stated number of issues. Part of the exercise is
deciding what "production-ready" means and being thorough.

### Production recommendations (Part 1 extension)

This environment is a **local staging stack** — not how we would run the site in
production. Once you have fixed what you can here, add a short section to your
Part 1 notes (and be ready to talk through it in the interview):

**If Decima2 were hosting this site for the client in production, what would you
recommend?**

Think about what still differs between this Docker setup and a real managed
hosting deployment — for the **client** (Northwind) and for **Decima2** as the
host. For example: TLS, email delivery, DNS and redirects, backups and recovery,
security hardening, monitoring, staging vs production workflow, performance, and
ongoing maintenance — but don't limit yourself to that list.

We are not looking for a generic essay. Tie your recommendations to what you
found during the audit and what you could not fully implement in this local
environment. If you made a change here that would be done differently in
production, say so.

---

## Part 2 — AI & automation

We're an AI company, and we expect the people we hire to be actively using AI
and automation tools in their work — not occasionally, but as a core part of how
they operate.

This part of the task is your chance to show us that.

Pick one of the following:

### Option A — Build something for this task

Identify the most painful or repetitive part of what you just did in Part 1 and
use AI and/or automation to make it faster, more reliable, or scalable. This
could be a script, a tool, a workflow — whatever makes sense. It should be
reusable across future migrations, not hardcoded to this site.

### Option B — Show us something you've already built

If you have an existing script, tool, or automated workflow that uses AI —
relevant to WordPress, web engineering, or technical operations — you can demo
that instead.

Either way, we're looking for something that genuinely impresses us. A basic
search-replace script won't cut it here. We want to see creative thinking about
where AI and automation add real leverage.

You'll demo this live in the interview — **don't send us the code in advance**.
Come ready to walk us through what it does, why you built it this way, and what
you'd do next with more time.

---

## Access

- **Site:** `https://newsite.com`
- **WordPress admin:** `https://newsite.com/wp-admin`
  - user: `admin`  ·  password: `admin_pass_change_me`
- You have full access to the database, the file system, and WP-CLI
  (`docker compose exec wpcli wp <command>`)
- The old domain (`oldsite.com`) is reachable at the same URL paths and is your
  **working reference**

---

## Notes

- Work in whatever order makes sense to you
- You may use any standard tools, plugins, or WP-CLI commands you would normally
  reach for
- You are welcome to use AI tools throughout Part 1 as well — we use them
  ourselves. If you do, briefly mention where and how in your notes
- If you make a change that would normally require hosting or DNS configuration
  we haven't given you direct control over, describe precisely what you would do
  and why

---

## How to submit & what happens next

### Step 1 — Send us your Part 1 notes

When you've completed the audit and fixes, email us your notes — what you found,
how you diagnosed it, how you fixed it, and your **production recommendations**
for the client and Decima2. These don't need to be polished; clear and honest is
what matters. **Keep your local environment running** — at the interview you will
**demo your Part 1 fixes live** (walk us through the site and what you changed,
including what you would do differently in production). **Don't send your Part
2 work** — you'll demo that live too.

### Step 2 — Book your interview slot

Book your technical interview here:

**https://calendly.com/torty-sivill9/30min**

The interview will cover a **live walkthrough of your Part 1 fixes**, your
**Part 2 demo**, plus a further question section — we'll send you more detail
on that once you've booked in.

Good luck — we're interested in both what you find and how you think about it.
