include(external)
include(utility)

external_working_directory(SQLite WORKING_DIR)
copy_file(${CMAKE_CURRENT_LIST_DIR}/make.cmake ${WORKING_DIR}/make.cmake)

external_cmake_lists(SQLite "project.cmake")
