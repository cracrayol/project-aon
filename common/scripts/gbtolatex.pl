#!/bin/perl -w
#
# gbtolatex.pl
# 19 september 2007
#
# Creates LaTeX gamebook from XML source. This should subsequently be
# used to create a PDF or PostScript version.
#####

use strict;

# Check AONPATH
if ( ! defined($ENV{'AONPATH'}) && ! defined ($ENV{'AONDATA'}) ) {
	print STDERR "AONPATH environment variable not set, it should be defined to\n";
	print STDERR "the root directory of the repository of the AON files are.\n";
	exit 1;
}
##

my $PROGRAM_NAME      = "gbtolatex";
my $XML_PATH          = "xml";
my $XML_SOURCE        = "";
my $PWD               = `pwd`;
chomp($PWD);
my $BOOK_PATH         = $ENV{'AONPATH'}."/common/pdf/build";
my $TITLE_COLOR       = "";
my $USE_ILLUSTRATORS  = "";

# Programs
#
# my $XMLPROC = "xalan";
# my $XMLPROC = "/usr/local/bin/xmlto";
my $XMLPROC = "/usr/bin/xsltproc";
# my $JAVA = "/cygdrive/c/WINDOWS/java.exe";
my $JAVA = "/usr/bin/java"; 
my $EXTRAPARMS =""; 
$EXTRAPARMS=$ENV{'XMLPARMS'} if defined($ENV{'XMLPARMS'});


unless( $ARGV[ 0 ] ) { die "Usage:\n\t${PROGRAM_NAME} book-code [LANGUAGE] [OUTPUTFILE]\n"; }

# Check that all the binaries are were want them

my @BINARIES;
push @BINARIES, ($XMLPROC, $JAVA);

foreach (@BINARIES) {
    if ( ! -e $_ ) {
            die "$PROGRAM_NAME: Cannot find binary '".$_."'. Please install it.\n";
    }
}


print "Reminder:\n\tDid you uncomment the LaTeX special character\n\tdeclarations in the book's XML file?\n";

my $bookCode = $ARGV[ 0 ];
my $language = $ARGV[ 1 ] || "en"; # Use a language or default to 'en'

my $DATADIR = "";
if ( defined ($ENV{'AONDATA'} ) ) {
	$DATADIR=$ENV{'AONDATA'} ; 
} else { 
	$DATADIR= $ENV{'AONPATH'}."/".$language."/xml";
}
if ( ! -d "$DATADIR" ) {
	print STDERR "Cannot find data directory $DATADIR !\n";
	exit 1;
}
# Data dir, where XSL files reside
# Note: This has to be set to the XML file location and not the XSL location
# because of the .inc and the .mod files
# We link the file later on to use it

my $XSLDIR = $ENV{'AONPATH'}."/common/xsl";
if ( ! -d "$XSLDIR" ) {
	print STDERR "Cannot find XSL directory: $XSLDIR !\n";
	exit 1;
}

# TODO:
# - convert the bookcode's if then else to a hash array
# - allow usage of unknown book codes

