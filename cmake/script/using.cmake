include(utility)
include(logging)
include(CMakeParseArguments)

# use_package(<package> [target...])
# Include directories and link libraries of the package to all specified
# targets. The package must be registered with register_package() first.
function(use_package PACKAGE)
    # Try to find the package
    string(TOUPPER ${PACKAGE} PACKAGE_UPPER)
    include(Use${PACKAGE})
    if (NOT (${PACKAGE_UPPER}_INCLUDES OR ${PACKAGE_UPPER}_LIBRARIES))
        log_error("Dependency ${PACKAGE} is not registered")
    endif()
    # Use includes and libraries
    foreach (TARGET ${ARGN})
        if (${PACKAGE_UPPER}_INCLUDES)
            target_include_directories(${TARGET} PUBLIC
                ${${PACKAGE_UPPER}_INCLUDES})
        endif()
        if (${PACKAGE_UPPER}_LIBRARIES)
            target_link_libraries(${TARGET}
                ${${PACKAGE_UPPER}_LIBRARIES})
        endif()
    endforeach()
    # Debug output
    if (${PACKAGE_UPPER}_INCLUDES)
        log_success("Include ${${PACKAGE_UPPER}_INCLUDES}")
    endif()
    if (${PACKAGE_UPPER}_LIBRARIES AND ARGN)
        log_success("Link    ${${PACKAGE_UPPER}_LIBRARIES} to ${ARGN}")
    endif()
endfunction()

# register_package(<package> [INCLUDES variable-name...]
#    [LIBRARIES variable-name...] [COMPONENTS component...])
# Try to call find script for the provided library name and include
# directories and link libraries based on the provided output variable names.
# Optionally, the needed components of the libraries passed to find_package()
# can be specified.
function(register_package PACKAGE)
    cmake_parse_arguments(PARAM "" "" "INCLUDES;LIBRARIES;COMPONENTS" ${ARGN})
    string(TOUPPER ${PACKAGE} PACKAGE_UPPER)
    # Optionally include components
    set(FIND_STRING ${PACKAGE})
    if (PARAM_COMPONENTS)
        set(FIND_STRING ${FIND_STRING} COMPONENTS ${PARAM_COMPONENTS})
    endif()
    # Try to use find script
    find_package(${FIND_STRING})
    if (${PACKAGE_UPPER}_FOUND OR ${PACKAGE}_FOUND)
        register_from_varnames(${PACKAGE} INCLUDES ${PARAM_INCLUDES})
        register_from_varnames(${PACKAGE} LIBRARIES ${PARAM_LIBRARIES})
    elseif()
        log_error("Depdendency ${PACKAGE} not found")
    endif()
endfunction()

# register_from_varnames(<package> <property> variable-name...)
# Collect values from one or more variables names and globally store them in
# ${PACKAGE}_${PROPERTY}.
function(register_from_varnames PACKAGE PROPERTY)
    string(TOUPPER ${PACKAGE} PACKAGE_UPPER)
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
    set_global(${PACKAGE_UPPER}_${PROPERTY} ${ELEMENTS})
endfunction()
