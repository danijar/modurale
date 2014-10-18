Installation
============

This guide describes how to set up a development environment of the project in
order to work on and compile it.

Preparation
-----------

You need [Git][git] and [CMake][cmake] to build this project. This guide will
assume you use the graphical interface of CMake but you can use the command line
tool directly as well.

[git]: http://git-scm.com/downloads
[cmake]: http://www.cmake.org/download/

Dependencies
------------

The following steps set up build scripts specific to your compilers. They are
capable of downloading and building all dependencies automatically.

1. Start CMake and select `<repository>/external/` as source and
`<repository>/external/` as binary directory.
2. Click <kbd>Configure</kbd> and select your compiler, for example *Visual
Studio 12 2013*.
3. If you don't have Git available globally, set `GIT_EXECUTABLE` to point to
your `git.exe`. Click <kbd>Configure</kbd> again. There shouldn't be any errors
this time.
4. Click <kbd>Generate</kbd> and close CMake.

Now we have the build scripts. How to execute them depends on your compiler.
For GCC or MinGW, navigate into `<repository>/external` and run these steps.

    ./configure
    make
    make install

In contrast, use the following steps for the Visual Studio compiler. Make sure
you use the *Developer Command Promt* and navigate into the external directory,
too.

    msbuild Project.sln /p:Configuration=Release
    msbuild Project.sln /p:Configuration=Debug

The dependencies are now being compiled. Be patient, this can take a while.

This project
------------

Now that we have all the dependencies available, we can generate the main
project. It should find all libraries now.

1. Start CMake and select `<repository>/src/` as source and
`<repository>/build/` as binary directory.
2. Click <kbd>Configure</kbd> and select your compiler, for example `Visual
Studio 12.0`. There shouldn't be any errors.
3. Click <kbd>Generate</kbd> and close CMake.

Your project is now set up in the `<repository>/src/` directory.
