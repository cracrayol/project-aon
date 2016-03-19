#!/bin/sh -e

# Update title skins based on the gif files contributed 

series="kai magnakai grandmaster neworder"
for series in $series; do
    if [ -d "png/ls/${series}" ] ; then
        for file in png/ls/${series}/*png; do
            if [ -e "$file" ] ; then
               basefile=`basename $file | sed -e 's/.png//'` 
               scroll_png=$file
               scroll_pdf="pdf/ls/${series}/${basefile}.pdf"
               pdfdir=`dirname $scroll_pdf`
               [ ! -e "$pdfdir" ] && mkdir -p "$pdfdir"
               echo "Series $series - updating PDF chart $basefile with PNG version (in $pdfdir)"
               convert "$scroll_png" "$scroll_pdf"
            fi
        done
    fi
done
