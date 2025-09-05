#!/bin/bash

set -euxo pipefail

export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY=1"

if [[ $PKG_NAME == "libmamba" ]]; then

    cmake -B build-lib/ \
        -G Ninja \
        ${CMAKE_ARGS} \
        -D CMAKE_INSTALL_PREFIX=$PREFIX  \
        -D CMAKE_PREFIX_PATH=$PREFIX     \
        -D CMAKE_BUILD_TYPE=Release      \
        -D BUILD_SHARED=ON \
        -D BUILD_LIBMAMBA=ON \
        -D BUILD_MAMBA_PACKAGE=ON \
        -D BUILD_LIBMAMBAPY=OFF \
        -D BUILD_MAMBA=OFF \
        -D BUILD_MICROMAMBA=OFF \
        -D MAMBA_WARNING_AS_ERROR=OFF
    cmake --build build-lib/ --parallel ${CPU_COUNT}
    cmake --install build-lib/

elif [[ $PKG_NAME == "libmambapy" ]]; then

    export CMAKE_ARGS="-G Ninja ${CMAKE_ARGS}"
    "${PYTHON}" -m pip install --no-deps --no-build-isolation --config-settings="--build-type=Release" --config-settings="--generator=Ninja" -vv ./libmambapy

fi