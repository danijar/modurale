include(logging)
include(utility)
include(CMakeParseArguments)

# use_package(<name> [INCLUDES variable-name...] [LIBRARIES variable-name...]
#    [COMPONENTS component...])
# Try to call find script for the prorvided library name and include
# directories and link libraries based on the provided output variable names.
# Optionally, the needed components of the libraries passed to find_package()
# can be specified.
function(use_package NAME)
    cmake_parse_arguments(PARAM "" "" "INCLUDES;LIBRARIES;COMPONENTS" ${ARGN})
    string(TOUPPER ${NAME} NAME_UPPER)
    # Optionally include components
    set(FIND_STRING ${NAME})
    if (PARAM_COMPONENTS)
        set(FIND_STRING ${FIND_STRING} COMPONENTS ${PARAM_COMPONENTS})
    endif()
    # Try to use find script
    find_package(${FIND_STRING})
    if (${NAME_UPPER}_FOUND OR ${NAME}_FOUND)
        add_includes_from_varnames(${PARAM_INCLUDES})
        add_libraries_from_varnames(${PARAM_LIBRARIES})
    elseif()
        log_error("Depdendency ${NAME} not found")
    endif()
endfunction()

# add_includes_from_varnames(variable-name...)
# All include directories from the contents of one or more variable names.
function(add_includes_from_varnames)
    foreach (VARNAME ${ARGN})
        foreach (DIR ${${VARNAME}})
            log_success("Add directory: ${DIR}")
            include_directories(${DIR})
        endforeach()
    endforeach()
endfunction()

# add_libraries_from_varnames(variable-name...)
# Link libraries to all targets created by create_target() from the contents of
# one or more variable names.
function(add_libraries_from_varnames)
    foreach (VARNAME ${ARGN})
        foreach (LIB ${${VARNAME}})
            log_success("Add library:   ${LIB}")
            # Link to all targets in global list, set by create_target()
            foreach (TARGET ${ALL_TARGETS})
                target_link_libraries(${TARGET} ${LIB})
            endforeach()
        endforeach()
    endforeach()
endfunction()
