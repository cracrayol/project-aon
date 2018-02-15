#!/usr/bin/env bash
#
# Copy all formats for the specified book(s) to a directory structure that's
# ready to be pushed to the public website.
#
# Examples:
#
#     copy-all-formats.sh 05sots
#
#     list-bookcodes-by-series.sh gs | xargs copy-all-formats.sh

if [ ! -d "$AONDIR" ]; then
    >&2 echo "Please set the AONDIR environment variable"
    exit 1
fi
BASE_DIR="$AONDIR/common/scripts"

"$BASE_DIR/copy-xhtml.sh" "$@"
"$BASE_DIR/copy-svg.sh" "$@"
"$BASE_DIR/copy-ebooks.sh" "$@"
