#!/usr/bin/env python3
"""Ensure CF7 _mail meta in db-seed/broken-state.sql is valid and addressed correctly."""

from pathlib import Path

RECIPIENT = "torty.sivill@decima2.co.uk"
RECIPIENT_LEN = len(RECIPIENT)

SERIALIZED = (
    'a:8:{s:7:"subject";s:30:"[_site_title] "[your-subject]"";'
    's:6:"sender";s:31:"[_site_title] <ops@newsite.com>";'
    's:4:"body";s:191:"From: [your-name] [your-email]\\nSubject: [your-subject]\\n\\n'
    'Message Body:\\n[your-message]\\n\\n-- \\n'
    'This is a notification that a contact form was submitted on your website '
    '([_site_title] [_site_url]).";'
    f's:9:"recipient";s:{RECIPIENT_LEN}:"{RECIPIENT}";'
    's:18:"additional_headers";s:22:"Reply-To: [your-email]";'
    's:11:"attachments";s:0:"";s:8:"use_html";i:0;s:13:"exclude_blank";i:0;}'
)

ROOT = Path(__file__).resolve().parents[1]


def patch(path: Path) -> None:
    text = path.read_text()

    if f's:{RECIPIENT_LEN}:"{RECIPIENT}"' in text:
        print(f"Already has recipient: {path}")
        return

    if "recipient: orders@newsite.com" in text:
        text = text.replace("recipient: orders@newsite.com", SERIALIZED, 1)
    elif 's:18:"orders@newsite.com"' in text:
        text = text.replace(
            's:18:"orders@newsite.com"',
            f's:{RECIPIENT_LEN}:"{RECIPIENT}"',
            1,
        )
    else:
        raise SystemExit(f"{path}: no known CF7 recipient to patch")

    path.write_text(text)
    print(f"Patched {path}")


if __name__ == "__main__":
    patch(ROOT / "db-seed" / "broken-state.sql")
    test_run = ROOT.parent / "_test-run" / "db-seed" / "broken-state.sql"
    if test_run.exists():
        patch(test_run)
