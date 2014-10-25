################################################################
# General
################################################################

# CMake version
cmake_minimum_required(VERSION 2.8.12)

# Version information
set(MODURALE_VERSION_MAJOR 0)
set(MODURALE_VERSION_MINOR 1)
set(MODURALE_VERSION_PATCH 0)

# Declare projects
project(modurale)
project(tests)

# Include scripts
set(CMAKE_MODULE_PATH cmake ${CMAKE_MODULE_PATH})
include(ExternalProject)

################################################################
# Configure tool chain
################################################################

# Enable modern C++ features
if (UNIX OR MINGW)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
endif()

# Build variants, default to release
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
	"Whether to build Debug or Release builds." FORCE)

# Library linkage, default to static
set(BUILD_SHARED_LIBS FALSE CACHE BOOL "")
set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL
	"Whether to build static or dynamic libraries." FORCE)

# Runtime linkage, default to static
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

# Linkage options are mutually exclusive
if (BUILD_SHARED_LIBS AND USE_STATIC_STD_LIBS)
	message(FATAL_ERROR "Can't link libraries dynamically but runtime "
		"statically. BUILD_SHARED_LIBS and USE_STATIC_STD_LIBS are mutually "
		"exclusive.")
endif()

################################################################
# External settings
################################################################

# Make GIT_EXECUTABLE show up in the graphical user interface
set(GIT_EXECUTABLE "git" CACHE FILEPATH "")
set(GIT_EXECUTABLE ${GIT_EXECUTABLE} CACHE FILEPATH
	"Path to the git executable used to download dependencies." FORCE)

################################################################
# Project and test target
################################################################

# Create a target with all code from the given directory
function(create_project PROJECT ROOT)
	# Collect files inside project directory
	file(GLOB_RECURSE HEADERS ${ROOT}/*.hpp ${ROOT}/*.inl)
	file(GLOB_RECURSE SOURCES ${ROOT}/*.cpp)
	# Add the collected files and add root as include directory
	add_executable(${PROJECT} HEADERS SOURCES)
	include_directories(${ROOT})
	# Display status message
	list(LENGTH HEADERS HEADERS_COUNT)
	list(LENGTH SOURCES SOURCES_COUNT)
	message(STATUS "Added project " ${PROJECT} " with " ${HEADERS_COUNT} " "
		"headers and " ${SOURCES_COUNT} " source files.")
	# If use static libraries if set
	if (NOT BUILD_SHARED_LIBS)
		set_target_properties(${PROJECT} PROPERTIES LINK_SEARCH_START_STATIC TRUE)
		set_target_properties(${PROJECT} PROPERTIES LINK_SEARCH_END_STATIC TRUE)
	endif()
endfunction()

# Use function above
create_project(modurale ${CMAKE_SOURCE_DIR}/src)
create_project(tests ${CMAKE_SOURCE_DIR}/test)

################################################################
# Library dependencies
################################################################

# Add another project and build it at configure time
function(add_subdirectory_and_build DIRECTORY)
	# Configure project
	exec_program(${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/external/${DIRECTORY} ARGS
		-G\"${CMAKE_GENERATOR}\"
		-DCMAKE_CONFIGURATION_TYPES:STRING="Debug\;Release"
		-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
		-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
		-DUSE_STATIC_STD_LIBS:BOOL=${USE_STATIC_STD_LIBS}
		-DGIT_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE})
	# Force build at compile time
	exec_program(${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/external/${DIRECTORY} ARGS
		--build .
		--config ${CMAKE_BUILD_TYPE})
	# Clean up CMake files
	# ...
endfunction()

# Use function above
add_subdirectory_and_build(boost)
add_subdirectory_and_build(sfml)
add_subdirectory_and_build(catch)

# Find and include headers and binaries of
# dependencies that match the configuration
include(UseBoost)
include(UseSFML)
include(UseCatch)
