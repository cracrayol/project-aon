#!/bin/bash

ZIP='/usr/bin/zip'
TAR='/bin/tar'

$ZIP -r all-books.zip xhtml -x \*.zip -x \*.bz2 -x \*/.ht\* -x \*/rh/\*;
$TAR cjvf all-books.tar.bz2 --exclude=*.zip --exclude=*.bz2 --exclude=*.ht --exclude=*/rh/* xhtml;
