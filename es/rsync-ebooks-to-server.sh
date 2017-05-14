#!/bin/sh

# Copy all the electronic book formats generated using
# 'make publish' to Project Aon's server using rsync

#LANGS="en es"
LANGS="es"
FORMATS="epub fb2 lrf mobi pdb"
DESTHOST=www.projectaon.org
ROOTSOURCEDIR=../../PUBLISH/
ROOTDESTDIR=/home/javier_aon/projectaon/projectaon.org
OPTS="-rtz -i --chmod=Dg+s,ug+w,Fo-w,+X"
EXTRAOPTS="-vv"
#EXTRAOPTS="-v -v --dry-run"


# Command line options
if [ "$1" ] ; then
    LANGS=$1
fi


for lang in $LANGS; do
    [ "$lang" = "en" ] && DIR=lw
    [ "$lang" = "es" ] && DIR=ls
    for type in $FORMATS; do
        echo "Syncing files of type ${type} in language ${lang}"

        SOURCEDIR="${lang}/${type}"
        DESTDIR="${lang}/${type}"
        COMPLETE_SOURCE_DIR="${ROOTSOURCEDIR}/${SOURCEDIR}/"
        COMPLETE_DEST_DIR="${ROOTDESTDIR}/${DESTDIR}/"
        echo "ORIGIN: ${COMPLETE_SOURCE_DIR}"
        echo "DESTINATION: ${DESTHOST}:${COMPLETE_DEST_DIR}"
        if [ ! -e "${COMPLETE_SOURCE_DIR}" ] || [ ! -d "${COMPLETE_SOURCE_DIR}" ] ; then
            echo "ERROR: Directory ${COMPLETE_SOURCE_DIR} does not exist or is not a directory. Aborting." >&2
            echo "HINT: Did you run 'make publish' in the epub directory?" >&2
            exit 1
        fi
        echo
        set +e
        rsync ${OPTS} ${EXTRAOPTS} ${COMPLETE_SOURCE_DIR} ${DESTHOST}:${COMPLETE_DEST_DIR}
        set -e
    done
done


