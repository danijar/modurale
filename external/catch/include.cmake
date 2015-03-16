################################################################
# Catch
################################################################

# Build external project
include(build_subdirectory)
build_subdirectory(${CMAKE_CURRENT_LIST_DIR})
set(CATCH_ROOT ${CMAKE_CURRENT_LIST_DIR}/install CACHE FILEPATH "")
set(CATCH_ROOT ${CATCH_ROOT} CACHE FILEPATH "Path to Catch installation." FORCE)

# Find package and include headers
find_package(Catch QUIET)
if (CATCH_FOUND)
	message(STATUS "Found ${CATCH_INCLUDE_DIR}")
	# Include headers and libraries
	include_directories(${CATCH_INCLUDE_DIR})
else()
	message(SEND_ERROR "Dependency Catch not found, please set CATCH_ROOT.")
endif()
