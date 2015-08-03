cmake_minimum_required(VERSION 2.8.8)

get_filename_component(REPOSITORY_DIR ${CMAKE_SOURCE_DIR}/.. ABSOLUTE)

set(CMAKE_INSTALL_PREFIX ${REPOSITORY_DIR}/install)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
    ${REPOSITORY_DIR}/cmake/script
    ${REPOSITORY_DIR}/cmake/find
    ${REPOSITORY_DIR}/cmake/use)

include(toolchain)
include(project)

add_project(Catch)
add_project(SQLite)
add_project(GLEW)
add_project(SFML     DEPENDS GLEW)
add_project(Boost)
add_project(Assimp   DEPENDS Boost)
add_project(Modurale DEPENDS Catch SQLite GLEW SFML Boost Assimp)
add_project(Game     DEPENDS Catch Modurale)
