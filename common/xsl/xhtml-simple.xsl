<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
 <!ENTITY % xhtml.characters SYSTEM "../../en/xml/htmlchar.mod">
 %xhtml.characters;
]>

<!--

$Id$

$Log$
Revision 1.5  2007/02/02 20:04:28  jonathan.blake
Correction to handling line elements

Revision 1.4  2006/12/20 00:15:04  jonathan.blake
Updated to handle the new capabilities in version 0.12.1 of the Gamebook DTD.

Revision 1.3  2006/12/07 01:42:28  jonathan.blake
Text illustrations need inclusion

Revision 1.2  2006/11/25 18:57:16  jonathan.blake
Fixed links to footnotes

Revision 1.1  2006/11/25 04:48:52  jonathan.blake
Modified to generate a single unstyled, UTF-8, HTML file which lacks any illustrations


///// xhtml.xsl used as source for xhtml-mongoose.xsl

Revision 1.12  2006/06/05 23:46:46  jonathan.blake
Fixing the handling of titles when <ch.*/> elements are used.

Revision 1.11  2006/04/04 18:48:52  angantyr
Fixed paragraphed list and illref template bug.

Revision 1.10  2006/04/02 19:14:37  angantyr
Introduced automatic footnotes list generation and changed the illustrations
list generation so that links to numbered sections are titled "Section ...".
Backwards compatible with old XML files.

Revision 1.9  2006/03/14 21:04:03  angantyr
Changed the illustration handling with the introduction of 'illref's.
Backwards compatible.

Revision 1.8  2006/03/13 18:38:49  jonathan.blake
Fixed minor Spanish translation issue

Revision 1.7  2006/03/09 18:56:33  jonathan.blake
Added a language parameter and coding to switch between languages when the output is hard-coded into the transformation.

Revision 1.5  2006/03/02 00:33:32  jonathan.blake
Removed the 'book-path' parameter to work with new gbtoxhtml.pl

Revision 1.4  2005/12/27 01:51:29  angantyr
Added templates for the "bookref" and "footref" elements.

Revision 1.3  2005/12/05 21:29:04  jonathan.blake
Added the facilities to properly handle character elements.

Revision 1.2  2005/04/09 19:51:50  angantyr
Added handling of open-ended quotes.

Revision 1.1  2005/01/30 01:32:52  jonathan.blake
Initial freepository revision of XML support documents.

Revision 1.12  2003/10/07 06:05:14  Jon
Added capability for "accent" illustrations.

Revision 1.11  2002/12/06 22:12:04  jblake
Added default namespace declaration to transformation element
and removed all the extraneous declarations in the template
elements.

Revision 1.10  2002/11/17 22:37:25  jblake
Removed the "medium" creator entry from the templates.
Will they be of any use?

Revision 1.9  2002/11/17 05:06:56  jblake
Rearranged the title page.

Revision 1.8  2002/11/15 19:35:25  jblake
Fixed "Content-type" of XHTML output.

Revision 1.7  2002/11/15 00:15:39  jblake
Fixed a problem with the client-side image map and fixed
the numbered section list generation so that it will work
for Shadow on the Sand.

Revision 1.6  2002/10/30 05:59:45  jblake
Added a value for the alt attribute of the ToC image on the navigation bar.

Revision 1.5  2002/10/24 15:53:41  jblake
Fixed a conflict with whitespace and paragraphed lists.

Revision 1.4  2002/10/24 15:06:51  jblake
Added xmlns attributes to all elements that are top level in
their templates. This was an adjustment required by Xalan-J 2.4.

Also reinstated the comment in each document since the new
version of Xalan redirects it properly.

Revision 1.3  2002/10/23 05:18:29  jblake
Added the capability to filter which illustrators' work is used.
This is accomplished by the "use-illustrators" parameter.

Revision 1.2  2002/10/20 06:25:35  jblake
Added support for CLOSE COMBAT SKILL for Freeway Warrior books.

Revision 1.1  2002/10/15 23:29:51  jblake
Initial revision


20020327 - repurposed to be used with Xalan Java 2

Todo:

* Add blank whitespace handling to the paragraphed list template

