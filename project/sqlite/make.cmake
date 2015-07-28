cmake_minimum_required(VERSION 2.8.8)

set(PROJECT_NAME sqlite)

# TODO: Remove unnecessary include_directories() call
# TODO: Use relative paths

include_directories(${CMAKE_SOURCE_DIR})
add_library(sqlite3 ${CMAKE_SOURCE_DIR}/sqlite3.c)

install(TARGETS sqlite3 DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(FILES sqlite3.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
