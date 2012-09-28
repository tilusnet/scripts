#!/bin/sh

# Replaces all occurrences of $1 with $2 in all files under the current folder.
# -b adds backup support

if [ $# -lt 2 ]; then
	echo "Usage: `basename $0` <oldText> <NewText> [-b]"
	exit 1
fi

oldText=$1
newText=$2
if [ "$3" = "-b" ]; then
	bckpsett=".bak"
else
	bckpsett=
fi

sed -i${bckpsett} 's/'${oldText}'/'${newText}'/g' `find . -type f`

