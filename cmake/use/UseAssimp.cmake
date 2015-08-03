include(project)
include(utility)

register_project(Assimp
    INCLUDE_DIRS ASSIMP_INCLUDE_DIRS
    LIBRARIES ASSIMP_LIBRARIES
    VARIABLES ASSIMP_LIBRARY_DIRS)

foreach(LIBRARY ${ASSIMP_LIBRARIES})
    # Work around Assimp always returning debug versions
    if (CMAKE_BUILD_TYPE STREQUAL "Release")
        string(REGEX REPLACE "d$" "" LIBRARY ${LIBRARY})
    endif()
    # Work around Assimp using a link directory variable
    find_library(ABSOLUTE ${LIBRARY} ${ASSIMP_LIBRARY_DIRS})
    list(APPEND UPDATED_LIBRARIES ${ABSOLUTE})
endforeach()
set_global(ASSIMP_LIBRARIES ${UPDATED_LIBRARIES})
