Chef Usage Instructions
=======================

**NOTE**: This document is work-in-progress and some edges in Chef may
  be still rough.  In case you encounter any difficulties following
  the steps below, please contact us on the S2E-Dev mailing list.

The `chef/` folder in S2E contains all the scripts and libraries
needed to operate Chef.  This file documents their usage along
standard Chef workflows.


Preparing a Chef VM
-------------------

The following steps illustrate how to create a Chef S2E virtual machine:

1. In the `$CHEF_ROOT/vm` directory, create a new S2E raw disk
image. 4 GB is the minimum size, but you may want to enlarge your
capacity depending on your needs.  The VM will host all interpreters,
their dependencies, the intermediate object files, and all testing
targets, so you should provision enough space.

2. Download an i386 Debian installation image.  For example,
`wget http://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-7.4.0-i386-netinst.iso`.

* Grab Debian: http://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-7.4.0-i386-netinst.iso
* Run: $CHEF_ROOT/s2e-public/build/qemu-release/i386-softmmu/qemu-system-i386 chef_disk.raw -cpu pentium -net nic,model=pcnet -net user,hostfwd=tcp::1234-:4321 -serial stdio -enable-kvm -smp 4 -cdrom debian-7.4.0-i386-netinst.iso
* Install basic system (no extras). User/pwd: chef
* Packages: build-essential unzip git-core [ libssl-dev libsqlite3-dev libreadline-dev libz2-dev ] (for Python)

* Dir structure:
 ~/chef
   python-src/
   python-build/
   lua/
     build/
   


1. Create a standard S2E image called `chef_disk.raw` and place it in the `$CHEF_ROOT/vm/` directory.
2. Inside the image, checkout the Chef-adapted interpreter repository and install the interpreter according to its instructions.
3. Copy the `cmd_server.py` file on the image.
4. Run the `cmd_server.py` file inside the image, before saving the snapshot and running it in S2E mode.


Running a Chef VM
-----------------

(Work in progress)

Use the `run_qemu.py` script to run the VM.


Running the experiments in the Chef paper
-----------------------------------------

(Work in progress)
