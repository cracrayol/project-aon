#!/bin/sh
#
# Build all the ePub files for Project Aon in a single run
#
# (c) 2011 Javier Fernandez-Sanguino <jfs@computer.org>
#
# This script is provided with the same license as that one
# used in the Aon Project

set -e

CURDIR=`pwd`
AONDIR="../../"
LOGDIR="$CURDIR/logs/"
[ ! -e "$LOGDIR" ] && mkdir $LOGDIR
LANGS="en es"
FONTDIR="../fontfiles/"

if [ ! -e "${AONDIR}${FONTDIR}" ] ; then
    echo "The font directory (${AONDIR}${FONTDIR}) does not exist."
    echo "Please create it and copy the Souvenir font to it "
    echo "(or adjust this script to use an alternative directory)"
    exit 1
fi

generate_files() {
    ls ${AONDIR}/${lang}/xml/*.xml |
    while read file ; do
        if [ -r "$file" ]; then
            xml=`basename $file | sed -e 's/\.xml//'`
            # Look for the XML name in the ePub metadata
            if grep -q ^$xml $EPUBDATA; then
                echo -n "Generating ePub file for $xml ('$lang' language)..."
                LOGFILE=$LOGDIR/$xml.epub.log
                cd $AONDIR 
                set +e 
                perl common/scripts/gbtoepub.pl --language=$lang --font-files=$FONTDIR $xml  >$LOGFILE 2>&1
                if [ $? -ne 0 ]; then
                    echo " ERROR building file (review $LOGFILE)"
                fi
                set -e 
                cd $CURDIR
                echo "...done"
            fi
        else
            echo "ERROR: Cannot generate ePub file for $xml (not readable)"
        fi
    done

}


for lang in $LANGS; do
    EPUBDATA=${AONDIR}/${lang}/.publisher/rules/epub
    if [ -e "$EPUBDATA" ] ; then
       generate_files 
    else
        echo "ERROR: Cannot find the publisher rules at $EPUBDATA for $lang"
    fi
done

exit 0
