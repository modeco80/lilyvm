#!/bin/bash

# core functions & main for vm configurations

# Execute a QEMU monitor command.
MonitorCommand() {
	echo $@ | ncat -U ${VM_MONITOR_SOCKET} >/dev/null 2>&1
}

MonitorCommandLoud() {
	echo $@ | ncat -U ${VM_MONITOR_SOCKET}
	# Add a newline for prettier output
	echo "";
}


# Generate a list of even numbers, in a format
# taskset(1) will accept
# $1 - Final value
# $2 - (optional) Start value
GenEvenNumList() {
	local START=0;
	[[ "$2" != "" ]] && START="$2";

	for i in $(seq $START $1); do
		if [ $(expr $i % 2) == 0 ]; then
			printf "$i";
			[[ $i != $1 && $i != $(expr $1 - 1) ]] && printf ',';
		fi
	done
}



# Try to connect to the monitor socket
# (to determine if the VM)
IsRunning() {
	MonitorCommand ""
}

# Shut the VM down
StopVM() {
	# Try to shut down the VM via ACPI.
	#
	# If this fails for some reason, systemd will have our back
	# and just kill the QEMU process hard
	#
	# (Though on other init systems; there won't be anything like that so we should timeout here too..)

	if IsRunning && MonitorCommand "system_powerdown"; then
		while IsRunning; do
			# Just for insurance's sake;
			MonitorCommand "system_powerdown"
			sleep 1
		done
	fi
}

# Boot the virtual machine up 
StartVM() {
	local BOOT_COMMAND="$VM_QEMU $VM_QEMU_ARGS"

	[[ $(type -t VMPreBootHook) == "function" ]] && VMPreBootHook
	
	if [ ! "$VM_PIN_VCPU_THREADS" == "no" ]; then
		taskset -ac $(GenEvenNumList $(nproc)) $BOOT_COMMAND $@
	else
		$BOOT_COMMAND $@
	fi
	
	[[ $(type -t VMPostShutdownHook) == "function" ]] && VMPostShutdownHook
}

Help() {
	echo "VMscript help: "
	echo "$0 start - start this VM (internal/init usage only)"
	echo "$0 stop - stop this VM (internal/init usage only)"
	echo "$0 help - display this help message"
	echo "$0 monitor [command] - exec QEMU monitor command (and display output)"
	echo "$0 commandpretty - (debug) display QEMU launch arguments"
}

# Source the base
. ${VM_ROOT}/lib/bases/${VM_BASE}.sh

# lame argument parsing
case "$1" in
	stop)
		StopVM
	;;

	start)
		shift; # remove the subcommand, rest is given to qemu
		StartVM $@
	;;

	help)
		Help
		exit 0;
	;;

	monitor)
		shift;
		MonitorCommandLoud "$@"
	;;

	commandpretty)
		echo "${VM_NAME} base is ${VM_ROOT}/lib/bases/${VM_BASE}.sh"
		echo "${VM_NAME} would launch as \"${VM_QEMU} ${VM_QEMU_ARGS}\"";
	;;

	command)
		echo "${VM_QEMU} ${VM_QEMU_ARGS}"
	;;

	# catch-all
	*)
		if [ "$1" == "" ]; then
			echo "Verb required";
			Help
			exit 0;
		else
			echo "Unknown verb \"$1\""
			Help
			exit 1;
		fi
	;;
esac
