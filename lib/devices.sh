#!/bin/bash

# Source all the device functions into a config file.

__size_common() {
	local sz=$1
	[[ "$sz" == "" ]] && sz=1;
	echo "$(($sz * $2))"
}


# SI Functions
Kb() {
	__size_common $1 "1024" 
}
Mb() {
	__size_common $1 "1024*1024" 
}
Gb() {
	__size_common $1 "1024*1024*1024" 
}
KB() { 
	__size_common $1 "1000" 
}
MB() { 
	__size_common $1 "1000*1000" 
}
GB() { 
	__size_common $1 "1000*1000*1000" 
}


. ${VM_ROOT}/lib/devices/bios.sh
. ${VM_ROOT}/lib/devices/cpu.sh
. ${VM_ROOT}/lib/devices/drive.sh
. ${VM_ROOT}/lib/devices/display.sh
. ${VM_ROOT}/lib/devices/net.sh
. ${VM_ROOT}/lib/devices/ram.sh
