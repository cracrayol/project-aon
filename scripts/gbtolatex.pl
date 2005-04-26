#!/bin/perl -w
#
# gbtolatex.pl
# 10 April 2002
#
# Creates LaTeX gamebook from XML source. This should subsequently be
# used to create a PDF or PostScript version.
#####

use strict;

my $PROGRAM_NAME      = "gbtolatex";
my $XML_PATH          = "xml";
my $XML_SOURCE        = "";
my $BOOK_PATH         = "latex";
my $TITLE_COLOR       = "";
my $USE_ILLUSTRATORS  = "";

my $JAVA = "/cygdrive/c/WINDOWS/java.exe";

##

unless( $ARGV[ 0 ] ) { die "Usage:\n\t${PROGRAM_NAME} book-code\n"; }

print "Reminder:\n\tDid you uncomment the LaTeX special character\n\tdeclarations in the book's XML file?\n";

my $bookCode = $ARGV[ 0 ];

if( $bookCode eq "01fftd" ) {
    $XML_SOURCE        = "01fftd.xml";
    $BOOK_PATH         .= "/lw/01fftd";
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02fotw" ) {
    $XML_SOURCE        = "02fotw.xml";
    $BOOK_PATH         .= "/lw/02fotw";
    $TITLE_COLOR       = "0.0,0.6,0.6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03tcok" ) {
    $XML_SOURCE        = "03tcok.xml";
    $BOOK_PATH         .= "/lw/03tcok";
    $TITLE_COLOR       = "0.0,0.6,0.8";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04tcod" ) {
    $XML_SOURCE        = "04tcod.xml";
    $BOOK_PATH         .= "/lw/04tcod";
    $TITLE_COLOR       = "0.0,0.0,0.6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "05sots" ) {
    $XML_SOURCE        = "05sots.xml";
    $BOOK_PATH         .= "/lw/05sots";
    $TITLE_COLOR       = "0.8,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "06tkot" ) {
    $XML_SOURCE        = "06tkot.xml";
    $BOOK_PATH         .= "/lw/06tkot";
    $TITLE_COLOR       = "0.6,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "07cd" ) {
    $XML_SOURCE        = "07cd.xml";
    $BOOK_PATH         .= "/lw/07cd";
    $TITLE_COLOR       = "0.0,0.8,0.4";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "08tjoh" ) {
    $XML_SOURCE        = "08tjoh.xml";
    $BOOK_PATH         .= "/lw/08tjoh";
    $TITLE_COLOR       = "0.4,0.6,0.4";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "09tcof" ) {
    $XML_SOURCE        = "09tcof.xml";
    $BOOK_PATH         .= "/lw/09tcof";
    $TITLE_COLOR       = "1.0,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "10tdot" ) {
    $XML_SOURCE        = "10tdot.xml";
    $BOOK_PATH         .= "/lw/10tdot";
    $TITLE_COLOR       = "1.0,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "11tpot" ) {
    $XML_SOURCE        = "11tpot.xml";
    $BOOK_PATH         .= "/lw/11tpot";
    $TITLE_COLOR       = "0.5,0.5,0.4";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "12tmod" ) {
    $XML_SOURCE        = "12tmod.xml";
    $BOOK_PATH         .= "/lw/12tmod";
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
else{ die "Error:\n\tUknown book code.\n"; }

chdir( "$ENV{'AONPATH'}/data" ) or die( "Cannot open Project Aon data directory \"$ENV{'AONPATH'}/data\": $!" );
print qx{$JAVA org.apache.xalan.xslt.Process -IN $XML_PATH/$XML_SOURCE -XSL $XML_PATH/latex.xsl -OUT $BOOK_PATH/$bookCode.tex -PARAM title-color \"$TITLE_COLOR\" -PARAM use-illustrators \"$USE_ILLUSTRATORS\"};
