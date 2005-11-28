#!/usr/bin/perl -w

use strict;

my $programName = 'corrtohtml';
my $usage = "$programName [options] [inputFile [inputFile2 ...]]\n" .
            "\t-b bookCode          convert unspecified corrections to this book\n" .
            "\t-o outputFile\n" .
            "\t-i editorsInitials\n" .

            "\t-s                   strips book information\n" .
            "\t-v                   verbose reporting\n";

my $optsProcessed = 0;
my $outFile = "";
my $editorInitials = "";
my $stripBookInfo = 0;
my $verbose = 0;
my $bookCode = "";
my $bookCodeReport = "";

while( $#ARGV > -1 && not $optsProcessed ) {
  my $commandLineItem = shift @ARGV;
  if( $commandLineItem eq "-b" ) {
    $bookCode = shift @ARGV or die $usage;
    &validateBookCode( $bookCode ) or die( "Error ($programName): unrecognized bookcode on command line \"$bookCode\"" );
  }
  elsif( $commandLineItem eq "-o" ) {
    $outFile = shift @ARGV or die $usage;
  }
  elsif( $commandLineItem eq "-i" ) {
    $editorInitials = shift @ARGV or die $usage;
  }
  elsif( $commandLineItem eq "-s" ) {
    $stripBookInfo = 1;
  }
  elsif( $commandLineItem eq "-v" ) {
    $verbose = 1;
  }
  elsif( $commandLineItem eq "--help" ) {
    print $usage and exit;
  }
  else {
    unshift @ARGV, $commandLineItem;
    $optsProcessed = 1;
  }
}

