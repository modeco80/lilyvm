#!/bin/bash

# This is a sample configuration file to get most stuff filled out, to use
# as a basis for new VM configurations.

# Source core lilyvm scripts
VM_ROOT="/home/lily/vms"
. ${VM_ROOT}/lib/devices.sh

VM_NAME="sample"
VM_BASE="virtio-modern" # this defines what base to use. "virtio-modern" should probably be preferred,
						# but there are others (and you can write your own)

VM_DATA_ROOT="/mnt/data/vms/${VM_NAME}"

VM_DEVICES=(
	"$(CPU host 2 "no")" # no options

	"$(Memory 2G prealloc)"

	# Network
	"$(NetDev vm.net user)"
	"$(NetCard vm.netadp virtio-net-pci vm.net "5a:96:13:37:ab:cd")"
	
	# Storage
	"$(HdDrive vm.hda ide-hd "/path/to/image.qcow2")"
	"$(CdDrive vm.cd ide-cd)"
	
	# Display
	"$(DisplayAdapter vm.vga vga)"
	"$(Display vnc ":30")"
	
	"$(Uefi)"
	
	#
	"-device usb-tablet"
);

. ${VM_ROOT}/lib/core.sh
