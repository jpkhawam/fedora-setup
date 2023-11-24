#!/bin/bash

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.shell.app-switcher.current-workspace-only true
gsettings set org.gnome.desktop.interface.font-antialiasing 'rgba'

# Desktop settings
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.privacy.recent-files-max-age -1

# GNOME Software settings
gsettings set org.gnome.software.download-updates false
gsettings set org.gnome.software.download-updates-notify false

# Power settings
gsettings set org.gnome.settings-daemon.plugins.power.power-button-action 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power.sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power.sleep-inactive-battery-type 'nothing'

# GNOME Text Editor settings
gsettings set org.gnome.TextEditor.use-system-font false
gsettings set org.gnome.TextEditor.highlight-current-line true
gsettings set org.gnome.TextEditor.restore-session false
gsettings set org.gnome.TextEditor.show-line-numbers true
gsettings set org.gnome.TextEditor.show-map true
gsettings set org.gnome.TextEditor.spellcheck false
gsettings set org.gnome.TextEditor.style-scheme 'builder-dark'
gsettings set org.gnome.TextEditor.custom-font 'Monospace 14'

# GWeather4 settings
gsettings set org.gnome.GWeather4.temperature-unit 'centigrade'
gsettings set org.gnome.GWeather4.speed-unit 'kph'
gsettings set org.gnome.GWeather4.distance-unit 'km'

# Keyboard Shortcuts
gsettings set org.gnome.desktop.wm.keybindings.show-desktop "['<Super>d']"

if [[ $1 = "true" ]]; then
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
fi
