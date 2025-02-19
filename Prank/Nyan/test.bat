:: Disable Task Manager (for ALL users, even Admins)
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V "DisableTaskMgr" /T REG_DWORD /D 1 /F
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /V "DisableTaskMgr" /T REG_DWORD /D 1 /F