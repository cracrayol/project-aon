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
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:redirect="org.apache.xalan.lib.Redirect"
  extension-element-prefixes="redirect">

<xsl:output method="xml"
            encoding="ISO-8859-1"
            omit-xml-declaration="yes"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

<xsl:strip-space elements="section data ol ul dl li dd footnotes footnote" />
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
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">top-level</xsl:with-param>
  <xsl:with-param name="filename">title</xsl:with-param>
 </xsl:call-template>

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section[@id='toc']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">toc</xsl:with-param>
  <xsl:with-param name="filename">toc</xsl:with-param>
 </xsl:call-template>

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='frontmatter']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">second-level-frontmatter</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::: third-level front matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter']">
 <h3><xsl:value-of select="meta/title[1]" /></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">third-level-frontmatter-separate</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::: fourth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">
 <h4><xsl:value-of select="meta/title[1]" /></h4>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
 <h5><xsl:value-of select="meta/title[1]" /></h5>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::: second-level main matter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='mainmatter']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">second-level-mainmatter</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::: third-level main matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter']">
 <h3><xsl:value-of select="meta/title[1]" /></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter-separate']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">third-level-mainmatter-separate</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::: fourth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter']">
 <h4><xsl:value-of select="meta/title[1]" /></h4>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
 <h5><xsl:value-of select="meta/title[1]" /></h5>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: second-level glossary sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='glossary']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">second-level-glossary</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
  <xsl:with-param name="glossary-id-prefix">topics</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::: third-level glossary sections ::::::::::::: -->
<!-- glossary sections should be enclosed in a second level glossary section -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='glossary']">
 <h3><xsl:value-of select="meta/title[1]" /></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='glossary-separate']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">third-level-glossary-separate</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
  <xsl:with-param name="glossary-id-prefix">topics</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">second-level-numbered</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='numbered']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">third-level-numbered</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- :::::::::::: second-level backmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='backmatter']">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">second-level-backmatter</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!-- ::::::::::::: third-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">
 <h3><xsl:value-of select="meta/title[1]" /></h3>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
 <h4><xsl:value-of select="meta/title[1]" /></h4>

 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::::::::::: map template ::::::::::::::::::::::::: -->

<xsl:template match="id( 'map' )">
 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">map-adjusted</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
 </xsl:call-template>

 <xsl:call-template name="xhtml-wrapper">
  <xsl:with-param name="document-type">map</xsl:with-param>
  <xsl:with-param name="filename"><xsl:value-of select="@id" /><xsl:text>large</xsl:text></xsl:with-param>
 </xsl:call-template>
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
  <xsl:when test="self::illustration">
   <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
   <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
   <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

   <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
    <div class="illustration"><div align="center"><xsl:value-of select="$newline" />
     <table border="0" cellpadding="0" cellspacing="0"><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrtpl.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrtp.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrtpr.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrl.gif" width="32" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="{$illustration-src}" width="{$illustration-width}" height="{$illustration-height}" border="0" align="middle" alt="[illustration]" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrr.gif" width="32" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrbtl.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrbt.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrbtr.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
     </table><br /><xsl:value-of select="$newline" />
    </div></div><xsl:value-of select="$newline" />
   </xsl:if>
  </xsl:when>
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
     <a href="{$link}.htm">
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

