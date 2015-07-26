cmake_minimum_required(VERSION 2.8.8)

get_filename_component(REPOSITORY_DIR ${CMAKE_SOURCE_DIR}/.. ABSOLUTE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
    ${REPOSITORY_DIR}/cmake/script
    ${REPOSITORY_DIR}/cmake/find
    ${REPOSITORY_DIR}/cmake/use)

include(toolchain)

include(external)

build_subdirectory(glew)
build_subdirectory(catch)
build_subdirectory(sqlite)
#build_subdirectory(assimp)
build_subdirectory(boost)
build_subdirectory(sfml)

add_subdirectory(modurale)
#add_subdirectory(game)
