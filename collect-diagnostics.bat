@echo off
setlocal EnableExtensions

cd /d "%~dp0"

if "%DRAFT_TO_TAKE_HOME%"=="" set "DRAFT_TO_TAKE_HOME=%USERPROFILE%\DraftToTake"
if "%DRAFT_TO_TAKE_SHARED_DIR%"=="" set "DRAFT_TO_TAKE_SHARED_DIR=%DRAFT_TO_TAKE_HOME%\shared"
set "DRAFT_TO_TAKE_RUNTIME_ENV=.draft-to-take-runtime.env"
set "COMPOSE_ENV_FILES="
if exist ".env" set "COMPOSE_ENV_FILES=--env-file .env"
if exist "%DRAFT_TO_TAKE_RUNTIME_ENV%" set "COMPOSE_ENV_FILES=%COMPOSE_ENV_FILES% --env-file %DRAFT_TO_TAKE_RUNTIME_ENV%"

set "OUT_DIR=%DRAFT_TO_TAKE_HOME%\diagnostics"
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set "STAMP=%%i"
set "OUT_FILE=%OUT_DIR%\draft-to-take-beta-%STAMP%.txt"

echo [INFO] Writing diagnostics to:
echo        %OUT_FILE%
echo.

(
    echo Draft to Take Beta Diagnostics
    echo Generated: %DATE% %TIME%
    echo.
    echo == System ==
    ver
    echo.
    echo == Docker Version ==
    docker version
    echo.
    echo == Docker Compose Version ==
    docker compose version
    echo.
    echo == Docker Disk Usage ==
    docker system df
    echo.
    echo == Docker Builder Cache Usage ==
    docker builder du
    echo.
    echo == Windows Drive Free Space ==
    powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | Select-Object Name,Used,Free | Format-Table -AutoSize"
    echo.
    echo == GPU Check ==
    docker run --rm --gpus all nvidia/cuda:12.8.0-base-ubuntu22.04 nvidia-smi
    echo.
    echo == Compose PS ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm --profile omnivoice --profile sfx ps
    echo.
    echo == Compose Frontend Port ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm --profile omnivoice --profile sfx port frontend 80
    echo.
    echo == Compose Backend Port ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm --profile omnivoice --profile sfx port backend 8000
    echo.
    echo == Backend Logs ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm --profile omnivoice --profile sfx logs --tail 250 backend
    echo.
    echo == Frontend Logs ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm --profile omnivoice --profile sfx logs --tail 100 frontend
    echo.
    echo == Script LLM Logs ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm logs --tail 150 script-llm
    echo.
    echo == OmniVoice Logs ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile omnivoice logs --tail 150 omnivoice
    echo.
    echo == SFX Logs ==
    docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile sfx logs --tail 150 sfx
) > "%OUT_FILE%" 2>&1

echo [INFO] Diagnostics collected.
echo [INFO] Please review the file before posting it publicly. Do not share private scripts, voices, tokens, or personal paths if you are not comfortable with them.
pause
