################################################################
# Catch
################################################################

cmake_minimum_required(VERSION 2.8.8)
include(ExternalProject)

# Download, configure, build and install
ExternalProject_Add(Catch
    # DEPENDS
    PREFIX            ${CMAKE_SOURCE_DIR}
    TMP_DIR           ${CMAKE_SOURCE_DIR}/temp
    STAMP_DIR         ${CMAKE_SOURCE_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR      ${CMAKE_SOURCE_DIR}/source
    GIT_REPOSITORY    https://github.com/philsquared/Catch.git
    GIT_TAG           3b18d9e
    #--Update/Patch step----------
    UPDATE_COMMAND    ""
    #--Configure step-------------
    CONFIGURE_COMMAND ""
    SOURCE_DIR        ${CMAKE_SOURCE_DIR}/source
    #--Build step-----------------
    BUILD_COMMAND     ""
    BINARY_DIR        ${CMAKE_SOURCE_DIR}
    #--Install step---------------
    INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy_directory
                          source/include ${INSTALL_DIR}
    INSTALL_DIR       ${INSTALL_DIR}
)
