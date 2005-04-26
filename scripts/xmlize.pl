#!/usr/bin/perl
#
# xmlize.pl
#
# $Id$
#
# $Log$
# Revision 1.1  2005/04/26 04:48:03  jonathan.blake
# Initial revision
#
# Revision 1.2  2002/10/20 05:46:31  jblake
# Fixed a couple of bugs in the handling of carriage returns and
# added support for Freeway Warrior's CLOSE COMBAT SKILL.
#
# Revision 1.1  2002/10/20 03:18:35  jblake
# Initial revision
#
#
# 21 Jun 2002 - Fixed bug in tagging of character-attributes
# 06 May 2002 - Incorporated funcionality of xmlize-all
# 20 Oct 2001 - Added more spaces to xmlized lines to make 'em purty
#               in the final product
# 19 May 2001 - Updated to conform to new gamebook DTD
# 17 Apr 2001 - Repurposed as XMLizer
# 24 Feb 2001 - Commented out some of the filtering in favor of
#               placing it in a separate script
# 22 Feb 2000 - Added filtering for &
#               Padding ENDURANCE in combat <p> with spaces
# 21 Feb 2000 - Added filtering for \t
# 05 Feb 2000 - Added Action Chart linking
#               Added [] centering
#               Fixed the "A Giak" caps problem
#
######################################################################

#use strict;

#### Subroutines

sub xmlize {
    my( $inline, $infile ) = @_;

    $inline =~ s/(\.\.\.|\.\s\.\s\.)/\&ellips\;/g;
    $inline =~ tr/\t/ /;
    $inline =~ s/\s{2,}/ /g;
    $inline =~ s/\s+$//;
    $inline =~ s/\&\s/\&amp\; /g;
    $inline =~ tr/\"\`\222\221/\'/;
    $inline =~ s/(Random\sNumber\sTable)/<a idref=\"random\">$1<\/a>/gi;
    $inline =~ s/(Action\sCharts?)/<a idref=\"action\">$1<\/a>/gi;
    # \222 and \221 are some form of funky right and
    # left quotes not present in ascii (of course) 
    $inline =~ tr/\227/-/;
    # \227 is an em or en dash

    $inline =~ s/^\s*(.*)\s*$/$1/;

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
    elsif( $inline eq "" ) {
    }
    elsif( $inline =~ /^<!--(.*)-->/ ) {
        warn( "Warning: unknown comment \"$1\" in \"$infile\"\n" );
    }
    else {
        $inline = "       <p>$inline</p>";
        $inline =~ s/\s+<\/p>/<\/p>/;
    }

# Interferes with selecting a combat paragraph if done earlier
    $inline =~ s/(COMBAT\sSKILL|CLOSE\sCOMBAT\sSKILL|ENDURANCE|WILLPOWER|\bCS\b|\bEP\b)([^<])/<typ class="attribute">$1<\/typ>$2/g;

    return $inline;
}

#### Main Routine

my $numberOfSections = shift @ARGV;

print << "(End of XML Header)";
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE gamebook SYSTEM "gamebook.dtd" [
 <!ENTITY % xhtml.characters SYSTEM "htmlchar.mod">
 <!ENTITY % latex.characters SYSTEM "ltexchar.mod">
 %xhtml.characters;

 <!ENTITY % general.links SYSTEM "genlink.mod">
 %general.links;
 <!ENTITY % xhtml.links   SYSTEM "htmllink.mod">
 %xhtml.links;

 <!ENTITY % general.inclusions SYSTEM "geninc.mod">
 %general.inclusions;
]>

<gamebook xml:lang="en-UK" version="0.10">

<!--

\$Id\$

\$Log\$

-->
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

for( my $sectionNumber = 1; $sectionNumber <= $numberOfSections; ++$sectionNumber ) {

    my $infile = "${sectionNumber}.txt";

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
    push( @oldlines, "" ) if( @oldlines[ $#oldlines ] ne "" );

    foreach my $oldline (@oldlines) {
        $oldline =~ s/\r|\n/ /g;
	$oldline =~ s/^\s*(\S*)\s*$/$1/;
	$oldline =~ s/\s\s/ /;
	if( $oldline ne "" ) {
	    $newline .= (" " . $oldline);
	}
	else {
            $newline = &xmlize( $newline, $infile );
            $newline .= "\n" if( $newline ne "" );
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
