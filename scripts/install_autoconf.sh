#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the gnu mirror server and
# unpack it


if [ ! -d  $SIMPATH/tools/autoconf ];
then 
  cd $SIMPATH/tools
  if [ ! -e $AUTOCONF_VERSION.tar.gz ];
  then
    echo "*** Downloading autoconf sources ***"
    download_file $AUTOCONF_LOCATION/$AUTOCONF_VERSION.tar.gz
  fi
  untar autoconf $AUTOCONF_VERSION.tar.gz 
  if [ -d $AUTOCONF_VERSION ]; 
  then
    ln -s $AUTOCONF_VERSION autoconf
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/bin/autoconf

if (not_there autoconf $checkfile);
then
  cd $SIMPATH/tools/autoconf

  ./configure --prefix=$install_prefix

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  check_success autoconf $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
