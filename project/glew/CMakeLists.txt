################################################################
# GLEW
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(ExternalProject)

ExternalProject_Add(GLEW
    PREFIX               ${CMAKE_BINARY_DIR}
    TMP_DIR              temp
    STAMP_DIR            stamp
    #--Download step--------------
    DOWNLOAD_DIR         download
    URL                  http://garr.dl.sourceforge.net/project/glew/glew/1.12.0/glew-1.12.0.tgz
    URL_HASH             SHA1=070dfb61dbb7cd0915517decf467264756469a94
    #--Update/Patch step----------
    UPDATE_COMMAND       ""
    #--Configure step-------------
    SOURCE_DIR           source
    CONFIGURE_COMMAND    ""
    #--Build step-----------------
    BINARY_DIR           source
    BUILD_COMMAND        make all
    #--Install step---------------
    INSTALL_DIR          ${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND      env GLEW_DEST=${CMAKE_INSTALL_PREFIX} make install
)

# Dummy step to get an install target
install(CODE "")