<xsl:template match="illustration">
 <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
 <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
 <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

 <xsl:variable name="illustration-width-adjusted"><xsl:number value="$illustration-width div 2" /></xsl:variable>
 <xsl:variable name="illustration-height-adjusted"><xsl:number value="$illustration-height div 2" /></xsl:variable>

 <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
  <xsl:choose>
   <xsl:when test="@class='float'">
    <div class="illustration"><div align="center"><xsl:value-of select="$newline" />
     <table border="0" cellpadding="0" cellspacing="0"><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrtpl.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrtp.gif" width="{$illustration-width-adjusted}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrtpr.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrl.gif" width="32" height="{$illustration-height-adjusted}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
        <td>
        <a>
         <xsl:attribute name="href"><xsl:text>ill</xsl:text><xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" /><xsl:text>.htm</xsl:text></xsl:attribute>
         <img src="{$illustration-src}" width="{$illustration-width-adjusted}" height="{$illustration-height-adjusted}" border="0" align="middle" alt="[illustration]" />
        </a>
       </td><xsl:value-of select="$newline" />
       <td><img src="brdrr.gif" width="32" height="{$illustration-height-adjusted}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrbtl.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrbt.gif" width="{$illustration-width-adjusted}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrbtr.gif" width="32" height="32" align="middle" alt=""/></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
     </table><br /><xsl:value-of select="$newline" />
    </div></div><xsl:value-of select="$newline" />

    <xsl:call-template name="xhtml-wrapper">
     <xsl:with-param name="document-type">illustration</xsl:with-param>
     <xsl:with-param name="filename"><xsl:text>ill</xsl:text><xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) ) ]" from="/" level="any" format="1" /></xsl:with-param>
    </xsl:call-template>
   </xsl:when>

   <xsl:when test="@class='accent'" />

   <xsl:otherwise>
    <div class="illustration"><div align="center"><xsl:value-of select="$newline" />
     <table border="0" cellpadding="0" cellspacing="0"><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrtpl.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrtp.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrtpr.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrl.gif" width="32" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="{$illustration-src}" width="{$illustration-width}" height="{$illustration-height}" border="0" align="middle" alt="[illustration]" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrr.gif" width="32" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
      <tr><xsl:value-of select="$newline" />
       <td><img src="brdrbtl.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrbt.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
       <td><img src="brdrbtr.gif" width="32" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
      </tr><xsl:value-of select="$newline" />
     </table><br /><xsl:value-of select="$newline" />
    </div></div><xsl:value-of select="$newline" />
   </xsl:otherwise>
  </xsl:choose>

 </xsl:if>
</xsl:template>

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
     <xsl:variable name="my-idref" select="@idref" />
     <xsl:attribute name="href">
      <xsl:choose>
       <!-- The order of these tests is deliberate. They are ordered roughly from most to least specific. -->
       <xsl:when test="/gamebook/section[@id=$my-idref] | /gamebook/section/data/section[@id=$my-idref]">
        <xsl:value-of select="$my-idref" /><xsl:text>.htm</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and @id=$my-idref]">
        <xsl:value-of select="$my-idref" /><xsl:text>.htm</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and @id=$my-idref]">
        <xsl:value-of select="$my-idref" /><xsl:text>.htm</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='numbered' and @id=$my-idref]">
        <xsl:value-of select="$my-idref" /><xsl:text>.htm</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='glossary-separate' and @id=$my-idref]">
        <xsl:value-of select="$my-idref" /><xsl:text>.htm</xsl:text>
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and descendant::*[@id=$my-idref]]">
        <xsl:value-of select="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and descendant::*[@id=$my-idref]]/@id" /><xsl:text>.htm#</xsl:text><xsl:value-of select="$my-idref" />
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and descendant::*[@id=$my-idref]]">
        <xsl:value-of select="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and descendant::*[@id=$my-idref]]/@id" /><xsl:text>.htm#</xsl:text><xsl:value-of select="$my-idref" />
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section/data/section[@class='glossary-separate' and descendant::*[@id=$my-idref]]">
        <xsl:value-of select="/gamebook/section/data/section/data/section[@class='glossary-separate' and descendant::*[@id=$my-idref]]/@id" /><xsl:text>.htm#</xsl:text><xsl:value-of select="$my-idref" />
       </xsl:when>
       <xsl:when test="/gamebook/section/data/section[descendant::*[@id=$my-idref]]">
        <xsl:value-of select="/gamebook/section/data/section[descendant::*[@id=$my-idref]]/@id" /><xsl:text>.htm#</xsl:text><xsl:value-of select="$my-idref" />
       </xsl:when>
       <xsl:otherwise>
        <xsl:text>[error: a template]</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
    </xsl:if>
    <xsl:if test="@id"><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
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

