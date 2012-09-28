#!/bin/sh

# Invoke less with non-printing characters showing.

if [ $# -lt 1 ]; then
	echo "Usage: `basename $0` <filename>"
	exit 1
fi

cat -vet "$1" | less 

