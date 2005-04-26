#!/usr/bin/perl -Tw
#
# Uses ANSI color escapes to highlight text and for cursor movement
#

use strict;

my $usage = "Usage:\n  gbfixquotes.pl [options] INFILE OUTFILE\n\t-f      \tforce attempted fixes in malformed places\n\t-s LINES\tskip lines\n";

my $lineNumber = 1;
my $skipLines = 1;

my $tags = qr{(p)|(choice)};
my $quoteMarks = qr{['`\221-\224]};
my $notQuoteMarks = qr{[^'`\221-\224]};
my $terminalPunctuation = qr{[.?!,]};
my $notTerminalPunctuation = qr{[^.?!,]};

my $spellNames = qr{(lightning[[:space:]]+hand)|(splinter)|(flameshaft)|(halt[[:space:]]+missile)|(strength)|(penetrate)|(energy[[:space:]]+grasp)|(slow[[:space:]]+fall)|(breathe[[:space:]]+water)|(power[[:space:]]+glyph)|(hold[[:space:]]+enemy)|(teleport)|(see[[:space:]]+illusion)|(mind[[:space:]]+charm)|(net)|(counterspell)|(sense[[:space:]]+evil)|(invisible[[:space:]]+fist)|(levitation)}i;

my ($infile, $outfile);

my $optsProcessed = 0;
my $forced = 0;

while( $#ARGV > -1 && not $optsProcessed ) {
  my $commandLineItem = shift @ARGV;
  if( $commandLineItem eq "-f" ) {
    $forced = 1;
  }
  elsif( $commandLineItem eq "-s" ) {
    $skipLines = shift @ARGV or die $usage;
  }
  else {
    unshift @ARGV, $commandLineItem;
    $optsProcessed = 1;
  }
}

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
  if( $skipLines > $lineNumber ) { }
  elsif( $line =~ m{<($tags)[[:space:]>]} ) {
    my $tagName = $1;
    unless( $line =~ m{</$tagName>} ) {
      printWarning( "Warning ($lineNumber): <$tagName> found without </$tagName>, skipping tests for current line\n", $line );
    }
    elsif( $line =~ m{${quoteMarks}} ) {
      $line = &quotify( $line );
    }
  }
  elsif( $forced && $line =~ m{${quoteMarks}} ) {
      $line = &quotify( $line );
  }
  elsif( $line =~ m{</($tags)>} ) {
    printWarning( "Warning ($lineNumber): </$1> found without <$1>\n", $line );
  }
  elsif( $line =~ m{($quoteMarks)}x ) {
    printWarning( "Warning ($lineNumber): unescaped quotation character \"$1\" found outside tested context\n", $line );
  }

  print OUTFILE $line;
  ++$lineNumber;
}

close OUTFILE;
close INFILE;

################################################################################

sub quotify {
  my ($line) = @_;
  my $modified = $line;
  $modified =~ s{
                 $quoteMarks
                 ($spellNames)
                 $quoteMarks
                }
                {<spell>$1</spell>}xg;
  $modified =~ s{
                 ([[:space:]])
                 $quoteMarks
                 ([[:alpha:]]+)
                 $quoteMarks
                 ([[:space:]])
                }
                {$1<quote>$2</quote>$3}xg;
  $modified =~ s{
                 ([[:alpha:]][[:space:]]*)
                 $quoteMarks
                 ([[:space:]]*[[:alpha:]])
                }
                {$1\&apos;$2}xg;
  $modified =~ s{
                 ${quoteMarks}
                 (${notTerminalPunctuation}+?
                 ${terminalPunctuation})
                 ${quoteMarks}
                }
                {<quote>$1</quote>}xg;
  $modified =~ s{
                 ${quoteMarks}
                 (${notQuoteMarks}+?)
                 ${quoteMarks}
                }
                {<quote>$1</quote>}xg;
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

sub highlight {
  my ($text) = @_;

  $text =~ s{^[[:space:]]+}{};
  $text =~ s{(<quote>)}{\033[1;36m$1\033[0m}g;
  $text =~ s{(</quote>)}{\033[1;34m$1\033[0m}g;
  $text =~ s{(</?spell>)}{\033[1;35m$1\033[0m}g;
  $text =~ s{(\&apos;)}{\033[1;32m$1\033[0m}g;
  $text =~ s{($quoteMarks)}{\033[1m\033[43m$1\033[0m}g;

  return $text;
}

sub printWarning {
    my ($message, $line) = @_;
    print "\033[2J";
    print "$message\n";
    print &highlight( $line ) . "\n";
    print "\033[7m    [continue]\033[0m >> ";
    my $response = <STDIN>;
}
