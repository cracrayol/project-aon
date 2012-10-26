#!/bin/sh
# List the file sizes of a book, should be executed in a parent directory of
#   all the files to be found
# Usage: list-file-sizes.sh bookcode

find . -name "$1.*" \
    | grep -v "\.svn\|\.xml" \
    | xargs ls -lh \
    | awk '{print $5 "\t" $9}'
