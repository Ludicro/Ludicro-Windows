' Path to the GIF file you want to display (make sure it's on the target machine)
strGIF = "C:\Windows\Temp\lockscreen.gif"

' Create and display the message box on top of the GIF
Set objShell = CreateObject("WScript.Shell")
objShell.Popup "WARNING: System update required. Please restart your computer to continue.", 10, "System Update", 0 + 64

' Show the GIF in full-screen mode
Set objIE = CreateObject("InternetExplorer.Application")
objIE.Visible = True
objIE.FullScreen = True
objIE.Navigate("file:///" & strGIF)

' Prevent closing the window until a restart
Do While True
    WScript.Sleep 1000
Loop