my @lines = <>;
my $document = "";
my %sectionDocLookup = (
  '_unknown' => '_unknown',
  'toc'      => 'toc',
  'title'    => 'title',
  'dedicate' => 'dedicate',
  'acknwldg' => 'acknwldg',
  'credits'  => 'acknwldg',
  'coming'   => 'coming',
  'tssf'     => 'tssf',
  'gamerulz' => 'gamerulz',
  'discplnz' => 'discplnz',
  'camflage' => 'discplnz',
  'hunting'  => 'discplnz',
  'sixthsns' => 'discplnz',
  'tracking' => 'discplnz',
  'healing'  => 'discplnz',
  'wepnskll' => 'discplnz',
  'mndshld'  => 'discplnz',
  'mndblst'  => 'discplnz',
  'anmlknsp' => 'discplnz',
  'mindomtr' => 'discplnz',
  'mksumary' => 'discplnz',
  'anmlctrl' => 'discplnz',
  'curing'   => 'discplnz',
  'invsblty' => 'discplnz',
  'psisurge' => 'discplnz',
  'psiscrn'  => 'discplnz',
  'dvnation' => 'discplnz',
  'wpnmstry' => 'discplnz',
  'anmlmstr' => 'discplnz',
  'deliver'  => 'discplnz',
  'assimila' => 'discplnz',
  'hntmstry' => 'discplnz',
  'pthmnshp' => 'discplnz',
  'kaisurge' => 'discplnz',
  'kaiscrn'  => 'discplnz',
  'nexus'    => 'discplnz',
  'gnosis'   => 'discplnz',
  'magi'     => 'discplnz',
  'kalchemy' => 'discplnz',
  'powers'   => 'powers',
  'lessmcks' => 'powers',
  'alchemy'  => 'powers',
  'sorcery'  => 'powers',
  'enchant'  => 'powers',
  'elementl' => 'powers',
  'prophecy' => 'powers',
  'psycmncy' => 'powers',
  'evcation' => 'powers',
  'highmcks' => 'powers',
  'thamtrgy' => 'powers',
  'telergy'  => 'powers',
  'physirgy' => 'powers',
  'theurgy'  => 'powers',
  'visionry' => 'powers',
  'necrmncy' => 'powers',
  'staff'    => 'powers',
  'moonston' => 'powers',
  'equipmnt' => 'equipmnt',
  'howcarry' => 'equipmnt',
  'howmuch'  => 'equipmnt',
  'howuse'   => 'equipmnt',
  'cmbtrulz' => 'cmbtrulz',
  'evasion'  => 'cmbtrulz',
  'lorecrcl' => 'lorecrcl',
  'lcbonus'  => 'lorecrcl',
  'levels'   => 'levels',
  'primate'  => 'levels',
  'tutelary' => 'levels',
  'mentora'  => 'levels',
  'scion'    => 'levels',
  'archmstr' => 'levels',
  'prncpln'  => 'levels',
  'imprvdsc' => 'imprvdsc',
  'guardian' => 'imprvdsc',
  'sunkght'  => 'imprvdsc',
  'sunlord'  => 'imprvdsc',
  'kaiwisdm' => 'kaiwisdm',
  'sage'     => 'sage',
  'numbered' => 'numbered',
  'part1'    => 'part1',
  'part2'    => 'part2',
  'ill1'     => 'ill1',
  'ill2'     => 'ill2',
  'ill3'     => 'ill3',
  'ill4'     => 'ill4',
  'ill5'     => 'ill5',
  'ill6'     => 'ill6',
  'ill7'     => 'ill7',
  'ill8'     => 'ill8',
  'ill9'     => 'ill9',
  'ill10'    => 'ill10',
  'ill11'    => 'ill11',
  'ill12'    => 'ill12',
  'ill13'    => 'ill13',
  'ill14'    => 'ill14',
  'ill15'    => 'ill15',
  'ill16'    => 'ill16',
  'ill17'    => 'ill17',
  'ill18'    => 'ill18',
  'ill19'    => 'ill19',
  'ill20'    => 'ill20',
  'passing'  => 'passing',
  'map'      => 'map',
  'action'   => 'action',
  'crsumary' => 'crsumary',
  'smevazn'  => 'crsumary',
  'crtable'  => 'crtable',
  'random'   => 'random',
  'errata'   => 'errata',
  'errintro' => 'errata',
  'errerr'   => 'errata',
  'footnotz' => 'footnotz',
  'illstrat' => 'illstrat',
  'primill'  => 'illstrat',
  'secill'   => 'illstrat',
  'license'  => 'license',
  'lic-pre'  => 'license',
  'lic-1'    => 'license',
  'lic-1-0'  => 'license',
  'lic-1-1'  => 'license',
  'lic-1-2'  => 'license',
  'lic-1-3'  => 'license',
  'lic-1-4'  => 'license',
  'lic-1-5'  => 'license',
  'lic-1-6'  => 'license',
  'lic-1-7'  => 'license',
  'lic-2'    => 'license',
  'lic-2-0'  => 'license',
  'lic-2-1'  => 'license',
  'lic-2-2'  => 'license',
  'lic-2-3'  => 'license',
  'lic-2-4'  => 'license',
  'lic-2-5'  => 'license',
  'lic-3'    => 'license',
  'lic-3-0'  => 'license',
  'lic-3-1'  => 'license',
  'lic-4'    => 'license',
  'lic-4-0'  => 'license',
  'lic-5'    => 'license',
  'lic-5-0'  => 'license',
  'lic-6'    => 'license',
  'lic-6-0'  => 'license',
  'lic-6-1'  => 'license'
);

