#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the genfit server and
# unpack it


if [ ! -d  $SIMPATH/tools/GenFit ];
then 
  cd $SIMPATH/tools
  if [ ! -e GenFit ];
  then
    echo "*** Checking out GenFit sources ***"
    git clone $GENFIT2_LOCATION GenFit
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

RAVEPATH=$SIMPATH_INSTALL/lib/pkgconfig
install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/lib/libgenfit2.so

if (not_there GenFit-lib $checkfile);
then

  cd $SIMPATH/tools/GenFit

  git checkout $GENFIT2_VERSION
#  mypatch ../GenFit-CMakeLists.patch

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

  check_success GenFit $checkfile
  check=$?
fi
  
cd  $SIMPATH
return 1
