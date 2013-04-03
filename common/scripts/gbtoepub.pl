#!/usr/bin/perl

use strict;
use warnings;

use File::Path qw(mkpath);

my $PROGRAM_NAME    = 'gbtoepub';
my $USAGE           = "$PROGRAM_NAME [options] book-code\n\t--meta=[metadata file]\n\t--xml=[book XML]\n\t--epub-xsl=[XSL transformation]\n\t--language=[language area of input data (output determined by meta file)]\n\t--font-files=[font-files]\n\t--no-validate\n\t--verbose\n";

my $FILENAME_SEPARATOR = '/';

my $RXP        = '/usr/bin/rxp';
my $CP         = '/bin/cp';
my $MV         = '/bin/mv';
my $TAR        = '/bin/tar';
my $ZIP        = '/usr/bin/zip';
my $BZIP2      = '/bin/bzip2';
my $JAVA       = '/usr/bin/java';
my $XALAN_JAR  = '/usr/share/java/xalan2.jar';
my $RM         = '/bin/rm';
my $CHMOD      = '/bin/chmod';

# Check that all the binaries are were want them

my @BINARIES;
push @BINARIES, ($RXP, $CP, $MV, $TAR, $ZIP, $BZIP2, $JAVA, $XALAN_JAR, $RM, $CHMOD);

foreach (@BINARIES) {
    if ( ! -e $_ ) {
        die "$PROGRAM_NAME: Cannot find binary '".$_."'. Please install it.\n";
    }
}

###

my $EPUB_MIMETYPE  = 'application/epub+zip';
my $MIMETYPE_FILE  = 'mimetype';
my $CONTAINER_FILE = 'container.xml';
my $OEBPS_DIR      = 'OEBPS';
my $META_INF_DIR   = 'META-INF';
my $NCX_FILE       = 'toc.ncx';
my $XHTML_EXT      = 'html';

my $PROJECT_AON_URI = 'http://www.projectaon.org';


###

my $bookCode     = '';
my $metaFile     = '';
my $bookXML      = '';
my $ncxXSL       = 'common/xsl/epub-ncx.xsl';
my $epubXSL      = 'common/xsl/epub-xhtml.xsl';
my $metadataXSL  = 'common/xsl/epub-opf-metadata.xsl';
my $spineXSL     = 'common/xsl/epub-opf-spine.xsl';
my $coverXSL     = 'common/xsl/epub-coverpage.xsl';
my $fontFiles    = "$ENV{'HOME'}${FILENAME_SEPARATOR}souvenir";
my $language     = 'en';

my $verbose = 0;
my $noValidate = 0;

### read command line options

while( $#ARGV > -1 ) {
    my $cmdLineItem = shift @ARGV;
    if( $cmdLineItem =~ /^--meta=(.+)$/ ) {
        $metaFile = $1;
    }
    elsif( $cmdLineItem =~ /^--xml=(.+)$/ ) {
        $bookXML = $1;
    }
    elsif( $cmdLineItem =~ /^--epub-xsl=(.+)$/ ) {
        $epubXSL = $1;
    }
    elsif( $cmdLineItem =~ /^--language=(.+)$/ ) {
        $language = $1;
    }
    elsif( $cmdLineItem =~ /^--verbose/ ) {
        $verbose = 1;
    }
    elsif( $cmdLineItem =~ /^--no-validate/ ) {
        $noValidate = 1;
    }
    elsif( $cmdLineItem =~ /^--font-files=(.+)$/ ) {
        $fontFiles = $1;
    }
    else { 
        $bookCode = $cmdLineItem;
    }
}

if( $bookCode eq '' ) { 
    die "$PROGRAM_NAME: Unspecified book code\n$USAGE";
}
if( $metaFile eq '' ) { $metaFile = "$language/.publisher/rules/epub"; }
if( $bookXML eq '' ) { $bookXML = "$language/xml/$bookCode.xml"; }
if( $epubXSL eq '' ) {
    die "$PROGRAM_NAME: Unspecified XSL transformation file\n$USAGE";
}

