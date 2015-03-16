Installation
============

This guide describes how to set up a development environment of the project in
order to work on and compile it. You need [Git][git] and [CMake][cmake] to
build this project.

[git]: http://git-scm.com/downloads
[cmake]: http://www.cmake.org/download/

Summary
-------

To just build the project on Windows, run `cmake -G"Visual Studio 12 2013"`
inside the repository root. This can take a while. Then open the generated
Visual Studio solution, set the startup project to *modurale*, select *Release*
mode and run.

On Linux, use `sudo cmake -G"Unix Makefiles"`. You can now build the project
using `sudo cmake --build .`.

Advanced
--------

This project comes with build scripts capable of downloading and building all
dependencies automatically. Here is how to use it. Open a terminal at the
repository root and run `cmake` with the following options. This sets up the
project and also will automatically download, extract, build and install
dependencies. Be prepared for this step to take a while. Every dependency has
its sub directory under `external` so that your system environment won't be
affected.

- `-G"<generator>"` Name of the tool chain you want to use. This option is
required. Use `cmake --help` to get a list of all available generators. In most
cases, you want to use *"Unix Makefiles"* on Linux and *"Visual Studio 12
2013"* on Windows.
- `-DGIT_EXECUTABLE=<git>` Path to your Git executable. Defaults to *git* or
*git.exe* depending on your platform. Change this if you don't have Git
available globally.
- `-DCMAKE_BUILD_TYPE=<variant>` Build variant. Defaults to *Release*. Change
this to *Debug* if you want debug binaries instead.
- `-DUSE_STATIC_STD_LIBS=<std-linkage>` Linkage type of runtime library.
Defaults to *TRUE* on Windows and *FALSE* on Linux. Only one of this and the
option right above can be true.

Now we have set up the build environment and built all dependencies. To start
compilation of the actual project, execute `cmake --build .` appended with the
following options. To stick with the defaults, add none of these. On Linux, you
need `sudo` for this.

- `--config <variant>` Build variant. This option is required. Set this so that
it matches your choice above.
- `--target <target>` Targets to build. Defaults to building everything, i.e.
all dependencies, this project and its unit tests. Set this to the name of a
dependency, *modurale* or *tests* to only build a specific target.

This builds the project, including tests. After this process, you have two
executables for this, in a location depending on our platform and toolset. Run
them and see if they start without any errors. Congratulations!

Visual Studio
-------------

When using Visual Studio, please note that `ALL_BUILD` get set as startup
project, which is not able to run the executable. Therefore, you have to right
click on *modurale* and set it as startup project. This
[has been discussed][question] already, and there is no automated solution.

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
