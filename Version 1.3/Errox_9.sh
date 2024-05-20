#!/bin/bash
echo " _________________ _______   __  _____ "
echo "|  ___| ___ \ ___ \  _  \ \ / / |  _  |"
echo "| |__ | |_/ / |_/ / | | |\ V /  | |_| |"
echo "|  __||    /|    /| | | |/   \  \____ |"
echo "| |___| |\ \| |\ \\\\ \_/ / /^\ \ .___/ /"
echo "\____/\_| \_\_| \_|\___/\/   \/ \____/"
echo "Version: 1.3"
echo ""
if [[ $1 != "-h" && $1 != 1 && $1 != 2 && $1 != 3 ]]; then
	echo "Error, unknown first argument: $1"
	echo "Use '-h' as first argument for help"
	exit
elif [[ $2 != "s" && -n $2 ]]; then
	echo "Error, unknown second argument: $2"
	echo "Use '-h' as first argument for help"
	exit
elif [[ $(whoami) != "root" ]]; then
	echo "Error, please run this script as root."
 	exit
fi
if [[ $1 == "-h" ]]; then
	echo "Hello user. Errox_9 is a very simple yet diverse script, this is the 1.3 version, which has some needed changes to 1.2."
	echo "Errox_9 1.3 has added these features:"
	echo "    1) arping and ping methods are much faster"
	echo "    2) holding data from the ping and arping methods within a temp file that gets deleted at end of the script"
	echo "    3) Adds slow mode, where the script runs slower for less stress on computer"
	echo ""
	echo "Here is how to use Errox_9 in its 1.3 version:"
	echo "    1) Use sudo when running Errox_9"
	echo "    2) Select the type you wish to use:"
	echo "        ~) Version 1 uses arping in parallel meaning"
	echo "        !) Version 2 uses ping in parallel, then accessing the data held by 'arp' to get mac addressesg"
	echo "        @) Version 3 uses arp-scan"
	echo "    3) Decide if you want to run in slow mode for versions 1/2 (recommended)"
	echo "        ~) If you wish to, set the second argument to 's'"
	echo "    3) Format like this: 'sudo ./Errox_9.sh [1-3] [s]' and let Errox_9 do the rest for you"
	echo ""
	echo "Hardware and its speed with one host on network in slow mode:"
	echo "     ____________________________________________________________"
	echo "    |        Hardware        | Version 1 | Version 2 | Version 3 |"
	echo "    |------------------------|-----------|-----------|-----------|"
	echo "    |  2 core CPU & 2GB RAM  |   54 sec  |   45 sec  |   2 sec   |"
	echo "    |  3 core CPU & 3GB RAM  |   40 sec  |   44 sec  |   2 sec   |"
	echo "    |  4 core CPU & 4BG RAM  |   49 sec  |   45 sec  |   2 sec   |"
	echo "    |  5 core CPU & 5GB RAM  |   45 sec  |   45 sec  |   2 sec   |"
	echo "    |  6 core CPU & 6GB RAM  |   47 sec  |   46 sec  |   3 sec   |"
	echo "    |  7 core CPU & 7GB RAM  |   48 sec  |   46 sec  |   3 sec   |"
	echo "    |  8 core CPU & 8BG RAM  |   48 sec  |   46 sec  |   3 sec   |"
	echo "    |  9 core CPU & 9GB RAM  |   49 sec  |   67 sec  |   3 sec   |"
	echo "    | 10 core CPU & 10GB RAM |   49 sec  |  126 sec  |   2 sec   |"
	echo "    |____________________________________________________________|"
	echo ""
	echo "Support the creator at:"
	echo "    vel2006 on github"
	echo "    that1ethicalhacker on youtube"
	echo ""
	echo "Happy pentesting."
	exit
