################################################################
# use_found_package(<name-pretty> <depender>)
# Tries both, the passed pretty name and it's uppercase version to see if a
# package was found. If so, includes headers and links libraries aginst the
# depender. Otherwise, prints passed error message.
################################################################

function(use_found_package NAME_PRETTY DEPENDER)
	# Not all libraries use uppercase prefix, so we try both
	string(TOUPPER ${NAME_PRETTY} NAME)
	# Collect headers an libraries from all variables we can think of. Some
	# libraries use plural form, some use singular. This may add duplicates and
	# empty items to the lists, so we need to clean them up later.
	set(INCLUDE_DIRS
		"${${NAME}_INCLUDE_DIRS}"
		"${${NAME}_INCLUDE_DIR}"
		"${${NAME_PRETTY}_INCLUDE_DIRS}"
		"${${NAME_PRETTY}_INCLUDE_DIR}")
	list(REMOVE_DUPLICATES INCLUDE_DIRS)
	list(REMOVE_ITEM INCLUDE_DIRS "")
	# However, the build configuration is a form of wanted duplicates in the
	# LIBRARIES list, so we just remove empty entries here.
	set(LIBRARIES
		"${${NAME}_LIBRARIES}"
		"${${NAME}_LIBRARY}"
		"${${NAME}_DEPENDENCIES}")
	list(REMOVE_ITEM LIBRARIES "")
	if (NOT LIBRARIES)
		set(LIBRARIES
			"${${NAME_PRETTY}_LIBRARIES}"
			"${${NAME_PRETTY}_LIBRARY}"
			"${${NAME_PRETTY}_DEPENDENCIES}")
		list(REMOVE_ITEM LIBRARIES "")
	endif()
	# Include header directories and use libraries
	include_directories(${INCLUDE_DIRS})
	target_link_libraries(${DEPENDER} ${LIBRARIES})
	# Print include dirs and libraries
	message(STATUS "${NAME_PRETTY} includes (${INCLUDE_DIRS}) and "
		"links (${LIBRARIES}).")
endfunction()

################################################################
# use_package(<depender> <package> [version] [EXACT] [QUIET] [MODULE]
#  [REQUIRED] [[COMPONENTS] [components...]]
#  [OPTIONAL_COMPONENTS components...]
#  [NO_POLICY_SCOPE])
# First parameter is target to link the package to. The following parameters
# are equivalent to the find_package command. Creates upper case configuration
# variable for a package, tries to find the package and includes it's headers
# and libraries. Otherwise, prints descriptive error messages.
################################################################

function(use_package DEPENDER)
	# The first parameter is the library name.
	list(GET ARGN 0 NAME_PRETTY)
	string(TOUPPER ${NAME_PRETTY} NAME)
	set(ROOT ${NAME}_ROOT)
	# Create root variable or if exists, convert path to use forward slashes.
	file(TO_CMAKE_PATH "${${ROOT}}" ESCAPED)
	set(${ROOT} ${ESCAPED} CACHE FILEPATH "Path to ${NAME} library." FORCE)
	# Look for library and use it. Otherwise print instructions.
	find_package(${ARGN})
	if (${NAME}_FOUND OR ${NAME_PRETTY}_FOUND)
		use_found_package(${NAME_PRETTY} ${DEPENDER})
	else()
		message(SEND_ERROR "${NAME_PRETTY} library not found. Please set "
			"${ROOT} to the installation directory.")
	endif()
endfunction()
