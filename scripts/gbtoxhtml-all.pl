#!/usr/bin/perl -w

use strict;

my $gbtoxhtml = "$ENV{AONPATH}/bin/gbtoxhtml.pl";
my @bookCodes = qw{ 01fftd  02fotw  03tcok  04tcod
                    05sots  06tkot  07cd    08tjoh
                    09tcof  10tdot  11tpot  12tmod
                    13tplor 14tcok  15tdc
                    01gstw  02tfc   03btng
                    rh
                };

foreach my $bookCode (@bookCodes) {
    print "\n" . ('~' x 10) . " $bookCode " . ('~' x 10) . "\n\n";
    print qx{$gbtoxhtml $bookCode};
}
