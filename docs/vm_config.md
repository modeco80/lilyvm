# VM Configuration Reference

This is a reference on what every (public) LilyVM configuration knob and device does.

This is largely TODO, but I'm writing it now just for nicity.

## `VM_ROOT`

This defines the root path to the LilyVM scripts. A config will usually declare this as soon as possible.

## `VM_NAME`

This defines the name of the VM

## `VM_BASE`

This defines what "base" the VM will use. A base provides QEMU options to set the machine type and maybe some other platform-specific ones.

## `VM_QEMU`

This defines what QEMU binary should be used.

## `VM_MONITOR`

A bit of a hack, this provides the -monitor arg to qemu. VM scripts intended to be used on CollabVM will set this to nothing because a seperate (or stdio) monitor isn't needed.

## `VM_DATA_ROOT`

This defines the path to where VM data should be located. This is used by some device functions

## `VM_DEVICES`

This defines all the devices for the VM.

## `_LVM_HAS_EDIDFILE_PATCH`

This is a boolean used internally to support a internal QEMU patch which allows providing EDID data as a file.

## `_LVM_AIO`

The AIO that QEMU will use. Default is `io_uring`, since it has worked well for considerable time.

## `LVM_DISK_LIMIT_ENABLE`

Determines whether or not to enable disk limiting. Default true.

## `LVM_DISK_LIMIT_BPS`

Provides the disk limit bandwidth in bytes per second. The value is actually two values, the base and a burst.

The SI functions can be used to make this easier to understand.

## `LVM_DISK_LIMIT_IOPS`

Provides the disk limit IOPS. Same format as `LVM_DISK_LIMIT_BPS`, the first value is base and the second is burst.

## `LVM_DISK_LIMIT_IOPS_SIZE`

Provides `iops_size` to QEMU. Default is 0 (to let qemu decide it, same as if the option was not specified)

# Functions

LilyVM comes with some helper functions.

## `Kb`, `Mb`, `Gb`, `KB`, `MB`, `GB`

These functions scale a given value in their respective SI unit to bytes.

E.g: $(Gb 1) will output one gibibyte scaled to bytes.

# Devices

Devices slightly abstract the QEMU command line options to be a bit less of a pain.

## `Uefi` & `UefiReadWrite`

Enables OVMF UEFI bios, instead of QEMU's default seabios. The `OVMF_VARS.fd` file is expected to be copied to `${VM_DATA_ROOT}/vars.fd`.

UefiReadWrite allows write access to the OVMF firmware. The utility of this is probably dubious, but it's there.

## `BiosBoot`

Configures BIOS boot options. First argument is the boot order, and the second argument can optionally be "menu" to enable the boot menu

## `CPU`

Configures CPU options.

The first argument is the CPU model.

The second argument is the core count.

The third argument is used to determine if LilyVM should pin the CPU cores to host CPU cores. This option is largely deprecated since it's possible to just do this by putting the vCPU threads into cgroups with a cpuset controller configured to run on a given core.

The fourth final option determines extra options for hypervisor enlightenments.

## `Memory`

Configures memory.

The first argument is the memory size.

Optionally, "prealloc" can be put after the size to request preallocation.

## `DisplayAdapter`

Provides a display adapter.

The first argument is the ID of the device.

The second argument is the device type.

| Type     | Detailed Model |
|----------|----------------|
| `vga`    | QEMU std-vga   |
| `cirrus` | Cirrus GD5446  |
| `vmware` | VMware SVGA-II |
| `qxl`    | QEMU QXL       |

## `Display`

Defines a display. The first argument is a type. For VNC, the second argument is the listen address.

Type can be:
- gtk (GTK display)
- sdl
- vnc

## `HdDrive`

Defines a disk drive.

The first argument is the ID of the drive.

The second argument is the drive type.

The third argument is the path to a image (or block device).

The fourth argument is optional and configurs the cache.

The fifth argument is optional and forces a particular format.

The sixth argument is optional, if it is "ssd" then this drive gets options set to treat it like a SSD.

## `CdDrive`

Defines a CD drive.

The first argument is the ID of the drive.

The second argument was originally for configuring the drive type, but it is not used anymore.

## `NetDev`

Defines a network device.

The first argument is the ID.

The second argument is the type. Currently this only accepts "user" or "tap".

In the case of "tap" the third argument is the tap.

## `NetCard`

Defines a network card.

The first argument is the ID.

The second argument is the network card type.

The third argument should be the ID of a previously declared netdev.

The fourth argument is optional, and sets the MAC address of the network card.

