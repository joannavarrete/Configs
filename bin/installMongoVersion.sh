#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: installMongoVersion.sh <version>"
    exit 1
fi

BINPATH=$(dirname `which mongod`)
#BINPATH=/usr/local/bin
VERSION=$1
VERSIONPATH=$BINPATH/mongodb/$VERSION

if [ -e $VERSIONPATH ]; then
    echo "ERROR: $VERSIONPATH already exists"
    exit 1
fi

echo "Creating directory for MongoDB files at: $VERSIONPATH"

if (! sudo mkdir $VERSIONPATH); then
    echo "ERROR: creating $VERSIONPATH failed"
    exit 1
fi

echo "Installing MongoDB files to: $VERSIONPATH"

if (! sudo scons --prefix=$VERSIONPATH install); then
    echo "ERROR: installing MongoDB to $VERSIONPATH failed"
    exit 1
fi

echo "Moving MongoDB files from temporary bin directory to final location at: $VERSIONPATH"

if (! sudo mv $VERSIONPATH/bin/* $VERSIONPATH); then
    echo "ERROR: moving files from temporary bin directory failed"
    exit 1
fi

echo "Deleting empty temporary bin directory"

sudo rmdir $VERSIONPATH/bin