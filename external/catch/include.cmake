################################################################
# Catch
################################################################

# Build external project
include(external)
external_cmake_lists(catch "external.cmake")

# Find package and include headers
find_package(Catch QUIET)
if (CATCH_FOUND)
    message(STATUS "Found ${CATCH_INCLUDE_DIR}")
    # Include headers and libraries
    include_directories(${CATCH_INCLUDE_DIR})
else()
    message(SEND_ERROR "Dependency Catch not found, please set CATCH_ROOT.")
endif()
