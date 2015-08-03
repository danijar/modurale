cmake_minimum_required(VERSION 2.8.12)

include(CMakeParseArguments)
include(ExternalProject)
include(utility)

add_config_variable(GIT_EXECUTABLE FILEPATH "git"
    "Path to the Git executable used to download dependencies.")

add_config_variable(INSTALL_SUBDIRECTORIES BOOL ON
    "Append the project's name to the installation path. Allows for clearer"
    "handeling during development. Do not use for system-wide installation.")

add_config_variable(LOG_USE_PROJECT BOOL OFF
    "Show detailed information of include directories and libraries that are"
    "found as part of use_package() calls.")

# Help binaries find dynamic dependenciesthat are not installed system-wide
set_global(CMAKE_INSTALL_RPATH_USE_LINK_PATH ON)

# add_project(<project>)
# Add a project to the build system. The lowercase project name must be a
# directory relative to the current CMake directory containing a valid
# CMakeLists.txt relative. The installation directory will be appended to
# CMAKE_PREFIX_PATH to hint find_package() calls there. It will be both
# configured and compiled when compiling the parent project. This is necessary
# since when configuring the parent project, dependencies might not be
# installed yet.
function(add_project PROJECT)
    cmake_parse_arguments(PARAM "" "" "DEPENDS" ${ARGN})
    string(TOLOWER ${PROJECT} PROJECT_LOWER)
    # Create a CMake target to resolve dependencies
    add_custom_target(${PROJECT} ALL DEPENDS ${PARAM_DEPENDS})
    # Define directories for this project
    # TODO: Get path difference between source dir and current source dir to
    # derive build and install dirs.
    set(SOURCE_DIR  ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_LOWER})
    set(BUILD_DIR   ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_LOWER})
    set(INSTALL_DIR ${CMAKE_INSTALL_PREFIX})
    if (INSTALL_SUBDIRECTORIES)
        set(INSTALL_DIR ${INSTALL_DIR}/${PROJECT_LOWER})
    endif()
    # Add the project
    _configure_and_build(${PROJECT}
        ${SOURCE_DIR} ${BUILD_DIR} ${INSTALL_DIR})
    # Help find scripts
    append_global(CMAKE_PREFIX_PATH ${INSTALL_DIR})
endfunction()

# use_project(<project> [target...])
# Try to run a script of the name Use<project>.cmake that is expected to fill
# the variables <PROJECT>_INCLUDE_DIRS and <PROJECT>_LIBRARIES as needed. Their
# content is included and linked to all specified targets respectively. Usually
# those variables are filled either by including a <project>Config.cmake
# provided by that project or by using register_project() in combination with a
# Find<project>.cmake script.
function(use_project PROJECT)
    string(TOUPPER ${PROJECT} PROJECT_UPPER)
    # Try to find the project
    include(Use${PROJECT})
    if (NOT (${PROJECT_UPPER}_INCLUDE_DIRS OR ${PROJECT_UPPER}_LIBRARIES))
        log_error("Dependency ${PROJECT} is not registered")
    endif()
    set(INCLUDE_DIRS ${${PROJECT_UPPER}_INCLUDE_DIRS})
    set(LIBRARIES ${${PROJECT_UPPER}_LIBRARIES})
    # Use includes and libraries
    foreach (TARGET ${ARGN})
        if (INCLUDE_DIRS)
            target_include_directories(${TARGET} PUBLIC ${INCLUDE_DIRS})
        endif()
        if (LIBRARIES)
            target_link_libraries(${TARGET} PUBLIC ${LIBRARIES})
        endif()
    endforeach()
    # Debug output
    if (LOG_USE_PROJECT)
        log_success("Use ${PROJECT}")
        if (ARGN)
            string(REPLACE ";" ", " TARGET_LIST "${ARGN}")
            log_success("Targets: ${TARGET_LIST}")
        endif()
        foreach(ELEMENT ${INCLUDE_DIRS})
            log_success("Include: ${ELEMENT}")
        endforeach()
        foreach(ELEMENT ${LIBRARIES})
            log_success("Library: ${ELEMENT}")
        endforeach()
        log_success()
    endif()
endfunction()

