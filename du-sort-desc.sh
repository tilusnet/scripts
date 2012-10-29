#!/bin/sh

# Displays the sizes of all subfolders in descending order. 
# By default it lists only one subfolder level. Override with optional parameter $1, which is a number, meaning the level, e.g. '2'.



if [ -n "$1" ]; then
	depth=$1
else
	depth=1
fi

du -k --max-depth=${depth} | sort -nr | awk '
	BEGIN {
		split("KB,MB,GB,TB", Units, ",");
	}
	{
		u = 1;
		while ($1 >= 1024) {
			$1 = $1 / 1024;
			u += 1
		}
		$1 = sprintf("%.1f %s", $1, Units[u]);
		print $0;
	}
	'

