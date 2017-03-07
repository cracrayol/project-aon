#!/bin/sh -e
#
# Do a spell check of PAE files using a standard dictionary
# and the aspell program
#

DICTFILE=pae-dict.aspell

check_dict() {
    [ -r "$DICTFILE" ] && return 0
    [ -e "$DICTFILE" ] && echo "ERROR: Dictionary file $DICTFILE does not exist. Incomplete checkout?" >&2
    [ ! -f "$DICTFILE" ] && echo "ERROR: Dictionary file $DICTFILE is not a regular file." >&2
    return 1
}

usage() {
    echo "Usage: $0 book.xml [book2.xml ...]"
}

if [ -z "$*" ] ; then
    usage
    exit 1
fi

if ! check_dict ; then
    echo "There was an error with the dictionary file. Aborting" >&2
    exit 1
fi

for file in $* ; do
    if [ -f "$file" ] && [ -r "$file" ] ; then
        echo "Running spell check for $file"
        aspell --add-filter=sgml -p $DICTFILE -c $file
    else
        echo -n "ERROR: Will not check '$file'" >&2
        if [ ! -e "$file" ] ; then
            echo -n " it does not exist." >&2
        elif [ ! -f "$file" ] ; then
            echo " it is not a regular file." >&2
        fi
        echo
    fi
done

exit 0
