<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
 <!ENTITY % xhtml.characters SYSTEM "htmlchar.mod">
 %xhtml.characters;
]>

<!--

$Id$

$Log$
Revision 1.1  2005/01/30 01:32:52  jonathan.blake
Initial freepository revision of XML support documents.

Revision 1.1  2003/01/15 17:24:02  jblake
Initial revision - originally xhtml.xsl:

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
  xmlns:lxslt="http://xml.apache.org/xslt">

<xsl:output method="html"
            encoding="ISO-8859-1"
            omit-xml-declaration="yes"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

<xsl:strip-space elements="gamebook section meta data ol ul dl li dd footnotes footnote illustration instance" />
<xsl:preserve-space elements="p choice" />

<!-- ====================== parameters ========================== -->

<xsl:param name="book-path"><xsl:text>undefined-book</xsl:text></xsl:param>
<xsl:param name="use-illustrators" />

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~ colors ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<xsl:param name="link-color"><xsl:text>#ff0000</xsl:text></xsl:param>
<xsl:param name="alink-color"><xsl:value-of select="$link-color" /></xsl:param>
<xsl:param name="vlink-color"><xsl:value-of select="$link-color" /></xsl:param>

<xsl:param name="text-color"><xsl:text>#000000</xsl:text></xsl:param>
<xsl:param name="background-color"><xsl:text>#ffffe4</xsl:text></xsl:param>

<!-- ======================= variables ========================== -->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<!-- ======================== Templates ========================= -->

<!-- ================= hierarchical sections ==================== -->

<xsl:template match="meta" />
<xsl:template match="section" />

<!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

<xsl:template match="/gamebook/section[@id='title']">
 <html xml:lang="en-UK" lang="en-UK">

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <head><xsl:value-of select="$newline" />
   <title>
    <xsl:value-of select="/gamebook/meta/title[1]" />
   </title><xsl:value-of select="$newline" />
   <meta http-equiv="Content-type" content="text/html; charset=ISO-8859-1" /><xsl:value-of select="$newline" />
   <meta name="robots" content="noindex,nofollow" /><xsl:value-of select="$newline" />
   <link rel="stylesheet" href="main.css" type="text/css" /><xsl:value-of select="$newline" />
  </head>

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <xsl:comment>
   <xsl:text> </xsl:text>
   <xsl:apply-templates select="/gamebook/meta/rights[@class='copyrights']" />
   <xsl:text> Published by </xsl:text>
   <xsl:value-of select="/gamebook/meta/publisher[1]" />
   <xsl:text>. </xsl:text>
  </xsl:comment>

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

  <body>
   <xsl:attribute name="text"><xsl:value-of select="$text-color" /></xsl:attribute>
   <xsl:attribute name="bgcolor"><xsl:value-of select="$background-color" /></xsl:attribute>
   <xsl:attribute name="background"><xsl:text>bckgrnd.gif</xsl:text></xsl:attribute>
   <xsl:attribute name="link"><xsl:value-of select="$link-color" /></xsl:attribute>
   <xsl:attribute name="alink"><xsl:value-of select="$alink-color" /></xsl:attribute>
   <xsl:attribute name="vlink"><xsl:value-of select="$vlink-color" /></xsl:attribute>

   <xsl:value-of select="$newline" />
   <h1 id="title"><xsl:value-of select="/gamebook/meta/title[1]" /></h1><xsl:value-of select="$newline" />
   <div id="body"><xsl:value-of select="$newline" />

    <div class="frontmatter"><xsl:value-of select="$newline" />

     <xsl:apply-templates select="/gamebook/meta/description[@class='blurb']" />
     <xsl:apply-templates select="/gamebook/meta/creator[@class='long']" />

     <hr />

     <xsl:apply-templates select="/gamebook/meta/description[@class='publication']" />

     <p>
      <xsl:text>Publication Date: </xsl:text>
      <xsl:value-of select="/gamebook/meta/date[@class='publication']/day" />
      <xsl:text> </xsl:text>
      <xsl:choose>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 1">
        <xsl:text>January</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 2">
        <xsl:text>February</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 3">
        <xsl:text>March</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 4">
        <xsl:text>April</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 5">
        <xsl:text>May</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 6">
        <xsl:text>June</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 7">
        <xsl:text>July</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 8">
        <xsl:text>August</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 9">
        <xsl:text>September</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 10">
        <xsl:text>October</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 11">
        <xsl:text>November</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/meta/date[@class='publication']/month = 12">
        <xsl:text>December</xsl:text>
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

     <xsl:apply-templates select="data/section[@class='frontmatter']" />

    </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

    <div class="mainmatter"><xsl:value-of select="$newline" />
     <xsl:apply-templates select="/gamebook/section/data/section[@class='mainmatter']" />
     <xsl:apply-templates select="/gamebook/section/data/section[@class='glossary']" />
    </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

    <div class="numbered"><xsl:value-of select="$newline" />
     <xsl:apply-templates select="/gamebook/section/data/section[@class='numbered']" />
    </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

    <div class="backmatter"><xsl:value-of select="$newline" />
     <xsl:apply-templates select="/gamebook/section/data/section[@class='backmatter']" />
    </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

    <div id="footnotes">
     <h2>Footnotes</h2><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
     <xsl:for-each select="//footnote">
      <xsl:variable name="footnote-idref" select="@idref" />
      <xsl:variable name="footnote-id" select="@id" />
      <xsl:variable name="footnote-marker"><xsl:number count="footnotes/footnote" from="/" level="any" format="1" /></xsl:variable>
      <xsl:for-each select="*">
       <xsl:choose>
        <xsl:when test="preceding-sibling::node( )">
         <xsl:apply-templates select="." />
        </xsl:when>
        <xsl:otherwise>
         <p>
          <xsl:text>[</xsl:text>
           <a href="#{$footnote-idref}" name="{$footnote-id}"><xsl:value-of select="$footnote-marker" /></a>
          <xsl:text>] </xsl:text>
          <xsl:apply-templates select="child::node()" />
         </p>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:for-each>
     </xsl:for-each>
    </div><xsl:value-of select="$newline" />

   </div><xsl:value-of select="$newline" />
  </body>

  <xsl:value-of select="$newline" />
  <xsl:value-of select="$newline" />

 </html>
