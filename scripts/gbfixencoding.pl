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

  if( $modified =~ s{ ([[:space:]]) \& ([[:space:]]) }{$1\&ampersand;$2}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]+ - [[:space:]]+ }{\&emdash;}xg ) { $replacements = 1; }
  if( $modified =~ s{ (?<!\!) ([[:space:]])* -- ([[:space:]])* (?!>) }{$1\&emdash;$2}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]* \227 [[:space:]]* }{\&emdash;}xg ) { $replacements = 1; }
  if( $modified =~ s{ ([[:digit:]]) - ([[:digit:]]) }{$1\&endash;$2}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]* \227 [[:space:]]* }{\&endash;}xg ) { $replacements = 1; }
  if( $modified =~ s{ > [[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)? }{>\&lellips;}xg ) { $replacements = 1; }
  if( $modified =~ s{ [[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)? }{\&ellips;}xg ) { $replacements = 1; }
  if( $modified =~ s{ (</?quote>) \1 }{\&thinspace;}xg ) { $replacements = 1; }
  if( $modified =~ s{ <quote> \&apos; }{<quote>\&thinspace;\&apos;}xg ) { $replacements = 1; }
  if( $modified =~ s{ \&apos; </quote> }{\&apos;\&thinspace;</quote>}xg ) { $replacements = 1; }
  if( $modified =~ s{ __+ }{\&blankline;}xg ) { $replacements = 1; }
  if( $modified =~ s{\%}{\&percent;}xg ) { $replacements = 1; }

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
  $text =~ s{(\&ampersand;)}{$encodedStart$1$stop}g;
  $text =~ s{(\&emdash;)}{$encodedDashStart$1$stop}g;
  $text =~ s{ [[:space:]] (\&) [[:space:]] }{$dashStart$1$stop}xg;
  $text =~ s{ ([[:space:]]+ - [[:space:]]+) }{$dashStart$1$stop}xg;
  $text =~ s{ (?<!\!) ([[:space:]]* -- [[:space:]]*) }{$dashStart$1$stop}xg;
  $text =~ s{ ([[:space:]]* \227 [[:space:]]*) }{$dashStart$1$stop}xg;
  $text =~ s{(\&endash;)}{$encodedDashStart$1$stop}g;
  $text =~ s{ ([[:digit:]]) - ([[:digit:]]) }{$1$dashStart-$stop$2}xg;
  $text =~ s{ ([[:space:]]* \226 [[:space:]]*) }{$dashStart$1$stop}xg;
  $text =~ s{(\&lellips;)}{$encodedStart$1$stop}g;
  $text =~ s{ > ([[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)?) }{>$start$1$stop}xg;
  $text =~ s{(\&ellips;)}{$encodedStart$1$stop}g;
  $text =~ s{ ([[:space:]]* \. [[:space:]]* \. ([[:space:]]* \.)?) }{$start$1$stop}xg;
  $text =~ s{(\&thinspace;)}{$encodedStart$1$stop}g;
  $text =~ s{ (</?quote> \1) }{$start$1$stop}xg;
  $text =~ s{ (<quote> \&apos;) }{$start$1$stop}xg;
  $text =~ s{ (\&apos; </quote>) }{$start$1$stop}xg;
  $text =~ s{(\&blankline;)}{$encodedStart$1$stop}g;
  $text =~ s{ (__+) }{$start$1$stop}xg;
  $text =~ s{(\&percent;)}{$encodedStart$1$stop}g;
  $text =~ s{(\%)}{$start$1$stop}xg;

  return $text;
}
