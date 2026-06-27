@echo off
REM ===========================================================================
REM  MVJ - Interfaces de Usuario - first-time local setup
REM
REM  Installs the git hooks that check your BRANCH NAME and COMMIT MESSAGE
REM  before each commit - the same rules CI enforces on every PR.
REM  Run this ONCE per fresh clone. Requires Python (https://www.python.org).
REM ===========================================================================

REM REFERENCES TO THIS FILE
REM .\README.md
REM .\.pre-commit-config.yaml

echo.
echo [1/2] Instalando pre-commit...
pip install pre-commit
if errorlevel 1 (
    echo.
    echo [ERROR] Fallo la instalacion de pip. Tenes Python instalado y en el PATH?
    echo         Bajalo de https://www.python.org/downloads/ y volve a correr este archivo.
    pause
    exit /b 1
)

echo.
echo [2/2] Instalando git hooks ^(pre-commit + commit-msg^)...
pre-commit install --hook-type pre-commit --hook-type commit-msg
if errorlevel 1 (
    echo.
    echo [ERROR] Fallo pre-commit install. Corre esto desde la raiz del repo.
    pause
    exit /b 1
)

echo.
echo [OK] Listo. Tus nombres de rama y mensajes de commit ahora se revisan localmente.
echo      Convenciones: .github/CONTRIBUTING.md
pause
