#!/usr/bin/env perl
#
# gbtopot.pl
#
# Script to convert Gamebook XML files to POT files for translation using gettext
#
# 

use strict;
use warnings;

delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)}; # clean house for taint mode

my $PROGRAM_NAME    = 'gbtopot';
my $USAGE           = "$PROGRAM_NAME [options] book-code\n\t--language=[language area of input data (output determined by meta file)]\n\t--verbose\n";

my $FILENAME_SEPARATOR = '/';

# Programs used by the tool
my $RXP        = '/usr/bin/rxp';
my $ITSTOOL    = '/usr/bin/itstool';

# Check that all the binaries are were want them

my @BINARIES;
push @BINARIES, ($RXP, $ITSTOOL);

foreach (@BINARIES) {
    if ( ! -e $_ ) {
            die "$PROGRAM_NAME: Cannot find binary '".$_."'. Please install it.\n";
    }
}


###

my $bookCode     = '';
my $metaFile     = '';
my $bookXML      = '';
my $language     = 'en';
my $itsfile       = 'common/gettext/gamebook.its';

my $verbose = 0;

while( $#ARGV > -1 ) {
    my $cmdLineItem = shift @ARGV;
    if( $cmdLineItem =~ /^--meta=(.+)$/ ) {
        $metaFile = $1;
    }
    elsif( $cmdLineItem =~ /^--xml=(.+)$/ ) {
        $bookXML = $1;
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
    open( META, '<', $metaFile ) 
        or die qq{Unable to open metadata file ($metaFile): $!\n};
}
else { 
    die qq{Improper metadata file ($metaFile)\n}; 
}

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
    print "Validating $bookXML' with $bookXML..." if $verbose;
    if( -e $bookXML && -f $bookXML && -r $bookXML ) {
        system( $RXP, '-Vs', $bookXML ) == 0 
            or die( "XML validation failed\n" );
    }
    print "succesful\n" if $verbose;

    unless( defined $rulesHash{'book-series'} ) { 
        die "Metadata file leaves book series unspecified\n";
    }
    unless( defined $rulesHash{'language'} ) { 
        die "Metadata file leaves language unspecified\n";
    }

    my $outPath = $rulesHash{'language'} . $FILENAME_SEPARATOR . 'pot' . $FILENAME_SEPARATOR . $rulesHash{'book-series'};
    &make_path( $outPath );
    unless( -e $outPath && -d $outPath ) {
	    die "Unknown error creating output directory\n";
    }

    my $potFile = "$outPath$FILENAME_SEPARATOR$bookCode.pot";
    print "Running $ITSTOOL with rules file '$itsfile' to convert '$bookXML' to '$potFile'" if $verbose;
    print qx{$ITSTOOL -i $itsfile -o "$potFile" "$bookXML"};
    print "succesful\n" if $verbose;

}

print "Success\n" if $verbose;

exit 0;

###

sub make_path {
    my ( $path ) = ( @_ );

	my @dirs = split ( /$FILENAME_SEPARATOR/, $path );
	my $dirPath = '';
	for( my $i = 0; $i <= $#dirs; ++$i ) {
	    $dirPath .= $dirs[$i] . $FILENAME_SEPARATOR;
	    if( -e $dirPath && ! -d $dirPath ) { 
            die "Output directory name exists and is not a directory\n";
        }
	    unless( -e $dirPath ) {
            mkdir $dirPath 
                or die( "Unable to create output directory ($path): $!\n" );
	    }
	}
}
