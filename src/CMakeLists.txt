################################################################
# General
################################################################

# CMake version
cmake_minimum_required(VERSION 2.8.12)

# Project name
set(PROJECT_NAME modurale)
project(${PROJECT_NAME})

# Version number
set(${PROJECT_NAME}_VERSION_MAJOR 0)
set(${PROJECT_NAME}_VERSION_MINOR 1)
set(${PROJECT_NAME}_VERSION_PATCH 0)

# Include scripts
get_filename_component(REPOSITORY_DIR ${CMAKE_SOURCE_DIR} DIRECTORY)
set(CMAKE_MODULE_PATH ${REPOSITORY_DIR}/cmake ${CMAKE_MODULE_PATH})
include(ExternalProject)
include(Helpers)

################################################################
# Configure toolchain
################################################################

# Enable modern C++ features
if (UNIX OR MINGW)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
endif()

# Use release builds without debug symbols
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
	"Whether to build Debug or Release builds." FORCE)

# Static libraries
set(BUILD_SHARED_LIBS FALSE CACHE BOOL "")
set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL
	"Whether to build static or dynamic libraries." FORCE)

# Link runtime library statically
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

################################################################
# Include headers and source files
################################################################

# Recursively look for headers and source files and add them
file(GLOB_RECURSE HEADER_FILES ${CMAKE_SOURCE_DIR}/*.hpp ${CMAKE_SOURCE_DIR}/*.inl)
file(GLOB_RECURSE SOURCE_FILES ${CMAKE_SOURCE_DIR}/*.cpp)
include_directories(${CMAKE_SOURCE_DIR})
add_executable(${PROJECT_NAME} ${HEADER_FILES} ${SOURCE_FILES})

# If set, force use of static libraries
if (NOT BUILD_SHARED_LIBS)
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_START_STATIC TRUE)
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_END_STATIC TRUE)
endif()

################################################################
# Library dependencies
################################################################

# SFML
if (NOT BUILD_SHARED_LIBS)
	set(SFML_STATIC_LIBRARIES TRUE)
endif()
set(SFML_ROOT ${REPOSITORY_DIR}/external/SFML/install)
use_package(${PROJECT_NAME} SFML 2 COMPONENTS graphics window system)

# Boost
if (NOT BUILD_SHARED_LIBS)
	set(Boost_USE_STATIC_LIBS TRUE)
	set(Boost_USE_STATIC_RUNTIME TRUE)
endif()
if (CMAKE_BUILD_TYPE MATCHES Debug)
	set(Boost_USE_DEBUG_RUNTIME TRUE)
endif()
add_definitions(-DBOOST_ALL_NO_LIB) # Prevent auto linking
set(BOOST_ROOT ${REPOSITORY_DIR}/external/Boost/install)
use_package(${PROJECT_NAME} Boost COMPONENTS thread system)