</xsl:template>

<xsl:template match="/gamebook/section[@id='toc']" />

<!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='frontmatter']">
 <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h2><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: third-level frontmatter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter' or @class='frontmatter-separate']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h3><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: fourth-level frontmatter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">
 <h4><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h4><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::::: fifth-level frontmatter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
 <h5><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h5><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::: second-level main matter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='mainmatter']">
 <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h2><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: third-level main matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter' or @class='mainmatter-separate']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h3><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: fourth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter']">
 <h4><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h4><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
 <h5><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h5><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: second-level glossary sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='glossary']">
 <xsl:variable name="glossary-id-prefix"><xsl:text>topics</xsl:text></xsl:variable>
 <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h2><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: third-level glossary sections ::::::::::::: -->
<!-- glossary sections should be enclosed in a second level glossary section -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='glossary']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h3><xsl:value-of select="$newline" />
 <xsl:call-template name="alpha-bar">
  <xsl:with-param name="alpha-bar-id-prefix">topics</xsl:with-param>
 </xsl:call-template>
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h2><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='numbered']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h3><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- :::::::::::: second-level backmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='backmatter']">
 <h2><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h2><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::::: third-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">
 <h3><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h3><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
 <h4><a><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute><xsl:value-of select="meta/title" /></a></h4><xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:value-of select="$newline" />
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
  <xsl:when test="self::illustration" />
  <xsl:otherwise>
   <xsl:text>[error: paragraphed list template]</xsl:text>
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
  <xsl:apply-templates />
 </table>
 <xsl:value-of select="$newline" />
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
  <xsl:apply-templates />
 </th>
</xsl:template>

<xsl:template match="td">
 <td>
  <xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align" /></xsl:attribute></xsl:if>
  <xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign" /></xsl:attribute></xsl:if>
  <xsl:if test="@char"><xsl:attribute name="char"><xsl:value-of select="@char" /></xsl:attribute></xsl:if>
  <xsl:apply-templates />
 </td>
</xsl:template>

<xsl:template match="combat">
 <p class="combat">
  <xsl:apply-templates select="enemy" />
  <xsl:text>: </xsl:text>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='combatskill']">
    <span class="smallcaps">COMBAT<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>SKILL</span>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='combatskill']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='closecombatskill']">
    <span class="smallcaps">CLOSE<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>COMBAT<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>SKILL</span>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
   </xsl:when>
  </xsl:choose>
  <xsl:text disable-output-escaping="yes"> &amp;nbsp;&amp;nbsp;</xsl:text>
  <span class="smallcaps">ENDURANCE</span>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='target']">
    <xsl:text> (</xsl:text><span class="smallcaps">TARGET</span><xsl:text> points)</xsl:text>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='target']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='resistance']">
    <xsl:text> (</xsl:text><span class="smallcaps">RESISTANCE</span><xsl:text> points)</xsl:text>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='resistance']" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
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

