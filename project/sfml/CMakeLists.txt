################################################################
# SFML
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(ExternalProject)
include(project)

use_project(GLEW)

ExternalProject_Add(SFML
    PREFIX             ${CMAKE_CURRENT_BINARY_DIR}
    TMP_DIR            ${CMAKE_CURRENT_BINARY_DIR}/temp
    STAMP_DIR          ${CMAKE_CURRENT_BINARY_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR       ${CMAKE_CURRENT_BINARY_DIR}/source
    GIT_REPOSITORY     https://github.com/SFML/SFML.git
    GIT_TAG            e257909
    DOWNLOAD_NO_PROGRESS 1
    #--Update/Patch step----------
    UPDATE_COMMAND     ""
    #--Configure step-------------
    SOURCE_DIR         ${CMAKE_CURRENT_BINARY_DIR}/source
    CMAKE_ARGS         -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                       -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                       -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
                       -DGLEW_LIBRARY=${GLEW_LIBRARY}
                       -DGLEW_INCLUDE_PATH=${GLEW_INCLUDE_DIR}
    #--Build step-----------------
    BINARY_DIR         ${CMAKE_CURRENT_BINARY_DIR}/build
    #--Install step---------------
    INSTALL_DIR        ${CMAKE_INSTALL_PREFIX}
)

# Dummy step to get an install target
install(CODE "")
