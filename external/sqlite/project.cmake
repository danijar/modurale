################################################################
# SQLite
################################################################

cmake_minimum_required(VERSION 2.8.8)
include(ExternalProject)

# Download, configure, build and install.
ExternalProject_Add(SQLite
    # DEPENDS
    PREFIX            ${CMAKE_SOURCE_DIR}
    TMP_DIR           ${CMAKE_SOURCE_DIR}/temp
    STAMP_DIR         ${CMAKE_SOURCE_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR      ${CMAKE_SOURCE_DIR}/download
    URL               http://www.sqlite.org/2014/sqlite-autoconf-3080704.tar.gz
    URL_HASH          SHA1=70ca0b8884a6b145b7f777724670566e2b4f3cde
    #--Update/Patch step----------
    UPDATE_COMMAND    ${CMAKE_COMMAND} -E copy
                          ${CMAKE_SOURCE_DIR}/make.cmake
                          ${CMAKE_SOURCE_DIR}/source/CMakeLists.txt
    #--Configure step-------------
    SOURCE_DIR        ${CMAKE_SOURCE_DIR}/source
    CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
                      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                      -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    #--Build step-----------------
    BINARY_DIR        ${CMAKE_SOURCE_DIR}/build
    BUILD_COMMAND     ${CMAKE_COMMAND} --build .
    #--Install step---------------
    INSTALL_DIR       ${INSTALL_DIR}
)
