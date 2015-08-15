################################################################
# Assimp
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(ExternalProject)
include(project)

use_project(Boost)

# Hide warnings
if (CMAKE_COMPILER_IS_GNUCXX)
    list(APPEND CMAKE_CXX_FLAGS
        -Wno-unused-variable
        -Wno-unused-but-set-variable
        -Wno-incompatible-pointer-types
        -Wno-deprecated-variable)
endif()

# Debug symbols fix for Visual Studio
if (MSVC AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(ASSIMP_DEBUG_SYMBOLS_FIX "${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_BINARY_DIR}/build/code/assimp.dir/Debug/vc120.pdb
        ${CMAKE_CURRENT_BINARY_DIR}/build/code/Debug/assimpd.pdb")
else()
    set(ASSIMP_DEBUG_SYMBOLS_FIX "")
endif()

ExternalProject_Add(Assimp
    PREFIX               ${CMAKE_CURRENT_BINARY_DIR}
    TMP_DIR              temp
    STAMP_DIR            stamp
    #--Download step--------------
    DOWNLOAD_DIR         download
    GIT_REPOSITORY       https://github.com/assimp/assimp.git
    GIT_TAG              524834c
    DOWNLOAD_NO_PROGRESS 1
    #--Update/Patch step----------
    UPDATE_COMMAND       ""
    #--Configure step-------------
    SOURCE_DIR           source
    CMAKE_ARGS           -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                         -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                         -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
                         -DUSE_STATIC_STD_LIBS=${USE_STATIC_STD_LIBS}
                         -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
                         -DASSIMP_BUILD_ASSIMP_TOOLS=FALSE
    #--Build step-----------------
    BINARY_DIR           build
    #--Test step-----------------
    TEST_BEFORE_INSTALL  1
    TEST_COMMAND         ${ASSIMP_DEBUG_SYMBOLS_FIX}
    #--Install step---------------
    INSTALL_DIR          ${CMAKE_INSTALL_PREFIX}
)

# Dummy step to get an install target
install(CODE "")
