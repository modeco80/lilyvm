#!/bin/bash

# Functions to generate QEMU drive stuff.

# $1 - id
# $2 - type
DisplayAdapter() {
	local FORMAT_STR="";
	local CACHE_STR="";
	
	if [[ "$1" == "" ]]; then
		echo "error in DisplayAdapter: ID must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "" ]]; then
		echo "error in DisplayAdapter: Adapter type must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	case "$2" in
		vga)
			echo "-device VGA,id=$1"
		;;
		
		qxl)
			echo "-device qxl,id=$1"
		;;
	
		*)
			echo "error in DisplayAdapter: Unrecognized type $2" >/dev/stderr;
			exit 1;
		;;
	esac
}

# $1 - type
# $2 - (vnc only) listen address
Display() {
	local MAC_STR="";
	
	if [[ "$1" == "" ]]; then
		echo "error in Display: Type must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	
	case "$1" in
		gtk)
			echo "-display gtk"
		;;
		
		sdl)
			echo "-display sdl"
		;;
		
		vnc)
			if [[ "$2" == "" ]]; then
				echo "error in Display: VNC display requires listen address" >/dev/stderr;
				exit 1;
			fi
			echo "-vnc $2"
		;;
			
	
		*)
			echo "error in Display: Unrecognized type $2" >/dev/stderr;
			exit 1;
		;;
	esac
}

# A dumb testcase

#Test=(
#	"$(NetDev mynet tap hosttap1)"
#	"$(NetCard virtio-net-pci mynet "5a:96:13:37:ab:cd")"
#)

#for i in $(seq 0 $((${#Test[@]}-1))); do
# 	echo "device $i : ${Test[i]}";
#done
