#!/bin/bash


# $1 - model
# $2 - core count
# $3 - should pin
# $4 - rest of options
CPU() {
	if [[ "$1" == "" ]]; then
		echo "error in CPU: Model must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$2" == "" ]]; then
		echo "error in CPU: Core count must be filled out" >/dev/stderr;
		exit 1;
	fi
	
	if [[ "$3" == "" ]]; then
		echo "error in CPU: need to know if Core should pin :V" >/dev/stderr;
		exit 1;
	fi
	
	VM_PIN_VCPU_THREADS=$3;
	local EXTRA_OPTS="$4"
	
	# Eghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh;;;
	[[ "$VM_BASE" == *"q35"* ]] &&  EXTRA_OPTS="${EXTRA_OPTS},hv_vendor_id=qemu"
	
	echo "
		-cpu $1,$EXTRA_OPTS
		-smp cores=$2
	"
}