### validate book XML

if( (not $noValidate) && -e $RXP ) {
    system( $RXP, '-Vs', $bookXML ) == 0
        or die "$PROGRAM_NAME: XML validation failed\n";
}
elsif( $noValidate ) {
    warn "$PROGRAM_NAME: XML validation skipped - validate before publication\n";
}
else {
    warn "$PROGRAM_NAME: XML validator not installed - validate before publication\n";
}

### read in metadata file

unless( -e $metaFile && -f $metaFile && -r $metaFile ) {
    die qq{$PROGRAM_NAME: Improper metadata file "$metaFile"\n};
}

open( META, '<', $metaFile ) or 
    die qq{$PROGRAM_NAME: Unable to open metadata file "$metaFile": $!\n};

my $meta = '';
while( my $line = <META> ) {
    $meta .= $line if $line !~ /^[[:space:]]*#/;
}
close META;

### interpret rules from metadata
my $rulesString = '';
if( $meta =~ /^[[:space:]]*$bookCode[[:space:]]*{([^}]*)}/sm ) {
    $rulesString = $1;
}
else {
    die "$PROGRAM_NAME: Book code ($bookCode) not found in metadata file or invalid file syntax\n";
}

my @rules = split( /[[:space:]\n]*;[[:space:]\n]*/, $rulesString );
my %rulesHash;
foreach my $rule (@rules) {
    if( $rule =~ /[[:space:]]*([^:]+)[[:space:]]*:[[:space:]]*(.+)$/s ) {
	$rulesHash{ $1 } = $2;
    }
    else {
	die "$PROGRAM_NAME: Unrecognized rule syntax:\n$rule\n";
    }
}

unless( defined $rulesHash{'book-series'} ) {
    die "$PROGRAM_NAME: no book series set\n";
}
unless( defined $rulesHash{'csst'} ) {
    die "$PROGRAM_NAME: metadata file leaves CSS templates unspecified\n";
}

my $SERIES = get_series($rulesHash{'book-series'}) ;
my $SERIES_NUMBER = get_series_number($bookCode);


### create output directories

my %outPath;
$outPath{'top'} = $rulesHash{'language'} . $FILENAME_SEPARATOR .
                     'epub' . $FILENAME_SEPARATOR .
                     $rulesHash{'book-series'} . $FILENAME_SEPARATOR .
                     $bookCode;
# clear old files
if( -e "$outPath{'top'}$FILENAME_SEPARATOR$MIMETYPE_FILE" ) {
    print qx{$RM -r $outPath{'top'}$FILENAME_SEPARATOR*};
}

$outPath{'meta-inf'} = $outPath{'top'} . $FILENAME_SEPARATOR . $META_INF_DIR;
$outPath{'oebps'} = $outPath{'top'} . $FILENAME_SEPARATOR . $OEBPS_DIR;

foreach my $directory (keys(%outPath)) {
    unless( -e $outPath{$directory} && -d $outPath{$directory} ) {
        mkpath $outPath{$directory}
            or die "$PROGRAM_NAME: Unknown error creating output directory " .
                   "\"$outPath{$directory}\"\n";
    }
}

### create content files

# the location of this tempfile also controls where the xhtml will go
my $tempFile = "$outPath{'oebps'}${FILENAME_SEPARATOR}foo.xml";
print qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$epubXSL" -OUT "$tempFile" -PARAM xhtml-ext ".$XHTML_EXT" -PARAM use-illustrators "$rulesHash{'use-illustrators'}" -PARAM language "$rulesHash{'language'}"}; #" <- comment to unconfuse VIM syntax hilighting (ugh)
print qx{$RM $tempFile};

