@echo off
:: Run on the lab computers to prevent people from messing with your box
set /p pass="Enter new password: "
net user Administrator %pass%
net user Student %pass%
NetSh Advfirewall set allprofiles state on
echo Firewall on 
Netsh Advfirewall show allprofiles
netsh interface set interface name="Local Area Connection 2" admin=disabled
echo NIC off
netsh interface set interface name="Local Area Connection 2" admin=enabled
echo NIC on
echo Box secured.
pause