<xsl:template match="a[@class='accent-illustration']">
 <xsl:for-each select="id( @idref )">
  <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />
  <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
  <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
  <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <img src="{$illustration-src}" class="accent" width="{$illustration-width}" height="{$illustration-height}" alt="" border="" align="left" />
  </xsl:if>
 </xsl:for-each>
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

<xsl:template name="xhtml-wrapper">
 <xsl:param name="document-type">undefined</xsl:param>
 <xsl:param name="filename">undefined</xsl:param>
 <xsl:param name="glossary-id-prefix"></xsl:param>

<!-- <redirect:write file="{$book-path}/{$filename}.htm">-->
 <redirect:write file="{$filename}.htm">
  <xsl:fallback>
   <xsl:text>xhtml-wrapper: Cannot write to filename: "</xsl:text>
   <xsl:value-of select="$filename" /><xsl:text>.htm"</xsl:text>
  </xsl:fallback>

  <html xml:lang="en-UK" lang="en-UK">

   <xsl:value-of select="$newline" />
   <xsl:value-of select="$newline" />

   <head><xsl:value-of select="$newline" />
    <title>
     <xsl:value-of select="/gamebook/meta/title[1]" />
     <xsl:text>: </xsl:text>
     <xsl:choose>
      <xsl:when test="$document-type='illustration'">
       <xsl:text>Illustration </xsl:text>
       <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="meta/title[1]" /></xsl:otherwise>
     </xsl:choose>
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
    <xsl:apply-templates select="/gamebook/meta/publisher[1]" />
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
    <div id="title"><img src="title.gif" width="550" height="100" border="0" align="middle" usemap="#imagemap"><xsl:attribute name="alt"><xsl:value-of select="/gamebook/meta/title[1]" /></xsl:attribute></img></div><xsl:value-of select="$newline" />
    <div id="body"><xsl:value-of select="$newline" />

     <xsl:choose>

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~ top-level ~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='top-level'">
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

        <xsl:call-template name="navigation-bar" />

        <xsl:value-of select="$newline" />
       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~ toc ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='toc'">
       <div class="frontmatter"><xsl:value-of select="$newline" />
        <h2>Table of Contents</h2><xsl:value-of select="$newline" />

        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <ul><xsl:value-of select="$newline" />
         <li><a href="title.htm">Title Page</a></li><xsl:value-of select="$newline" />
         <xsl:for-each select="/gamebook/section/data/section">
          <li>
           <a><xsl:attribute name="href"><xsl:value-of select="@id" /><xsl:text>.htm</xsl:text></xsl:attribute>
            <xsl:value-of select="meta/title[1]" />
           </a>
           <xsl:if test="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
            <xsl:value-of select="$newline" />
            <ul><xsl:value-of select="$newline" />
             <xsl:for-each select="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
              <li>
               <a><xsl:attribute name="href"><xsl:value-of select="@id" /><xsl:text>.htm</xsl:text></xsl:attribute>
                <xsl:value-of select ="meta/title[1]" />
               </a>
              </li><xsl:value-of select="$newline" />
             </xsl:for-each>
            </ul><xsl:value-of select="$newline" />
           </xsl:if>
          </li><xsl:value-of select="$newline" />
         </xsl:for-each>
        </ul><xsl:value-of select="$newline" />

        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />
        <xsl:call-template name="navigation-bar" />
       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~ second-level-frontmatter ~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='second-level-frontmatter'">
       <div class="frontmatter"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />

        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />

       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~ third-level-frontmatter-separate ~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='third-level-frontmatter-separate'">
       <div class="frontmatter"><xsl:value-of select="$newline" />
        <h3><xsl:value-of select="meta/title" /></h3><xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />

       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~ second-level-mainmatter ~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='second-level-mainmatter'">
       <div class="mainmatter"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />

       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~ third-level-mainmatter-separate ~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='third-level-mainmatter-separate'">
       <div class="mainmatter"><xsl:value-of select="$newline" />
        <h3><xsl:value-of select="meta/title" /></h3><xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />

       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~ second-level-glossary ~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='second-level-glossary'">
       <div class="mainmatter"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="alpha-bar">
         <xsl:with-param name="alpha-bar-id-prefix"><xsl:value-of select="$glossary-id-prefix" /></xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="navigation-bar" />

       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~ third-level-glossary-separate ~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='third-level-glossary-separate'">
       <div class="glossary"><xsl:value-of select="$newline" />
        <h3><xsl:value-of select="meta/title" /></h3><xsl:value-of select="$newline" />
        <xsl:call-template name="alpha-bar">
         <xsl:with-param name="alpha-bar-id-prefix"><xsl:value-of select="$glossary-id-prefix" /></xsl:with-param>
        </xsl:call-template>

        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />
        <xsl:value-of select="$newline" />
       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~ second-level-numbered ~~~~~~~~~~~~~~~~~~~~ -->
