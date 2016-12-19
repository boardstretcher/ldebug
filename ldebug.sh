#!/bin/bash 

##[ ./ldebug.sh
##[
##[ A simple information gathering tool for sharing system info with others
##[ on forums, email etc...

# Global Variables
##############################################
MINARGS=1
US_DATE=$(date +%d%m%Y)
EU_DATE=$(date +%Y%m%d)
NOW=$(date +%H%M)
TMPFILE=$(mktemp /tmp/myfile.XXXXX)

# Functions
##############################################
function output(){
	# print out a section header
	echo -e "\n\n"
	echo -e "$1 ####################"
}

function get_general(){
	# general system information
	output Memory
	free -m
	vmstat
	output CPU
	cat /proc/cpuinfo | grep '^proc\|^model\|^cpu'
}

function get_storage(){
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

function get_lvm(){
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

function usage(){
	# print out a simple usage/help menu
cat << EOF
$0 [OPTIONS] 

EXAMPLE:
        ldebug.sh -s
                print information about BASIC system storage

OPTIONS:
	-g		get general info (ram,cpu,etc)
        -h              display script help
	-l		get info about LVM system storage
        -s              get info about BASIC system storage
	-Z		send to online pastebin and get shareable URL
EOF
}

# currently only uid 0 (root) is allowed to run this script
if [[ $EUID -ne 0 ]]; then
	echo "script must be run as root" 1>&2
	exit
fi

# if args empty then display usage and exit
if [[ $# -lt $MINARGS ]]; then usage; fi

# argument handling - standard examples
while getopts ":ghlsZ" opt; do
	case $opt in
		g)
		get_general | tee -a $TMPFILE
		;;
		h)  
		usage 
		;;
		l)
		get_lvm | tee -a $TMPFILE
		;;
		s)  
		get_storage | tee -a $TMPFILE
		;;
		Z)
		echo -e "\n\n\nCopy, Paste and Share this pastebin URL: "
		cat $TMPFILE | curl -F 'sprunge=<-' http://sprunge.us
		;;
		\?) 
		echo "unknown arg: -$OPTARG" 
		;;
	esac
done

# clean temp file
rm -f $TMPFILE
