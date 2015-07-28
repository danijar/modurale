include(project)

register_project(SFML
    INCLUDES SFML_INCLUDE_DIR
    LIBRARIES SFML_LIBRARIES SFML_DEPENDENCIES
    COMPONENTS graphics window system)
