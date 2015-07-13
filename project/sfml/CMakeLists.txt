include(external)
include(using)

use_package(GLEW)

external_cmake_lists(SFML "project.cmake"
    -DGLEW_LIBRARY=${GLEW_LIBRARY}
    -DGLEW_INCLUDE_PATH=${GLEW_INCLUDE_DIR})
