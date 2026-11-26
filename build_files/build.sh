#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# Copy our source-compiled apps to their appropriate homes from the builder image
# hypr-seam plugin for hyprland
cp "/bldr/tmp/hypr-seam/build/libhypr-seam.so" "/usr/lib/"

# Flightdeck hyprland / caelestia settings
cp -r "/bldr/usr/share/flightdeck" /usr/share/
cp "/bldr/usr/share/applications/flightdeck.desktop" /usr/share/applications/
cp "/bldr/usr/share/icons/hicolor/scalable/apps/flightdeck.svg" /usr/share/icons/hicolor/scalable/apps/
cp "/bldr/usr/bin/flightdeck" /usr/bin/

# Atlas file manager
cp "/bldr/usr/share/applications/atlas.desktop" /usr/share/applications/
cp "/bldr/usr/share/icons/hicolor/scalable/apps/atlas.svg" /usr/share/icons/hicolor/scalable/apps/
cp "/bldr/usr/bin/atlas" /usr/bin/

# Airlock display manager
cp "/bldr/usr/bin/astra-airlock" /usr/bin/

# Enable dependency repositories
dnf5 -y copr enable errornointernet/quickshell
dnf5 -y copr enable celestelove/libcava
dnf5 -y copr enable celestelove/app2unit
dnf5 -y copr enable brycensranch/gpu-screen-recorder-git
dnf5 -y copr enable celestelove/caelestia
dnf5 -y copr enable lionheartp/Hyprland

# Install Caelestia and dependencies
dnf5 -y install quickshell-git
dnf5 -y install libcava-devel
dnf5 -y install app2unit
dnf5 -y install gpu-screen-recorder-ui
dnf5 -y install caelestia-shell caelestia-cli qtengine
dnf5 -y install Hyprland
dnf5 -y install hyprland-guiutils
dnf5 -y install hyprcursor
dnf5 -y install hyprpolkitagent
dnf5 -y install mpvpaper
dnf5 -y install nwg-look
dnf5 -y install qt6-qtshadertools
dnf5 -y install qt6-qtmultimedia
dnf5 -y install dex-autostart

# Install kitty terminal emulator
dnf5 -y install kitty

# Disable dependency repositories
dnf5 -y copr disable errornointernet/quickshell
dnf5 -y copr disable celestelove/libcava
dnf5 -y copr disable celestelove/app2unit
dnf5 -y copr disable brycensranch/gpu-screen-recorder-git
dnf5 -y copr disable celestelove/caelestia
dnf5 -y copr disable lionheartp/Hyprland

# Hourly weather updates in caelestia dashboard
git clone https://github.com/ItsXyzzy/Caelestia-Hourly-Weather.git /tmp/Caelestia-Hourly-Weather 
cd /tmp/Caelestia-Hourly-Weather 
mv /etc/xdg/quickshell/caelestia/modules/dashboard/WeatherTab.qml /etc/xdg/quickshell/caelestia/modules/dashboard/WeatherTab.qml.bak
cp ./qml/modules/dashboard/WeatherTab.qml /etc/xdg/quickshell/caelestia/modules/dashboard/WeatherTab.qml

# Helium web browser
wget https://github.com/imputnet/helium-linux/releases/download/0.22.4.1/helium-0.22.4.1-x86_64_linux.tar.xz -O /tmp/helium-0.22.4.1-x86_64_linux.tar.xz
tar -xvf /tmp/helium-0.22.4.1-x86_64_linux.tar.xz -C /usr/share/
cp "/usr/share/helium-0.22.4.1-x86_64_linux/helium.desktop" /usr/share/applications/
cp "/usr/share/helium-0.22.4.1-x86_64_linux/product_logo_256.png" /usr/share/icons/hicolor/256x256/apps/helium.png
ln -s /usr/share/helium-0.22.4.1-x86_64_linux/helium /usr/bin/helium

# Plymouth themes
wget https://github.com/adi1090x/plymouth-themes/releases/download/v1.0/hexagon_dots.tar.gz -O /tmp/hexagon_dots.tar.gz
tar -xvzf /tmp/hexagon_dots.tar.gz -C /usr/share/plymouth/themes/

wget https://github.com/adi1090x/plymouth-themes/releases/download/v1.0/loader_2.tar.gz -O /tmp/loader_2.tar.gz
tar -xvzf /tmp/loader_2.tar.gz -C /usr/share/plymouth/themes/

wget https://github.com/adi1090x/plymouth-themes/releases/download/v1.0/deus_ex.tar.gz -O /tmp/deus_ex.tar.gz
tar -xvzf /tmp/deus_ex.tar.gz -C /usr/share/plymouth/themes/

#### Example for enabling a System Unit File

# systemctl enable podman.socket