-->

<xsl:transform version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:redirect="org.apache.xalan.lib.Redirect"
  extension-element-prefixes="redirect">

<xsl:output method="xml"
            encoding="UTF-8"
            omit-xml-declaration="yes"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

<xsl:strip-space elements="section data ol ul dl li dd footnotes footnote" />
<xsl:preserve-space elements="p choice" />

<!-- ====================== parameters ========================== -->

<xsl:param name="use-illustrators" />
<xsl:param name="language"><xsl:text>en</xsl:text></xsl:param>
 
<!-- ======================= variables ========================== -->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<!-- ======================== Templates ========================= -->

<!-- ================= hierarchical sections ==================== -->

<xsl:template match="meta" />
<xsl:template match="section" />

<xsl:template match="/gamebook">
 <html xml:lang="en-UK" lang="en-UK">

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <head><xsl:value-of select="$newline" />
   <title>
    <xsl:apply-templates select="/gamebook/meta/title[1]" />
   </title><xsl:value-of select="$newline" />
   <meta http-equiv="Content-type" content="text/html; charset=utf-8" /><xsl:value-of select="$newline" />
   <meta name="robots" content="noindex,nofollow" /><xsl:value-of select="$newline" />
  </head>

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <body>
   <xsl:comment>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="/gamebook/meta/rights[@class='copyrights']" />
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text> Publicado por </xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text> Published by </xsl:text>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="/gamebook/meta/publisher[1]" />
    <xsl:text>. </xsl:text>
   </xsl:comment>

   <xsl:value-of select="$newline" />
   <xsl:value-of select="$newline" />

   <h1>
    <a name="title">
     <xsl:apply-templates select="/gamebook/meta/title[1]" />
    </a>
   </h1><xsl:value-of select="$newline" />

   <xsl:apply-templates/>

  </body>
 </html>
</xsl:template>

<!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

<xsl:template match="/gamebook/section[@id='title']">
 <div class="frontmatter"><xsl:value-of select="$newline" />

  <xsl:apply-templates select="/gamebook/meta/description[@class='blurb']" />
  <xsl:apply-templates select="/gamebook/meta/creator[@class='long']" />

  <hr />

  <xsl:apply-templates select="/gamebook/meta/description[@class='publication']" />

  <p>
   <xsl:choose>
    <xsl:when test="$language='es'">
     <xsl:text>Fecha de Publicaci&oacute;n: </xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>Publication Date: </xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:value-of select="/gamebook/meta/date[@class='publication']/day" />
   <xsl:text> </xsl:text>
   <xsl:choose>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 1">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de enero de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>January</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 2">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de febrero de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>February</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 3">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de marzo de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>March</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 4">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de abril de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>April</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 5">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de mayo de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>May</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 6">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de junio de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>June</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 7">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de julio de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>July</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 8">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de agosto de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>August</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 9">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de septiembre de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>September</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 10">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de octubre de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>October</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 11">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de noviembre de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>November</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:when test="/gamebook/meta/date[@class='publication']/month = 12">
     <xsl:choose>
      <xsl:when test="$language='es'"><xsl:text>de diciembre de</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>December</xsl:text></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>Invalid Month</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:text> </xsl:text>
   <xsl:value-of select="/gamebook/meta/date[@class='publication']/year" />
  </p>

  <xsl:apply-templates select="/gamebook/meta/rights[@class='license-notification']" />

  <xsl:value-of select="$newline" />

  <xsl:value-of select="$newline" />
 </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section[@id='toc']">
 <div class="frontmatter"><xsl:value-of select="$newline" />
  <h2>
   <xsl:choose>
    <xsl:when test="$language='es'">
     <xsl:text>&Iacute;ndice de Contenidos</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>Table of Contents</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </h2><xsl:value-of select="$newline" />

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <ul><xsl:value-of select="$newline" />
   <xsl:variable name="title-page">
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text>P&aacute;gina Principal</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>Title Page</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>

   <xsl:for-each select="/gamebook/section/data/section">
    <li>
     <a><xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="@id" /></xsl:attribute>
      <xsl:apply-templates select="meta/title[1]" />
     </a>
     <xsl:if test="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
      <xsl:value-of select="$newline" />
      <ul><xsl:value-of select="$newline" />
       <xsl:for-each select="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
        <li>
         <a><xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="@id" /></xsl:attribute>
          <xsl:value-of select ="meta/title[1]" />
         </a>
        </li><xsl:value-of select="$newline" />
       </xsl:for-each>
      </ul><xsl:value-of select="$newline" />
     </xsl:if>
    </li><xsl:value-of select="$newline" />
   </xsl:for-each>
  </ul><xsl:value-of select="$newline" />

 </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='frontmatter']">
 <div class="frontmatter"><xsl:value-of select="$newline" />
  <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h2>

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <xsl:apply-templates />
 </div>
