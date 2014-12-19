# - Find SQLite
# Find the SQLite include and library
#
#  SQLITE_INCLUDE_DIR - The include directory
#  SQLITE_LIBRARY     - The library
#  SQLITE_FOUND       - True if SQLite has been found

find_path(SQLITE_INCLUDE_DIR
	include/sqlite3.h
	HINTS ${SQLITE_ROOT}
)

find_library(SQLITE_LIBRARY
	sqlite3
	HINTS ${SQLITE_ROOT}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SQLite DEFAULT_MSG SQLITE_LIBRARY SQLITE_INCLUDE_DIR)

mark_as_advanced(SQLITE_INCLUDE_DIR SQLITE_LIBRARY)
