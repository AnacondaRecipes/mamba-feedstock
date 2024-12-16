@echo ON

mkdir build
cd build
if errorlevel 1 exit /b 1

if /I "%PKG_NAME%" == "libmamba" (

    cmake -B build ^
        -G Ninja ^
        %CMAKE_ARGS% ^
        -D BUILD_SHARED=ON ^
        -D BUILD_LIBMAMBA=ON ^
        -D BUILD_MAMBA_PACKAGE=ON ^
        -D BUILD_LIBMAMBAPY=OFF ^
        -D BUILD_MAMBA=OFF ^
        -D BUILD_MICROMAMBA=OFF ^
		-D MAMBA_WARNING_AS_ERROR=OFF ^
		-D CMAKE_BUILD_TYPE=Release
    if errorlevel 1 exit 1
    cmake --build build/ --parallel %CPU_COUNT%
    if errorlevel 1 exit 1
    cmake --install build/

)
if /I "%PKG_NAME%" == "libmambapy" (
	cd ../libmambapy
	rmdir /Q /S build
	%PYTHON% -m pip install . --no-deps --no-build-isolation -v
	del *.pyc /a /s
	del *.pyd /a /s
)
if /I "%PKG_NAME%" == "mamba" (

    cmake -B build ^
        -G Ninja ^
        %CMAKE_ARGS% ^
        -D BUILD_LIBMAMBA=OFF ^
        -D BUILD_MAMBA_PACKAGE=OFF ^
        -D BUILD_LIBMAMBAPY=OFF ^
        -D BUILD_MAMBA=ON ^
        -D BUILD_MICROMAMBA=OFF
		-D MAMBA_WARNING_AS_ERROR=OFF ^
		-D CMAKE_BUILD_TYPE=Release
    if errorlevel 1 exit 1
    cmake --build build --parallel %CPU_COUNT%
    if errorlevel 1 exit 1
    cmake --install build
    :: Install BAT hooks in condabin/
    CALL "%LIBRARY_BIN%\mamba.exe" shell hook --shell cmd.exe "%PREFIX%"
    if errorlevel 1 exit 1
)