<!--

The following automatically generated section list requires that the
title of each section be a simple number.

-->
      <xsl:when test="$document-type='second-level-numbered'">
       <div class="numbered"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:variable name="base-section-number" select="number( data/section[1]/meta/title ) - 1" />
        <p>
         <xsl:for-each select="data/section">
          <xsl:if test="position( ) mod 10 = 1">
           <b><a><xsl:attribute name="name"><xsl:value-of select="position( ) + $base-section-number" /></xsl:attribute>
            <xsl:value-of select="position( ) + $base-section-number" />
            <xsl:if test="not( position( ) = last( ) )">
             <xsl:text>-</xsl:text>
             <xsl:choose>
              <xsl:when test="position( ) + 9 &lt;= last( )">
               <xsl:value-of select="position( ) + 9 + $base-section-number" />
              </xsl:when>
              <xsl:otherwise>
               <xsl:value-of select="last( ) + $base-section-number" />
              </xsl:otherwise>
             </xsl:choose>
            </xsl:if>
           </a><xsl:text>: </xsl:text></b>
          </xsl:if>
          <a>
           <xsl:attribute name="href"><xsl:value-of select="@id" /><xsl:text>.htm</xsl:text></xsl:attribute>
           <xsl:value-of select="meta/title" />
          </a>
          <xsl:choose>
           <xsl:when test="position( ) mod 10 = 0">
            <br /><xsl:value-of select="$newline" />
           </xsl:when>
           <xsl:otherwise>
            <xsl:text> </xsl:text>
           </xsl:otherwise>
          </xsl:choose>
         </xsl:for-each>
        </p>

        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />
        <xsl:value-of select="$newline" />
       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~ third-level-numbered ~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='third-level-numbered'">
       <div class="numbered"><xsl:value-of select="$newline" />
        <h3><xsl:value-of select="meta/title" /></h3><xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />
        <xsl:call-template name="navigation-bar" />
        <xsl:value-of select="$newline" />
       </div>
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~ second-level-backmatter ~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='second-level-backmatter'">
       <div class="frontmatter"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />

        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates />

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />
        <xsl:value-of select="$newline" />
       </div><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~~~~~~ map-adjusted ~~~~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='map-adjusted'">
       <div class="frontmatter"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />

        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:for-each select="data/* | data/text()">
         <xsl:choose>
          <xsl:when test="self::illustration and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
           <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
           <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
           <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

           <xsl:variable name="illustration-width-adjusted"><xsl:number value="386" /></xsl:variable>
           <xsl:variable name="illustration-height-adjusted"><xsl:number value="$illustration-height * $illustration-width-adjusted div $illustration-width" /></xsl:variable>

           <div class="illustration"><div align="center"><xsl:value-of select="$newline" />
            <table border="0" cellpadding="0" cellspacing="0"><xsl:value-of select="$newline" />
             <tr><xsl:value-of select="$newline" />
              <td><img src="brdrtpl.gif" width="31" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrtp.gif" width="{$illustration-width-adjusted}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrtpr.gif" width="33" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
             </tr><xsl:value-of select="$newline" />
             <tr><xsl:value-of select="$newline" />
              <td><img src="brdrl.gif" width="31" height="{$illustration-height-adjusted}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><a href="maplarge.htm"><img src="{$illustration-src}" width="{$illustration-width-adjusted}" height="{$illustration-height-adjusted}" align="middle" border="0" alt="[map]" /></a></td><xsl:value-of select="$newline" />
              <td><img src="brdrr.gif" width="33" height="{$illustration-height-adjusted}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
             </tr><xsl:value-of select="$newline" />
             <tr><xsl:value-of select="$newline" />
              <td><img src="brdrbtl.gif" width="31" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrbt.gif" width="{$illustration-width-adjusted}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrbtr.gif" width="33" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
             </tr><xsl:value-of select="$newline" />
            </table><xsl:value-of select="$newline" />
            <br /><br />
           </div></div><xsl:value-of select="$newline" />
          </xsl:when>
          <xsl:otherwise>
           <xsl:apply-templates select="." />
          </xsl:otherwise>
         </xsl:choose>
        </xsl:for-each>

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />
        <xsl:value-of select="$newline" />
       </div>
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~ map ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='map'">
       <div class="frontmatter"><xsl:value-of select="$newline" />
        <h2><xsl:value-of select="meta/title" /></h2><xsl:value-of select="$newline" />

        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:for-each select="data/* | data/text()">
         <xsl:choose>
          <xsl:when test="self::illustration and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
           <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
           <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
           <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

           <div class="illustration"><div align="center"><xsl:value-of select="$newline" />
            <table border="0" cellpadding="0" cellspacing="0"><xsl:value-of select="$newline" />
             <tr><xsl:value-of select="$newline" />
              <td><img src="brdrtpl.gif" width="31" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrtp.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrtpr.gif" width="33" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
             </tr><xsl:value-of select="$newline" />
             <tr><xsl:value-of select="$newline" />
              <td><img src="brdrl.gif" width="31"  height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><a href="map.htm"><img src="{$illustration-src}" width="{$illustration-width}" height="{$illustration-height}" align="middle" border="0" alt="[map]" /></a></td><xsl:value-of select="$newline" />
              <td><img src="brdrr.gif" width="33" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
             </tr><xsl:value-of select="$newline" />
             <tr><xsl:value-of select="$newline" />
              <td><img src="brdrbtl.gif" width="31" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrbt.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
              <td><img src="brdrbtr.gif" width="33" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
             </tr><xsl:value-of select="$newline" />
            </table><br /><xsl:value-of select="$newline" />
           </div></div><xsl:value-of select="$newline" />
          </xsl:when>
          <xsl:otherwise>
           <xsl:apply-templates select="." />
          </xsl:otherwise>
         </xsl:choose>
        </xsl:for-each>

        <xsl:value-of select="$newline" />

        <xsl:call-template name="navigation-bar" />
        <xsl:value-of select="$newline" />
       </div>
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~~~~~ illustration ~~~~~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:when test="$document-type='illustration'">
       <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
       <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
       <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

       <h3>
        <xsl:text>Illustration </xsl:text>
        <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
       </h3><xsl:value-of select="$newline" />

       <div class="illustration"><div align="center"><xsl:value-of select="$newline" />
        <table border="0" cellpadding="0" cellspacing="0"><xsl:value-of select="$newline" />
         <tr><xsl:value-of select="$newline" />
          <td><img src="brdrtpl.gif" width="31" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
          <td><img src="brdrtp.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
          <td><img src="brdrtpr.gif" width="33" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
         </tr><xsl:value-of select="$newline" />
         <tr><xsl:value-of select="$newline" />
          <td><img src="brdrl.gif" width="31" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
          <td><img src="{$illustration-src}" width="{$illustration-width}" height="{$illustration-height}" align="middle" border="0" alt="[illustration]" /></td><xsl:value-of select="$newline" />
          <td><img src="brdrr.gif" width="33" height="{$illustration-height}" align="middle" alt="" /></td><xsl:value-of select="$newline" />
         </tr><xsl:value-of select="$newline" />
         <tr><xsl:value-of select="$newline" />
          <td><img src="brdrbtl.gif" width="31" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
          <td><img src="brdrbt.gif" width="{$illustration-width}" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
          <td><img src="brdrbtr.gif" width="33" height="32" align="middle" alt="" /></td><xsl:value-of select="$newline" />
         </tr><xsl:value-of select="$newline" />
        </table><br /><xsl:value-of select="$newline" />
       </div></div><xsl:value-of select="$newline" />
       <p class="caption"><strong><xsl:apply-templates select="meta/description" /></strong></p><xsl:value-of select="$newline" />
      </xsl:when>

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ error ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

      <xsl:otherwise>
       <xsl:message>
        <xsl:text>xhtml-wrapper: Cannot process document of type "</xsl:text>
        <xsl:value-of select="$document-type" />
        <xsl:text>".</xsl:text>
       </xsl:message>
       <p>
        <xsl:text>xhtml-wrapper: Cannot process document of type "</xsl:text>
        <xsl:value-of select="$document-type" />
        <xsl:text>".</xsl:text>
       </p>
      </xsl:otherwise>

     </xsl:choose>

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ footer ~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

     <xsl:call-template name="process-footnotes" />

     <p class="copyright"><xsl:apply-templates select="/gamebook/meta/rights[@class='copyrights']" /></p><xsl:value-of select="$newline" /><xsl:value-of select="$newline" />

    </div><xsl:value-of select="$newline" />

    <map name="imagemap" id="imagemap">
     <area shape="rect" coords="0,0,99,99" href="http://www.projectaon.org/" alt="Project Aon" target="_top" />
     <area shape="default" href="title.htm">
      <xsl:attribute name="alt"><xsl:value-of select="/gamebook/meta/title[1]" /></xsl:attribute>
     </area>
    </map>

   </body>

   <xsl:value-of select="$newline" />
   <xsl:value-of select="$newline" />

  </html>
 </redirect:write>

