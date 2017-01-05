# ldebug
Simple linux information gathering tool for troubleshooting

# purpose
Written in a simple bash script, easy to read, easy to understand what it is doing and how it is doing it. A fast way to gather information about your system in a readable format fit for sharing on Forums, IRC and Pastebins.

# downloading
With wget:
```
wget --no-check-certificate https://raw.githubusercontent.com/boardstretcher/ldebug/master/ldebug.sh
chmod 0755 ldebug.sh
```
With curl:
```
curl -o ldebug.sh https://raw.githubusercontent.com/boardstretcher/ldebug/master/ldebug.sh
chmod 0755 ldebug.sh
```
# running
if you have downloaded it:
```
./ldebug.sh <options>
```

if you want to run it from the repo:
```
curl https://raw.githubusercontent.com/boardstretcher/ldebug/master/ldebug.sh | bash -s -- <options>
```

# options
```
-f get firewall info(iptables,firewalld)
-g get general info (ram,cpu,etc)
-h display script help
-H get general hardware info (modules,pci,usb)
-l get info about LVM system storage
-n get networking info
-s get info about BASIC system storage
-Z send to pastebin-like site and get shareable URL
```
