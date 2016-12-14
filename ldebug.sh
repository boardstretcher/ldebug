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
ECHO=$(which echo)
FIND=$(which find)
GREP=$(which grep)
PING=$(which ping)
PS=$(which ps)
PVS=$(which pvs)
RM=$(which rm)
SSH=$(which ssh)
TCPDUMP=$(which tcpdump)
WGET=$(which wget)

##############################
# Functions
##############################################

function get_storage(){
        $ECHO -e "\n\nMOUNTS ########################"
        $CAT /proc/mounts
        $ECHO -e "\n\nBLKID #########################"
        $BLKID
        $ECHO -e "\n\nPVS ###########################"
        $PVS
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
                print information about the system storage

OPTIONS:
        -h              display script help
        -s              print information about system storage
EOF
}

# currently only uid 0 (root) is allowed to run this script
only_run_as 0

# if args empty then display usage and exit
if [[ $# -lt $MINARGS ]]; then usage; fi

# argument handling - standard examples
while getopts ":hs" opt; do
        case $opt in
                h)
                usage
                ;;
                s)
                get_storage
                ;;
                \?)
                $ECHO "unknown arg: -$OPTARG"
                ;;
        esac
done
