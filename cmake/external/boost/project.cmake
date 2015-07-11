################################################################
# Boost
################################################################

cmake_minimum_required(VERSION 2.8.8)
include(ExternalProject)

# Find platform dependend commands to configure
# and compile, fail if unclear
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
if (USE_STATIC_STD_LIBS AND WIN32)
    set(BOOST_RUNTIME_LINK static)
else()
    set(BOOST_RUNTIME_LINK shared)
endif()

# Adress model
if (UNIX)
    set(BOOST_ADDRESS_MODEL 64)
elseif (WIN32)
    set(BOOST_ADDRESS_MODEL 32)
endif()

# Use collected variables to download, configure, build
# and install.
ExternalProject_Add(Boost
    PREFIX            ${CMAKE_SOURCE_DIR}
    TMP_DIR           ${CMAKE_SOURCE_DIR}/temp
    STAMP_DIR         ${CMAKE_SOURCE_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR      ${CMAKE_SOURCE_DIR}/download
    URL               http://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.gz
    URL_MD5           8c54705c424513fa2be0042696a3a162
    #--Update/Patch step----------
    UPDATE_COMMAND    ""
    #--Configure step-------------
    SOURCE_DIR        ${CMAKE_SOURCE_DIR}/source
    CONFIGURE_COMMAND ${BOOST_CONFIGURE_COMMAND}
    #--Build step-----------------
    BUILD_COMMAND     ${BOOST_BUILD_EXECUTABLE} install
                          --build-dir=${CMAKE_SOURCE_DIR}/build
                          --prefix=${INSTALL_DIR}
                          variant=${BOOST_VARIANT}
                          link=${BOOST_LINK}
                          threading=multi
                          address-model=${BOOST_ADDRESS_MODEL}
                          toolset=${BOOST_TOOLSET}
                          runtime-link=${BOOST_RUNTIME_LINK}
                          --with-thread
                          --with-system
                          -sNO_BZIP2=1
    BUILD_IN_SOURCE   1
    #--Install step---------------
    INSTALL_COMMAND   ""
    #--Output logging-------------
    LOG_DOWNLOAD      ${LOGGING}
    LOG_UPDATE        ${LOGGING}
    LOG_CONFIGURE     ${LOGGING}
    LOG_BUILD         ${LOGGING}
    LOG_TEST          ${LOGGING}
    LOG_INSTALL       ${LOGGING}
)
