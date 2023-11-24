#!/bin/bash

sudo dnf in akmod-nvidia xorg-x11-drv-nvidia-cuda -y
echo 'options nvidia NVreg_DynamicPowerManagement=0x02' | sudo tee -a /etc/modprobe.d/nvidia.conf
sudo dnf copr enable lukenukem/asus-linux -y && sudo dnf install supergfxctl -y && sudo systemctl enable supergfxd.service

read -p "Configure drivers for secure boot? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # To create the self generated key and certificate:
  sudo /usr/sbin/kmodgenca
  # To import the key, the command will ask for a password to protect the key
  # You will have to enter this password during the special EFI window
  sudo mokutil --import /etc/pki/akmods/certs/public_key.der
fi
