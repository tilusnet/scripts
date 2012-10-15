#!/bin/sh
# Finds text in all files in a given folder.
#   $1 = where
#   $2 = what
#   $3 = file pattern filter (optional)
# e.g. $basename "." "nlp" "*.sh"

# set -x

if [ -z $3 ]; then
	echo "Usage: `basename $0` <where> <what> <filepattern>"
	exit 1
fi

#if [ -z "$3" ]; then
#	ffilt=""
#else
#	ffilt="-name $3"
#fi

find $1 -type f -name $3 -exec grep -HT --color "$2" {} \; 
# grep -i "$2" `find "$1" -type f -print` /dev/null # Doesn't work with spaces
#find "$1" -type f -print0 | xargs -0 grep -iT --color "$2" /dev/null 
