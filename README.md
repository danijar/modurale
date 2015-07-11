Modurale
========

Modular real time engine for computer graphics.

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
# your platform. Otherwise, please refer to the readme for a full list.
tool/setup-<platform>.sh

# Configure. This also downloads, builds and installs the direct dependencies.
This can take a couple of minutes.
cmake .

# Build.
cmake --build .

# Optionally, runs tests.
./tests

# Run Modurale.
./modurale
```

To clean up temporary and build files, you can reset the repository using `git
clean -xffd`. Warning: This will remove all uncommited changes.

Direct dependencies
-------------------

The following libraries are used in Modurale. Because of the automated build
system there is no need to manually install them though.

|   Library   |  Version   |                 Description                  |
| ----------- | :--------: | -------------------------------------------- |
| [SFML][1]   |  [2.1][2]  | Simple and fast multimedia library.          |
| [Boost][3]  |   1.56.0   | Large collection of multi-purpose libraries. |
| [Catch][4]  | [1.2.1][5] | Multi-paradigm automated test framework.     |
| [SQLite][6] |   3.8.7    | Serverless transactional SQL database.       |
| [Assimp][7] | [3.1.1][8] | Import library for various 3D model formats. |
| [GLEW][9]   |   1.12.0   | OpenGL run-time extension loader.            |

[1]: https://github.com/LaurentGomila/SFML
[2]: https://github.com/LaurentGomila/SFML/commit/e257909
[3]: http://www.boost.org/
[4]: https://github.com/philsquared/Catch
[5]: https://github.com/philsquared/Catch/commit/3b18d9e
[6]: http://www.sqlite.org/
[7]: https://github.com/assimp/assimp
[8]: https://github.com/assimp/assimp/commit/dca3f09
[9]: http://glew.sourceforge.net/

Indirect dependencies
---------------------

Since libraries above have dependencies themselves, the following libraries
must be available on the system. There are setup scripts available for some
platforms inside the `tool/` directory.

|         Library         |      Arch     |
| ----------------------- | ------------- |
| FreeType                | freetype2     |
| JPEG                    | libjpeg-turbo |
| Sound Files             | libsndfile    |
| OpenAL                  | openal        |
| OpenGL Utility          | glu           |
| X Input                 | libxi         |
| X Miscellaneous Utility | libxmu        |
| XRandR                  | libxrandr     |
