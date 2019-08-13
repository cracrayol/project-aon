#!/usr/bin/perl -w

use strict;
use autodie;
use warnings qw< FATAL all >;
use IO::Handle;
use Scalar::Util qw< openhandle >;

#Initialise variables
my $debug = 1;
my $fh = new IO::Handle;
my $line = "";
my $section = "";
my $filename = "";

while ($line = <STDIN>) {
    chomp ($line);
    print STDERR "DEBUG: Reading '$line'\n" if $debug;
    if ($line =~ /^(\d+)$/) {
        $section = $1 ;
        $filename = "$section.txt";
        print STDERR "DEBUG: Starting section $section\n" if $debug;
        close $fh if $fh->opened();
        open ($fh, ">>$filename") or die "Couldn't open file $filename, $!"
    } 

    # Print to the file if we have a filehandle except for the 
    # section number itself
    if ($line !~  /^(\d+)$/) {
        if ( $fh->opened() ) {
            print STDERR "DEBUG: Printing to $filename\n" if $debug;
            print $fh $line."\n" ;
        }
    }
}


close $fh if fileno($fh);

exit 0;
