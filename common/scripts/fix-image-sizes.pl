#!/usr/bin/perl -w

use strict;

use File::Spec;
use Image::Size;

my $PROG_NAME = 'fix-image-sizes.pl';
my $USAGE = "typical usage:\t${PROG_NAME} *.png <input.xml >output.xml\n";
die $USAGE if $#ARGV < 0;

my %image_widths = ( );
my %image_heights = ( );

while( my $file = shift @ARGV ) {
    my( $volume, $directory, $filename ) = File::Spec->splitpath( $file );
    ( $image_widths{ $filename }, $image_heights{ $filename } ) = 
        imgsize( $file );
}

while( my $line = <> ) {
    if( $line =~ m{<instance.*src="([^"]+)"} ) {
    my $image = $1;
        if( exists $image_widths{$image} && defined $image_widths{$image} ) {
            my $image = $1;
            if( $line =~ m{width="[^"]*"} ) {
                $line =~ s/width="[^"]*"/width="$image_widths{$image}"/;
            }
            else {
                $line =~ s/(src="[^"]*")/$1 width="$image_widths{$image}"/;
            }

            if( $line =~ m{height="[^"]*"} ) {
                $line =~ s/height="[^"]*"/height="$image_heights{$image}"/;
            }
            else {
                $line =~ s/(src="[^"]*")/$1 height="$image_heights{$image}"/;
            }
        }
    }
    print $line;
}
