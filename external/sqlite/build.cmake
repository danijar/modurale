include(external)
external_working_directory(SQLite WORKING_DIR)
# TODO: How to use relative path here?
copy_file(${CMAKE_SOURCE_DIR}/external/sqlite/make.cmake ${WORKING_DIR})
external_cmake_lists(SQLite "project.cmake")
