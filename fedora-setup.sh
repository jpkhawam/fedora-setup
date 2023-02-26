#!/bin/bash

sudo dnf update --refresh -y
notify-send "Updated your system successfully" --expire-time=10

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable RPM Fusion repositories
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
notify-send "Enabled RPM Fusion" --expire-time=10

# Install plugins for movies and music
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y
notify-send "Installed plugins for movies and music" --expire-time=10

# Firefox GNOME Theme
git clone https://github.com/rafaelmardojai/firefox-gnome-theme && cd firefox-gnome-theme || exit
./scripts/auto-install.sh
cd || exit
rm -rf firefox-gnome-theme
notify-send "Installed Firefox GNOME Theme" --expire-time=10

# Additional COPRs
sudo dnf copr enable elxreno/preload -y && sudo dnf install preload -y
sudo dnf copr enable dusansimic/themes -y && sudo dnf install morewaita-icon-theme -y
sudo dnf copr enable observeroftime/betterdiscordctl -y && sudo dnf install betterdiscordctl -y
notify-send "Enabled additional COPRs" --expire-time=10

# Install adw-gtk3 GTK3 Theme
sudo dnf copr enable nickavem/adw-gtk3 -y && sudo dnf install adw-gtk3 -y
flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
notify-send "Installed adw-gtk3 theme" --expire-time=10

# Essential RPM packages
sudo dnf install -y $(cat dnf-packages.txt)
notify-send "Installed dnf packages" --expire-time=10

# Essential Flatpak apps
PACKAGES=$(cat flatpak-apps.txt)
for PACKAGE in $PACKAGES; do
  flatpak install flathub -y $PACKAGE
done
notify-send "Installed flatpaks" --expire-time=10

# Additional GNOME flatpaks
GNOME_APPS=$(cat flatpak-gnome-apps.txt)
for APP in $GNOME_APPS; do
  flatpak install flathub -y $APP
done
notify-send "Installed GNOME flatpaks" --expire-time=10

# GNOME development flatpaks
DEV_APPS=$(cat flatpak-gnome-dev.txt)
for APP in $DEV_APPS; do
  flatpak install flathub -y $APP
done
notify-send "Installed GNOME dev flatpaks" --expire-time=10

# open recommended extensions in browser
EXTENSIONS=$(cat gnome-extensions.txt)
for EXTENSION in $EXTENSIONS; do
  xdg-open $EXTENSION
done

# Improve the GNOME UX
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
notify-send "Improved GNOME's settings" --expire-time=10

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
notify-send "Installed Rust" --expire-time=10

# Install Dev utils
sudo dnf group install C Development Tools and Libraries -y
notify-send "Installed group C Development Tools and Libraries" --expire-time=10

# Update firmware if device supports it
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
notify-send "Updated firmware" --expire-time=10

# Spicetify
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
notify-send "Installed Spicetify" --expire-time=10
