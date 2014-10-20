Installation
============

This guide describes how to set up a development environment of the project in
order to work on and compile it. You need [Git][git] and [CMake][cmake] to build
this project. This guide assumes you use the graphical interface of CMake but
you can use the command line tool directly as well.

[git]: http://git-scm.com/downloads
[cmake]: http://www.cmake.org/download/

Dependencies
------------

This project comes with build scripts capable of downloading and building all
dependencies automatically. They will create a sub directory for each dependency
under `<repository>/external`, where downloaded source, intermediate files and
the final libraries get stored. Here is how to use the build scripts.

1. Start CMake and select `<repository>/external/` both as source and binary
directory.
2. Click <kbd>Configure</kbd> and select your compiler, for example *Visual
Studio 12 2013*. Don't be afraid of the errors.
3. If you don't have Git available globally, set `GIT_EXECUTABLE` to point to
your `git.exe`.
4. Click <kbd>Configure</kbd> again. There shouldn't be any errors this time.
5. Click <kbd>Generate</kbd> and leave CMake open for later.

Now we have set up the bulid environment. To start compilation, execute this
command. Be patient while the dependencies are being compiled. This can take a
while.

    cmake --build <repository>/external/

This gives us the release binaries. To get debug binaries, set
`CMAKE_BUILD_TYPE` to `Debug` in CMake and configure and generate again. Then
run the above command again to start the build process. The binaries differ in
their names, so they can live next to each other just fine.

This project
------------

Now that we have all the dependencies available, we can generate the main
project. It should find all libraries now.

1. Start CMake and select `<repository>/src/` both as source and binary
directory.
2. Click <kbd>Configure</kbd> and select your compiler, for example *Visual
Studio 12 2013*. Don't be afraid of the errors.
3. Click <kbd>Configure</kbd> again. There shouldn't be any errors this time.
4. Click <kbd>Generate</kbd> and close CMake.

Your project is now set up in the `<repository>/src/` directory.