</xsl:template>

<!-- :::::::::::: third-level front matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: fourth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">
 <h4><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h4>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
 <h5><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h5>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::: second-level main matter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='mainmatter']">
 <div class="mainmatter"><xsl:value-of select="$newline" />
  <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h2>

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <xsl:apply-templates />
 </div>
</xsl:template>

<!-- :::::::::::: third-level main matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter-separate']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: fourth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter']">
 <h4><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h4>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
 <h5><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h5>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <div class="numbered"><xsl:value-of select="$newline" />
  <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h2><xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <xsl:apply-templates/>

 </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='numbered']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h3><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />

 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: second-level backmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='backmatter']">
 <div class="frontmatter"><xsl:value-of select="$newline" />
  <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h2><xsl:value-of select="$newline" />

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <xsl:apply-templates />

  <xsl:value-of select="$newline" />

 </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::::: third-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
 <h4><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h4>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::::::::::: footnotes template ::::::::::::::::::::::::: -->

<xsl:template match="id( 'footnotz' )">
 <div class="backmatter">
  <xsl:value-of select="$newline" />
  <!-- No particular reason to code title here -->
  <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:apply-templates select="meta/title[1]" /></a></h2><xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />
   
  <!-- Generate list of footnotes -->
  <div class="footnote">
   <xsl:for-each select="//footnotes/footnote">
    <!-- will the list always contain the closest ancestor first? -->
    <xsl:variable name="footnote-section"><xsl:value-of select="ancestor::section[position()=1]/@id" /></xsl:variable>
    <xsl:variable name="footnote-marker"><xsl:number count="footnotes/footnote" from="/" level="any" format="1" /></xsl:variable>
    <xsl:variable name="footnote-id"><xsl:value-of select="@id" /></xsl:variable>
    <xsl:variable name="footnote-idref"><xsl:text>#</xsl:text><xsl:value-of select="@idref" /></xsl:variable>
     
    <xsl:for-each select="*[1]">
     <p>
      <xsl:text>[</xsl:text>
      <a>
       <xsl:attribute name="name"><xsl:value-of select="$footnote-id" /></xsl:attribute>
       <xsl:attribute name="href"><xsl:value-of select="$footnote-idref" /></xsl:attribute>
       <xsl:value-of select="$footnote-marker" />
      </a>
      <xsl:text>] </xsl:text>

      <xsl:text> (</xsl:text>
      <xsl:call-template name="section-title-link" />
      <xsl:text>) </xsl:text>

      <xsl:apply-templates select="child::* | child::text()" />
     </p>
    </xsl:for-each>
     
    <xsl:for-each select="*[position() != 1]">
     <xsl:apply-templates select="." />
    </xsl:for-each>
     
   </xsl:for-each>
  </div>
   
  <!-- Backwards compatibility... needed? Probably not. -->
  <xsl:apply-templates />
   
  <xsl:value-of select="$newline" />
  
 </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
</xsl:template>

<!-- ==================== block elements ======================== -->

