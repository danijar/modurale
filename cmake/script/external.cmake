include(utility)
include(logging)

add_config_variable(GIT_EXECUTABLE FILEPATH "git"
    "Path to the Git executable used to download dependencies.")
add_config_variable(EXTERNAL_LOGGING BOOL OFF
    "Verbose output of setting up external dependencies.")

# external_working_directory(<name> <dest-directory>)
# Creates and returns the working directory given a project name.
function(external_working_directory NAME DEST_DIR)
    string(TOLOWER ${NAME} LOWER_NAME)
    set(DIRECTORY ${REPOSITORY_DIR}/build/${LOWER_NAME})
    file(MAKE_DIRECTORY ${DIRECTORY})
    set(${DEST_DIR} ${DIRECTORY} PARENT_SCOPE)
endfunction()

# external_install_directory(<name> <dest-directory>)
# Creates and returns the installation directory given a project name.
function(external_install_directory NAME DEST_DIR)
    string(TOLOWER ${NAME} LOWER_NAME)
    set(DIRECTORY ${REPOSITORY_DIR}/install/${LOWER_NAME})
    file(MAKE_DIRECTORY ${DIRECTORY})
    set(${DEST_DIR} ${DIRECTORY} PARENT_SCOPE)
endfunction()

# build_subdirectory(<directory> [cmake-args...])
# Add another project and build it at configuration time.
function(build_subdirectory DIRECTORY)
    # Configure project
    exec_program(${CMAKE_COMMAND} ${DIRECTORY} ARGS
        -G\"${CMAKE_GENERATOR}\"
        -DCMAKE_CONFIGURATION_TYPES:STRING="Debug\;Release"
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
        ${ARGN})
    # Force build at compile time
    exec_program(${CMAKE_COMMAND} ${DIRECTORY} ARGS
        --build .
        --config ${CMAKE_BUILD_TYPE})
endfunction()

# external_cmake_lists(<name> <filename> [cmake-args...])
# Copies and executes a CMakeLists.txt in the correct location for external
# projects. The installation directory will be written to NAME_ROOT.
function(external_cmake_lists NAME FILENAME)
    message("################################################################")
    message("External project ${NAME}")
    message("################################################################")
    string(TOUPPER ${NAME} NAME_UPPER)
    # Get and ensure directories
    # TODO: Check if those are the defaults anyway and can be omitted in th
    # function calls below.
    external_working_directory(${NAME} WORKING_DIR)
    external_install_directory(${NAME} INSTALL_DIR)
    # Help find scripts to find the package later
    set(${NAME_UPPER}_ROOT ${INSTALL_DIR} CACHE FILEPATH
        "Installation location of ${NAME} dependency" FORCE)
    # Use content of existing file
    set(FILENAME ${CMAKE_CURRENT_LIST_DIR}/${FILENAME})
    if (EXISTS ${FILENAME})
        copy_file(${FILENAME} ${WORKING_DIR}/CMakeLists.txt)
    # Write new file from lines
    else()
        log_error("External project ${FILENAME} not found")
    endif()
    # Build project at configuration time
    invert(${EXTERNAL_LOGGING} LOG_TO_FILE)
    build_subdirectory(${WORKING_DIR}
        -DINSTALL_DIR=${INSTALL_DIR}
        -DLOGGING=${LOG_TO_FILE}
        ${ARGN})
    message("")
endfunction()
