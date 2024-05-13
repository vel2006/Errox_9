#!/bin/bash
#-PRINTING OUT THE CURRENT VERSION OF 'Errox_9', DUE TO ME CHANGING TO PYTHON, BUT THIS WILL STAY THE SAME-#
echo "Version: 1.2"
#-GETTING THE START TIME, FOR TELLING THE USER HOW LONG THE SCRIPT TAKES WHEN THE SCRIPT IS DONE-#
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
#-GOING THROUGH THE INTERFACES AND SCANNING THE NETWORK TO FIND HOSTS-#
for i in ${!interfaces[@]}; do
	echo "Getting ${interfaces[$i]} network devices IPs and MACs"
	userIP=$(ifconfig | grep -A 1 -e '${interfaces[$i]}:' | grep -E 'inet [[:xdigit:]]' | awk '{print $2}' | awk -F '[/]' '{print $1}')
	userMAC=$(ifconfig | grep -i -A 100 "${interfaces[$i]}:" | awk '/${interfaces[$i +1]}/{exit} 1' | grep -E 'ether [[:xdigit:]]' | awk '{print $2}')
	MACs=()
	IPs=()
	temp=$(ifconfig)
	base=""
	base+=$(echo "$temp" | grep -A 1 -E "[[:xdigit:]]: flags=+" | grep -E "inet+ " | awk '{print $2}' | awk -F '[.]' '{print $1}')
	base+="."
	base+=$(echo "$temp" | grep -A 1 -E "[[:xdigit:]]: flags=+" | grep -E "inet+ " | awk '{print $2}' | awk -F '[.]' '{print $2}')
	base+="."
	base+=$(echo "$temp" | grep -A 1 -E "[[:xdigit:]]: flags=+" | grep -E "inet+ " | awk '{print $2}' | awk -F '[.]' '{print $3}')
	base+="."
	if [[ $# == 1 ]]; then
		if [[ $1 == 1 ]]; then
			for (( j = 1; j < 256; j++ )); do
				temp=$(arping -c 1 -w 1 $base$j)
				if [[ $(echo "$temp" | grep -E "[[:xdigit:]]+:[[:xdigit:]]+:") ]]; then
					MACs+=($(echo "$temp" | grep -E "from +" | awk '{print $4}'))
					IPs+=("$base$j")
				fi
			done
			echo "Data collected"
			echo "Interface: ${interfaces[$i]}"
			echo "IPs: ${IPs[@]}"
			echo "MACs: ${MACs[@]}"
		elif [[ $1 == 2 ]]; then
			for (( j = 1; j < 256; j++ )); do
				temp=$(ping -s 1 -W 5 -c 1 $base$j)
				if [[ $? == 0 ]]; then
					readarray -t lines < <(arp -a)
					for k in ${!lines[@]}; do
						if [[ $(echo "${lines[$k]}" | grep -E "at [[:xdigit:]]") && $(echo "${lines[$k]}" | grep -E "at [[:xdigit:]]" | awk -F '[()]' '{print $2}') != "$userIP" ]]; then
							echo "${IPs[@]}"
							echo ""
							add=1
							for l in ${!IPs[@]}; do
								if [[ $(echo "${lines[$k]}" | grep -E "at [[:xdigit:]]" | awk -F '[()]' '{print $2}') == "${IPs[$l]}" ]]; then
									add=0
								fi
							done
							if [[ $add == 1 ]]; then
								IPs+=($(echo "${lines[$k]}" | grep -E "at [[:xdigit:]]" | awk -F '[()]' '{print $2}'))
								MACs+=($(echo "${lines[$k]}" | grep -oE "[[:xdigit:]]+:[[:xdigit:]]+:[[:xdigit:]]+:[[:xdigit:]]+:[[:xdigit:]]+:[[:xdigit:]]+"))
							fi
						fi
					done
				fi
			done
			echo "Data collected"
			echo "Interface: ${interface[$i]}"
			echo "IPs: ${IPs[@]}"
			echo "MACs: ${MACs[@]}"
		elif [[ $1 == 3 ]]; then
			scanResult=$(sudo arp-scan -I ${interfaces[$i]} --localnet --format='${ip}\t${mac}')
			temp=($(echo "$scanResult" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $1}'))
			for j in ${!temp[@]}; do
				if [[ $(echo "${temp[$j]}" | awk '{print $1}') != $(echo "$userIP") ]]; then
					IPs+=("${temp[$j]}")
				fi
			done
			temp=($(echo "$scanResult" | grep -oE "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}"))
			for j in ${!temp[@]}; do
				if [[ $(echo "${temp[$j]}") != "$userMAC" ]]; then
					MACs+=("${temp[$j]}")
				fi
			done
			echo "Data collected"
			echo "Interface: ${interfaces[$i]}"
			echo "IPs: ${IPs[@]}"
			echo "MACs: ${MACs[@]}"
		elif [[ $1 == "-h" ]]; then
			echo " _________________ _______   __  _____ "
			echo "|  ___| ___ \ ___ \  _  \ \ / / |  _  |"
			echo "| |__ | |_/ / |_/ / | | |\ V /  | |_| |"
			echo "|  __||    /|    /| | | |/   \  \____ |"
			echo "| |___| |\ \| |\ \\\\ \_/ / /^\ \ .___/ /"
			echo "\____/\_| \_\_| \_|\___/\/   \/ \____/"
			echo ""
			echo "Hello user. Errox_9 is a very simple yet diverse script, this is the 1.2 version, which adds some usefull features."
			echo "Errox_9 1.2 has added these features:"
			echo "    1) Different scanning methods"
			echo "    2) Slightly quieter scan methods"
			echo "Here is how to use Errox_9 in its 1.2 version:"
			echo "    1) Use sudo when running Errox_9, it is needed for two of the methods (1 & 3)"
			echo "    2) Select the type you wish to use:"
			echo "        ~) Version 1 uses arping, is louder to network admins but faster than version 2"
			echo "        !) Version 2 uses ping, it's quieter than version 1 but much slower"
			echo "        @) Version 3 uses arp-scan, its the fastest and loudest"
			echo "    3) Format like this: 'sudo ./Errox_9.sh [1-3]' and let Errox_9 do the rest for you"
			echo "Happy pentesting, and support the creator at: 'https://github.com/vel2006/Errox_9"
		else
			echo "Error, unknown argument: $1"
			echo "Please use -h to solve the issue"
			exit
		fi
	else
		echo "Error, no argument"
		echo "Please use -h to solve the issue"
	fi
done
#-GETTING THE END TIME AND HOW LONG IT TAKES IN SECONDS-#
end=$(date +%s)
total=$((end - start))
echo "It took $total seconds to run this script"
