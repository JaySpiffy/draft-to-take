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

if "%INDTEXTS_FRONTEND_HOST_PORT%"=="" set "INDTEXTS_FRONTEND_HOST_PORT=3000"

echo [INFO] Opening Draft to Take at http://localhost:%INDTEXTS_FRONTEND_HOST_PORT%
start "" "http://localhost:%INDTEXTS_FRONTEND_HOST_PORT%"
