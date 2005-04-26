This file describes how to use the scripts included in this archive.
Yes, it desperately needs updating and expansion.

corrtohtml.pl: translates the standard Project Aon correction report
format into HTML corresponding to the changes log used with the 
Editor's Companion.

  corrtohtml.pl [correctionFile1 [correctionFile2 . . .]]

create-css.pl: used by gbtoxhtml.pl to create a CSS file for use by
the XHTML files.

  [not used from the command line]

create-css-xhtml-single.pl: used by gbtoxhtml-single.pl to create a
CSS file for use by the single file version of the XHTML.

  [not used from the command line]

create-pdacss.pl: used by gbtopdaxhtml.pl to create a CSS file for
use by the PDA version of the XHTML.

  [not used from the command line]

frontfilter.pl: filters frontmatter files for links and common
characters.

  frontfilter.pl frontmatterFile1 [frontmatterFile2 . . .]

gbfixencoding.pl: interactively fix encoding errors in gamebook XML
  (requires ANSI escape sequences - tested on CYGWIN)

  gbfixencoding.pl inputXML outputXML

gbfixquotes.pl: interactively encode quotation marks
  (requires ANSI escape sequences - tested on CYGWIN)

  gbfixquotes.pl inputXML outputXML

gblint.pl: find common errors in gamebook XML - does not validate XML

  gblint.pl inputXML > errorList
    -s LINES         skip first LINES
    -e MAX_ERRORS 

gbtodot.pl: converts an XML file to DOT graph representation of the 
choices.

  gbtodot.pl inputXML outputDOT baseURL

gbtolatex.pl: creates a LaTeX file for conversion to PDF using
pdflatex.

  gbtolatex.pl bookCode

gbtopdaxhtml.pl: creates simplified XHTML for use by PDA utilities.

  gbtopdaxhtml.pl bookCode

gbtopml.pl: creates PML version of the XML.

  gbtopml.pl bookCode

gbtoxhtml.pl: processes an XML file into XHTML.

  gbtoxhtml.pl bookCode

gbtoxhtml-all.pl: creates all of the books in XHTML. Uses
gbtoxhtml.pl.

  gbtoxhtml-all.pl

gbtoxhtml-single.pl: creates a single XHTML file.

  gbtoxhtml-single.pl bookCode

mergecorrhtml.pl: merges correction log HTML into a preexisting file.

  mergecorrhtml.pl [options] inputHTML [correctionFiles]
    -b    bookCode
    -u    include corrections with unspecified title

sortcorrhtml.pl: sorts correction log HTML into book order.

  sortcorrhtml.pl [correctionFiles]

xmlize.pl: converts the proofread text format into a gamebook XML file.

  xmlize.pl numberOfSections
