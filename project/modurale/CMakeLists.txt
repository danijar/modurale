################################################################
# Modurale
################################################################

cmake_minimum_required(VERSION 2.8.12)

include(project)
include(utility)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_library(modurale ${SOURCE})
target_include_directories(modurale PRIVATE include)

collect_files(TEST PATHS test EXTENSIONS cpp)
add_executable(modurale-test ${SOURCE} ${TEST})
target_include_directories(modurale-test PRIVATE include)

use_project(Catch            modurale-test)
use_project(Threads modurale modurale-test)
use_project(GLEW    modurale modurale-test)
use_project(SQLite  modurale modurale-test)
use_project(Boost   modurale modurale-test)
use_project(SFML    modurale modurale-test)
use_project(Assimp  modurale modurale-test)

install_project(Modurale
    TARGETS modurale modurale-test
    INCLUDE_DIRS include
)
