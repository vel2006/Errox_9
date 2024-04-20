#!/bin/bash
#-GETTING THE INTERFACES AVALABLE TO THE USER-#
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
echo "Collected device interfaces"
#-GOING THROUGH THE INTERFACES AND SCANNING THE NETWORK WITH arp-scan TO FIND HOSTS-#
for i in ${!interfaces[@]}; do
	#GETTING THE USER'S IP#
	userIP=$(ip a | grep "inet" | grep "brd" | awk '{print $2}' | awk -F '[/]' '{print $1}')
	#CALCULATING THE BASE IP FOR THE NETWORK#
	networkIP=$(ipcalc $userIP | grep "Network:" | awk '{print $2}')
	#CALCULATING THE NETWORK MIN A DEVICE COULD HAVE#
	networkMn=$(ipcalc $userIP | grep "HostMin:" | awk '{print $2}')
	#SCANNING FOR DEVICES AND SAVING IT WITHIN A TEMP ARRAY#
	scanResult=$(sudo arp-scan -I ${interfaces[$i]} "$networkIP" --format='${ip}\t${mac}')
	#HOLDING FOUND IPs, MACs, AND THE NETWORK TYPE#
	IPs=()
	MACs=()
	type=$(echo "$scanResult" | grep -oE 'type:+ [[:alnum:]]+' | awk '{print $2}')
	#HOLDING THE IPs WITHIN A TEMP ARRAY TO CHECK IF IT'S NEEDED#
	temp=($(echo "$output" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $1}'))
	#LOOPING THROUGH THE IPs#
	for i in ${!temp[@]}; do
		#CHECKING TO SEE IF THE IP IS THE USER OR NETWORK MIN#
		if [[ $(echo "${temp[$i]}" | awk '{print $1}') != $(echo "$(ip a | grep 'inet' | grep 'brd' | awk '{print $2}' | awk -F '[/]' '{print $1}')") && $(echo "${temp[$i]}" | awk '{print $1}') != $(echo "$(ip a | grep 'inet' | grep 'brd' | awk '{print $2}' | awk -F '[/]' '{print $1}')" | awk "HostMin:" | awk '{print $2}')  ]]; then
			#THE IP IS NEITHER, SO IT GETS ADDED#
			IPs+=("${temp[$i]}")
		fi
	done
	#HOLDING THE MACs WITHIN A TEMP ARRAY TO CHECK IF IT'S NEEDED#
	temp=($(echo "$output" | grep -oE "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}"))
	#LOOPING THROUGH THE MACs#
	for i in ${!temp[@]}; do
		#CHECKING TO SEE IF THE MAC ADDRESS IS THE USER'S#
		if [[ $(echo "${temp[$i]}") != $(echo "$(ifconfig ${interfaces[$i]} | grep -oE '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')") ]]; then
			#IT ISNT AND GETS ADDED#
			MACs+=($("${temp[$i]}"))
		fi
	done
	echo "Interface: ${interfaces[$i]}"
	echo "IPs found: ${IPs[@]}"
	echo "MACs found: ${MACs[@]}"
	echo ""
done
