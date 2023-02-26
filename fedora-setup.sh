#!/bin/bash

read -p "Install Firefox GNOME Theme? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  firefox_gnome_theme=true
fi

read -p "Enable additional COPRs? (preload, themes, betterdiscordctl, better fonts) [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  enable_copr=true
fi

read -p "Install the adw-gtk3 theme? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  enable_adwgtk3=true
fi

read -p "Install recommended dnf packages? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_dnf_packages=true
fi

read -p "Install recommended flatpaks? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_flatpaks=true
fi

read -p "Install recommended GNOME flatpaks? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_gnome_flatpaks=true
fi

read -p "Install GNOME development flatpaks? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_gnome_dev_flatpaks=true
fi

read -p "Open recommended GNOME extensions in your browser? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  open_recommended_extensions=true
fi

read -p "Improve GNOME settings? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  improve_gnome_ux=true
fi

read -p "Increase scaling factor to 1.15 (for HiDPI screens)? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  increase_scaling_factor=true
fi

read -p "Install Rust? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_rust=true
fi

read -p "Install C Development Tools and Libraries? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_dev_utils=true
fi

read -p "Update system firmware (if supported)? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  update_firmware=true
fi

read -p "Install Spicetify? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_spicetify=true
fi

read -p "Copy Neofetch config? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  copy_neofetch_conf=true
fi

sudo dnf update --refresh -y
notify-send "Updated your system successfully" --expire-time=10

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
notify-send "Enabled Flathub" --expire-time=10

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

sudo dnf groupupdate core -y
sudo dnf groupinstall multimedia -y
sudo dnf groupupdate multimedia -y
sudo dnf groupupdate sound-and-video -y

# Firefox GNOME Theme
if [ "$firefox_gnome_theme" = true ]; then
  git clone https://github.com/rafaelmardojai/firefox-gnome-theme
  bash ~/firefox-gnome-theme/scripts/auto-install.sh
  rm -rf ~/firefox-gnome-theme
  notify-send "Installed Firefox GNOME Theme" --expire-time=10
fi

# Additional COPRs
if [ "$enable_copr" = true ]; then
  sudo dnf copr enable elxreno/preload -y && sudo dnf install preload -y
  sudo dnf copr enable dusansimic/themes -y && sudo dnf install morewaita-icon-theme -y
  sudo dnf copr enable observeroftime/betterdiscordctl -y && sudo dnf install betterdiscordctl -y
  sudo dnf copr enable dawid/better_fonts -y && sudo dnf install fontconfig-enhanced-defaults -y
  notify-send "Enabled additional COPRs" --expire-time=10
fi

# Install adw-gtk3 GTK3 Theme
if [ "$enable_adwgtk3" = true ]; then
  sudo dnf copr enable nickavem/adw-gtk3 -y && sudo dnf install adw-gtk3 -y
  flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  notify-send "Installed adw-gtk3 theme" --expire-time=10
fi

# Essential RPM packages
if [ "$install_dnf_packages" = true ]; then
  sudo dnf install -y $(cat dnf-packages.txt)
  notify-send "Installed dnf packages" --expire-time=10
fi

# Essential Flatpak apps
if [ "$install_flatpaks" = true ]; then
  PACKAGES=$(cat flatpak-apps.txt)
  for PACKAGE in $PACKAGES; do
    flatpak install flathub -y "$PACKAGE"
  done
  notify-send "Installed flatpaks" --expire-time=10
fi

# Additional GNOME flatpaks
if [ "$install_gnome_flatpaks" = true ]; then
  GNOME_APPS=$(cat flatpak-gnome-apps.txt)
  for APP in $GNOME_APPS; do
    flatpak install flathub -y "$APP"
  done
  notify-send "Installed GNOME flatpaks" --expire-time=10
fi

# GNOME development flatpaks
if [ "$install_gnome_dev_flatpaks" = true ]; then
  DEV_APPS=$(cat flatpak-gnome-dev.txt)
  for APP in $DEV_APPS; do
    flatpak install flathub -y "$APP"
  done
  notify-send "Installed GNOME dev flatpaks" --expire-time=10
fi

# open recommended extensions in browser
if [ "$open_recommended_extensions" = true ]; then
  EXTENSIONS=$(cat gnome-extensions.txt)
  for EXTENSION in $EXTENSIONS; do
    xdg-open "$EXTENSION"
  done
fi

# Improve the GNOME UX
if [ "$improve_gnome_ux" = true ]; then
  gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface clock-format '12h'
  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface clock-show-seconds false
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
  gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
  notify-send "Improved GNOME's settings" --expire-time=10
fi

# Increase scaling factor
if [ "$increase_scaling_factor" = true ]; then
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
fi

# Install Rust
if [ "$install_rust" = true ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  notify-send "Installed Rust" --expire-time=10
fi

# Install Dev utils
if [ "$install_dev_utils" = true ]; then
  sudo dnf group install C Development Tools and Libraries -y
  notify-send "Installed group C Development Tools and Libraries" --expire-time=10
fi

# Update firmware if device supports it
if [ "$update_firmware" = true ]; then
  sudo fwupdmgr get-devices
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
  notify-send "Updated firmware" --expire-time=10
fi

# Spicetify
if [ "$install_spicetify" = true ]; then
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
  notify-send "Installed Spicetify" --expire-time=10
fi

# Neofetch config
if [ "$copy_neofetch_conf" = true ]; then
  mv ~/.config/neofetch/config.conf ~/.config/neofetch/[BACKUP]config.conf
  cp neofetch-config.conf ~/.config/neofetch/config.conf
fi
