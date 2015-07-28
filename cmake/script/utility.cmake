include(CMakeParseArguments)

# add_config_variable(<name> <type> <default> <description>)
# Ensure a cache entry in the configuration. If it does not exist,
# initialize it with the provided default.
function(add_config_variable NAME TYPE DEFAULT DESCRIPTION)
    set(${NAME} ${DEFAULT} CACHE ${TYPE} "")
    set(${NAME} ${${NAME}} CACHE ${TYPE} ${DESCRIPTION} FORCE)
endfunction()

add_config_variable(LOG_EXTERNAL BOOL OFF
    "Display output of external commands even if they exit successfully.")

# copy_file(<source> <dest>)
# Copy one file to another location.
function(copy_file SOURCE DEST)
    get_filename_component(DEST_DIR ${DEST} PATH)
    file(MAKE_DIRECTORY ${DEST_DIR})
    exec_program("${CMAKE_COMMAND} -E copy ${SOURCE} ${DEST}")
endfunction()

# set_global(<name> value...)
# Create or update a hidden variable in the CMake cache.
function(set_global NAME)
    set(${NAME} "${ARGN}" CACHE INTERNAL "" FORCE)
endfunction()

# invert(<value> <dest>)
# Set the destination variable to the inverted boolean value.
function(invert VALUE DEST)
    if (${VALUE})
        set(${DEST} OFF PARENT_SCOPE)
    else()
        set(${DEST} ON PARENT_SCOPE)
    endif()
endfunction()

# collect_files(<destination> PATHS [path...] EXTENSIONS [extension...])
# Recursively scan one or more directories for all files that end with one of
# the specified file extensions.
function(collect_files DESTINATION)
    cmake_parse_arguments(PARAM "" "" "PATHS;EXTENSIONS" ${ARGN})
    set(FILES)
    foreach(PATH ${PARAM_PATHS})
        foreach(EXTENSION ${PARAM_EXTENSIONS})
            file(GLOB_RECURSE FILES_CURRENT ${PATH}/*.${EXTENSION})
            list(APPEND FILES ${FILES_CURRENT})
        endforeach()
    endforeach()
    set(${DESTINATION} ${FILES} PARENT_SCOPE)
endfunction()

# execute_command(<directory> <command> <args-var>)
# Run a command in a given working directory and displays it's output on
# failure.
function(execute_command DIRECTORY COMMAND ARGS_VAR)
    execute_process(COMMAND ${COMMAND} ${${ARGS_VAR}}
        WORKING_DIRECTORY ${DIRECTORY}
        RESULT_VARIABLE EXITCODE
        OUTPUT_VARIABLE STDOUT
        ERROR_VARIABLE STDERR)
    if (EXITCODE)
        log_info("Error")
    elseif()
        log_info("Success")
    endif()
    if (EXITCODE OR LOG_EXTERNAL)
        log_info(${STDOUT})
    endif()
    if (STDERR)
        log_error(${STDERR})
    endif()
endfunction()

# Store escape sequences for terminal colors if supported by the terminal
if(NOT WIN32)
    string(ASCII 27 Esc)
    set(COLOR_RESET "${Esc}[m")
    set(COLOR_RED "${Esc}[31m")
    set(COLOR_GREEN "${Esc}[32m")
    set(COLOR_YELLOW "${Esc}[33m")
endif()

# log_success(message...)
# Print a message that will be formatted in green color.
function(log_success)
    message(STATUS "${COLOR_GREEN}${ARGV}${COLOR_RESET}")
endfunction()

# log_warning(message...)
# Report a warning that will be formatted in yellow color.
function(log_warning)
    message(STATUS "${COLOR_YELLOW}${ARGV}${COLOR_RESET}")
endfunction()

# log_error(message...)
# Throw an error that will be formatted in red color. This will stop the CMake
# execution.
function(log_error)
    message(SEND_ERROR "${COLOR_RED}${ARGV}${COLOR_RESET}")
endfunction()

# log_info(message...)
# Print a message.
function(log_info)
    message(STATUS "${ARGV}")
endfunction()

# print_headline(<text>)
function(print_headline TEXT)
    message("")
    message("################################################################")
    message(" ${TEXT}")
    message("################################################################")
    message("")
endfunction()
