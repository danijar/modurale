# - Find Catch
# Find the Catch include
#
#  CATCH_INCLUDE_DIR - The include directory
#  CATCH_FOUND       - True if Catch has been found

find_path(CATCH_INCLUDE_DIR
	catch/catch.hpp
	HINTS ${CATCH_ROOT}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Catch DEFAULT_MSG CATCH_INCLUDE_DIR)

mark_as_advanced(CATCH_INCLUDE_DIR)
