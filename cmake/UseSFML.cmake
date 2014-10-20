# SFML
set(SFML_ROOT ${REPOSITORY_DIR}/external/SFML/install CACHE FILEPATH "")
set(SFML_ROOT ${SFML_ROOT} CACHE FILEPATH "Path to SFML library installation.")

# Runtime linking
if (USE_STATIC_STD_LIBS)
	set(SFML_STATIC_LIBRARIES TRUE)
endif()

# Find package and include headers and libraries
find_package(SFML 2 COMPONENTS graphics window system)
if (SFML_FOUND)
	include_directories(${SFML_INCLUDE_DIR})
	target_link_libraries(${PROJECT_NAME} ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
else()
	message(SEND_ERROR "SFML library not found. Please set SFML_ROOT to the "
		"installation directory.")
endif()
