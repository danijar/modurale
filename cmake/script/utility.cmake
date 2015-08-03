include(CMakeParseArguments)

# add_config_variable(<name> <type> <default> <description>)
# Ensure a cache entry in the configuration. If it does not exist,
# initialize it with the provided default.
function(add_config_variable NAME TYPE DEFAULT DESCRIPTION)
    if (${NAME})
        # Preserve user choice
        set(${NAME} ${DEFAULT} CACHE ${TYPE} "")
    else()
        # Overwrite empty CMake defaults
        set(${NAME} ${DEFAULT})
    endif()
    # Write to global cache
    set(${NAME} ${${NAME}} CACHE ${TYPE} ${DESCRIPTION} FORCE)
endfunction()

add_config_variable(LOG_EXTERNAL BOOL ON
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

# append_global(<name> value...)
# Add elements to a hidden variable in the CMake cache. If the variable does
# not exist, it will be created.
function(append_global NAME)
    set(COMBINED "${${NAME}}" "${ARGN}")
    list(REMOVE_DUPLICATES COMBINED)
    set_global(${NAME} ${COMBINED})
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

# escape_list(<list-name>)
# Escapes the separators for a list so that it can be passed as a single value.
# The result will be stored in <list-name>_ESCAPED. This is needed for passing
# lists to command line calls. Note that you have to surround the escaped
# variable in quites when using it, otherwise CMake will turn it back into a
# normal list.
function(escape_list LIST_NAME)
    string(REPLACE ";" "\;" ${LIST_NAME}_ESCAPED "${${LIST_NAME}}")
    set(${LIST_NAME}_ESCAPED "${${LIST_NAME}_ESCAPED}" PARENT_SCOPE)
endfunction()

# execute_command(<directory> <command> <args-var>)
# Run a command in a given working directory and displays it's output on
# failure.
# function(execute_command DIRECTORY COMMAND ARGS_VAR)
#     execute_process(COMMAND ${COMMAND} ${${ARGS_VAR}}
#         WORKING_DIRECTORY ${DIRECTORY}
#         RESULT_VARIABLE EXITCODE
#         OUTPUT_VARIABLE STDOUT
#         ERROR_VARIABLE STDERR)
#     if (EXITCODE)
#         log_info("Error")
#     elseif()
#         log_info("Success")
#     endif()
#     if (EXITCODE OR LOG_EXTERNAL)
#         log_info(${STDOUT})
#     endif()
#     if (STDERR)
#         log_error(${STDERR})
#     endif()
# endfunction()

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

# log_build(<target> message...)
# Print a message as part of building the specified target.
function(log_build TARGET)
    # Join elements
    string(REPLACE ";" "" JOINED "${ARGN}")
    # Split lines since they must be printed separately
    string(REPLACE "\n" " ;" LINES "${JOINED}")
    foreach(MESSAGE ${LINES})
        add_custom_command(TARGET ${TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo ${MESSAGE})
    endforeach()
endfunction()
