#!/usr/local/bin/perl -w
#
# gbtolatex.pl
# 10 April 2002
#
# Creates LaTeX gamebook from XML source. This should subsequently be
# used to create a PDF or PostScript version.
#####

use strict;

my $PROGRAM_NAME = "gbtopml";
my $PATH_PREFIX  = "$ENV{'HOME'}/aon/data";
my $XML_PATH = "$PATH_PREFIX/xml";
my $PML_PATH = "$PATH_PREFIX/pml";

my $JAVA       = '/usr/bin/java';

# Check that all the binaries are were want them

my @BINARIES;
push @BINARIES, ($JAVA);

foreach (@BINARIES) {
    if ( ! -e $_ ) {
        die "$PROGRAM_NAME: Cannot find binary '".$_."'. Please install it.\n";
    }
}

##

unless( $ARGV[ 0 ] ) { die "Usage:\n\t${PROGRAM_NAME} book-code\n"; }

print STDERR "Reminder:\n\tDid you declare the PML character entities in the XML?\n";

my $bookCode         = $ARGV[ 0 ];
my $XML_SOURCE       = "";
my $BOOK_PATH        = "";
my $USE_ILLUSTRATORS = "";

if( $bookCode eq "01fftd" ) {
    $XML_SOURCE        = "01fftd.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02fotw" ) {
    $XML_SOURCE        = "02fotw.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03tcok" ) {
    $XML_SOURCE        = "03tcok.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04tcod" ) {
    $XML_SOURCE        = "04tcod.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "05sots" ) {
    $XML_SOURCE        = "05sots.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "06tkot" ) {
    $XML_SOURCE        = "06tkot.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "07cd" ) {
    $XML_SOURCE        = "07cd.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "08tjoh" ) {
    $XML_SOURCE        = "08tjoh.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "09tcof" ) {
    $XML_SOURCE        = "09tcof.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "10tdot" ) {
    $XML_SOURCE        = "10tdot.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "11tpot" ) {
    $XML_SOURCE        = "11tpot.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "12tmod" ) {
    $XML_SOURCE        = "12tmod.xml";
    $BOOK_PATH         = "lw/";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
else{ die "Error:\n\tUknown book code.\n"; }

print qx{$JAVA org.apache.xalan.xslt.Process -IN $XML_PATH/$XML_SOURCE -XSL $XML_PATH/pml.xsl -OUT $PML_PATH/$BOOK_PATH/$bookCode.txt -PARAM use-illustrators \"$USE_ILLUSTRATORS\"};
