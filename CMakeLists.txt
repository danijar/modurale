################################################################
# Modurale
################################################################

cmake_minimum_required(VERSION 2.8.8)
set(CMAKE_MODULE_PATH cmake ${CMAKE_MODULE_PATH})

# Project
set(PROJECT_NAME modurale)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
set(${PROJECT_NAME_UPPER}_VERSION_MAJOR 0)
set(${PROJECT_NAME_UPPER}_VERSION_MINOR 1)
set(${PROJECT_NAME_UPPER}_VERSION_PATCH 0)
project(${PROJECT_NAME})

# Tool chain
include(toolchain)

# Targets
include(target)
create_target(${PROJECT_NAME}
	${CMAKE_SOURCE_DIR}/src)
create_target(tests
	${CMAKE_SOURCE_DIR}/test
	${CMAKE_SOURCE_DIR}/src/manager
	${CMAKE_SOURCE_DIR}/src/system)

# Download dependencies; could also use platform's package manager
include(external/glew/build.cmake)
include(external/catch/build.cmake)
include(external/sqlite/build.cmake)
include(external/assimp/build.cmake)
include(external/boost/build.cmake)
include(external/sfml/build.cmake)

# Use depdendencies
include(external/glew/use.cmake)
include(external/catch/use.cmake)
include(external/sqlite/use.cmake)
include(external/assimp/use.cmake)
include(external/boost/use.cmake)
include(external/sfml/use.cmake)
