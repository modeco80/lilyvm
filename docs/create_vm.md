# Creating a VM

First, copy the `sample.sh` file in configs/ to a new .sh file. 
Keep note of what you name the file; the basename will be important later.

Edit the file to your liking; after you have done so it's pretty much ready

# Setting up service

The `qemuvm@` service is a template service; so we don't need to worry much about it, but
the service should have a override which configures cgroup resource limits, to limit resources
properly.

Run `systemctl edit qemuvm@[name]`, and add the following lines (where it tells you); with appropriate substitutions for
your configuration, of course.

```systemd

[Service]

CPUQuota={CPUMAX}%

MemoryHigh={MEMSIZE}
MemoryMax={MEMSIZE}

```

{CPUMAX} is ideally (100 * the number of vCPUs you have assigned to the vm); more or less is also fine.

{MEMSIZE} is the configured memory size; you can change MemoryHigh/MemoryMax to your liking.

You may optionally add `AllowedCPUs` to pin the VM to certain CPUs.
Really, you can add anything here that doesn't change the start or stop commands.

## Common operations on your VM

Some common operations that can be done on VMs using the system are:

### Starting

`systemctl start qemuvm@[name]`

### Stopping

`systemctl stop qemuvm@[name]`

### Accessing the QEMU monitor

`[vm dir]/configs/[name] monitor`

**NOTE**: Also, if you accidentally keep a monitor connection open the VM will force stop when stopping, which is a data loss risk.

### Accessing the graphical console of the VM

`vncviewer :[console_desktop_number]`

**NOTE**: This requires the configuration to have a `-vnc` in `$VM_DISPLAY`; and not have any `-nographic`.

# Starting VM on boot

To start a VM on boot, just enable the qemuvm@[name] service for the VM you want to start on boot. 

It will then start on boot like you expect.

### Running commands on the QEMU monitor

`[vm config file] monitor "[monitor command]"`
