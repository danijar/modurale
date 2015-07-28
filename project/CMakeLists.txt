cmake_minimum_required(VERSION 2.8.8)

get_filename_component(REPOSITORY_DIR ${CMAKE_SOURCE_DIR}/.. ABSOLUTE)

set(CMAKE_INSTALL_PREFIX ${REPOSITORY_DIR}/install)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
    ${REPOSITORY_DIR}/cmake/script
    ${REPOSITORY_DIR}/cmake/find
    ${REPOSITORY_DIR}/cmake/use)

include(toolchain)
include(project)
include(utility)

add_project(GLEW     CONFIGURE_TIME)
add_project(Catch    CONFIGURE_TIME)
add_project(SQLite   CONFIGURE_TIME)
add_project(Assimp   CONFIGURE_TIME)
add_project(Boost    CONFIGURE_TIME)
add_project(SFML     CONFIGURE_TIME)
add_project(Modurale BUILD_TIME)
# add_project(Game     BUILD_TIME)
