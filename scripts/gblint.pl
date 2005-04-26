#!/usr/bin/perl -Tw
#
# Each new section id requires adding it to the list (e.g. improved
# disciplines).
#
###############################################################################
use strict;

my $endOfDTD = 0;

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
  'passing'  => 'passing',
  'part1'    => 'part1',
  'part2'    => 'part2',
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
  'lic-6-1'  => 'license',
);

my $errorCount = 0;
my $maxErrorCount = 0;
my $skipLines = 0;
my $initials = "??";
my $useCorr = 0;

while( $#ARGV > -1 && $ARGV[ 0 ] =~ /^-/ ) {
  if( $ARGV[ 0 ] eq "-e" && $#ARGV > 0 ) {
    shift @ARGV;
    $maxErrorCount = shift @ARGV;
  }
  elsif( $ARGV[ 0 ] eq "-s" && $#ARGV > 0 ) {
    shift @ARGV;
    $skipLines = shift @ARGV;
  }
  elsif( $ARGV[ 0 ] eq "-i" && $#ARGV > 0 ) {
    shift @ARGV;
    $initials = shift @ARGV;
  }
  elsif( $ARGV[ 0 ] eq "--use-corr" ) {
    shift @ARGV;
    $useCorr = 1;
  }
}

my $lineNumber = 1;
my $currentSection = "_unknown";

