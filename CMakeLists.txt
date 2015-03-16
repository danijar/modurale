# Project
set(PROJECT_NAME modurale)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

cmake_minimum_required(VERSION 2.8.12)
set(${PROJECT_NAME_UPPER}_VERSION_MAJOR 0)
set(${PROJECT_NAME_UPPER}_VERSION_MINOR 1)
set(${PROJECT_NAME_UPPER}_VERSION_PATCH 0)
project(${PROJECT_NAME})
set(CMAKE_MODULE_PATH cmake ${CMAKE_MODULE_PATH})

# Tool chain
include(configure_tool_chain)

# Targets
include(create_target)
create_target(${PROJECT_NAME}
	${CMAKE_SOURCE_DIR}/src)
create_target(tests
	${CMAKE_SOURCE_DIR}/test
	${CMAKE_SOURCE_DIR}/src/manager
	${CMAKE_SOURCE_DIR}/src/system)

# Dependencies
include(${CMAKE_SOURCE_DIR}/external/boost/include.cmake)
include(${CMAKE_SOURCE_DIR}/external/sfml/include.cmake)
include(${CMAKE_SOURCE_DIR}/external/catch/include.cmake)
include(${CMAKE_SOURCE_DIR}/external/sqlite/include.cmake)
include(${CMAKE_SOURCE_DIR}/external/assimp/include.cmake)
