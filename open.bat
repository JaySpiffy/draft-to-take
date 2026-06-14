@echo off
setlocal EnableExtensions

cd /d "%~dp0"

if exist ".env" (
    call :ValidateEnvFile ".env"
    if errorlevel 1 exit /b 1
    for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
        if not "%%A"=="" set "%%A=%%B"
    )
)

if exist ".draft-to-take-runtime.env" (
    call :ValidateEnvFile ".draft-to-take-runtime.env"
    if errorlevel 1 exit /b 1
    for /f "usebackq eol=# tokens=1,* delims==" %%A in (".draft-to-take-runtime.env") do (
        if not "%%A"=="" set "%%A=%%B"
    )
)

if not defined INDTEXTS_FRONTEND_HOST_PORT set "INDTEXTS_FRONTEND_HOST_PORT=3000"
call :ValidatePort INDTEXTS_FRONTEND_HOST_PORT 3000
if errorlevel 1 exit /b 1

echo [INFO] Opening Draft to Take at http://localhost:%INDTEXTS_FRONTEND_HOST_PORT%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process ('http://localhost:' + $env:INDTEXTS_FRONTEND_HOST_PORT)"
exit /b 0

:ValidateEnvFile
set "DTT_ENV_FILE=%~f1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path=$env:DTT_ENV_FILE; $badChars=[char[]](34,38,60,62,94,124); $lineNo=0; foreach ($line in Get-Content -LiteralPath $path -ErrorAction Stop) { $lineNo++; $trim=$line.Trim(); if ($trim -eq '' -or $trim.StartsWith('#')) { continue }; $eq=$line.IndexOf('='); if ($eq -lt 1) { continue }; $key=$line.Substring(0,$eq).Trim(); $value=$line.Substring($eq+1); $unsafe=$key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'; foreach ($ch in $badChars) { if ($value.Contains($ch)) { $unsafe=$true } }; if ($unsafe) { Write-Host ('[ERROR] Unsafe env entry on line {0}: {1}' -f $lineNo,$key); exit 2 } }; exit 0"
set "DTT_ENV_FILE="
exit /b %ERRORLEVEL%

:ValidatePort
set "DTT_PORT_VAR=%~1"
set "DTT_PORT_FALLBACK=%~2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$name=$env:DTT_PORT_VAR; $p=[Environment]::GetEnvironmentVariable($name); $port=0; if (-not [string]::IsNullOrWhiteSpace($p) -and [int]::TryParse($p, [ref]$port) -and [string]$port -eq $p -and $port -ge 1 -and $port -le 65535) { exit 0 }; exit 2"
if errorlevel 1 (
    echo [WARNING] Invalid %~1; using %~2.
    set "%~1=%~2"
)
set "DTT_PORT_VAR="
set "DTT_PORT_FALLBACK="
exit /b 0