foreach my $imagePath (split( /:/, $rulesHash{'images'} )) {
    unless( -e $imagePath && -d $imagePath ) {
    die "$PROGRAM_NAME: Image path ($imagePath) does not exist or is not a directory\n";
}
    print qx{$CP $imagePath${FILENAME_SEPARATOR}* $outPath{'oebps'}};
}

### create the CSS stylsheet

foreach my $cssTemplate (split( /:/, $rulesHash{'csst'} )) {
    $cssTemplate =~ m/([^${FILENAME_SEPARATOR}]+)t$/;
    my $templateFile = $1;
    open( TEMPLATE, '<', $cssTemplate ) 
        or die "$PROGRAM_NAME: Unable to open CSS template file ($cssTemplate): $!\n";

    my $stylesFile = "$outPath{'oebps'}$FILENAME_SEPARATOR$templateFile";
    open( STYLESHEET, '>', $stylesFile ) 
        or die "$PROGRAM_NAME: Unable to open stylesheet file ($stylesFile) for writing: $!\n";

    while( my $templateLine = <TEMPLATE> ) {
        while( $templateLine =~ /%%([^%[:space:]]+)%%/ ) {
            my $name = $1;
            $templateLine =~ s/%%${name}%%/$rulesHash{$name}/g;
        }
        print STYLESHEET $templateLine;
    }
    close STYLESHEET;
    close TEMPLATE;
}

### copy the font files

unless( -e $fontFiles && -d $fontFiles ) {
    die "$PROGRAM_NAME: font files directory does not exist or is not a directory \"$fontFiles\": $!\n";
}
print qx{$CP $fontFiles${FILENAME_SEPARATOR}*.otf $outPath{'oebps'}};

### write NCX file

my $uniqueID = "opf-$bookCode";
my $bookUniqueURI = "$PROJECT_AON_URI/$language/epub/" .
                    "$rulesHash{'book-series'}/$bookCode/";

my $ncxFile = $outPath{'oebps'} . $FILENAME_SEPARATOR . $NCX_FILE;
open( NCXFILE, '>', $ncxFile ) or
    die "$PROGRAM_NAME: unable to open NCX file for writing " .
        "\"$ncxFile\"\n";
print NCXFILE qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$ncxXSL" -PARAM xhtml-ext ".$XHTML_EXT" -PARAM unique-identifier "$bookUniqueURI" -PARAM language "$rulesHash{'language'}"}; #" comment to unconfuse VIM syntax highlighting
close NCXFILE;

### write mimetype file

my $mimeFile = $outPath{'top'} . $FILENAME_SEPARATOR . $MIMETYPE_FILE;
open( MIMETYPE, '>', $mimeFile ) or
    die "$PROGRAM_NAME: unable to open mimetype file for writing " .
        "\"$mimeFile\"\n";
print MIMETYPE $EPUB_MIMETYPE;
close MIMETYPE;


## write coverpage 

# Generate the cover image. This can be done in two ways:
# 1.- A file is available under the directory of JPEG files for the book
# 2.- A file is generated using imagemagick

# Cover filename
my $coverImage = $outPath{'oebps'} . $FILENAME_SEPARATOR . "cover.jpg"; 
# Cover filename generated by Project Aon
my $pa_coverImage = $rulesHash{'language'} . $FILENAME_SEPARATOR . "jpeg" . $FILENAME_SEPARATOR .$rulesHash{'book-series'}. $FILENAME_SEPARATOR .$bookCode . $FILENAME_SEPARATOR . "cover.jpg";

