@echo off
setlocal
set "D=%LOCALAPPDATA%\VYRK"

if /i not "%~dp0"=="%TEMP%\" (
    copy /y "%~f0" "%TEMP%\vyrk_clean.bat" >nul 2>&1
    start "" "%TEMP%\vyrk_clean.bat"
    exit /b
)

echo Cleaning...
taskkill /f /im rundll32.exe >nul 2>&1
ping 127.0.0.1 -n 3 >nul
rd /s /q "%D%" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\VYRK Clean.bat" >nul 2>&1
del /f /q "%TEMP%\vy_log.txt" >nul 2>&1
del /f /q "%TEMP%\*.dll" >nul 2>&1
for /d %%D in ("%TEMP%\vy_*") do rd /s /q "%%~D" >nul 2>&1
echo. | clip >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\CMD.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\CONHOST.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\RUNDLL32.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\TASKKILL.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\PING.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\CLIP.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\CURL.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\CSCRIPT.EXE-"*.pf >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\FLTMC.EXE-"*.pf >nul 2>&1
echo Done.
start /b "" cmd.exe /c "ping 127.0.0.1 -n 2 >nul & del /f /q ""%~f0"""
exit /b