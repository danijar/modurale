include(using)

# Prevent auto linking in Boost headers
add_definitions(-DBOOST_ALL_NO_LIB)

use_package(Boost
    INCLUDES Boost_INCLUDE_DIRS
    LIBRARIES Boost_LIBRARIES
    COMPONENTS thread system)
