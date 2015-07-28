################################################################
# Game
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(project)
include(utility)

include_directories(include)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_executable(game ${HEADER} ${SOURCE})

collect_files(TEST PATHS test EXTENSIONS cpp)
add_executable(game-test ${HEADER} ${SOURCE} ${TEST})

use_project(modurale game game-test)

install_project(game
    RUNTIMES game game-test
    # FOLDERS script texture mesh
)
