################################################################
# SFML
################################################################

# Linkage option name
if (BUILD_SHARED_LIBS)
    set(SFML_STATIC_LIBRARIES FALSE)
else()
    set(SFML_STATIC_LIBRARIES TRUE)
endif()

# Build external project
include(external)
external_cmake_lists(sfml "external.cmake"
    -DSFML_STATIC_LIBRARIES=${SFML_STATIC_LIBRARIES}
    -DGLEW_LIBRARY=${GLEW_LIBRARIES}
    -DGLEW_INCLUDE_PATH=${GLEW_INCLUDE_DIRS})

# Make sure libraries exist
find_package(SFML 2 QUIET COMPONENTS graphics window system)
if (SFML_FOUND)
    message(STATUS "Found ${SFML_INCLUDE_DIR}")
    foreach (FILE ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
        message(STATUS "Found ${FILE}")
    endforeach()
    # Include headers and libraries
    include_directories(${SFML_INCLUDE_DIR})
    target_link_libraries(modurale ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
    target_link_libraries(tests    ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
else()
    message(SEND_ERROR "Dependency SFML not found, please set SFML_ROOT.")
endif()
