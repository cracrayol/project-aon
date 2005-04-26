#!/usr/local/bin/perl -w
#
# gbtoxhtml-single.pl
# 10 April 2002
#
# Creates XHTML gamebook from XML source.
#####

use strict;

my $PROGRAM_NAME = "gbtoxhtml-single";
my $PATH_PREFIX  = "$ENV{'HOME'}/aon/data";
my $XML_PATH = "$PATH_PREFIX/xml";
my $XHTML_PATH = "$PATH_PREFIX/xhtml-single";

##

unless( $ARGV[ 0 ] ) { die "Usage:\n\t${PROGRAM_NAME} book-code\n"; }

my $CREATE_CSS = "$ENV{'HOME'}/aon/bin/create-css-xhtml-single.pl";
my $RXP        = "$ENV{'HOME'}/aon/bin/rxp";
my $JAVA       = "/usr/j2sdk1_3_0_02/bin/java";

##

my $BOOK_PATH         = "";
my $XML_SOURCE        = "";
my $TEXT_COLOR        = "";
my $LINK_COLOR        = "";
my $SCROLL_BASE_COLOR = "";
my $USE_ILLUSTRATORS  = "";

##

unless( $ARGV[ 0 ] ) { die "Usage:\n\t${PROGRAM_NAME} BOOK_CODE\n"; }

print "Reminder:\n\tDid you comment out the LaTeX special character\n\tdeclarations in the book's XML file?\n";

my( $bookCode ) = @ARGV;

if( $bookCode eq "01fftd" ) {
    $XML_SOURCE        = "01fftd.xml";
    $BOOK_PATH         .= "/lw/01fftd";
    $TEXT_COLOR        = "#003300";
    $LINK_COLOR        = "#006633";
    $SCROLL_BASE_COLOR = "#003300";
}
elsif( $bookCode eq "02fotw" ) {
    $XML_SOURCE        = "02fotw.xml";
    $BOOK_PATH         .= "/lw/02fotw";
    $TEXT_COLOR        = "#003333";
    $LINK_COLOR        = "#009999";
    $SCROLL_BASE_COLOR = "#003333";
}
elsif( $bookCode eq "03tcok" ) {
    $XML_SOURCE        = "03tcok.xml";
    $BOOK_PATH         .= "/lw/03tcok";
    $TEXT_COLOR        = "#003366";
    $LINK_COLOR        = "#0099cc";
    $SCROLL_BASE_COLOR = "#003366";
}
elsif( $bookCode eq "04tcod" ) {
    $XML_SOURCE        = "04tcod.xml";
    $BOOK_PATH         .= "/lw/04tcod";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#000099";
    $SCROLL_BASE_COLOR = "#000033";
}
elsif( $bookCode eq "05sots" ) {
    $XML_SOURCE        = "05sots.xml";
    $BOOK_PATH         .= "/lw/05sots";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#cc9900";
    $SCROLL_BASE_COLOR = "#330000";
}
elsif( $bookCode eq "06tkot" ) {
    $XML_SOURCE        = "06tkot.xml";
    $BOOK_PATH         .= "/lw/06tkot";
    $TEXT_COLOR        = "#404000";
    $LINK_COLOR        = "#999900";
    $SCROLL_BASE_COLOR = "#404000";
}
elsif( $bookCode eq "07cd" ) {
    $XML_SOURCE        = "07cd.xml";
    $BOOK_PATH         .= "/lw/07cd";
    $TEXT_COLOR        = "#003300";
    $LINK_COLOR        = "#00cc66";
    $SCROLL_BASE_COLOR = "#003300";
}
elsif( $bookCode eq "08tjoh" ) {
    $XML_SOURCE        = "08tjoh.xml";
    $BOOK_PATH         .= "/lw/08tjoh";
    $TEXT_COLOR        = "#334033";
    $LINK_COLOR        = "#669966";
    $SCROLL_BASE_COLOR = "#334033";
}
elsif( $bookCode eq "09tcof" ) {
    $XML_SOURCE        = "09tcof.xml";
    $BOOK_PATH         .= "/lw/09tcof";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#ff9900";
    $SCROLL_BASE_COLOR = "#330000";
}
elsif( $bookCode eq "10tdot" ) {
    $XML_SOURCE        = "10tdot.xml";
    $BOOK_PATH         .= "/lw/10tdot";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#ff0000";
    $SCROLL_BASE_COLOR = "#330000";
}
elsif( $bookCode eq "11tpot" ) {
    $XML_SOURCE        = "11tpot.xml";
    $BOOK_PATH         .= "/lw/11tpot";
    $TEXT_COLOR        = "#333300";
    $LINK_COLOR        = "#808066";
    $SCROLL_BASE_COLOR = "#333300";
}
elsif( $bookCode eq "12tmod" ) {
    $XML_SOURCE        = "12tmod.xml";
    $BOOK_PATH         .= "/lw/12tmod";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#990000";
    $SCROLL_BASE_COLOR = "#330000";
}
elsif( $bookCode eq "13tplor" ) {
    $XML_SOURCE        = "13tplor.xml";
    $BOOK_PATH         .= "/lw/13tplor";
    $TEXT_COLOR        = "#333300";
    $LINK_COLOR        = "#666633";
    $SCROLL_BASE_COLOR = "#333300";
}
elsif( $bookCode eq "15tdc" ) {
    $XML_SOURCE        = "15tdc.xml";
    $BOOK_PATH         .= "/lw/15tdc";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#6699cc";
    $SCROLL_BASE_COLOR = "#000033";
}
elsif( $bookCode eq "01gstw" ) {
    $XML_SOURCE        = "01gstw.xml";
    $BOOK_PATH         .= "/gs/01gstw";
    $TEXT_COLOR        = "#330066";
    $LINK_COLOR        = "#9900ff";
    $SCROLL_BASE_COLOR = "#330066";
}
elsif( $bookCode eq "01hh" ) {
    $XML_SOURCE        = "01hh.xml";
    $BOOK_PATH         .= "/fw/01hh";
    $TEXT_COLOR        = "#330066";
    $LINK_COLOR        = "#9900ff";
    $SCROLL_BASE_COLOR = "#330066";
}
elsif( $bookCode eq "rh" ) {
    $XML_SOURCE        = "rh.xml";
    $BOOK_PATH         .= "/misc/rh";
    $TEXT_COLOR        = "#400000";
    $LINK_COLOR        = "#339933";
    $SCROLL_BASE_COLOR = "#400000";
}
else{ die "Error:\n\tUknown book code ($bookCode).\n"; }

qx{$JAVA org.apache.xalan.xslt.Process -IN $XML_PATH/$XML_SOURCE -XSL $XML_PATH/xhtml-single.xsl -OUT $XHTML_PATH/$BOOK_PATH/$bookCode.html -PARAM use-illustrators \"$USE_ILLUSTRATORS\"};
qx{$CREATE_CSS $XHTML_PATH/$BOOK_PATH \"$TEXT_COLOR\" \"\#ffffe6\" \"$SCROLL_BASE_COLOR\" \"\#e6e6cc\" \"\#ffffe6\" \"$LINK_COLOR\" \"$LINK_COLOR\" \"\#e6e6cc\" \"$LINK_COLOR\"};
