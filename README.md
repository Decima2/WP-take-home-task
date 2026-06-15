# Northwind Coffee Co. — Staging

The Northwind Coffee Co. WordPress site, just after a migration to a new domain.
Your task is in **[`scenario-brief.md`](scenario-brief.md)** — read that first.

## Requirements

- **Docker Desktop** (Compose v2). On Windows, keep the default WSL2 backend.

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

**https://newsite.com:8443**

It uses a self-signed certificate, so your browser will warn you. In Chrome/Edge,
click the page and type `thisisunsafe`. In Safari, choose *Show Details → visit
this website*.

**Admin:** https://newsite.com:8443/wp-admin — user `admin`, password `admin_pass_change_me`

## Tools

- **WP-CLI:** `docker compose exec wpcli wp <command>`
- **Database:** `docker compose exec db mysql -uwp_user -pwp_pass wordpress`

## Stop / reset

```bash
./stop.sh          # stop (your changes are kept).  Windows: .\stop.ps1

# Full reset to the original state:
docker compose down -v   # then run start again
```