<xsl:template match="p">
 <p><xsl:apply-templates /></p>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="p[@class='dedication']">
 <p class="dedication"><xsl:apply-templates /></p>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dl[@class='paragraphed']/dd/node() | ol[@class='paragraphed']/li/node() | ul[@class='paragraphed']/li/node()">
 <xsl:choose>
  <xsl:when test="self::p">
   <xsl:apply-templates /><br /><br /><xsl:value-of select="$newline" />
  </xsl:when>
  <xsl:when test="self::dl">
   <dl><xsl:value-of select="$newline" />
    <xsl:apply-templates />
   </dl><br /><br /><xsl:value-of select="$newline" />
  </xsl:when>
  <xsl:when test="self::ol">
   <ol><xsl:value-of select="$newline" />
    <xsl:apply-templates />
   </ol><br /><br /><xsl:value-of select="$newline" />
  </xsl:when>
  <xsl:when test="self::ul">
   <ul>
    <xsl:if test="self::*[@class='unbulleted']"><xsl:attribute name="class"><xsl:text>unbulleted</xsl:text></xsl:attribute></xsl:if>
    <xsl:value-of select="$newline" />
    <xsl:apply-templates />
   </ul><br /><br /><xsl:value-of select="$newline" />
  </xsl:when>
  <xsl:when test="self::blockquote">
   <blockquote><xsl:value-of select="$newline" />
    <xsl:apply-templates />
   </blockquote><xsl:value-of select="$newline" />
  </xsl:when>
  <xsl:when test="self::poetry">
   <blockquote class="poetry"><xsl:value-of select="$newline" />
    <xsl:apply-templates />
   </blockquote><xsl:value-of select="$newline" />
  </xsl:when>
  <xsl:when test="self::illustration"></xsl:when>
  <xsl:when test="self::illref"></xsl:when>
  <xsl:otherwise>
   <xsl:text>[error: paragraphed list template]</xsl:text>
   <xsl:message><xsl:text>error: paragraphed list template</xsl:text></xsl:message>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="ol">
 <ol><xsl:value-of select="$newline" />
  <xsl:apply-templates />
 </ol><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="ul">
 <ul>
  <xsl:if test="self::*[@class='unbulleted']"><xsl:attribute name="class"><xsl:text>unbulleted</xsl:text></xsl:attribute></xsl:if>
  <xsl:value-of select="$newline" />
  <xsl:apply-templates />
 </ul><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dl">
 <dl><xsl:value-of select="$newline" />
  <xsl:apply-templates />
 </dl><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dt">
 <dt><xsl:apply-templates /></dt>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dd">
 <dd><xsl:apply-templates /></dd>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="li">
 <li><xsl:apply-templates /></li>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="table">
 <table border="1" cellspacing="0" cellpadding="2">
  <xsl:if test="@summary"><xsl:attribute name="summary"><xsl:value-of select="@summary" /></xsl:attribute></xsl:if>
  <xsl:apply-templates />
 </table>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="caption">
 <caption>
  <xsl:apply-templates />
 </caption>
</xsl:template>

<xsl:template match="colgroup[@scope]">
 <colgroup>
  <xsl:attribute name="scope"><xsl:value-of select="@scope" /></xsl:attribute>
 </colgroup>
</xsl:template>

<xsl:template match="thead">
 <thead>
  <xsl:apply-templates />
 </thead>
</xsl:template>

<xsl:template match="tfoot">
 <tfoot>
  <xsl:apply-templates />
 </tfoot>
</xsl:template>

<xsl:template match="tbody">
 <tbody>
  <xsl:apply-templates />
 </tbody>
</xsl:template>

<xsl:template match="tr">
 <tr>
  <xsl:apply-templates />
 </tr>
</xsl:template>

<xsl:template match="th">
 <th>
  <xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align" /></xsl:attribute></xsl:if>
  <xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign" /></xsl:attribute></xsl:if>
  <xsl:if test="@char"><xsl:attribute name="char"><xsl:value-of select="@char" /></xsl:attribute></xsl:if>
  <xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan" /></xsl:attribute></xsl:if>
  <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute></xsl:if>
  <xsl:if test="@axis"><xsl:attribute name="axis"><xsl:value-of select="@axis" /></xsl:attribute></xsl:if>
  <xsl:if test="@scope"><xsl:attribute name="scope"><xsl:value-of select="@scope" /></xsl:attribute></xsl:if>
  <xsl:apply-templates />
 </th>
</xsl:template>

