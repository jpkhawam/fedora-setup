#!/bin/bash

# generate message asking to reboot if not on latest kernel now
sudo dnf update --refresh -y
sudo dnf in akmod-nvidia xorg-x11-drv-nvidia-cuda -y
sudo dnf copr enable lukenukem/asus-linux -y && sudo dnf install supergfxctl -y && sudo systemctl enable supergfxd.service

sudo cat > /etc/modprobe.d/nvidia.conf <<EOF
# Enable DynamicPwerManagement
# http://download.nvidia.com/XFree86/Linux-x86_64/440.31/README/dynamicpowermanagement.html
options nvidia NVreg_DynamicPowerManagement=0x02
EOF
