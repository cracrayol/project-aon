#!/usr/bin/env bash
#
# List all bookcodes that match given language.
# 
# Example:
#     list-bookcodes-by-lang.sh en es

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi

book_db="$AONDIR/common/sqlite/bookcodes.db"

for lang in $@
do
    if [[ ! $lang =~ ^[a-z][a-z]$ ]]; then
        >&2 echo "invalid language"
        exit 1
    fi

    sqlite3 -noheader "$book_db" <<EOF
      select book 
      from bookcodes 
      where lang = '$lang'
      order by book
EOF
done
