#!/usr/bin/env python3
"""Restore issue-#1 oldsite.com URLs in db-seed/broken-state.sql.

The seed dump was accidentally captured after a dry-run search-replace.
This script puts visible content/menus/widgets back to oldsite.com while
keeping wp_options siteurl/home on newsite.com (the junior's only fix).
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SEED = ROOT / "db-seed" / "broken-state.sql"


def main() -> None:
    sql = SEED.read_text()
    before = sql.count("oldsite.com")

    # Keep siteurl/home on newsite.com.
    protected: list[str] = []

    def protect(match: re.Match[str]) -> str:
        protected.append(match.group(0))
        return f"__PROTECT_{len(protected) - 1}__"

    sql = re.sub(
        r"\(\d+,'(?:siteurl|home)','https://newsite\.com','(?:yes|no)'\)",
        protect,
        sql,
    )

    chunks = sql.split("INSERT INTO")
    fixed: list[str] = []
    for chunk in chunks[1:]:
        table = chunk.split("VALUES", 1)[0]
        if "`wp_posts`" in table or "`wp_postmeta`" in table:
            chunk = chunk.replace("https://newsite.com", "https://oldsite.com")
            if "`wp_postmeta`" in table:
                chunk = chunk.replace(
                    "https://oldsite.com/wp-content/uploads/2023/06/summer-hero",
                    "http://oldsite.com/wp-content/uploads/2023/06/summer-hero",
                )
                chunk = chunk.replace(
                    "https://oldsite.com/wp-content/uploads/2023/06/g",
                    "http://oldsite.com/wp-content/uploads/2023/06/g",
                )
                chunk = chunk.replace(
                    "https://oldsite.com/wp-content/uploads/2023/01/logo",
                    "http://oldsite.com/wp-content/uploads/2023/01/logo",
                )
                chunk = chunk.replace(
                    "https://oldsite.com/shop/summer/",
                    "http://oldsite.com/shop/summer/",
                )
        fixed.append(chunk)

    sql = "INSERT INTO" + "INSERT INTO".join(fixed)

    # Widget option: serialized http://oldsite.com links.
    sql = re.sub(
        r"('widget_text',')(.*?)('\))",
        lambda m: m.group(1)
        + m.group(2)
        .replace("https://newsite.com", "http://oldsite.com")
        .replace("https://oldsite.com", "http://oldsite.com")
        + m.group(3),
        sql,
        count=1,
        flags=re.S,
    )

    for i, value in enumerate(protected):
        sql = sql.replace(f"__PROTECT_{i}__", value)

    SEED.write_text(sql)
    after = sql.count("oldsite.com")
    print(f"Patched {SEED}")
    print(f"  oldsite.com: {before} -> {after}")
    print(f"  menu blog oldsite: {'oldsite.com/blog/' in sql}")
    print(f"  siteurl still newsite: {\"('siteurl','https://newsite.com'\" in sql or \"siteurl','https://newsite.com\" in sql}")


if __name__ == "__main__":
    main()
