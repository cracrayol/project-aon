#!/bin/sh

# Check if the included files are all available in the current directory

file=$1

if [ -z "$file" ] ; then
    echo "Usage: $0 file.tex" 
    echo "Checks if the included graphics in the TeX file are available in "
    echo "the current directory"
    exit 1
fi

if [ ! -r "$file" ] ; then
    echo "ERROR: Cannot read $file"
    exit 1
fi

exitval=0
grep includegraphics $file | 
perl -ne 'print $1."\n" if /.*\{(\w+\.pdf)\}/' |
sort -u  | 
while read graph; do 
    [ ! -e "$graph" ] && echo "WARNING: Included graphic file $graph is not available in the current directory." >&2 
    exitval=1
done


exit $exitval
