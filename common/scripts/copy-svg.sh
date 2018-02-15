#!/usr/bin/env bash
#
# Copy SVG files for the specified book(s) to a directory structure that's
# ready to be pushed to the public website.
#
# Examples:
#
#     copy-svg.sh 05sots
#
#     list-bookcodes-by-series.sh gs | xargs copy-svg.sh

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit
fi
CURR_DIR=`pwd`

book_db="$AONDIR/common/sqlite/bookcodes.db"

for book in $@
do
    row=($(sqlite3 -separator ' ' $book_db "select lang, series from bookcodes where book = '$book';"))

    lang=${row[0]}
    series=${row[1]}

    source_dir="$AONDIR/$lang/svg/$series"
    output_dir="$CURR_DIR/$lang/svg/$series"
    mkdir -p "$output_dir"
    cp -av "$source_dir/$book.svgz" "$output_dir"
done
