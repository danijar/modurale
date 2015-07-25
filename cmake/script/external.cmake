include(utility)

add_config_variable(GIT_EXECUTABLE FILEPATH "git"
    "Path to the Git executable used to download dependencies.")
add_config_variable(LOG_EXTERNAL BOOL OFF
    "Verbose output of setting up external dependencies.")

# build_subdirectory(<directory-name> [cmake-args...])
# Build and install a directory relative to the current CMake file. The
# directory must contain a valid CMakeLists.txt. Defaults for build and install
# directories apply. The installation directory will be stored in a uppsercase
# variable named <source-dir>_ROOT.
function(build_subdirectory DIRECTORY_NAME)
    # TODO: Rename to build_external()
    string(TOUPPER ${DIRECTORY_NAME} NAME)
    message("################################################################")
    message("${NAME}")
    message("################################################################")
    build_directory(
        ${CMAKE_CURRENT_LIST_DIR}/${DIRECTORY_NAME}
        ${CMAKE_BINARY_DIR}/${DIRECTORY_NAME}
        ${REPOSITORY_DIR}/install/${DIRECTORY_NAME})
    # Help find scripts to find the package later
    set(${NAME}_ROOT ${INSTALL_DIR} CACHE FILEPATH
        "Installation location of ${DIRECTORY} dependency" FORCE)
    message("")
endfunction()

# build_directory(<source-dir> <build-dir> <install-dir> [cmake-args...])
# Build the project at source dir at configuration time. The directories to
# use for build files and installation files can be specified.
function(build_directory SOURCE_DIR BUILD_DIR INSTALL_DIR)
    # TODO: Rename to build_subdirectory()
    # TODO: Prepend ${CMAKE_CURRENT_LIST_DIR} if ${SOURCE_DIR} is relative
    # TODO: Prepend ${CMAKE_BINARY_DIR} if ${BUILD_DIR} is relative
    # Configure project
    invert(${LOG_EXTERNAL} LOG_TO_FILE)
    exec_program(${CMAKE_COMMAND} ${BUILD_DIR} ARGS ${SOURCE_DIR}
        -G\"${CMAKE_GENERATOR}\"
        -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -DCMAKE_CONFIGURATION_TYPES=\"Debug\;Release\"
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -DCMAKE_BINARY_DIR=${BUILD_DIR}
        -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
        -DLOGGING=${LOG_TO_FILE}
        ${ARGN})
    # Force build at compile time
    exec_program(${CMAKE_COMMAND} ${BUILD_DIR} ARGS
        --build .
        --config ${CMAKE_BUILD_TYPE})
endfunction()
