################################################################
# Modurale
################################################################

include(logging)
include(utility)
include(using)

print_headline("MODURALE")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_library(modurale ${SOURCE})

collect_files(TEST PATHS test EXTENSIONS cpp)
add_executable(modurale-test ${SOURCE} ${TEST})

use_package(GLEW    modurale modurale-test)
use_package(Threads modurale modurale-test)
use_package(Catch   modurale modurale-test)
use_package(SQLite  modurale modurale-test)
use_package(Assimp  modurale modurale-test)
use_package(Boost   modurale modurale-test)
use_package(SFML    modurale modurale-test)

# include(install)
# install_package(engine include)
