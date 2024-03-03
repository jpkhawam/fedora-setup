#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NO_COLOR='\033[0m'

echo -e "${YELLOW}[Warning]: Make sure to update your system before running this script"
echo -e "${CYAN}[Info]: Run \"sudo dnf update --refresh\" before proceeding${NO_COLOR}"
read -p "Are you sure you want to continue? [y/N]: " -r
if [[ $REPLY != 'y' && $REPLY != 'Y' ]]; then
  echo -e "${RED}[Error]: Update your system before proceeding.${NO_COLOR}"
  exit
fi

fn_info_start() {
  echo -e "${CYAN}[Info]: $1${NO_COLOR}"
}

fn_info_end() {
  echo -e "${CYAN}[Info]: Done. Press any key to continue${NO_COLOR}"
  read -p ""
}

if ! command -v dialog &>/dev/null; then
  sudo dnf install dialog -y
fi

HEIGHT=40
WIDTH=120
CHOICE_HEIGHT=4
BACKTITLE=""
TITLE="Fedora post-install setup"
MENU="Choose any of the following options"

OPTIONS=(01 "Improve GNOME settings - Slightly modifies GNOME's default settings"
  02 "Increase scaling factor to 1.15 - Helps with the resolution of HiDPI screens"
  03 "Speed up DNF - Sets max parallel downloads to 10 and fastestmirror to true"
  04 "Install potentionally desired packages - Installs packages listed in rpm/dnf-packages.txt"
  05 "Remove potentionally unwanted packages - Removes packages listed in rpm/dnf-unwanted.txt"
  06 "Adjust clock for dual booting with Windows - Fixes time sync between Windows and Linux"
  07 "Enable Flathub - the App store for Linux, if not already enabled"
  08 "Add RPM Fusion repositories - for non-free software such as multimedia plugins"
  09 "Remove potentionally unwanted repos - Removes Google Chrome and PyCharm repos from /etc/yum.repos.d"
  10 "Install plugins for movies and music - Installs multimedia plugins needed for various formats"
  11 "Enable additional COPRs - Installs preload and the morewaita theme"
  12 "Install the adw-gtk3 theme - An unofficial GTK3 port of libadwaita"
  13 "Install the Firefox GNOME Theme - A modern GNOME theme for Firefox"
  14 "Install custom Neofetch - Installs neofetch and overrides the default config"
  15 "Update system firmware - if supported"
  16 "Install Rust - a language empowering everyone to build reliable and efficient software"
  17 "Install Bun - a fast JavaScript all-in-one runtime and toolkit"
  18 "Install C/C++ Development Tools and Libraries - such as gcc, make and meson"
  19 "Install Starship - A minimal, fast, and customizable terminal prompt for any shell"
  20 "Install the GitHub CLI - bring GitHub to your terminal"
  21 "Install Visual Studio Code - Microsoft's text editor"
  22 "Install VSCodium - a community-driven, freely-licensed distribution of VS Code"
  23 "Install recommended flatpaks - Installs flatpaks listed in flatpaks/base-flatpaks.txt"
  24 "Install additional flatpaks - Installs flatpaks listed in flatpaks/extra-flatpaks.txt"
  25 "Install GNOME development flatpaks - Installs flatpaks listed in flatpaks/gnome-dev-flatpaks.txt"
  26 "Install Steam - Installs Steam as a flatpak and the steam-devices package via dnf"
  27 "Install Nvidia drivers - Installs the proprietary Nvidia drivers"
  28 "Set up Nvidia drivers for secure boot - Signs the Nvidia drivers, only needed if you use secure boot"
  29 "Open recommended GNOME extensions - Opens recommended GNOME extensions in your browser"
  99 "Quit")

