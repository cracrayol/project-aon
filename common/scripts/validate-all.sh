#!/bin/sh

for file in "$@"
do
    echo "validating $file"
    rxp -Vs $file
done
