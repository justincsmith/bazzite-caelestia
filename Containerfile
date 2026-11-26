# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Builder image for apps we need to compile from source
FROM docker.io/library/fedora:45 AS builder
RUN dnf5 -y copr enable lionheartp/Hyprland
RUN dnf5 install -y \
    git \
    qmake \
    ninja-build \
    hyprland-devel \
    qt6-qtdeclarative-devel \
    qt6-qtshadertools-devel \
    qt6-qtquickcontrols2-devel \
    qt6-qtmultimedia-devel \
    qt6-qtsvg-devel \
    cargo \
    mold    

# Compile the hypr-seam rounded-corners plugin for caelestia/hyprland
RUN git clone https://github.com/misaid/hypr-seam.git /tmp/hypr-seam && \
    cd /tmp/hypr-seam && \
    make all

# Compile and install FlightDeck which helps configure hyprland/caelestia
RUN git clone https://github.com/AstraSuite/FlightDeck.git /tmp/FlightDeck && \
    cd /tmp/FlightDeck && \
    cmake -B build -S . -G Ninja -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build && \
    cmake --install build

# Compile and install Airlock which is a login greeter for greetd
RUN git clone https://github.com/AstraSuite/Airlock.git /tmp/Airlock && \
    cd /tmp/Airlock && \
    CARGO_HOME=/tmp/.cargo cargo build --release && \
    install -Dm755 target/release/astra-airlock /usr/bin/astra-airlock

RUN git clone https://github.com/AstraSuite/Atlas.git /tmp/Atlas && \
    cd /tmp/Atlas && \
    CARGO_HOME=/tmp/.cargo cargo build --release && \
    make install PREFIX=/usr

# Base Image
FROM ghcr.io/ublue-os/bazzite-dx-gnome:stable
## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:testing
# FROM ghcr.io/ublue-os/aurora:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia-open:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:44
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=bind,from=builder,source=/,target=/bldr \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
