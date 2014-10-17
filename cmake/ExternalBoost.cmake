# Boost
set(BOOST_PREFIX ${CMAKE_SOURCE_DIR}/external/Boost)

if(UNIX)
	set(BOOST_CONFIGURE_COMMAND ./bootstrap.sh)
	set(BOOST_BUILD_EXECUTABLE ./b2)
elseif(WIN32)
	set(BOOST_CONFIGURE_COMMAND bootstrap.bat)
	set(BOOST_BUILD_EXECUTABLE b2.exe)
endif()

ExternalProject_Add(Boost
	# DEPENDS
	PREFIX            ${BOOST_PREFIX}
	TMP_DIR           ${BOOST_PREFIX}/temp
	STAMP_DIR         ${BOOST_PREFIX}/stamp
	#--Download step--------------
	DOWNLOAD_DIR      ${BOOST_PREFIX}/download
	URL               http://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.gz
	URL_MD5           8c54705c424513fa2be0042696a3a162
	#--Update/Patch step----------
	UPDATE_COMMAND    ""
	#--Configure step-------------
	SOURCE_DIR        ${BOOST_PREFIX}/source
	CONFIGURE_COMMAND ${BOOST_CONFIGURE_COMMAND}
	#--Build step-----------------
	BUILD_COMMAND     ${BOOST_BUILD_EXECUTABLE} install
	                      --build-dir=${BOOST_PREFIX}/build
	                      --prefix=${BOOST_PREFIX}/install
	                      --build-type=complete
	BUILD_IN_SOURCE   1
	#--Install step---------------
	INSTALL_COMMAND   ""
)

set(BOOST_ROOT ${BOOST_PREFIX}/install)
