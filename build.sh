#!/bin/sh

if [ "$1" = "clean" ]; then
  if [ -e Makefile ]; then
    make clean
  fi
elif [ "$1" = "rpm" ]; then
  # A very simplistic RPM build scenario
  mydir=`dirname $0`
  tmpdir=`mktemp -d`
  cp -r ${mydir} ${tmpdir}/exampleInterfaces-1.0.0
  tar czf ${tmpdir}/exampleInterfaces-1.0.0.tar.gz --exclude=".svn" -C ${tmpdir} exampleInterfaces-1.0.0
  rpmbuild -ta ${tmpdir}/exampleInterfaces-1.0.0.tar.gz
  rm -rf $tmpdir
else
  # Checks if build is newer than makefile (based on modification time)
  if [ ! -e configure ] || [ ! -e Makefile ] || [ configure.ac -nt Makefile ] || [ Makefile.am -nt Makefile ]; then
    ./reconf
    ./configure
    ./install
  fi
  make
  ./install
fi
