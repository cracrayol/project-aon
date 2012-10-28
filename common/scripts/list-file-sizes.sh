#!/bin/sh
# list book file sizes in page-text directive form, should be executed in a
#   parent directory of all the files to be found
# Usage: list-file-sizes.sh bookcode

list_file_size () {
    size=''
    if [ -f "$2" ]; then
        size=`ls -lh $2 \
            | awk '{print $5}' \
            | sed -e 's/\([MK]\)$/ {\1iB}/'`
    fi
    echo "(:$1:$size:)"

    return 0
}

list_dir_size () {
    size=''
    if [ -d "$2" ]; then
        size=`du -h $2 \
            | awk '{print $1}' \
            | sed -e 's/\([MK]\)$/ {\1iB}/'`
    fi
    echo "(:$1:$size:)"

    return 0
}

####

list_file_size xhtml-zip-size \
    `find . -path "*xhtml/*$1.zip"`
list_dir_size xhtml-less-simple-size \
    `find . -path "*xhtml-less-simple*$1"`
list_file_size xhtml-less-simple-zip-size \
    `find . -path "*xhtml-less-simple/*$1.zip"`
list_file_size xhtml-simple-size \
    `find . -path "*xhtml-simple/*$1.htm"`
list_file_size xhtml-simple-zip-size \
    `find . -path "*xhtml-simple/*$1.zip"`
list_file_size pdf-size \
    `find . -name "$1.pdf"`
list_file_size epub-size \
    `find . -name "$1.epub"`
list_file_size mobi-size \
    `find . -name "$1.mobi"`
list_file_size fb2-size \
    `find . -name "$1.fb2"`
list_file_size pdb-size \
    `find . -name "$1.pdb"`
list_file_size lrf-size \
    `find . -name "$1.lrf"`
