#!/usr/bin/perl -w
#
# gbtoxhtml-less-simple.xsl
#
######################################################################

use strict;

delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)}; # clean house for taint mode

my $PROGRAM_NAME    = 'gbtoxhtml-less-simple.pl';
my $USAGE           = "$PROGRAM_NAME [options] book-code\n\t--xml=[book XML]\n\t--meta=[metadata file]\n\t--xsl=[XSL transformation]\n\t--language=[language area of input data (output determined by meta file)]\n\t--verbose\n";

my $FILENAME_SEPARATOR = '/';

my $CP         = '/bin/cp';
my $MV         = '/bin/mv';
my $RM         = '/bin/rm';
my $RXP        = '/usr/bin/rxp';
my $ZIP        = '/usr/bin/zip';
my $JAVA       = '/usr/bin/java';
my $XALAN_JAR  = '/usr/share/java/xalan2.jar';

###

my $bookCode     = '';
my $bookXML      = '';
my $metaFile     = '';
my $xhtmlXSL     = 'common/xsl/xhtml-less-simple.xsl';
my $language     = 'en';

my $verbose = 0;

while( $#ARGV > -1 ) {
    my $cmdLineItem = shift @ARGV;
    if( $cmdLineItem =~ /^--xml=(.+)$/ ) {
	$bookXML = $1;
    }
    elsif( $cmdLineItem =~ /^--meta=(.+)$/ ) {
	$metaFile = $1;
    }
    elsif( $cmdLineItem =~ /^--xsl=(.+)$/ ) {
	$xhtmlXSL = $1;
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
if( $metaFile eq '' ) { $metaFile = "$language/.publisher/rules/simple"; }
if( $bookXML eq '' ) { $bookXML = "$language/xml/$bookCode.xml"; }
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
	    system( $RXP, '-Vs', $bookXML ) == 0
            or die( "XML validation failed\n" );
    }
    unless( defined $rulesHash{'language'} ) {
        die "Metadata file leaves language unspecified\n";
    }
    unless( defined $rulesHash{'book-series'} ) {
        die "Metadata file leaves book series unspecified\n";
    }
    unless( defined $rulesHash{'images'} ) { 
        die "Metadata file leaves image directories unspecified\n";
    }

    my $outPath = $rulesHash{'language'} . $FILENAME_SEPARATOR .
                 'xhtml-less-simple' . $FILENAME_SEPARATOR .
                 $rulesHash{'book-series'} . $FILENAME_SEPARATOR .
                 $bookCode;
    unless( -e $outPath && -d $outPath ) {
	    my @dirs = split ( /$FILENAME_SEPARATOR/, $outPath );
    	my $dirPath = '';
	    for( my $i = 0; $i <= $#dirs; ++$i ) {
	        $dirPath .= $dirs[$i] . $FILENAME_SEPARATOR;
    	    if( -e $dirPath && ! -d $dirPath ) {
                die "Output directory name exists and is not a directory\n";
            }
	        unless( -e $dirPath ) {
		        mkdir $dirPath or die( "Unable to create output directory ($outPath): $!\n" );
	    }
	    }
    }
    unless( -e $outPath && -d $outPath ) {
	    die "Unknown error creating output directory\n";
    }

    my $bookPath = "$outPath${FILENAME_SEPARATOR}";

    print qx{$RM ${bookPath}*} if -e $bookPath."/title.htm";
    print qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "${bookXML}" -XSL "${xhtmlXSL}" -OUT "${bookPath}title.htm" -PARAM use-illustrators "$rulesHash{'use-illustrators'}"};

    foreach my $imagePath (split( /:/, $rulesHash{'images'} )) {
        unless( -e $imagePath && -d $imagePath ) {
	        die "Image path ($imagePath) does not exist or is not a directory\n";
	    }
        print qx{$CP $imagePath${FILENAME_SEPARATOR}* $bookPath};
    }

    print qx{$ZIP -8 -q ${bookCode}.zip ${bookPath}*};
    print qx{$MV ${bookCode}* $bookPath};
}

print "Success\n" if $verbose;
