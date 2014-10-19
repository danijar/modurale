# Boost
include(ExternalProject)
set(BOOST_PREFIX ${CMAKE_SOURCE_DIR}/Boost)

# Find platform dependend commands to configure
# and compile. Fail if unclear.
if (UNIX)
	set(BOOST_CONFIGURE_COMMAND ./bootstrap.sh)
	set(BOOST_BUILD_EXECUTABLE ./b2)
	set(BOOST_TOOLSET gcc)
elseif (WIN32)
	set(BOOST_CONFIGURE_COMMAND bootstrap.bat)
	set(BOOST_BUILD_EXECUTABLE b2.exe)
else()
	message(ERROR "Unsupported platform.")
endif()

# Find compiler toolset. Fail if unclear.
if (UNIX OR MINGW)
	set(BOOST_TOOLSET gcc)
elseif (WIN32 AND MSVC)
	set(BOOST_TOOLSET msvc)
else()
	message(ERROR "Unsupported compiler.")
endif()

# Use linking type from global BUILD_SHARED_LIBS
# variable. Defaults to static.
if (BUILD_SHARED_LIBS)
	set(BOOST_LINK shared)
else()
	set(BOOST_LINK static)
endif()

# Use build variant from global CMAKE_BUILD_TYPE.
# Defaults to release.
if (CMAKE_BUILD_TYPE MATCHES Debug)
	set(BOOST_VARIANT debug)
else()
	set(BOOST_VARIANT release)
endif()

# Use runtime linkingtype from global
# USE_STATIC_STD_LIBS. Defaults to shared.
if (USE_STATIC_STD_LIBS)
	set(BOOST_RUNTIME_LINK static)
else()
	set(BOOST_RUNTIME_LINK shared)
endif()

# Use collected variables to download, configure, build
# and install.
ExternalProject_Add(Boost
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
	                      variant=${BOOST_VARIANT}
	                      link=${BOOST_LINK}
	                      threading=multi
	                      address-model=32
	                      toolset=${BOOST_TOOLSET}
	                      runtime-link=${BOOST_RUNTIME_LINK}
	BUILD_IN_SOURCE   1
	#--Install step---------------
	INSTALL_COMMAND   ""
)

# Set root so that find module knows where to look.
set(BOOST_ROOT ${BOOST_PREFIX}/install)
