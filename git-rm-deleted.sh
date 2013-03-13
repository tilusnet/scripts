#!/bin/sh
# Removes files marked as deleted from the git index.


for x in `git status | grep deleted | awk '{print $3}'`; do 
	git rm "$x"
done
