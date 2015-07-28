include(CMakeParseArguments)
include(utility)

add_config_variable(GIT_EXECUTABLE FILEPATH "git"
    "Path to the Git executable used to download dependencies.")

# add_project(<project> CONFIGURE_TIME|BUILD_TIME)
# Add a project to the build system. The lowercase project name must be a
# directory relative to the current CMakeLists.txt using another CMake
# instance. The directory must contain a valid CMakeLists.txt. It can be
# specified whether the project is compiled at build time or already at
# configure time.
function(add_project PROJECT TIMING)
    string(TOLOWER ${PROJECT} DIRECTORY)
    print_headline(${PROJECT})
    # Add or build subdirectory
    if (TIMING STREQUAL "BUILD_TIME")
        add_subdirectory(${DIRECTORY})
    elseif (TIMING STREQUAL "CONFIGURE_TIME")
        _build_subdirectory(
            ${CMAKE_CURRENT_LIST_DIR}/${DIRECTORY}
            ${CMAKE_BINARY_DIR}/${DIRECTORY})
    else()
        log_error("Invalid timing parameter")
    endif()
endfunction()

# install_project(<project> [INCLUDES path...] [LIBRARIES target...]
#     [RUNTIMES target...] [FOLDERS path...])
# Install a project. Copy provided directories and targets into
# ${CMAKE_INSTALL_PREFIX}/<project>. Includes, libraries and runtimes  are
# places in subdirectories 'include/<project>', 'lib' and 'bin' respectively.
# Moreover, generate a configuration file and install it into the first include
# directory. It can be included by depending projects and makes
# <PROJECT>_INCLUDES and <PROJECT>_LIBRARIES available. The installation
# directory will be stored in an uppercase variable named <PROJECT>_ROOT.
function(install_project PROJECT)
    cmake_parse_arguments(PARAM "" "" "INCLUDES;LIBRARIES;RUNTIMES;FOLDERS"
        ${ARGN})
    set(ROOT ${CMAKE_INSTALL_PREFIX}/${PROJECT})
    # Install includes
    foreach(FOLDER ${PARAM_INCLUDES})
        install(DIRECTORY ${FOLDER}/ DESTINATION ${ROOT}/include/${PROJECT})
    endforeach()
    # Install binaries
    install(TARGETS ${PARAM_LIBRARIES} ${PARAM_RUNTIMES}
        RUNTIME DESTINATION ${ROOT}/bin
        LIBRARY DESTINATION ${ROOT}/lib
        ARCHIVE DESTINATION ${ROOT}/lib)
    # Install folders
    foreach(FOLDER ${PARAM_FOLDERS})
        install(DIRECTORY ${FOLDER} DESTINATION ${ROOT})
    endforeach()
    # Create configuration file
    # ...
    _set_root(${PROJECT} "${ROOT}")
endfunction()

# use_project(<project> [target...])
# Try to run a script of the name Use<project>.cmake that is expected to fill
# the variables <PROJECT>_INCLUDES and <PROJECT>_LIBRARIES. Their content is
# included and linked to all specified targets respectively. Usually those
# variables are filled either by including a <project>Config.cmake provided by
# that project or by using register_project() in combination with a
# Find<project>.cmake script.
function(use_project PROJECT)
    # Try to find the project
    string(TOUPPER ${PROJECT} PROJECT_UPPER)
    include(Use${PROJECT})
    if (NOT (${PROJECT_UPPER}_INCLUDES OR ${PROJECT_UPPER}_LIBRARIES))
        log_error("Dependency ${PROJECT} is not registered")
    endif()
    # Use includes and libraries
    foreach (TARGET ${ARGN})
        if (${PROJECT_UPPER}_INCLUDES)
            target_include_directories(${TARGET} PUBLIC
                ${${PROJECT_UPPER}_INCLUDES})
        endif()
        if (${PROJECT_UPPER}_LIBRARIES)
            target_link_libraries(${TARGET}
                ${${PROJECT_UPPER}_LIBRARIES})
        endif()
    endforeach()
    # Debug output
    if (${PROJECT_UPPER}_INCLUDES)
        log_success("Include ${${PROJECT_UPPER}_INCLUDES}")
    endif()
    if (${PROJECT_UPPER}_LIBRARIES AND ARGN)
        log_success("Link    ${${PROJECT_UPPER}_LIBRARIES} to ${ARGN}")
    endif()
