#!/usr/bin/env python3
"""Conservative offline scanner for common credential formats and risky filenames.

This is NOT a substitute for secret scanning of Git history or mature tooling.
Never print matched values, only path/line and the type of finding.
"""
from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys

SKIP_DIRS = frozenset({".git", ".venv", "venv", "__pycache__", "node_modules", "dist", "build", ".pytest_cache"})
TEXT_EXTS = frozenset({".py", ".ps1", ".md", ".json", ".yaml", ".yml", ".txt", ".toml", ".ini", ".cfg", ".example", ".gitignore", ".gitattributes"})
RISKY_NAMES = frozenset({".env", "mcp.json", "mcp.local.json", "id_rsa", "id_ed25519", "auth.json"})
PATTERNS = (
    ("GitHub access token", re.compile(r"(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,})")),
    ("Google API key", re.compile(r"AIza[0-9A-Za-z_-]{35}")),
    ("OpenAI-like API key", re.compile(r"sk-(?:proj-)?[A-Za-z0-9_-]{25,}")),
    ("Private key header", re.compile(r"-----BEGIN (?:RSA |EC |DSA |OPENSSH |ENCRYPTED )?PRIVATE KEY-----")),
    ("Credential assignment", re.compile(
        r"""(?i)\b(?:api[_-]?key|access[_-]?token|client[_-]?secret|password)\s*[:=]\s*["']?([^\s"'#,]{12,})"""
    )),
)
PLACEHOLDERS = ("REPLACE", "EXAMPLE", "PLACEHOLDER", "YOUR_", "DUMMY_", "CHANGEME", "<", "$", "%")


def scan_text(text: str, source: str) -> list[str]:
    findings: list[str] = []
    for line_number, line in enumerate(text.splitlines(), 1):
        for name, pattern in PATTERNS:
            match = pattern.search(line)
            if not match:
                continue
            value = match.group(1) if match.lastindex else match.group(0)
            if name == "Credential assignment" and value.upper().startswith(PLACEHOLDERS):
                continue
            findings.append(f"{source}:{line_number}: {name}")
    return findings


def scan_path(root: Path) -> list[str]:
    if not root.exists():
        return [f"path does not exist: {root}"]
    findings: list[str] = []
    paths = [root] if root.is_file() else root.rglob("*")
    for path in paths:
        if path.is_symlink() or not path.is_file() or any(part in SKIP_DIRS for part in path.parts):
            continue
        relative = str(path.relative_to(root)) if root.is_dir() else path.name
        if path.name.lower() in RISKY_NAMES:
            findings.append(f"{relative}: risky filename")
        if path.suffix.lower() not in TEXT_EXTS and path.name not in {".gitignore", ".gitattributes"}:
            continue
        try:
            if path.stat().st_size > 2_000_000:
                continue
            content = path.read_text(encoding="utf-8")
        except (OSError, UnicodeError):
            continue
        findings.extend(scan_text(content, relative))
    return findings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", default=".", type=Path)
    args = parser.parse_args()
    findings = scan_path(args.root)
    if findings:
        for finding in findings:
            print("POTENTIAL SECRET: " + finding, file=sys.stderr)
        return 1
    print("OK: no matches for bundled secret patterns. Manual review still required.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
