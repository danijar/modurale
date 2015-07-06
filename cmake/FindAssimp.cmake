# - Find Assimp
# Find the Assimp include and library
#
#  ASSIMP_INCLUDE_DIR - The include directory
#  ASSIMP_LIBRARY     - The library
#  ASSIMP_DEPENDENCY  - The dependency
#  ASSIMP_FOUND       - True if Assimp has been found

message(WARNING ${ASSIMP_ROOT})

find_path(ASSIMP_INCLUDE_DIR
	assimp/mesh.h
	HINTS ${ASSIMP_ROOT}/include
)

find_library(ASSIMP_LIBRARY
	assimp
	HINTS ${ASSIMP_ROOT}/lib
)

if (NOT BUILD_SHARED_LIBS)
	find_library(ASSIMP_DEPENDENCY
		zlibstatic
		HINTS ${ASSIMP_ROOT}/lib
	)
endif()

include(FindPackageHandleStandardArgs)
if (BUILD_SHARED_LIBS)
	find_package_handle_standard_args(Assimp DEFAULT_MSG ASSIMP_LIBRARY ASSIMP_INCLUDE_DIR)
	mark_as_advanced(ASSIMP_INCLUDE_DIR ASSIMP_LIBRARY)
else()
	find_package_handle_standard_args(Assimp DEFAULT_MSG ASSIMP_LIBRARY ASSIMP_DEPENDENCY ASSIMP_INCLUDE_DIR)
	mark_as_advanced(ASSIMP_INCLUDE_DIR ASSIMP_LIBRARY ASSIMP_DEPENDENCY)
endif()
