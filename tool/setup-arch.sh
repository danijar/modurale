#!/bin/sh

# Install compiler and development tools
sudo pacman -Sy --needed --noconfirm gcc git cmake

# Install dependencies
sudo pacman -Sy --needed --noconfirm libsndfile libxrandr libjpeg-turbo \
    openal freetype2 libxmu libxi glu
