# Staging Site Handover — Northwind Coffee Co.

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

## Your task

Treat this as a real client handover. Go through the site as a careful developer
would before sign-off, find whatever is wrong, and **fix everything needed to make
the site genuinely production-ready** on the new domain.

For each thing you change, we'd like a short note covering:

- what the problem was,
- how you diagnosed it,
- what you did to fix it, and
- how you verified the fix.

## Access

- See `README.md` to start the environment (Docker) and open the site.
- **Site:** `https://newsite.com`
- **WordPress admin:** `https://newsite.com/wp-admin`
  - user: `admin`  ·  password: `admin_pass_change_me`
- You have full access to the database, the file system, and WP-CLI
  (`docker compose exec wpcli wp <command>`).

## Notes

- There is no checklist and no stated number of issues. Part of the exercise is
  deciding what "production-ready" means and being thorough.
- The old domain (`oldsite.com`) may still resolve while DNS propagates. If you
  need to compare content against the previous site, it is reachable at the same
  URL paths.
- Check the site on mobile as well as desktop before sign-off.
- Work in whatever order makes sense to you. You may use any standard tools,
  plugins, or WP-CLI commands you would normally reach for.
- If you make a change that needs hosting/DNS/server configuration we haven't
  given you direct control over, describe precisely what you would do and why.

Good luck — we're interested in both the fixes and your reasoning.
