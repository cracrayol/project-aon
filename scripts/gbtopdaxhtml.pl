#!/bin/perl -w
#
# gbtoxhtml.pl
# 10 April 2002
#
# Creates XHTML gamebook from XML source.
#
# $Id$
#
# $Log$
# Revision 1.1  2005/04/26 04:47:54  jonathan.blake
# Initial revision
#
# Revision 1.1  2002/10/22 16:20:26  jblake
# Initial revision
#
#
# Revision 1.3  2002/10/20 05:47:50  jblake
# Added Highway Holocaust to the book list.
#
# Revision 1.2  2002/10/18 15:42:25  jblake
# Added Grey Star the Wizard to the book list.
#
# Revision 1.1  2002/10/18 15:38:41  jblake
# Initial revision
#
#####

use strict;

##

my $PROGRAM_NAME    = "gbtoxhtml";
my $PATH_PREFIX     = "$ENV{'HOME'}/aon/data";
my $XML_PATH        = "xml";
my $BOOK_PATH       = "xhtml-pda";

##

my $CREATE_CSS = "$ENV{'HOME'}/aon/bin/create-pdacss.pl";
my $RXP        = "$ENV{'HOME'}/aon/bin/rxp";
my $CP         = "/bin/cp";
my $MV         = "/bin/mv";
my $TAR        = "/usr/local/bin/tar";
my $ZIP        = "/bin/zip";
my $BZIP2      = "/bin/bzip2";
my $JAVA       = "/usr/j2sdk1_3_0_02/bin/java";
my $RM         = "/bin/rm";

##

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
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02fotw" ) {
    $XML_SOURCE        = "02fotw.xml";
    $BOOK_PATH         .= "/lw/02fotw";
    $TEXT_COLOR        = "#003333";
    $LINK_COLOR        = "#009999";
    $SCROLL_BASE_COLOR = "#003333";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03tcok" ) {
    $XML_SOURCE        = "03tcok.xml";
    $BOOK_PATH         .= "/lw/03tcok";
    $TEXT_COLOR        = "#003366";
    $LINK_COLOR        = "#0099cc";
    $SCROLL_BASE_COLOR = "#003366";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04tcod" ) {
    $XML_SOURCE        = "04tcod.xml";
    $BOOK_PATH         .= "/lw/04tcod";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#000099";
    $SCROLL_BASE_COLOR = "#000033";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "05sots" ) {
    $XML_SOURCE        = "05sots.xml";
    $BOOK_PATH         .= "/lw/05sots";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#cc9900";
    $SCROLL_BASE_COLOR = "#330000";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "06tkot" ) {
    $XML_SOURCE        = "06tkot.xml";
    $BOOK_PATH         .= "/lw/06tkot";
    $TEXT_COLOR        = "#404000";
    $LINK_COLOR        = "#999900";
    $SCROLL_BASE_COLOR = "#404000";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "07cd" ) {
    $XML_SOURCE        = "07cd.xml";
    $BOOK_PATH         .= "/lw/07cd";
    $TEXT_COLOR        = "#003300";
    $LINK_COLOR        = "#00cc66";
    $SCROLL_BASE_COLOR = "#003300";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "08tjoh" ) {
    $XML_SOURCE        = "08tjoh.xml";
    $BOOK_PATH         .= "/lw/08tjoh";
    $TEXT_COLOR        = "#334033";
    $LINK_COLOR        = "#669966";
    $SCROLL_BASE_COLOR = "#334033";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "09tcof" ) {
    $XML_SOURCE        = "09tcof.xml";
    $BOOK_PATH         .= "/lw/09tcof";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#ff9900";
    $SCROLL_BASE_COLOR = "#330000";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "10tdot" ) {
    $XML_SOURCE        = "10tdot.xml";
    $BOOK_PATH         .= "/lw/10tdot";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#ff0000";
    $SCROLL_BASE_COLOR = "#330000";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "11tpot" ) {
    $XML_SOURCE        = "11tpot.xml";
    $BOOK_PATH         .= "/lw/11tpot";
    $TEXT_COLOR        = "#333300";
    $LINK_COLOR        = "#808066";
    $SCROLL_BASE_COLOR = "#333300";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "12tmod" ) {
    $XML_SOURCE        = "12tmod.xml";
    $BOOK_PATH         .= "/lw/12tmod";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#990000";
    $SCROLL_BASE_COLOR = "#330000";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "13tplor" ) {
    $XML_SOURCE        = "13tplor.xml";
    $BOOK_PATH         .= "/lw/13tplor";
    $TEXT_COLOR        = "#333300";
    $LINK_COLOR        = "#666633";
    $SCROLL_BASE_COLOR = "#333300";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "15tdc" ) {
    $XML_SOURCE        = "15tdc.xml";
    $BOOK_PATH         .= "/lw/15tdc";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#6699cc";
    $SCROLL_BASE_COLOR = "#000033";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
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

chdir( "$PATH_PREFIX" ) or die( "Cannot open Project Aon data directory \"$PATH_PREFIX\": $!" );
print STDERR "Validating XML... ";
system( "$RXP", "-Vs", "$XML_PATH/$XML_SOURCE" ) == 0 or die( "failed\n" );
print STDERR "succeeded\n";

-d "$BOOK_PATH" or die( "Book directory does not exist or isn't a directory: $!\n" );

print STDERR "Removing previous files in \"$PATH_PREFIX/$BOOK_PATH/\"...\n";
qx{$RM $BOOK_PATH/*};
print STDERR "Processing XSL Transformation...\n";
print STDERR "Warning:\n\tdiscarding top-level output of transformation\n";
print qx{$JAVA org.apache.xalan.xslt.Process -IN $XML_PATH/$XML_SOURCE -XSL $XML_PATH/xhtml-pda.xsl -OUT /dev/null -PARAM book-path \"$PATH_PREFIX/$BOOK_PATH\" -PARAM text-color \"$TEXT_COLOR\" -PARAM link-color \"$LINK_COLOR\" -PARAM use-illustrators \"$USE_ILLUSTRATORS\"};

print STDERR "Creating CSS\n";
print qx{$CREATE_CSS $BOOK_PATH \"$TEXT_COLOR\" \"\#ffffe6\" \"$SCROLL_BASE_COLOR\" \"\#e6e6cc\" \"\#ffffe6\" \"$LINK_COLOR\" \"$LINK_COLOR\" \"\#e6e6cc\" \"$LINK_COLOR\"};

print STDERR "Copying archived image files...\n";
qx{$CP images/$BOOK_PATH/*gif images/$BOOK_PATH/*jpg $BOOK_PATH};
