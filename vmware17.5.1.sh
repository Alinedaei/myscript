#!/bin/bash

# Clone the vmware-host-modules repository
git clone https://github.com/mkubecek/vmware-host-modules.git

# Change directory to vmware-host-modules
cd vmware-host-modules

# Switch to the workstation-17.5.1 branch
git switch workstation-17.5.1

# Compile the modules
make

# Install the modules
sudo make install

# Sign the vmmon file
sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmmon)

# Sign the vmnet file
sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmnet)

# Load the vmmon module
sudo modprobe -v vmmon

# Load the vmnet module
sudo modprobe -v vmnet

# Start VMware networks
sudo vmware-networks --start
