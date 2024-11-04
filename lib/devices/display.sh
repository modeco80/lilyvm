#!/bin/bash

# Set to anything other than "true" to disable ",edidfile" (part of a internal QEMU patch).
# 
# For anyone else this is likely always false, as I haven't released
# that patch yet. (I'm only setting it to true here because I don't feel like
# touching 10+ lvm configs.)
_LVM_HAS_EDIDFILE_PATCH="true"

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
			if [[ "$_LVM_HAS_EDIDFILE_PATH" == "true" ]]; then
				echo "-device VGA,id=$1,edidfile=/srv/collabvm/edid.bin"
			else
				echo "-device VGA,id=$1"
			fi
		;;
		
		qxl)
			echo "-device qxl-vga,id=$1"
		;;

		cirrus)
			echo "-device cirrus-vga,id=$1"
		;;
		vmware)
			echo "-device vmware-svga,id=$1"
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
