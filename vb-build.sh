#!/bin/bash
# This script builds the repo version of PyNE (with the MOAB optional 
# dependency) from scratch on Ubuntu 14.04. The folder /home/Install/PyNE
# is created and PyNE is installed within.
#
# Run this script from any directory by issuing the command:
# $ ./vb-build
# After the build finishes run:
#  $ source ~/.bashrc
# or open a new terminal.
set -euo pipefail
IFS=$'\n\t'

# Use package manager for as many packages as possible
#sudo apt-get install -y python-numpy python-scipy cython python-nose git cmake vim emacs gfortran libblas-dev liblapack-dev libhdf5-dev python-tables
# need to put libhdf5.so on LD_LIBRARY_PATH
# Note: I needed to add H5FDmpiposix.h to /home/Install/anaconda/include for
# this to work. I got it from:
#http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.1/src/unpacked/src/H5FDmpiposix.h

export LD_LIBARY_PATH=/usr/lib/x86_64-linux-gnu
echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu" >> ~/.bashrc

export INSTALL_BASE=/home/Install
export INSTALL_DIR=$INSTALL_BASE/PyNE
export BUILD_DIR=/home/slayer/Software/Sources
export PYNE_DIR=/home/slayer/Software/PyNE/pyne

# Install MOAB
cd $BUILD_DIR
#mkdir moab
cd moab
#wget http://ftp.mcs.anl.gov/pub/fathom/moab-4.6.2.tar.gz
#tar zxvf moab-4.6.2.tar.gz
#rm moab-4.6.2.tar.gz

#mkdir build
cd build
../moab-4.6.2/configure --enable-shared --prefix=$INSTALL_DIR
make clean
make -j 8
make install

export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$INSTALL_DIR/lib:$LIBRARY_PATH
export CPLUS_INCLUDE_PATH=$INSTALL_DIR/include:$CPLUS_INCLUDE_PATH
export C_INCLUDE_PATH=$INSTALL_DIR/include:$C_INCLUDE_PATH
export LD_LIBRARY_PATH=/home/Install/anaconda/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/slayer/.local/lib:$LD_LIBRARY_PATH
echo "export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=$INSTALL_DIR/lib:$LIBRARY_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=$INSTALL_DIR/include:$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export C_INCLUDE_PATH=$INSTALL_DIR/include:$C_INCLUDE_PATH" >> ~/.bashrc

# Install PyTAPS
cd $BUILD_DIR
#mkdir pytaps
cd pytaps
#wget https://pypi.python.org/packages/source/P/PyTAPS/PyTAPS-1.4.tar.gz
#tar zxvf PyTAPS-1.4.tar.gz
#rm PyTAPS-1.4.tar.gz
cd PyTAPS-1.4/
python setup.py --iMesh-path=$INSTALL_DIR install --user

# Install PyNE
#git clone https://github.com/pyne/pyne.git
cd $PYNE_DIR
python setup.py install --hdf5=/home/Install/anaconda --user
echo "export PATH=$INSTALL_DIR/bin:$PATH" >> ~/.bashrc

# Generate nuclear data file
cd scripts
./nuc_data_make
cd ..

# Run all the tests
cd tests
nosetests
