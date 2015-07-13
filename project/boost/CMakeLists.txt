################################################################
# Boost
################################################################

include(external)

# Runtime linking
if (NOT BUILD_SHARED_LIBS)
    set(Boost_USE_STATIC_LIBS TRUE)
    set(Boost_USE_STATIC_RUNTIME TRUE)
endif()

# Build variant
if (CMAKE_BUILD_TYPE MATCHES Debug)
    set(Boost_USE_DEBUG_RUNTIME TRUE)
endif()

external_cmake_lists(Boost "project.cmake")