if ( -e  "$pa_coverImage") {
    # Copy the file here
    print STDERR "DEBUG: Using cover from $pa_coverImage\n" if $verbose;
    system "cp $pa_coverImage $coverImage";
} else {

# Use Imagemagick if available
    if ( -x "/usr/bin/convert" ) {

        print STDERR "DEBUG: Will generate cover with ImageMagick\n" if $verbose;
        my $TITLE = quote_shell(find_title($bookXML));
        my $AUTHOR = quote_shell(find_author($bookXML));
        my $ILLUSTRATOR = quote_shell(find_illustrator($bookXML));
        my $convert_cmd = "";

        if ( -e "$fontFiles/SouvenirStd-Demi.otf" && -e "$fontFiles/SouvenirStd-Light.otf" ) { 
            $convert_cmd="convert -size 600x800 -background white  -font $fontFiles/SouvenirStd-Demi.otf -pointsize 32 -fill '#006633' -gravity north caption:\"\" -annotate +0+218 \"$TITLE\"  -font $fontFiles/SouvenirStd-Light.otf -pointsize 22 -fill black -annotate +0+304 '$AUTHOR' -annotate +0+333 '$ILLUSTRATOR' $coverImage"
        } else {
            print STDERR "WARN: Fontfiles not found, using standard font\n";
            $convert_cmd="convert -size 600x800 -background white -pointsize 32 -fill '#006633' -gravity north caption:\"\" -annotate +0+218 \"$TITLE\"  -pointsize 22 -fill black -annotate +0+304 '$AUTHOR' -annotate +0+333 '$ILLUSTRATOR' $coverImage";
        }

        print STDERR "DEBUG: Will run '$convert_cmd'\n" if $verbose;
        system $convert_cmd;
    }
}

# If there is no coverImage then we will change the XSL output
my $addCover = "yes"; 
$addCover = "no" if ! -e $coverImage;


#
#  TODO: The coverpage seems to be stripped by Calibre since it 
#  expects an image file for the coverpage. Alternatively, create
#  a jpeg file based on the HTML (using html2ps for example) 
#  and use that for the OPF description of the book

my $coverFileName = "coverpage.html";
my $coverFile = "$outPath{'oebps'}$FILENAME_SEPARATOR$coverFileName";
open( COVER, '>', $coverFile ) or
    die "$PROGRAM_NAME: unable to open OPF file for writing " .
        "\"$coverFile\"\n";

my $cover  = qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$coverXSL" -PARAM opf-id "$uniqueID" -PARAM unique-identifier "$bookUniqueURI" -PARAM language "$rulesHash{'language'}" -PARAM book_series "$SERIES" -PARAM book_series_index "$SERIES_NUMBER" -PARAM addcover "$addCover"}; #" comment to unconfuse VIM syntax hilighting


print COVER "$cover";

close COVER;

check_file($coverFileName);

### write OPF Root file
# All content files must be created prior to creating the OPF root file
# with its manifest of content files.

my $opfFileName = "$bookCode.opf";
my $opfFile = "$outPath{'oebps'}$FILENAME_SEPARATOR$opfFileName";
open( OPF, '>', $opfFile ) or
    die "$PROGRAM_NAME: unable to open OPF file for writing " .
        "\"$opfFile\"\n";

print OPF <<END_OPF_HEADER;
<?xml version="1.0"?>
<package version="2.0" 
         xmlns="http://www.idpf.org/2007/opf" 
         unique-identifier="$uniqueID">

END_OPF_HEADER

## write metadata

my $metadata = qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$metadataXSL" -PARAM opf-id "$uniqueID" -PARAM unique-identifier "$bookUniqueURI" -PARAM language "$rulesHash{'language'}" -PARAM book_series "$SERIES" -PARAM book_series_index "$SERIES_NUMBER" -PARAM addcover "$addCover"}; #" comment to unconfuse VIM syntax hilighting
$metadata = " $metadata";
$metadata =~ s|(<dc:)|\n  $1|g;
$metadata =~ s|(</metadata>)|\n $1|g;

print OPF "$metadata\n\n";

## write manifest data
# assuming a flat directory structure within the OEBPS directory

print OPF " <manifest>\n";

opendir( my $content_dir, $outPath{'oebps'} )
    or die "$PROGRAM_NAME: unable to read OEBPS directory " .
           "\"$outPath{'oebps'}\": $!\n";

