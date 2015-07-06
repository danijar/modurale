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
include(external/glew/include.cmake)

# Use dependencies
# include(${CMAKE_SOURCE_DIR}/external/boost/include.cmake)
# if (UNIX)
#     include(${CMAKE_SOURCE_DIR}/external/glew/include.cmake)
# endif()
# include(${CMAKE_SOURCE_DIR}/external/sfml/include.cmake)
# include(${CMAKE_SOURCE_DIR}/external/catch/include.cmake)
# include(${CMAKE_SOURCE_DIR}/external/sqlite/include.cmake)
# include(${CMAKE_SOURCE_DIR}/external/assimp/include.cmake)
