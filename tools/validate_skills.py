#!/usr/bin/env python3
"""Offline, dependency-free structural validation for local Agent Skills."""
from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys

FRONTMATTER = re.compile(r"\A---\r?\n(.*?)\r?\n---\r?\n(.*)", re.DOTALL)
NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def validate_skill(folder: Path) -> list[str]:
    """Return problems found in one skill folder; never execute skill content."""
    problems: list[str] = []
    manifest = folder / "SKILL.md"
    if not manifest.is_file() or manifest.is_symlink():
        return [f"{folder.name}: missing or symlinked SKILL.md"]
    try:
        raw = manifest.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as exc:
        return [f"{folder.name}: cannot read manifest: {exc}"]
    found = FRONTMATTER.match(raw)
    if not found:
        return [f"{folder.name}: missing YAML frontmatter"]
    header, body = found.groups()
    fields: dict[str, str] = {}
    for line in header.splitlines():
        if ":" in line and not line.lstrip().startswith("#"):
            key, value = line.split(":", 1)
            fields[key.strip()] = value.strip().strip('"').strip("'")
    name = fields.get("name", "")
    if not NAME.fullmatch(name):
        problems.append(f"{folder.name}: invalid skill name")
    if name != folder.name:
        problems.append(f"{folder.name}: frontmatter name mismatches directory")
    if len(fields.get("description", "")) < 20:
        problems.append(f"{folder.name}: description should explain when to invoke")
    if len(body.strip()) < 120:
        problems.append(f"{folder.name}: instructions are too short")
    return problems


def validate_skills(root: Path) -> list[str]:
    """Validate immediate child skill directories."""
    if not root.is_dir():
        return [f"skills directory not found: {root}"]
    directories = sorted(p for p in root.iterdir() if p.is_dir() and not p.is_symlink())
    if not directories:
        return ["no skill directories found"]
    problems: list[str] = []
    for directory in directories:
        problems.extend(validate_skill(directory))
    return problems


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", type=Path, default=Path("skills"))
    args = parser.parse_args()
    problems = validate_skills(args.root)
    if problems:
        for problem in problems:
            print(f"ERROR: {problem}", file=sys.stderr)
        return 1
    print("OK: skill manifests have valid basic structure.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