while( my $content_file = readdir $content_dir ) {
    next if $content_file eq '.';
    next if $content_file eq '..';
    next if $content_file =~ m/\.opf$/i;
    print OPF qq{  <item id="};
    print OPF make_id( $content_file );
    print OPF qq{" href="$content_file" media-type="};
    print OPF get_mime_type( $content_file );
    print OPF qq{"/>\n};
}

closedir $content_dir;

print OPF " </manifest>\n\n";

## write spine data

my $ncxID = make_id( $NCX_FILE );
#print OPF qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$spineXSL" -PARAM toc-id "$ncxID"};
my $spine = qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$spineXSL" -PARAM toc-id "$ncxID" -PARAM addcover "$addCover"};

$spine =~ s/idref="([^"]*)"/idref="$1.$XHTML_EXT"/g;
$spine = " $spine";
$spine =~ s|(<itemref)|\n  $1|g;
$spine =~ s|(</spine>)|\n $1|g;

print OPF "$spine\n\n";

# TODO: write (optional) guide data here
#print OPF " <guide>\n";
#print OPF " </guide>\n</package>";

print OPF "</package>";
close OPF;


### write container.xml

my $containerFile = "$outPath{'meta-inf'}$FILENAME_SEPARATOR$CONTAINER_FILE";
open( CONTAINER, '>', $containerFile ) or
    die "$PROGRAM_NAME: unable to open container file for writing " .
        "\"$containerFile\"\n";
print CONTAINER <<END_CONTAINER;
<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles>
    <rootfile full-path="$OEBPS_DIR/$opfFileName"
     media-type="application/oebps-package+xml" />
  </rootfiles>
</container>
END_CONTAINER
close CONTAINER;

### compress epub contents
# complies with Open Container Format 2.0.1
# http://idpf.org/epub/20/spec/OCF_2.0.1_draft.doc

chdir $outPath{'top'};

system( $ZIP, '-0Xq', "$bookCode.epub", $MIMETYPE_FILE );
system( $ZIP, '-rq', "$bookCode.epub", $META_INF_DIR );
system( $ZIP, '-rq', "$bookCode.epub", $OEBPS_DIR );

exit 0;

################################################################################
# Subroutines
################################################################################

sub make_id {
    my ( $name ) = ( @_ );
    $name = "_$name" if( $name =~ m/^[-.0-9]/ );
    $name =~ tr/\x80-\xff/_/;
    return $name
}

sub get_mime_type {
    # relies on valid file name extensions

    my ( $file ) = ( @_ );
    if( $file =~ m/\.x?html?$/i ) {
        return 'application/xhtml+xml';
    }
    elsif( $file =~ m/\.css$/i ) {
        return 'text/css';
    }
    elsif( $file =~ m/\.png$/i ) {
        return 'image/png';
    }
    elsif( $file =~ m/\.jpe?g$/i ) {
        return 'image/jpeg';
    }
    elsif( $file =~ m/\.svg$/i ) {
        return 'image/svg+xml';
    }
    elsif( $file =~ m/\.gif$/i ) {
        return 'image/gif';
    }
    elsif( $file =~ m/\.ncx$/i ) {
        return 'application/x-dtbncx+xml';
    }
    elsif( $file =~ m/\.otf$/i ) {
        return 'application/x-font-opentype';
    }
    else {
        return 'application/x-unrecognized-mime';
    }
}

sub check_file {
# Check if a file is empty, if it is, abort as this is an indication
# that the previous processing step went wrong
    my ($file) = @_;

    if ( -z $file ) {
        print  STDERR "There was an error generating $file (empty file produced)";
        exit 1;
    }

    return 0;
}

