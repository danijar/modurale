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
# Include headers and source files
################################################################

# Add source root as include location
include_directories(${CMAKE_SOURCE_DIR})

# Function to collect all code files from passed directories in
# ${PROJECT_NAME}_HEADERS and ${PROJECT_NAME}_SOURCES lists.
set(${PROJECT_NAME}_HEADERS)
set(${PROJECT_NAME}_SOURCES)
function(add_code)
	foreach(DIRECTORY ${ARGV})
		# Collect files from current directory
		file(GLOB_RECURSE ADD_HEADERS
			${CMAKE_SOURCE_DIR}/${DIRECTORY}/*.hpp
			${CMAKE_SOURCE_DIR}/${DIRECTORY}/*.inl)
		file(GLOB_RECURSE ADD_SOURCES
			${CMAKE_SOURCE_DIR}/${DIRECTORY}/*.cpp)
		# Add them to global lists
		list(APPEND ${PROJECT_NAME}_HEADERS ${ADD_HEADERS})
		list(APPEND ${PROJECT_NAME}_SOURCES ${ADD_SOURCES})
		set(${PROJECT_NAME}_HEADERS ${${PROJECT_NAME}_HEADERS} PARENT_SCOPE)
		set(${PROJECT_NAME}_SOURCES ${${PROJECT_NAME}_SOURCES} PARENT_SCOPE)
	endforeach()
endfunction()

# Add all directories containing project code
add_code(system manager type module application)
list(LENGTH ${PROJECT_NAME}_HEADERS ${PROJECT_NAME}_HEADERS_COUNT)
list(LENGTH ${PROJECT_NAME}_SOURCES ${PROJECT_NAME}_SOURCES_COUNT)
add_executable(${PROJECT_NAME}
	${${PROJECT_NAME}_HEADERS}
	${${PROJECT_NAME}_SOURCES})
message(STATUS "Add " ${${PROJECT_NAME}_HEADERS_COUNT} " headers and "
	${${PROJECT_NAME}_SOURCES_COUNT} " source files to project.")

# If set, force use of static libraries
if (NOT BUILD_SHARED_LIBS)
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_START_STATIC TRUE)
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_END_STATIC TRUE)
endif()

################################################################
# Generator settings
################################################################

# Configuration types
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING
	"Semicolon separated list of supported configuration types, only supports Debug, Release, MinSizeRel, and RelWithDebInfo, anything else will be ignored." FORCE)

################################################################
# Library dependencies
################################################################

include(UseBoost)
include(UseSFML)
