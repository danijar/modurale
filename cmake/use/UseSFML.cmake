include(project)

register_project(SFML
    INCLUDE_DIRS SFML_INCLUDE_DIR
    LIBRARIES SFML_LIBRARIES SFML_DEPENDENCIES
    COMPONENTS graphics window system)
