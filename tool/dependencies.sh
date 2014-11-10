#!/bin/sh

# Update package information
sudo apt-get update

# Install compiler and development tools
sudo apt-get install libdpkg-perl=1.17.5ubuntu5 -y --force-yes
sudo apt-get install build-essential git cmake -y

# Update compiler version for modern features
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update
sudo apt-get install gcc-4.9 g++-4.9 -y
ln -sf /usr/bin/gcc-4.9 /usr/bin/gcc
ln -sf /usr/bin/g++-4.9 /usr/bin/g++

# Set up libraries
sudo apt-get install libglapi-mesa libx11-dev libxrandr-dev libgl1-mesa-dev libglu1-mesa-dev libfreetype6-dev libopenal-dev libsndfile1-dev libudev-dev libglew-dev libjpeg-dev -y
