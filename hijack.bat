@echo off
set /p pc="Select PC: "
set /p pass="Configure new password: "

:: Added current password incase you already changed it
set curpass=student

psexec -u student -p %curpass% \\%pc% reg add "hklm\system\currentcontrolset\control\terminal server" /f /v fDenyTSConnections /t REG_DWORD /d 0
psexec -u student -p %curpass% \\%pc% netsh firewall set service remoteadmin enable 
psexec -u student -p %curpass% \\%pc% netsh firewall set service remotedesktop enable
psexec -u student -p %curpass% \\%pc% net user Administrator %pass%
psexec -u student -p %curpass% \\%pc% net user Student %pass%
echo.

:: Added ability to RDP into the box by pressing enter

:: Saves the credentials for the machine
cmdkey /generic:"%pc%" /user:"student" /pass:"%pass%"

:: Sets the sound to stay on the remote computer so we can play music
echo audiomode:i:1 > C:\session.rdp

:: Adds desktop shortcut for easy re-entry
echo mstsc C:\session.rdp /v:%pc% > C:\Users\%USERNAME%\Desktop\RDP_%pc%.bat


echo Press enter to automatically RDP into the computer or close to stop...
pause >NUL

mstsc C:\session.rdp /v:%pc%