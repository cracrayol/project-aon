
README file for epub directory
------------------------------

  This directory holds the scripts and programs used to build e-books of the
  Project Aon released books based on the existing XML files.

  It currently holds:

  - build-epubs.sh: A shell script that runs a build of all the books.
    The result of the build is a number of e-books in epub format
    which will be available once the script finishes in the English
    directory for ePubs (from this directory available at ../../en/epub/)

  - Makefile: a makefile file to build the ebooks (in all available
    formats) in the existing subdirectories. It will build the ePub files
    required and copy them to the appropiate subdirectory.
     

NOTES
----
 
  - Conversion is done using Calibre's command-line interface. All ebooks are
    converted from the 'standard' the ePub format into other common formats
    (such as .mobi or .pdb)

    (see http://manual.calibre-ebook.com/cli/cli-index.html)

    For formats see http://en.wikipedia.org/wiki/Comparison_of_e-book_formats
    
    If you run 'make' (without arguments) the Makefiles will automatically
    build the following formats:

    - .epub: ePub format - appropiate for most electronic Readers
    - .mobi: Mobipocket format - appropiate for the Kindle
    - .pdb: eReader / Palm Media format - appropiate for some PDAs (including
            Palm)
    - .lrf: Broadband eBooks (BBeB) format - appropiate for Sony ereaders

    Other formats can also be built but are not built by default nor removed
    if generated.


WHAT WORKS
---------
 
   - Navigating the pages
   - Navigation to other illustrations (Random number table, map of
     Sommerlund, etc).
   - Zoom feature (in Kindle, maybe not in other readers)
   - Links outside the book (such as the frontmatter note about the errata
     asking anyone to contact Project Aon)

SUGGESED IMPROVEMENTS
---------------------

The following lists some improvements suggested by readers of the ebooks:


 *  Improve navigation as it is sometimes a little unclear. Because page
    length and font size are variable with device settings, many sections wrap
    to a second page. In some sections the page might split between section
    choices.  Readers might not detect that there are additional choices.

   There should be some kind of indicator to show the end of section
   pages. Otherwise there might be a page break and only way to be sure
   is to turn to the next page. 

    Possible solution: 
       - add an 'end of section' marker of some kind.
       - Maybe consider using a "Table of Contents" link similar to the one on
         the HTML book pages on the web site.

 * toc.ncx is basically a table of contents, so it could contain all
   entries in toc.htm. 

 * More references to the content.opf's <guide> section.
   
    <reference type="toc" title="Table of Contents" href="toc.htm"/>
    <reference type="title-page" title="Title Page" href="title.htm"/>
    <reference type="dedication" title="Dedication" href="dedicate.htm"/>
    <reference type="acknowledgements" title="Acknowledgements"
href="acknwldg.htm"/>
    <reference type="other.sections" title="Numbered Sections"
href="numbered.htm"/>
    <reference type="text" title="Section 1" href="sect1.htm"/>
    <reference type="loi" title="Table of Illustrations" href="illstrat.htm"



KNOWN ISSUES
------------

  - There's an Action Chart limitation. You need to have a pen and paper
    chart along with you while you read.

    Possible alternative: Add a frontmatter link to PDF action charts and
    suggest ebook readers use it.

  - Local linking to other books does not work. Linking from one book to
    others should be removed.

    NOTE: Probably to be done in the XSTL files.

  - The titles of the illustrations sometimes span multiple lines when they
    could show up in one single line.

  - The ebooks could be improved by including the official covers (we
    currently do not hold distribution rights for covers as far as I know,
    however).

  - Images (at least in my Android device) are not always scaled properly.
    Although my e-reader (Fbreader) can zoom in the images some could be
    scaled to fit better in the "page".

    Note: This seems to be related to this issue posted in the mailing list:

    " There seems to be an issue with viewing the images correctly on a
    Kindle. They are not correcly aligned and are chopped at page edges, etc.

    All images seem to be within HTML tables, probably for layout, but this
    means that the Kindle cannot find the image size and correctly re-size the
    image to fit it on the page.

    I used Calibre to do a very simple conversion on the original files from
    MOBI to MOBI with the 'linearize tables' option set. All other options I
    left at the Calibre default settings.

    When using the new MOBI files on my Kindle all of the images are now
    automatically sized and centered, are not chopped at page edges, and they
    can be zoomed to full screen using the standard Kindle function by
    clicking on the image. I think that this is because the layout tables
    were hiding the real image details on the Kindle."

  - The map is too large and not scrollable some readers (reported: Sony
    PRS-T1, Nook). Ebook readers might not allow zooming or panning of large
    images, so the map is of limited utility. 

    Alternatives to fix this:
     * providing a text alternate alongside the image.         
     * split the map in two (like in the PDF files)

  - In the Sony PRS-T1 a contributor indicates that:

   * Thin space (U+2009) is rendered as a question mark.
      It says "The Story So Far?...?" in a few places.
   * PNG images don't render correctly at all. There is some kind of vertical
    banding resulting in lack of resolution and fewer shades of grey. GIF and
    JPG work fine though.

    Some other problems with PRS-T1 not apparent in the ebooks as far as I
    could see:

    * PRS-T1's ebook reader does not allow links for images to be followed:
      <IMG> tags aren't clickable even if enclosed in <A>.
    * ISO-8859-1 doesn't seem to be supported at all (I'm not sure  if EPUBs
      require UTF-8).

FIXED ISSUES
-----------

  - A cover is not provided. Some readers (Calibre) just pick an image
    at random do display as a cover. A generic 'all text title page' cover.
    (Name, series, author, illustrator, ProjAon note.. etc) should be
    created.

   DONE: Implemented through changes in the XSLT and also by generating
    a cover page JPEG through Imagemagick. In addition, if the project
    provides a "nice" cover page with a given illustration in the common/
    subdirectory this will be used instead.

  - There is some metadata missing. The ebooks have the "Title" and
    "Language" set but are lacking "Author" and "Series" so sorting in an
    ebook manager is somewhat limited.

    DONE: Sources modified and the information is also extracted by the
     script that generated the ePub in order to set this in the
     file's metadata.

  - Metadata with multiple authors does not show up properly in Calibre,
    it is shown as a single author concatenating both names.

    DONE: Fixed in the XSL

