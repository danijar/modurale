# SFML
set(SFML_ROOT ${CMAKE_SOURCE_DIR}/external/sfml/install CACHE FILEPATH "")
set(SFML_ROOT ${SFML_ROOT} CACHE FILEPATH "Path to SFML installation." FORCE)

# Linkage
if (BUILD_SHARED_LIBS)
	set(SFML_STATIC_LIBRARIES FALSE)
else()
	set(SFML_STATIC_LIBRARIES TRUE)
endif()

# Find package and include headers and libraries
find_package(SFML 2 QUIET COMPONENTS graphics window system)
if (SFML_FOUND)
	include_directories(${SFML_INCLUDE_DIR})
	target_link_libraries(modurale ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
	target_link_libraries(tests    ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
	message(STATUS "Found dependency SFML at " ${SFML_ROOT} ".")
else()
	message(SEND_ERROR "Dependency SFML not found. Please set SFML_ROOT to the "
		"installation directory.")
endif()