<xsl:template match="td">
 <td>
  <xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align" /></xsl:attribute></xsl:if>
  <xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign" /></xsl:attribute></xsl:if>
  <xsl:if test="@char"><xsl:attribute name="char"><xsl:value-of select="@char" /></xsl:attribute></xsl:if>
  <xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan" /></xsl:attribute></xsl:if>
  <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute></xsl:if>
  <xsl:if test="@axis"><xsl:attribute name="axis"><xsl:value-of select="@axis" /></xsl:attribute></xsl:if>
  <xsl:if test="@scope"><xsl:attribute name="scope"><xsl:value-of select="@scope" /></xsl:attribute></xsl:if>
  <xsl:apply-templates />
 </td>
</xsl:template>

<xsl:template match="combat">
 <p class="combat">
  <xsl:apply-templates select="enemy" />
  <xsl:text>: </xsl:text>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='combatskill']">
    <small>
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text>DESTREZA&nbsp;EN&nbsp;EL&nbsp;COMBATE</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>COMBAT&nbsp;SKILL</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
    </small>
    <xsl:text>&nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='combatskill']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='closecombatskill']">
    <small>
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text>CLOSE&nbsp;COMBAT&nbsp;SKILL</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>CLOSE&nbsp;COMBAT&nbsp;SKILL</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
    </small>
    <xsl:text>&nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
   </xsl:when>
  </xsl:choose>
  <xsl:text> &nbsp;&nbsp;</xsl:text>
  <small>
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text>RESISTENCIA</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>ENDURANCE</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </small>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='target']">
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text> (o </xsl:text><small>BLANCOS</small><xsl:text>)</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text> (</xsl:text><small>TARGET</small><xsl:text> points)</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='target']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='resistance']">
    <xsl:choose>
     <xsl:when test="$language='es'"></xsl:when>
     <xsl:otherwise>
      <xsl:text> (</xsl:text><small>RESISTANCE</small><xsl:text> points)</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='resistance']" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>&nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='endurance']" />
   </xsl:otherwise>
  </xsl:choose>
 </p>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="choice">
 <xsl:variable name="link">
  <xsl:value-of select="@idref" />
 </xsl:variable>

 <p class="choice">
  <xsl:for-each select="* | text()">
   <xsl:choose>
    <xsl:when test="self::link-text">
     <a href="#{$link}">
      <xsl:apply-templates />
     </a>
    </xsl:when>
    <xsl:otherwise>
     <xsl:apply-templates select="." />
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
 </p>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="data/signpost">
 <div class="signpost">
  <xsl:apply-templates />
 </div>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="signpost">
 <span class="signpost"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="blockquote">
 <blockquote><xsl:value-of select="$newline" />
  <xsl:apply-templates /><xsl:value-of select="$newline" />
 </blockquote><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="poetry">
 <blockquote class="poetry"><p><xsl:value-of select="$newline" />
  <xsl:apply-templates /><xsl:value-of select="$newline" />
 </p></blockquote><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="illref">
 <!-- It is important that the class is not checked right in the template - that would make this template match with higher priority, which will turn a few things upside down --> 
 <xsl:if test="@class='html'">
  <xsl:for-each select="id( @idref )">
   <!-- This creates unneccessary regeneration of float illustration pages, but it is easiest to keep things this way as long as we have to be backwards compatible... -->
   <!-- When backwards compatibility can be dropped, most of (all?) the <illustration> processing can happen here -->
   <xsl:apply-templates select="." />
  </xsl:for-each>
 </xsl:if>
</xsl:template>

