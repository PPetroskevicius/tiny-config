#!/bin/bash -e

# ROCm installation
# https://rocm.docs.amd.com/projects/install-on-linux/en/latest/tutorial/install-overview.html


# Prerequisites:
# https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/prerequisites.html

# Install Linux kernel headers and modules
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" -y

# Add yourself to the render and video groups to access GPU resources
sudo usermod -a -G render,video $LOGNAME


# Install through package manager
# https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/native-install/ubuntu.html

# Register Repositories
# Download and convert the package signing key

# Make the directory if it doesn't exist yet.
# This location is recommended by the distribution maintainers.
sudo mkdir --parents --mode=0755 /etc/apt/keyrings

# Download the key, convert the signing-key to a full
# keyring required by apt and store in the keyring directory
wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
        gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null

# Add the AMDGPU repository for the driver

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/6.0/ubuntu jammy main" \
        | sudo tee /etc/apt/sources.list.d/amdgpu.list
          sudo apt update

# Add the ROCm repository

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.0 jammy main" \
        | sudo tee --append /etc/apt/sources.list.d/rocm.list
          echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
      	    | sudo tee /etc/apt/preferences.d/rocm-pin-600

# Install kernel driver
sudo apt install amdgpu-dkms -y

# Install ROCm packages
sudo apt install rocm-hip-sdk -y

echo "Please reboot system for all settings to take effect."


# Post-installation:
# https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/native-install/post-install.html

# Configure the system linker
sudo tee --append /etc/ld.so.conf.d/rocm.conf <<EOF
/opt/rocm/lib
/opt/rocm/lib64
EOF
sudo ldconfig

# Verify installation
./check_rocm.sh
