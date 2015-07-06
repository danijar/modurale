# create_target(<name> [directories...])
# Create an executable from all code found inside the given directories.
function(create_target NAME)
	set(HEADERS)
	set(SOURCES)
	# Collect files inside project directories
	foreach(ROOT ${ARGN})
		file(GLOB_RECURSE HEADERS_CURRENT ${ROOT}/*.hpp ${ROOT}/*.inl)
		file(GLOB_RECURSE SOURCES_CURRENT ${ROOT}/*.cpp)
		list(APPEND HEADERS ${HEADERS_CURRENT})
		list(APPEND SOURCES ${SOURCES_CURRENT})
		include_directories(${ROOT})
	endforeach()
	# Add the collected files and add root as include directory
	add_executable(${NAME} ${HEADERS} ${SOURCES})
	# Display status message
	list(LENGTH HEADERS HEADERS_COUNT)
	list(LENGTH SOURCES SOURCES_COUNT)
	message(STATUS "Added project " ${NAME} " with " ${HEADERS_COUNT} " "
		"headers and " ${SOURCES_COUNT} " source files.")
endfunction()
