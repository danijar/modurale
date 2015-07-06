################################################################
# GLEW
################################################################

# Build external project
include(external)
external_cmake_lists(glew "external.cmake")

# Help CMake's built-in find script
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}
    ${GLEW_ROOT}/include)
set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH}
    ${GLEW_ROOT}/lib64)

# Make sure library exist
find_package(GLEW REQUIRED)
foreach (FILE ${GLEW_INCLUDE_DIRS} ${GLEW_LIBRARIES})
    message(STATUS "Found ${FILE}")
endforeach()

# Include headers and libraries
include_directories(${GLEW_INCLUDE_DIRS})
target_link_libraries(modurale ${GLEW_LIBRARIES})
target_link_libraries(tests    ${GLEW_LIBRARIES})
