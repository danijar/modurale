# copy_file(<source> <dest>)
# Copy one file to another location.
function(copy_file SOURCE DEST)
    get_filename_component(DEST_DIR ${DEST} PATH)
    file(MAKE_DIRECTORY ${DEST_DIR})
    exec_program("${CMAKE_COMMAND} -E copy ${SOURCE} ${DEST}")
endfunction()

# add_config_variable(<name> <type> <default> <description>)
# Ensure an entry in the configuration. If it was not already set, initialize
# it with the provided default.
function(add_config_variable NAME TYPE DEFAULT DESCRIPTION)
    set(${NAME} ${DEFAULT} CACHE ${TYPE} "")
    set(${NAME} ${${NAME}} CACHE ${TYPE} ${DESCRIPTION} FORCE)
endfunction()

# set_global(<name> value...)
# Create or update a hidden variable in the CMake cache.
function(set_global NAME)
    set(${NAME} "${ARGN}" CACHE INTERNAL "" FORCE)
endfunction()

# invert(<value> <dest>)
# Sets the destination variable to the inverted boolean value.
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
