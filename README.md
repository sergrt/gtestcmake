# gtestcmake
CMake files to generate empty Visual Studio project with supplementary unit-tests project. No more, no less - if you need empty project with another project for unit-tests - you just run runme.bat and get it.

## Features
- Simple configuration
- Option to use precompiled headers

## How to use
1. Open CMakeLists.txt in your favorite editor
2. Set "PROJECT_NAME" variable as you want your solution (and main project) to be named
3. Comment (or leave as it is) line with "USE_PRECOMPILED_HEADERS Yes"
4. Clone googletest and put it to "3rdparty/googletest" folder
5. Run runme.bat

As a result, "build" folder will be created, where all solution files will be placed.

## Known limitations
Despite "USE_PRECOMPILED_HEADERS" option works, it is necessary to set "Precompiled Header" option for your project to "Create (/Yc)" at first compilation. After first compilation complete, set it back to "Use (/Yu)". Any suggestions on this are welcome.




