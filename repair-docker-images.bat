@echo off
setlocal EnableExtensions

echo ============================================
echo   Draft to Take Docker Image Repair
echo ============================================
echo.

cd /d "%~dp0"

if not exist ".env" (
    copy ".env.example" ".env" >nul
    echo [INFO] Created .env from .env.example.
)

for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
    if not "%%A"=="" set "%%A=%%B"
)

if "%DRAFT_TO_TAKE_IMAGE_PREFIX%"=="" set "DRAFT_TO_TAKE_IMAGE_PREFIX=ghcr.io/jayspiffy"
if "%DRAFT_TO_TAKE_IMAGE_TAG%"=="" set "DRAFT_TO_TAKE_IMAGE_TAG=v3.0.0-beta.10"

docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

set "COMPOSE_ENV_FILES=--env-file .env"
if exist ".draft-to-take-runtime.env" set "COMPOSE_ENV_FILES=%COMPOSE_ENV_FILES% --env-file .draft-to-take-runtime.env"

echo [INFO] Stopping Draft to Take beta containers...
docker compose %COMPOSE_ENV_FILES% -f docker-compose.yml -f docker-compose.gpu.yml --profile llm --profile omnivoice --profile sfx down --remove-orphans

echo.
echo [INFO] Removing only Draft to Take beta images for %DRAFT_TO_TAKE_IMAGE_TAG%...
for %%I in (
    draft-to-take-backend
    draft-to-take-frontend
    draft-to-take-script-llm
    draft-to-take-omnivoice
    draft-to-take-sfx
) do (
    docker image rm "%DRAFT_TO_TAKE_IMAGE_PREFIX%/%%I:%DRAFT_TO_TAKE_IMAGE_TAG%" >nul 2>&1
    if errorlevel 1 (
        echo [INFO] %%I image was not present or is already removed.
    ) else (
        echo [OK] Removed %%I:%DRAFT_TO_TAKE_IMAGE_TAG%
    )
)

echo.
echo [INFO] Cleaning dangling Docker layers...
docker image prune -f >nul 2>&1

echo.
echo [OK] Repair cleanup finished.
echo Shared data was not deleted:
if "%DRAFT_TO_TAKE_SHARED_DIR%"=="" (
    echo   %USERPROFILE%\DraftToTake\shared
) else (
    echo   %DRAFT_TO_TAKE_SHARED_DIR%
)
echo.
echo Run start.bat to pull fresh images and start Draft to Take again.
pause
