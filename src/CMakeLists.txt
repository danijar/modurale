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
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")

# Default to release builds without debug symbols
if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE Debug)
endif()

# Link everything statically
set(BUILD_SHARED_LIBS FALSE)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a") # This isn't cross platform yet
set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")

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
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_START_STATIC ON)
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_END_STATIC ON)
endif()

################################################################
# Library dependencies
################################################################

# List all dependencies
add_dependencies(${PROJECT_NAME} SFML Boost)

# SFML
set(SFML_STATIC_LIBRARIES ON)
set(SFML_ROOT ${REPOSITORY_DIR}/external/SFML/install)
use_package(${PROJECT_NAME} SFML 2 COMPONENTS graphics window system)

# Boost
set(Boost_USE_STATIC_LIBS ON)
set(BOOST_ROOT ${REPOSITORY_DIR}/external/Boost/install)
use_package(${PROJECT_NAME} Boost COMPONENTS thread)
