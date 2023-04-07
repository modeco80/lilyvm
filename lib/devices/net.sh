#!/bin/bash

# Functions to generate QEMU drive stuff.

# $1 - id
# $2 - type
# $3 - (optional in most cases) host device to attach to/etc...
NetDev() {
	if [[ "$1" == "" ]]; then
		echo "error in NetDev: ID must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "" ]]; then
		echo "error in NetDev: Netdev type must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	case "$2" in
		user)
			echo "-netdev user,id=$1"
		;;
		
		tap)
			if [[ "$3" == "" ]]; then
				echo "error in NetDev: Taps require the tap, duh!" >/dev/stderr;
				exit 1;
			fi
			echo "-netdev tap,ifname=$3,vhost=on,script=no,downscript=no,id=$1"
		;;
			
	
		*)
			echo "error in NetDev: Unrecognized type $2" >/dev/stderr;
			exit 1;
		;;
	esac
}

# $1 - id
# $2 - network card type
# $3 - id of netdev
# $4 - MAC of nic (optional, in most cases.)
NetCard() {
	local MAC_STR="";
	
	if [[ "$1" == "" ]]; then
		echo "error in NetCard: ID must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "" ]]; then
		echo "error in NetCard: Network card type must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$3" == "" ]]; then
		echo "error in NetCard: Network card needs a netdev" >/dev/stderr;
		exit 1;
	fi
	
	
	if [[ ! "$4" == "" ]]; then
		MAC_STR=",mac=$4"
	fi
	
	echo "-device $2,id=$1,netdev=$3${MAC_STR}";
}

# A dumb testcase

#Test=(
#	"$(NetDev mynet tap hosttap1)"
#	"$(NetCard virtio-net-pci mynet "5a:96:13:37:ab:cd")"
#)

#for i in $(seq 0 $((${#Test[@]}-1))); do
# 	echo "device $i : ${Test[i]}";
#done
