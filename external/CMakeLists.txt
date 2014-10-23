################################################################
# General
################################################################

# CMake version
cmake_minimum_required(VERSION 2.8.12)

# Project name
project(dependencies)

# Include scripts
get_filename_component(REPOSITORY_DIR ${CMAKE_SOURCE_DIR} DIRECTORY)
set(CMAKE_MODULE_PATH ${REPOSITORY_DIR}/cmake ${CMAKE_MODULE_PATH})
include(ExternalProject)

################################################################
# Configure tool chain
################################################################

# Enable modern C++ features
if (UNIX OR MINGW)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
endif()

# Build variant
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
	"Whether to build Debug or Release builds." FORCE)

# Link libraries
set(BUILD_SHARED_LIBS FALSE CACHE BOOL "")
set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL
	"Whether to build static or dynamic libraries." FORCE)

# Link runtime library
set(USE_STATIC_STD_LIBS TRUE CACHE BOOL "")
set(USE_STATIC_STD_LIBS ${USE_STATIC_STD_LIBS} CACHE BOOL
	"Whether to use statically or dynamically link to the runtime library." FORCE)
if (USE_STATIC_STD_LIBS)
	if (UNIX OR MINGW)
		set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	elseif (MSVC)
		set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
		set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
	else()
		message(ERROR "Unsupported compiler.")
	endif()
endif()

# Can't use static runtime with dynamic libraries
if (BUILD_SHARED_LIBS AND USE_STATIC_STD_LIBS)
	message(FATAL_ERROR "Can't link libraries dynamically but runtime "
		"statically. BUILD_SHARED_LIBS and USE_STATIC_STD_LIBS are mutually "
		"exclusive.")
endif()

################################################################
# Generator settings
################################################################

# Configuration types
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING
	"Semicolon separated list of supported configuration types, only supports Debug, Release, MinSizeRel, and RelWithDebInfo, anything else will be ignored." FORCE)

################################################################
# External settings
################################################################

# Make GIT_EXECUTABLE show up in the graphical user interface
set(GIT_EXECUTABLE "git" CACHE FILEPATH "")
set(GIT_EXECUTABLE ${GIT_EXECUTABLE} CACHE FILEPATH
	"Path to the git executable used to download dependencies." FORCE)

################################################################
# Library dependencies
################################################################

# Automatically downloaddependencies, this uses scripts from
# ../cmake/ directory that make calls to ExternalProject_Add.
include(ExternalSFML)
include(ExternalBoost)
include(ExternalCatch)
