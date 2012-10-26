<?xml version="1.0"?>

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="xml"
             encoding="UTF-8"
             omit-xml-declaration="no"/>
 <xsl:strip-space elements="*" />

 <!-- ====================== parameters ========================== -->

 <xsl:param name="language"><xsl:text>en</xsl:text></xsl:param>
 <xsl:param name="xhtml-ext"><xsl:text>.html</xsl:text></xsl:param>
 <xsl:param name="unique-identifier">
  <xsl:text>error: unique ID not provided to XSL</xsl:text>
 </xsl:param>
  
 <!-- ======================== Templates ========================= -->

 <!-- ================= hierarchical sections ==================== -->

 <xsl:template match="*" />

 <xsl:template match="title">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="creator">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="/gamebook">
  <ncx version="2005-1" xmlns="http://www.daisy.org/z3986/2005/ncx/">
   <xsl:attribute name="xml:lang">
    <xsl:value-of select="$language"/>
   </xsl:attribute>

   <head>
    <meta name="dtb:uid">
     <xsl:attribute name="content">
      <xsl:value-of select="$unique-identifier"/>
     </xsl:attribute>
    </meta>
    <meta name="dtb:depth" content="2"/><!--TODO: make this smarter-->
    <meta name="dtb:totalPageCount" content="0"/>
    <meta name="dtb:maxPageNumber" content="0"/>
   </head>

   <docTitle>
    <text>
     <xsl:apply-templates select="meta/title[1]"/>
    </text>
   </docTitle>

   <docAuthor>
    <text>
     <xsl:apply-templates select="meta/creator[@class='author']"/>
    </text>
   </docAuthor>

   <xsl:apply-templates select="section[@id='title']"/>
  </ncx>
 </xsl:template>

 <!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

 <xsl:template match="/gamebook/section[@id='title']">
  <navMap xmlns="http://www.daisy.org/z3986/2005/ncx/">
   <navPoint class="heading1" id="title">
    <navLabel>
     <text>
      <xsl:apply-templates select="meta/title[1]"/>
     </text>
    </navLabel>
    <content>
     <xsl:attribute name="src">
      <xsl:value-of select="@id"/>
      <xsl:value-of select="$xhtml-ext"/>
     </xsl:attribute>
    </content>
   </navPoint>
   <navPoint class="heading1" id="toc">
    <xsl:for-each select="/gamebook/section[@id='toc']">
     <navLabel>
      <text>
       <xsl:choose>
        <xsl:when test="meta/title">
         <xsl:apply-templates select="meta/title[1]"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>Table of Contents</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </text>
     </navLabel>
     <content>
      <xsl:attribute name="src">
       <xsl:value-of select="@id"/>
       <xsl:value-of select="$xhtml-ext"/>
      </xsl:attribute>
     </content>
    </xsl:for-each>
   </navPoint>

   <xsl:apply-templates select="data/section"/>
  </navMap>
 </xsl:template>

 <!-- ::::::::::: second-level sections :::::::::::::: -->

 <xsl:template match="/gamebook/section/data/section">
  <navPoint class="heading1">
   <xsl:attribute name="id">
    <xsl:value-of select="@id"/>
   </xsl:attribute>
   <navLabel>
    <text>
     <xsl:apply-templates select="meta/title[1]"/>
    </text>
   </navLabel>
   <content>
    <xsl:attribute name="src">
     <xsl:value-of select="@id"/>
     <xsl:value-of select="$xhtml-ext"/>
    </xsl:attribute>
   </content>
   <xsl:apply-templates select="data/section"/>
  </navPoint>
 </xsl:template>

 <!-- :::::::::::: third-level sections ::::::::::::: -->

 <xsl:template match="/gamebook/section/data/section/data/section">
  <xsl:apply-templates select="data/section"/>
 </xsl:template>

 <xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate' or @class='mainmatter-separate' or @class='numbered' or @class='glossary-separate']">
  <navPoint class="heading2">
   <xsl:attribute name="id">
    <xsl:value-of select="@id"/>
   </xsl:attribute>
   <navLabel>
    <text>
     <xsl:apply-templates select="meta/title[1]"/>
    </text>
   </navLabel>
   <content>
    <xsl:attribute name="src">
     <xsl:value-of select="@id"/>
     <xsl:value-of select="$xhtml-ext"/>
    </xsl:attribute>
   </content>
   <xsl:apply-templates select="data/section"/>
  </navPoint>
 </xsl:template>

 <!-- ==================== character elements ==================== -->
 <!--

 These templates define the mapping between the character elements used in
 the Project Aon instances of Gamebook XML and the Unicode characters.

 Portions Copyright International Organization for Standardization 1986 
 Permission to copy in any form is granted for use with conforming SGML 
 systems and applications as defined in ISO 8879, provided this notice 
 is included in all copies.

 -->

 <xsl:template match="ch.apos"><xsl:text>&#39;</xsl:text></xsl:template><!-- apostrophe = single quotation mark -->
 <xsl:template match="ch.nbsp"><xsl:text>&#160;</xsl:text></xsl:template><!-- no-break space = non-breaking space, U+00A0 ISOnum -->
 <xsl:template match="ch.iexcl"><xsl:text>&#161;</xsl:text></xsl:template><!-- inverted exclamation mark, U+00A1 ISOnum -->
 <xsl:template match="ch.cent"><xsl:text>&#162;</xsl:text></xsl:template><!-- cent sign, U+00A2 ISOnum -->
 <xsl:template match="ch.pound"><xsl:text>&#163;</xsl:text></xsl:template><!-- pound sign, U+00A3 ISOnum -->
 <xsl:template match="ch.curren"><xsl:text>&#164;</xsl:text></xsl:template><!-- currency sign, U+00A4 ISOnum -->
 <xsl:template match="ch.yen"><xsl:text>&#165;</xsl:text></xsl:template><!-- yen sign = yuan sign, U+00A5 ISOnum -->
 <xsl:template match="ch.brvbar"><xsl:text>&#166;</xsl:text></xsl:template><!-- broken bar = broken vertical bar, U+00A6 ISOnum -->
 <xsl:template match="ch.sect"><xsl:text>&#167;</xsl:text></xsl:template><!-- section sign, U+00A7 ISOnum -->
 <xsl:template match="ch.uml"><xsl:text>&#168;</xsl:text></xsl:template><!-- diaeresis = spacing diaeresis, U+00A8 ISOdia -->
 <xsl:template match="ch.copy"><xsl:text>&#169;</xsl:text></xsl:template><!-- copyright sign, U+00A9 ISOnum -->
 <xsl:template match="ch.ordf"><xsl:text>&#170;</xsl:text></xsl:template><!-- feminine ordinal indicator, U+00AA ISOnum -->
 <xsl:template match="ch.laquo"><xsl:text>&#171;</xsl:text></xsl:template><!-- left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum -->
 <xsl:template match="ch.not"><xsl:text>&#172;</xsl:text></xsl:template><!-- not sign, U+00AC ISOnum -->
 <xsl:template match="ch.shy"><xsl:text>&#173;</xsl:text></xsl:template><!-- soft hyphen = discretionary hyphen, U+00AD ISOnum -->
 <xsl:template match="ch.reg"><xsl:text>&#174;</xsl:text></xsl:template><!-- registered sign = registered trade mark sign, U+00AE ISOnum -->
 <xsl:template match="ch.macr"><xsl:text>&#175;</xsl:text></xsl:template><!-- macron = spacing macron = overline = APL overbar, U+00AF ISOdia -->
 <xsl:template match="ch.deg"><xsl:text>&#176;</xsl:text></xsl:template><!-- degree sign, U+00B0 ISOnum -->
 <xsl:template match="ch.plusmn"><xsl:text>&#177;</xsl:text></xsl:template><!-- plus-minus sign = plus-or-minus sign, U+00B1 ISOnum -->
 <xsl:template match="ch.sup2"><xsl:text>&#178;</xsl:text></xsl:template><!-- superscript two = superscript digit two = squared, U+00B2 ISOnum -->
 <xsl:template match="ch.sup3"><xsl:text>&#179;</xsl:text></xsl:template><!-- superscript three = superscript digit three = cubed, U+00B3 ISOnum -->
 <xsl:template match="ch.acute"><xsl:text>&#180;</xsl:text></xsl:template><!-- acute accent = spacing acute, U+00B4 ISOdia -->
 <xsl:template match="ch.micro"><xsl:text>&#181;</xsl:text></xsl:template><!-- micro sign, U+00B5 ISOnum -->
 <xsl:template match="ch.para"><xsl:text>&#182;</xsl:text></xsl:template><!-- pilcrow sign  = paragraph sign, U+00B6 ISOnum -->
 <xsl:template match="ch.middot"><xsl:text>&#183;</xsl:text></xsl:template><!-- middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum -->
 <xsl:template match="ch.cedil"><xsl:text>&#184;</xsl:text></xsl:template><!-- cedilla = spacing cedilla, U+00B8 ISOdia -->
 <xsl:template match="ch.sup1"><xsl:text>&#185;</xsl:text></xsl:template><!-- superscript one = superscript digit one, U+00B9 ISOnum -->
 <xsl:template match="ch.ordm"><xsl:text>&#186;</xsl:text></xsl:template><!-- masculine ordinal indicator, U+00BA ISOnum -->
 <xsl:template match="ch.raquo"><xsl:text>&#187;</xsl:text></xsl:template><!-- right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum -->
 <xsl:template match="ch.frac14"><xsl:text>&#188;</xsl:text></xsl:template><!-- vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum -->
 <xsl:template match="ch.frac12"><xsl:text>&#189;</xsl:text></xsl:template><!-- vulgar fraction one half = fraction one half, U+00BD ISOnum -->
 <xsl:template match="ch.frac34"><xsl:text>&#190;</xsl:text></xsl:template><!-- vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum -->
 <xsl:template match="ch.iquest"><xsl:text>&#191;</xsl:text></xsl:template><!-- inverted question mark = turned question mark, U+00BF ISOnum -->
 <xsl:template match="ch.Agrave"><xsl:text>&#192;</xsl:text></xsl:template><!-- latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1 -->
 <xsl:template match="ch.Aacute"><xsl:text>&#193;</xsl:text></xsl:template><!-- latin capital letter A with acute, U+00C1 ISOlat1 -->
 <xsl:template match="ch.Acirc"><xsl:text>&#194;</xsl:text></xsl:template><!-- latin capital letter A with circumflex, U+00C2 ISOlat1 -->
 <xsl:template match="ch.Atilde"><xsl:text>&#195;</xsl:text></xsl:template><!-- latin capital letter A with tilde, U+00C3 ISOlat1 -->
 <xsl:template match="ch.Auml"><xsl:text>&#196;</xsl:text></xsl:template><!-- latin capital letter A with diaeresis, U+00C4 ISOlat1 -->
 <xsl:template match="ch.Aring"><xsl:text>&#197;</xsl:text></xsl:template><!-- latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1 -->
 <xsl:template match="ch.AElig"><xsl:text>&#198;</xsl:text></xsl:template><!-- latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1 -->
 <xsl:template match="ch.Ccedil"><xsl:text>&#199;</xsl:text></xsl:template><!-- latin capital letter C with cedilla, U+00C7 ISOlat1 -->
 <xsl:template match="ch.Egrave"><xsl:text>&#200;</xsl:text></xsl:template><!-- latin capital letter E with grave, U+00C8 ISOlat1 -->
 <xsl:template match="ch.Eacute"><xsl:text>&#201;</xsl:text></xsl:template><!-- latin capital letter E with acute, U+00C9 ISOlat1 -->
 <xsl:template match="ch.Ecirc"><xsl:text>&#202;</xsl:text></xsl:template><!-- latin capital letter E with circumflex, U+00CA ISOlat1 -->
 <xsl:template match="ch.Euml"><xsl:text>&#203;</xsl:text></xsl:template><!-- latin capital letter E with diaeresis, U+00CB ISOlat1 -->
 <xsl:template match="ch.Igrave"><xsl:text>&#204;</xsl:text></xsl:template><!-- latin capital letter I with grave, U+00CC ISOlat1 -->
 <xsl:template match="ch.Iacute"><xsl:text>&#205;</xsl:text></xsl:template><!-- latin capital letter I with acute, U+00CD ISOlat1 -->
 <xsl:template match="ch.Icirc"><xsl:text>&#206;</xsl:text></xsl:template><!-- latin capital letter I with circumflex, U+00CE ISOlat1 -->
 <xsl:template match="ch.Iuml"><xsl:text>&#207;</xsl:text></xsl:template><!-- latin capital letter I with diaeresis, U+00CF ISOlat1 -->
 <xsl:template match="ch.ETH"><xsl:text>&#208;</xsl:text></xsl:template><!-- latin capital letter ETH, U+00D0 ISOlat1 -->
 <xsl:template match="ch.Ntilde"><xsl:text>&#209;</xsl:text></xsl:template><!-- latin capital letter N with tilde, U+00D1 ISOlat1 -->
 <xsl:template match="ch.Ograve"><xsl:text>&#210;</xsl:text></xsl:template><!-- latin capital letter O with grave, U+00D2 ISOlat1 -->
 <xsl:template match="ch.Oacute"><xsl:text>&#211;</xsl:text></xsl:template><!-- latin capital letter O with acute, U+00D3 ISOlat1 -->
 <xsl:template match="ch.Ocirc"><xsl:text>&#212;</xsl:text></xsl:template><!-- latin capital letter O with circumflex, U+00D4 ISOlat1 -->
 <xsl:template match="ch.Otilde"><xsl:text>&#213;</xsl:text></xsl:template><!-- latin capital letter O with tilde, U+00D5 ISOlat1 -->
 <xsl:template match="ch.Ouml"><xsl:text>&#214;</xsl:text></xsl:template><!-- latin capital letter O with diaeresis, U+00D6 ISOlat1 -->
 <xsl:template match="ch.times"><xsl:text>&#215;</xsl:text></xsl:template><!-- multiplication sign, U+00D7 ISOnum -->
 <xsl:template match="ch.Oslash"><xsl:text>&#216;</xsl:text></xsl:template><!-- latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1 -->
 <xsl:template match="ch.Ugrave"><xsl:text>&#217;</xsl:text></xsl:template><!-- latin capital letter U with grave, U+00D9 ISOlat1 -->
 <xsl:template match="ch.Uacute"><xsl:text>&#218;</xsl:text></xsl:template><!-- latin capital letter U with acute, U+00DA ISOlat1 -->
 <xsl:template match="ch.Ucirc"><xsl:text>&#219;</xsl:text></xsl:template><!-- latin capital letter U with circumflex, U+00DB ISOlat1 -->
 <xsl:template match="ch.Uuml"><xsl:text>&#220;</xsl:text></xsl:template><!-- latin capital letter U with diaeresis, U+00DC ISOlat1 -->
 <xsl:template match="ch.Yacute"><xsl:text>&#221;</xsl:text></xsl:template><!-- latin capital letter Y with acute, U+00DD ISOlat1 -->
 <xsl:template match="ch.THORN"><xsl:text>&#222;</xsl:text></xsl:template><!-- latin capital letter THORN, U+00DE ISOlat1 -->
 <xsl:template match="ch.szlig"><xsl:text>&#223;</xsl:text></xsl:template><!-- latin small letter sharp s = ess-zed, U+00DF ISOlat1 -->
 <xsl:template match="ch.agrave"><xsl:text>&#224;</xsl:text></xsl:template><!-- latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1 -->
 <xsl:template match="ch.aacute"><xsl:text>&#225;</xsl:text></xsl:template><!-- latin small letter a with acute, U+00E1 ISOlat1 -->
 <xsl:template match="ch.acirc"><xsl:text>&#226;</xsl:text></xsl:template><!-- latin small letter a with circumflex, U+00E2 ISOlat1 -->
 <xsl:template match="ch.atilde"><xsl:text>&#227;</xsl:text></xsl:template><!-- latin small letter a with tilde, U+00E3 ISOlat1 -->
 <xsl:template match="ch.auml"><xsl:text>&#228;</xsl:text></xsl:template><!-- latin small letter a with diaeresis, U+00E4 ISOlat1 -->
 <xsl:template match="ch.aring"><xsl:text>&#229;</xsl:text></xsl:template><!-- latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1 -->
 <xsl:template match="ch.aelig"><xsl:text>&#230;</xsl:text></xsl:template><!-- latin small letter ae = latin small ligature ae, U+00E6 ISOlat1 -->
 <xsl:template match="ch.ccedil"><xsl:text>&#231;</xsl:text></xsl:template><!-- latin small letter c with cedilla, U+00E7 ISOlat1 -->
 <xsl:template match="ch.egrave"><xsl:text>&#232;</xsl:text></xsl:template><!-- latin small letter e with grave, U+00E8 ISOlat1 -->
 <xsl:template match="ch.eacute"><xsl:text>&#233;</xsl:text></xsl:template><!-- latin small letter e with acute, U+00E9 ISOlat1 -->
 <xsl:template match="ch.ecirc"><xsl:text>&#234;</xsl:text></xsl:template><!-- latin small letter e with circumflex, U+00EA ISOlat1 -->
 <xsl:template match="ch.euml"><xsl:text>&#235;</xsl:text></xsl:template><!-- latin small letter e with diaeresis, U+00EB ISOlat1 -->
 <xsl:template match="ch.igrave"><xsl:text>&#236;</xsl:text></xsl:template><!-- latin small letter i with grave, U+00EC ISOlat1 -->
 <xsl:template match="ch.iacute"><xsl:text>&#237;</xsl:text></xsl:template><!-- latin small letter i with acute, U+00ED ISOlat1 -->
 <xsl:template match="ch.icirc"><xsl:text>&#238;</xsl:text></xsl:template><!-- latin small letter i with circumflex, U+00EE ISOlat1 -->
 <xsl:template match="ch.iuml"><xsl:text>&#239;</xsl:text></xsl:template><!-- latin small letter i with diaeresis, U+00EF ISOlat1 -->
 <xsl:template match="ch.eth"><xsl:text>&#240;</xsl:text></xsl:template><!-- latin small letter eth, U+00F0 ISOlat1 -->
 <xsl:template match="ch.ntilde"><xsl:text>&#241;</xsl:text></xsl:template><!-- latin small letter n with tilde, U+00F1 ISOlat1 -->
 <xsl:template match="ch.ograve"><xsl:text>&#242;</xsl:text></xsl:template><!-- latin small letter o with grave, U+00F2 ISOlat1 -->
 <xsl:template match="ch.oacute"><xsl:text>&#243;</xsl:text></xsl:template><!-- latin small letter o with acute, U+00F3 ISOlat1 -->
 <xsl:template match="ch.ocirc"><xsl:text>&#244;</xsl:text></xsl:template><!-- latin small letter o with circumflex, U+00F4 ISOlat1 -->
 <xsl:template match="ch.otilde"><xsl:text>&#245;</xsl:text></xsl:template><!-- latin small letter o with tilde, U+00F5 ISOlat1 -->
 <xsl:template match="ch.ouml"><xsl:text>&#246;</xsl:text></xsl:template><!-- latin small letter o with diaeresis, U+00F6 ISOlat1 -->
 <xsl:template match="ch.divide"><xsl:text>&#247;</xsl:text></xsl:template><!-- division sign, U+00F7 ISOnum -->
 <xsl:template match="ch.oslash"><xsl:text>&#248;</xsl:text></xsl:template><!-- latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1 -->
 <xsl:template match="ch.ugrave"><xsl:text>&#249;</xsl:text></xsl:template><!-- latin small letter u with grave, U+00F9 ISOlat1 -->
 <xsl:template match="ch.uacute"><xsl:text>&#250;</xsl:text></xsl:template><!-- latin small letter u with acute, U+00FA ISOlat1 -->
 <xsl:template match="ch.ucirc"><xsl:text>&#251;</xsl:text></xsl:template><!-- latin small letter u with circumflex, U+00FB ISOlat1 -->
 <xsl:template match="ch.uuml"><xsl:text>&#252;</xsl:text></xsl:template><!-- latin small letter u with diaeresis, U+00FC ISOlat1 -->
 <xsl:template match="ch.yacute"><xsl:text>&#253;</xsl:text></xsl:template><!-- latin small letter y with acute, U+00FD ISOlat1 -->
 <xsl:template match="ch.thorn"><xsl:text>&#254;</xsl:text></xsl:template><!-- latin small letter thorn, U+00FE ISOlat1 -->
 <xsl:template match="ch.yuml"><xsl:text>&#255;</xsl:text></xsl:template><!-- latin small letter y with diaeresis, U+00FF ISOlat1 -->

 <!-- ~~~~~~~~~~~~~~~~~~~~~ Special Characters ~~~~~~~~~~~~~~~~~~~~ -->

 <xsl:template match="ch.ampersand">&amp;</xsl:template><!-- ampersand -->
 <xsl:template match="ch.lsquot">&#8216;</xsl:template><!-- opening left quotation mark -->
 <xsl:template match="ch.rsquot">&#8217;</xsl:template><!-- closing right quotation mark -->
 <xsl:template match="ch.ldquot">&#8220;</xsl:template><!-- opening left double quotation mark -->
 <xsl:template match="ch.rdquot">&#8221;</xsl:template><!-- closing right double quotation mark -->
 <xsl:template match="ch.minus">&#8722;</xsl:template><!-- mathematical minus -->
 <xsl:template match="ch.endash">&#8211;</xsl:template><!-- endash -->
 <xsl:template match="ch.emdash">&#160;&#8212;&#32;</xsl:template><!-- emdash -->
 <xsl:template match="ch.ellips">&#160;&#8230;&#32;</xsl:template><!-- ellipsis -->
 <xsl:template match="ch.lellips">&#8230;&#32;</xsl:template><!-- left ellipsis, used at the beginning of edited material -->
 <xsl:template match="ch.blankline">_______</xsl:template><!-- blank line to be filled in -->
 <xsl:template match="ch.percent"><xsl:text>&#37;</xsl:text></xsl:template><!-- percent sign -->
 <xsl:template match="ch.thinspace"><xsl:text>&#32;</xsl:text></xsl:template><!-- small horizontal space for use between adjacent quotation marks - added mainly for LaTeX's sake -->
 <xsl:template match="ch.frac116"><xsl:text>1/16</xsl:text></xsl:template><!-- vulgar fraction one sixteenth = fraction on sixteenth -->
 <xsl:template match="ch.plus"><xsl:text>+</xsl:text></xsl:template><!-- mathematical plus -->

</xsl:transform>