#!/usr/bin/env python3
"""Friendly wrapper around commit-check for the local pre-commit hooks.

commit-check performs the real validation, so local checks stay identical to
CI. Its native failure output, however, embeds ANSI colour codes and an
ASCII-art banner that GUI clients (Fork, GitHub Desktop, ...) render as raw
escape sequences. This wrapper runs commit-check, suppresses that output, and
on failure prints a single concise, plain-text explanation instead.

Allowed branch/commit types are read from .github/commit-check.toml -- the same
file commit-check and the CI action consume -- so they are defined in exactly
one place and never duplicated here.
"""
from __future__ import annotations

import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from textwrap import dedent

try:  # stdlib on Python 3.11+
    import tomllib
except ModuleNotFoundError:  # older interpreters use the regex fallback below
    tomllib = None

REPO_ROOT = Path(__file__).resolve().parents[2]
CONFIG_FILE = REPO_ROOT / ".github" / "commit-check.toml"
CONTRIBUTING = ".github/CONTRIBUTING.md"
COMMIT_CHECK_MISSING = 127


@dataclass(frozen=True)
class Check:
    """A single commit-check validation and how to explain a failure of it."""

    args: tuple[str, ...]  # arguments passed to commit-check
    section: str           # [section] in commit-check.toml
    key: str               # allow-list key within that section
    headline: str          # one-line summary of what failed
    syntax: str            # the expected format
    example: str           # a valid example


CHECKS = {
    "branch": Check(
        args=("--branch",),
        section="branch",
        key="allow_branch_types",
        headline="branch name does not follow Conventional Branch",
        syntax="<type>/<description>",
        example="feature/skip-button",
    ),
    "message": Check(
        args=("--message",),
        section="commit",
        key="allow_commit_types",
        headline="commit message does not follow Conventional Commits",
        syntax="<type>(<scope>): <description>   (scope optional)",
        example="feat(gameplay): add skip button",
    ),
}


def allowed_types(check: Check) -> str:
    """Return `check`'s allow-list from the TOML config as a spaced string."""
    try:
        text = CONFIG_FILE.read_text(encoding="utf-8")
    except OSError:
        return ""

    types: list[str] = []
    if tomllib is not None:
        try:
            types = tomllib.loads(text).get(check.section, {}).get(check.key, [])
        except (ValueError, AttributeError):
            types = []
    if not types:  # interpreter without tomllib, or a parse error
        match = re.search(
            rf"^\s*{check.key}\s*=\s*\[(.*?)\]", text, re.DOTALL | re.MULTILINE
        )
        types = re.findall(r'"([^"]+)"', match.group(1)) if match else []

    return "  ".join(types)


def offending_value(name: str, message_file: str) -> str:
    """The branch name or commit subject that triggered the failure."""
    if name == "branch":
        result = subprocess.run(
            ["git", "branch", "--show-current"], capture_output=True, text=True
        )
        return result.stdout.strip()
    try:
        return Path(message_file).read_text(encoding="utf-8").splitlines()[0]
    except (OSError, IndexError):
        return ""


def run_commit_check(args: tuple[str, ...]) -> int:
    """Run commit-check, discarding its output; return its exit code.

    Returns COMMIT_CHECK_MISSING when the executable is not on PATH.
    """
    try:
        completed = subprocess.run(
            ["commit-check", *args], capture_output=True, text=True
        )
        return completed.returncode
    except FileNotFoundError:
        return COMMIT_CHECK_MISSING


def report(check: Check, value: str) -> None:
    """Print one GUI-friendly, plain-text explanation of the failure."""
    print(dedent(f"""\
        Commit rejected: {check.headline}.
            received:       {value or "(none)"}
            expected:       {check.syntax}
            allowed types:  {allowed_types(check)}
            example:        {check.example}
            reference:      {CONTRIBUTING}
        """))


def main(argv: list[str]) -> int:
    name = argv[1] if len(argv) > 1 else ""
    check = CHECKS.get(name)
    if check is None:
        print(f"friendly_commit_check: unknown mode {name!r}", file=sys.stderr)
        return 2

    message_file = argv[2] if len(argv) > 2 else ".git/COMMIT_EDITMSG"
    args = check.args + ((message_file,) if name == "message" else ())

    code = run_commit_check(args)
    if code == 0:
        return 0
    if code == COMMIT_CHECK_MISSING:
        print(
            "commit-check is unavailable in this hook environment; "
            "re-run setup-git-hooks.bat to repair the hooks.",
            file=sys.stderr,
        )
        return 1

    report(check, offending_value(name, message_file))
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
