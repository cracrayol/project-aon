#!/usr/bin/perl -w

use strict;
use File::Copy;
use Cwd;

my $PROGRAM = 'rename-all.pl';
my $USAGE = "Usage: $PROGRAM regex substitution [directory]\n\nUses Perl regular expressions to rename multiple files. For example, to change the extension of all files ending with 'TXT' to 'txt':\n\n\t$PROGRAM 'TXT\$' txt\n";

unless( $#ARGV >= 1 ) { die $USAGE; }

my $old = shift @ARGV;
my $new = shift @ARGV;
my $dir = '';

if( $#ARGV >= 0 ) {
  $dir = shift @ARGV;
}
else {
  $dir = getcwd;
}

opendir( DIR, $dir ) || die( "Cannot open directory: $!\n" );
my @files = readdir(DIR);
closedir(DIR);

print $old;

for my $file (@files) {
  if( -f $file && $file =~ /$old/ ) {
    my $oldfile = $file;
    $file =~ s/$old/$new/;
    print "mv $oldfile $file\n";
    move( $oldfile, $file );
  }
}
