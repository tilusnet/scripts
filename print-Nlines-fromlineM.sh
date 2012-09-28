#!/bin/sh

# Print ${N_lines} lines from line ${fromline_M} in file ${filename}.

if [ $# -lt 3 ]; then
        echo "Usage: `basename $0` <filename> <fromline> <linenum>"
	exit 1
fi

filename=$1
fromline_M=$2
N_lines=$3

tail -n +${fromline_M} ${filename} | head -${N_lines} 

