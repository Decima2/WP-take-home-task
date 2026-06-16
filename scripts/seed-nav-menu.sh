#!/usr/bin/env bash
# Ensure the Primary menu lists every public page (About, Shop, Seasonal, etc.).
# Idempotent — safe to run on every ./start.sh.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

wp() { docker compose exec -T wpcli wp "$@"; }

wp core is-installed >/dev/null 2>&1 || exit 0

HOME_ID=$(wp post list --post_type=page --name=home --field=ID --posts_per_page=1)
ABOUT_ID=$(wp post list --post_type=page --name=about --field=ID --posts_per_page=1)
SHOP_ID=$(wp post list --post_type=page --name=shop --field=ID --posts_per_page=1)
SEASONAL_ID=$(wp post list --post_type=page --name=seasonal --field=ID --posts_per_page=1)
LANDING_ID=$(wp post list --post_type=page --name=summer-specials --field=ID --posts_per_page=1)
CONTACT_ID=$(wp post list --post_type=page --name=contact --field=ID --posts_per_page=1)

for id in "$HOME_ID" "$ABOUT_ID" "$SHOP_ID" "$SEASONAL_ID" "$LANDING_ID" "$CONTACT_ID"; do
  [ -n "$id" ] || { echo "seed-nav-menu: missing page (run after DB import)" >&2; exit 0; }
done

wp menu create "Primary" >/dev/null 2>&1 || true
wp menu location assign primary primary >/dev/null 2>&1 || true

# Rebuild from scratch so order stays predictable.
IDS=$(wp post list --post_type=nav_menu_item --field=ID --format=csv 2>/dev/null || true)
if [ -n "$IDS" ]; then
  wp post delete $IDS --force >/dev/null
fi

OLD_URL="https://oldsite.com"

wp menu item add-post primary "$HOME_ID"    >/dev/null
wp menu item add-post primary "$ABOUT_ID"   >/dev/null
wp menu item add-custom primary "Shop" "${OLD_URL}/shop/" >/dev/null
wp menu item add-post primary "$SEASONAL_ID" >/dev/null
wp menu item add-custom primary "Blog" "${OLD_URL}/blog/" >/dev/null
wp menu item add-post primary "$LANDING_ID"  >/dev/null
wp menu item add-post primary "$CONTACT_ID"  >/dev/null

echo "==> Primary menu: Home, About, Shop, Seasonal, Blog, Summer Specials, Contact"
