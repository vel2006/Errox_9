#!/bin/bash
#-PRINTING OUT THE CURRENT VERSION OF 'Errox_9', DUE TO ME CHANGING TO JAVA, BUT THIS WILL STAY THE SAME-#
echo "Version: 1.1"
if [[ $1 == "-h" ]]; then
	echo " _________________ _______   __  _____ "
	echo "|  ___| ___ \ ___ \  _  \ \ / / |  _  |"
	echo "| |__ | |_/ / |_/ / | | |\ V /  | |_| |"
	echo "|  __||    /|    /| | | |/   \  \____ |"
	echo "| |___| |\ \| |\ \\\\ \_/ / /^\ \ .___/ /"
	echo "\____/\_| \_\_| \_|\___/\/   \/ \____/"
	echo ""
 	echo "Hello user. Errox_9 is a very simple yet diverse script, this is the 1.1 version, which lays the foundation for other versions."
  	echo "Here is how to use Errox_9 in its 1.2 version:"
	echo "    1) Use sudo when running Errox_9, it is needed."
	echo "    2) Format like this: 'sudo ./Errox_9.sh' and let Errox_9 do the rest for you"
	echo "Happy pentesting, and support the creator at: 'https://github.com/vel2006/Errox_9"
 	exit
  fi
#-GETTING THE START TIME, FOR TELLING THE USER HOW LONG THE SCRIPT TAKES-#
start=$(date +%s)
#-GETTING THE INTERFACES AVALABLE TO THE USER-#
echo "Collecting device interfaces"
#SAVING THE INTERFACES IN A TEMP ARRAY#
temp=($(ifconfig | grep -E ": flags=" | awk -F '[:]' '{print $1}'))
#HOLDING USABLE INTERFACES#
interfaces=()
#LOOPING THROUGH THE INTERFACES#
for i in ${!temp[@]}; do
	#SEEING IF THE INTERFACE CAN BE USED#
	if [[ "${temp[$i]}" != "lo" ]]; then
		interfaces+=("${temp[$i]}")
	fi
done
echo "Collected device interfaces: ${interfaces[@]}"
#-GOING THROUGH THE INTERFACES AND SCANNING THE NETWORK WITH arp-scan TO FIND HOSTS-#
for i in ${!interfaces[@]}; do
	echo "Getting network information on ${interfaces[$i]} interface"
	#GETTING THE USER'S IP#
	userIP=$(ip a | grep "inet" | grep "brd" | awk '{print $2}' | awk -F '[/]' '{print $1}')
	#SCANNING FOR DEVICES AND SAVING IT WITHIN A TEMP ARRAY#
	scanResult=$(sudo arp-scan -I ${interfaces[$i]} --localnet --format='${ip}\t${mac}')
	#HOLDING FOUND IPs, MACs, AND THE NETWORK TYPE#
	IPs=()
	MACs=()
 	echo "Getting network speed and type"
	type=$(echo "$scanResult" | grep -oE 'type:+ [[:alnum:]]+' | awk '{print $2}')
	#HOLDING THE IPs WITHIN A TEMP ARRAY TO CHECK IF IT'S NEEDED#
	temp=($(echo "$scanResult" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $1}'))
 	echo "Getting network devices IPs"
	#LOOPING THROUGH THE IPs#
	for j in ${!temp[@]}; do
		#CHECKING TO SEE IF THE IP IS THE USER OR NETWORK MIN#
		if [[ $(echo "${temp[$j]}" | awk '{print $1}') != $(echo "$(ip a | grep 'inet' | grep 'brd' | awk '{print $2}' | awk -F '[/]' '{print $1}')") && $(echo "${temp[$j]}" | awk '{print $1}') != $(echo "$(ip a | grep 'inet' | grep 'brd' | awk '{print $2}' | awk -F '[/]' '{print $1}')")  ]]; then
			#THE IP IS NEITHER, SO IT GETS ADDED#
			IPs+=("${temp[$j]}")
		fi
	done
	#HOLDING THE MACs WITHIN A TEMP ARRAY TO CHECK IF IT'S NEEDED#
	temp=($(echo "$scanResult" | grep -oE "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}"))
 	echo "Getting network device MAC addresses"
	#LOOPING THROUGH THE MACs#
	for j in ${!temp[@]}; do
		#CHECKING TO SEE IF THE MAC ADDRESS IS THE USER'S#
		if [[ $(echo "${temp[$j]}") != $(echo "$(ifconfig ${interfaces[$j]} | grep -oE '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')") ]]; then
			#IT ISNT AND GETS ADDED#
			MACs+=("${temp[$j]}")
		fi
	done
	echo "Interface: ${interfaces[$i]}"
	echo "IPs found: ${IPs[@]}"
	echo "MACs found: ${MACs[@]}"
	echo ""
done
#-GETTING THE END TIME AND HOW LONG IT TAKES IN SECONDS-#
end=$(date +%s)
total=$((end - start))
echo "It took $((total % 60)) seconds to run the script"
