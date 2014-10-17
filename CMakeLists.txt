################################################################
# Project settings
################################################################

# CMake version
cmake_minimum_required(VERSION 2.8.4)

# Project name
set(PROJECT_NAME modurale)
project(${PROJECT_NAME})

# Version number
set(${PROJECT_NAME}_VERSION_MAJOR 0)
set(${PROJECT_NAME}_VERSION_MINOR 1)
set(${PROJECT_NAME}_VERSION_PATCH 0)

################################################################
# Include headers and source files
################################################################

# Recursively look for headers and source files and add them
set(SRC ${CMAKE_SOURCE_DIR}/src)
file(GLOB_RECURSE HEADER_FILES ${SRC}/*.hpp ${SRC}/*.inl)
file(GLOB_RECURSE SOURCE_FILES ${SRC}/*.cpp)
include_directories(${SRC})
add_executable(${PROJECT_NAME} ${HEADER_FILES} ${SOURCE_FILES})

################################################################
# Configure toolchain
################################################################

# Enable modern C++ features
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")

# Default to release builds without debug symbols
if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE Release)
endif()

# Link everything statically
set(BUILD_SHARED_LIBS FALSE)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a") # This isn't cross platform yet
set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_START_STATIC ON)
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_SEARCH_END_STATIC ON)

################################################################
# Helper functions
################################################################

# clean_up_list(<name>)
# Removes duplicates and empty items from the list. Excepts the name of this
# list as parameter, not its values.
function(CLEAN_UP_LIST NAME)
	list(REMOVE_DUPLICATES ${NAME})
	list(REMOVE_ITEM ${NAME} "")
	set(${NAME} ${${NAME}} PARENT_SCOPE)
endfunction()

# use_package(<name>)
# Tries both, the passed pretty name and it's uppercase version to see if a
# package was found. If so, includes headers and libraries. Otherwise, prints
# passed error message.
function(use_package NAME_PRETTY)
	# Not all libraries use uppercase prefix, so we try both
	string(TOUPPER ${NAME_PRETTY} NAME)
	# Collect headers an libraries from all variables we can think of. Some
	# libraries use plural form, some use singular. This may add duplicates and
	# empty items to the lists, so we need to clean them up later.
	set(INCLUDE_DIRS
		"${${NAME}_INCLUDE_DIRS}"
		"${${NAME}_INCLUDE_DIR}"
		"${${NAME_PRETTY}_INCLUDE_DIRS}"
		"${${NAME_PRETTY}_INCLUDE_DIR}")
	set(LIBRARIES
		"${${NAME}_LIBRARIES}"
		"${${NAME}_LIBRARY}"
		"${${NAME}_DEPENDENCIES}"
		"${${NAME_PRETTY}_LIBRARIES}"
		"${${NAME_PRETTY}_LIBRARY}"
		"${${NAME_PRETTY}_DEPENDENCIES}")
	clean_up_list(INCLUDE_DIRS)
	clean_up_list(LIBRARIES)
	# Include header directories and use libraries
	include_directories(${INCLUDE_DIRS})
	target_link_libraries(${PROJECT_NAME} ${LIBRARIES})
	# Print include dirs and libraries
	message(WARNING "${NAME_PRETTY} includes (${INCLUDE_DIRS}) and "
		"links (${LIBRARIES}).")
endfunction()

# find_and_use_package(<package> [version] [EXACT] [QUIET] [MODULE]
#  [REQUIRED] [[COMPONENTS] [components...]]
#  [OPTIONAL_COMPONENTS components...]
#  [NO_POLICY_SCOPE])
# Creates upper case configuration variable for a package, tries to find the
# package and includes it's headers and libraries. Otherwise, prints
# descriptive error messages.
function(find_and_use_package)
	# The first parameter is the library name.
	list(GET ARGN 0 NAME_PRETTY)
	string(TOUPPER ${NAME_PRETTY} NAME)
	set(ROOT ${NAME}_ROOT)
	# Create root variable or if exists, convert path to use forward slashes.
	file(TO_CMAKE_PATH "${${ROOT}}" ESCAPED)
	set(${ROOT} ${ESCAPED} CACHE FILEPATH "Path to ${NAME} library." FORCE)
	# Look for library and use it. Otherwise print instructions.
	find_package(${ARGN})
	if (${NAME}_FOUND OR ${NAME_PRETTY}_FOUND)
		use_package(${NAME_PRETTY})
	else()
		message(SEND_ERROR "${NAME_PRETTY} library not found. Please set "
			"${ROOT} to the installation directory.")
	endif()
endfunction()

################################################################
# Library dependencies
################################################################

# Set path to find scripts
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

# Define dependencies
add_dependencies(${PROJECT_NAME} SFML Boost)

# Automatically download dependencies
include(ExternalProject)
include(ExternalSFML)
include(ExternalBoost)

## SFML
set(SFML_STATIC_LIBRARIES ON)
find_and_use_package(SFML 2 COMPONENTS graphics window system)

## Boost
find_and_use_package(Boost COMPONENTS thread)
