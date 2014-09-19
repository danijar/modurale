Instructions for MinGW
======================

MinGW
-----

This is a environment that allows to use a tool chain on Windows, that is
similar to the default on Linux. Mainly, it is a port of the gcc compiler. In
contrast to the native Visual Studio compiler on Windows, it provides early
support for mordern C++ language features. Moreover, using gcc makes is easier
to port the project to Linux and Mac.

1. Download and run `mingw-get-setup.exe`.
2. When prompted, make sure that you have `gcc`, `make` and `msys` selected.
3. Add `MinGW/bin` folder to PATH environment variable.
4. Open a terminal and see if `gcc --version` works.

CMake
-----

This tool can build project files for a wide range of tool chains. It's used
for some of this dependencies as well as for this application. Download the
newest version from [the website][cmake] and run the setup. If you choose the
archive instead, extract and copy it into your application directory, and
create a link to the `cmake/bin/cmake-gui.exe`.

[cmake]: http://www.cmake.org/download/

Dependencies
------------

During the following steps, you will install one application and several
libraries. To keep things neat you should decide for two directories to hold
both kinds of software. On Linux, libraries typically go to `/usr/lib/`.
However, on Windows there is no such default location. You should add the
directory you chose to the PATH environment variable.

For each library you copy to that directory, make sure that it is not wrapped
by a folder twice, due to archive packing. Most libraries come in a folder
that has the library name and version number in its name and includes sub
directories like `include`, `src`, `bin` and or `lib`. You should not rename
the folder, because default names are the easiest to relate afterwards.

### GLEW

This library provides access to a lot of OpenGL functions, even if they aren't
available as core functionality on the target platform, but just as extensions.

1. Download source as archive from [the website][glew].
2. Copy into your library directory.
3. Run the following commands in order to build.

        gcc -DGLEW_NO_GLU -O2 -Wall -W -Iinclude -DGLEW_BUILD -o src/glew.o -c src/glew.c
        gcc -shared -Wl,-soname,libglew32.dll -Wl,--out-implib,lib/libglew32.dll.a -o lib/glew32.dll src/glew.o -L/mingw/lib -lglu32 -lopengl32 -lgdi32 -luser32 -lkernel32
        ar cr lib/libglew32.a src/glew.o
        gcc -DGLEW_NO_GLU -DGLEW_MX -O2 -Wall -W -Iinclude -DGLEW_BUILD -o src/glew.mx.o -c src/glew.c
        gcc -shared -Wl,-soname,libglew32mx.dll -Wl,--out-implib,lib/libglew32mx.dll.a -o lib/glew32mx.dll src/glew.mx.o -L/mingw/lib -lglu32 -lopengl32 -lgdi32 -luser32 -lkernel32
        ar cr lib/libglew32mx.a src/glew.mx.o

[glew]: http://glew.sourceforge.net/index.html

### SFML

This library provides an abstraction from platform specific code for creating
windows, reading mouse and keyboard input, rendering fonts, playing sound,
networking. It also includes 2D drawing functionality, but this isn't used by
this project.

1. *Download ZIP* of master branch [from Github][sfml] and extract anywhere.
2. Start CMake GUI and select extracted folder both as *source code* and to
*build the binaries*.
3. Run *Configure* and select *MinGW Makefiles*. Don't be scared by all the red
entries.
4. Change the following entries. Make sure you use forward slashes in paths.
	- `BUILD_SHARED_LIBS`: Uncheck.
	- `CMAKE_INSTALL_PREFIX`: Choose installation folder inside your library
	directory, e.g. `SFML`.
	- `GLEW_INCLUDE_PATH`: Sub folder `include` inside your GLEW installation.
	- `GLEW_LIBRARY`: File `lib/libglew32.a` inside your GLEW installation.
	- `SFML_USE_STATIC_STD_LIBS`: Check.
5. Run *Configure* again. This time, there shouldn't be any red lines. Then
click *Generate*.
6. Run `mingw32-make install` in the exctracted folder.

[sfml]: https://github.com/LaurentGomila/SFML/

### Boost

This is the largest collection of C++ libraries, covering a broad spectrum of
use cases. It's design and code has very high quality, so Boost libraries often
make their ways into the language standard.

1. Download current release from the [the website][boost].
2. Copy into your library directory. Be aware of the size of this library, it
is roughly over 1 GB.
3. Run the following commands in order to build.

        bootstrap.bat mingw'
        b2 toolset=gcc'

4. Grab a coffee and wait until compilation is done.

[boost]: http://www.boost.org/users/download/

Porject setup
-------------

### Development Environment

I recommend Jetbrains CLion or QtCreator because they use CMake as project
files. The advantage is that you can make changes to the project and contribute
them to the repository. In contrast, when using CMake to generate third party
projects files, e.g. for Visual Studio, you can't make permanent changes to the
project files. With one exception. Since our CMake project scans for all
available `*.h`, `*.inl` and `*.cpp` files, you can add new files of those
extension and it will still work. In addition to that, you must be careful to
not commit project files of third party IDEs then.

### Jetbrains CLion

You need to set the following CMake options in order for the project to find its
dependencies.

- `SFML_ROOT`: Folder to SFML installation.
- `GLEW_LIBRARY`: Library `lib/libglew32.a` inside the GLEW installation.
