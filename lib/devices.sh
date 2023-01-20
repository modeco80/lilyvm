#!/bin/bash

# Source all the device functions into a config file.

. ${VM_ROOT}/lib/devices/bios.sh
. ${VM_ROOT}/lib/devices/cpu.sh
. ${VM_ROOT}/lib/devices/drive.sh
. ${VM_ROOT}/lib/devices/display.sh
. ${VM_ROOT}/lib/devices/net.sh
. ${VM_ROOT}/lib/devices/ram.sh