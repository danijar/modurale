#!/bin/sh

# Install compiler and development tools
sudo pacman -Sy --needed --noconfirm gcc git cmake

# Install dependencies
sudo pacman -Sy --needed --noconfirm freetype2 libjpeg-turbo openal glu \
    libsndfile systemd libxi libxmu libxrandr
