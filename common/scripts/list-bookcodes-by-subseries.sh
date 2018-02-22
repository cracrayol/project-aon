#!/usr/bin/env bash
#
# List all bookcodes that match given subseries.
# 
# Example:
#     list-bookcodes-by-subseries.sh lw gs

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi

book_db="$AONDIR/common/sqlite/bookcodes.db"

for subseries in $@
do
    if [[ ! $subseries =~ ^[a-z]+$ ]]; then
        >&2 echo "invalid subseries"
        exit 1
    fi

    sqlite3 -column -noheader "$book_db" <<EOF
      select book 
      from bookcodes 
      where subseries = '$subseries'
      order by book
EOF
done
