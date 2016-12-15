#!/bin/bash 

##[ ./ldebug.sh
##[
##[ A simple information gathering tool for sharing system info with others
##[ on forums, email etc...

##############################
# Global Variables
################################################

# important global variables
MINARGS=1

# time and dates to construct filenames
US_DATE=$(date +%d%m%Y)
EU_DATE=$(date +%Y%m%d)
NOW=$(date +%H%M)

# Program paths
BLKID=$(which blkid)
CAT=$(which cat)
CURL=$(which curl)
DF=$(which df)
ECHO=$(which echo)
FIND=$(which find)
FREE=$(which free)
GREP=$(which grep)
LSBLK=$(which lsblk)
LVS=$(which lvs)
PING=$(which ping)
PS=$(which ps)
PVDISPLAY=$(which pvdisplay)
PVS=$(which pvs)
RM=$(which rm)
SSH=$(which ssh)
TCPDUMP=$(which tcpdump)
WGET=$(which wget)

##############################
# Functions
##############################################

function get_general(){
	$ECHO -e "\n\nMEMORY #######################"
	$FREE -m
	$ECHO -e "\n\nCPUINFO ######################"
	$CAT /proc/cpuinfo | $GREP '^proc\|^model\|^cpu'
}

function get_storage(){
	$ECHO -e "\n\nDF ###########################"
	$DF
	$ECHO -e "\n\nFSTAB #########################"
	$CAT /etc/fstab
        $ECHO -e "\n\nMOUNTS ########################"
        $CAT /proc/mounts
        $ECHO -e "\n\nBLKID #########################"
        $BLKID
	$ECHO -e "\n\nLSBLK ########################"
	$LSBLK
}

function get_lvm(){
	$ECHO -e "\n\nPVDISPLAY ####################"
	$PVDISPLAY
        $ECHO -e "\n\nPVS ###########################"
        $PVS
	$ECHO -e "\n\nLVS ###########################"
	$LVS
}

function only_run_as(){
	if [[ $EUID -ne $1 ]]; then
		$ECHO "script must be run as uid $1" 1>&2
		exit
	fi
}

function usage(){
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
EOF
}

# currently only uid 0 (root) is allowed to run this script
only_run_as 0

# if args empty then display usage and exit
if [[ $# -lt $MINARGS ]]; then usage; fi

# argument handling - standard examples
while getopts ":ghls" opt; do
	case $opt in
		g)
		get_general
		;;
		h)  
		usage
		;;
		l)
		get_lvm
		;;
		s)  
		get_storage
		;;
		\?) 
		$ECHO "unknown arg: -$OPTARG" 
		;;
	esac
done
