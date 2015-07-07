# Enable modern C++ features
if (UNIX OR MINGW)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
endif()

# Build variants; defaults to release
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
	"Whether to build Debug or Release builds." FORCE)

# Dependency linkage type; default depends on platform
if (UNIX)
	set(BUILD_SHARED_LIBS ON CACHE BOOL "")
else()
	set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
endif()
set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL
	"Whether to build static or dynamic libraries." FORCE)

# Runtime library linkage is set to match other library's linkage
if (BUILD_SHARED_LIBS)
	set(USE_STATIC_STD_LIBS OFF)
else()
	set(USE_STATIC_STD_LIBS ON)
endif()
set(USE_STATIC_STD_LIBS ${USE_STATIC_STD_LIBS} CACHE BOOL
	"This is set to opposite of USE_STATIC_STD_LIBS automatically." FORCE)

# Runtime linkage; defaults to static
if (USE_STATIC_STD_LIBS)
	if (UNIX OR MINGW)
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
