#!/usr/bin/perl -Tw
#
# Uses ANSI color escapes to highlight text and for cursor movement
#

use strict;

my $usage = "Usage:\n\tgbfixquotes.pl INFILE OUTFILE\n";

my $lineNumber = 1;

my ($infile, $outfile);

if( $#ARGV == 1 ) {
  $infile = shift @ARGV;
  $outfile = shift @ARGV;
}
else {
  die $usage;
}

if( $infile =~ m{(^.*$)} && -f $1 ) {
  open( INFILE, "<$1" ) or die "Error: unable to read from \"$infile\": $!\n";
}
else {
  die "Error: bad input file\n";
}

if( $outfile =~ m{(^.*$)} ) {
  open( OUTFILE, ">$1" ) or die "Error: unable to write to \"$outfile\": $!\n";
}
else {
  die "Error: bad output file\n";
}

while( my $line = <INFILE> ) {
  $line = &encodify( $line );

  print OUTFILE $line;
  ++$lineNumber;
}

close OUTFILE;
close INFILE;

################################################################################

sub encodify {
  my ($line) = @_;
  my $modified = $line;
  my $replacements = 0;

  if( $modified =~ s{ ([[:space:]]) \& ([[:space:]]) }{$1<ch.ampersand/>$2}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]+ - [[:space:]]+ }{<ch.emdash/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ (?<!\!) ([[:space:]])* -- ([[:space:]])* (?!>) }{$1<ch.emdash/>$2}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]* \227 [[:space:]]* }{<ch.emdash/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ ([[:digit:]]) - ([[:digit:]]) }{$1<ch.endash/>$2}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]* \227 [[:space:]]* }{<ch.endash/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ > [[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)? }{><ch.lellips/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)? }{<ch.ellips/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ (</?quote>) \1 }{<ch.thinspace/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ <quote> \&apos; }{<quote><ch.thinspace/><ch.apos/>}xg ) { $replacements = 1; }
  if( $modified =~ s{ \&apos; </quote> }{<ch.apos/><ch.thinspace/></quote>}xg ) { $replacements = 1; }
  if( $modified =~ s{ __+ }{<ch.blankline/>}xg ) { $replacements = 1; }
  if( $modified =~ s{\%}{<ch.percent/>}xg ) { $replacements = 1; }

  if( $replacements ) {
    print "\033[2J";
    print &highlight( $line ) . "\n";
    print &highlight( $modified );
    print "\033[7m    (a)ccept, (r)eject, (q)uit: [accept]\033[0m >> ";

    my $response = <STDIN>;
    chomp $response;
    if( $response =~ m/^[aA]$/ || $response eq "" ) { $line = $modified; }
    elsif( $response =~ m/^[qQ]$/ ) {
      print OUTFILE $line;
      while( $line = <INFILE> ) {
        print OUTFILE $line;
      }
      exit( 0 );
    }
    return $line;
  }
  else { return $line; }
}

sub highlight {
  my ($text) = @_;

  my $start = "\033[45;30m";
  my $encodedStart = "\033[40;35m";
  my $dashStart = "\033[46;30m";
  my $encodedDashStart = "\033[40;36m";
  my $stop  = "\033[0m";

  $text =~ s{^[[:space:]]+}{}g;
  $text =~ s{ ([[:space:]]) \& ([[:space:]]) }{$1$start\&$stop$2}xg;
  $text =~ s{(<ch.ampersand/>)}{$encodedStart$1$stop}g;
  $text =~ s{(<ch.emdash/>)}{$encodedDashStart$1$stop}g;
  $text =~ s{ [[:space:]] (\&) [[:space:]] }{$dashStart$1$stop}xg;
  $text =~ s{ ([[:space:]]+ - [[:space:]]+) }{$dashStart$1$stop}xg;
  $text =~ s{ (?<!\!) ([[:space:]]* -- [[:space:]]*) }{$dashStart$1$stop}xg;
  $text =~ s{ ([[:space:]]* \227 [[:space:]]*) }{$dashStart$1$stop}xg;
  $text =~ s{(<ch.endash/>)}{$encodedDashStart$1$stop}g;
  $text =~ s{ ([[:digit:]]) - ([[:digit:]]) }{$1$dashStart-$stop$2}xg;
  $text =~ s{ ([[:space:]]* \226 [[:space:]]*) }{$dashStart$1$stop}xg;
  $text =~ s{(<ch.lellips/>)}{$encodedStart$1$stop}g;
  $text =~ s{ > ([[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)?) }{>$start$1$stop}xg;
  $text =~ s{(<ch.ellips/>)}{$encodedStart$1$stop}g;
  $text =~ s{ ([[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)?) }{$start$1$stop}xg;
  $text =~ s{(<ch.thinspace/>)}{$encodedStart$1$stop}g;
  $text =~ s{ (</?quote> \1) }{$start$1$stop}xg;
  $text =~ s{ (<quote> <ch.apos/>) }{$start$1$stop}xg;
  $text =~ s{ (<ch.apos/> </quote>) }{$start$1$stop}xg;
  $text =~ s{(<ch.blankline/>)}{$encodedStart$1$stop}g;
  $text =~ s{ (__+) }{$start$1$stop}xg;
  $text =~ s{(<ch.percent/>)}{$encodedStart$1$stop}g;
  $text =~ s{(\%)}{$start$1$stop}xg;

  return $text;
}
