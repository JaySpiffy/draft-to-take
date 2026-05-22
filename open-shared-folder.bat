@echo off
setlocal EnableExtensions

cd /d "%~dp0"

if exist ".env" (
    for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
        if not "%%A"=="" set "%%A=%%B"
    )
)

if exist ".draft-to-take-runtime.env" (
    for /f "usebackq eol=# tokens=1,* delims==" %%A in (".draft-to-take-runtime.env") do (
        if not "%%A"=="" set "%%A=%%B"
    )
)

if "%DRAFT_TO_TAKE_HOME%"=="" set "DRAFT_TO_TAKE_HOME=%USERPROFILE%\DraftToTake"
if "%DRAFT_TO_TAKE_SHARED_DIR%"=="" set "DRAFT_TO_TAKE_SHARED_DIR=%DRAFT_TO_TAKE_HOME%\shared"

if not exist "%DRAFT_TO_TAKE_SHARED_DIR%" mkdir "%DRAFT_TO_TAKE_SHARED_DIR%"

echo [INFO] Opening shared folder:
echo        %DRAFT_TO_TAKE_SHARED_DIR%
start "" "%DRAFT_TO_TAKE_SHARED_DIR%"
