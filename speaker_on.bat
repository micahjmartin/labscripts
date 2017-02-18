@echo off
:: Turn on the speakers for all computers in the lab.
:: Requires nircmd.exe
:: -knif3
set list=INSTRUCTOR AUTO11 AUTO12 AUTO21 AUTO22 AUTO31 AUTO32 AUTO41 AUTO42 AUTO51 AUTO52 AUTO61 AUTO62 AUTO71 AUTO72 DECEP11 DECEP12 DECEP21 DECEP22 DECEP31 DECEP32 DECEP41 DECEP42 DECEP51 DECEP52 DECEP61 DECEP62 MAX11 MAX12 MAX21 MAX22 MAX31 MAX32 MAX41 MAX42 MAX51 MAX52 MAX61 MAX62
for %%a in (%list%) do (
    psexec \\%%a -c nircmd.exe setsysvolume 65534
    psexec \\%%a -c nircmd.exe mutesysvolume 0
)