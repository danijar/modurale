################################################################
# Game
################################################################

cmake_minimum_required(VERSION 2.8.8)

include(utility)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

collect_files(SOURCE PATHS src EXTENSIONS cpp)
add_executable(game ${HEADER} ${SOURCE})
add_dependencies(game engine)
target_link_libraries(game engine)

collect_files(TEST PATHS test EXTENSIONS cpp)
add_executable(game-test ${HEADER} ${SOURCE} ${TEST})
add_dependencies(game-test engine)
target_link_libraries(game-test engine)
