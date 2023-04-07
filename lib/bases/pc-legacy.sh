#!/bin/bash

# A setup for very legacy virtual machines.

# You can assign to this variable if using a custom QEMU binary,
# and we'll obey it. (TODO: Put in core.sh?)
if [ -z "$VM_QEMU" ]; then
	VM_QEMU="/srv/collabvm/qemu/bin/qemu-system-x86_64"
fi

# Sane defaults for the QEMU monitor options
if [ -z "$VM_MONITOR_SOCKET" ]; then
	VM_MONITOR_SOCKET="/run/qemu/qemu-monitor-${VM_NAME}"
fi

if [ -z "$VM_MONITOR" ]; then
	VM_MONITOR="-monitor unix:${VM_MONITOR_SOCKET},server,nowait"
fi

if [ ! -z "$VM_QEMU_ARGS" ]; then
	echo "Invalid VM configuration (attempting to create VM_QEMU_ARGS)";
	exit 1;
fi

VM_QEMU_ARGS="-nodefaults
    -name $VM_NAME,process=$VM_NAME
    -machine pc,accel=kvm,kernel_irqchip=on,hpet=off,acpi=on,usb=on
    -rtc base=localtime,clock=vm
    ${VM_DEVICES[@]}
    $VM_MONITOR"