while( my $line = <> ) {
  my @section = ( $line =~ /<section[^>]+id="([^"]*)"/g );
  if( $#section > 0 ) { die( "Multiple sections begin at line $lineNumber\n" ); }
  elsif( $#section == 0 ) {
    if( $section[ 0 ] =~ /^sect[[:digit:]]+$/ ) {
      $currentSection = $section[ 0 ];
    }
    else {
      $currentSection = $sectionDocLookup{$section[ 0 ]};
    }
  }

  if( $skipLines >= $lineNumber ) {
    ++$lineNumber;
    next;
  }

  ##### Unescaped Characters
  if( $line =~ /[\200-\377]/ ) {
    if( $line =~ /\221/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped left single quotation mark(s)", "\221", "<quote>...</quote> or \&apos;" ); }
    if( $line =~ /\222/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped right single quotation mark(s)", "\222", "<quote>...</quote> or \&apos;" ); }
    if( $line =~ /\223/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped left double quotation mark(s)", "\223", "<quote>...</quote>" ); }
    if( $line =~ /\224/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped right double quotation mark(s)", "\224", "<quote>...</quote>" ); }
    if( $line =~ /\226/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped endash(es)", "\226", "&endash;" ); }
    if( $line =~ /\227/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped emdash(es)", "\227", "&emdash;" ); }
    if( $line =~ /([ \200-\220 \225 \230-\377 ])/gx ) {
      &printError( "ne", $currentSection, $lineNumber, "unescaped non-ASCII character(s); first found only", "$1" );
    }
}
  if( $line =~ /'/ ) { &printError( "ne", $currentSection, $lineNumber, "unescaped apostrophe(s)", "'", "\&apos; or <quote>...</quote>" ); }
  if( $line =~ /`/ ) { &printError( "ne", $currentSection, $lineNumber, "backtick(s)", "`", "\&apos; or <quote>...</quote>" ); }

  # tab

  if( $line =~ /\t/ ) { &printError( "ne", $currentSection, $lineNumber, "TAB character found; convert to equivalent SPACEs" ); }

  # ampersand
  if( $line =~ /\&\s/ ) { &printError( "ne", $currentSection, $lineNumber, "possible malformed ampersand or escape sequence", "&", "&ampersand;" ); }

  # emdash
  if( $line =~ /\s-\s/ ) { &printError( "ne", $currentSection, $lineNumber, "probable malformed emdash", " - ", "\&emdash;" ); }
  if( $line =~ /(?<!\!)--(?!>)/ ) { &printError( "ne", $currentSection, $lineNumber, "probable malformed emdash", "--", "\&emdash;" ); }

  # endash
  if( $line =~ /([0-9])-([0-9]+)(?![^<]+>)/ ) { &printError( "ne", $currentSection, $lineNumber, "possible malformed endash", "$1-$2", "$1\&endash;$2" ); }

  # ellipsis
  if( $line =~ /(\.\s*\.(\s*\.)?)/ ) { &printError( "ne", $currentSection, $lineNumber, "possible malformed ellipsis", "$1", "\&ellips; or \&lellips;" ); }
  if( $line =~ /(\&ellips;)([^<[:space:]])/ ) { &printError( "ne", $currentSection, $lineNumber, "\&ellips; without space afterwards", "$1$2", "\&ellips; $2" ); }
  if( $line =~ /([[:space:]]\&ellips;)/ ) { &printError( "ne", $currentSection, $lineNumber, "\&ellips; with preceding space", "$1", "\&ellips;" ); }
  if( $line =~ /([^>])(\&lellips;)/ ) { &printError( "ne", $currentSection, $lineNumber, "possible \&lellips; used in place of \&ellips;", "$1$2", "$1\&ellips;" ); }
  if( $line =~ /(>\&ellips;)/ ) { &printError( "ne", $currentSection, $lineNumber, "possible \&ellips; used in place of \&lellips;", "$1", ">\&lellips;" ); }

  # thinspace
  if( $line =~ m{(</?quote>)\1} ) { &printError( "ne", $currentSection, $lineNumber, "probable candidate for thinspace", "$1$1", "$1\&thinspace;$1" ); }
  if( $line =~ m{(<quote>)(\&apos;)} || $line =~ m{(\&apos;)(</quote>)} ) { &printError( "ne", $currentSection, $lineNumber, "probable canidate for thinspace", "$1$2", "$1\&thinspace;$2" ); }

  # blankline
  if( $line =~ /(__+)/ ) { &printError( "ne", $currentSection, $lineNumber, "probable candidate for blankline", "$1", "\&blankline;" ); }

  # percent
  #  It should be safe to assume that there will be a "]>" at the end of
  #  internal DTD subset. Previous to the end of the internal DTD subset
  #  "%" has special meaning and shouldn't be detected.
  if( $line =~ /]>/ ) { $endOfDTD = 1; }
  if( $endOfDTD && $line =~ /\%/ ) { &printError( "ne", $currentSection, $lineNumber, "possible candidate for percent", "\%", "\&percent;" ); }

  ##### OCR Errors

  if( $line =~ m{([^.?!:);>]</((p)|(choice))>)} ) { &printError( "??", $currentSection, $lineNumber, "possible missing punctuation", "$1" ); }
  if( $line =~ /((?<![iIeE]\.[eg])[.?!]\s+[a-z])/ ) { &printError( "??", $currentSection, $lineNumber, "possible bad initial capitalization", "$1" ); }
  if( $line =~ /([a-zA-Z][0-9][a-zA-Z])/ ) { &printError( "??", $currentSection, $lineNumber, "probable replacement of number for letter", "$1" ); }
  if( $line =~ />[^<]*-[[:space:]]/ ) { &printError( "??", $currentSection, $lineNumber, "possible retained end-of-line hyphen(s)" ); }

  ##### Obsolete Markup

  if( $line =~ /\&lsquot;/ ) { &printError( "ne", $currentSection, $lineNumber, "probable obsolete markup", "\&lsquot;", "<quote>" ); }
  if( $line =~ /\&rsquot;/ ) { &printError( "ne", $currentSection, $lineNumber, "probable obsolete markup", "\&rsquot;", "</quote>" ); }
  if( $line =~ /\&ldquot;/ ) { &printError( "ne", $currentSection, $lineNumber, "probable obsolete markup", "\&ldquot;", "<quote>" ); }
  if( $line =~ /\&rdquot;/ ) { &printError( "ne", $currentSection, $lineNumber, "probable obsolete markup", "\&rdquot;", "</quote>" ); }
  if( $line =~ /\&quot;/ ) { &printError( "ne", $currentSection, $lineNumber, "possible obsolete markup", "\&quot;", "<quote> or </quote>" ); }
  if( $line =~ /(\&link.[^;]+;)/ ) { &printError( "ne", $currentSection, $lineNumber, "probable obsolete markup", "$1", "use <bookref.../> instead" ); }
  if( $line =~ /\&([^[:space:]]+);/ ) {
    unless( $1 =~ /^(?:link|inclusion)/ ) {
      &printError( "ne", $currentSection, $lineNumber, "probable obsolete markup", "\&$1\;", "<ch.$1/>" );
    }
  }
  if( $line =~ /(<a([^>]*) class="footnote"(.*?)>)/ )  { &printError( "ne", $currentSection, $lineNumber, "obsolete markup", "$1", "<footref$2$3>" ); }

  ##### Character Attributes
  if( $line =~ /[^>]((CLOSE\s+)?COMBAT\sSKILL)/ || $line =~ /((CLOSE\s+)?COMBAT\sSKILL)[^<]/ ) {
    &printError( "ne", $currentSection, $lineNumber, "possible missing markup", "$1", "<typ class=\"attribute\">$1</typ>" );
  }
  if( $line =~ /[^>](ENDURANCE)/ || $line =~ /(ENDURANCE)[^<]/ ) {
    &printError( "ne", $currentSection, $lineNumber, "possible missing markup", "ENDURANCE", "<typ class=\"attribute\">ENDURANCE</typ>" );
  }
  if( $line =~ /[^>](WILLPOWER)/ || $line =~ /(WILLPOWER)[^<]/ ) {
    &printError( "ne", $currentSection, $lineNumber, "possible missing markup", "WILLPOWER", "<typ class=\"attribute\">WILLPOWER</typ>" );
  }

  ##### Links
  if( $line =~ /[^>](random[[:space:]]+number[[:space:]]+table)/i ) {
    &printError( "ne", $currentSection, $lineNumber, "possible missing markup", "$1", "<a idref=\"random\">$1</a>" );
  }
  if( $line =~ /[^>](action[[:space:]]+charts?)/i ) {
    &printError( "ne", $currentSection, $lineNumber, "possible missing markup", "$1", "<a idref=\"action\">$1</a>" );
  }

  ##### Others
  if( $line =~ m{<!--(?!/?ERRTAG)} ) { &printError( "ne", $currentSection, $lineNumber, "XML comment found (check for editor comments)" ); }
  if( $line =~ /([[:upper:]]{5,})/ &&
      $line !~ /<signpost>/ &&
      $1 ne "ENDURANCE" &&
      $1 ne "COMBAT" &&
      $1 ne "WILLPOWER" &&
      $1 ne "CLOSE" &&
      $1 ne "XVIII" &&
      $1 ne "DOCTYPE" &&
      $1 ne "ENTITY" &&
      $1 ne "ERRTAG" ) { &printError( "ne", $currentSection, $lineNumber, "possible <signpost> needed", "$1", "<signpost>$1</signpost>" ); }

  #####
  ++$lineNumber;
}

unless( $endOfDTD || $skipLines > 0 ) { print "End of document reached without finding end of internal DTD subset \"]>\".\n"; }

################################################################################

sub printError {
  my ($type, $section, $line, $message, $original, $corrected) = @_;
  my $report = "";

  if( $useCorr ) {
    $report = "($type) $section: ";
    if( defined $original ) { $report .= "$original "; }
    if( defined $corrected ) { $report .= "-> $corrected "; }
    $report .= "[$initials: $message <line $line>]\n";
  }
  else {
    $report = "line $line ($section): $message";
    if( defined $original ) { $report .= " \"$original\""; }
    if( defined $corrected ) { $report .= " ($corrected)"; }
    $report .= "\n";
  }

  print $report;

  ++$errorCount;
  if( $maxErrorCount > 0 && $errorCount > $maxErrorCount ) { die "Maximum number of errors ($maxErrorCount) exceeded. Quitting.\n"; }
}
