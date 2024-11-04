#!/bin/bash

# Common QEMU options for all bases.
_LVM_QEMU_OPTIONS_COMMON=(
	"-d guest_errors"
	"-sandbox on,obsolete=deny,spawn=deny,resourcecontrol=deny"
)