# install_project(<project> [TARGETS target...] [INCLUDE_DIRS path...]
#    [FOLDERS path...])
# Copy the binaries and include directories of the provided targets into
# standard subdirectories of ${CMAKE_INSTALL_PREFIX}/<project>. Optionally,
# additional folders can be specified that will be copies as well. Moreover, a
# configure file will be created that populates <PROJECT>_INCLUDE_DIRS,
# <PROJECT>_LIBRARIES and <PROJECT>_DEPENDENCIES to use the project. If called
# without targets and folders, this function will still ensure an existing
# install target.
function(install_project PROJECT)
    cmake_parse_arguments(PARAM "" "" "TARGETS;INCLUDE_DIRS;FOLDERS" ${ARGN})
    string(TOLOWER ${PROJECT} PROJECT_LOWER)
    # Dummy step to have least one step so CMakes generates the install target
    install(CODE "")
    # Install binaries
    install(TARGETS ${PARAM_TARGETS}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
    # Install include directories
    foreach(DIRECTORY ${PARAM_INCLUDE_DIRS})
        install(DIRECTORY ${DIRECTORY}/ DESTINATION
            ${CMAKE_INSTALL_PREFIX}/include/${PROJECT_LOWER})
    endforeach()
    # Install folders
    foreach(FOLDER ${PARAM_FOLDERS})
        install(DIRECTORY ${FOLDER} DESTINATION ${CMAKE_INSTALL_PREFIX})
    endforeach()
    # Create configuration file if there is something to use
    set(HAS_INCLUDE_DIR_OR_LIBRARY ${INCLUDE_DIRS})
    foreach (TARGET ${PARAM_TARGETS})
        get_target_property(TYPE ${TARGET} TYPE)
        if (TYPE MATCHES "_LIBRARY$")
            set(HAS_INCLUDE_DIR_OR_LIBRARY ON)
        endif()
    endforeach()
    if (HAS_INCLUDE_DIR_OR_LIBRARY)
        _standard_configure_file(${PROJECT} ${PARAM_TARGETS})
    endif()
endfunction()

# register_project(<project> [INCLUDE_DIRS variable-name...]
#    [LIBRARIES variable-name...] [VARIABLES variable-name...]
#    [COMPONENTS component...])
# Look for the project using the built-in function find_package() project and
# fill the variables <PROJECT>_INCLUDE_DIRS and <PROJECT>_LIBRARIES based on
# the specified output variable names. Variable names passed after VARIABLES
# will be made available to the parent scope. Also, library directories are
# used by the project if specified. Optionally, components can be forwarded to
# find_package().
function(register_project PROJECT)
    # TODO: Rename to find_project()
    cmake_parse_arguments(PARAM "" ""
        "INCLUDE_DIRS;LIBRARIES;VARIABLES;COMPONENTS" ${ARGN})
    string(TOUPPER ${PROJECT} PROJECT_UPPER)
    # Optionally include components
    set(FIND_STRING ${PROJECT})
    if (PARAM_COMPONENTS)
        set(FIND_STRING ${FIND_STRING} COMPONENTS ${PARAM_COMPONENTS})
    endif()
    # Use configure file or find script
    find_package(${FIND_STRING})
    if (${PROJECT_UPPER}_FOUND OR ${PROJECT}_FOUND)
        _register_from_varnames(${PROJECT} INCLUDE_DIRS ${PARAM_INCLUDE_DIRS})
        _register_from_varnames(${PROJECT} LIBRARIES ${PARAM_LIBRARIES})
        foreach(VARIABLE ${PARAM_VARIABLES})
            set_global(${VARIABLE} ${${VARIABLE}})
        endforeach()
    elseif()
        log_error("Depdendency ${PROJECT} not found")
    endif()
endfunction()

# _configure_and_build(<target> <source-dir> <build-dir> <install-dir>
#    [cmake-args...])
# Append actions to the target to both configure and build the project inside
# the source dir when building the parent project. The directories used for
# building and installation can be specified.
function(_configure_and_build TARGET SOURCE_DIR BUILD_DIR INSTALL_DIR)
    file(MAKE_DIRECTORY ${BUILD_DIR})
    # Print headline
    log_build(${TARGET}
        "\n================================================================\n"
        " ${TARGET}\n"
        "================================================================\n")
    # Configure
    escape_list(CMAKE_MODULE_PATH)
    escape_list(CMAKE_PREFIX_PATH)
    add_custom_command(TARGET ${TARGET}
        COMMAND ${CMAKE_COMMAND}
            --no-warn-unused-cli
            -G ${CMAKE_GENERATOR}
            -DREPOSITORY_DIR=${REPOSITORY_DIR}
            "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH_ESCAPED}"
            "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_ESCAPED}"
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
            -DCMAKE_BINARY_DIR=${BUILD_DIR}
            -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
            -DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}
            -DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}
            -DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}
            ${ARGN}
            ${SOURCE_DIR}
        WORKING_DIRECTORY ${BUILD_DIR})
    # Build
    add_custom_command(TARGET ${TARGET}
        COMMAND ${CMAKE_COMMAND}
            --build .
            --config ${CMAKE_BUILD_TYPE}
            --target install
        WORKING_DIRECTORY ${BUILD_DIR})
    log_build(${TARGET} "\n")
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

# _standard_configure_file(<project> target...)
# Automatically generate and install a configure file to use the targets of a
# project. Read include directories, libraries and dependencies from target
# properties.
function(_standard_configure_file PROJECT)
    string(TOUPPER ${PROJECT} PROJECT_UPPER)
    string(TOLOWER ${PROJECT} PROJECT_LOWER)
    # Collect properties
    set(CONFIG_INCLUDE_DIRS include)
    foreach(TARGET ${ARGN})
        get_target_property(TYPE ${TARGET} TYPE)
        if (TYPE MATCHES "_LIBRARY$")
            set(CONFIG_LIBRARIES ${CONFIG_LIBRARIES} ${TARGET})
        endif()
        get_target_property(FOLDER ${TARGET} INTERFACE_INCLUDE_DIRECTORIES)
        set(CONFIG_INCLUDE_DIRS ${CONFIG_INCLUDE_DIRS} ${FOLDER})
        get_target_property(DEPENDENCIES ${TARGET} INTERFACE_LINK_LIBRARIES)
        set(CONFIG_DEPENDENCIES ${CONFIG_DEPENDENCIES} ${DEPENDENCIES})
    endforeach()
    # Write configure file
    set(CONFIGURE_TEMPLATE ${REPOSITORY_DIR}/cmake/script/config.cmake.in)
    set(CONFIGURE_PATH ${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_LOWER})
    set(CONFIGURE_FILE ${CONFIGURE_PATH}/${PROJECT_LOWER}-config.cmake)
    configure_file(${CONFIGURE_TEMPLATE} ${CONFIGURE_FILE} @ONLY)
endfunction()
