#!/bin/sh
#
# author: tilusnet
#

# Lists all files that contain non-ASCII characters.
#   $1 = where
#   $2 = file pattern filter
# e.g. $basename "." "*.java"

# set -x

if [ -z "$2" ]; then
	echo "Usage: `basename $0` <where> <filepattern>"
	echo " E.g.: `basename $0` . *.java"
	exit 1
fi

find "$1" -name "$2" -exec file --mime-encoding {} \; | grep -v 'us-ascii'
