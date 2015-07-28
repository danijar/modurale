include(project)

# Prevent auto linking in Boost headers
add_definitions(-DBOOST_ALL_NO_LIB)

set(BOOST_INCLUDEDIR ${BOOST_ROOT}/include)

register_project(Boost
    INCLUDES Boost_INCLUDE_DIRS
    LIBRARIES Boost_LIBRARIES
    COMPONENTS thread system)
