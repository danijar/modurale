################################################################
# SFML
################################################################

# Build external project
include(build_subdirectory)
build_subdirectory(${CMAKE_CURRENT_LIST_DIR})
set(SFML_ROOT ${CMAKE_CURRENT_LIST_DIR}/install CACHE FILEPATH "")
set(SFML_ROOT ${SFML_ROOT} CACHE FILEPATH "Path to SFML installation." FORCE)

# Linkage
if (BUILD_SHARED_LIBS)
	set(SFML_STATIC_LIBRARIES FALSE)
else()
	set(SFML_STATIC_LIBRARIES TRUE)
endif()

# Make sure libraries exist
find_package(SFML 2 QUIET COMPONENTS graphics window system)
if (SFML_FOUND)
	message(STATUS "Found ${SFML_INCLUDE_DIR}")
	foreach (FILE ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
		message(STATUS "Found ${FILE}")
	endforeach()
	# Include headers and libraries
	include_directories(${SFML_INCLUDE_DIR})
	target_link_libraries(modurale ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
	target_link_libraries(tests    ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
else()
	message(SEND_ERROR "Dependency SFML not found, please set SFML_ROOT.")
endif()
