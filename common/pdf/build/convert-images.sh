#!/bin/sh

# Convert images to PDF

convert=`which convert`
if [ -z "$convert" ] ; then
    echo "Cannot find the 'convert' utility" >&2
    echo "Do you have imagemagick installed?" >&2
    exit 1
fi

for filetype in png jpg; do
    for file in *.${filetype}; do 
        pdf=`echo $file | sed -e "s/${filetype}/pdf/"`
        if [ -r "$file" ] && [ ! -e "$pdf" ] ; then
            case $file in
                back*|bckgrnd*|brdr*|forward*|left*|right*|title*|toc*) ;; # ignore HTML specific images
                ac*|crt*|random*) ;; # ignore unused images
                ill*|small*|map*) echo "Converting $file to PDF ..."; convert $file $pdf ;;
                *) echo "Trimming and converting $file to PDF ..."; convert -trim +repage -transparent white $file $pdf ;;
            esac
        fi
    done
done

exit 0
