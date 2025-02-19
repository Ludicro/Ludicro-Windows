Set objShell = CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set pnpMonitors = objWMIService.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE Service='Monitor'")

screenCount = 0
For Each monitor In pnpMonitors
    command = "mshta.exe ""C:\Windows\Temp\lockscreen.hta?screen=" & screenCount & """"
    objShell.Run command, 3, False
    WScript.Sleep 1000
    screenCount = screenCount + 1
Next