#unless( $bookXML =~ m{^([-\w\@./]+)$} ) {
#    die "$PROGRAM_NAME: bad book XML filename \"$bookXML\"\n";
#}
#$bookXML = $1;
#
#unless( -e $bookXML && -f $bookXML && -r $bookXML ) {
#    die "$PROGRAM_NAME: XML does not exist or is not readable \"$bookXML\"\n";
#}
#
#if( -e $RXP ) {
#    system( $RXP, '-Vs', $bookXML ) == 0
#        or die "$PROGRAM_NAME: XML validation failed\n";
#}
#else {
#    warn "$PROGRAM_NAME: XML Validator not installed - validate before publication\n";
#}
#
#unless( defined $rulesHash{'language'} ) { die "$PROGRAM_NAME: Metadata file leaves language unspecified\n"; }
#unless( defined $rulesHash{'book-series'} ) { die "$PROGRAM_NAME: Metadata file leaves book series unspecified\n"; }
#unless( defined $rulesHash{'images'} ) { die "$PROGRAM_NAME: Metadata file leaves image directories unspecified\n"; }
#unless( defined $rulesHash{'csst'} ) { die "$PROGRAM_NAME: Metadata file leaves CSS templates unspecified\n"; }
#
#
#my $bookPath = "$outPath${FILENAME_SEPARATOR}";
#print qx{$RM ${bookPath}*} if -e $bookPath."/toc.htm";
#print qx{$JAVA -classpath "$XALAN_JAR" org.apache.xalan.xslt.Process -IN "$bookXML" -XSL "$xhtmlXSL" -OUT "${bookPath}foo.xml" -PARAM background-color "$rulesHash{'background-color'}" -PARAM text-color "$rulesHash{'text-color'}" -PARAM link-color "$rulesHash{'link-color'}" -PARAM use-illustrators "$rulesHash{'use-illustrators'}" -PARAM language "$rulesHash{'language'}"};
#print qx{$RM ${bookPath}foo.xml};
#
#
#
#print qx{$ZIP -8 -q ${bookCode}.zip ${bookPath}*};
#print qx{$MV ${bookCode}* $bookPath};
#
#print "Success\n" if $verbose;

# Determine series long name by the series acronym
sub get_series {
    my ($series) = @_;
    my $series_name = "";
    if ($series eq "lw" ) {
        $series_name = "Lone Wolf";
    } elsif ($series eq "ls" ) {
        $series_name = "Lobo Solitario";
    } elsif ($series eq "gs" ) {
        $series_name = "Grey Star the Wizard";
    } elsif ($series eq "fw" ) {
        $series_name = "Freeway Warrior";
    } else {
        print STDERR "WARN: Undefined series. Short name given: '$series'\n";
        $series_name = "[undefined]";
    }
    return $series_name;
}

# Determine the series number based on book code
sub get_series_number {
    my ($bookCode) = @_;
    my $series_number = "";
    if ( $bookCode =~ /^(\d\d)/ ) {
        $series_number = $1;
    } else {
        print STDERR "WARN: Undefined series number. Book code is '$bookCode'.\n";
        $series_number = "xx";
    }
    return $series_number;
}

# Determine the book title by reading the book meta information
sub find_title {
    my ($book) = @_;
    my $title = ""; my $line = "";
    open (BOOK, "head -100 $book | ") || die ("Could not read $book: $!");
    while ($title eq "" && ( $line = <BOOK> ) ) {
        chomp $line;
        if ( $line =~ /<title>(.*?)<\/title>/ ) {
            $title = $1;
        }
    }
    close BOOK;

    if ( $title eq "" ) {
        print STDERR "WARN: Cannot find title for book '$book'\n";
        $title = "[Undefined]";
    }

    return convert_entities($title);
}

