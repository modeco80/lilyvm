#!/bin/bash

# Generic setup for modern virtual machines,
# using as much virtio-scsi and hypervisor enlightments as possible to improve performance.

# Device listings created by these arguments:
#
# vm.net     - virtio network card
# vm.vioscsi - virtio scsi controller
# vm.hda
# vm.cd      - Crash cart cd (basically)

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
    $VM_MEMORY
    -cpu host,hv_relaxed,hv_frequencies,hv_vpindex,hv_ipi,hv_tlbflush,hv_spinlocks=0x1fff,hv_synic,hv_runtime,hv_time,hv_stimer,hv_vendor_id=qemu,kvm=off
    -smp cores=$VM_CORES
    -device qemu-xhci,p2=4,p3=4,id=vm.xhci

    -device ioh3420,id=vm.pcie_root,slot=0,bus=pcie.0

    -object iothread,id=vm.block_thread

    $VM_LAN_NETDEV
    $VM_LAN_CARD

    -device virtio-scsi-pci,num_queues=$VM_CORES,iothread=vm.block_thread,id=vm.vioscsi

    -drive if=none,file=$VM_HDA_DISK,cache=$VM_HDA_CACHE,discard=unmap,format=$VM_HDA_FORMAT,aio=$VM_HDA_AIO,id=vm.hda_drive
    -device scsi-hd,id=vm.hda,rotation_rate=1,drive=vm.hda_drive

    -drive if=none,id=vm.cd
    -device ide-cd,drive=vm.cd,id=vm.cd_drive

    $VM_ADDL_OPTIONS
    $VM_UEFI
    $VM_MONITOR
    $VM_BOOT_ORDER
    $VM_DISPLAY"
