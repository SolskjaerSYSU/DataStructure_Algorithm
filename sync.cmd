@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\sync.ps1"
set "syncExit=%ERRORLEVEL%"
if not "%syncExit%"=="0" echo Sync failed. Read the error above.
pause
exit /b %syncExit%