</xsl:template>

<xsl:template name="process-footnotes">
 <xsl:if test="footnotes/footnote">
  <div id="footnotes"><xsl:value-of select="$newline" />
   <xsl:for-each select="footnotes/footnote">
    <xsl:variable name="footnote-idref" select="@idref" />
    <xsl:variable name="footnote-id" select="@id" />
    <xsl:variable name="footnote-marker"><xsl:number count="footnotes/footnote" from="/" level="any" format="1" /></xsl:variable>

    <xsl:for-each select="*[1]">
     <p>
      <xsl:text>[</xsl:text>
       <a href="#{$footnote-idref}" name="{$footnote-id}"><xsl:value-of select="$footnote-marker" /></a>
      <xsl:text>] </xsl:text>
      <xsl:apply-templates select="child::* | child::text()" />
     </p>
    </xsl:for-each>

    <xsl:for-each select="*[position() != 1]">
      <xsl:apply-templates select="." />
    </xsl:for-each>
   </xsl:for-each>
  </div><xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<xsl:template name="navigation-bar">
 <div class="navigation">
  <table cellspacing="0" cellpadding="0" border="0">
   <tr>
    <td>
     <xsl:choose>
      <xsl:when test="meta/link[@class='prev']">
       <a>
        <xsl:attribute name="href">
         <xsl:value-of select="meta/link[@class='prev']/@idref" />
         <xsl:text>.htm</xsl:text>
        </xsl:attribute>
        <img src="back.gif" width="150" height="30" border="0">
         <xsl:attribute name="alt">
          <xsl:value-of select="id( meta/link[@class='prev']/@idref )/meta/title" />
         </xsl:attribute>
        </img>
       </a>
      </xsl:when>
      <xsl:otherwise>
       <img src="left.gif" width="150" height="30" border="0" alt="" />
      </xsl:otherwise>
     </xsl:choose>
    </td>
    <td><a href="toc.htm"><img src="toc.gif" width="150" height="30" border="0" alt="Table of Contents" /></a></td>
    <td>
     <xsl:choose>
      <xsl:when test="meta/link[@class='next']">
       <a>
        <xsl:attribute name="href">
         <xsl:value-of select="meta/link[@class='next']/@idref" />
         <xsl:text>.htm</xsl:text>
        </xsl:attribute>
        <img src="forward.gif" width="150" height="30" border="0">
         <xsl:attribute name="alt">
          <xsl:choose>
           <xsl:when test="meta/link[@class='next']/@idref = 'sect1'">
            <xsl:text>Section 1</xsl:text>
           </xsl:when>
           <xsl:otherwise>
            <xsl:value-of select="id( meta/link[@class='next']/@idref )/meta/title" />
           </xsl:otherwise>
          </xsl:choose>
         </xsl:attribute>
        </img>
       </a>
      </xsl:when>
      <xsl:otherwise>
       <img src="right.gif" width="150" height="30" border="0" alt="" />
      </xsl:otherwise>
     </xsl:choose>
    </td>
   </tr>
  </table>
 </div>
