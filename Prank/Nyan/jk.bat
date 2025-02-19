@echo off
title System Restore
color 2F
cls
echo [!] Restoring system settings...
timeout /t 2 /nobreak >nul

:: Kill the VBS script to stop the prank
taskkill /IM wscript.exe /F >nul

:: Delete prank files
del "C:\Windows\Temp\nyan.vbs" >nul
del "C:\Windows\Temp\nyan_glitch.gif" >nul

echo [!] Prank undone, system restored.
pause
exit
