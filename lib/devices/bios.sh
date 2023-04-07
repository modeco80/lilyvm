#!/bin/bash

# BIOS/UEFI options

Uefi() {
	echo "
		-drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF_CODE.fd
		-drive if=pflash,format=raw,file=${VM_DATA_ROOT}/vars.fd
	";
}

BiosBoot() {
	local MENU_STR=""

	if [[ "$1" == "" ]]; then
		echo "error in BiosBoot: order must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "menu" ]]; then
		MENU_STR=",menu=on"
	fi
	
	echo "-boot order=$1${MENU_STR}"
}
