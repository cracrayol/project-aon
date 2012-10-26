#!/usr/bin/perl -w
# This script parses the illustrations list of a book in XML form and checks
# that the referred sections contain an illustration of the correct type, and
# that the section titles are correct.

# $Id$

# $Log$
# Revision 1.1  2005/08/23 19:32:28  angantyr
# First checked in version.
#

# Old History:
#  2005-08-22 Implemented handling of multiple instances of an illustration
#  2005-04-02 Fixed a bad regexp for section ids.
#  2003-03-23 First version.


($xmlfile = shift @ARGV) || die("usage: $0 <xml file>\n");
shift @ARGV && die("usage: $0 <xml file>\n");

foreach $illtype ("primill", "secill") {
  open(ILL, $xmlfile) || die("Cannot read input file $xmlfile\n");
  open(SECTIONS, $xmlfile) || die("Cannot read input file $xmlfile\n");

  while(<ILL>) { # find illustrations list
    last if (m/<section.*id="$illtype".*>/i);
  }
  die("No illustrations section!? Aborting.\n") if eof(ILL);
  while(<ILL>) { # find start of actual list
    last if m/<data>/;
  }
  die("No data in the illustrations section!? Aborting.\n")
    if eof(ILL);
  print("No matches for these $illtype entries were found:\n");

  $lastref = "";
  $repeated = 0;
  # Now pick each paragraph (= illustrations) line
 ILLLOOP: while(<ILL>) {
    last if m|</data>|; # end of the illustrations list
    next unless m/^\s*<li>/; # no list item = not an illustrations line

    @refpairs = m|<a idref="(\w*)">(.*?)</a>|g;

    $i = 0;
  REFLOOP: while((@refpairn = @refpairs[$i++, $i++]) && (($sect, $title) = @refpairn) && $sect && $title) {
      if ($lastref eq $sect) { # Multiple illustrations in one section
        seek(SECTIONS, 0, 0);
        $repeated++;
      }
      else {
        $repeated = 0;
      }

      # Now find section
    FINDSEC: foreach $tryagain (1, 0) {
        while(<SECTIONS>) { # locate section
          if (m/<section.*id="$sect">/) {
            ($class) = m/class="(\S+)"/;
            last FINDSEC; # Don't try again
          }
        }

        # Start over
        seek(SECTIONS, 0, 0);
        if ($tryagain) {
          print("$title ($sect) appears not to be in correct order!\n");
        }
        else {
          print("Could not find $title ($sect) at all!\n");
          next REFLOOP;
        }
      }

      $lastref = $sect;

      my $secttitle;
      while(<SECTIONS>) { # locate data
        if (m/<title>/) {
          my $sectnumber;
          ($sectnumber) = m|<title>(.+)</title>|;
          if ($class =~ m/numbered/i) {
            $secttitle = "Section $sectnumber"
          }
          else {
            $secttitle = $sectnumber;
          }

          print("Illustrations entry section name '$title' does not match the\nsection name '$secttitle' of section with id $sect!\n")
            if (("$secttitle" ne "$title") && ("$sectnumber" ne "$title"));
          last;
        }
      }

      while(<SECTIONS>) { # locate data
        last if m/<data>/;
      }
      die("Could not find any data in $title!? Aborting.\n") if eof(SECTIONS);

      $foundit = 0;
      while(<SECTIONS>) { # find the illustration
        last if m|</data>|;
        #if (m/<section/) { # oh no, nested sections - we cannot handle this well
        #  seek(SECTIONS, -length(), 1); # give the next section a chance
        #  next REFLOOP; # give up on this section
        #}

        $foundit++
          if ($illtype eq "primill" && m/<illustration>/ || # Map
              $illtype eq "primill" && m/<illustration.+class="float".*>/ || # Normal large
              $illtype eq "primill" && m/<illustration.+class="inline".*>/ || # Action Chart
              $illtype eq "secill" && m/<illustration.+class="inline".*>/ || # Normal small
              $illtype eq "secill" && m/<illustration.+class="accent".*>/); # In use still?
      }
      die("Could not find the end of $title!? Aborting.\n") if eof(SECTIONS);
      if (!$repeated && !$foundit) {
        print("$secttitle ($sect) does not contain any matching illustration!\n");
      }
      elsif ($repeated >= $foundit) {
        print("$secttitle ($sect) contains too few matching illustrations!\n");
      }
    } # REFLOOP
    if (@refpairs > 2) { # This illustration appears multiple times
      seek(SECTIONS, 0, 0); # Do not warn if next illustration is not in order
    }
  } # ILLOOP
  close(SECTIONS) || die("What's this?");
  close(ILL) || die("What's this?");
}
print("Checking finished!\n");
