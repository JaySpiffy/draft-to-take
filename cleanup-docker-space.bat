@echo off
setlocal EnableExtensions

echo ============================================
echo   Draft to Take Docker Space Cleanup
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
if not defined DRAFT_TO_TAKE_IMAGE_TAG set "DRAFT_TO_TAKE_IMAGE_TAG=v3.0.0-beta.19"

docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo [INFO] Docker disk usage before cleanup:
docker system df
echo.
echo [INFO] Docker detailed disk usage before cleanup:
docker system df -v
echo.
echo [INFO] Keeping current Draft to Take image tag:
echo        %DRAFT_TO_TAKE_IMAGE_TAG%
echo.
echo [INFO] Removing older Draft to Take beta image tags from:
echo        %DRAFT_TO_TAKE_IMAGE_PREFIX%
echo.
echo This does not delete voices, projects, model files, or exports under:
if not defined DRAFT_TO_TAKE_SHARED_DIR (
    echo   %USERPROFILE%\DraftToTake\shared
) else (
    echo   %DRAFT_TO_TAKE_SHARED_DIR%
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$prefix=$env:DRAFT_TO_TAKE_IMAGE_PREFIX; $current=$env:DRAFT_TO_TAKE_IMAGE_TAG; $services=@('backend','frontend','script-llm','omnivoice','sfx'); $removed=0; foreach ($service in $services) { $repo=('{0}/draft-to-take-{1}' -f $prefix,$service); $lines=docker image ls $repo --format '{{.Repository}}`t{{.Tag}}'; foreach ($line in $lines) { $parts=$line -split \"`t\"; if ($parts.Count -lt 2) { continue }; $tag=$parts[1]; if ($tag -and $tag -ne '<none>' -and $tag -ne $current) { Write-Host ('[INFO] Removing {0}:{1}' -f $repo,$tag); docker image rm ('{0}:{1}' -f $repo,$tag); if ($LASTEXITCODE -eq 0) { $removed++ } } } }; Write-Host ('[INFO] Removed {0} old Draft to Take image tag(s).' -f $removed)"

echo.
echo [INFO] Cleaning dangling Docker image layers...
docker image prune -f

echo.
echo [INFO] Docker disk usage after cleanup:
docker system df
echo.
echo [INFO] Docker Desktop WSL disk files, if present:
powershell -NoProfile -ExecutionPolicy Bypass -Command "$paths=@((Join-Path $env:LOCALAPPDATA 'Docker\wsl\data\ext4.vhdx'), (Join-Path $env:LOCALAPPDATA 'Docker\wsl\disk\docker_data.vhdx')); foreach ($path in $paths) { if (Test-Path -LiteralPath $path) { $size=[math]::Round((Get-Item -LiteralPath $path).Length / 1GB, 2); Write-Host ('[INFO] {0} = {1} GB' -f $path,$size) } }; Write-Host '[INFO] If Docker freed space internally but Windows did not regain it, Docker Desktop may still be holding it in this WSL virtual disk.'"
echo.
echo [OK] Cleanup finished.
echo Cleaning 0 GB can be normal if no older Draft to Take tags are present.
echo Docker Desktop can also keep free space inside its WSL virtual disk until Docker/WSL compacts or resets it.
echo This script does not run global Docker prune, delete Docker volumes, or compact WSL disks because that can affect other Docker projects.
echo If Docker Desktop still shows high disk usage, open Docker Desktop:
echo Settings / Resources / Disk image size, or Troubleshoot / Clean or Purge data.
echo That resets Docker images and containers, but not the shared folder shown above.
pause
exit /b 0

:ValidateEnvFile
set "DTT_ENV_FILE=%~f1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path=$env:DTT_ENV_FILE; $badChars=[char[]](34,38,60,62,94,124); $lineNo=0; foreach ($line in Get-Content -LiteralPath $path -ErrorAction Stop) { $lineNo++; $trim=$line.Trim(); if ($trim -eq '' -or $trim.StartsWith('#')) { continue }; $eq=$line.IndexOf('='); if ($eq -lt 1) { continue }; $key=$line.Substring(0,$eq).Trim(); $value=$line.Substring($eq+1); $unsafe=$key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'; foreach ($ch in $badChars) { if ($value.Contains($ch)) { $unsafe=$true } }; if ($unsafe) { Write-Host ('[ERROR] Unsafe env entry on line {0}: {1}' -f $lineNo,$key); exit 2 } }; exit 0"
set "DTT_ENV_FILE="
exit /b %ERRORLEVEL%
