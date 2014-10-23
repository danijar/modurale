# SFML
set(SFML_ROOT ${REPOSITORY_DIR}/external/SFML/install CACHE FILEPATH "")
set(SFML_ROOT ${SFML_ROOT} CACHE FILEPATH "Path to SFML installation." FORCE)

# Runtime linking
if (USE_STATIC_STD_LIBS)
	set(SFML_STATIC_LIBRARIES TRUE)
endif()

# Find package and include headers and libraries
find_package(SFML 2 QUIET COMPONENTS graphics window system)
if (SFML_FOUND)
	include_directories(${SFML_INCLUDE_DIR})
	target_link_libraries(${PROJECT_NAME} ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
	message(STATUS "Found dependency SFML at " ${SFML_ROOT} ".")
else()
	message(SEND_ERROR "Dependency SFML not found. Please set SFML_ROOT to the "
		"installation directory.")
endif()
