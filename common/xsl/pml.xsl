<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
 <!ENTITY % pml.characters SYSTEM "pmlchar.mod">
 %pml.characters;
]>

<!--

$Id$

$Log$
Revision 1.2  2005/04/09 19:51:50  angantyr
Added handling of open-ended quotes.

Revision 1.1  2005/01/30 01:32:52  jonathan.blake
Initial freepository revision of XML support documents.

Revision 1.2  2003/01/07 16:55:28  jblake
Restarted work from base xhtml.xsl.


-->

<xsl:transform version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lxslt="http://xml.apache.org/xslt">

<xsl:output method="text" encoding="ISO-8859-1" />

<xsl:strip-space elements="gamebook section meta data ol ul dl li dd footnotes footnote illustration instance" />
<xsl:preserve-space elements="p choice" />

<!-- ====================== parameters ========================== -->

<xsl:param name="use-illustrators" />

<!-- ======================= variables ========================== -->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="newparagraph">
 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
</xsl:variable>

<xsl:variable name="newpage">
 <xsl:value-of select="$newline" />
 <xsl:text>\p</xsl:text>
</xsl:variable>

<!-- ======================== Templates ========================= -->

<!-- ================= hierarchical sections ==================== -->

<xsl:template match="meta" />

<!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

<xsl:template match="/gamebook/section[@id='title']">
 <xsl:text>\vTITLE="</xsl:text><xsl:value-of select="/gamebook/meta/title" /><xsl:text>"\v</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />

 <xsl:text>\X0\l\B</xsl:text>
  <xsl:text>\c</xsl:text>
   <xsl:value-of select="/gamebook/meta/title" />
   <xsl:value-of select="$newline" />
  <xsl:text>\c</xsl:text>
 <xsl:text>\B\l\X0</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:text>\c</xsl:text>
  <xsl:apply-templates select="/gamebook/meta/creator[@class='medium']" />
  <xsl:value-of select="$newline" />
 <xsl:text>\c</xsl:text>

 <xsl:value-of select="$newpage" />
 
 <xsl:apply-templates select="/gamebook/meta/rights[@class='license-notification']" />

 <xsl:value-of select="$newparagraph" />
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

 <xsl:value-of select="$newparagraph" />
 <xsl:apply-templates select="/gamebook/meta/description[@class='publication']" />

 <xsl:if test="data/section[@class='frontmatter']">
  <xsl:apply-templates select="data/section[@class='frontmatter']" />
 </xsl:if>

 <xsl:if test="data/section[@class='mainmatter']">
  <xsl:apply-templates select="data/section[@class='mainmatter']" />
 </xsl:if>

 <xsl:if test="data/section[@class='numbered']">
  <xsl:apply-templates select="data/section[@class='numbered']" />
 </xsl:if>

 <xsl:if test="data/section[@class='backmatter']">
  <xsl:apply-templates select="data/section[@class='backmatter']" />
 </xsl:if>

 <xsl:for-each select="//footnote">
  <xsl:value-of select="$newparagraph" />
  <xsl:text>&lt;footnote id="</xsl:text><xsl:value-of select="@id" /><xsl:text>"&gt;</xsl:text>
   <xsl:text>[</xsl:text><xsl:number count="footnote" from="/" level="any" format="1" /><xsl:text>]</xsl:text>
   <xsl:apply-templates />
  <xsl:text>&lt;/footnote&gt;</xsl:text>
 </xsl:for-each>

</xsl:template>

<xsl:template match="/gamebook/section[@id='toc']" />

<xsl:template match="section" />

<!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='frontmatter']">
 <xsl:value-of select="$newpage" />

 <xsl:text>\X1\l\B\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B\l\X1</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: third-level front matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\X2\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l\X2</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter']">
 <xsl:text>\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- :::::::::::: fourth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">
 <xsl:text>\B\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
 <xsl:text>\Q{</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- ::::::::::: second-level main matter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='mainmatter']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\X1\l\B\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B\l\X1</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: third-level main matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter-separate']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\X2\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l\X2</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter']">
 <xsl:text>\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- :::::::::::: fourth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter-separate']">
 <xsl:text>\B\Q="</xsl:text><xsl:value-of select="@id" />><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter']">
 <xsl:text>\B\Q="</xsl:text><xsl:value-of select="@id" />><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
 <xsl:text>\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- :::::::::::: third-level glossary sections ::::::::::::: -->
