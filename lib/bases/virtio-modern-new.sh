#!/bin/bash

# Generic setup for modern virtual machines,
# using as much virtio-scsi and hypervisor enlightments as possible to improve performance.

# You can assign to this variable if using a custom QEMU binary,
# and we'll obey it. (TODO: Put in core.sh?)
if [ -z "$VM_QEMU" ]; then
	VM_QEMU="qemu-system-x86_64"
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

VM_QEMU_ARGS="
    -nodefaults
    -name $VM_NAME,process=$VM_NAME
    -M q35,accel=kvm,kernel_irqchip=on,hpet=off,acpi=on
    -rtc base=localtime,clock=vm
    ${VM_DEVICES[@]}
    $VM_MONITOR
    $VM_DISPLAY"
