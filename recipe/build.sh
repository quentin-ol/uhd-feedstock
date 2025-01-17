#!/bin/bash

if [ "$PY3K" = "1" ]; then
    export BOOST_PYTHON_COMPONENT="PYTHON3"
else
    export BOOST_PYTHON_COMPONENT="PYTHON"
fi
export BOOST_PYTHON_LIBPATH="$PREFIX/lib/libboost_python${PY_VER//./}$SHLIB_EXT"

cd host  # needed for builds from github tarball
mkdir build
cd build
# enable uhd components explicitly so we get build error when unsatisfied
# the following are disabled:
#   DOXYGEN/MANUAL because we don't need docs in the conda package
#   E100/E300 are for embedded devices and are disable by default
#   GPSD needs gpsd
#   LIBERIO needs liberio
cmake \
    -DBOOST_ROOT=$PREFIX \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DBoost_${BOOST_PYTHON_COMPONENT}_LIBRARY_RELEASE:FILEPATH=$BOOST_PYTHON_LIBPATH \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DLIB_SUFFIX="" \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DENABLE_B100=ON \
    -DENABLE_B200=ON \
    -DENABLE_C_API=ON \
    -DENABLE_DOXYGEN=OFF \
    -DENABLE_E300=OFF \
    -DENABLE_EXAMPLES=ON \
    -DENABLE_GPSD=OFF \
    -DENABLE_LIBERIO=OFF \
    -DENABLE_LIBUHD=ON \
    -DENABLE_MAN_PAGES=ON \
    -DENABLE_MANUAL=OFF \
    -DENABLE_MPMD=ON \
    -DENABLE_OCTOCLOCK=ON \
    -DENABLE_N230=ON \
    -DENABLE_PYTHON_API=ON \
    -DENABLE_PYTHON3=$PY3K \
    -DENABLE_RFNOC=ON \
    -DENABLE_TESTS=ON \
    -DENABLE_UTILS=ON \
    -DENABLE_USB=ON \
    -DENABLE_USRP1=ON \
    -DENABLE_USRP2=ON \
    -DENABLE_X300=ON \
    ..
make -j${CPU_COUNT}
ctest --output-on-failure
make install
