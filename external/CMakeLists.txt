################################################################
# General
################################################################

# CMake version
cmake_minimum_required(VERSION 2.8.12)

# Include scripts
get_filename_component(REPOSITORY_DIR ${CMAKE_SOURCE_DIR} DIRECTORY)
set(CMAKE_MODULE_PATH ${REPOSITORY_DIR}/cmake ${CMAKE_MODULE_PATH})
include(ExternalProject)

################################################################
# Configure toolchain
################################################################

# Enable modern C++ features
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")

# Use release builds without debug symbols
set(CMAKE_BUILD_TYPE Release)

# Link everything statically
set(BUILD_SHARED_LIBS FALSE)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")

################################################################
# Library dependencies
################################################################

# Automatically downloaddependencies, this uses scripts from
# ../cmake/ directory that make calls to ExternalProject_Add.
include(ExternalSFML)
include(ExternalBoost)
