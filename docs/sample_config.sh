#!/bin/bash

# This is a sample configuration file to get most stuff filled out, to use
# as a basis for new VM configurations.

# Source core lilyvm scripts
VM_ROOT="/home/lily/vms"
. ${VM_ROOT}/lib/devices.sh

VM_NAME="sample"
VM_BASE="q35-modern" # this defines what base to use. "q35-modern" should probably be preferred for modern guests.

# this is where lilyvm expects data for the vm to be.
# It's probably a good idea to use this, and to only deviate if using
# raw block devices/LVM in your configuration (in which case it's unavoidable).
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
	
	# Assorted QEMU options can also be stuck in here.
	"-device usb-tablet"
);

. ${VM_ROOT}/lib/core.sh
