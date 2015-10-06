#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the gnu mirror server and
# unpack it


if [ ! -d  $SIMPATH/tools/libtool ];
then 
  cd $SIMPATH/tools
  if [ ! -e $LIBTOOL_VERSION.tar.gz ];
  then
    echo "*** Downloading libtool sources ***"
    download_file $LIBTOOL_LOCATION/$LIBTOOL_VERSION.tar.gz
  fi
  untar libtool $LIBTOOL_VERSION.tar.gz 
  if [ -d $LIBTOOL_VERSION ]; 
  then
    ln -s $LIBTOOL_VERSION libtool
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/bin/libtool

if (not_there libtool $checkfile);
then
  cd $SIMPATH/tools/libtool

  ./configure --prefix=$install_prefix

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  check_success libtool $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
