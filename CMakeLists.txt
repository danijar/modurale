cmake_minimum_required(VERSION 2.8.8)

set(REPOSITORY_DIR ${CMAKE_SOURCE_DIR})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
    ${REPOSITORY_DIR}/cmake/script
    ${REPOSITORY_DIR}/cmake/find
    ${REPOSITORY_DIR}/cmake/use)

add_subdirectory(project)
