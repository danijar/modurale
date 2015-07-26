# TODO: Rename this file?

include(utility)
include(logging)

add_config_variable(GIT_EXECUTABLE FILEPATH "git"
    "Path to the Git executable used to download dependencies.")

# build_subdirectory(<directory-name> [cmake-args...])
# Build and install a directory relative to the current CMake file. The
# directory must contain a valid CMakeLists.txt. Defaults for build and install
# directories apply. The installation directory will be stored in a uppsercase
# variable named <source-dir>_ROOT.
function(build_subdirectory DIRECTORY_NAME)
    # TODO: Rename to build_external()
    string(TOUPPER ${DIRECTORY_NAME} NAME)
    print_headline(${NAME})
    set(INSTALL_DIR ${REPOSITORY_DIR}/install/${DIRECTORY_NAME})
    build_directory(
        ${CMAKE_CURRENT_LIST_DIR}/${DIRECTORY_NAME}
        ${CMAKE_BINARY_DIR}/${DIRECTORY_NAME}
        ${INSTALL_DIR})
    # Help find scripts to find the package later
    set(${NAME}_ROOT ${INSTALL_DIR} CACHE FILEPATH
        "Installation location of ${DIRECTORY} dependency" FORCE)
    log_info("Set ${NAME}_ROOT to ${${NAME}_ROOT}")
endfunction()

# build_directory(<source-dir> <build-dir> <install-dir> [cmake-args...])
# Build the project at source dir at configuration time. The directories to
# use for build files and installation files can be specified.
function(build_directory SOURCE_DIR BUILD_DIR INSTALL_DIR)
    file(MAKE_DIRECTORY ${BUILD_DIR})
    file(MAKE_DIRECTORY ${INSTALL_DIR})
    # TODO: Rename to build_subdirectory()
    # TODO: Prepend ${CMAKE_CURRENT_LIST_DIR} if ${SOURCE_DIR} is relative
    # TODO: Prepend ${CMAKE_BINARY_DIR} if ${BUILD_DIR} is relative
    # Configure project
    log_info("Configure")
    string(REPLACE ";" "\;" CMAKE_MODULE_PATH_ESCAPED "${CMAKE_MODULE_PATH}")
    set(ARGUMENTS
        -G ${CMAKE_GENERATOR}
        "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH_ESCAPED}"
        -DCMAKE_CONFIGURATION_TYPES=Debug\;Release
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -DCMAKE_BINARY_DIR=${BUILD_DIR}
        -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
        ${ARGN}
        ${SOURCE_DIR})
    execute_command(${BUILD_DIR} ${CMAKE_COMMAND} ARGUMENTS)
    # Compile at configuration time
    log_info("Download, build and install")
    set(ARGUMENTS --build . --config ${CMAKE_BUILD_TYPE})
    execute_command(${BUILD_DIR} ${CMAKE_COMMAND} ARGUMENTS)
endfunction()

# execute_command(<directory> <command> <args-var>)
# Runs a command in a given working directory and displays it's output on
# failure.
function(execute_command DIRECTORY COMMAND ARGS_VAR)
    execute_process(COMMAND ${COMMAND} ${${ARGS_VAR}}
        WORKING_DIRECTORY ${DIRECTORY}
        RESULT_VARIABLE EXITCODE
        OUTPUT_VARIABLE STDOUT
        ERROR_VARIABLE STDERR)
    if (EXITCODE EQUAL 0)
        log_info("Success")
    elseif()
        log_info("Error")
        log_info(${STDOUT})
    endif()
    if (STDERR)
        log_error(${STDERR})
    endif()
endfunction()
