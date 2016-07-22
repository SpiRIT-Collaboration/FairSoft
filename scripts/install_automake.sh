#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the gnu mirror server and
# unpack it


if [ ! -d  $SIMPATH/tools/automake ];
then 
  cd $SIMPATH/tools
  if [ ! -e $AUTOMAKE_VERSION.tar.gz ];
  then
    echo "*** Downloading automake sources ***"
    download_file $AUTOMAKE_LOCATION/$AUTOMAKE_VERSION.tar.gz
  fi
  untar automake $AUTOMAKE_VERSION.tar.gz 
  if [ -d $AUTOMAKE_VERSION ]; 
  then
    ln -s $AUTOMAKE_VERSION automake
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/bin/automake

if (not_there automake $checkfile);
then
  cd $SIMPATH/tools/automake

  ./configure --prefix=$install_prefix

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  check_success automake $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
