#!/bin/bash

# Sync current contents of this directory (PDF files)
# to project's server using rsync
# 
# TODO: Support both Spanish and English books
# 

set -e
DESTHOST=www.projectaon.org

# Rsync options:
OPTS="-rtz -i --chmod=Dg+s,ug+w,Fo-w,+X"
EXTRAOPTS="-vv"
#EXTRAOPTS="-v -v --dry-run"

# TODO: Make it possible to select if this is a test run
# (rsync to staff directory) or an official publication
# (rsync to web site)

# Spanish directory - website linked
DESTDIR=/home/projectaon/projectaon.org/es/pdf/ls

# Staff directory 
#DESTDIR=/home/javier_aon/projectaon/projectaon.org/es


# By default sync all the books
BOOKS="--files-from=spanish-books"

echo "Syncing PDF"
echo
set +e
rsync ${OPTS} ${EXTRAOPTS} ${BOOKS} . ${DESTHOST}:${DESTDIR}
set -e

exit 0
