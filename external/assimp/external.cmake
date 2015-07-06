################################################################
# Assimp
################################################################

cmake_minimum_required(VERSION 2.8.8)
include(ExternalProject)

# Debug symbols fix for Visual Studio
if (MSVC AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(ASSIMP_DEBUG_SYMBOLS_FIX ${CMAKE_COMMAND} -E copy
        ${CMAKE_SOURCE_DIR}/build/code/assimp.dir/Debug/vc120.pdb
        ${CMAKE_SOURCE_DIR}/build/code/Debug/assimpd.pdb)
else()
    set(ASSIMP_DEBUG_SYMBOLS_FIX "")
endif()

# Download, configure, build and install
ExternalProject_Add(Assimp
    # DEPENDS
    PREFIX         ${CMAKE_SOURCE_DIR}
    TMP_DIR        ${CMAKE_SOURCE_DIR}/temp
    STAMP_DIR      ${CMAKE_SOURCE_DIR}/stamp
    #--Download step--------------
    DOWNLOAD_DIR   ${CMAKE_SOURCE_DIR}/source
    GIT_REPOSITORY https://github.com/assimp/assimp.git
    GIT_TAG        dca3f09
    #--Update/Patch step----------
    UPDATE_COMMAND ""
    #--Configure step-------------
    SOURCE_DIR     ${CMAKE_SOURCE_DIR}/source
    CMAKE_ARGS     -DCMAKE_INSTALL_PREFIX=${CMAKE_SOURCE_DIR}/install
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
                   -DUSE_STATIC_STD_LIBS=${USE_STATIC_STD_LIBS}
                   -DASSIMP_BUILD_ASSIMP_TOOLS=FALSE
                   -DASSIMP_ENABLE_BOOST_WORKAROUND=TRUE
    #--Build step-----------------
    BINARY_DIR     ${CMAKE_SOURCE_DIR}/build
    #--Test step-----------------
    TEST_BEFORE_INSTALL 1
    TEST_COMMAND   ${ASSIMP_DEBUG_SYMBOLS_FIX}
    #--Install step---------------
    INSTALL_DIR    ${CMAKE_SOURCE_DIR}/install
)
