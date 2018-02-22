#!/usr/bin/env bash
#
# List all bookcodes.

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi

book_db="$AONDIR/common/sqlite/bookcodes.db"

sqlite3 -noheader "$book_db" "select book from bookcodes order by book"
