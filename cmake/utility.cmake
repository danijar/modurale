# copy_file(<source> <dest>)
# Copy one file to another location.
function(copy_file SOURCE DEST)
    exec_program("${CMAKE_COMMAND} -E copy ${SOURCE} ${DEST}")
endfunction()

# add_config_variable(<name> <type> <default> <description>)
# Ensure an entry in the configuration. If it was not already set, initialize
# it with the provided default.
function(add_config_variable NAME TYPE DEFAULT DESCRIPTION)
    set(${NAME} ${DEFAULT} CACHE ${TYPE} "")
    set(${NAME} ${${NAME}} CACHE ${TYPE} ${DESCRIPTION} FORCE)
endfunction()
