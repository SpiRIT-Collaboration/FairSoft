#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the rave server and
# unpack it


if [ ! -d  $SIMPATH/tools/anaroot ];
then 
  cd $SIMPATH/tools
  git clone $ANAROOT_LOCATION
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/lib/libanaroot.so

if (not_there anaroot-lib $checkfile);
then

  cd $SIMPATH/tools/anaroot/

  if [ "$platform" = "macosx" ];
  then
    if !hash autoconf 2> /dev/null;
    then
      source $SIMPATH/install_autoconf.sh
      source $SIMPATH/install_automake.sh
      source $SIMPATH/install_libtool.sh
    fi
  fi

  ROOTSYS=$install_prefix ./autogen.sh --prefix=$install_prefix

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  if [ "$platform" = "macosx" ];
  then
    cd $install_prefix/lib
    create_links dylib so
  fi

  check_success anaroot $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
