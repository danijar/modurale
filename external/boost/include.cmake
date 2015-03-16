################################################################
# Boost
################################################################

# Build external project
include(build_subdirectory)
build_subdirectory(${CMAKE_CURRENT_LIST_DIR})
set(BOOST_ROOT ${CMAKE_CURRENT_LIST_DIR}/install CACHE FILEPATH "")
set(BOOST_ROOT ${BOOST_ROOT} CACHE FILEPATH "Path to Boost installation." FORCE)

# Runtime linking
if (NOT BUILD_SHARED_LIBS)
	set(Boost_USE_STATIC_LIBS TRUE)
	set(Boost_USE_STATIC_RUNTIME TRUE)
endif()

# Build variant
if (CMAKE_BUILD_TYPE MATCHES Debug)
	set(Boost_USE_DEBUG_RUNTIME TRUE)
endif()

# Prevent auto linking
add_definitions(-DBOOST_ALL_NO_LIB)

# Make sure libraries exist
find_package(Boost QUIET COMPONENTS thread system)
if (Boost_FOUND)
	message(STATUS "Found ${Boost_INCLUDE_DIR}")
	foreach (FILE ${Boost_LIBRARIES})
		message(STATUS "Found ${FILE}")
	endforeach()
	# Include headers and libraries
	include_directories(${Boost_INCLUDE_DIR})
	target_link_libraries(modurale ${Boost_LIBRARIES})
	target_link_libraries(tests    ${Boost_LIBRARIES})
else()
	message(SEND_ERROR "Dependency Boost not found, please set BOOST_ROOT.")
endif()