my %sectionTitleLookup = (
  '_unknown' => '_unknown',
  'toc'      => 'Table of Contents',
  'title'    => 'Title Page',
  'dedicate' => 'Dedication',
  'acknwldg' => 'Acknowledgements',
  'coming'   => 'Of the Coming of Grey Star',
  'tssf'     => 'The Story So Far . . .',
  'gamerulz' => 'The Game Rules',
  'discplnz' => '. . . Disciplines',
  'powers'   => 'Magical Powers',
  'equipmnt' => 'Equipment',
  'cmbtrulz' => 'Rules for Combat',
  'lorecrcl' => 'Lore-circles of the Magnakai',
  'levels'   => 'Levels of . . . Mastery',
  'imprvdsc' => 'Improved . . . Disciplines',
  'kaiwisdm' => '. . . Wisdom',
  'sage'     => 'Sage Advice',
  'numbered' => 'Numbered Sections',
  'part1'    => 'Part I',
  'part2'    => 'Part II',
  'ill1'     => 'Illustration 1',
  'ill2'     => 'Illustration 2',
  'ill3'     => 'Illustration 3',
  'ill4'     => 'Illustration 4',
  'ill5'     => 'Illustration 5',
  'ill6'     => 'Illustration 6',
  'ill7'     => 'Illustration 7',
  'ill8'     => 'Illustration 8',
  'ill9'     => 'Illustration 9',
  'ill10'    => 'Illustration 10',
  'ill11'    => 'Illustration 11',
  'ill12'    => 'Illustration 12',
  'ill13'    => 'Illustration 13',
  'ill14'    => 'Illustration 14',
  'ill15'    => 'Illustration 15',
  'ill16'    => 'Illustration 16',
  'ill17'    => 'Illustration 17',
  'ill18'    => 'Illustration 18',
  'ill19'    => 'Illustration 19',
  'ill20'    => 'Illustration 20',
  'passing'  => 'Passing of the Shianti',
  'map'      => 'map',
  'action'   => 'Action Chart',
  'crsumary' => 'Combat Rules Summary',
  'crtable'  => 'Combat Results Table',
  'random'   => 'Random Number Table',
  'errata'   => 'Errata',
  'footnotz' => 'Footnotes',
  'illstrat' => 'Table of Illustrations',
  'license'  => 'Project Aon License'
);

if( $bookCode ne "" ) {
    $bookCodeReport = " [$bookCode]";
}
################################################################################
# Normalize Lines and Whitespace

foreach my $line (@lines) {
  $line =~ tr/\n\r/ /;
  $document .= $line;
}
$document =~ s/[[:space:]]{2,}/ /g;                        # collapse spaces
$document =~ s/(\(er?\)|\(ne?\)|\(ft?\)|\(ce\)|\(cn\)|\(cf\)|\(re\)|\(rn\)|\(rf\)|\(\?\??\))/\n$1/g; # break lines
$document =~ s/^[[:space:]]*\n//g;                         # remove blank lines
@lines = split( m/ *\n/, $document );

################################################################################
# Translate

my $commentRegex       = qr{\[[[:space:]]*(([^[:space:]:]*)[[:space:]]*:)?[[:space:]]*([^]]*)\]};
my $sectionNumberRegex = qr{^\(([^)][^)])*\)                       # type: $1
                            [[:space:]]*
                            ([[:digit:]]*[[:alpha:]]+[[:space:]]+)? # book: $2
                            ([[:digit:]]+)                          # section: $3
                            (?:[[:space:]]+
                            \#([[:digit:]]+))?                      # issue: $4
                            [[:space:]]*:
                            (.*?)                                   # correction: $5
                            [[:space:]]*$}x;
my $sectionIDRegex     = qr{^\(([^)][^)])*\)                        # type: $1
                            [[:space:]]*
                            ([[:digit:]]*[[:alpha:]]+[[:space:]]+)? # book: $2
                            ([^:[:space:]]*)                        # section: $3
                            (?:[[:space:]]+
                            \#([[:digit:]]+))?                      # issue: $4
                            [[:space:]]*:
                            (.*?)                                   # correction: $5
                            [[:space:]]*$}x;

