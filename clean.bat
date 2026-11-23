@echo off
setlocal EnableExtensions
title CacheClean

fltmc >nul 2>&1
if %errorlevel% equ 0 goto :GO
if /i "%~1"=="__ELEVATED__" goto :GO

echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\vy_elev.vbs"
echo UAC.ShellExecute "%~s0", "__ELEVATED__", "", "runas", 1 >> "%TEMP%\vy_elev.vbs"
cscript //nologo "%TEMP%\vy_elev.vbs"
del /f /q "%TEMP%\vy_elev.vbs" >nul 2>&1
exit /b

:GO
echo.
echo  [*] Cleaning...
echo.

taskkill /f /im rundll32.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul

del /f /q "%TEMP%\a7f3c812-4e9b-4d2a-b156-9c8e1d4f7062.tmp" >nul 2>&1
del /f /q "%TEMP%\a7f3c812-4e9b-4d2a-b156-9c8e1d4f7062.old" >nul 2>&1
for /d %%D in ("%TEMP%\vy_*") do rd /s /q "%%~D" >nul 2>&1
del /f /q "%TEMP%\vy_log.txt" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\VYRK" >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\RUNDLL32*.pf" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\VYRK Clean.bat" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\Clean.bat" >nul 2>&1
echo | clip

echo  [+] Done
echo.

set "SELF=%~f0"
start /b "" cmd.exe /c ping 127.0.0.1 -n 2 ^>nul ^& del /f /q "%SELF%"
exit /b