################################################################
# SQLite
################################################################

# Build external project
include(external)
external_cmake_lists(sqlite "external.cmake")

# Make sure libraries exist
find_package(SQLite QUIET)
if (SQLITE_FOUND)
    message(STATUS "Found ${SQLITE_INCLUDE_DIR}")
    message(STATUS "Found ${SQLITE_LIBRARY}")
    # Include headers and libraries
    include_directories(${SQLITE_INCLUDE_DIR})
    target_link_libraries(modurale ${SQLITE_LIBRARY})
    target_link_libraries(tests    ${SQLITE_LIBRARY})
else()
    message(SEND_ERROR "Dependency SQLite not found, please set SQLITE_ROOT.")
endif()
