# - Find Assimp
# Find the Assimp include and library
#
#  ASSIMP_INCLUDE_DIR - The include directory
#  ASSIMP_LIBRARIES   - The library and dependencies
#  ASSIMP_FOUND       - True if Assimp has been found

# Find include directory
find_path(ASSIMP_INCLUDE_DIR
	assimp/mesh.h
	HINTS ${ASSIMP_ROOT}/include
)

# Find correct prefix for Visual Studio binary
if (MSVC)
	if (MSVC70 OR MSVC71)
		set(MSVC_PREFIX "vc70")
	elseif (MSVC80)
		set(MSVC_PREFIX "vc80")
	elseif (MSVC90)
		set(MSVC_PREFIX "vc90")
	elseif (MSVC10)
		set(MSVC_PREFIX "vc100")
	elseif (MSVC11)
		set(MSVC_PREFIX "vc110")
	elseif (MSVC12)
		set(MSVC_PREFIX "vc120")
	else()
		set(MSVC_PREFIX "vc130")
	endif()
	set(ASSIMP_LIBRARY_SUFFIX "-${MSVC_PREFIX}-mt")
else()
	set(ASSIMP_LIBRARY_SUFFIX "")
endif()

# Debug mode suffix
if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
	set(ASSIMP_DEBUG_SUFFIX "d")
else()
	set(ASSIMP_DEBUG_SUFFIX "")
endif()

message(STATUS "Looking for assimp${ASSIMP_LIBRARY_SUFFIX}${ASSIMP_DEBUG_SUFFIX}")
message(STATUS "Looking for assimpzlibstatic${ASSIMP_DEBUG_SUFFIX}")

# Find binaries and store in list
find_library(ASSIMP_LIBRARY
	assimp${ASSIMP_LIBRARY_SUFFIX}${ASSIMP_DEBUG_SUFFIX}
	HINTS ${ASSIMP_ROOT}/lib
)

find_library(ZLIB_LIBRARY
	zlibstatic${ASSIMP_DEBUG_SUFFIX}
	HINTS ${ASSIMP_ROOT}/lib
)

set(ASSIMP_LIBRARIES ${ASSIMP_LIBRARY} ${ZLIB_LIBRARY})

# Handle arguments and hide configuration variables
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Assimp DEFAULT_MSG ASSIMP_LIBRARIES ASSIMP_INCLUDE_DIR)

mark_as_advanced(ASSIMP_INCLUDE_DIR ASSIMP_LIBRARIES)
