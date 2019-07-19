#!/usr/bin/env perl
#
# xmlize.pl
#
######################################################################

use strict;
use warnings;
use utf8;
use open ':encoding(UTF-8)';

my $FILE_EXTENSION = 'txt';

#### Main Routine

die "xmlize.pl maxSectionNumber [minSectionNumber]\n" if $#ARGV < 0;
my $minSectionNumber = 1;
my $numberOfSections = shift @ARGV;
$minSectionNumber = shift @ARGV if $#ARGV > -1;

print << "(End of XML Header)";
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE gamebook SYSTEM "gamebook.dtd" [
 <!ENTITY % general.links SYSTEM "genlink.mod">
 %general.links;
 <!ENTITY % xhtml.links   SYSTEM "htmllink.mod">
 %xhtml.links;

 <!ENTITY % general.inclusions SYSTEM "geninc.mod">
 %general.inclusions;
]>

<gamebook xml:lang="en-UK" version="0.12">

 <meta>
  <title>[Insert Title]</title>
 </meta>

 <section id="toc">
  <meta />
  <data />
 </section>

 <section id="title">
  <meta>
   <title>Title Page</title>
   <link class="next" idref="dedicate" />
  </meta>

  <data>

   <!-- Frontmatter -->

   <section class="numbered" id="numbered">
    <meta><title>Numbered Sections</title></meta>

    <data>
(End of XML Header)

for( my $sectionNumber = $minSectionNumber; $sectionNumber <= $numberOfSections; ++$sectionNumber ) {

    my $infile = "${sectionNumber}.${FILE_EXTENSION}";

    open( INFILE, "<$infile" ) or die "Input file \"$infile\" is not readable.\n";

    my @oldlines = ( );
    @oldlines = <INFILE>;

    close INFILE;

    my $title = shift @oldlines;
    my $section = shift @oldlines;
    my $illustration = shift @oldlines;
    chomp $illustration;
    $illustration =~ s/^Illustration\s+(\d+)\s+/$1/;
    $illustration =~ s/\r//g;
    shift @oldlines if( $illustration ne "" );

    my @newlines = ( "" );
    my $newline;

    # Parsing waits for an empty line to XMLize and store
    # the preceding lines. 
    push( @oldlines, "" ) if( $oldlines[ $#oldlines ] ne "" );

    foreach my $oldline (@oldlines) {
        $oldline =~ s/\r|\n/ /g;
        $oldline =~ s/^\s*(\S*)\s*$/$1/;
        $oldline =~ s/\s{2,}/ /;
        if( $oldline ne "" ) {
            $newline .= (" " . $oldline);
        }
        else {
                $newline = &xmlize($newline, $infile);
                $newline .= "\n" if($newline ne "");
                push( @newlines, $newline );
                $newline = "";
        }
    }

    print "\n\n    <section class=\"numbered\" id=\"sect$sectionNumber\">\n     <meta><title>$sectionNumber</title></meta>\n\n     <data>\n";
    print @newlines;
    print "     </data>\n    </section>";
}

print << "(End of XML footer)";

    </data>
   </section>

   <!-- Backmatter -->

  </data>
 </section>
</gamebook>
(End of XML footer)

#### Subroutines

sub xmlize {
    my( $inline, $infile ) = @_;

    $inline =~ tr/\t/ /;
    $inline =~ s/[[:space:]]{2,}/ /g;
    $inline =~ s/[[:space:]]+$//;
    $inline =~ s/^[[:space:]]+//;
    $inline =~ s/[[:space:]]*(\.\.\.|\.\s\.\s\.)[[:space:]]*/<ch.ellips\/>/g;

    $inline =~ s/\&(?=[[:space:]])/<ch.ampersand\/>/g;
    $inline =~ tr/\"\`/\'/;
    $inline =~ s/[\N{U+2018}\N{U+201C}]/<quote>/g;
    $inline =~ s/[\N{U+2019}\N{U+201D}]/<\/quote>/g;
    $inline =~ s/[\N{U+2014}]/<ch.endash\/>/g;
    $inline =~ s/[\N{U+2014}]/<ch.emdash\/>/g;

    $inline =~ s/(Random\sNumber\sTable)/<a idref=\"random\">$1<\/a>/gi;
    $inline =~ s/(Action\sCharts?)/<a idref=\"action\">$1<\/a>/gi;

    if( $inline =~ /^\*/ ) {
        $inline =~ s/^\*\s*/       <ul>\n        <li>/;
        $inline =~ s/\s*\*\s*/<\/li>\n        <li>/g;
        $inline .= "</li>\n       </ul>";
    }
    elsif( $inline =~ /^\d+\)\s/ ) {
        $inline =~ s/^\d+\)\s+/       <ol>\n        <li>/;
        $inline =~ s/\s*\d+\)\s+/<\/li>\n        <li>/g;
        $inline .= "</li>\n       </ol>";
    }
    elsif( $inline =~ /^\<\!\-\-\spre\s\-\-\>/ ) {
        $inline =~ s/^\<\!\-\-\spre\s\-\-\>//;
        warn( "Warning: preformatted text in \"$infile\"\n" );
    }
    elsif( $inline =~ /^.+:\s+CLOSE\sCOMBAT\sSKILL/ ) {
        $inline =~ s/^(.+):\s+CLOSE\sCOMBAT\sSKILL\s+([0-9]+)\s+ENDURANCE\s+([0-9]+)/       <combat><enemy>$1<\/enemy><enemy-attribute class=\"closecombatskill\">$2<\/enemy-attribute><enemy-attribute class=\"endurance\">$3<\/enemy-attribute><\/combat>/g;
    }
    elsif( $inline =~ /^.+:\s+COMBAT\sSKILL/ ) {
        $inline =~ s/^(.+):\s+COMBAT\sSKILL\s+([0-9]+)\s+ENDURANCE\s+([0-9]+)/       <combat><enemy>$1<\/enemy><enemy-attribute class=\"combatskill\">$2<\/enemy-attribute><enemy-attribute class=\"endurance\">$3<\/enemy-attribute><\/combat>/;
    }
    elsif( $inline =~ /^(.*)\b(return|turn|go)([a-zA-Z\s]+?to )(\d{1,3})/i ) {
        $inline =~ s/^(.*)\b(return|turn|go)([a-zA-Z\s]+?to )(\d{1,3})(.*)/       <choice idref=\"sect$4\">$1<link-text>$2$3$4<\/link-text>$5<\/choice>/i;
        $inline =~ s/\s+<\/choice>/<\/choice>/;
    }
    elsif( $inline =~ /^\[/ ) {
        $inline =~ s/\[(.*)\]/$1/;
        $inline = "       <signpost>$inline</signpost>";
        $inline =~ s/\s+<\/signpost>/<\/signpost>/;
    }
    elsif( $inline =~ /^<!--(.*)-->/ ) {
        warn( "Warning: unknown comment \"$1\" in \"$infile\"\n" );
    }
    elsif( $inline eq "" ) {
    }
    else {
        $inline = "       <p>$inline</p>";
        $inline =~ s/\s+<\/p>/<\/p>/;
    }

# Interferes with selecting a combat paragraph if done earlier
    $inline =~ s/(COMBAT\sSKILL|CLOSE\sCOMBAT\sSKILL|ENDURANCE|WILLPOWER|\bCS\b|\bEP\b)([^<])/<typ class="attribute">$1<\/typ>$2/g;

    return $inline;
}
