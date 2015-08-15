#!/bin/sh

# Make newer package versions available
sudo add-apt-repository -y ppa:andykimpe/cmake
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

# Update package information
sudo apt-get update -qq

# Install compiler and development tools
sudo apt-get install -qq build-essential git cmake gcc-5 g++-5
sudo rm /usr/bin/gcc
sudo rm /usr/bin/g++
sudo ln -s /usr/bin/gcc-5 /usr/bin/gcc
sudo ln -s /usr/bin/g++-5 /usr/bin/g++

# Install dependencies
sudo apt-get install -qq libfreetype6-dev libjpeg-dev libopenal-dev \
    libglu1-mesa-dev libsndfile1-dev libudev-dev libx11-dev libxrandr-dev