while [ "$CHOICE -ne 4" ]; do
  CHOICE=$(dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "$TITLE" \
    --nocancel \
    --menu "$MENU" \
    $HEIGHT $WIDTH $CHOICE_HEIGHT \
    "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

  clear
  case $CHOICE in
  01)
    fn_info_start "Improving GNOME's default settings"
    source gnome/gsettings.sh
    fn_info_end
    ;;
  02)
    fn_info_start "Increasing scaling factor"
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
    fn_info_end
    ;;
  03)
    fn_info_start "Speeding up DNF"
    echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
    echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
    fn_info_end
    ;;
  04)
    fn_info_start "Installing dnf packages"
    sudo dnf install -y $(cat rpm/dnf-packages.txt)
    fn_info_end
    ;;
  05)
    fn_info_start "Removing unwanted dnf packages"
    sudo dnf remove -y $(cat rpm/dnf-unwanted.txt)
    fn_info_end
    ;;
  06)
    fn_info_start "Adjusting system clock for dual booting"
    timedatectl set-local-rtc 1
    fn_info_end
    ;;
  07)
    fn_info_start "Enabling Flathub"
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fn_info_end
    ;;
  08)
    fn_info_start "Adding RPM Fusion repositories"
    sudo dnf install \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    fn_info_end
    ;;
  09)
    fn_info_start "Removing yum repos"
    sudo rm /etc/yum.repos.d/google-chrome.repo
    sudo rm /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:phracek\:PyCharm.repo
    fn_info_end
    ;;
  10)
    fn_info_start "Installing multimedia plugins"
    sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude={gstreamer1-plugins-bad-free-devel,proj-data-*} -y
    sudo dnf install lame\* --exclude=lame-devel -y
    sudo dnf group upgrade --with-optional Multimedia --allowerasing -y
    fn_info_end
    ;;
  11)
    fn_info_start "Installing preload and morewaita"
    sudo dnf copr enable elxreno/preload -y && sudo dnf install preload -y
    sudo dnf copr enable dusansimic/themes -y && sudo dnf install morewaita-icon-theme -y
    fn_info_end
    ;;
  12)
    fn_info_start "Installing adw-gtk3 theme"
    sudo dnf copr enable nickavem/adw-gtk3 -y && sudo dnf install adw-gtk3-theme -y
    flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark -y
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    fn_info_end
    ;;
  13)
    fn_info_start "Installing Firefox GNOME theme"
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
    fn_info_end
    ;;
  14)
    fn_info_start "Installing neofetch"
    sudo dnf in -y neofetch
    neofetch
    mv ~/.config/neofetch/config.conf ~/.config/neofetch/defaultconfig.conf
    cp configs/neofetch-config.conf ~/.config/neofetch/config.conf
    neofetch
    fn_info_end
    ;;
  15)
    fn_info_start 'Updating system firmware'
    sudo fwupdmgr get-devices
    sudo fwupdmgr refresh --force
    sudo fwupdmgr get-updates
    sudo fwupdmgr update
    fn_info_end
    ;;
  16)
    fn_info_start "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fn_info_end
    ;;
  17)
    fn_info_start "Installing Bun"
    curl -fsSL https://bun.sh/install | bash
    fn_info_end
    ;;
  18)
    fn_info_start "Installing C Development Tools and Libraries"
    sudo dnf group install "C Development Tools and Libraries" -y
    sudo dnf install meson -y
    fn_info_end
    ;;
  19)
    fn_info_start "Installing Starship"
    curl -sS https://starship.rs/install.sh | sh
    echo 'eval "$(starship init bash)"' >>~/.bashrc
    echo -e "${CYAN} Info: Installed Starhip. Configure your terminal with a Nerd Font from https://www.nerdfonts.com/font-downloads${NO_COLOR}"
    notify-send "Installed Starhip. Configure your terminal with a Nerd Font" --expire-time=10
    fn_info_end
    ;;
  20)
    fn_info_start "Installing the GitHub CLI"
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install gh -y
    fn_info_end
    ;;
  21)
    fn_info_start "Installing Visual Studio Code"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install code -y
    fn_info_end
    ;;
  22)
    fn_info_start "Installing VSCodium"
    sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
    sudo dnf install codium
    ;;
  23)
    fn_info_start "Installing recommended Flatpaks"
    PACKAGES=$(cat flatpaks/base-flatpaks.txt)
    for PACKAGE in $PACKAGES; do
      flatpak install flathub -y "$PACKAGE"
    done
    fn_info_end
    ;;
  24)
    fn_info_start "Installing additional Flatpaks"
    PACKAGES=$(cat flatpaks/extra-flatpaks.txt)
    for PACKAGE in $PACKAGES; do
      flatpak install flathub -y "$PACKAGE"
    done
    fn_info_end
    ;;
  25)
    fn_info_start "Installing GNOME Dev Flatpaks"
    DEV_APPS=$(cat flatpaks/gnome-dev-flatpaks.txt)
    for APP in $DEV_APPS; do
      flatpak install flathub -y "$APP"
    done
    fn_info_end
    ;;
  26)
    fn_info_start "Installing Steam"
    flatpak install flathub -y com.valvesoftware.Steam
    sudo dnf in -y steam-devices
    fn_info_end
    ;;
  27)
    fn_info_start "Installing Nvidia drivers"
    sudo dnf in akmod-nvidia xorg-x11-drv-nvidia-cuda -y
    echo 'options nvidia NVreg_DynamicPowerManagement=0x02' | sudo tee -a /etc/modprobe.d/nvidia.conf
    sudo dnf copr enable lukenukem/asus-linux -y && sudo dnf install supergfxctl -y && sudo systemctl enable supergfxd.service
    notify-send "Installed the Nvidia drivers. Please wait at least 5 minutes until rebooting" --expire-time=10
    fn_info_end
    ;;
  28)
    fn_info_start "Signing Nvidia drivers for secure boot"
    echo -e "${CYAN} Info: Creating the self generated key and certificate${NO_COLOR}"
    sudo /usr/sbin/kmodgenca
    echo -e "${CYAN} Info: To import the key, the command will ask for a password to protect the key${NO_COLOR}"
    echo -e "${CYAN} Info: You will have to enter this password during the special EFI window${NO_COLOR}"
    sudo mokutil --import /etc/pki/akmods/certs/public_key.der
    fn_info_end
    ;;
  29)
    fn_info_start "Opening recommended GNOME extensions"
    EXTENSIONS=$(cat gnome/gnome-extensions.txt)
    for EXTENSION in $EXTENSIONS; do
      xdg-open "$EXTENSION"
    done
    fn_info_end
    ;;
  99)
    exit 0
    ;;
  esac
done
