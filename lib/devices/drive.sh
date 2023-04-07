#!/bin/bash

# Functions to generate QEMU drive stuff.

_LVM_AIO="threads" # nvm 6.1 lts io_uring is still fucked...
#io_uring once we get 6.x

# this is in format [base] [burst]
# Feel free to overwrite this in configuration
LVM_DISK_LIMIT_BPS="$(MB 50) $(MB 65)"
LVM_DISK_LIMIT_IOPS="1250 1500"

# generate LVM disk limits
_GenerateLVMDiskLimit() {
 	local BPS=($LVM_DISK_LIMIT_BPS); # For both of these: 0 - base, 1 - burst
	local IOPS=($LVM_DISK_LIMIT_IOPS);
	echo "group=lvm,bps_rd=${BPS[0]},bps_wr=${BPS[0]},bps_rd_max=${BPS[1]},bps_wr_max=${BPS[1]},iops_rd=${IOPS[0]},iops_wr=${IOPS[0]},iops_rd_max=${IOPS[1]},iops_wr_max=${IOPS[1]}"
}


# $1 - id
# $2 - drive device name (see QEMU `-device help` if you need help) 
# $3 - path to image (or bdev)
# (optional onwards)
# $4 - cache
# $5 - format (raw for raw files or block devices)
# $6 - ssd
HdDrive() {
	local FORMAT_STR="";
	local CACHE_STR="";
	local SSD_HACK="";
	
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

	if [[ "$6" == "ssd" ]]; then
		SSD_HACK=",rotation_rate=1"
	fi
	
	echo "-drive if=none,file=$3,$CACHE_STR,discard=unmap,$FORMAT_STR,aio=$_LVM_AIO,id=$1_drive,$(_GenerateLVMDiskLimit) -device $2,id=$1${SSD_HACK},drive=$1_drive";
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

	if [[ "$VM_BASE" == *q35* ]]; then	
		echo "-drive if=none,media=cdrom,aio=$_LVM_AIO,id=$1 -device ide-cd,drive=$1,bus=ide.2,id=$1_drive";
	else
		echo "-drive if=none,media=cdrom,aio=$_LVM_AIO,id=$1 -device ide-cd,drive=$1,id=$1_drive";
	fi
}

# A dumb testcase

# Test=(
#	"$(MakeHdDrive vm.hda scsi "/dev/VMGroup/xpvol" "none" "raw")"
# )

# for i in $(seq 0 $((${#Test[@]}-1))); do
# 	echo "drive $i : ${Test[i]}";
# done
