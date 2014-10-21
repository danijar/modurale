Installation
============

This guide describes how to set up a development environment of the project in
order to work on and compile it. You need [Git][git] and [CMake][cmake] to
build this project.

[git]: http://git-scm.com/downloads
[cmake]: http://www.cmake.org/download/

Dependencies
------------

This project comes with build scripts capable of downloading and building all
dependencies automatically. They will create a sub directory for each
dependency under `<repository>/external`, where downloaded source, intermediate
files and the final libraries get stored. Here is how to use the build scripts.

1. Open a terminal and navigate to `<repository>/external/`. When using Visual
Studio, please use the *Developer Command Promt*.

2. Run `cmake -G"<generator>"`. The generator for which environment you want to
generate build files for. Type in `cmake --help` to get a list of all available
generators. In most cases, you want to use `"Unix Makefiles"` on Linux and
`"Visual Studio 12 2013"` on Windows. If you don't have git available globally,
add `-DGIT_EXECUTABLE:FILEPATH=<git>` to set the path to the git executable.

3. Now we have set up the build environment. To start compilation, execute
`cmake --build . --config Release`. Be patient while the dependencies are being
compiled. This can take a while. You now have release binaries.

4. You only need this step if you want to make debug builds. Run `cmake
-G"<generator>" -DCMAKE_BUILD_TYPE:STRING=Debug` which is analogous to step
two. Add the path to git if needed. Then use `cmake --build . --config Debug`
to perform the build.

This project
------------

Now that we have all the dependencies available, we can generate the main
project. It should find all libraries now. Therefore, navigate to
`<repository>/src/` and run `cmake -G"<generator>"` with the generator you used
for building dependencies. Your project is now set up in the
`<repository>/src/` directory.

When using Visual Studio, please note that `ALL_BUILD` get set as startup
project, which is not able to run the executable. Therefore, you have to right
click on *modurale* and set it as startup project. This
[has been discussed][question] already, and there is no automated solution.

As an advice, you may also want to use *Show All Files* mode from the toolbar
of the *Solution Explorer* for that project to show source files in their
directory structure instead of just listing the file names. Moreover, you can
safely check to not show popups about *No Debug Information* on build again.

[question]: http://stackoverflow.com/q/7304625
