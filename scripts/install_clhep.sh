#!/bin/bash

# Check if the source tar file is already available
# If not download it a from the clhep server and
# unpack it


if [ ! -d  $SIMPATH/tools/clhep ];
then 
  cd $SIMPATH/tools
  if [ ! -e clhep-$CLHEP_VERSION.tgz ];
  then
    echo "*** Downloading clhep sources ***"
    download_file $CLHEP_LOCATION/clhep-$CLHEP_VERSION.tgz
  fi
  untar clhep clhep-$CLHEP_VERSION.tgz 
  if [ -d $CLHEP_VERSION/CLHEP ]; 
  then
    ln -s $CLHEP_VERSION/CLHEP clhep  
  fi
fi 

# Full output during compilation and linking to check for the
# compile and link commands
#export CPPVERBOSE=1

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/lib/libCLHEP-$CLHEP_VERSION.so

if (not_there clhep-lib $checkfile);
then
  if (not_there clhep-build $SIMPATH/tools/clhep-build);
  then 
    mkdir $SIMPATH/tools/clhep-build
  fi 
  cd $SIMPATH/tools/clhep-build

  cmake -DCMAKE_INSTALL_PREFIX=$install_prefix \
        -DCMAKE_INSTALL_LIBDIR=$install_prefix/lib \
        $SIMPATH/tools/clhep

  $MAKE_command -j$number_of_processes install

  if [ "$platform" = "macosx" ];
  then
    cd $install_prefix/lib
    create_links dylib so
  fi

  check_success clhep $checkfile
  check=$?

#else
#  . $install_prefix/share/$GEANT4VERSIONp/geant4make/geant4make.sh
fi
  
cd  $SIMPATH
return 1
