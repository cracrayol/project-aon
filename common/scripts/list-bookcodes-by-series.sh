#!/usr/bin/env bash
#
# List all bookcodes that match given series.
# 
# Example:
#     list-bookcodes-by-series.sh lw gs

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi

book_db="$AONDIR/common/sqlite/bookcodes.db"

for series in $@
do
    if [[ ! $series =~ ^[a-z][a-z]$ ]]; then
        >&2 echo "invalid series"
        exit 1
    fi

    sqlite3 -column -noheader "$book_db" <<EOF
      select book 
      from bookcodes 
      where series = '$series'
      order by book
EOF
done