foreach my $line (@lines) {
  $line =~ s{&} {&amp;}g;  # escape for HTML
  $line =~ s{<} {&lt;}g;   #   "
  $line =~ s{>} {&gt;}g;   #   "

  while( $line =~ m{$commentRegex} ) {
    if( (not defined( $2 )) || $2 eq "" ) {
      $line =~ s{$commentRegex}{<div class="cm $editorInitials">$3</div>};
    } else {
      my $initials = lc( $2 );
      $line =~ s{$commentRegex}{<div class="cm $initials">$3</div>};
    }
    if( $3 =~ m/^[[:space:]]*$/ ) {
      warn( "Warning ($programName)$bookCodeReport: empty comment found\n" );
    }
  }

  if( $line =~ m{$sectionNumberRegex} ) {
    my $book = "";
    if( defined $2 ) {
      $book = lc( $2 );
      &validateBookCode( $book ) or die( "Error ($programName)$bookCodeReport: unrecognized bookcode in input corrections \"$book\"" );
    }
    elsif( $bookCode ) {
      $book = $bookCode;
      warn( "Warning ($programName)$bookCodeReport: entry with unspecified book coerced to $bookCode: $line\n" );
    }

    my $issue = "";
    if( defined $4 ) { $issue = $4; }
    my $caseFoldSection = lc( $3 );
    if( $book ne "" && not $stripBookInfo ) {
      $line =~ s{$sectionNumberRegex}{<div class="$1"><!-- $book--><a href="sect$caseFoldSection.htm">$caseFoldSection</a> #$issue:$5</div>\n};
    }
    else {
      $line =~ s{$sectionNumberRegex}{<div class="$1"><a href="sect$caseFoldSection.htm">$caseFoldSection</a> #$issue:$5</div>\n};
    }
  }
  elsif( $line =~ m{$sectionIDRegex} ) {
    my $caseFoldSection = lc( $3 );
    exists $sectionDocLookup{$caseFoldSection} && defined $sectionDocLookup{$caseFoldSection}
      or die( "Error ($programName)$bookCodeReport: don\'t understand section ID \"$caseFoldSection\" in $line" );
    exists $sectionTitleLookup{$sectionDocLookup{$caseFoldSection}} && defined $sectionTitleLookup{$sectionDocLookup{$caseFoldSection}}
      or die( "Error ($programName)$bookCodeReport: section ID \"$caseFoldSection\" doesn\'t have an associated title" );

    my $book = "";
    if( defined $2 ) {
      $book = $2;
      chomp( $book );
      &validateBookCode( $book ) or die( "Error ($programName)$bookCodeReport: unrecognized bookcode in input corrections \"$book\"" );
    }
    elsif( $bookCode ) {
      $book = $bookCode;
      warn( "Warning ($programName)$bookCodeReport: entry with unspecified book coerced to $bookCode: $line\n" );
    }

    my $issue = "";
    if( defined $4 ) { $issue = $4; }

    if( $book ne "" && not $stripBookInfo ) {
      $line =~ s{$sectionIDRegex}{<div class="$1"><!-- $book--><a href="$sectionDocLookup{$caseFoldSection}.htm">$sectionTitleLookup{$sectionDocLookup{$caseFoldSection}}</a> \#$issue:$5</div>\n};
    }
    else {
      $line =~ s{$sectionIDRegex}{<div class="$1"><a href="$sectionDocLookup{$caseFoldSection}.htm">$sectionTitleLookup{$sectionDocLookup{$caseFoldSection}}</a> \#$issue:$5</div>\n};
    }
  }
  else {
    die( "Error ($programName)$bookCodeReport: unable to parse line: $line\n" );
  }

  $line =~ s{class="\?\??"} {class="u"};
  $line =~ s{class="er"} {class="e"};
  $line =~ s{class="ne"} {class="n"};
  $line =~ s{class="ft"} {class="f"};

  if( $line =~ m/(\(.{,4}\))|(\[.{,4}\])/ ) {
    warn( "Warning ($programName)$bookCodeReport: possible malformed correction entry: $line\n" );
  }
}

################################################################################
# Output Results

if( $outFile ne "" ) {
  open( OUTFILE, ">$outFile" ) or die( "Error ($programName)$bookCodeReport: Unable to open output file \"$outFile\" for writing: $!" );
  print OUTFILE @lines;
  close( OUTFILE );
}
else {
  print @lines;
}

################################################################################
# Subroutines

sub validateBookCode {
    my ($bookCode) = @_;

    # bookCode typically has some space after real data
    $bookCode =~ s{[[:space:]]+}{}g;

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

    return exists $books{ $bookCode };
}
