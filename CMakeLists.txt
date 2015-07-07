################################################################
# Modurale
################################################################

cmake_minimum_required(VERSION 2.8.8)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
    cmake cmake/script cmake/find)

# Project
set(PROJECT_NAME modurale)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
set(${PROJECT_NAME_UPPER}_VERSION_MAJOR 0)
set(${PROJECT_NAME_UPPER}_VERSION_MINOR 1)
set(${PROJECT_NAME_UPPER}_VERSION_PATCH 0)
project(${PROJECT_NAME})

# Toolchain
include(toolchain)

# Targets
include(target)
create_target(${PROJECT_NAME}
	${CMAKE_SOURCE_DIR}/src)
create_target(tests
	${CMAKE_SOURCE_DIR}/test
	${CMAKE_SOURCE_DIR}/src/manager
	${CMAKE_SOURCE_DIR}/src/system)

# Download and setup dependencies
# Could also use a package manager instead
include(external/glew/build)
include(external/catch/build)
include(external/sqlite/build)
include(external/assimp/build)
include(external/boost/build)
include(external/sfml/build)

# Use depdendencies
# From both package manager and builded external projects
include(use/threads)
include(use/glew)
include(use/catch)
include(use/sqlite)
include(use/assimp)
include(use/boost)
include(use/sfml)
