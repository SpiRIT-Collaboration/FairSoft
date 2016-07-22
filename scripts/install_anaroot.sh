#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the rave server and
# unpack it


if [ ! -d  $SIMPATH/tools/anaroot ];
then 
  cd $SIMPATH/tools
  if [ ! -d anaroot ];
  then
    echo "*** Checking out anaroot sources ***"
    git clone -b $ANAROOT_VERSION $ANAROOT_LOCATION
  fi
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
    mypatch ../anaroot_autogen_OSX.patch
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
