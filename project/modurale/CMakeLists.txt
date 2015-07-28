################################################################
# Modurale
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(project)
include(utility)

include_directories(include)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_library(modurale ${SOURCE})

collect_files(TEST PATHS test EXTENSIONS cpp)
add_executable(modurale-test ${SOURCE} ${TEST})

use_project(GLEW    modurale modurale-test)
use_project(Threads modurale modurale-test)
use_project(Catch   modurale modurale-test)
use_project(SQLite  modurale modurale-test)
use_project(Assimp  modurale modurale-test)
use_project(Boost   modurale modurale-test)
use_project(SFML    modurale modurale-test)

install_project(modurale
    INCLUDES  include
    LIBRARIES modurale
    RUNTIMES  modurale-test
    # FOLDERS script
)
