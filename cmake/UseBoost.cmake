# Boost
set(BOOST_ROOT ${REPOSITORY_DIR}/external/Boost/install CACHE FILEPATH "")
set(BOOST_ROOT ${BOOST_ROOT} CACHE FILEPATH "Path to Boost library installation.")

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

# Find package and include headers and libraries
find_package(Boost COMPONENTS thread system)
if (Boost_FOUND)
	include_directories(${Boost_INCLUDE_DIR})
	target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES})
else()
	message(SEND_ERROR "Boost library not found. Please set BOOST_ROOT to the "
		"installation directory.")
endif()