<xsl:template match="illustrations">
 <ul class="unbulleted">
  <xsl:for-each select="illustration[contains( $use-illustrators, concat( ':', meta/creator, ':' ) )] | illgroup">
   <xsl:choose>
    <xsl:when test="self::illustration and @class='float'">
     <!-- List item with illustration name as link -->
     <li>
      <a>
       <xsl:attribute name="href"><xsl:text>ill</xsl:text><xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" /><xsl:text>.htm</xsl:text></xsl:attribute>
       <xsl:choose>
        <xsl:when test="$language='es'">
         <xsl:text>Ilustraci&oacute;n </xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>Illustration </xsl:text>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
      </a>
      <!-- List the sections that the illustration appears in -->
      <xsl:text> (</xsl:text>
      <xsl:for-each select="//illref[@class='html' and @idref=current()/@id]">
       <xsl:call-template name="section-title-link" />
       <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>        
       </xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text><xsl:value-of select="$newline" />
     </li>
     <!-- Call the backwards compatible template for generating the illustration page -->
    </xsl:when>
   </xsl:choose>
  </xsl:for-each>
 </ul><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="illustration">
 <xsl:choose>
  <xsl:when test="instance[@class='text'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:apply-templates select="instance[@class='text']/*"/>
  </xsl:when>
  <xsl:when test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:choose>
    <xsl:when test="@class='float'">
     <div class="illustration">
      <xsl:text>[Illustration </xsl:text>
      <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
      <xsl:text>]</xsl:text>
     </div><xsl:value-of select="$newline" />
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
   </xsl:choose>
  </xsl:when>
  <xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="instance" />

<xsl:template match="footnotes" />

<xsl:template match="footnote" />

<xsl:template match="hr">
 <hr />
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="choose">
 <xsl:choose>
  <xsl:when test="@test='has-numbered-section-list'">
   <xsl:choose>
    <xsl:when test="when[@value='false']">
     <xsl:apply-templates select="when[@value='false'][1]/node()" />
    </xsl:when>
    <xsl:when test="otherwise">
     <!-- this should only be applied when there is no option for "false" -->
     <xsl:apply-templates select="otherwise/node()" />
    </xsl:when>
   </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
   <xsl:message>
    <xsl:text>choose: unrecognized test "</xsl:text>
    <xsl:value-of select="@test" />
    <xsl:text>" - element ignored.</xsl:text>
   </xsl:message>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- ==================== inline elements ======================= -->

<xsl:template match="a">
 <xsl:choose>
  <xsl:when test="@href">
   <a>
    <xsl:attribute name="href"><xsl:value-of select="@href" /></xsl:attribute>
    <xsl:if test="@id"><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
    <xsl:apply-templates />
   </a>
  </xsl:when>
  <xsl:otherwise>
   <a>
    <xsl:if test="@idref">
     <xsl:attribute name="href">
      <xsl:text>#</xsl:text><xsl:value-of select="@idref" />
     </xsl:attribute>
    </xsl:if>
    <xsl:if test="@id"><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
    <xsl:apply-templates />
   </a>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- This template is obsolete, the "footref" element should be used instead -->
<xsl:template match="a[@class='footnote']">
 <!-- <xsl:message><xsl:text>WARNING: Obsolete &lt;a idref='...' class='footnote' /&gt; usage</xsl:text></xsl:message> -->
 <xsl:apply-templates />
 <sup>
  <a>
   <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="@idref" /></xsl:attribute>
   <xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:number count="a[@class='footnote']" from="/" level="any" format="1" />
  </a>
 </sup>
</xsl:template>

<!-- TODO: can this be made more uniform with illrefs? -->
<xsl:template match="a[@class='accent-illustration']"></xsl:template>

<xsl:template match="bookref">
 <a>
  <xsl:attribute name="href">
   <xsl:variable name="my-section">
    <xsl:choose>
     <xsl:when test="@section">
      <xsl:value-of select="@section" />
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>title</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <xsl:variable name="my-series">
    <!-- If series is specified, go one directory back and then to series. Otherwise, add nothing. -->
    <xsl:choose>
     <xsl:when test="@series">
      <xsl:text>../</xsl:text><xsl:value-of select="@series" />
     </xsl:when>
     <xsl:otherwise>
      <xsl:text></xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <xsl:value-of select="$my-series" /><xsl:text>/</xsl:text><xsl:value-of select="@book" /><xsl:text>.htm#</xsl:text><xsl:value-of select="$my-section" />
  </xsl:attribute>
  <xsl:if test="@id"><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
  <xsl:apply-templates />
 </a>
</xsl:template>

<xsl:template match="footref">
 <xsl:apply-templates />
 <sup>
  <a>
   <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="@idref" /></xsl:attribute>
   <xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:number count="footref" from="/" level="any" format="1" />
  </a>
 </sup>
</xsl:template>

<xsl:template match="em">
 <em><xsl:apply-templates /></em>
</xsl:template>

<xsl:template match="strong">
 <strong><xsl:apply-templates /></strong>
</xsl:template>

<xsl:template match="thought">
 <i><xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="onomatopoeia">
 <i><xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="spell">
 <i><xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="item">
 <strong><xsl:apply-templates /></strong>
</xsl:template>

<xsl:template match="foreign">
 <i>
  <xsl:attribute name="xml:lang">
   <xsl:value-of select="@xml:lang"/>
  </xsl:attribute>
  <xsl:apply-templates />
 </i>
</xsl:template>

<xsl:template match="quote">
 <xsl:text>&#8216;</xsl:text>
  <xsl:apply-templates />
 <xsl:if test="not(self::*[@class='open-ended'])"><xsl:text>&#8217;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="quote//quote">
 <xsl:text>&#8220;</xsl:text>
  <xsl:apply-templates />
 <xsl:if test="not(self::*[@class='open-ended'])"><xsl:text>&#8221;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="cite">
 <cite><xsl:apply-templates /></cite>
</xsl:template>

<xsl:template match="code">
 <tt><xsl:apply-templates /></tt>
</xsl:template>

<xsl:template match="line">
 <xsl:apply-templates />
 <xsl:if test="position( ) != last( )"><br /></xsl:if>
</xsl:template>

<xsl:template match="br">
 <br />
</xsl:template>

<xsl:template match="typ[@class='attribute']">
 <small><xsl:apply-templates /></small>
</xsl:template>

<!-- ==================== character elements ==================== -->
<!--

These templates define the mapping between the character elements used in
the Project Aon instances of Gamebook XML and the ISO-8859-1
characters.

Portions Copyright International Organization for Standardization 1986 
Permission to copy in any form is granted for use with conforming SGML 
systems and applications as defined in ISO 8879, provided this notice 
is included in all copies.

-->

<xsl:template match="ch.apos"><xsl:text>&#8217;</xsl:text></xsl:template><!-- apostrophe = single quotation mark -->
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
<xsl:template match="ch.emdash">&#8212;</xsl:template><!-- emdash -->
<xsl:template match="ch.ellips">&#8230;</xsl:template><!-- ellipsis -->
<xsl:template match="ch.lellips">&#8230;</xsl:template><!-- left ellipsis, used at the beginning of edited material -->
<xsl:template match="ch.blankline">_______</xsl:template><!-- blank line to be filled in -->
<xsl:template match="ch.percent"><xsl:text>&#37;</xsl:text></xsl:template><!-- percent sign -->
<xsl:template match="ch.thinspace"><xsl:text>&#8201;</xsl:text></xsl:template><!-- small horizontal space for use between adjacent quotation marks - added mainly for LaTeX's sake -->
<xsl:template match="ch.frac116"><xsl:text>1/16</xsl:text></xsl:template><!-- vulgar fraction one sixteenth = fraction on sixteenth -->
<xsl:template match="ch.plus"><xsl:text>+</xsl:text></xsl:template><!-- mathematical plus -->

<!-- ==================== named templates ======================= -->

<!--
 A "subroutine" to generate a link to the current section, with the section title (expanded with "Section " in case of a numbered section) as link text.
-->
<xsl:template name="section-title-link">
 <!-- will the list always contain the closest ancestor first? -->
 <xsl:variable name="section-title">
  <!-- numbered or not? -->
  <xsl:if test="ancestor::section[position()=1]/@class='numbered'">
   <xsl:choose>
    <xsl:when test="$language='es'">
     <xsl:text>Secci&oacute;n </xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>Section </xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
  <xsl:apply-templates select="ancestor::section[position()=1]/meta/title[1]" />
 </xsl:variable>
 
 <a>
  <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="ancestor::section[position()=1]/@id" /></xsl:attribute>
  <xsl:value-of select="$section-title" />
 </a>
</xsl:template>

</xsl:transform>