endfunction()

# register_project(<project> [INCLUDES variable-name...]
#    [LIBRARIES variable-name...] [COMPONENTS component...])
# Try to call a find script for the requested project and fill the variables
# <PROJECT>_INCLUDES and <PROJECT>_LIBRARIES based on the specified output
# variable names. Optionally, forward components to the find script.
function(register_project PROJECT)
    cmake_parse_arguments(PARAM "" "" "INCLUDES;LIBRARIES;COMPONENTS" ${ARGN})
    string(TOUPPER ${PROJECT} PROJECT_UPPER)
    # Optionally include components
    set(FIND_STRING ${PROJECT})
    if (PARAM_COMPONENTS)
        set(FIND_STRING ${FIND_STRING} COMPONENTS ${PARAM_COMPONENTS})
    endif()
    # Try to use find script
    find_package(${FIND_STRING})
    if (${PROJECT_UPPER}_FOUND OR ${PROJECT}_FOUND)
        _register_from_varnames(${PROJECT} INCLUDES ${PARAM_INCLUDES})
        _register_from_varnames(${PROJECT} LIBRARIES ${PARAM_LIBRARIES})
    elseif()
        log_error("Depdendency ${PROJECT} not found")
    endif()
endfunction()

# _build_subdirectory(<source-dir> <build-dir> <install-dir> [cmake-args...])
# Build the project inside the source dir at configuration time. The
# directories to use for build files and installation files can be specified.
# The installation directory will be stored in an uppercase variable named
# <PROJECT>_ROOT.
function(_build_subdirectory SOURCE_DIR BUILD_DIR)
    file(MAKE_DIRECTORY ${BUILD_DIR})
    # TODO: Prepend ${CMAKE_CURRENT_LIST_DIR} if ${SOURCE_DIR} is relative
    # TODO: Prepend ${CMAKE_BINARY_DIR} if ${BUILD_DIR} is relative
    get_filename_component(PROJECT "${SOURCE_DIR}" NAME)
    set(ROOT ${CMAKE_INSTALL_PREFIX}/${PROJECT})
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
        -DCMAKE_INSTALL_PREFIX=${ROOT}
        ${ARGN}
        ${SOURCE_DIR})
    execute_command(${BUILD_DIR} ${CMAKE_COMMAND} ARGUMENTS)
    # Compile at configuration time
    log_info("Download, build and install")
    set(ARGUMENTS --build . --config ${CMAKE_BUILD_TYPE})
    execute_command(${BUILD_DIR} ${CMAKE_COMMAND} ARGUMENTS)
    # Help find scripts
    _set_root(${PROJECT} ${ROOT})
endfunction()

# _set_root(<project> <directory>)
# Set the global configuration variable <PROJECT>_ROOT to help find scripts to
# find the project.
function(_set_root PROJECT DIRECTORY)
    string(TOUPPER ${PROJECT} UPPER)
    # TODO: This should force set, but that's not supported by the utility yet
    add_config_variable(${UPPER}_ROOT FILEPATH ${DIRECTORY}
        "Installation directory of ${PROJECT}")
    log_info("Set ${UPPER}_ROOT to ${${UPPER}_ROOT}")
endfunction()

# _register_from_varnames(<project> <property> variable-name...)
# Collect values from one or more variables names and globally store them in
# ${PROJECT}_${PROPERTY}.
function(_register_from_varnames PROJECT PROPERTY)
    string(TOUPPER ${PROJECT} PROJECT_UPPER)
    set(ELEMENTS)
    foreach (VARNAME ${ARGN})
        foreach (ELEMENT ${${VARNAME}})
            set(ELEMENTS ${ELEMENTS} ${ELEMENT})
            # log_success("Register ${ELEMENT}")
        endforeach()
    endforeach()
    if (ELEMENTS)
        list(REMOVE_DUPLICATES ELEMENTS)
    endif()
    set_global(${PROJECT_UPPER}_${PROPERTY} ${ELEMENTS})
endfunction()