fi
#-MAKING ARPING METHOD FOR PARALLEL-#
arpingIP()
{
	local temp=$(arping -c 1 -w 1 -I $1 $2)
	if [[ $(echo "$temp" | grep -E "[[:xdigit:]]+:[[:xdigit:]]+:") ]]; then
		sudo echo $(echo "$temp" | grep -E "from +" | awk '{print $4}')%$2 >> "$3"
	fi
}
#-MAKING PING METHOD FOR PARALLEL-#
pingIP()
{
	local temp=$(ping -c 1 -s 5 -W 5 -I $1 $2)
	echo "$(arp -a)" | while IFS= read -r line; do
		if [[ $(echo "$line" | grep -E "$2") && $(echo "$line" | grep -E "[[:xdigit:]][[:xdigit:]]:") ]]; then
			sudo echo $(echo "$line" | grep -oE "[[:xdigit:]][[:xdigit:]]:[[:xdigit:]][[:xdigit:]]:[[:xdigit:]][[:xdigit:]]:[[:xdigit:]][[:xdigit:]]:[[:xdigit:]][[:xdigit:]]:[[:xdigit:]][[:xdigit:]]")%$2 >> "$3"
		fi
	done
}
touch tempFile
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
	if [[ $# -ge 1 ]]; then
		if [[ $1 == 1 ]]; then
			echo "Starting paralell scan"
			#STARTING THE arping_ip METHOD ON 255 DIFFERENT SUBSHELLS#
			for (( j = 1; j < 256; j++ )); do
				arpingIP ${interfaces[$i]} $base$j "$(pwd)/tempFile" &
				#CHECKING TO SEE IF THE USER IS USING SLOW MODE#
				if [[ $2 == 's' ]]; then
					sleep 0.15
				fi
			done
			#WAITING FOR THE SUBSHELLS TO END THEIR TASKS#
			wait
			#EXTRACTING DATA FROM THE TEMP FILE#
			echo "Information gathered, extracting from temp file"
			while read line; do
				IPs+=($(echo "$line" | awk -F '[%]' '{print $2}'))
				MACs+=($(echo "$line" | awk -F '[%]' '{print $1}'))
			done < "$(pwd)/tempFile"
			echo "Information extracted."
			#PRINTING OUT THE DATA#
			echo "Interface: ${interfaces[$i]}"
			echo "IPs: ${IPs[@]}"
			echo "MACs: ${MACs[@]}"
		elif [[ $1 == 2 ]]; then
			#CLEARING THE ARP CASHE FOR CLEAR READING#
			echo "Clearing ARP cashe for clear reading"
			toRemove=($(arp -v | awk '{print $1}' | grep -E "[0-9]+.[0-9]"))
			for j in ${!toRemove[@]}; do
				arp -d ${toRemove[$j]}
			done
			#STARTING THE ping_ip METHOD ON 255 DIFFERENT SUBSHELLS#
			echo "Cashe cleared, starting parallel scan"
			for (( j = 1; j < 256; j++ )); do
				pingIP ${interfaces[$i]} $base$j "$(pwd)/tempFile" &
				#CHECKING TO SEE IF THE USER IS USING SLOW MODE#
				if [[ $2 == 's' ]]; then
					sleep 0.15
				fi
			done
			#WAITING FOR THE SUBSHELLS TO END THEIR TASKS#
			wait
			#EXTRACTING DATA FROM THE TEMP FILE#
			echo "Information gethered, extracting from temp file"
			while read line; do
				IPs+=($(echo "$line" | awk -F '[%]' '{print $2}'))
				MACs+=($(echo "$line" | awk -F '[%]' '{print $1}'))
			done < "$(pwd)/tempFile"
			echo "Information extracted"
			#PRINTING OUT THE DATA#
			echo "Interface: ${interfaces[$i]}"
			echo "IPs: ${IPs[@]}"
			echo "MACs: ${MACs[@]}"
		elif [[ $1 == 3 ]]; then
			#SAVING THE OUTPUT OF arp-scan#
			scanResult=$(sudo arp-scan -I ${interfaces[$i]} --localnet --format='${ip}\t${mac}')
			#GETTING THE IPS FROM THE RESULT AND SAVING THEM IN AN ARRAY#
			temp=($(echo "$scanResult" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $1}'))
			for j in ${!temp[@]}; do
				#GETTING THE IP IF IT ISNT THE USER'S#
				if [[ $(echo "${temp[$j]}" | awk '{print $1}') != "$userIP" ]]; then
					IPs+=("${temp[$j]}")
				fi
			done
			#GETTING THE MAC ADDRESSES FROM THE RESULT AND SAVING THEM IN AN ARRAY#
			temp=($(echo "$scanResult" | grep -oE "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}"))
			for j in ${!temp[@]}; do
				#GETTING THE MAC IF IT ISNT THE USER'S#
				if [[ $(echo "${temp[$j]}") != "$userMAC" ]]; then
					MACs+=("${temp[$j]}")
				fi
			done
			#PRINTING OUT THE DATA#
			echo "Data collected"
			echo "Interface: ${interfaces[$i]}"
			echo "IPs: ${IPs[@]}"
			echo "MACs: ${MACs[@]}"
		fi
	fi
done
#-GETTING THE END TIME AND HOW LONG IT TAKES IN SECONDS-#
end=$(date +%s)
total=$((end - start))
sudoo rm "$(pwd)/tempFile"
echo "It took $total seconds to run this script"
