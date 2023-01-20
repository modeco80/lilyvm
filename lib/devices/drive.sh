#!/bin/bash

# Functions to generate QEMU drive stuff.

# $1 - id
# $2 - drive device name (see QEMU `-device help` if you need help) 
# $3 - path to image (or bdev)
# (optional onwards)
# $4 - cache
# $5 - format (raw for raw files or block devices)
HdDrive() {
	local FORMAT_STR="";
	local CACHE_STR="";
	
	if [[ "$1" == "" ]]; then
		echo "error in MakeHdDrive: ID must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "" ]]; then
		echo "error in MakeHdDrive: Drive type must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$3" == "" ]]; then
		echo "error in MakeHdDrive: Path to file or bdev must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	# Optional arguments
	if [[ ! "$4" == "" ]]; then
		CACHE_STR="cache=$4";
	fi
	
	if [[ ! "$5" == "" ]]; then
		FORMAT_STR="format=$5";
	fi
	
	echo "
		-drive if=none,file=$3,$CACHE_STR,discard=unmap,$FORMAT_STR,aio=io_uring,id=$1_drive
		-device $2,id=$1,drive=$1_drive
	";
}

# $1 - id
# $2 - drive device name (see QEMU `-device help` if you need help) 
CdDrive() {
	if [[ "$1" == "" ]]; then
		echo "error in MakeCdDrive: ID must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "" ]]; then
		echo "error in MakeCdDrive: Drive type must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	echo "
		-drive if=none,media=cdrom,aio=io_uring,id=$1
		-device ide-cd,drive=$1,id=$1_drive
	";
}

# A dumb testcase

# Test=(
#	"$(MakeHdDrive vm.hda scsi "/dev/VMGroup/xpvol" "none" "raw")"
# )

# for i in $(seq 0 $((${#Test[@]}-1))); do
# 	echo "drive $i : ${Test[i]}";
# done
