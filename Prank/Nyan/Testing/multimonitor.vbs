Set shell = CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set pnpMonitors = objWMIService.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE Service='Monitor'")

monitorCount = 0
For Each monitor In pnpMonitors
    shell.Run "mshta.exe ""C:\Windows\Temp\lockscreen.hta#" & monitorCount & """", 1, False
    monitorCount = monitorCount + 1
Next
