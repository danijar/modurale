include(utility)

# Enable modern C++ features
if (CMAKE_COMPILER_IS_GNUCXX)
	list(APPEND CMAKE_CXX_FLAGS -std=c++1y)
endif()

# Build variants; defaults to release
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
add_config_variable(CMAKE_BUILD_TYPE STRING "Release"
	"Whether to build Debug or Release builds.")

# Linkage type; default depends on platform
if (UNIX)
	set(BUILD_SHARED_LIBS ON CACHE BOOL "")
else()
	set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
endif()
add_config_variable(BUILD_SHARED_LIBS BOOL ON "Whether to build static or "
	"dynamic libraries of both the projects and its dependencies")

# Runtime library linkage is set to match general linkage
if (BUILD_SHARED_LIBS)
	set(USE_STATIC_STD_LIBS OFF)
else()
	set(USE_STATIC_STD_LIBS ON)
endif()
add_config_variable(USE_STATIC_STD_LIBS BOOL OFF
	"This is set to opposite of BUILD_SHARED_LIBS automatically.")

if (USE_STATIC_STD_LIBS)
	if (CMAKE_COMPILER_IS_GNUCXX)
		set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")
	elseif (MSVC)
		set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
		set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
	else()
		message(ERROR "Unsupported compiler.")
	endif()
endif()

# Find correct file extension for libraries
if (UNIX)
	if (BUILD_SHARED_LIBS)
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".so")
	else()
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	endif()
endif()
