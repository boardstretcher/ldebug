#!/bin/sh

##[ ./ldebug.sh
##[
##[ A simple information gathering tool for sharing system info with others
##[ on forums, email etc...

# Global Variables
##############################################
MINARGS=1
US_DATE=$(date +%d%m%Y)
EU_DATE=$(date +%Y%m%d)
TMPFILE=$(mktemp /tmp/myfile.XXXXX)

# Functions
##############################################
output(){
	# print out a section header
	printf "\n\n"
	printf "%s #################### \n" "$1"
}

obfuscate(){
	echo obfuscate function
	# To do:
	# take public IP addresses from output and rename to IP-ADD-01, IP-ADD-02 etc..
	# take public hostnames and obfuscate to something like HOST01, HOST02 etc..
}

get_general(){
	# general system information
	output VERSION
	cat /proc/version
	output Memory
	free -m
	vmstat
	output CPU
	grep '^proc\|^model\|^cpu' /proc/cpuinfo
	cat /proc/loadavg
}

get_hardware(){
	# general hardware information
	output Modules
	lsmod
	output PCI
	lspci
	output USB
	lsusb
}

get_storage(){
	# general storage information
	output DF
	df -h
	output FSTAB
	cat /etc/fstab	
	output MOUNTS
	cat /proc/mounts
	output BLKID
	blkid
	ouput LSBLK
	lsblk
}

get_lvm(){
	# more specific LVM related information
	output PVDISPLAY
	pvdisplay
	output PVS
	pvs
	output LVS
	lvs
	output VGS
	vgs
}

get_fw(){
	# firewall information (iptables, firewalld)
	output IPTABLES STATUS
	systemctl status iptables
	service iptables status
	output FIREWALLD STATUS
	systemctl status firewalld
	firewall-cmd --state
	output IPTABLES RULES
	iptables -L
	output FIREWALLD RULES
	firewall-cmd --list-all
}

get_network(){
	# network information
	output ADAPTERS
	ip link
	output IPADDRESSES
	ip addr
	output ROUTING
	ip route
	output LISTENING
	netstat -tulpn
}

usage(){
	# print out a simple usage/help menu
cat << EOF
$0 [OPTIONS] 

EXAMPLE:
        ldebug.sh -s
                print information about BASIC system storage

OPTIONS:
	-f		get firewall info
	-g		get general info (ram,cpu,etc)
        -h              display script help
	-H		get general hardware info (modules,pci,usb)
	-l		get info about LVM system storage
	-n		get networking info
        -s              get info about BASIC system storage
	-Z		send to pastebin-like site and get shareable URL
EOF
}

# currently only uid 0 (root) is allowed to run this script
if [ "$(id -u)" -ne "0" ]; then
	printf "script must be run as root \n" 1>&2
	exit
fi

# if args empty then display usage and exit
if [ $# -lt $MINARGS ]; then usage; fi

# argument handling - standard examples
while getopts ":fghHlnsZ" opt; do
	case $opt in
		f)
		get_fw | tee -a "$TMPFILE"
		;;
		g)
		get_general | tee -a "$TMPFILE"
		;;
		h)  
		usage 
		;;
		H)
		get_hardware | tee -a "$TMPFILE"
		;;
		l)
		get_lvm | tee -a "$TMPFILE"
		;;
		n)
		get_network | tee -a "$TMPFILE"
		;;
		s)  
		get_storage | tee -a "$TMPFILE"
		;;
		Z)
		printf "\n\n\nCopy, Paste and Share this pastebin URL: \n"
		curl -F 'sprunge=<-' http://sprunge.us < cat "$TMPFILE"
		;;
		\?) 
		printf "unknown arg: -%s \n" "$OPTARG" 
		;;
	esac
done

printf "\n\n"
printf "US Date: %s \n" "$US_DATE"
printf "EU Date: %s \n" "$EU_DATE"
printf "NOTE: 'Command not found' and other ERRORS are common in the output. \n"

# clean temp file
rm -f "$TMPFILE"
