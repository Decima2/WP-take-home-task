#!/usr/bin/env python3
"""Replace corrupted CF7 _mail meta in db-seed/broken-state.sql."""

from pathlib import Path

SERIALIZED = (
    'a:8:{s:7:"subject";s:30:"[_site_title] "[your-subject]"";'
    's:6:"sender";s:31:"[_site_title] <ops@newsite.com>";'
    's:4:"body";s:191:"From: [your-name] [your-email]\\nSubject: [your-subject]\\n\\n'
    'Message Body:\\n[your-message]\\n\\n-- \\n'
    'This is a notification that a contact form was submitted on your website '
    '([_site_title] [_site_url]).";'
    's:9:"recipient";s:18:"orders@newsite.com";'
    's:18:"additional_headers";s:22:"Reply-To: [your-email]";'
    's:11:"attachments";s:0:"";s:8:"use_html";i:0;s:13:"exclude_blank";i:0;}'
)

OLD = "recipient: orders@newsite.com"
ROOT = Path(__file__).resolve().parents[1]


def patch(path: Path) -> None:
    text = path.read_text()
    if OLD not in text:
        raise SystemExit(f"{path}: expected corrupted _mail value not found")
    path.write_text(text.replace(OLD, SERIALIZED, 1))
    print(f"Patched {path}")


if __name__ == "__main__":
    patch(ROOT / "db-seed" / "broken-state.sql")
    test_run = ROOT.parent / "_test-run" / "db-seed" / "broken-state.sql"
    if test_run.exists():
        patch(test_run)
