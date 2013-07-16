#!/bin/bash

# Kills left behind chrome instances

for i in `pgrep chrome` ; do
    echo "Killing chrome instance with pid ${i}..."
    kill $i
    sleep .33
done
echo "Done."
