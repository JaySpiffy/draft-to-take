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

call :ValidateEnvFile ".env"
if errorlevel 1 (
    pause
    exit /b 1
)

for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
    if not "%%A"=="" set "%%A=%%B"
)

if not defined DRAFT_TO_TAKE_IMAGE_PREFIX set "DRAFT_TO_TAKE_IMAGE_PREFIX=ghcr.io/jayspiffy"
if not defined DRAFT_TO_TAKE_IMAGE_TAG set "DRAFT_TO_TAKE_IMAGE_TAG=v3.0.0-beta.17"

docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo [INFO] Docker disk usage before cleanup:
docker system df
echo.
echo [INFO] This repair removes only Draft to Take beta images for the selected tag.
echo        Your projects, voices, models, and exports live outside Docker under:
if "%DRAFT_TO_TAKE_SHARED_DIR%"=="" (
    echo        %USERPROFILE%\DraftToTake\shared
) else (
    echo        %DRAFT_TO_TAKE_SHARED_DIR%
)
echo.

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
echo [INFO] Docker disk usage after cleanup:
docker system df
echo.
echo [OK] Repair cleanup finished.
echo Shared data was not deleted:
if "%DRAFT_TO_TAKE_SHARED_DIR%"=="" (
    echo   %USERPROFILE%\DraftToTake\shared
) else (
    echo   %DRAFT_TO_TAKE_SHARED_DIR%
)
echo.
echo If Docker Desktop still shows very high disk usage after repeated failed pulls,
echo use Docker Desktop's built-in Troubleshoot / Clean or Purge data option.
echo That resets Docker images and containers, so you will need to run start.bat again.
echo It does not delete the Draft to Take shared folder shown above.
echo.
echo Run start.bat to pull fresh images and start Draft to Take again.
echo.
echo If Draft to Take works but old beta images are using disk space,
echo run cleanup-docker-space.bat instead of this repair script.
pause
exit /b 0

:ValidateEnvFile
set "DTT_ENV_FILE=%~f1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path=$env:DTT_ENV_FILE; $badChars=[char[]](34,38,60,62,94,124); $lineNo=0; foreach ($line in Get-Content -LiteralPath $path -ErrorAction Stop) { $lineNo++; $trim=$line.Trim(); if ($trim -eq '' -or $trim.StartsWith('#')) { continue }; $eq=$line.IndexOf('='); if ($eq -lt 1) { continue }; $key=$line.Substring(0,$eq).Trim(); $value=$line.Substring($eq+1); $unsafe=$key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'; foreach ($ch in $badChars) { if ($value.Contains($ch)) { $unsafe=$true } }; if ($unsafe) { Write-Host ('[ERROR] Unsafe env entry on line {0}: {1}' -f $lineNo,$key); exit 2 } }; exit 0"
set "DTT_ENV_FILE="
exit /b %ERRORLEVEL%
