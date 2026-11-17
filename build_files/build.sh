#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable Caelestia dependency repositories
dnf5 -y copr enable errornointernet/quickshell
dnf5 -y copr enable celestelove/libcava
dnf5 -y copr enable celestelove/app2unit
dnf5 -y copr enable brycensranch/gpu-screen-recorder-git
dnf5 -y copr enable celestelove/caelestia
dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y copr enable imput/helium

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

# Install kitty terminal emulator
dnf5 -y install kitty

# Install helium web browser
dnf5 -y install helium-bin

# Disable Caelestia dependency repositories
dnf5 -y copr disable errornointernet/quickshell
dnf5 -y copr disable celestelove/libcava
dnf5 -y copr disable celestelove/app2unit
dnf5 -y copr disable brycensranch/gpu-screen-recorder-git
dnf5 -y copr disable celestelove/caelestia
dnf5 -y copr disable lionheartp/Hyprland
dnf5 -y copr disable imput/helium

#### Example for enabling a System Unit File

# systemctl enable podman.socket