# Determine the book author by reading the book meta information
sub find_author {
    my ($book) = @_;
    my $author = ""; 
    my $line = "";
    open (BOOK, "head -100 $book |") || die ("Could not read $book: $!");

    my $find_line = 0;
    while ($author eq "" && ( $line = <BOOK> ) ) {
        chomp $line;
        if ( $find_line == 1 && $line =~ /<line>(.*?)<\/line>/ ) {
            $author = $1;
        }
        $find_line = 1 if ( $line =~ /<creator class="medium">/ );
        $find_line = 0 if ( $line =~ /<\/creator>/ );
        if ( $line =~ /<creator class="author">(.*?)<\/title>/ ) {
            $author = $1;
        }
    }
    close BOOK;

    if ( $author eq "" ) {
        print STDERR "WARN: Cannot find author for book '$book'\n";
        $author = "[Undefined]";
    }


    return $author;
}

# Determine the book illustrator by reading the book meta information
sub find_illustrator {
    my ($book) = @_;
    my $illustrator = "";
    my $line = "";
    open (BOOK, "head -100 $book | ") || die ("Could not read $book: $!");

    my $find_line = 0;
    while ($illustrator eq "" && ( $line = <BOOK> ) ) {
        chomp $line;
        if ( $find_line == 1 && $line =~ /<line>Illustrated by (.*?)<\/line>/ ) {
            $illustrator = $1;
        }
        $find_line = 1 if ( $line =~ /<creator class="medium">/ );
        $find_line = 0 if ( $line =~ /<\/creator>/ );
        if ( $line =~ /<creator class="illustrator">(.*?)<\/title>/ ) {
            $illustrator = $1;
        }
    }
    close BOOK;

    if ( $illustrator eq "" ) {
        print STDERR "WARN: Cannot find illustrator for book '$book'\n";
        $illustrator = "[Undefined]";
    }
    if ( $language eq "en" ) {
        $illustrator = "Illustrated by ".$illustrator;
    } elsif ( $language eq "es" ) {
        $illustrator = "Illustrado por ".$illustrator;
    }

    return $illustrator;
}

sub convert_entities {
# Convert character entities to their correspondent values
    my ($text) = @_;

    $text =~ s/\<ch.apos\/\>/'/g; 
    $text =~ s/\<ch.nbsp\/\>/ /g;
    $text =~ s/\<ch.plusmn\/\>/+-/g;
    $text =~ s/\<ch.aacute\/\>/á/g;
    $text =~ s/\<ch.eacute\/\>/é/g;
    $text =~ s/\<ch.iacute\/\>/í/g;
    $text =~ s/\<ch.oacute\/\>/ó/g;
    $text =~ s/\<ch.uacute\/\>/ú/g;
    $text =~ s/\<ch.ntilde\/\>/ñ/g;
    $text =~ s/\<ch.Aacute\/\>/Á/g;
    $text =~ s/\<ch.Eacute\/\>/É/g;
    $text =~ s/\<ch.Iacute\/\>/Í/g;
    $text =~ s/\<ch.Oacute\/\>/Ó/g;
    $text =~ s/\<ch.Uacute\/\>/Ú/g;
    $text =~ s/\<ch.auml\/\>/ä/g;
    $text =~ s/\<ch.euml\/\>/ë/g;
    $text =~ s/\<ch.iuml\/\>/ï/g;
    $text =~ s/\<ch.ouml\/\>/ö/g;
    $text =~ s/\<ch.uuml\/\>/ü/g;
    $text =~ s/\<ch.Ntilde\/\>/Ñ/g;
    $text =~ s/\<ch.acute\/\>/´/g;
    $text =~ s/\<ch.iexcl\/\>/¡/g;
    $text =~ s/\<ch.iquest\/\>/¿/g;
    $text =~ s/\<ch.laquo\/\>/«/g;
    $text =~ s/\<ch.raquo\/\>/»/g;
    $text =~ s/\<ch.ampersand\/\>/&/g;

    return $text;
}

# Quote metacaracters for shell use
sub quote_shell {
    my ($text) = @_;
    $text =~ s/'/\\'/g; 
    return $text;
}
