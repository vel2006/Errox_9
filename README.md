# Errox_9

# MESSAGE FROM THE DEV!!!
## Errox_9 will be changing languages from Bash to Python on the 2.0 version update, it is in the testing stage (two of five for those who dont know my work flow) and will be online in around four weeks.

## Small note from the dev
Errox_9 is a bash script that uses tools to scan the user's local network for devices using arp-scan. The script is as quiet as I could make it within this first post and will be updated more than once unlike Errox_8. Errox_9 should be getting updated biweekly or so, with this time of the year bringing EOCs and other tests, the updates could take longer than expected.

### Errox_9 version
Version: 1.0
### Needed tools
1) arp-scan
2) ifconfig
3) ipcalc
4) ip
5) grep
6) awk

### First use
For the first time use of Errox_9 I would suggest using the Installer file, it is named 'Installer.sh' and will install all of the tools needed that are defined inside of the 'Needed tools' section. In the event that the tool doesnt work for your flavor/distro of Linux, install by hand and post it as a issue on 'https://github.com/vel2006/Errox_9'. 

### How to use
Errox_9 is a very user friendly script, but must be ran with sudo perms. You dont need to input any information for the script to work, in future updates that might change. As for now Errox_9 will print out everything it is doing for the user, when it is done Errox_9 will print out the interfaces used, IPv4s found, and MAC addresses found on the user's network. While Errox_9 has only been tested on a virtual ethernet network, it should have no issues running on a wireless network. In the even that it doesnt work, please submit it as an issue on 'https://github.com/vel2006/Errox_9'.

## Updates to come:
1) Faster scan time
2) More sneaky beaky like scanning
3) Option to use no external tools and instead use home made methods
4) Possible port scanning included
