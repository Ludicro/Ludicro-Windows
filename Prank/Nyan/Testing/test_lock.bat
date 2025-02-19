@echo off
:: Detect the USB drive letter
echo [!] Detecting USB drive...
for /f "tokens=2 delims==" %%I in ('wmic logicaldisk where "drivetype=2" get deviceid /value') do set USBDrive=%%I
echo [!] USB drive detected: %USBDrive%

:: Verify the source files exist on the USB drive
if not exist "%USBDrive%\payload\nyan_glitch.gif" (
    echo [!] Error: nyan_glitch.gif not found on USB drive.
    exit /b
)

if not exist "%USBDrive%\payload\lockscreen.hta" (
    echo [!] Error: lockscreen.hta not found on USB drive.
    exit /b
)

if not exist "%USBDrive%\payload\multimonitor.vbs" (
    echo [!] Error: multimonitor.vbs not found on USB drive.
    exit /b
)

:: Copy prank files to C:\Windows\Temp using copy (instead of xcopy)
echo [!] Deploying prank files...

:: Ensure the destination is treated as a file and avoid the "file or directory" prompt
copy /Y "%USBDrive%\payload\nyan_glitch.gif" "C:\Windows\Temp\nyan_glitch.gif"
copy /Y "%USBDrive%\payload\lockscreen.hta" "C:\Windows\Temp\lockscreen.hta"
copy /Y "%USBDrive%\payload\multimonitor.vbs" "C:\Windows\Temp\multimonitor.vbs"

:: Run the HTA file to display the GIF in full-screen
echo [!] Running prank...
cscript //nologo "C:\Windows\Temp\multimonitor.vbs"

:: Wait for the prank to finish (e.g., 30 seconds)
timeout /t 30

:: Kill the HTA process after the prank duration
echo [!] Terminating HTA process...
taskkill /F /IM mshta.exe

:: Clean up prank files
echo [!] Cleaning up...
del "C:\Windows\Temp\nyan_glitch.gif"
del "C:\Windows\Temp\lockscreen.hta"
del "C:\Windows\Temp\multimonitor.vbs"
echo [!] Prank complete!

pause
exit /b