if( $bookCode eq "01fftd" ) {
    $XML_SOURCE        = "01fftd.xml";
    $BOOK_PATH         .= "/lw/01fftd";
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "01hdlo" ) {
    $XML_SOURCE        = "01hdlo.xml";
    $BOOK_PATH         .= "/lw/01hdlo";
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02fotw" ) {
    $XML_SOURCE        = "02fotw.xml";
    $BOOK_PATH         .= "/lw/02fotw";
    $TITLE_COLOR       = "0.0,0.6,0.6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02fsea" ) {
    $XML_SOURCE        = "02fsea.xml";
    $BOOK_PATH         .= "/lw/02fsea";
    $TITLE_COLOR       = "0.0,0.6,0.6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03tcok" ) {
    $XML_SOURCE        = "03tcok.xml";
    $BOOK_PATH         .= "/lw/03tcok";
    $TITLE_COLOR       = "0.0,0.6,0.8";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03lcdk" ) {
    $XML_SOURCE        = "03lcdk.xml";
    $BOOK_PATH         .= "/lw/03lcdk";
    $TITLE_COLOR       = "0.0,0.6,0.8";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04tcod" ) {
    $XML_SOURCE        = "04tcod.xml";
    $BOOK_PATH         .= "/lw/04tcod";
    $TITLE_COLOR       = "0.0,0.0,0.6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04eam" ) {
    $XML_SOURCE        = "04eam.xml";
    $BOOK_PATH         .= "/lw/04eam";
    $TITLE_COLOR       = "0.0,0.0,0.6";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "05sots" ) {
    $XML_SOURCE        = "05sots.xml";
    $BOOK_PATH         .= "/lw/05sots";
    $TITLE_COLOR       = "0.8,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "05eddls" ) {
    $XML_SOURCE        = "05eddls.xml";
    $BOOK_PATH         .= "/lw/05eddls";
    $TITLE_COLOR       = "0.8,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "06tkot" ) {
    $XML_SOURCE        = "06tkot.xml";
    $BOOK_PATH         .= "/lw/06tkot";
    $TITLE_COLOR       = "0.6,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "06lpdlc" ) {
    $XML_SOURCE        = "06lpdlc.xml";
    $BOOK_PATH         .= "/lw/06lpdlc";
    $TITLE_COLOR       = "0.6,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "07cd" ) {
    $XML_SOURCE        = "07cd.xml";
    $BOOK_PATH         .= "/lw/07cd";
    $TITLE_COLOR       = "0.0,0.8,0.4";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "07meec" ) {
    $XML_SOURCE        = "07meec.xml";
    $BOOK_PATH         .= "/lw/07meec";
    $TITLE_COLOR       = "0.6,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "08tjoh" ) {
    $XML_SOURCE        = "08tjoh.xml";
    $BOOK_PATH         .= "/lw/08tjoh";
    $TITLE_COLOR       = "0.4,0.6,0.4";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "08ljdlh" ) {
    $XML_SOURCE        = "08ljdlh.xml";
    $BOOK_PATH         .= "/lw/08ljdlh";
    $TITLE_COLOR       = "0.4,0.6,0.4";
    $USE_ILLUSTRATORS  = ":Gary Chalk:JC Alvarez & Jonathan Blake:Jonathan Blake:Daniel Strong:";
}
elsif( $bookCode eq "09tcof" ) {
    $XML_SOURCE        = "09tcof.xml";
    $BOOK_PATH         .= "/lw/09tcof";
    $TITLE_COLOR       = "1.0,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "09ecdm" ) {
    $XML_SOURCE        = "09ecdm.xml";
    $BOOK_PATH         .= "/lw/09ecdm";
    $TITLE_COLOR       = "1.0,0.6,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:Daniel Strong:";
}
elsif( $bookCode eq "10tdot" ) {
    $XML_SOURCE        = "10tdot.xml";
    $BOOK_PATH         .= "/lw/10tdot";
    $TITLE_COLOR       = "1.0,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "10lmdt" ) {
    $XML_SOURCE        = "10lmdt.xml";
    $BOOK_PATH         .= "/lw/10lmdt";
    $TITLE_COLOR       = "1.0,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:Daniel Strong:";
}
elsif( $bookCode eq "11tpot" ) {
    $XML_SOURCE        = "11tpot.xml";
    $BOOK_PATH         .= "/lw/11tpot";
    $TITLE_COLOR       = "0.5,0.5,0.4";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "11pdt" ) {
    $XML_SOURCE        = "11pdt.xml";
    $BOOK_PATH         .= "/lw/11pdt";
    $TITLE_COLOR       = "0.5,0.5,0.4";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:Daniel Strong:";
}
elsif( $bookCode eq "12tmod" ) {
    $XML_SOURCE        = "12tmod.xml";
    $BOOK_PATH         .= "/lw/12tmod";
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "12lsdlo" ) {
    $XML_SOURCE        = "12lsdlo.xml";
    $BOOK_PATH         .= "/lw/12lsdlo";
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:Daniel Strong:";
}
elsif( $bookCode eq "13tplor" ) {
    $XML_SOURCE        = "13tplor.xml";
    $BOOK_PATH         .= "/lw/13tplor";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "13lsdlpdr" ) {
    $XML_SOURCE        = "13lsdlpdr.xml";
    $BOOK_PATH         .= "/lw/13lsdlpdr";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "14tcok" ) {
    $XML_SOURCE        = "14tcok.xml";
    $BOOK_PATH         .= "/lw/14tcok";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "15tdc" ) {
    $XML_SOURCE        = "15tdc.xml";
    $BOOK_PATH         .= "/lw/15tdc";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "16tlov" ) {
    $XML_SOURCE        = "16tlov.xml";
    $BOOK_PATH         .= "/lw/16tlov";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "17tdoi" ) {
    $XML_SOURCE        = "17tdoi.xml";
    $BOOK_PATH         .= "/lw/17tdoi";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "18dotd" ) {
    $XML_SOURCE        = "18dotd.xml";
    $BOOK_PATH         .= "/lw/18dotd";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "19wb" ) {
    $XML_SOURCE        = "19wb.xml";
    $BOOK_PATH         .= "/lw/19wb";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0"; 
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "20tcon" ) {
    $XML_SOURCE        = "20tcon.xml";
    $BOOK_PATH         .= "/lw/20tcon";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "21votm" ) {
    $XML_SOURCE        = "21votm.xml";
    $BOOK_PATH         .= "/lw/21votm";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Trevor Newton:Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "22tbos" ) {
    $XML_SOURCE        = "22tbos.xml";
    $BOOK_PATH         .= "/lw/22tbos";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "23mh" ) {
    $XML_SOURCE        = "23mh.xml";
    $BOOK_PATH         .= "/lw/23mh";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "24rw" ) {
    $XML_SOURCE        = "24rw.xml";
    $BOOK_PATH         .= "/lw/24rw";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "25totw" ) {
    $XML_SOURCE        = "25totw.xml";
    $BOOK_PATH         .= "/lw/25totw";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "26tfobm" ) {
    $XML_SOURCE        = "26tfobm.xml";
    $BOOK_PATH         .= "/lw/26tfobm";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "27v" ) {
    $XML_SOURCE        = "27v.xml";
    $BOOK_PATH         .= "/lw/27v";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "28thos" ) {
    $XML_SOURCE        = "28thos.xml";
    $BOOK_PATH         .= "/lw/28thos";
    # TODO - review
    $TITLE_COLOR       = "0.6,0.0,0.0";
    $USE_ILLUSTRATORS  = ":Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
# TODO - fix title color for Grey Star books
elsif( $bookCode eq "01gstw" ) {
    $XML_SOURCE        = "01gstw.xml";
    $BOOK_PATH         .= "/gs/01gstw";
    # TODO - review
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Paul Bonner:Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "02tfc" ) {
    $XML_SOURCE        = "02tfc.xml";
    $BOOK_PATH         .= "/gs/02tfc";
    # TODO - review
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Paul Bonner:Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "03btng" ) {
    $XML_SOURCE        = "03btng.xml";
    $BOOK_PATH         .= "/gs/03btng";
    # TODO - review
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Paul Bonner:Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
elsif( $bookCode eq "04wotw" ) {
    $XML_SOURCE        = "04wotw.xml";
    $BOOK_PATH         .= "/gs/04wotw";
    # TODO - review
    $TITLE_COLOR       = "0.0,0.4,0.2";
    $USE_ILLUSTRATORS  = ":Paul Bonner:Brian Williams:JC Alvarez & Jonathan Blake:Jonathan Blake:";
}
else{ die "Error:\n\tUknown book code.\n"; }


#chdir( "$DATADIR" ) or die( "Cannot open Project Aon data directory \"$DATADIR\": $!" );


# Check that the XML file is there
if ( ! -r $DATADIR."/".$XML_SOURCE ) {
    die "Could not find source file $XML_SOURCE in $DATADIR!";
}
if ( ! -e $DATADIR."/latex.xsl" ) {
    if ( ! -r $XSLDIR."/latex.xsl" ) {
        die "Could not find LaTeX stylesheet (latex.xsl) in $XSLDIR!";
    }
    # Link, if it does not exist the XSL file to the DATADIR
    if ( ! link $XSLDIR."/latex.xsl", $DATADIR."/latex.xsl" ) {
     die "Could not link the LaTeX stylesheet (latex.xsl) from $XSLDIR to $DATADIR!";
    }
}
if ( ! -e $DATADIR."/latex.xsl" ) {
        die "Could not find LaTeX stylesheet (latex.xsl) in $DATADIR!";
}
$XSLDIR = $DATADIR;


# Create the output directory if it does not exist already
print "Checking directory $BOOK_PATH...";
if ( ! -d "$BOOK_PATH/" ) {
    print "...directory does not exist.\n";
    print "Creating $BOOK_PATH ...";
    mkdir "$BOOK_PATH" || die "Could not create output directory $BOOK_PATH: $!";
}
print "..done.\n";

my $OUTPUTFILE = $ARGV[ 2 ] || "$BOOK_PATH/$bookCode.tex";

if ( -e $OUTPUTFILE ) {
    print "WARN: Outputfile $OUTPUTFILE already exists, will overwrite\n";
}

# Run the XML preprocessor
# TODO: use system() properly here and check return value
print "Processing book $bookCode and storing result in $OUTPUTFILE...\n";

my $command="";
# For Xmlto, which uses xsltproc:
# (Does not work)
# `$XMLPROC -v -o $BOOK_PATH -x ${XSLDIR}/latex.xsl dvi ${DATADIR}/${XML_SOURCE}`;
if ( $XMLPROC =~ /xalan/ ) {
    # Apache's Xalan:
    $command="$XMLPROC -in  ${DATADIR}/${XML_SOURCE} -xsl ${XSLDIR}/latex.xsl -out $OUTPUTFILE -param title-color \"\'$TITLE_COLOR\'\" -param use-illustrators \"\'$USE_ILLUSTRATORS\'\" -param language \"\'$language\'\" $EXTRAPARMS";
}
elsif ( $XMLPROC =~ /xsltproc/ ) {
    # xsltproc:
    $command="$XMLPROC --output $OUTPUTFILE --param title-color \"\'$TITLE_COLOR\'\" --param use-illustrators \"\'$USE_ILLUSTRATORS\'\" --param language \"\'$language\'\" $EXTRAPARMS ${XSLDIR}/latex.xsl ${DATADIR}/${XML_SOURCE}";
}
else {
    die "Error: Unsupported XSLT processor '$XMLPROC'.";
}
#print "Executing $command";
print qx{$command};
# Apache Xalan, Java version:
# print qx{$JAVA org.apache.xalan.xslt.Process -IN $XML_PATH/$XML_SOURCE -XSL $XML_PATH/latex.xsl -OUT $OUTPUTFILE -PARAM title-color \"$TITLE_COLOR\" -PARAM use-illustrators \"$USE_ILLUSTRATORS\"};
#
print "...done\n";


# End of script
exit 0;
