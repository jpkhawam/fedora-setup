# fedora-setup
Bash script to setup my fedora installs
- Updates system
- Enables Flathub
- Enables RPM Fusion
- Installs multimedia plugins
- Installs Firefox GNOME Theme
- Enables COPRs for preload/themes/betterdiscordctl
- Installs the adw-gtk3 theme
- Installs dnf packages
- Installs flatpaks
- Installs GNOME flatpaks
- Installs GNOME Dev flatpaks
- Opens recommended extensions in browser
- Improves GNOME's settings
- Installs Rust
- Installs C Development Tools and Libraries
- Updates system firmware
- Installs spicetify
- Updates neofetch config

### Installation script
1. Clone this repo and enter folder:

	```sh
	git clone https://github.com/jpkhawam/fedora-setup && cd fedora-setup
	```
  
2. Run installation script

	#### Auto install script
	```sh
	bash fedora-setup.sh
	```
  
4. Reboot

	```sh
	reboot
	```
  
4. [Optional] Install Nvidia Drivers

	```sh
	bash fedora-nvidia.sh
	```
