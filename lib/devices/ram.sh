#!/bin/bash

# Functions to generate QEMU drive stuff.

# $1 - size

# $2... - "prealloc"
Memory() {
	if [[ "$1" == "" ]]; then
		echo "error in Memory: Memory must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	echo "-m $1"
	
	shift;
	
	while [[ ! "$1" == "" ]]; do
		case "$1" in
			prealloc)
				echo "-mem-prealloc"
			;;
			
			# I think there's a better way to do this
			# (future lily note: There is. -object memory-backend-file
			# then -machine memory-backend=backendID)
			/*)
				echo "-mem-path $1"
			;;
		
			*)
				echo "error in Memory: Unrecognized thing $1" >/dev/stderr;
				exit 1;
			;;
		esac
		shift;
	done
}

# A dumb testcase

#Test=(
#	"$(NetDev mynet tap hosttap1)"
#	"$(NetCard virtio-net-pci mynet "5a:96:13:37:ab:cd")"
#)

#for i in $(seq 0 $((${#Test[@]}-1))); do
# 	echo "device $i : ${Test[i]}";
#done
