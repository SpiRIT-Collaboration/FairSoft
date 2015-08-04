#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the genfit server and
# unpack it


if [ ! -d  $SIMPATH/tools/genfit ];
then 
  cd $SIMPATH/tools
  if [ ! -e $GENFIT_VERSION.tar.gz ];
  then
    echo "*** Checking out genfit sources ***"
    svn co $GENFIT_LOCATION genfit
  fi
  untar genfit $GENFIT_VERSION.tar.gz 
  if [ -d $GENFIT_VERSION ]; 
  then
    ln -s $GENFIT_VERSION genfit
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

RAVEPATH=$SIMPATH_INSTALL/lib/pkgconfig
install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/lib/libgenfit2.so

if (not_there genfit-lib $checkfile);
then

  cd $SIMPATH/tools/genfit/

  mkdir build
  cd build
  cmake ../ -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  if [ "$platform" = "macosx" ];
  then
    cd $install_prefix/lib
    create_links dylib so
  fi

  check_success genfit $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
