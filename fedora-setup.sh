#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NO_COLOR='\033[0m'

echo -e "${YELLOW} Warning: Make sure to update your system before running this script"
echo -e "${CYAN} Info: Run \"sudo dnf update --refresh\" before proceeding${NO_COLOR}"
read -p "Are you sure you want to continue? [y/N]: " -r
if [[ $REPLY != 'y' && $REPLY != 'Y' ]]; then
  echo -e "${RED} Error: Update your system before proceeding.${NO_COLOR}"
  exit
fi

declare -A prompt_var_map=(
  ["Improve GNOME settings?"]="improve_gnome_ux"
  ["Increase scaling factor to 1.15 (for HiDPI screens)?"]="increase_scaling_factor"
  ["Set DNF fastestmirror to true?"]="dnf_fastest_mirror"
  ["Remove unneeded packages?"]="remove_unwanted_packages"
  ["Adjust clock for dual booting with Windows?"]="set_local_rtc"
  ["Enable additional COPRs? (preload, themes, better fonts)"]="enable_copr"
  ["Install the adw-gtk3 theme?"]="enable_adwgtk3"
  ["Install Nvidia drivers?"]="install_nvidia_drivers"
  ["Install recommended dnf packages?"]="install_dnf_packages"
  ["Install GitHub CLI?"]="install_gh"
  ["Install Visual Studio Code?"]="install_vscode"
  ["Install C Development Tools and Libraries?"]="install_dev_utils"
  ["Update system firmware (if supported)?"]="update_firmware"
  ["Install recommended flatpaks?"]="install_flatpaks"
  ["Install steam (as flatpak) and steam-devices package?"]="install_steam"
  ["Install extra flatpaks?"]="install_extra_flatpaks"
  ["Install GNOME development flatpaks?"]="install_gnome_dev_flatpaks"
  ["Open recommended GNOME extensions in your browser?"]="open_recommended_extensions"
  ["Copy Neofetch config?"]="copy_neofetch_conf"
  ["Install Firefox GNOME Theme?"]="firefox_gnome_theme"
  ["Install Rust?"]="install_rust"
)

for prompt in "${!prompt_var_map[@]}"; do
  read -p "$prompt [y/N]: " -r
  var_name="${prompt_var_map[$prompt]}"
  declare "$var_name=false"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    declare "$var_name=true"
  fi
done

# Improve GNOME's UX
if [ "$improve_gnome_ux" = true ]; then
  source gnome/gsettings.sh $increase_scaling_factor
fi

# DNF config
if [ "$dnf_fastest_mirror" = true ]; then
  echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
fi

# Remove unneeded DNF packages
if [ "$remove_unwanted_packages" = true ]; then
  sudo dnf remove -y $(cat rpm/dnf-unwanted.txt)
fi

# Adjust clock for dual booting
if [ "$set_local_rtc" = true ]; then
  timedatectl set-local-rtc 1
fi

# Enable Firefox wayland
echo 'MOZ_ENABLE_WAYLAND=1' | sudo tee -a /etc/environment

# Enable flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable RPM Fusion repositories
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# remove unwanted repos
sudo rm /etc/yum.repos.d/google-chrome.repo
sudo rm /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:phracek\:PyCharm.repo

# Install plugins for movies and music
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia --allowerasing -y

# Additional COPRs
if [ "$enable_copr" = true ]; then
  sudo dnf copr enable elxreno/preload -y && sudo dnf install preload -y
  sudo dnf copr enable dusansimic/themes -y && sudo dnf install morewaita-icon-theme -y
  sudo dnf copr enable dawid/better_fonts -y && sudo dnf install fontconfig-enhanced-defaults -y
fi

# Install adw-gtk3 GTK3 theme
if [ "$enable_adwgtk3" = true ]; then
  sudo dnf copr enable nickavem/adw-gtk3 -y && sudo dnf install adw-gtk3-theme -y
  flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark -y
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# Essential RPM packages
if [ "$install_dnf_packages" = true ]; then
  sudo dnf install -y $(cat rpm/dnf-packages.txt)
fi

# Install GitHub CLI
if [ "$install_gh" = true ]; then
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y
fi

# Install VSCode
if [ "$install_vscode" = true ]; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf install code -y
fi

# Install Dev utils
if [ "$install_dev_utils" = true ]; then
  sudo dnf group install "C Development Tools and Libraries" -y
  sudo dnf install meson -y
fi

# Update firmware if device supports it
if [ "$update_firmware" = true ]; then
  sudo fwupdmgr get-devices
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
fi

# Install Nvidia drivers
if [ "$install_nvidia_drivers" = true ]; then
  source nvidia/nvidia-drivers.sh
fi

# Recommended Flatpak apps
if [ "$install_flatpaks" = true ]; then
  PACKAGES=$(cat flatpaks/base-flatpaks.txt)
  for PACKAGE in $PACKAGES; do
    flatpak install flathub -y "$PACKAGE"
  done
fi

# Install Steam
if [ "$install_steam" = true ]; then
  flatpak install flathub -y com.valvesoftware.Steam
  sudo dnf in -y steam-devices
fi

# Extra flatpaks
if [ "$install_extra_flatpaks" = true ]; then
  GNOME_APPS=$(cat flatpaks/extra-flatpaks.txt)
  for APP in $GNOME_APPS; do
    flatpak install flathub -y "$APP"
  done
fi

# GNOME development flatpaks
if [ "$install_gnome_dev_flatpaks" = true ]; then
  DEV_APPS=$(cat flatpaks/gnome-dev-flatpaks.txt)
  for APP in $DEV_APPS; do
    flatpak install flathub -y "$APP"
  done
fi

# Open recommended extensions in browser
if [ "$open_recommended_extensions" = true ]; then
  EXTENSIONS=$(cat gnome/gnome-extensions.txt)
  for EXTENSION in $EXTENSIONS; do
    xdg-open "$EXTENSION"
  done
fi

# Firefox GNOME Theme
if [ "$firefox_gnome_theme" = true ]; then
  git clone https://github.com/rafaelmardojai/firefox-gnome-theme &&
  cd firefox-gnome-theme &&
  source ./scripts/auto-install.sh &&
  cd .. &&
  rm -rf firefox-gnome-theme &&
  echo 'user_pref("gnomeTheme.bookmarksToolbarUnderTabs", true);' >> .mozilla/firefox/*-release/prefs.js
fi

# Neofetch config
if [ "$copy_neofetch_conf" = true ]; then
  # check if neofetch is installed
  if ! command -v neofetch &> /dev/null; then
    sudo dnf install neofetch -y
  fi
  neofetch
  mv ~/.config/neofetch/config.conf ~/.config/neofetch/defaultconfig.conf
  cp configs/neofetch-config.conf ~/.config/neofetch/config.conf
  neofetch
fi

# Install Rust
# requires manual input
if [ "$install_rust" = true ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