<!-- Glossary sections should be contained in a second level section. -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='glossary-separate']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\X2\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l\X2</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='glossary']">
 <xsl:text>\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\X1\l\B\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B\l\X1</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section[@class='numbered']/data/section[@class='numbered']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\c\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\c</xsl:text><xsl:value-of select="$newline" />

 <xsl:apply-templates />
 <xsl:value-of select="$newparagraph" />
 <xsl:text>\w="50%"</xsl:text>
</xsl:template>

<!-- :::::::::::: second-level backmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='backmatter']">
 <xsl:value-of select="$newpage" />
 <xsl:text>\X1\l\B\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B\l\X1</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: third-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">
 <xsl:text>\l\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\l</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
 <xsl:text>\B\Q="</xsl:text><xsl:value-of select="@id" />><xsl:text>"</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>\B</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<!-- :::::::::::::::::: dedication template ::::::::::::::::::::: -->

<xsl:template match="id( 'dedicate' )">
 <!-- PML doesn't allow blank lines at the top of a page without a space -->
 <xsl:value-of select="$newpage" />
 <xsl:text>&nbsp;</xsl:text><xsl:value-of select="$newparagraph" />
 <xsl:text>&nbsp;</xsl:text><xsl:value-of select="$newparagraph" />
 <xsl:text>\c\i</xsl:text>
  <xsl:apply-templates select="data/p" />
 <xsl:text>\i</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\c</xsl:text>
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ==================== block elements ======================== -->

<xsl:template match="p">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="dd/p | li/p">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:choose>
   <xsl:when test="following-sibling::illustration">
    <xsl:if test="following-sibling::illustration/instance[@class='text']">
     <xsl:value-of select="$newparagraph" />
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$newparagraph" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:if>
</xsl:template>

<xsl:template match="ul | ol | dl">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="li/ul | li/ol | li/dl | dd/ul | dd/ol | dd/dl">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="table">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="tr">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<xsl:template match="th">
 <xsl:variable name="indent-level" select="count( th | td )" />
 <xsl:choose>
  <xsl:when test="$indent-level = 2"><xsl:text>\T="33%"</xsl:text></xsl:when>
  <xsl:when test="$indent-level = 3"><xsl:text>\T="66%"</xsl:text></xsl:when>
 </xsl:choose>
 <xsl:text>\B</xsl:text><xsl:apply-templates /><xsl:text>\B</xsl:text>
</xsl:template>

<xsl:template match="td">
 <xsl:variable name="indent-level" select="count( th | td )" />
 <xsl:choose>
  <xsl:when test="$indent-level = 2"><xsl:text>\T="33%"</xsl:text></xsl:when>
  <xsl:when test="$indent-level = 3"><xsl:text>\T="66%"</xsl:text></xsl:when>
 </xsl:choose>
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="combat">
 <xsl:text>\t</xsl:text>
 <xsl:apply-templates select="enemy" />
 <xsl:text>:</xsl:text>
 <xsl:text>\t</xsl:text>

 <xsl:value-of select="$newline" />
 <xsl:text>\t&nbsp;&nbsp;</xsl:text>
 <xsl:choose>
  <xsl:when test="enemy-attribute[@class='combatskill']">
   <xsl:text>COMBAT&nbsp;SKILL&nbsp;</xsl:text>
   <xsl:value-of select="enemy-attribute[@class='combatskill']" />
  </xsl:when>
  <xsl:when test="enemy-attribute[@class='closecombatskill']">
   <xsl:text>CLOSE&nbsp;COMBAT&nbsp;SKILL&nbsp;</xsl:text>
   <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
  </xsl:when>
 </xsl:choose>
 <xsl:text>\t</xsl:text>

 <xsl:value-of select="$newline" />
 <xsl:text>\t&nbsp;&nbsp;</xsl:text>
 <xsl:text>ENDURANCE&nbsp;</xsl:text>
 <xsl:choose>
  <xsl:when test="enemy-attribute[@class='target']">
   <xsl:text>(TARGET&nbsp;points)&nbsp;</xsl:text>
   <xsl:value-of select="enemy-attribute[@class='target']" />
  </xsl:when>
  <xsl:when test="enemy-attribute[@class='resistance']">
   <xsl:text>(RESISTANCE&nbsp;points)&nbsp;</xsl:text>
   <xsl:value-of select="enemy-attribute[@class='resistance']" />
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="enemy-attribute[@class='endurance']" />
  </xsl:otherwise>
 </xsl:choose>
 <xsl:text>\t</xsl:text>

 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="choice">
 <xsl:variable name="link">
  <xsl:value-of select="@idref" />
 </xsl:variable>

 <xsl:text>\t</xsl:text>
 <xsl:for-each select="* | text()">
  <xsl:choose>
   <xsl:when test="self::link-text">
    <xsl:text>\q="#</xsl:text><xsl:value-of select="$link" /><xsl:text>"</xsl:text>
     <xsl:apply-templates />
    <xsl:text>\q</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="." />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:for-each>
 <xsl:text>\t</xsl:text>
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="signpost">
 <xsl:text>\c</xsl:text>
  <xsl:apply-templates />
  <xsl:value-of select="$newline" />
 <xsl:text>\c</xsl:text>
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="blockquote">
 <xsl:text>\t</xsl:text>
  <xsl:apply-templates />
 <xsl:text>\t</xsl:text>
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newparagraph" />
 </xsl:if>
