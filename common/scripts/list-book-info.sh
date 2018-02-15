#!/usr/bin/env bash
#
# List all book into that match given bookcode(s). If the bookcode is omitted,
# outputs data for all books.
# 
# Examples:
#     list-book-info.sh lw gs
#
#     list-book-info.sh

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi

book_db="$AONDIR/common/sqlite/bookcodes.db"

if [ -z "$1" ]; then
    sqlite3 -column -noheader "$book_db" <<EOF
        select book, lang, series
        from bookcodes
        order by book
EOF
    exit
fi


for book in $@
do
    if [[ ! $book =~ ^[a-z0-9]+[a-z]$ ]]; then
        >&2 echo "invalid book code"
        exit
    fi

    sqlite3 -column -noheader "$book_db" <<EOF
      select book, lang, series
      from bookcodes 
      where book = '$book'
      order by book
EOF
done
