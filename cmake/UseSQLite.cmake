# SQLite
set(SQLITE_ROOT ${CMAKE_SOURCE_DIR}/external/sqlite/install CACHE FILEPATH "")
set(SQLITE_ROOT ${SQLITE_ROOT} CACHE FILEPATH "Path to SQLite installation." FORCE)

# Find package and include headers
find_package(SQLite QUIET)
if (SQLITE_FOUND)
	include_directories(${SQLITE_INCLUDE_DIR})
	target_link_libraries(modurale ${SQLITE_LIBRARY})
	target_link_libraries(tests    ${SQLITE_LIBRARY})
	message(STATUS "Found dependency SQLite at " ${SQLITE_ROOT} ".")
else()
	message(SEND_ERROR "Dependency SQLite not found. Please set SQLITE_ROOT to "
		"the installation directory.")
endif()
