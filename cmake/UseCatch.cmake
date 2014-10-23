# Catch
set(CATCH_ROOT ${REPOSITORY_DIR}/external/Catch/install CACHE FILEPATH "")
set(CATCH_ROOT ${CATCH_ROOT} CACHE FILEPATH "Path to Catch installation." FORCE)

# Find package and include headers
find_package(Catch 2 QUIET)
if (CATCH_FOUND)
	include_directories(${CATCH_INCLUDE_DIR})
	message(STATUS "Found dependency Catch at " ${CATCH_ROOT} ".")
else()
	message(SEND_ERROR "Dependency Catch not found. Please set CATCH_ROOT to "
		"the installation directory.")
endif()
