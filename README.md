# Northwind Coffee Co. — Staging

The Northwind Coffee Co. WordPress site, just after a migration to a new domain.
Your task is in **[`scenario-brief.md`](scenario-brief.md)** — read that first.

## Requirements

- **Docker Desktop** (Compose v2). On Windows, keep the default WSL2 backend.
- Ports **80** and **443** free (the site runs on the standard web ports). If
  another web server is using them, stop it first, or set `HTTP_PORT`/`HTTPS_PORT`
  in `.env`.

That's it — the TLS certificate is generated for you inside a container.

## 1. Start it

**macOS / Linux:**

```bash
./start.sh
```

**Windows (PowerShell):**

```powershell
.\start.ps1
```

First boot takes a minute (it pulls images and imports the database).

## 2. Add the hostname (one time)

**macOS / Linux:**

```bash
echo "127.0.0.1 newsite.com oldsite.com" | sudo tee -a /etc/hosts
```

**Windows (Administrator PowerShell):**

```powershell
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "127.0.0.1 newsite.com oldsite.com"
```

## 3. Open the site

**https://newsite.com**

It uses a self-signed certificate, so your browser will warn you. In Chrome/Edge,
click the page and type `thisisunsafe`. In Safari, choose *Show Details → visit
this website*.

**Admin:** https://newsite.com/wp-admin — user `admin`, password `admin_pass_change_me`

## Tools

- **Files:** `wp-content/` (themes, plugins, mu-plugins) is mounted from this
  folder, so edits here are live — just refresh. `nginx/newsite.conf` is mounted
  too (run `docker compose restart nginx` after changing it).
- **WP-CLI:** `docker compose exec wpcli wp <command>`
- **Database:** `docker compose exec db mysql -uwp_user -pwp_pass wordpress`

## Stop / reset

```bash
./stop.sh                 # stop (your changes are kept).  Windows: .\stop.ps1
docker compose down -v    # reset the database back to the original state
git restore wp-content    # discard your file edits (optional)
```
