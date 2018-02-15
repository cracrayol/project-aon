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
    exit
fi
CURR_DIR=`pwd`

BASE_DIR="$AONDIR/common/epub"
book_db="$AONDIR/common/sqlite/bookcodes.db"

for book in $@
do
    row=($(sqlite3 -separator ' ' $book_db "select lang, series from bookcodes where book = '$book';"))

    lang=${row[0]}
    series=${row[1]}

    source_dir="$BASE_DIR/$book"

    for format in epub mobi fb2 pdb lrf
    do
        output_dir="$CURR_DIR/$lang/$format/$series"
        mkdir -p "$output_dir"
        cp -av "$source_dir/$book.$format" "$output_dir"
    done
done
