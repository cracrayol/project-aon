#!/bin/sh
#
# Build all the xHTML files for Project Aon in a single run
#
# (c) 2011 Javier Fernandez-Sanguino <jfs@computer.org>
#
# This script is provided with the same license as that one
# used in the Aon Project

set -e

CURDIR=`pwd`
[ -z "$AONDIR" ] && AONDIR="../../"
[ -z "$LANGS" ]  && LANGS="en es"
LOGDIR="$CURDIR/logs/"
[ ! -e "$LOGDIR" ] && mkdir $LOGDIR

if [ -n "$1" ] ; then
    BOOKS="$1"
else
    BOOKS='*'
fi

generate_files() {
    ls ${AONDIR}/${lang}/xml/$1.xml |
    while read file ; do
        if [ -r "$file" ]; then
            xml=`basename $file | sed -e 's/\.xml//'`
            # Look for the XML name in the metadata file
            if grep -q ^$xml $METADATA; then
                echo -n "Generating XHTML for $xml ('$lang' language)..."
                LOGFILE=$LOGDIR/$xml.xhtml.log
                cd $AONDIR 
                set +e 
                perl common/scripts/gbtoxhtml.pl --language=$lang $xml >$LOGFILE 2>&1
                if [ $? -ne 0 ]; then
                    echo " ERROR building Xhtml file (review $LOGFILE)"
                fi
                echo "...done"
                LOGFILE=$LOGDIR/$xml.xhtml-simple.log
                echo -n "Building XHTML simple"
                perl common/scripts/gbtoxhtml-simple.pl --language=$lang $xml >$LOGFILE 2>&1
                if [ $? -ne 0 ]; then
                    echo " ERROR building xhtml simple file (review $LOGFILE)"
                fi
                echo "...done"
                LOGFILE=$LOGDIR/$xml.xhtml-less-simple.log
                echo -n "Building XHTML less simple"
                perl common/scripts/gbtoxhtml-less-simple.pl --language=$lang $xml >$LOGFILE 2>&1
                if [ $? -ne 0 ]; then
                    echo " ERROR building xhtml less simple file (review $LOGFILE)"
                fi
                echo "...done"
                set -e 
                cd $CURDIR
            else 
                echo "WARN: Do not find metadata for $xml in $METADATA"
            fi
        else
            echo "ERROR: Cannot generate xhtml file for $xml (not readable)"
        fi
    done
}

for lang in $LANGS; do
    METADATA=${AONDIR}/${lang}/.publisher/rules/simple
    if [ -e "$METADATA" ] ; then
        generate_files "$BOOKS"
    else
        echo "ERROR: Cannot find the publisher rules at $METADATA for $lang"
    fi
done

exit 0
