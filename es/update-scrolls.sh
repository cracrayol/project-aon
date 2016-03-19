#!/bin/sh -e

# Update title skins based on the gif files contributed 

for dir in eps/ls/*; do
    series=`basename $dir` 
    scroll_eps="eps/ls/${series}/bearer.eps"
    scroll_pdf="pdf/ls/${series}/bearer.pdf"
    pdfdir=`dirname $scroll_pdf`
    if [ -e "$scroll_eps" ] ; then
        [ ! -e "$pdfdir" ] && mkdir -p "$pdfdir"
        echo "Series $series - updating PDF title with EPS version (in $pdfdir)"
        convert "$scroll_eps" "$scroll_pdf"
    fi
done
