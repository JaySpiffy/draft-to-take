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

if not defined DRAFT_TO_TAKE_HOME set "DRAFT_TO_TAKE_HOME=%USERPROFILE%\DraftToTake"
if not defined DRAFT_TO_TAKE_SHARED_DIR set "DRAFT_TO_TAKE_SHARED_DIR=%DRAFT_TO_TAKE_HOME%\shared"

call :ValidateSharedDir
if errorlevel 1 exit /b 1

if not exist "%DRAFT_TO_TAKE_SHARED_DIR%" mkdir "%DRAFT_TO_TAKE_SHARED_DIR%"

echo [INFO] Opening shared folder:
echo        %DRAFT_TO_TAKE_SHARED_DIR%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Item -LiteralPath $env:DRAFT_TO_TAKE_SHARED_DIR"
exit /b 0

:ValidateEnvFile
set "DTT_ENV_FILE=%~f1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$path=$env:DTT_ENV_FILE; $badChars=[char[]](34,38,60,62,94,124); $lineNo=0; foreach ($line in Get-Content -LiteralPath $path -ErrorAction Stop) { $lineNo++; $trim=$line.Trim(); if ($trim -eq '' -or $trim.StartsWith('#')) { continue }; $eq=$line.IndexOf('='); if ($eq -lt 1) { continue }; $key=$line.Substring(0,$eq).Trim(); $value=$line.Substring($eq+1); $unsafe=$key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'; foreach ($ch in $badChars) { if ($value.Contains($ch)) { $unsafe=$true } }; if ($unsafe) { Write-Host ('[ERROR] Unsafe env entry on line {0}: {1}' -f $lineNo,$key); exit 2 } }; exit 0"
set "DTT_ENV_FILE="
exit /b %ERRORLEVEL%

:ValidateSharedDir
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p=$env:DRAFT_TO_TAKE_SHARED_DIR; $badChars=[char[]](34,38,60,62,94,124); if ([string]::IsNullOrWhiteSpace($p)) { exit 1 }; foreach ($ch in $badChars) { if ($p.Contains($ch)) { exit 2 } }; try { [System.IO.Path]::GetFullPath($p) | Out-Null; exit 0 } catch { exit 3 }"
if errorlevel 1 (
    echo [ERROR] DRAFT_TO_TAKE_SHARED_DIR is not a safe Windows folder path.
    pause
    exit /b 1
)
exit /b 0
