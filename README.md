## Chef Usage Instructions

**NOTE**: This document is work-in-progress and some edges in Chef may be still rough.  In case you encounter any difficulties following the steps below, please contact us on the S2E-Dev mailing list.

This repository contains all the scripts and libraries needed to operate Chef.  It contains both host and guest (symbolic VM) utilities, so you will need to clone it in both places.  This file documents the usage of the utilities by following the recommended Chef workflow.

From now on, we assume ``$CHEF_ROOT`` to be the root directory of the Chef installation, where all related repos are cloned and prepared (e.g., ``/home/ubuntu/chef``).

### Building the Chef-flavored S2E

This part is essentially covered by the [S2E installation instructions](https://github.com/dslab-epfl/s2e/blob/master/docs/BuildingS2E.rst). We recommend the following source layout:

1. Create a ``$CHEF_ROOT/s2e`` directory, then clone the Chef-flavored S2E repository in it:

        $ cd $CHEF_ROOT/s2e
        $ git clone https://github.com/dslab-epfl/s2e.git s2e -b chef
        
2. Create the ``build/`` directory and run the S2E Makefile inside it:

        $ cd $CHEF_ROOT/s2e
        $ mkdir build
        $ cd build
        $ ln -s ../s2e/Makefile
        $ make

### Preparing a Chef VM

The following steps illustrate how to create a Chef S2E virtual machine. 

1. In the ``$CHEF_ROOT/vm`` directory, create a new S2E raw disk image. 4 GB is the minimum size, but you may want to enlarge your capacity depending on your needs.  The VM will host all interpreters, their dependencies, the intermediate object files, and all testing targets, so you should provision enough space.

2. Download an i386 Debian installation image.  For example:

        wget http://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-7.4.0-i386-netinst.iso

3. Boot the VM, having mounted the Debian installation disk:

        $CHEF_ROOT/s2e-public/build/qemu-release/i386-softmmu/qemu-system-i386 chef_disk.raw -cpu pentium -net nic,model=pcnet -net user,hostfwd=tcp::1234-:4321 -serial stdio -enable-kvm -smp 4 -cdrom debian-7.4.0-i386-netinst.iso
        
4. Install the basic system (no extras), then reboot into the new system

5. Install additional packages:

        $ sudo apt-get install build-essential unzip git-core

   For building Python, you will also need:
   
        $ sudo apt-get install libssl-dev libsqlite3-dev libreadline-dev libz2-dev

* Dir structure:

        $CHEF_ROOT
        tools/
        s2e/ - Host only
         build/
         s2e/
        python/
         chef/
           build/
        lua/
         chef/
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
