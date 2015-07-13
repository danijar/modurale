################################################################
# Engine
################################################################

include(utility)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_library(engine ${SOURCE})
add_dependencies(engine external)

collect_files(TEST PATHS test EXTENSIONS cpp)
add_executable(engine-tests ${SOURCE} ${TEST})
add_dependencies(engine-tests external)

use_package(GLEW    engine engine-tests)
use_package(Threads engine engine-tests)
use_package(Catch   engine engine-tests)
use_package(SQLite  engine engine-tests)
#use_package(Assimp  engine engine-tests)
use_package(Boost   engine engine-tests)
use_package(SFML    engine engine-tests)

# include(install)
# install_package(engine include)
