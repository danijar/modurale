################################################################
# Game
################################################################

cmake_minimum_required(VERSION 2.8.12)

include(project)
include(utility)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_executable(game ${SOURCE})

use_project(Modurale game)

install_project(Game TARGETS game)
