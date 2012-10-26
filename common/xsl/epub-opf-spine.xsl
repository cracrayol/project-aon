<?xml version="1.0"?>

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="xml"
             encoding="UTF-8"
             omit-xml-declaration="yes"/>
 <xsl:strip-space elements="*" />

 <!-- ====================== parameters ========================== -->

 <xsl:param name="toc-id"><xsl:text>toc.ncx</xsl:text></xsl:param>
 <xsl:param name="addcover" />
  
 <!-- ======================== Templates ========================= -->

 <!-- ================= hierarchical sections ==================== -->

 <xsl:template match="*" />

 <xsl:template match="/gamebook">
  <spine>
   <xsl:attribute name="toc">
    <xsl:value-of select="$toc-id"/>
   </xsl:attribute>

   <xsl:apply-templates select="section[@id='title']"/>
  </spine>

 </xsl:template>

 <!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

 <xsl:template match="/gamebook/section[@id='title']">
  <itemref idref="title" media-type="application/xhtml+xml"/>
  <itemref idref="toc"   media-type="application/xhtml+xml"/>
  <itemref idref="coverpage" media-type="application/xhtml+xml"/>

  <xsl:apply-templates select="data/section"/>
 </xsl:template>

 <!-- ::::::::::: second-level sections :::::::::::::: -->

 <xsl:template match="/gamebook/section/data/section">
  <itemref>
   <xsl:attribute name="idref">
    <xsl:value-of select="@id"/>
   </xsl:attribute>
   <xsl:attribute name="media-type">
    <xsl:text>application/xhtml+xml</xsl:text>
   </xsl:attribute>
  </itemref>

  <xsl:apply-templates select="data/section"/>
 </xsl:template>

 <xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <!-- Put the numbered section list after the numbered sections so
      the reader doesn't get sent there between the Kai Wisdom page
      and Section 1. -->
  <xsl:apply-templates select="data/section"/>

  <itemref>
   <xsl:attribute name="idref">
    <xsl:value-of select="@id"/>
   </xsl:attribute>
   <xsl:attribute name="media-type">
    <xsl:text>application/xhtml+xml</xsl:text>
   </xsl:attribute>
  </itemref>
 </xsl:template>

 <!-- :::::::::::: third-level sections ::::::::::::: -->

 <xsl:template match="/gamebook/section/data/section/data/section">
  <xsl:apply-templates select="data/section"/>
 </xsl:template>

 <xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate' or @class='mainmatter-separate' or @class='numbered' or @class='glossary-separate']">
  <itemref>
   <xsl:attribute name="idref">
    <xsl:value-of select="@id"/>
   </xsl:attribute>
   <xsl:attribute name="media-type">
    <xsl:text>application/xhtml+xml</xsl:text>
   </xsl:attribute>
  </itemref>

  <xsl:apply-templates select="data/section"/>
 </xsl:template>
</xsl:transform>
