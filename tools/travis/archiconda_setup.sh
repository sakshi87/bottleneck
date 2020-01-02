#!/usr/bin/env bashexport PATH="${HOME}/miniconda/bin:${PATH}"

set -ev # exit on first error, print commands

URL= https://github.com/Archiconda/build-tools/releases/download/0.2.3/Archiconda3-0.2.3-Linux-aarch64.sh

echo "Downloading '${URL}'..."

chmod +x Archiconda3-0.2.3-Linux-aarch64.sh
./miniconda.sh -b -p "${HOME}/miniconda"
export PATH="${HOME}/miniconda/bin:${PATH}"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
