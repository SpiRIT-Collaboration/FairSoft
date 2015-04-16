#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the rave server and
# unpack it


if [ ! -d  $SIMPATH/tools/rave ];
then 
  cd $SIMPATH/tools
  if [ ! -e $RAVE_VERSION.tar.gz ];
  then
    echo "*** Downloading rave sources ***"
    download_file $RAVE_LOCATION/$RAVE_VERSION.tar.gz
  fi
  untar rave $RAVE_VERSION.tar.gz 
  if [ -d $RAVE_VERSION ]; 
  then
    ln -s $RAVE_VERSION rave  
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL
clhep_exe=$SIMPATH_INSTALL

checkfile=$install_prefix/lib/libRaveBase.so

if (not_there rave-lib $checkfile);
then

  cd $SIMPATH/tools/rave/
  mypatch ../rave-0.6.21_Makefile.in.patch
  mypatch ../rave-0.6.21-shared_ptr-c++11.patch

  rm -rf ./src/boost

  ./configure --prefix=$install_prefix \
              --with-clhep=$install_prefix \
              --with-boost=$install_prefix \
              --with-boost-libdir=$install_prefix/lib

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  if [ "$platform" = "macosx" ];
  then
    cd $install_prefix/lib
    create_links dylib so
  fi

  check_success rave $checkfile
  check=$?

#else
#  . $install_prefix/share/$GEANT4VERSIONp/geant4make/geant4make.sh
fi
  
cd  $SIMPATH
return 1
