#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the eigen3 server and
# unpack it


if [ ! -d  $SIMPATH/tools/eigen3 ];
then 
  cd $SIMPATH/tools
  if [ ! -e eigen3 ];
  then
    echo "*** Checking out eigen3 sources ***"
    git clone $EIGEN3_LOCATION eigen3
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/include/eigen3/signature_of_eigen3_matrix_library

if (not_there eigen3 $checkfile);
then

  cd $SIMPATH/tools/eigen3

  git checkout -b $EIGEN3_VERSION tags/$EIGEN3_VERSION

  mkdir build
  cd build
  cmake ../ -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL -DEIGEN_TEST_CXX11=ON

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  check_success eigen3 $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
