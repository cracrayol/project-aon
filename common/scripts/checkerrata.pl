#!/usr/bin/perl -w
# This script parses the errata list of a book in XML form and tries to
# locate the added or replaced strings in the sections where they are now
# supposed to exist. Things that are not found by the simple errata list
# parsing code are just skipped. Nesting frontmatter sections are also
# skipped.

# Old History:
#  2005-08-23 Tried to improve handling of <link-text> tags
#  2005-03-12 Treat &thinspace; correctly.
#  2003-03-16 Fixed reporting of false positived due to <link-text> tags
#  2003-03-15 First version.

$xmlfile = shift @ARGV;
$xmlfile || die("usage: $0 <xml file>\n");
$invalid = shift @ARGV;
$invalid && die("usage: $0 <xml file>\n");

open(ERRATA, $xmlfile) || die("Cannot read input file $xmlfile\n");
open(SECTIONS, $xmlfile) || die("Cannot read input file $xmlfile\n");

while(<ERRATA>) { # find errata list
  last if m/<section.*id="errerr".*>/;
}
die("No errata section!? Aborting.\n") if eof(ERRATA);
while(<ERRATA>) { # find start of actual list
  last if m/<data>/;
}
die("No data in the errata section!? Aborting.\n") if eof(ERRATA);

print("No matches for these errata entries were found:\n");

# Now pick each paragraph (= errata) line
ERRATALOOP: while(<ERRATA>) {
  next unless m/^\s*<p>\(<a\s+idref=".+">.+<\/a>\)/; # no paragraph = not an errata line
  last if m|</data>|; # end of the errata list
  ($sect) = m|\(<a (?:id="\w+?" )?idref="(\w+?)">.*</a>\)|;
  defined($sect) || die("Failed on line: $_");
  @reps = m|<quote>.*?</quote> with <quote>(.*?)</quote>|g;
  @adds = m|[Aa]dded <quote>(.*?(?=</quote>))</quote>|g;
  next unless @reps || @adds;

  # Now find section and append all contents into one string
  while(<SECTIONS>) { # locate section
    last if m/<section.*id=\"$sect\">/;
  }
  die("Could not find section $sect!? (This might be because the errata\nentry for it is not placed in the correct section order.) Aborting.\n") if eof(SECTIONS);
  while(<SECTIONS>) { # locate data
    last if m/<data>/;
  }
  die("Could not find any data in $sect!? Aborting.\n") if eof(SECTIONS);
  $text = "";
  while(<SECTIONS>) { # grab all section contents
    last if m|</data>|;
    if (m/<section/) { # oh no, nested sections - we cannot handle this well
      seek(SECTIONS, -length(), 1); # give the next section a chance
      next ERRATALOOP; # give up on this section
    }
    # Before adding the text to the section blob, modify <link-text> tags
    # since they are commented out in the errata entries
    s|<(/?)link-text>|<!--${1}link-text-->|g;
    # The following line substitutes a colon for </enemy> tag since the
    # colon is not in the xml but is added during the conversion process.
    # Some enemies, notably in dotd.xml, were missing a colon after the
    # enemy declaration, which we have added in the PA editions.
    s|</enemy>|:|g;
    $text .= $_;
  }
  die("Could not find the end of $sect!? Aborting.\n") if eof(SECTIONS);

  # The replacement may contain left/right quotes which in the sections are
  # <quote> thingies. Translate these. Also ignore &thinspace; first and
  # last in the replacements.
  # Refactor the duplicated code below some day!
  foreach $rep (@reps) {
    # Contemporary character entities
    $rep =~ s/<ch.l[sd]quot\/>/<quote>/g;
    $rep =~ s/<ch.r[sd]quot\/>/<\/quote>/g;
    $rep =~ s/^<ch.thinspace\/>//g;
    $rep =~ s/<ch.thinspace\/>$//g;
    # (Obsolete) character elements
    $rep =~ s/\&l[sd]quot;/<quote>/g;
    $rep =~ s/\&r[sd]quot;/<\/quote>/g;
    $rep =~ s/^\&thinspace;//g;
    $rep =~ s/\&thinspace;$//g;

    if ($text !~ m/\Q$rep\E/) {
      print("Replacement \"$rep\" in $sect\n");
    }
  }
  foreach $add (@adds) {
    $add =~ s/<ch.l[sd]quot\/>/<quote>/g;
    $add =~ s/<ch.r[sd]quot\/>/<\/quote>/g;
    $add =~ s/^<ch.thinspace\/>//g;
    $add =~ s/<ch.thinspace\/>$//g;
    $add =~ s/\&l[sd]quot;/<quote>/g;
    $add =~ s/\&r[sd]quot;/<\/quote>/g;
    $add =~ s/^\&thinspace;//g;
    $add =~ s/\&thinspace;$//g;

    if ($text !~ m/\Q$add\E/) {
      print("Addition    \"$add\" in $sect\n");
    }
  }
}
print("Checking finished!\n");
