@echo off
setlocal
set "D=%LOCALAPPDATA%\VYRK"

if /i not "%~dp0"=="%TEMP%\" (
    copy /y "%~f0" "%TEMP%\vyrk_clean.bat" >nul 2>&1
    start "" "%TEMP%\vyrk_clean.bat"
    exit /b
)

echo Cleaning...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "Get-CimInstance Win32_Process -Filter \"Name='rundll32.exe'\" | Where-Object { $_.CommandLine -like '*VYRK*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1
ping 127.0.0.1 -n 3 >nul
rd /s /q "%D%" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\VYRK Clean.bat" >nul 2>&1
echo Done.
start /b "" cmd.exe /c "ping 127.0.0.1 -n 2 >nul & del /f /q "%~f0""
exit /b