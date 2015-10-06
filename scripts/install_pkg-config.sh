#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the server and
# unpack it


if [ ! -d  $SIMPATH/tools/pkg-config ];
then 
  cd $SIMPATH/tools
  if [ ! -e $PKGCONFIG_VERSION.tar.gz ];
  then
    echo "*** Downloading pkg-config sources ***"
    download_file $PKGCONFIG_LOCATION/$PKGCONFIG_VERSION.tar.gz
  fi
  untar pkg-config $PKGCONFIG_VERSION.tar.gz 
  if [ -d $PKGCONFIG_VERSION ]; 
  then
    ln -s $PKGCONFIG_VERSION pkg-config
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/bin/pkg-config

if (not_there pkg-config $checkfile);
then
  cd $SIMPATH/tools/pkg-config

  ./configure --prefix=$install_prefix

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  check_success pkg-config $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
