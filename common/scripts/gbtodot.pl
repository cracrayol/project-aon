#!/usr/bin/perl -w
#
# gbtodot.pl

use strict;

delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)}; # clean house for taint mode

my $PROGRAM_NAME    = 'gbtodot';
my $USAGE           = "$PROGRAM_NAME [options] book-code\n\t--meta=[metadata file]\n\t--xml=[book XML]\n\t--xsl=[XSL transformation]\n\t--baseURI=[URI of linked XHTML book]\n\t--language=[language area of input data (output determined by meta file)]\n\t--verbose\n";

my $FILENAME_SEPARATOR = '/';

my $RXP        = '/usr/bin/rxp';
my $JAVA       = '/usr/bin/java';
my $XALAN_JAR  = '/usr/share/java/xalan2.jar';

###

my $bookCode     = '';
my $metaFile     = '';
my $bookXML      = '';
my $dotXSL       = 'common/xsl/dot.xsl';
my $language     = 'en';
my $baseURI      = '';

my $verbose = 0;

while( $#ARGV > -1 ) {
    my $cmdLineItem = shift @ARGV;
    if( $cmdLineItem =~ /^--meta=(.+)$/ ) {
	$metaFile = $1;
    }
    elsif( $cmdLineItem =~ /^--xml=(.+)$/ ) {
	$bookXML = $1;
    }
    elsif( $cmdLineItem =~ /^--xsl=(.+)$/ ) {
	$dotXSL = $1;
    }
    elsif( $cmdLineItem =~ /^--base-uri=(.+)$/ ) {
	$baseURI = $1;
    }
    elsif( $cmdLineItem =~ /^--language=(.+)$/ ) {
	$language = $1;
    }
    elsif( $cmdLineItem =~ /^--verbose/ ) {
	$verbose = 1;
    }
    else { 
	$bookCode = $cmdLineItem;
    }
}

if( $bookCode eq '' ) { die "Unspecified book code\n$USAGE"; }
if( $bookXML eq '' ) { $bookXML = "$language/xml/$bookCode.xml"; }
if( $metaFile eq '' ) { $metaFile = "$language/.publisher/rules/dever"; }

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

    unless( defined $rulesHash{'book-series'} ) { die "Metadata file leaves book series unspecified\n"; }
    unless( defined $rulesHash{'language'} ) { die "Metadata file leaves language unspecified\n"; }

    my $outPath = $rulesHash{'language'} . $FILENAME_SEPARATOR . 'dot' . $FILENAME_SEPARATOR . $rulesHash{'book-series'};
    unless( -e $outPath && -d $outPath ) {
	my @dirs = split ( /$FILENAME_SEPARATOR/, $outPath );
	my $dirPath = '';
	for( my $i = 0; $i <= $#dirs; ++$i ) {
	    $dirPath .= $dirs[$i] . $FILENAME_SEPARATOR;
	    if( -e $dirPath && ! -d $dirPath ) { die "Output directory name exists and is not a directory\n"; }
	    unless( -e $dirPath ) {
		mkdir $dirPath or die( "Unable to create output directory ($outPath): $!\n" );
	    }
	}
    }
    unless( -e $outPath && -d $outPath ) {
	die "Unknown error creating output directory\n";
    }

    $baseURI = "http://www.projectaon.org/$rulesHash{'language'}/xhtml/$rulesHash{'book-series'}/$bookCode/" if( $baseURI eq '' );
    print qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$dotXSL" -OUT "$outPath$FILENAME_SEPARATOR$bookCode.dot" -PARAM base-URI "$baseURI" -PARAM language "$rulesHash{'language'}"};
}

print "Success\n" if $verbose;
