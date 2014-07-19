#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
export buildlog=$HOME/buildlog
echo "Starting build" > buildlog
sudo apt-get install python-numpy python-scipy cython python-nose git cmake
echo "apt" >> $buildlog
cd $HOME
mkdir opt
cd opt
wget http://www.hdfgroup.org/ftp/HDF5/current/bin/linux-x86_64/hdf5-1.8.13-linux-x86_64-shared.tar.gz
tar zxvf hdf5-1.8.13-linux-x86_64-shared.tar.gz
rm hdf5-1.8.13-linux-x86_64-shared.tar.gz
echo "export LD_LIBRARY_PATH=/home/pyneuser/opt/hdf5-1.8.13-linux-x86_64-shared/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=/home/pyneuser/opt/hdf5-1.8.13-linux-x86_64-shared/lib:$LIBRARY_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=/home/pyneuser/opt/hdf5-1.8.13-linux-x86_64-shared/include:$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export C_INCLUDE_PATH=/home/pyneuser/opt/hdf5-1.8.13-linux-x86_64-shared/include:$C_INCLUDE_PATH" >> ~/.bashrc
source ~/.bashrc
echo "hdf5" >> $buildlog
git clone https://github.com/pydata/numexpr.git
cd numexpr
python setup.py install --user
cd ..
echo "numexpr" >> $buildlog
git clone https://github.com/PyTables/PyTables.git
cd PyTables
python setup.py install --user --hdf5=/home/pyneuser/opt/hdf5-1.8.13-linux-x86_64-shared
cd ..
echo "pytables" >> $buildlog
mkdir moab
cd moab
wget http://ftp.mcs.anl.gov/pub/fathom/moab-4.6.2.tar.gz
tar zxvf moab-4.6.2.tar.gz
rm moab-4.6.2.tar.gz
mkdir build
cd build
../moab-4.6.2/configure --enable-shared --with-hdf5=/home/pyneuser/opt/hdf5-1.8.13-linux-x86_64-shared --prefix=/home/pyneuser/.local
make
make install
echo "export LD_LIBRARY_PATH=/home/pyneuser/.local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=/home/pyneuser/.local/lib:$LIBRARY_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=/home/pyneuser/.local/include:$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export C_INCLUDE_PATH=/home/pyneuser/.local/include:$C_INCLUDE_PATH" >> ~/.bashrc
source ~/.bashrc
echo "moab" >> $buildlog
cd ../../
wget https://pypi.python.org/packages/source/P/PyTAPS/PyTAPS-1.4.tar.gz
tar zxvf PyTAPS-1.4.tar.gz
rm PyTAPS-1.4.tar.gz
cd PyTAPS-1.4/
python setup.py install --imesh-path=/home/pyneuser/.local/ --user
echo "pytaps" >> $buildlog
cd ..
git clone https://github.com/pyne/pyne.git
cd pyne
python setup.py install --user
cd tests
nosetests
echo "pyne" >> $buildlog
cd $HOME
echo "done!" >> $buildlog
