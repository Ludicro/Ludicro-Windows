Set objShell = CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Try multiple monitor detection methods
Set activeMonitors = objWMIService.ExecQuery("SELECT * FROM Win32_DesktopMonitor WHERE Status='OK'")
Set videoControllers = objWMIService.ExecQuery("SELECT * FROM Win32_VideoController")
Set pnpMonitors = objWMIService.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE Service='Monitor'")

msgbox "Active Monitors: " & activeMonitors.Count & vbCrLf & _
       "Video Controllers: " & videoControllers.Count & vbCrLf & _
       "PnP Monitors: " & pnpMonitors.Count

' Display details for each detection method
For Each monitor In activeMonitors
    msgbox "Desktop Monitor: " & monitor.DeviceID
Next

For Each controller In videoControllers
    msgbox "Video Controller: " & controller.Description & vbCrLf & _
           "Resolution: " & controller.CurrentHorizontalResolution & "x" & controller.CurrentVerticalResolution
Next

For Each pnp In pnpMonitors
    msgbox "PnP Monitor: " & pnp.Caption
Next
