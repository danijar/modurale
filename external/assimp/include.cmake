################################################################
# Assimp
################################################################

# Build external project
include(build_subdirectory)
build_subdirectory(${CMAKE_CURRENT_LIST_DIR})
set(ASSIMP_ROOT ${CMAKE_CURRENT_LIST_DIR}/install CACHE FILEPATH "")
set(ASSIMP_ROOT ${ASSIMP_ROOT} CACHE FILEPATH "Path to Assimp installation." FORCE)

# Make sure libraries exist
find_package(Assimp QUIET)
if (ASSIMP_FOUND)
	foreach(LIBRARY ${ASSIMP_LIBRARIES})
		message(STATUS "Found ${LIBRARY}")
	endforeach()
	message(STATUS "Found ${ASSIMP_INCLUDE_DIR}")
	# Include headers and libraries
	include_directories(${ASSIMP_INCLUDE_DIR})
	target_link_libraries(modurale ${ASSIMP_LIBRARIES})
	target_link_libraries(tests    ${ASSIMP_LIBRARIES})
else()
	message(SEND_ERROR "Dependency Assimp not found, please set ASSIMP_ROOT.")
endif()
