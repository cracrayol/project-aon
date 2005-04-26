#!/usr/bin/perl -w
#
# make-editor.pl
#
# Creates Editor Pack
#
#
#####

use strict;

##

if( $ENV{'AONPATH'} eq "" ) { die "Please set the AONPATH environment variable."; }

my $PROGRAM_NAME     = "make-editor";
my $PATH_PREFIX      = "$ENV{'AONPATH'}/data";
my $XML_PATH         = "xml";
my $GRAPH_PATH       = "svg";
my $EDITOR_PATH      = "editor";
my $CHANGES_PATH     = "$EDITOR_PATH/changes/data";
my @EDITOR_INC       = qw{*.* scripts/* style/* images/* changes/index.html changes/controls.html changes/scripts/* changes/style/*};

##

my $CP         = "/bin/cp";
my $MV         = "/bin/mv";
my $TAR        = "/bin/tar";
my $ZIP        = "/usr/bin/zip";
my $BZIP2      = "/usr/bin/bzip2";
my $RM         = "/usr/bin/rm";

##

my $verbose = 0;
my $book = "";

while( $#ARGV > -1 ) {
 if( $ARGV[0] eq "-v" ) { $verbose = 1; shift @ARGV; }
 else { $book = shift @ARGV; }
}

chdir( "$PATH_PREFIX" ) or die( "Cannot open Project Aon data directory \"$PATH_PREFIX\": $!" );
if( $book ne "" ) {
  print "Tarring SVG\n" if $verbose;
  print qx{$TAR cf editor-$book.tar $GRAPH_PATH/$book.svg};
  print "Zipping SVG\n" if $verbose;
  print qx{$ZIP -8 -q editor-$book.zip $GRAPH_PATH/$book.svg};
  print "Tarring Changes\n" if $verbose;
  print qx{$TAR uf editor-$book.tar $CHANGES_PATH/$book-changes.html};
  print "Zipping Changes\n" if $verbose;
  print qx{$ZIP -8 -q editor-$book.zip $CHANGES_PATH/$book-changes.html};
  print "BZIP2ing tar archive\n" if $verbose;
  print qx{$BZIP2 -9 editor-$book.tar};
}
else {
  print "Tarring Editor Companion\n" if $verbose;
  foreach my $item (@EDITOR_INC) {
    print qx{$TAR uf editor.tar $EDITOR_PATH/$item};
  }
  print "Zipping Editor Companion\n" if $verbose;
  foreach my $item (@EDITOR_INC) {
    print qx{$ZIP -g -q -8 editor.zip $EDITOR_PATH/$item};
  }
  print "BZIP2ing tar archive\n" if $verbose;
  print qx{$BZIP2 -9 editor.tar};
}