</xsl:template>

<xsl:template match="illustration">
 <xsl:choose>
  <xsl:when test="instance[@class='pml'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:text>\c\m="</xsl:text><xsl:value-of select="instance[@class='pml']/@src" /><xsl:text>"</xsl:text>
   <xsl:value-of select="$newline" />
   <xsl:text>\c</xsl:text>
   <xsl:if test="following-sibling::node( )">
    <xsl:value-of select="$newparagraph" />
   </xsl:if>
  </xsl:when>
  <xsl:when test="instance[@class='text'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:apply-templates select="instance[@class='text']/*" />
   <xsl:if test="following-sibling::node( )">
    <xsl:value-of select="$newparagraph" />
   </xsl:if>
  </xsl:when>
 </xsl:choose>
</xsl:template>

<xsl:template match="instance" />

<xsl:template match="footnotes" />

<xsl:template match="footnote">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="hr">
 <xsl:text>\w="80%"</xsl:text>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dt">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<xsl:template match="dd">
 <xsl:text>\t</xsl:text>
 <xsl:apply-templates />
 <xsl:text>\t</xsl:text>
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<xsl:template match="ol/li">
 <xsl:number count="li" /><xsl:text>. </xsl:text>
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<xsl:template match="ul/li">
 <xsl:text>&bullet; </xsl:text>
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<xsl:template match="ul[@class='unbulleted']/li">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::node( )">
  <xsl:value-of select="$newline" />
 </xsl:if>
</xsl:template>

<!-- ==================== inline elements ======================= -->

<xsl:template match="a">
 <xsl:if test="@id">
  <xsl:text>\Q="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text>
 </xsl:if>
 <xsl:if test="@idref">
  <xsl:text>\q="#</xsl:text><xsl:value-of select="@idref" /><xsl:text>"</xsl:text>
 </xsl:if>

 <xsl:apply-templates />

 <xsl:if test="@idref">
  <xsl:text>\q</xsl:text>
 </xsl:if>
</xsl:template>

<xsl:template match="footnote//a">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="a[@class='footnote']">
 <xsl:apply-templates />
 <xsl:text>\Sp\Fn="</xsl:text><xsl:value-of select="@idref" /><xsl:text>"</xsl:text>
 <xsl:number count="a[@class='footnote']" from="/" level="any" format="1" />
 <xsl:text>\Fn\Sp</xsl:text>
</xsl:template>

<xsl:template match="em">
 <xsl:text>\i{</xsl:text><xsl:apply-templates /><xsl:text>i</xsl:text>
</xsl:template>

<xsl:template match="strong">
 <xsl:text>\B</xsl:text><xsl:apply-templates /><xsl:text>\B</xsl:text>
</xsl:template>

<xsl:template match="cite">
 <xsl:text>\i</xsl:text><xsl:apply-templates /><xsl:text>\i</xsl:text>
</xsl:template>

<xsl:template match="thought">
 <xsl:text>\i</xsl:text><xsl:apply-templates /><xsl:text>\i</xsl:text>
</xsl:template>

<xsl:template match="onomatopoeia">
 <xsl:text>\i</xsl:text><xsl:apply-templates /><xsl:text>\i</xsl:text>
</xsl:template>

<xsl:template match="spell">
 <xsl:text>\i</xsl:text><xsl:apply-templates /><xsl:text>\i</xsl:text>
</xsl:template>

<xsl:template match="item">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="foreign">
 <xsl:text>\i</xsl:text><xsl:apply-templates /><xsl:text>\i</xsl:text>
</xsl:template>

<xsl:template match="quote">
 <xsl:text>&lsquot;</xsl:text>
  <xsl:apply-templates />
 <xsl:if test="not(self::*[@class='open-ended'])"><xsl:text>&rsquot;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="quote//quote">
 <xsl:text>&ldquot;</xsl:text>
  <xsl:apply-templates />
 <xsl:if test="not(self::*[@class='open-ended'])"><xsl:text>&rdquot;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="code">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="br">
 <xsl:value-of select="$newline" />
</xsl:template>

</xsl:transform>

