# Make GIT_EXECUTABLE show up in the graphical user interface
set(GIT_EXECUTABLE "git" CACHE FILEPATH "")
set(GIT_EXECUTABLE ${GIT_EXECUTABLE} CACHE FILEPATH
	"Path to the git executable used to download dependencies." FORCE)

# Add another project and build it at configure time
function(build_subdirectory DIRECTORY)
	# Configure project
	exec_program(${CMAKE_COMMAND} ${DIRECTORY} ARGS
		-G\"${CMAKE_GENERATOR}\"
		-DCMAKE_CONFIGURATION_TYPES:STRING="Debug\;Release"
		-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
		-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
		-DUSE_STATIC_STD_LIBS:BOOL=${USE_STATIC_STD_LIBS}
		-DGIT_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE})
	# Force build at compile time
	exec_program(${CMAKE_COMMAND} ${DIRECTORY} ARGS
		--build .
		--config ${CMAKE_BUILD_TYPE})
	# Clean up CMake files
	# ...
endfunction()
