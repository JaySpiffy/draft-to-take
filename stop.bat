@echo off
setlocal EnableExtensions

cd /d "%~dp0"

if exist ".env" (
    call :ValidateEnvFile ".env"
    if errorlevel 1 (
        pause
        exit /b 1
    )
    for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
        if not "%%A"=="" set "%%A=%%B"
    )
)

if "%INDTEXTS_USE_GPU%"=="false" (
    set "COMPOSE_FILES=-f docker-compose.yml"
) else (
    set "COMPOSE_FILES=-f docker-compose.yml -f docker-compose.gpu.yml"
)

echo [INFO] Stopping Draft to Take beta containers...
docker compose %COMPOSE_FILES% --profile llm --profile omnivoice --profile sfx down
echo [INFO] Done. Shared files and downloaded models were not deleted.
pause
exit /b 0

:ValidateEnvFile
set "DTT_ENV_FILE=%~f1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path=$env:DTT_ENV_FILE; $badChars=[char[]](34,38,60,62,94,124); $lineNo=0; foreach ($line in Get-Content -LiteralPath $path -ErrorAction Stop) { $lineNo++; $trim=$line.Trim(); if ($trim -eq '' -or $trim.StartsWith('#')) { continue }; $eq=$line.IndexOf('='); if ($eq -lt 1) { continue }; $key=$line.Substring(0,$eq).Trim(); $value=$line.Substring($eq+1); $unsafe=$key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'; foreach ($ch in $badChars) { if ($value.Contains($ch)) { $unsafe=$true } }; if ($unsafe) { Write-Host ('[ERROR] Unsafe env entry on line {0}: {1}' -f $lineNo,$key); exit 2 } }; exit 0"
set "DTT_ENV_FILE="
exit /b %ERRORLEVEL%
