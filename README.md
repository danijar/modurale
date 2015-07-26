Modurale
========

[![Build Status][1.1]][1.2]

Modular real time engine for computer graphics.

[1.1]: https://travis-ci.org/danijar/modurale.svg?branch=master
[1.2]: https://travis-ci.org/danijar/modurale

Requirements
------------

Modurale is written in cross-platform C++ and should compile in Windows, Linux
and Mac environments. Currently it has been tested on Windows and Linux.

Instructions
------------

```bash
# Clone the repository and navigate into its root folder.
git clone git@github.com:danijar/modurale.git
cd modurale

# Install the indirect dependencies. Use the setup script if available for
# your platform. Otherwise, please see section Indirect Dependencies.
chmod +x tool/setup-<platform>.sh
tool/setup-<platform>.sh

# Configure and build external dependencies. They will be downloaded first.
# This can take a couple of minutes.
cd build
cmake ../project/

# Build the engine and application.
cmake --build .

# Optionally, run tests.
modurale/tests

# Launch the example application
game/game
```

Direct dependencies
-------------------

The following libraries are used in Modurale. Because of the automated build
system there is no need to manually install them though.

|    Library    |    Version    |                 Description                  |
| ------------- | :-----------: | -------------------------------------------- |
| [SFML][2.1]   |   [2.1][2.2]  | Simple and fast multimedia library.          |
| [Boost][2.3]  | [1.58.0][2.4] | Large collection of multi-purpose libraries. |
| [Catch][2.5]  |  [1.2.1][2.6] | Multi-paradigm automated test framework.     |
| [SQLite][2.7] |     3.8.7     | Serverless transactional SQL database.       |
| [Assimp][2.8] |  [3.1.1][2.9] | Import library for various 3D model formats. |
| [GLEW][2.10]  |     1.12.0    | OpenGL run-time extension loader.            |

[2.1]: https://github.com/LaurentGomila/SFML
[2.2]: https://github.com/LaurentGomila/SFML/commit/e257909
[2.3]: http://www.boost.org/
[2.4]: https://github.com/boostorg/boost/commit/9ccd339
[2.5]: https://github.com/philsquared/Catch
[2.6]: https://github.com/philsquared/Catch/commit/3b18d9e
[2.7]: http://www.sqlite.org/
[2.8]: https://github.com/assimp/assimp
[2.9]: https://github.com/assimp/assimp/commit/dca3f09
[2.10]: http://glew.sourceforge.net/

Indirect dependencies
---------------------

Since libraries above have dependencies themselves, the following libraries
must be available on the system. There are setup scripts available for some
platforms inside the `tool/` directory.

|    Library     |      Arch     |      Ubuntu      |
| -------------- | ------------- | ---------------- |
| FreeType       | freetype2     | libfreetype6-dev |
| JPEG           | libjpeg-turbo | libjpeg-dev      |
| OpenAL         | openal        | libopenal-dev    |
| OpenGL Utility | glu           | libglu1-mesa-dev |
| Sound Files    | libsndfile    | libsndfile1-dev  |
| Udev           | systemd       | libudev-dev      |
| X Input        | libxi         |                  |
| X Utility      | libxmu        |                  |
| X11 Client     |               | libx11-dev       |
| XRandR         | libxrandr     | libxrandr-dev    |
