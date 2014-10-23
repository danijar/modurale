# Catch
include(ExternalProject)
set(CATCH_PREFIX ${CMAKE_SOURCE_DIR}/Catch)

# Download, configure, build and install.
ExternalProject_Add(Catch
	# DEPENDS
	PREFIX            ${CATCH_PREFIX}
	TMP_DIR           ${CATCH_PREFIX}/temp
	STAMP_DIR         ${CATCH_PREFIX}/stamp
	#--Download step--------------
	DOWNLOAD_DIR      ${SFML_PREFIX}/source
	GIT_REPOSITORY    https://github.com/philsquared/Catch.git
	GIT_TAG           d4e5f18436
	#--Update/Patch step----------
	UPDATE_COMMAND    ""
	#--Configure step-------------
	CONFIGURE_COMMAND ""
	SOURCE_DIR        ${CATCH_PREFIX}/source
	#--Build step-----------------
	BUILD_COMMAND     ""
	BINARY_DIR        ${CATCH_PREFIX}
	#--Install step---------------
	INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy_directory source/include install/include
	INSTALL_DIR       ${CATCH_PREFIX}/install
)

# Set root so that find module knows where to look.
set(CATCH_ROOT ${CATCH_PREFIX}/install)
