#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the genfit server and
# unpack it


if [ ! -d  $SIMPATH/tools/genfit2 ];
then 
  cd $SIMPATH/tools
  if [ ! -e $GENFIT2_VERSION.tar.gz ];
  then
    echo "*** Checking out genfit2 sources ***"
    svn co -r $GENFIT2_REVISION --no-auth-cache --non-interactive --trust-server-cert $GENFIT2_LOCATION genfit2
  fi
  untar genfit2 $GENFIT2_VERSION.tar.gz 
  if [ -d $GENFIT2_VERSION ]; 
  then
    ln -s $GENFIT2_VERSION genfit2
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

RAVEPATH=$SIMPATH_INSTALL/lib/pkgconfig
install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/lib/libgenfit2.so

if (not_there genfit2-lib $checkfile);
then

  cd $SIMPATH/tools/genfit2/

  mypatch ../genfit2.0.0-CMakeLists.patch

  mkdir build
  cd build
  RAVEPATH=$RAVEPATH BOOST_ROOT=$SIMPATH_INSTALL cmake ../ -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL -DBoost_NO_SYSTEM_PATHS=TRUE -DBoost_NO_BOOST_CMAKE=TRUE

  $MAKE_command -j$number_of_processes
  $MAKE_command -j$number_of_processes install

  if [ "$platform" = "macosx" ];
  then
    cd $install_prefix/lib
    create_links dylib so
  fi

  check_success genfit2 $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
