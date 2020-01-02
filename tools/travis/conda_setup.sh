#!/usr/bin/env bash

set -ev # exit on first error, print commands

CONDA_URL="http://repo.continuum.io/miniconda"

if [ `uname -m` = 'aarch64' ]; then
   MINICONDA_DIR="$HOME/archiconda3"
   IS_SUDO="sudo"
elif [ "${PYTHON_VERSION:0:1}" == "2" ]; then
    CONDA="Miniconda2"
else
    CONDA="Miniconda3"
fi
if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    CONDA_OS="MacOSX"
else
    CONDA_OS="Linux"
fi
if [ `uname -m` = 'aarch64' ]; then
   wget -q "https://github.com/Archiconda/build-tools/releases/download/0.2.3/Archiconda3-0.2.3-Linux-aarch64.sh" -O archiconda.sh
elif [ "${PYTHON_ARCH}" == "64" ]; then
    URL="${CONDA_URL}/${CONDA}-latest-${CONDA_OS}-x86_64.sh"
else
    URL="${CONDA_URL}/${CONDA}-latest-${CONDA_OS}-x86.sh"
fi
echo "Downloading '${URL}'..."

set +e
travis_retry wget "${URL}" -O miniconda.sh
set -e

if [ `uname -m` = 'aarch64' ]; then
   chmod +x archiconda.sh
   $IS_SUDO apt-get install python-dev
   $IS_SUDO apt-get install python3-pip
   $IS_SUDO apt-get install lib$ARCHICONDA_PYTHON-dev
   $IS_SUDO apt-get install xvfb
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/local/lib:/usr/local/bin/python
   ./archiconda.sh -b
   echo "chmod MINICONDA_DIR"
   $IS_SUDO chmod -R 777 $MINICONDA_DIR
   $IS_SUDO cp $MINICONDA_DIR/bin/* /usr/bin/
   $IS_SUDO rm /usr/bin/lsb_release
else
    chmod +x miniconda.sh
    ./miniconda.sh -b -p "${HOME}/miniconda"
    
export PATH="${HOME}/miniconda/bin:${PATH}"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
