#!/usr/bin/perl

while( $ARGV[ 0 ] ) {
    $infile = shift @ARGV;

    @lines = ( );
    open( INFILE, "<$infile" ) or die "Bad input file \"$infile.\": $!";
    @lines = <INFILE>;
    close INFILE;

    foreach $line (@lines) {
	my $oldline = $line;
        $line =~ s/(\.\.\.|\.\s\.\s\.)/\&ellips\;/g;
        $line =~ tr/\t/ /;
        $line =~ s/\s{2,}/ /g;
        $line =~ s/\&\s/\&amp\; /g;
        $line =~ tr/\"\`\222\221/\'/;
        $line =~ s/(Random\sNumber\sTable)/<a idref=\"random\">$1<\/a>/gi;
        $line =~ s/(COMBAT\sSKILL|CLOSE\sCOMBAT\sSKILL|ENDURANCE|WILLPOWER|\bCS\b|\bEP\b)([^<])/<typ class="attribute">$1<\/typ>$2/g;
        $line =~ s/(Action\sCharts?)/<a idref=\"action\">$1<\/a>/gi;
        # \222 and \221 are some form of funky right and
        # left quotes not present in ascii (of course) 
        $line =~ tr/\227/-/;
        # \227 is an em or en dash

        $line =~ s/^\s*(.*)\s*$/$1\n/;
    }

    print @lines;
}
