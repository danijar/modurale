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
        # Include directories
        foreach (VARNAME ${PARAM_INCLUDES})
            foreach (DIR ${${VARNAME}})
                log_success("Found directory: ${DIR}")
                include_directories(${DIR})
            endforeach()
        endforeach()
        # Library fields
        foreach (VARNAME ${PARAM_LIBRARIES})
            foreach (LIB ${${VARNAME}})
                log_success("Found library:   ${LIB}")
                target_link_libraries(modurale ${LIB})
                target_link_libraries(tests ${LIB})
            endforeach()
        endforeach()
    elseif()
        log_error("Depdendency ${NAME} not found")
    endif()
endfunction()
