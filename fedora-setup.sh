#!/bin/bash

sudo dnf update --refresh -y

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable RPM Fusion repositories 
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
  
# Install plugins for movies and music
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y

# Firefox GNOME Theme
git clone https://github.com/rafaelmardojai/firefox-gnome-theme && cd firefox-gnome-theme
./scripts/auto-install.sh
cd
rm -rf firefox-gnome-theme

# Additional COPRs
sudo dnf copr enable elxreno/preload -y && sudo dnf install preload -y
sudo dnf copr enable dusansimic/themes -y && sudo dnf install morewaita-icon-theme -y
sudo dnf copr enable observeroftime/betterdiscordctl -y && sudo dnf install betterdiscordctl -y 

# adw-gtk3
sudo dnf copr enable nickavem/adw-gtk3 -y && sudo dnf install adw-gtk3 -y
flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# essential rpm packages
sudo dnf in gnome-tweaks yaru-theme yaru-icon-theme yaru-sound-theme yaru-gtk4-theme yaru-gtk3-theme shotwell steam vlc neofetch lolcat papirus-icon-theme rhythmbox gnome-epub-thumbnailer webp-pixbuf-loader -y

# essential flatpak apps
flatpak install flathub com.discordapp.Discord org.telegram.desktop com.spotify.Client com.github.neithern.g4music com.bitwarden.desktop com.mattjakeman.ExtensionManager -y

# additional gnome apps
flatpak install flathub de.haeckerfelix.Shortwave com.github.jeromerobert.pdfarranger io.github.diegoivan.pdf_metadata_editor org.gnome.Epiphany org.nickvision.money com.github.ADBeveridge.Raider com.github.johnfactotum.Foliate de.haeckerfelix.Fragments -y

# gnome dev apps
flatpak install flathub org.gnome.design.AppIconPreview org.gnome.Builder org.gnome.design.Palette org.gnome.design.Contrast org.gnome.Devhelp org.gnome.design.IconLibrary org.gnome.design.SymbolicPreview re.sonny.Workbench com.github.liferooter.textpieces org.gnome.design.Typography -y

# open recommended extensions in browser
xdg-open https://extensions.gnome.org/extension/615/appindicator-support/
xdg-open https://extensions.gnome.org/extension/5425/battery-time/
xdg-open https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/
xdg-open https://extensions.gnome.org/extension/3193/blur-my-shell/
xdg-open https://extensions.gnome.org/extension/779/clipboard-indicator/
xdg-open https://extensions.gnome.org/extension/3843/just-perfection/
xdg-open https://extensions.gnome.org/extension/2182/noannoyance/
xdg-open https://extensions.gnome.org/extension/5344/supergfxctl-gex/
xdg-open https://extensions.gnome.org/extension/1446/transparent-window-moving/
xdg-open https://extensions.gnome.org/extension/5506/user-avatar-in-quick-settings/
xdg-open https://extensions.gnome.org/extension/19/user-themes/
xdg-open https://extensions.gnome.org/extension/1720/weeks-start-on-monday-again/
xdg-open https://extensions.gnome.org/extension/1319/gsconnect/

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo 'Additional things to do:'
echo 'Settings -> Mouse & Touchpad -> Touchpad -> Enable Natural Scrolling and Tap to Click'
echo 'Settings -> Users -> Enable Automatic Login (if you encrypt your drive)'
echo 'Gnome tweaks -> Fonts -> Adjust scaling factor (1.15)'
echo 'Gnome tweaks -> Top Bar -> Enable Weekday'
echo 'Gnome tweaks -> Window Titlebars -> Enable Maximize and Minimize'
echo 'Gnome tweaks -> Windows -> Enable Center New Windows'
echo 'Increase terminal font size to 14'
echo 'Set shortcut to open terminal, to show desktop'
