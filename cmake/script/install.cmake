# install_package(<target> <path> [folder...])
function(install_package TARGET)
    # Install binaries
    install(TARGETS ${TARGET}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )
    # Install folders
    foreach(FOLDER ${ARGN})
        file(GLOB CONTENTS "${CMAKE_CURRENT_SOURCE_DIR}/${FOLDER}/*")
        install(FILES ${CONTENTS} DESTINATION ${folder})
    endforeach()
    # Create CMake configuration file
    #${${TARGET}_INCLUDE_DIRS}
    #${${TARGET}_LIBRARIES}
endfunction()
