#!/bin/bash

# Facilitates a `mv $1 $2`, including hidden files.
# See http://superuser.com/questions/62141/linux-how-to-move-all-files-from-current-directory-to-upper-directory

if [ $# -lt 2 ]; then
	echo "Usage: `basename $0` <source-folder> <target-folder>"
	echo "Note that <source-folder>'s content will be moved, not the folder itself (for which you can use plain 'mv')."
	exit 1
fi

# set -x

pushd ${1}
src_folder=`pwd`
popd

pushd ${2}
dest_folder=`pwd`
popd

(shopt -s dotglob; cd "$src_folder" ;mv -- * "$dest_folder")

