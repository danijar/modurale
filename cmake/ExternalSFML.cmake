# SFML
include(ExternalProject)
set(SFML_PREFIX ${CMAKE_SOURCE_DIR}/SFML)

# Download, configure, build and install.
ExternalProject_Add(SFML
	# DEPENDS
	PREFIX         ${SFML_PREFIX}
	TMP_DIR        ${SFML_PREFIX}/temp
	STAMP_DIR      ${SFML_PREFIX}/stamp
	#--Download step--------------
	DOWNLOAD_DIR   ${SFML_PREFIX}/source
	GIT_REPOSITORY https://github.com/LaurentGomila/SFML.git
	GIT_TAG        e2c378e9d1
	#--Update/Patch step----------
	UPDATE_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR     ${SFML_PREFIX}/source
	CMAKE_ARGS     -DCMAKE_INSTALL_PREFIX:PATH=${SFML_PREFIX}/install
	               -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
	               -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
	               -DSFML_USE_STATIC_STD_LIBS=${USE_STATIC_STD_LIBS}
	#--Build step-----------------
	BINARY_DIR     ${SFML_PREFIX}/build
	#--Install step---------------
	INSTALL_DIR    ${SFML_PREFIX}/install
)

# Set root so that find module knows where to look.
set(SFML_ROOT ${SFML_PREFIX}/install)
