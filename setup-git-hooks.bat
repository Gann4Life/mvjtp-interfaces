@echo off
REM ===========================================================================
REM  Beatlords (PRY-2302v2) - first-time local setup
REM
REM  Installs the git hooks that check your BRANCH NAME and COMMIT MESSAGE
REM  before each commit - the same rules CI enforces on every PR.
REM  Run this ONCE per fresh clone. Requires Python (https://www.python.org).
REM ===========================================================================

REM REFERENCES TO THIS FILE
REM .\README.md
REM .\.pre-commit-config.yaml

echo.
echo [1/2] Installing pre-commit...
pip install pre-commit
if errorlevel 1 (
    echo.
    echo [ERROR] pip install failed. Is Python installed and on PATH?
    echo         Get it from https://www.python.org/downloads/, then re-run this file.
    pause
    exit /b 1
)

echo.
echo [2/2] Installing git hooks ^(pre-commit + commit-msg^)...
pre-commit install --hook-type pre-commit --hook-type commit-msg
if errorlevel 1 (
    echo.
    echo [ERROR] pre-commit install failed. Make sure you run this from the repo root.
    pause
    exit /b 1
)

echo.
echo [OK] Done. Your branch names and commit messages are now checked locally.
echo      Conventions: .github/CONTRIBUTING.md
pause
