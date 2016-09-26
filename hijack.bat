@echo off
set /p pc="Select PC: "
set /p pass="Configure new password: "
psexec -u Student -p student \\%pc% reg add "hklm\system\currentcontrolset\control\terminal server" /f /v fDenyTSConnections /t REG_DWORD /d 0
psexec -u Student -p student \\%pc% netsh firewall set service remoteadmin enable 
psexec -u Student -p student \\%pc% netsh firewall set service remotedesktop enable
psexec -u Student -p student \\%pc% net user Administrator %pass%
psexec -u Student -p student \\%pc% net user Student %pass%

pause
