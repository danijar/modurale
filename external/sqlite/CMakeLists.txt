# SQLite
cmake_minimum_required(VERSION 2.8.8)
include(ExternalProject)

# Add CMake project file
file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/temp)
file(WRITE ${CMAKE_SOURCE_DIR}/temp/CMakeLists.txt
	"cmake_minimum_required(VERSION 2.8.8)\n"
	"set(PROJECT_NAME sqlite)\n"
	"include_directories(${CMAKE_SOURCE_DIR}/source)\n"
	"add_library(sqlite3 ${CMAKE_SOURCE_DIR}/source/sqlite3.c)\n"
	"install(TARGETS sqlite3 DESTINATION lib)\n"
	"install(FILES sqlite3.h DESTINATION include)\n")

# Download, configure, build and install.
ExternalProject_Add(SQLite
	# DEPENDS
	PREFIX            ${CMAKE_SOURCE_DIR}
	TMP_DIR           ${CMAKE_SOURCE_DIR}/temp
	STAMP_DIR         ${CMAKE_SOURCE_DIR}/stamp
	#--Download step--------------
	DOWNLOAD_DIR      ${SFML_PREFIX}/download
	URL               http://www.sqlite.org/2014/sqlite-autoconf-3080704.tar.gz
	URL_HASH          SHA1=70ca0b8884a6b145b7f777724670566e2b4f3cde
	#--Update/Patch step----------
	UPDATE_COMMAND    ${CMAKE_COMMAND} -E copy
	                      ${CMAKE_SOURCE_DIR}/temp/CMakeLists.txt
	                      ${CMAKE_SOURCE_DIR}/source/CMakeLists.txt
	#--Configure step-------------
	SOURCE_DIR        ${CMAKE_SOURCE_DIR}/source
	CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}/install
	                  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
	                  -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
	#--Build step-----------------
	BINARY_DIR        ${CMAKE_SOURCE_DIR}/build
	BUILD_COMMAND	  ${CMAKE_COMMAND} --build .
	#--Install step---------------
	INSTALL_DIR       ${CMAKE_SOURCE_DIR}/install
)
