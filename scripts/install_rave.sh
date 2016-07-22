#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the rave server and
# unpack it


if [ ! -d  $SIMPATH/tools/rave ];
then 
  cd $SIMPATH/tools
  if [ ! -e rave ];
  then
    echo "*** Checking out rave sources ***"
    git clone -b $RAVE_VERSION $RAVE_LOCATION rave
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

#  source $SIMPATH/scripts/install_autoconf.sh
#  source $SIMPATH/scripts/install_automake.sh
#  source $SIMPATH/scripts/install_libtool.sh

  cd $SIMPATH/tools/rave/

  ./configure --prefix=$install_prefix \
              --disable-java \
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
fi
  
cd  $SIMPATH
return 1