<xsl:template match="signpost">
 <div class="signpost">
  <xsl:apply-templates />
 </div>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="blockquote">
 <blockquote><xsl:value-of select="$newline" />
  <xsl:apply-templates /><xsl:value-of select="$newline" />
 </blockquote><xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="illustration" />

<xsl:template match="instance" />

<xsl:template match="footnotes" />

<xsl:template match="footnote" />

<xsl:template match="hr">
 <hr />
 <xsl:value-of select="$newline" />
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
     <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="@idref" /></xsl:attribute>
    </xsl:if>
    <xsl:if test="@id">
     <xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates />
   </a>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="a[@class='footnote']">
 <xsl:apply-templates />
 <sup>
  <a>
   <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="@idref" /></xsl:attribute>
   <xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
   <xsl:number count="a[@class='footnote']" from="/" level="any" format="1" />
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
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="foreign">
 <i><xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="quote">
 <xsl:text>&apos;</xsl:text>
  <xsl:apply-templates />
 <xsl:text>&apos;</xsl:text>
</xsl:template>

<xsl:template match="quote//quote">
 <xsl:text>&quot;</xsl:text>
  <xsl:apply-templates />
 <xsl:text>&quot;</xsl:text>
</xsl:template>

<xsl:template match="cite">
 <cite><xsl:apply-templates /></cite>
</xsl:template>

<xsl:template match="code">
 <tt><xsl:apply-templates /></tt>
</xsl:template>

<xsl:template match="br">
 <br />
</xsl:template>

<xsl:template match="typ[@class='attribute']">
 <span class="smallcaps"><xsl:apply-templates /></span>
</xsl:template>

<!-- ==================== named templates ======================= -->

<xsl:template name="alpha-bar">
 <xsl:param name="alpha-bar-id-prefix"></xsl:param>

  <p class="navigation">[<a href="#{$alpha-bar-id-prefix}a">A</a>&nbsp;<a href="#{$alpha-bar-id-prefix}b">B</a>&nbsp;<a href="#{$alpha-bar-id-prefix}c">C</a>&nbsp;<a href="#{$alpha-bar-id-prefix}d">D</a>&nbsp;<a href="#{$alpha-bar-id-prefix}e">E</a>&nbsp;<a href="#{$alpha-bar-id-prefix}f">F</a>&nbsp;<a href="#{$alpha-bar-id-prefix}g">G</a>&nbsp;<a href="#{$alpha-bar-id-prefix}h">H</a>&nbsp;<a href="#{$alpha-bar-id-prefix}i">I</a>&nbsp;<a href="#{$alpha-bar-id-prefix}j">J</a>&nbsp;<a href="#{$alpha-bar-id-prefix}k">K</a>&nbsp;<a href="#{$alpha-bar-id-prefix}l">L</a>&nbsp;<a href="#{$alpha-bar-id-prefix}m">M</a>&nbsp;<a href="#{$alpha-bar-id-prefix}n">N</a>&nbsp;<a href="#{$alpha-bar-id-prefix}o">O</a>&nbsp;<a href="#{$alpha-bar-id-prefix}p">P</a>&nbsp;<a href="#{$alpha-bar-id-prefix}q">Q</a>&nbsp;<a href="#{$alpha-bar-id-prefix}r">R</a>&nbsp;<a href="#{$alpha-bar-id-prefix}s">S</a>&nbsp;<a href="#{$alpha-bar-id-prefix}t">T</a>&nbsp;<a href="#{$alpha-bar-id-prefix}u">U</a>&nbsp;<a href="#{$alpha-bar-id-prefix}v">V</a>&nbsp;<a href="#{$alpha-bar-id-prefix}w">W</a>&nbsp;<a href="#{$alpha-bar-id-prefix}x">X</a>&nbsp;<a href="#{$alpha-bar-id-prefix}y">Y</a>&nbsp;<a href="#{$alpha-bar-id-prefix}z">Z</a>]</p><xsl:value-of select="$newline" />

</xsl:template>

</xsl:transform>