#!/usr/bin/perl -w
#
# Created from gengraph.pl by Thomas Wolmer
# 19 December 2002
#
# This program makes assumptions about the input XML file:
#
#  * the title of the numbered sections is a simple number
#  * the title appears on a line by itself
#  * the numbered sections are followed by sections of class "backmatter"
#
################################################################################

use strict;

die( "gbtodot inputXMLfile outputDOTfile\n" ) if( $#ARGV + 1 < 2 );

my $infile = shift @ARGV;
my $outfile = shift @ARGV;
my $baseURL = shift @ARGV;

die( "Input file and output file the same: \"$infile\" \"$outfile\"\n" ) if( $infile eq $outfile );

open( INFILE, "<$infile" ) or die( "Cannot read $infile: $!\n" );
my @inlines = <INFILE>;
close INFILE;

my $graphName = $infile;
$graphName =~ s/\.xml$//;

open( OUTFILE, ">$outfile" ) or die( "Cannot write to $outfile: $!\n" );
print( OUTFILE "digraph theGraph {\n  nodesep=.1; \n  ranksep=.2;\n  ratio=auto;\n");
print( OUTFILE "  node [height=.3,width=.3,shape=ellipse,fixedsize=true,fontname=Arial,fontsize=8]\n");
print( OUTFILE "  edge [arrowsize=.7]\n");

my $section = -1;
my $combat = 0;
my $smallIll = 0;
my $ill = 0;
my @attributes = ();
my $backmatterFound;

foreach my $line (@inlines) {
    if( $line =~ m|class="backmatter"| ) {
        last;
    }
    if( $line =~ m|<title>(\d+)</title>| ) {
        # Visualize the previous section's attributes
        if( $combat ) {
            push( @attributes, ( "color=firebrick1", "style=filled" ) );
          }
        # Assume that small and large illustrations never appear together
        if( $smallIll ) {
            push( @attributes, ( "fontcolor=DarkGreen", "label=\"s$smallIll\\n$section\"" ) );
        }
        if( $ill ) {
            push( @attributes, ( "fontcolor=blue", "label=\"i$ill\\n$section\"" ) );
        }
        if( defined( $baseURL ) ) {
            push( @attributes, ( "URL=\"${baseURL}sect${section}.htm\"", "" ) );
        }

        # Print out extra section data if needed
        if( $#attributes > 0 && $section != -1 ) {
#            print( OUTFILE "  $section [", join( ',', @attributes ), "];\n");
            printf( OUTFILE "  %03d [%s];\n", $section, join( ',', @attributes ) );
        }
        $combat = 0;
        $smallIll = 0;
        $ill = 0;
        @attributes = ();
        $section = $1;
    }
    elsif( $line =~ m|<choice\sidref="sect(\d+)">| ) {
#        print( OUTFILE "  $section -> $1;\n" );
        printf( OUTFILE "  %03d -> %03d;\n", $section, $1 );
    }
    elsif( $line =~ m|idref="sect(\d+)"| && $section != -1 ) { # misc links (should be pruned later)
        printf( OUTFILE "  %03d -> %03d [style=dotted,dir=none];\n", $1, $section );
    }

    if( $line =~ m|<combat>| ) {
        $combat = 1;
    }

    if( $line =~ m|src=\"ill(\d+)| ) {
        $ill = $1;
    }

    if( $line =~ m/src=\"s(mall|ect)(\d+)/ ) {
        $smallIll = $2;
    }
}

print( OUTFILE "}\n" );
close OUTFILE;
