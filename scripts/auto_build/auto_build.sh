#!/bin/sh
# --
# auto_build.sh - build automatically OTRS tar, rpm and src-rpm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

echo "auto_build.sh - build OTRS release files"
echo "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/";

PATH_TO_CVS_SRC=$1
PRODUCT=OTRS
VERSION=$2
RELEASE=$3
ARCHIVE_DIR="otrs-$VERSION"
PACKAGE=otrs
PACKAGE_BUILD_DIR="/tmp/$PACKAGE-build"
PACKAGE_DEST_DIR="/tmp/$PACKAGE-packages"

if ! test $PATH_TO_CVS_SRC || ! test $VERSION || ! test $RELEASE; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: auto_build.sh <PATH_TO_CVS_SRC> <VERSION> <BUILD>"
    echo ""
    echo "  Try: auto_build.sh /home/ernie/src/otrs 3.1.0.beta1 01"
    echo ""
    exit 1;
else
    # --
    # check dir
    # --
    if ! test -e $PATH_TO_CVS_SRC/RELEASE; then
        echo "Error: $PATH_TO_CVS_SRC is not OTRS CVS directory!"
        exit 1;
    fi
fi

SYSTEM_SOURCE_DIR=$PACKAGE_BUILD_DIR/src

rm -rf $PACKAGE_DEST_DIR
mkdir $PACKAGE_DEST_DIR


# --
# build
# --
rm -rf $PACKAGE_BUILD_DIR || exit 1;
mkdir -p $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
mkdir -p $SYSTEM_SOURCE_DIR || exit 1;

cp -a $PATH_TO_CVS_SRC/.*rc.dist $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
cp -a $PATH_TO_CVS_SRC/.mailfilter.dist $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
cp -a $PATH_TO_CVS_SRC/.bash_completion $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
cp -a $PATH_TO_CVS_SRC/* $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;

# --
# update RELEASE
# --
RELEASEFILE=$PACKAGE_BUILD_DIR/$ARCHIVE_DIR/RELEASE
echo "PRODUCT = $PRODUCT" > $RELEASEFILE
echo "VERSION = $VERSION" >> $RELEASEFILE
echo "BUILDDATE = `date`" >> $RELEASEFILE
echo "BUILDHOST = `hostname -f`" >> $RELEASEFILE

# --
# cleanup
# --
cd $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;

# remove old sessions, articles and spool and other stuff
# (remainders of a running system, should not really happen)
rm -rf .gitignore var/sessions/* var/article/* var/spool/* Kernel/Config.pm
# remove development content
rm -rf development
# remove swap/temp stuff
find -name ".#*" | xargs rm -rf
find -name ".keep" | xargs rm -f

# mk ARCHIVE
bin/otrs.CheckSum.pl -a create
# Create needed directories
mkdir -p var/tmp var/article var/log

function CreateArchive() {
    SUFFIX=$1
    COMMANDLINE=$2

    cd $PACKAGE_BUILD_DIR/ || exit 1;
    SOURCE_LOCATION=$SYSTEM_SOURCE_DIR/$PACKAGE-$VERSION.$SUFFIX
    rm $SOURCE_LOCATION
    echo "Building $SOURCE_LOCATION..."
    echo $COMMANDLINE $SOURCE_LOCATION $ARCHIVE_DIR/
    $COMMANDLINE $SOURCE_LOCATION $ARCHIVE_DIR/ > /dev/null || exit 1;
    cp $SOURCE_LOCATION $PACKAGE_DEST_DIR/
}

CreateArchive "tar.gz"  "tar -czf"
CreateArchive "tar.bz2" "tar -cjf"
CreateArchive "zip"     "zip -r"

