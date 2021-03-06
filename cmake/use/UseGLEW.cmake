include(project)

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}
    ${GLEW_ROOT}/include)
set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH}
    ${GLEW_ROOT}/lib64)

register_project(GLEW
    INCLUDE_DIRS GLEW_INCLUDE_DIRS
    LIBRARIES GLEW_LIBRARIES)
