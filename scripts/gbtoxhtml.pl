#!/usr/bin/perl -w
#
# gbtoxhtml.pl
#
# Creates XHTML gamebook from XML source.
#
# $Id$
#
# $Log$
# Revision 1.1  2005/04/26 04:47:33  jonathan.blake
# Initial revision
#
# Revision 1.8  2003/07/14 17:20:09  jblake
# Modified for Xalan 2.5.1, added support for AONPATH
# environment variable, commented out RXP validation.
#
# Revision 1.7  2002/11/10 07:52:15  jblake
# Added more books.
#
# Revision 1.6  2002/11/10 03:57:50  jblake
# Added some missing semicolons.
#
# Revision 1.5  2002/11/07 18:43:14  jblake
# Added books (02fotw, 13tplor, and 15tdc) and added an illustrator to the list.
#
# Revision 1.4  2002/10/23 18:58:34  jblake
# Added Flight from the Dark to the valid book list, and made
# a change to the working directory in order to work with
# Xalan-J 2.4.0.
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
my $PATH_PREFIX     = "$ENV{'AONPATH'}/data";
my $XML_PATH        = "xml";
my $BOOK_PATH       = "xhtml";
my $WEBSITE_PATH    = "website";

##

my $CREATE_CSS = "$ENV{'HOME'}/aon/bin/create-css.pl";
my $RXP        = "$ENV{'HOME'}/aon/bin/rxp";
my $CP         = "/bin/cp";
my $MV         = "/bin/mv";
my $TAR        = "/bin/tar";
my $ZIP        = "/usr/bin/zip";
my $BZIP2      = "/usr/bin/bzip2";
my $JAVA       = "/usr/lib/java/jre/bin/java";
my $RM         = "/bin/rm";
my $CHMOD      = "/bin/chmod";

##

my $XML_SOURCE               = "";
my $TEXT_COLOR               = "";
my $LINK_COLOR               = "";
my $HLINK_BACK_COLOR         = "";
my $HLINK_LIGHT_BORDER_COLOR = "";
my $HLINK_DARK_BORDER_COLOR  = "";
my $USE_ILLUSTRATORS         = "";

##

