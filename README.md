# Fedora Post-install Setup

![screenshot of CLI with all the different options presented by the script](./screenshot.png)

This script represents the steps I usually take to configure my Fedora installs. Most these changes shouldn't be unconventional.\
Credit to [@smittix](https://github.com/smittix)'s [fedorable](https://github.com/smittix/fedorable) script for inspiring me to rewrite this using `dialog`.


> [!CAUTION]
> ***Most of the configuration is tailored to my personal liking. Double check the content of all the files in the repo before running this on any system.***


#### You can choose to execute any combination of the following
- Slightly Improve GNOME's default settings (check [gnome/gsettings.sh](gnome/gsettings.sh) for details)
- Increase scaling factor to 1.15 for HiDPI screens
- Speed up dnf (sets max parallel downloads to 10 and fastest mirror to true)
- Install potentionally desired packages - Installs packages listed in [rpm/dnf-packages.txt](rpm/dnf-packages.txt)
- Remove potentionally unwanted packages - Removes packages listed in [rpm/dnf-unwanted.txt](rpm/dnf-unwanted.txt)
- Adjust clock for dual booting with Windows to avoid time sync issues
- Enable [Flathub](https://flathub.org/) - the App store for Linux, if not already enabled
- Add [RPM Fusion](https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/) repositories - for non-free software such as multimedia plugins
- Remove potentionally unwanted repos - Removes Google Chrome and PyCharm repos from `/etc/yum.repos.d`
- Install plugins for movies and music ([following the Fedora documentation](https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/))
- Enable additional COPRs for preload and the morewaita theme
- Install the [adw-gtk3](https://github.com/lassekongo83/adw-gtk3) theme - An unofficial GTK3 port of libadwaita
- Install the [Firefox GNOME Theme](https://github.com/rafaelmardojai/firefox-gnome-theme) - A modern GNOME theme for Firefox
- Install custom Neofetch (slightly modified version of the [Boxes theme](https://github.com/Chick2D/neofetch-themes/blob/main/normal/boxes.conf))
- Update system firmware with `fwupdmgr` if supported
- Install [Rust](https://www.rust-lang.org/) - a language empowering everyone to build reliable and efficient software
- Install [Bun](https://bun.sh/) - a fast JavaScript all-in-one runtime and toolkit
- Install C/C++ Development Tools and Libraries - such as gcc, make and meson
- Install [Starship](https://starship.rs/) - A minimal, fast, and customizable terminal prompt for any shell
- Install the [GitHub CLI](https://cli.github.com/) - bring GitHub to your terminal
- Install [Visual Studio Code](https://code.visualstudio.com/) - Microsoft's text editor
- Install [VSCodium](https://vscodium.com/) - a community-driven, freely-licensed distribution of VS Code
- Install recommended flatpaks listed in [flatpaks/base-flatpaks.txt](flatpaks/base-flatpaks.txt)
- Install additional flatpaks in [flatpaks/extra-flatpaks.txt](flatpaks/extra-flatpaks.txt)
- Install GNOME development flatpaks listed in [flatpaks/gnome-dev-flatpaks.txt](flatpaks/gnome-dev-flatpaks.txt)
- Install Steam as a flatpak and the steam-devices package via dnf
- Install the proprietary Nvidia drivers and supergfxctl
- Sign the Nvidia drivers for secure boot
- Open [recommended GNOME extensions](gnome/gnome-extensions.txt) in your browser

### Installation
1. Clone this repo and navigate to directory:

	```sh
	git clone https://github.com/jpkhawam/fedora-setup && cd fedora-setup
	```

2. Mark script as executable

	```sh
	chmod +x fedora-setup.sh
	```

3. Execute script

	```sh
	./fedora-setup.sh
	```
