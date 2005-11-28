#!/usr/bin/perl -w
#
# addcorr.pl
#
# addcorr.pl [inputCorrections HTMLfile(s)]
#
# Combines the operations of corrtohtml.pl, sortcorrhtml.pl, and
# mergecorrhtml.pl into one simple command line. Anything that needs
# to do anything more complex than this should use the three utilities
# separately.
#
# The book code will be obtained from the input HTML filename. E.g.
# 01fftd-changes.html provides the book code 01fftd. If for some reason
# the input HTML filename doesn't hold the book code in the first
# characters before the hyphen, use the three separate utilities.
#
# Anything that isn't specified on the command line will be prompted for.
#
# This program uses the most used pattern of using these three utilities.
#
# corrtohtml.pl -v -b bookCode inputCorrections
#   | sortcorrhtml.pl -v -s -b bookCode
#   | mergecorrhtml.pl inputHTML
#   > outputHTML
#
# This utility also has the side effect of creating a backup copy of
# the inputHTML file.
#
######################################################################
use strict;

my $programName = "addcorr";
my $usage = "$programName [inputCorrections HTMLfile(s)]\n";

unless( -d $ENV{AONPATH} ) { die "\$AONPATH environment variable doesn't point to a directory"; }

my $convert = $ENV{AONPATH} . "/bin/corrtohtml.pl";
die( "Cannot find executable file \"$convert\"" ) unless( -x $convert );
my $sort = $ENV{AONPATH} . "/bin/sortcorrhtml.pl";
die( "Cannot find executable file \"$sort\"" ) unless( -x $sort );
my $merge = $ENV{AONPATH} . "/bin/mergecorrhtml.pl"; 
die( "Cannot find executable file \"$merge\"" ) unless( -x $merge );
my $copy = "/bin/cp";
die( "Cannot find executable file \"$copy\"" ) unless( -x $copy );

my $optsProcessed = 0;
my $bookCode = "";
my $inCorr = "";
my $inHTML = "";
my $outHTML = "";
my $verbose = 0;

my %books = (
    '01fftd' => 1,
    '02fotw' => 1,
    '03tcok' => 1,
    '04tcod' => 1,
    '05sots' => 1,
    '06tkot' => 1,
    '07cd' => 1,
    '08tjoh' => 1,
    '09tcof' => 1,
    '10tdot' => 1,
    '11tpot' => 1,
    '12tmod' => 1,
    '13tplor' => 1,
    '14tcok' => 1,
    '15tdc' => 1,
    '16tlov' => 1,
    '17tdoi' => 1,
    '18dotd' => 1,
    '19wb' => 1,
    '20tcon' => 1,
    '21votm' => 1,
    '22tbos' => 1,
    '23mh' => 1,
    '24rw' => 1,
    '25totw' => 1,
    '26tfobm' => 1,
    '27v' => 1,
    '28thos' => 1,
    '01gstw' => 1,
    '02tfc' => 1,
    '03btng' => 1,
    '04wotw' => 1,
    '01hh' => 1,
    '02smr' => 1,
    '03toz' => 1,
    '04cc' => 1,
    'tmc' => 1,
    'rh' => 1
);

######################################################################

while( $#ARGV > -1 && not $optsProcessed ) {
  my $commandLineItem = shift @ARGV;
  if( $commandLineItem eq "--help" ) {
    print $usage and exit;
  }
  elsif( $commandLineItem eq "-v" ) {
    $verbose = 1;
  }
  else {
    unshift @ARGV, $commandLineItem;
    $optsProcessed = 1;
  }
}

if( $#ARGV > -1 ) {
    $inCorr = shift @ARGV or die "Couldn't get input corrections\n$usage";
    $inHTML = shift @ARGV or die "Couldn't get input HTML\n$usage";
}
else {
    while( $inCorr eq "" ) {
	print "Corrections File: ";
	$inCorr = <>;
	chomp( $inCorr );
    }
    while( $inHTML eq "" ) {
	print "Input HTML File: ";
	$inHTML = <>;
	chomp( $inHTML );
    }
}

while( $inHTML ne "" ) {
    die( "Cannot find corrections file \"$inCorr\"" ) unless( -f $inCorr );
    die( "Cannot read corrections file \"$inCorr\"" ) unless( -r $inCorr );
    die( "Cannot find HTML file \"$inHTML\"" ) unless( -f $inHTML );
    die( "Cannot read HTML file \"$inHTML\"" ) unless( -r $inHTML );
    die( "Cannot write to HTML file \"$inHTML\"" ) if( -f $inHTML && ! -w $inHTML );

    $bookCode = $inHTML;
    $bookCode =~ s{^([[:lower:][:digit:]]+)-.*$}{$1};
    die( "Unknown book code \"$bookCode\" (obtained from \"$inHTML\")" ) unless( exists $books{ $bookCode } );

    print "Bookcode: $bookCode\n" if( $verbose );
    # leave backup untouched while putting output in original filename
    print qx{$copy $inHTML $inHTML.backup};
    $outHTML = $inHTML;
    $inHTML = "$inHTML.backup";

    print qx{ $convert -v -b $bookCode $inCorr | $sort -v -s -b $bookCode | $merge $inHTML >$outHTML };

    $inHTML = "";
    $inHTML = shift @ARGV if( $#ARGV > -1 );
}
