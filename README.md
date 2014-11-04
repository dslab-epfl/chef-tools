## Chef Usage Instructions

**NOTE**: This document is work-in-progress and some edges in Chef may be still rough.  In case you encounter any difficulties following the steps below, please contact us on the S2E-Dev mailing list.

This repository contains all the scripts and libraries needed to operate Chef.  It contains both host and guest (symbolic VM) utilities, so you will need to clone it in both places.  This file documents the usage of the utilities by following the recommended Chef workflow.

From now on, we assume ``$CHEF_ROOT`` to be the root directory of the Chef installation, where all related repos are cloned and prepared (e.g., ``/home/ubuntu/chef``).  Similarly, ``$CHEF_GUEST_ROOT`` designates the root of the Chef setup inside the guest VM.

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

### Creating a Chef VM

The following steps illustrate how to create a Chef S2E virtual machine. 

1. In the ``$CHEF_ROOT/vm`` directory, create a new S2E raw disk image called ``chef_disk.raw``. 4 GB is the minimum size, but you may want to enlarge your capacity depending on your needs.  The VM will host all interpreters, their dependencies, the intermediate object files, and all testing targets, so you should provision enough space.

2. Download an i386 Debian installation image.  For example:

        wget http://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-7.4.0-i386-netinst.iso

3. Boot the VM, having mounted the Debian installation disk:

        $CHEF_ROOT/s2e-public/build/qemu-release/i386-softmmu/qemu-system-i386 chef_disk.raw \
          -cpu pentium \
          -net nic,model=pcnet -net user,hostfwd=tcp::1234-:4321 \
          -serial stdio -enable-kvm -smp 4 \
          -cdrom debian-7.4.0-i386-netinst.iso
        
4. Install the basic system (no extras), then reboot into the new system to check that everything works OK (including the network connectivity)

5. In the ``$CHEF_ROOT/vm`` directory, create the ``chef_disk.s2e`` file as a hard link to ``chef_disk.raw``.

### Setting up the Chef VM

First, a bit of context. To facilitate interaction with S2E, Chef provides the ``run_qemu.py`` wrapper script.  ``run_qemu.py`` operates in one of three possible modes:

* **kvm** - concrete mode, hardware accelerated.  This mode is most suitable for expensive setup operations, such as building & installing new packages.  In this mode, all changes to the VM disk are persistent.  Since the KVM snapshots are incompatible with the regular snapshots, the KVM mode should boot from scratch and the machine be shut down cleanly at the end.

* **prep** - snapshot preparation mode.  In this mode, the VM still boots in non-symbolic mode, but all changes to the disk are ephemeral and only stored in snapshots.  The purpose of this mode is to boot up the system from scratch and prepare it up to the point it is ready for symbolic execution.  You should use ``savevm 1`` in the Qemu console to save the snapshot. 

* **sym** - symbolic mode.  In this mode, the snapshot created in **prep** mode is executed in full symbolic mode.

That being said, we'll use the **kvm** mode to set up the Chef VM:

1. Boot up the Chef VM:

        $ cd $CHEF_ROOT/tools
        $ ./run_qemu.py kvm

2. Install additional packages:

        $ sudo apt-get install build-essential unzip git-core

   For building Python, you will also need:
   
        $ sudo apt-get install libssl-dev libsqlite3-dev libreadline-dev libz2-dev
        
3. Clone the ``chef-tools`` repository and set up the interpreters you want to use. You should get the following directory structure inside the guest:

        $CHEF_GUEST_ROOT
          tools/
          python/
            chef/
              build/
          lua/
            chef/
              build/
             
4. Shut down the VM (this is an important step before preparing the VM snapshot for symbolic execution):

        $ sudo halt
              

### Preparing the host replay environment

This part is necessary for replaying the test cases generated by Chef.  Essentially, you need to download & set up again the interpreters you use, but this time on the host.  At the end of this part, you should get the following directory structure:

    $CHEF_ROOT
    tools/
    s2e/
     build/
     s2e/
    python/
     chef/
       build/
    lua/
     chef/
       build/


### Running a Chef VM

We will use the `run_qemu.py` script to prepare the snapshot and run it in symbolic mode:

1. Boot up the VM in preparation mode:

        $ cd $CHEF_ROOT/tools
        $ ./run_qemu.py prep
        
2. Bring the VM to a point ready for symbolic execution. Then run ``savevm 1`` in the Qemu console and then ``quit``.

3. Run the VM snapshot in symbolic mode:

        $ ./run_qemu.py sym -f <S2E config file>
        
If you ever need to resume the VM from the snapshot, but not in symbolic mode (e.g., to re-adjust the snapshot without rebooting the entire VM), you can do so using:

    $ ./run_qemu.py prep -l


Running the experiments in the Chef paper
-----------------------------------------

(Work in progress)
