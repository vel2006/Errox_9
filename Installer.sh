#!/bin/bash
distro=$(lsb_release -a | grep -E 'Distributor ID:' | awk '{print $3}')
if [[ $distro == "Kali" || $distro == "Debian" || $distro == "Ubuntu" ]]; then
	if ! dpkg -l | grep -q 'arp-scan'; then
		sudo apt install arp-scan
	fi
	if ! dpkg -l | grep -q 'ifconfig'; then
		sudo apt install ifconfig
	fi
	if ! dpkg -l | grep -q 'ipcalc'; then
		sudo apt install ipcalc
	fi
elif [[ $distro == "Fedora" || $distro == "CentOS" ]]; then
	if ! rpm -q arp-scan &>/dev/null; then
		sudo dnf install arp-scan
	fi
	if ! rpm -q ifconfig &>/dev/null; then
		sudo dnf install ifconfig
	fi
	if ! rpm -q ipcalc &>/dev/null; then
		sudo dnf install ipcalc
	fi
elif [[ $distro == "Arch" ]]; then
	if ! pacman -Qq arp-scan &>/dev/null; then
		sudo pacman -S arp-scan
	fi
	if ! pacman -Qq ifconfig &>/dev/null; then
		sudo pacman -S ifconfig
	fi
	if ! pacman -Qq ipcalc &>/dev/null; then
		sudo pacman -S ipcalc
	fi
else
	echo "Your current distro either isnt supported, or the dev has made a mistake"
fi
