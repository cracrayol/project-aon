#!/usr/bin/env bash
#
# Copy ebook files for the specified book(s) to a directory structure that's
# ready to be pushed to the public website.
#
# Examples:
#
#     copy-ebooks.sh 05sots
#
#     list-bookcodes-by-series.sh gs | xargs copy-ebooks.sh

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi
CURR_DIR=`pwd`

if [ "$AONDIR" -ef "$CURR_DIR" ]; then
    >&2 echo "Current directory is the same as AONDIR: giving up"
    exit 1
fi

BASE_DIR="$AONDIR/common/epub"

for book in $@
do
    row=( $($AONDIR/common/scripts/list-book-info.sh $book) )

    lang=${row[1]}
    series=${row[2]}

    source_dir="$BASE_DIR/$book"

    for format in epub mobi fb2 pdb lrf
    do
        output_dir="$CURR_DIR/$lang/$format/$series"
        mkdir -p "$output_dir"
        cp -av "$source_dir/$book.$format" "$output_dir"
    done
done