unless( $#ARGV == 0 ) { die "Usage:\n\t${PROGRAM_NAME} bookCode\n"; }
my( $bookCode ) = @ARGV;

if( $bookCode eq "01fftd" ) {
    $XML_SOURCE        = "01fftd.xml";
    $BOOK_PATH         .= "/lw/01fftd";
    $TEXT_COLOR        = "#003300";
    $LINK_COLOR        = "#006633";
    $HLINK_BACK_COLOR  = "#cce0c1";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02fotw" ) {
    $XML_SOURCE        = "02fotw.xml";
    $BOOK_PATH         .= "/lw/02fotw";
    $TEXT_COLOR        = "#003333";
    $LINK_COLOR        = "#009999";
    $HLINK_BACK_COLOR  = "#ccebd5";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03tcok" ) {
    $XML_SOURCE        = "03tcok.xml";
    $BOOK_PATH         .= "/lw/03tcok";
    $TEXT_COLOR        = "#003366";
    $LINK_COLOR        = "#0099cc";
    $HLINK_BACK_COLOR  = "#ccebdf";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04tcod" ) {
    $XML_SOURCE        = "04tcod.xml";
    $BOOK_PATH         .= "/lw/04tcod";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#000099";
    $HLINK_BACK_COLOR  = "#ccccd5";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "05sots" ) {
    $XML_SOURCE        = "05sots.xml";
    $BOOK_PATH         .= "/lw/05sots";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#cc9900";
    $HLINK_BACK_COLOR  = "#f5ebb6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "06tkot" ) {
    $XML_SOURCE        = "06tkot.xml";
    $BOOK_PATH         .= "/lw/06tkot";
    $TEXT_COLOR        = "#404000";
    $LINK_COLOR        = "#999900";
    $HLINK_BACK_COLOR  = "#ebebb6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "07cd" ) {
    $XML_SOURCE        = "07cd.xml";
    $BOOK_PATH         .= "/lw/07cd";
    $TEXT_COLOR        = "#003300";
    $LINK_COLOR        = "#00cc66";
    $HLINK_BACK_COLOR  = "#ccf5cb";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "08tjoh" ) {
    $XML_SOURCE        = "08tjoh.xml";
    $BOOK_PATH         .= "/lw/08tjoh";
    $TEXT_COLOR        = "#334033";
    $LINK_COLOR        = "#669966";
    $HLINK_BACK_COLOR  = "#e0ebcb";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "09tcof" ) {
    $XML_SOURCE        = "09tcof.xml";
    $BOOK_PATH         .= "/lw/09tcof";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#ff9900";
    $HLINK_BACK_COLOR  = "#ffebb6";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "10tdot" ) {
    $XML_SOURCE        = "10tdot.xml";
    $BOOK_PATH         .= "/lw/10tdot";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#ff0000";
    $HLINK_BACK_COLOR  = "#ffccb6";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "11tpot" ) {
    $XML_SOURCE        = "11tpot.xml";
    $BOOK_PATH         .= "/lw/11tpot";
    $TEXT_COLOR        = "#333300";
    $LINK_COLOR        = "#808066";
    $HLINK_BACK_COLOR  = "#e6e6cb";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "12tmod" ) {
    $XML_SOURCE        = "12tmod.xml";
    $BOOK_PATH         .= "/lw/12tmod";
    $TEXT_COLOR        = "#330000";
    $LINK_COLOR        = "#990000";
    $HLINK_BACK_COLOR  = "#ebccb6";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "13tplor" ) {
    $XML_SOURCE        = "13tplor.xml";
    $BOOK_PATH         .= "/lw/13tplor";
    $TEXT_COLOR        = "#333300";
    $LINK_COLOR        = "#666633";
    $HLINK_BACK_COLOR  = "#e0e0c1";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "14tcok" ) {
    $XML_SOURCE        = "14tcok.xml";
    $BOOK_PATH         .= "/lw/14tcok";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#660099";
    $HLINK_BACK_COLOR  = "#e0ccd5";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "15tdc" ) {
    $XML_SOURCE               = "15tdc.xml";
    $BOOK_PATH                .= "/lw/15tdc";
    $TEXT_COLOR               = "#000033";
    $LINK_COLOR               = "#6699cc";
    $HLINK_BACK_COLOR         = "#e0ebdf";
    $USE_ILLUSTRATORS         = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "16tlov" ) {
    $XML_SOURCE               = "16tlov.xml";
    $BOOK_PATH                .= "/lw/16tlov";
    $TEXT_COLOR               = "#000033";
    $LINK_COLOR               = "#0033cc";
    $HLINK_BACK_COLOR         = "#d9e1e0";
    $USE_ILLUSTRATORS         = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "17tdoi" ) {
    $XML_SOURCE               = "17tdoi.xml";
    $BOOK_PATH                .= "/lw/17tdoi";
    $TEXT_COLOR               = "#003366";
    $LINK_COLOR               = "#6699ff";
    $HLINK_BACK_COLOR         = "#e0eaea";
    $USE_ILLUSTRATORS         = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "01gstw" ) {
    $XML_SOURCE        = "01gstw.xml";
    $BOOK_PATH         .= "/gs/01gstw";
    $TEXT_COLOR        = "#330066";
    $LINK_COLOR        = "#9900ff";
    $HLINK_BACK_COLOR  = "#ebcce9";
    $USE_ILLUSTRATORS  = ":Christopher Lundgren:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02tfc" ) {
    $XML_SOURCE               = "02tfc.xml";
    $BOOK_PATH                .= "/gs/02tfc";
    $TEXT_COLOR               = "#333300";
    $LINK_COLOR               = "#999966";
    $HLINK_BACK_COLOR         = "#ebebcb";
    $USE_ILLUSTRATORS         = ":Christopher Lundgren:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03btng" ) {
    $XML_SOURCE        = "03btng.xml";
    $BOOK_PATH         .= "/gs/03btng";
    $TEXT_COLOR        = "#003333";
    $LINK_COLOR        = "#669999";
    $HLINK_BACK_COLOR  = "#e0ebd5";
    $USE_ILLUSTRATORS  = ":Christopher Lundgren:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04wotw" ) {
    $XML_SOURCE        = "04wotw.xml";
    $BOOK_PATH         .= "/gs/04wotw";
    $TEXT_COLOR        = "#000033";
    $LINK_COLOR        = "#9999cc";
    $HLINK_BACK_COLOR  = "#ebebdf";
    $USE_ILLUSTRATORS  = ":Christopher Lundgren:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "01hh" ) {
    $XML_SOURCE        = "01hh.xml";
    $BOOK_PATH         .= "/fw/01hh";
    $TEXT_COLOR        = "#330066";
    $LINK_COLOR        = "#9900ff";
#    $SCROLL_BASE_COLOR = "#330066";
    $USE_ILLUSTRATORS  = ":Jonathan Blake:";
}
elsif( $bookCode eq "rh" ) {
    $XML_SOURCE        = "rh.xml";
    $BOOK_PATH         .= "/misc/rh";
    $TEXT_COLOR        = "#400000";
    $LINK_COLOR        = "#339933";
    $HLINK_BACK_COLOR  = "#e1f0ca";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "mhahn" ) {
    $XML_SOURCE        = "mhahn.xml";
    $BOOK_PATH         .= "/misc/mhahn";
    $TEXT_COLOR        = "#400000";
    $LINK_COLOR        = "#339933";
    $HLINK_BACK_COLOR  = "#e1f0ca";
    $USE_ILLUSTRATORS  = ":Michael Hahn:";
}
elsif( $bookCode eq "jcalvarez" ) {
    $XML_SOURCE        = "jcalvarez.xml";
    $BOOK_PATH         .= "/misc/jcalvarez";
    $TEXT_COLOR        = "#400000";
    $LINK_COLOR        = "#339933";
    $HLINK_BACK_COLOR  = "#e1f0ca";
    $USE_ILLUSTRATORS  = ":JC Alvarez:";
}
elsif( $bookCode eq "statskeeper" ) { }
elsif( $bookCode eq "base" ) { }
else{ die "Error:\n\tUnknown book code ($bookCode).\n"; }

if( $bookCode eq "statskeeper" ) {
  chdir( "$PATH_PREFIX" ) or die( "Cannot open Project Aon data directory \"$PATH_PREFIX\": $!" );
  chdir( "$WEBSITE_PATH/main" ) or die( "Error: unable to change to statskeeper directory ($!)\n" );
  print qx{$RM statskeeper.zip statskeeper.tar.bz2 statskeeper.tar};
  my $statskeeperFiles = "statskeeper/index.htm statskeeper/lw/*htm statskeeper/lw/*/* statskeeper/gs/*htm statskeeper/gs/*/*";
  print qx{$ZIP -8 -q statskeeper.zip $statskeeperFiles};
  print qx{$TAR cf statskeeper.tar $statskeeperFiles};
  print qx{$BZIP2 -9 *tar};
}
elsif( $bookCode eq "base" ) {
  chdir( "$PATH_PREFIX" ) or die( "Cannot open Project Aon data directory \"$PATH_PREFIX\": $!" );
  chdir( "$WEBSITE_PATH/athome" ) or die( "Unable to change directory to \"$WEBSITE_PATH/athome\": $!\n" );
  print qx{$RM base.zip base.tar.bz2 base.tar};
  print qx{$ZIP -8 -q base.zip *ico *htm images/* style/*};
  print qx{$TAR cf base.tar *ico *htm images/* style/*};
  print qx{$BZIP2 -9 *tar};
}
else {
  print "Reminder:\n\tDid you comment out the LaTeX special character\n\tdeclarations in the book's XML file?\n";

  chdir( "$PATH_PREFIX" ) or die( "Cannot open Project Aon data directory \"$PATH_PREFIX\": $!" );
  system( "$RXP", "-Vs", "$XML_PATH/$XML_SOURCE" ) == 0 or die( "XML validation failed\n" );
  unless( -d "$BOOK_PATH" ) { mkdir $BOOK_PATH or die( "Unable to create directory \"$PATH_PREFIX/$BOOK_PATH\": $!\n" ); }
  print qx{$RM $BOOK_PATH/*};
  print qx{$JAVA org.apache.xalan.xslt.Process -IN $XML_PATH/$XML_SOURCE -XSL $XML_PATH/xhtml.xsl -OUT \"$BOOK_PATH/foo.xml\" -PARAM book-path \"$BOOK_PATH\" -PARAM text-color \"$TEXT_COLOR\" -PARAM link-color \"$LINK_COLOR\" -PARAM use-illustrators \"$USE_ILLUSTRATORS\"};
  print qx{$RM $BOOK_PATH/foo.xml};
  print qx{$CREATE_CSS $BOOK_PATH \"$TEXT_COLOR\" \"\#ffffe6\" \"$LINK_COLOR\" \"$LINK_COLOR\" \"$HLINK_BACK_COLOR\" \"$LINK_COLOR\"};

  print qx{$CP images/$BOOK_PATH/*gif images/$BOOK_PATH/*jpg $BOOK_PATH};
  print qx{$CHMOD 600 $BOOK_PATH/*};
  print qx{$TAR cf $bookCode.tar $BOOK_PATH/*};
  print qx{$ZIP -8 -q $bookCode.zip $BOOK_PATH/*};
  print qx{$BZIP2 -9 $bookCode.tar};
  print qx{$CHMOD 600 $bookCode.tar.bz2 $bookCode.zip};

  print qx{$MV $bookCode* $PATH_PREFIX/$BOOK_PATH/};
}
