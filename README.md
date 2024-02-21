# Fedora Setup Script

This script automates my Fedora installs to configure them the way I usually set up the distro. Most these changes shouldn't be unconventional.

> [!CAUTION]
> A lot of the files and settings are tailored to my personal liking. Double check the content of all the files in the repo before running this on any system.

### Sets up new Fedora installs to have sane defaults

## You can choose to execute any combination of the following
- Add Flathub (if not added)
- Add RPM Fusion repositories
- Remove Google Chrome and PyCharm repos from `/etc/yum.repos.d`
- Install plugins for movies and music ([as per the Fedora documentation](https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/))
- Improve GNOME's default settings (check [gnome/gsettings.sh](gnome/gsettings.sh) for details)
- Set `fastestmirror` to DNF config
- Remove unneeded packages (check [rpm/dnf-unwanted.txt](rpm/dnf-unwanted.txt) for details, edit this file to your liking)
- Adjust system clock for dual booting with Windows
- Enable additional COPRs (elxreno/preload, dusansimic/themes, dawid/better_fonts)
- Install adw-gtk3 GTK3 theme
- Install Nvidia drivers
- Install RPM packages (check [rpm/dnf-packages.txt](rpm/dnf-packages.txt) for details, edit this file to your liking)
- Install GitHub CLI
- Install Visual Studio Code
- Install C Development Tools and Libraries
- Update system firmware
- Install flatpaks (general/GNOME/GNOME Dev, check flatpak folder for details)
- Install Steam (flatpak) and steam-devices (dnf)
- Open recommended GNOME extensions in browser (check [gnome/gnome-extensions.txt](gnome/gnome-extensions.txt))
- Copy custom neofetch config (check configs/neofetch-config.conf for details)
- Install the Firefox GNOME Theme
- Install Starship
- Install Bun
- Install Rust

### Installation script
1. Clone this repo and navigate to directory:

	```sh
	git clone https://gitlab.com/moralpanic/fedora-setup && cd fedora-setup
	```

2. Run installation script

	```sh
	bash fedora-setup.sh
	```

3. Reboot

	```sh
	reboot
	```
