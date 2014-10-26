Installation
============

This guide describes how to set up a development environment of the project in
order to work on and compile it. You need [Git][git] and [CMake][cmake] to
build this project.

[git]: http://git-scm.com/downloads
[cmake]: http://www.cmake.org/download/

General
-------

This project comes with build scripts capable of downloading and building all
dependencies automatically. They will create a sub directory for each
dependency under `<repository>/external`, where downloaded source, intermediate
files and the final libraries get stored. Here is how to use the build scripts.

Open a terminal at the repository root and run `cmake` with the following
options.

- `-G"<generator>"` Name of the toolchain you want to use. This option is
required. Use `cmake --help` to get a list of all available generators. In most
cases, you want to use *"Unix Makefiles"* on Linux and *"Visual Studio 12
2013"* on Windows.
- `-DGIT_EXECUTABLE:FILEPATH=<git>` Path to your git executable. Defaults to
*git* or *git.exe* dependending on your platform. Change this if you don't have
git available globally.
- `-DCMAKE_BUILD_TYPE:STRING=<variant>` Build variant. Defaults to *Release*.
Change this to *Debug* if you want debug binaries instead.

Now we have set up the build environment. To start compilation, execute `cmake
--build .` appended with the following options.

- `--config <variant>` Build variant. This option is required. Set this so that
it matches your choice above.
- `--target <target>` Targets to build. Defaults to building everything, i.e.
all dependencies, this project and its unit tests. Set this to the name of a
dependency, *modurale* or *tests* to only build a specific target.

This builds everything, including tests, dependencies and downloading them
first. This can take a while.

Visual Studio
-------------

When using Visual Studio, please note that `ALL_BUILD` get set as startup
project, which is not able to run the executable. Therefore, you have to right
click on *modurale* and set it as startup project. This
[has been discussed][question] already, and there is no automated solution.
Another way would be to right click the project and under *Debug* click
*Start new instance* every time. This can be useful for running the tests
without switching the statup project every time.

As an advice, you may also want to use *Show All Files* mode from the toolbar
of the *Solution Explorer* for that project to show source files in their
directory structure instead of just listing the file names. Moreover, you can
safely check the box to not show popups about *No Debug Information* again when
building.

[question]: http://stackoverflow.com/q/7304625

Cleanup
-------

If you want to clean up your repository from temporary directories and files
created by CMake and your compiler, you can run `git clean -xffd`. This also
removed the dependencies that were set up automatically, so you have to rebuild
them next time. Therefore, this is only useful if you have issues with the
build system or to test changes made to it.
