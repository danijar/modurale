# SFML
set(SFML_PREFIX ${CMAKE_SOURCE_DIR}/external/SFML)
ExternalProject_Add(SFML
	# DEPENDS
	PREFIX         ${SFML_PREFIX}
	TMP_DIR        ${SFML_PREFIX}/temp
	STAMP_DIR      ${SFML_PREFIX}/stamp
	#--Download step--------------
	GIT_REPOSITORY https://github.com/LaurentGomila/SFML.git
	GIT_TAG        e2c378e9d1
	#--Update/Patch step----------
	UPDATE_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR     ${SFML_PREFIX}/source
	CMAKE_ARGS     -DCMAKE_INSTALL_PREFIX:PATH=${SFML_PREFIX}/install
	#--Build step-----------------
	BINARY_DIR     ${SFML_PREFIX}/build
	#--Install step---------------
	INSTALL_DIR    ${SFML_PREFIX}/install
)

set(SFML_ROOT ${SFML_PREFIX}/install)
