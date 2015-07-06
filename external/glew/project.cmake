################################################################
# GLEW
################################################################

cmake_minimum_required(VERSION 2.8.8)
include(ExternalProject)

# Download, configure, build and install
ExternalProject_Add(GLEW
    # DEPENDS
    PREFIX             ${CMAKE_SOURCE_DIR}
    TMP_DIR            ${CMAKE_SOURCE_DIR}/temp
    STAMP_DIR          ${CMAKE_SOURCE_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR       ${CMAKE_SOURCE_DIR}/source
    URL                http://garr.dl.sourceforge.net/project/glew/glew/1.12.0/glew-1.12.0.tgz
    URL_HASH           SHA1=070dfb61dbb7cd0915517decf467264756469a94
    #--Update/Patch step----------
    UPDATE_COMMAND     ""
    #--Configure step-------------
    SOURCE_DIR         ${CMAKE_SOURCE_DIR}/source
    CONFIGURE_COMMAND  ""
    #--Build step-----------------
    BINARY_DIR         ${CMAKE_SOURCE_DIR}/source
    BUILD_COMMAND      make all
    #--Install step---------------
    INSTALL_DIR        ${INSTALL_DIR}
    INSTALL_COMMAND    GLEW_DEST=${INSTALL_DIR} make install
)