</xsl:template>

<xsl:template name="alpha-bar">
 <xsl:param name="alpha-bar-id-prefix"></xsl:param>

  <p class="navigation">[<a href="{$alpha-bar-id-prefix}a.htm">A</a>&nbsp;<a href="{$alpha-bar-id-prefix}b.htm">B</a>&nbsp;<a href="{$alpha-bar-id-prefix}c.htm">C</a>&nbsp;<a href="{$alpha-bar-id-prefix}d.htm">D</a>&nbsp;<a href="{$alpha-bar-id-prefix}e.htm">E</a>&nbsp;<a href="{$alpha-bar-id-prefix}f.htm">F</a>&nbsp;<a href="{$alpha-bar-id-prefix}g.htm">G</a>&nbsp;<a href="{$alpha-bar-id-prefix}h.htm">H</a>&nbsp;<a href="{$alpha-bar-id-prefix}i.htm">I</a>&nbsp;<a href="{$alpha-bar-id-prefix}j.htm">J</a>&nbsp;<a href="{$alpha-bar-id-prefix}k.htm">K</a>&nbsp;<a href="{$alpha-bar-id-prefix}l.htm">L</a>&nbsp;<a href="{$alpha-bar-id-prefix}m.htm">M</a>&nbsp;<a href="{$alpha-bar-id-prefix}n.htm">N</a>&nbsp;<a href="{$alpha-bar-id-prefix}o.htm">O</a>&nbsp;<a href="{$alpha-bar-id-prefix}p.htm">P</a>&nbsp;<a href="{$alpha-bar-id-prefix}q.htm">Q</a>&nbsp;<a href="{$alpha-bar-id-prefix}r.htm">R</a>&nbsp;<a href="{$alpha-bar-id-prefix}s.htm">S</a>&nbsp;<a href="{$alpha-bar-id-prefix}t.htm">T</a>&nbsp;<a href="{$alpha-bar-id-prefix}u.htm">U</a>&nbsp;<a href="{$alpha-bar-id-prefix}v.htm">V</a>&nbsp;<a href="{$alpha-bar-id-prefix}w.htm">W</a>&nbsp;<a href="{$alpha-bar-id-prefix}x.htm">X</a>&nbsp;<a href="{$alpha-bar-id-prefix}y.htm">Y</a>&nbsp;<a href="{$alpha-bar-id-prefix}z.htm">Z</a>]</p><xsl:value-of select="$newline" />

</xsl:template>

</xsl:transform>