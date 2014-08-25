#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export buildlog=$HOME/buildlog
export hdf5dir=$HOME/opt/hdf5
echo "Starting build" > $buildlog
sudo apt-get install -y python-numpy python-scipy cython python-nose git cmake vim emacs gfortran libblas-dev liblapack-dev libhdf5-dev
export LD_LIBARY_PATH=/usr/lib/x86_64-linux-gnu
echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu" >> ~/.bashrc
echo "apt" >> $buildlog
cd $HOME
mkdir opt
cd opt
git clone https://github.com/pydata/numexpr.git
cd numexpr
python setup.py install --user
cd ..
echo "numexpr" >> $buildlog
git clone https://github.com/PyTables/PyTables.git
cd PyTables
python setup.py install --user
cd ..
echo "pytables" >> $buildlog
mkdir moab
cd moab
wget http://ftp.mcs.anl.gov/pub/fathom/moab-4.6.2.tar.gz
tar zxvf moab-4.6.2.tar.gz
rm moab-4.6.2.tar.gz
mkdir build
cd build
../moab-4.6.2/configure --enable-shared --prefix=$HOME/.local
make
make install
export LD_LIBRARY_PATH=$HOME/.local/lib:\$LD_LIBRARY_PATH
export LIBRARY_PATH=$HOME/.local/lib:\$LIBRARY_PATH
echo "export LD_LIBRARY_PATH=$HOME/.local/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=$HOME/.local/lib:\$LIBRARY_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=$HOME/.local/include:\$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export C_INCLUDE_PATH=$HOME/.local/include:\$C_INCLUDE_PATH" >> ~/.bashrc
echo "moab" >> $buildlog
cd ../../
wget https://pypi.python.org/packages/source/P/PyTAPS/PyTAPS-1.4.tar.gz
tar zxvf PyTAPS-1.4.tar.gz
rm PyTAPS-1.4.tar.gz
cd PyTAPS-1.4/
python setup.py --iMesh-path=$HOME/.local/ install --user
echo "pytaps" >> $buildlog
cd ..
git clone https://github.com/pyne/pyne.git
cd pyne
python setup.py install --hdf5=$HOME/opt/hdf5 --user
echo "export PATH=$HOME/.local/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$HOME/.local/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
cd scripts
./nuc_data_make
cd ..
cd tests
nosetests
echo "pyne" >> $buildlog
cd $HOME
echo "done!" >> $buildlog
