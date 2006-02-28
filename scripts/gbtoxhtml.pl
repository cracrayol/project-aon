#!/usr/bin/perl -w
#
# gbtoxhtml.pl
#
# Creates XHTML gamebook from XML source.
#
# $Id$
#
# $Log$
# Revision 2.0  2006/02/28 23:50:54  jonathan.blake
# Extensive overhaul and changed command line interface
#
# Revision 1.2  2005/10/13 00:48:47  angantyr
# Put Paul Bonner as illustrator of the GS books.
#
# Revision 1.1.1.1  2005/04/26 04:47:33  jonathan.blake
# Imported scripts
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
# ///// To Do
# * make the transformation more generic by using an xslt-params rule
# 
#####

use strict;

delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)}; # clean house for taint mode

my $PROGRAM_NAME    = 'gbtoxhtml';
my $USAGE           = "$PROGRAM_NAME [options]\n\t--book=[book code]\n\t--meta=[metadata file]\n\t--xml=[book XML]\n\t--xsl=[XSL transformation]\n";

my $FILENAME_SEPARATOR = '/';

my $RXP        = '/home/projectaon/bin/rxp';
my $CP         = '/bin/cp';
my $MV         = '/bin/mv';
my $TAR        = '/bin/tar';
my $ZIP        = '/usr/bin/zip';
my $BZIP2      = '/usr/bin/bzip2';
my $JAVA       = '/usr/bin/java';
my $XALAN_JAR  = '/home/projectaon/bin/xalan.jar';
my $RM         = '/bin/rm';
my $CHMOD      = '/bin/chmod';

###

my $bookCode     = '';
my $metaFile     = '';
my $bookXML      = '';
my $xhtmlXSL     = '';

my $verbose = 0;

while( $#ARGV > -1 ) {
    my $cmdLineItem = shift @ARGV;
    if( $cmdLineItem =~ /^--book=(.+)$/ ) {
	$bookCode = $1;
    }
    elsif( $cmdLineItem =~ /^--meta=(.+)$/ ) {
	$metaFile = $1;
    }
    elsif( $cmdLineItem =~ /^--xml=(.+)$/ ) {
	$bookXML = $1;
    }
    elsif( $cmdLineItem =~ /^--xsl=(.+)$/ ) {
	$xhtmlXSL = $1;
    }
    elsif( $cmdLineItem =~ /^--verbose/ ) {
	$verbose = 1;
    }
    else { die $USAGE; }
}

if( $bookCode eq '' ) { die "Unspecified book code\n$USAGE"; }
if( $metaFile eq '' ) { die "Unspecified metadata file\n$USAGE"; }
if( $bookXML eq '' ) { die "Unspecified book XML file\n$USAGE"; }
if( $xhtmlXSL eq '' ) { die "Unspecified XSL transformation file\n$USAGE"; }

if( -e $metaFile && -f $metaFile && -r $metaFile ) {
    open( META, '<', $metaFile ) or die qq{Unable to open metadata file ($metaFile): $!\n};
}
else { die qq{Improper metadata file ($metaFile)\n}; }

my $meta = '';
while( my $line = <META> ) {
    $meta .= $line if $line !~ /^[[:space:]]*#/;
}
close META;

my $rulesString = '';
if( $meta =~ /^[[:space:]]*$bookCode[[:space:]]*{([^}]*)}/sm ) {
    $rulesString = $1;
}
else {
    die "Book code ($bookCode) not found in metadata file or invalid file syntax\n";
}

my @rules = split( /[[:space:]\n]*;[[:space:]\n]*/, $rulesString );
my %rulesHash;
foreach my $rule (@rules) {
    if( $rule =~ /[[:space:]]*([^:]+)[[:space:]]*:[[:space:]]*(.+)$/s ) {
	$rulesHash{ $1 } = $2;
    }
    else {
	die "Unrecognized rule syntax:\n$rule\n";
    }
}

if( $bookXML =~ m{^([-\w\@./]+)$} ) {
    $bookXML = $1;
    if( -e $bookXML && -f $bookXML && -r $bookXML ) {
	system( $RXP, '-Vs', $bookXML ) == 0 or die( "XML validation failed\n" );
    }
    unless( defined $rulesHash{'book-path'} ) { die "Metadata file leaves output path unspecified\n"; }
    unless( -e $rulesHash{'book-path'} && -d $rulesHash{'book-path'} ) {
	my @dirs = split ( /$FILENAME_SEPARATOR/, $rulesHash{'book-path'} );
	my $dirPath = '';
	for( my $i = 0; $i <= $#dirs; ++$i ) {
	    $dirPath .= $dirs[$i] . $FILENAME_SEPARATOR;
	    if( -e $dirPath && ! -d $dirPath ) { die "Output directory name exists and is not a directory\n"; }
	    unless( -e $dirPath ) {
		mkdir $dirPath or die( "Unable to create output directory ($rulesHash{'book-path'}): $!\n" );
	    }
	}
    }
    unless( -e $rulesHash{'book-path'} && -d $rulesHash{'book-path'} ) {
	die "Unknown error creating output directory\n";
    }

    print qx{$RM $rulesHash{'book-path'}$FILENAME_SEPARATOR*};
    print qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$xhtmlXSL" -OUT "$rulesHash{'book-path'}${FILENAME_SEPARATOR}foo.xml" -PARAM background-color "$rulesHash{'background-color'}" -PARAM text-color "$rulesHash{'text-color'}" -PARAM link-color "$rulesHash{'link-color'}" -PARAM use-illustrators "$rulesHash{'use-illustrators'}"};
    print qx{$RM $rulesHash{'book-path'}${FILENAME_SEPARATOR}foo.xml};

    foreach my $cssTemplate (split( /:/, $rulesHash{'csst'} )) {
	$cssTemplate =~ m/([^${FILENAME_SEPARATOR}]+)t$/;
	my $templateFilename = $1;
	open( TEMPLATE, '<', $cssTemplate ) or die "Unable to open CSS template file ($cssTemplate): $!\n";
	open( STYLESHEET, '>', "$rulesHash{'book-path'}${FILENAME_SEPARATOR}${templateFilename}" ) or die "Unable to open stylesheet file ($rulesHash{'book-path'}${FILENAME_SEPARATOR}${templateFilename}) for writing: $!\n";
        while( my $templateLine = <TEMPLATE> ) {
            while( $templateLine =~ /%%([^%[:space:]]+)%%/ ) {
		my $name = $1;
	        $templateLine =~ s/%%${name}%%/$rulesHash{$name}/g;
            }
            print STYLESHEET $templateLine;
        }
    }
    close TEMPLATE;
    close STYLESHEET;

    foreach my $imagePath (split( /:/, $rulesHash{'images'} )) {
        unless( -e $imagePath && -d $imagePath ) {
	    die "Image path ($imagePath) does not exist or is not a directory\n";
	}
        print qx{$CP $imagePath${FILENAME_SEPARATOR}* $rulesHash{'book-path'}};
    }

    print qx{$TAR cf ${bookCode}.tar $rulesHash{'book-path'}${FILENAME_SEPARATOR}*};
    print qx{$ZIP -8 -q ${bookCode}.zip $rulesHash{'book-path'}${FILENAME_SEPARATOR}*};
    print qx{$BZIP2 -9 ${bookCode}.tar};
    print qx{$MV ${bookCode}* $rulesHash{'book-path'}${FILENAME_SEPARATOR}};
}

print "Success\n" if $verbose;
