#!/bin/sh
# Extract list of graphics used by a given TeX file

dir=`pwd`
file=`basename $dir`
tex="$file.tex"
grep graphics $tex |
perl -ne 'print $1."\n" if /{(\w+\.pdf)}/' |
sort -u

