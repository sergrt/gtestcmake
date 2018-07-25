::set CMAKE="c:\Program Files (x86)\CMake\bin\cmake"
set CMAKE=cmake
set BUILD_DIR=%~dp0.\build

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"
::%CMAKE% -version
%CMAKE% -G "Visual Studio 15 2017" -T "v141" -DCMAKE_USE_RELATIVE_PATHS=ON ../
cd ..