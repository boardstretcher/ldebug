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

get_general(){
	# general system information
	output Memory
	free -m
	vmstat
	output CPU
	grep '^proc\|^model\|^cpu' /proc/cpuinfo
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

usage(){
	# print out a simple usage/help menu
cat << EOF
$0 [OPTIONS] 

EXAMPLE:
        ldebug.sh -s
                print information about BASIC system storage

OPTIONS:
	-g		get general info (ram,cpu,etc)
        -h              display script help
	-H		get general hardware info (modules,pci,usb)
	-l		get info about LVM system storage
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
while getopts ":ghHlsZ" opt; do
	case $opt in
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

# clean temp file
rm -f "$TMPFILE"
