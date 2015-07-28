################################################################
# Catch
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(ExternalProject)

# Download, configure, build and install
ExternalProject_Add(Catch
    PREFIX             ${CMAKE_CURRENT_BINARY_DIR}
    TMP_DIR            ${CMAKE_CURRENT_BINARY_DIR}/temp
    STAMP_DIR          ${CMAKE_CURRENT_BINARY_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR       ${CMAKE_CURRENT_BINARY_DIR}/source
    GIT_REPOSITORY     https://github.com/philsquared/Catch.git
    GIT_TAG            3b18d9e
    #--Update/Patch step----------
    UPDATE_COMMAND     ""
    #--Configure step-------------
    CONFIGURE_COMMAND  ""
    SOURCE_DIR         ${CMAKE_CURRENT_BINARY_DIR}/source
    #--Build step-----------------
    BUILD_COMMAND      ""
    BINARY_DIR         ${CMAKE_CURRENT_BINARY_DIR}
    #--Install step---------------
    INSTALL_COMMAND    ${CMAKE_COMMAND} -E copy_directory
                           source/include ${CMAKE_INSTALL_PREFIX}
    INSTALL_DIR        ${CMAKE_INSTALL_PREFIX}
)
