<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
 <!ENTITY % xhtml.characters SYSTEM "../../en/xml/htmlchar.mod">
 %xhtml.characters;
]>

<!--

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
 <xsl:preserve-space elements="p choice puzzle deadend" />

 <!-- ====================== parameters ========================== -->

 <xsl:param name="use-illustrators" />
 <xsl:param name="language"><xsl:text>en</xsl:text></xsl:param>
 <xsl:param name="xhtml-ext"><xsl:text>.html</xsl:text></xsl:param>

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
  <h3><xsl:apply-templates select="meta/title[1]" /></h3>

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
  <h4><xsl:apply-templates select="meta/title[1]" /></h4>

  <xsl:apply-templates />
 </xsl:template>

 <!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->

 <xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
  <h5><xsl:apply-templates select="meta/title[1]" /></h5>

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
  <h3><xsl:apply-templates select="meta/title[1]" /></h3>

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
  <h4><xsl:apply-templates select="meta/title[1]" /></h4>

  <xsl:apply-templates />
 </xsl:template>

 <!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

 <xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
  <h5><xsl:apply-templates select="meta/title[1]" /></h5>

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
  <h3><xsl:apply-templates select="meta/title[1]" /></h3>

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
  <h3><xsl:apply-templates select="meta/title[1]" /></h3>

  <xsl:apply-templates />
 </xsl:template>

 <!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

 <xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
  <h4><xsl:apply-templates select="meta/title[1]" /></h4>

  <xsl:apply-templates />
 </xsl:template>

 <!-- ::::::::::::::::::::: map template ::::::::::::::::::::::::: -->

 <xsl:template match="id( 'map' )">
  <xsl:call-template name="xhtml-wrapper">
   <xsl:with-param name="document-type">map</xsl:with-param>
   <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <!-- ::::::::::::::::::::: footnotes template ::::::::::::::::::::::::: -->

 <xsl:template match="id( 'footnotz' )">
  <xsl:choose>
   <!-- Backwards compatibility measure - if there is data content, use that, otherwise generate footnotes list -->
   <xsl:when test="count( data/p ) = 0">
    <xsl:call-template name="xhtml-wrapper">
     <xsl:with-param name="document-type">footnotz</xsl:with-param>
     <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="xhtml-wrapper">
     <xsl:with-param name="document-type">second-level-backmatter</xsl:with-param>
     <xsl:with-param name="filename"><xsl:value-of select="@id" /></xsl:with-param>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates />
 </xsl:template>

 <!-- ==================== block elements ======================== -->

 <xsl:template match="p">
  <p><xsl:apply-templates /></p>

 </xsl:template>

 <xsl:template match="p[@class='dedication']">
  <p class="dedication"><xsl:apply-templates /></p>

 </xsl:template>

 <xsl:template match="dl[@class='paragraphed']/dd/node() | ol[@class='paragraphed']/li/node() | ul[@class='paragraphed']/li/node()">
  <xsl:choose>
   <xsl:when test="self::p">
    <xsl:apply-templates /><br /><br />
   </xsl:when>
   <xsl:when test="self::dl">
    <dl>
     <xsl:apply-templates />
    </dl><br /><br />
   </xsl:when>
   <xsl:when test="self::ol">
    <ol>
     <xsl:apply-templates />
    </ol><br /><br />
   </xsl:when>
   <xsl:when test="self::ul">
    <ul>
     <xsl:if test="self::*[@class='unbulleted']"><xsl:attribute name="class"><xsl:text>unbulleted</xsl:text></xsl:attribute></xsl:if>

     <xsl:apply-templates />
    </ul><br /><br />
   </xsl:when>
   <xsl:when test="self::blockquote">
    <blockquote>
     <xsl:apply-templates />
    </blockquote>
   </xsl:when>
   <xsl:when test="self::poetry">
    <blockquote class="poetry"><p>
     <xsl:apply-templates />
    </p></blockquote>
   </xsl:when>
   <xsl:when test="self::illustration">
    <!-- Backwards compatibility code -->
    <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
    <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
    <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

    <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
     <div class="illustration">

      <xsl:call-template name="illustration-noframe">
       <xsl:with-param name="illustration-width"><xsl:value-of select="$illustration-width" /></xsl:with-param>
       <xsl:with-param name="illustration-height"><xsl:value-of select="$illustration-height" /></xsl:with-param>
       <xsl:with-param name="illustration-src"><xsl:value-of select="$illustration-src" /></xsl:with-param>
      </xsl:call-template>
     </div>
    </xsl:if>
   </xsl:when>
   <xsl:when test="self::illref">
    <xsl:if test="@class='html'">
     <xsl:for-each select="id( @idref )">
      <xsl:apply-templates select="." />
     </xsl:for-each>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>[error: paragraphed list template]</xsl:text>
    <xsl:message><xsl:text>error: paragraphed list template</xsl:text></xsl:message>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="ol">
  <ol>
   <xsl:if test="@start"><xsl:attribute name="start"><xsl:value-of select="@start" /></xsl:attribute></xsl:if>

   <xsl:apply-templates />
  </ol>
 </xsl:template>

 <xsl:template match="ul">
  <ul>
   <xsl:if test="self::*[@class='unbulleted']"><xsl:attribute name="class"><xsl:text>unbulleted</xsl:text></xsl:attribute></xsl:if>

   <xsl:apply-templates />
  </ul>
 </xsl:template>

 <xsl:template match="dl">
  <dl>
   <xsl:apply-templates />
  </dl>
 </xsl:template>

 <xsl:template match="dt">
  <dt><xsl:apply-templates /></dt>

 </xsl:template>

 <xsl:template match="dd">
  <dd><xsl:apply-templates /></dd>

 </xsl:template>

 <xsl:template match="li">
  <li>
   <xsl:if test="@value"><xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </li>

 </xsl:template>

 <xsl:template match="table">
  <table align="center" border="1" cellspacing="0" cellpadding="2">
   <xsl:if test="@summary"><xsl:attribute name="summary"><xsl:value-of select="@summary" /></xsl:attribute></xsl:if>
   <xsl:apply-templates />
  </table>

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
     <span class="smallcaps">
      <xsl:choose>
       <xsl:when test="$language='es'">
        <xsl:text>DESTREZA&nbsp;EN&nbsp;EL&nbsp;COMBATE</xsl:text>
       </xsl:when>
       <xsl:otherwise>
        <xsl:text>COMBAT&nbsp;SKILL</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </span>
     <xsl:text>&nbsp;</xsl:text>
     <xsl:value-of select="enemy-attribute[@class='combatskill']" />
    </xsl:when>
    <xsl:when test="enemy-attribute[@class='closecombatskill']">
     <span class="smallcaps">
      <xsl:choose>
       <xsl:when test="$language='es'">
        <xsl:text>CLOSE&nbsp;COMBAT&nbsp;SKILL</xsl:text>
       </xsl:when>
       <xsl:otherwise>
        <xsl:text>CLOSE&nbsp;COMBAT&nbsp;SKILL</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </span>
     <xsl:text>&nbsp;</xsl:text>
     <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
    </xsl:when>
   </xsl:choose>
   <xsl:text> &nbsp;&nbsp;</xsl:text>
   <span class="smallcaps">
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text>RESISTENCIA</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>ENDURANCE</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </span>
   <xsl:choose>
    <xsl:when test="enemy-attribute[@class='target']">
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text> (o </xsl:text><span class="smallcaps">BLANCOS</span><xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text> (</xsl:text><span class="smallcaps">TARGET</span><xsl:text> points)</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
     <xsl:text>&nbsp;</xsl:text>
     <xsl:value-of select="enemy-attribute[@class='target']" />
    </xsl:when>
    <xsl:when test="enemy-attribute[@class='resistance']">
     <xsl:choose>
      <xsl:when test="$language='es'"></xsl:when>
      <xsl:otherwise>
       <xsl:text> (</xsl:text><span class="smallcaps">RESISTANCE</span><xsl:text> points)</xsl:text>
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

 </xsl:template>

 <xsl:template match="choice">
  <xsl:variable name="link">
   <xsl:value-of select="@idref" />
  </xsl:variable>

  <p class="choice">
   <xsl:for-each select="* | text()">
    <xsl:choose>
     <xsl:when test="self::link-text">
      <a href="{$link}{$xhtml-ext}">
       <xsl:apply-templates />
      </a>
     </xsl:when>
     <xsl:otherwise>
      <xsl:apply-templates select="." />
     </xsl:otherwise>
    </xsl:choose>
   </xsl:for-each>
  </p>

 </xsl:template>

 <xsl:template match="puzzle">
  <p class="puzzle">
   <xsl:apply-templates />
  </p>
 </xsl:template>
 
 <xsl:template match="deadend">
  <p class="deadend">
   <xsl:apply-templates />
  </p>
 </xsl:template>

 <xsl:template match="data/signpost">
  <div class="signpost">
   <xsl:apply-templates />
  </div>
 </xsl:template>

 <xsl:template match="signpost">
  <span class="signpost"><xsl:apply-templates /></span>
 </xsl:template>

 <xsl:template match="blockquote">
  <blockquote>
   <xsl:apply-templates />
  </blockquote>
 </xsl:template>

 <xsl:template match="poetry">
  <blockquote class="poetry">
   <xsl:apply-templates />
  </blockquote>
 </xsl:template>

 <xsl:template match="illref">
  <!-- It is important that the class is not checked right in the template - that would make this template match with higher priority, which will turn a few things upside down --> 
  <xsl:if test="@class='html'">
   <xsl:for-each select="id( @idref )">
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
      <!-- List item with illustration name -->
      <li>
       <xsl:choose>
        <xsl:when test="$language='es'">
         <xsl:text>Ilustraci&oacute;n </xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>Illustration </xsl:text>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
       <!-- List the sections that the illustration appears in -->
       <xsl:text> (</xsl:text>
       <xsl:for-each select="//illref[@class='html' and @idref=current()/@id]">
        <xsl:call-template name="section-title-link" />
        <xsl:if test="position()!=last()">
         <xsl:text>, </xsl:text>        
        </xsl:if>
       </xsl:for-each>
       <xsl:text>)</xsl:text>
      </li>
     </xsl:when>

     <xsl:when test="self::illustration"> <!-- inline and map -->
      <!-- List the sections that the illustration appears in -->     
      <li>
       <!-- TODO: fix this so that sections that do not represent separate XHTML files are not linked to? -->
       <xsl:for-each select="//illref[@class='html' and @idref=current()/@id]">
        <xsl:call-template name="section-title-link" />
        <xsl:if test="position()!=last()">
         <xsl:text>, </xsl:text>     
        </xsl:if>
       </xsl:for-each>
      </li>
     </xsl:when>

     <xsl:when test="self::illgroup and @class!='hidden'">
      <!-- Check if the group contains any illustrations being used, before creating the list item -->
       <xsl:if test="count( illustration[contains( $use-illustrators, concat( ':', meta/creator, ':' ) )] ) != 0">
        <li>
         <a>
          <xsl:attribute name="href"><xsl:value-of select="@idref" /><xsl:value-of select="$xhtml-ext"/></xsl:attribute>
          <xsl:value-of select="id(@idref)/meta/title[1]" />
         </a>
        </li>
       </xsl:if>
     </xsl:when>
    </xsl:choose>
   </xsl:for-each>
  </ul>
 </xsl:template>

 <xsl:template match="illustration">
  <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
  <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
  <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

  <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:choose>
    <xsl:when test="@class='float'">
     <div class="illustration">
      <xsl:call-template name="illustration-noframe">
       <xsl:with-param name="illustration-width"><xsl:value-of select="$illustration-width" /></xsl:with-param>
       <xsl:with-param name="illustration-height"><xsl:value-of select="$illustration-height" /></xsl:with-param>
       <xsl:with-param name="illustration-src"><xsl:value-of select="$illustration-src" /></xsl:with-param>
       <xsl:with-param name="illustration-href">
        <xsl:text>ill</xsl:text><xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" /><xsl:value-of select="$xhtml-ext"/>
       </xsl:with-param>
      </xsl:call-template>
     </div>
    </xsl:when>

    <xsl:when test="@class='accent'" />

    <xsl:otherwise>
     <div class="illustration">
      <xsl:call-template name="illustration-noframe">
       <xsl:with-param name="illustration-width"><xsl:value-of select="$illustration-width" /></xsl:with-param>
       <xsl:with-param name="illustration-height"><xsl:value-of select="$illustration-height" /></xsl:with-param>
       <xsl:with-param name="illustration-src"><xsl:value-of select="$illustration-src" /></xsl:with-param>
      </xsl:call-template>
     </div>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
 </xsl:template>

 <xsl:template match="instance" />

 <xsl:template match="footnotes" />

 <xsl:template match="footnote" />

 <xsl:template match="hr">
  <hr />

 </xsl:template>

 <xsl:template match="choose">
  <xsl:choose>
   <xsl:when test="@test='has-numbered-section-list'">
    <xsl:choose>
     <xsl:when test="when[@value='true']">
      <xsl:apply-templates select="when[@value='true'][1]/node()" />
     </xsl:when>
     <xsl:when test="otherwise">
      <!-- this should only be applied when there is no option for "true" -->
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
         <xsl:value-of select="$my-idref" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and @id=$my-idref]">
         <xsl:value-of select="$my-idref" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and @id=$my-idref]">
         <xsl:value-of select="$my-idref" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='numbered' and @id=$my-idref]">
         <xsl:value-of select="$my-idref" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='glossary-separate' and @id=$my-idref]">
         <xsl:value-of select="$my-idref" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and descendant::*[@id=$my-idref]]">
         <xsl:value-of select="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and descendant::*[@id=$my-idref]]/@id" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and descendant::*[@id=$my-idref]]">
         <xsl:value-of select="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and descendant::*[@id=$my-idref]]/@id" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section/data/section[@class='glossary-separate' and descendant::*[@id=$my-idref]]">
         <xsl:value-of select="/gamebook/section/data/section/data/section[@class='glossary-separate' and descendant::*[@id=$my-idref]]/@id" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:when test="/gamebook/section/data/section[descendant::*[@id=$my-idref]]">
         <xsl:value-of select="/gamebook/section/data/section[descendant::*[@id=$my-idref]]/@id" /><xsl:value-of select="$xhtml-ext"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>[error: a template]</xsl:text>
         <xsl:message><xsl:text>error: a template</xsl:text></xsl:message>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:attribute>
     </xsl:if>
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
   <xsl:number count="a[@class='footnote']" from="/" level="any" format="1" />
  </sup>
 </xsl:template>

 <!-- TODO: can this be made more uniform with illrefs? -->
 <xsl:template match="a[@class='accent-illustration']">
  <xsl:for-each select="id( @idref )">
   <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />
   <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
   <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
   <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
    <img src="{$illustration-src}" class="accent" width="{$illustration-width}" height="{$illustration-height}" alt="" />
   </xsl:if>
  </xsl:for-each>
 </xsl:template>

 <!-- TODO: references to external books will not work in Ebooks -->
 <!--       should they be skipped or modified to point to the online book? -->
 <xsl:template match="bookref">
 <!-- <a> -->
 <!--  <xsl:attribute name="href"> -->
 <!--   <xsl:variable name="my-section"> -->
 <!--    <xsl:choose> -->
 <!--     <xsl:when test="@section"> -->
 <!--      <xsl:value-of select="@section" /> -->
 <!--     </xsl:when> -->
 <!--     <xsl:otherwise> -->
 <!--      <xsl:text>title</xsl:text> -->
 <!--     </xsl:otherwise> -->
 <!--    </xsl:choose> -->
 <!--   </xsl:variable> -->
 <!--   <xsl:variable name="my-series"> -->
     <!-- If series is specified, go one directory back and then to series. Otherwise, add nothing. -->
 <!--    <xsl:choose> -->
 <!--     <xsl:when test="@series"> -->
 <!--      <xsl:text>/../</xsl:text><xsl:value-of select="@series" /> -->
 <!--     </xsl:when> -->
 <!--     <xsl:otherwise> -->
 <!--      <xsl:text></xsl:text> -->
 <!--     </xsl:otherwise> -->
 <!--    </xsl:choose> -->
 <!--   </xsl:variable> -->
 <!--   <xsl:text>..</xsl:text><xsl:value-of select="$my-series" /><xsl:text>/</xsl:text><xsl:value-of select="@book" /><xsl:text>/</xsl:text><xsl:value-of select="$my-section" /><xsl:value-of select="$xhtml-ext"/> -->
 <!--  </xsl:attribute> -->
 <!--  <xsl:if test="@id"><xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute></xsl:if> -->
   <xsl:apply-templates />
 <!-- </a> -->
 </xsl:template>

 <xsl:template match="footref">
  <xsl:apply-templates />
  <sup>
   <xsl:number count="footref" from="/" level="any" format="1" />
  </sup>
 </xsl:template>

 <xsl:template match="em">
  <em><xsl:apply-templates /></em>
 </xsl:template>

 <xsl:template match="strong">
  <strong><xsl:apply-templates /></strong>
 </xsl:template>

 <xsl:template match="thought">
  <span class="thought"><xsl:apply-templates /></span>
 </xsl:template>

 <xsl:template match="onomatopoeia">
  <span class="onomatopoeia"><xsl:apply-templates /></span>
 </xsl:template>

 <xsl:template match="spell">
  <span class="spell"><xsl:apply-templates /></span>
 </xsl:template>

 <xsl:template match="item">
  <xsl:apply-templates />
 </xsl:template>

 <xsl:template match="foreign">
  <span class="foreign">
   <xsl:attribute name="xml:lang">
    <xsl:value-of select="@xml:lang"/>
   </xsl:attribute>
   <xsl:apply-templates />
  </span>
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
  <span class="smallcaps"><xsl:apply-templates /></span>
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

 <!-- ==================== named templates ======================= -->

 <xsl:template name="xhtml-wrapper">
  <xsl:param name="document-type">undefined</xsl:param>
  <xsl:param name="filename">undefined</xsl:param>
  <xsl:param name="glossary-id-prefix"></xsl:param>

  <redirect:write file="{$filename}{$xhtml-ext}">
   <xsl:fallback>
    <xsl:text>xhtml-wrapper: Cannot write to filename: "</xsl:text>
    <xsl:value-of select="$filename" />
    <xsl:value-of select="$xhtml-ext" />
   </xsl:fallback>

   <html xml:lang="{$language}">

    <head>
     <title>
      <xsl:apply-templates select="/gamebook/meta/title[1]" />
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="meta/title[1]" />
     </title>
     <meta http-equiv="Content-type" content="application/xhtml+xml; charset=utf-8" />
     <link rel="stylesheet" href="main.css" type="text/css" />
    </head>

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

    <body> 
     <div id="body"> 
      <div id="page-header">
       <cite>
        <xsl:apply-templates select="/gamebook/meta/title[1]"/>
       </cite>
       <xsl:choose>
        <xsl:when test="$language='es'">
         <xsl:text> por </xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text> by </xsl:text>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:apply-templates select="/gamebook/meta/creator[@class='short']" />
      </div>

      <xsl:choose>

 <!-- ~~~~~~~~~~~~~~~~~~~~~~~~ top-level ~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='top-level'">
        <div class="frontmatter">

         <div class="maintext">
          <h1 id="title">
           <xsl:apply-templates select="/gamebook/meta/title[1]"/>
          </h1>
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
         </div>
        </div>

       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~ toc ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='toc'">
        <div class="frontmatter">
         <div class="maintext">

          <h2>
           <xsl:choose>
            <xsl:when test="$language='es'">
             <xsl:text>&Iacute;ndice de Contenidos</xsl:text>
            </xsl:when>
            <xsl:otherwise>
             <xsl:text>Table of Contents</xsl:text>
            </xsl:otherwise>
           </xsl:choose>
          </h2>

          <ul>
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

           <li><a href="title{$xhtml-ext}"><xsl:value-of select="$title-page"/></a></li>
           <xsl:for-each select="/gamebook/section/data/section">
            <li>
             <a><xsl:attribute name="href"><xsl:value-of select="@id" /><xsl:value-of select="$xhtml-ext"/></xsl:attribute>
              <xsl:apply-templates select="meta/title[1]" />
             </a>
             <xsl:if test="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">

              <ul>
               <xsl:for-each select="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
                <li>
                 <a><xsl:attribute name="href"><xsl:value-of select="@id" /><xsl:value-of select="$xhtml-ext"/></xsl:attribute>
                  <xsl:value-of select ="meta/title[1]" />
                 </a>
                </li>
               </xsl:for-each>
              </ul>
             </xsl:if>
            </li>
           </xsl:for-each>
          </ul>

         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~ second-level-frontmatter ~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='second-level-frontmatter'">
        <div class="frontmatter">
         <div class="maintext">
          <h2><xsl:apply-templates select="meta/title" /></h2>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~ third-level-frontmatter-separate ~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='third-level-frontmatter-separate'">
        <div class="frontmatter">
         <div class="maintext">
          <h3><xsl:apply-templates select="meta/title" /></h3>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~ second-level-mainmatter ~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='second-level-mainmatter'">
        <div class="mainmatter">
         <div class="maintext">
          <h2><xsl:apply-templates select="meta/title" /></h2>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~ third-level-mainmatter-separate ~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='third-level-mainmatter-separate'">
        <div class="mainmatter">
         <div class="maintext">
          <h3><xsl:apply-templates select="meta/title" /></h3>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~ second-level-glossary ~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='second-level-glossary'">
        <div class="mainmatter">
         <div class="maintext">
          <h2><xsl:apply-templates select="meta/title" /></h2>

          <xsl:call-template name="alpha-bar">
           <xsl:with-param name="alpha-bar-id-prefix"><xsl:value-of select="$glossary-id-prefix" /></xsl:with-param>
          </xsl:call-template>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~ third-level-glossary-separate ~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='third-level-glossary-separate'">
        <div class="glossary">
         <div class="maintext">
          <h3><xsl:apply-templates select="meta/title" /></h3>
          <xsl:call-template name="alpha-bar">
           <xsl:with-param name="alpha-bar-id-prefix"><xsl:value-of select="$glossary-id-prefix" /></xsl:with-param>
          </xsl:call-template>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~~~ second-level-numbered ~~~~~~~~~~~~~~~~~~~~ -->
 <!--

The following automatically generated section list requires that the
title of each section be a simple number.

-->
       <xsl:when test="$document-type='second-level-numbered'">
        <div class="numbered">
         <div class="maintext">
          <h2><xsl:apply-templates select="meta/title" /></h2>

          <xsl:variable name="base-section-number" select="number( data/section[1]/meta/title ) - 1" />
          <p>
           <xsl:for-each select="data/section">
            <xsl:if test="position( ) mod 10 = 1">
             <b>
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
             <xsl:text>: </xsl:text></b>
            </xsl:if>
            <a>
             <xsl:attribute name="href"><xsl:value-of select="@id" /><xsl:value-of select="$xhtml-ext"/></xsl:attribute>
             <xsl:apply-templates select="meta/title" />
            </a>
            <xsl:choose>
             <xsl:when test="position( ) mod 10 = 0">
              <br />
             </xsl:when>
             <xsl:otherwise>
              <xsl:text> </xsl:text>
             </xsl:otherwise>
            </xsl:choose>
           </xsl:for-each>
          </p>
         </div>

        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~~~ third-level-numbered ~~~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='third-level-numbered'">
        <div class="numbered">
         <div class="maintext">
          <h3><xsl:apply-templates select="meta/title" /></h3>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~~ footnotes ~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='footnotz'">
        <div class="backmatter">
         <div class="maintext">

          <!-- No particular reason to code title here -->
          <h2><xsl:apply-templates select="meta/title" /></h2>
          <!-- Generate list of footnotes -->
          <xsl:for-each select="//footnotes/footnote">
           <div class="footnote">
            <!-- will the list always contain the closest ancestor first? -->
            <xsl:variable name="footnote-section"><xsl:value-of select="ancestor::section[position()=1]/@id" /></xsl:variable>
            <xsl:variable name="footnote-marker"><xsl:number count="footnotes/footnote" from="/" level="any" format="1" /></xsl:variable>
            <xsl:variable name="footnote-idref"><xsl:value-of select="@idref" /></xsl:variable>

            <xsl:for-each select="*[1]">
             <p>
              <xsl:text>[</xsl:text>
              <a>
               <xsl:attribute name="href"><xsl:value-of select="$footnote-section" /><xsl:value-of select="$xhtml-ext"/></xsl:attribute>
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

           </div>
          </xsl:for-each>

          <!-- Backwards compatibility... needed? Probably not. -->
          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~~ second-level-backmatter ~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='second-level-backmatter'">
        <div class="frontmatter">
         <div class="maintext">
          <h2><xsl:apply-templates select="meta/title" /></h2>

          <xsl:apply-templates />
         </div>
        </div>
       </xsl:when>

 <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~ map ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

       <xsl:when test="$document-type='map'">
        <div class="frontmatter">
         <div class="maintext">
          <h2><xsl:apply-templates select="meta/title" /></h2>

          <xsl:for-each select="data/* | data/text()">
           <xsl:variable name="map-illustration-alt-text">
            <xsl:choose>
             <xsl:when test="$language='es'">
              <xsl:text>mapa</xsl:text>
             </xsl:when>
             <xsl:otherwise>
              <xsl:text>map</xsl:text>
             </xsl:otherwise>
            </xsl:choose>
           </xsl:variable>

           <!-- duplicated stuff here, no good way to avoid this while retaining backwards compatibility -->
           <xsl:choose>
            <xsl:when test="self::illustration and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
             <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
             <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
             <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

             <div class="illustration">
              <xsl:call-template name="illustration-noframe">
               <xsl:with-param name="illustration-width"><xsl:value-of select="$illustration-width" /></xsl:with-param>
               <xsl:with-param name="illustration-height"><xsl:value-of select="$illustration-height" /></xsl:with-param>
               <xsl:with-param name="illustration-src"><xsl:value-of select="$illustration-src" /></xsl:with-param>
               <xsl:with-param name="illustration-href">map<xsl:value-of select="$xhtml-ext"/></xsl:with-param>
               <xsl:with-param name="illustration-alt-text">
                <xsl:text>[</xsl:text>
        	       <xsl:value-of select="$map-illustration-alt-text"/>
	              <xsl:text>]</xsl:text>
       	      </xsl:with-param>
              </xsl:call-template>
             </div>
            </xsl:when>

            <xsl:when test="self::illref and @class='html'">
             <xsl:for-each select="id( @idref )">
              <xsl:if test="contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
               <xsl:variable name="illustration-width" select="instance[@class='html']/@width" />
               <xsl:variable name="illustration-height" select="instance[@class='html']/@height" />
               <xsl:variable name="illustration-src" select="instance[@class='html']/@src" />

               <div class="illustration">
                <xsl:call-template name="illustration-noframe">
                 <xsl:with-param name="illustration-width"><xsl:value-of select="$illustration-width" /></xsl:with-param>
                 <xsl:with-param name="illustration-height"><xsl:value-of select="$illustration-height" /></xsl:with-param>
                 <xsl:with-param name="illustration-src"><xsl:value-of select="$illustration-src" /></xsl:with-param>
                 <xsl:with-param name="illustration-href">map<xsl:value-of select="$xhtml-ext"/></xsl:with-param>
                 <xsl:with-param name="illustration-alt-text">
  	             	 <xsl:text>[</xsl:text>
                  <xsl:value-of select="$map-illustration-alt-text"/>
	      	         <xsl:text>]</xsl:text>
        	        </xsl:with-param>
                </xsl:call-template>
               </div>
              </xsl:if>
             </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
             <xsl:apply-templates select="." />
            </xsl:otherwise>
           </xsl:choose>
          </xsl:for-each>
         </div>
        </div>
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

     </div>
    </body>

   </html>
  </redirect:write>

 </xsl:template>

 <xsl:template name="process-footnotes">
  <xsl:if test="footnotes/footnote">
   <div id="footnotes">
    <xsl:for-each select="footnotes/footnote">
     <xsl:variable name="footnote-idref" select="@idref" />
     <xsl:variable name="footnote-id" select="@id" />
     <xsl:variable name="footnote-marker"><xsl:number count="footnotes/footnote" from="/" level="any" format="1" /></xsl:variable>

     <xsl:for-each select="*[1]">
      <p>
       <xsl:text>[</xsl:text>
        <xsl:value-of select="$footnote-marker" />
       <xsl:text>] </xsl:text>
       <xsl:apply-templates select="child::* | child::text()" />
      </p>
     </xsl:for-each>

     <xsl:for-each select="*[position() != 1]">
       <xsl:apply-templates select="." />
     </xsl:for-each>
    </xsl:for-each>
   </div>
  </xsl:if>
 </xsl:template>

 <xsl:template name="alpha-bar">
  <xsl:param name="alpha-bar-id-prefix"></xsl:param>

   <p class="navigation">[<a href="{$alpha-bar-id-prefix}a{$xhtml-ext}">A</a>&nbsp;<a href="{$alpha-bar-id-prefix}b{$xhtml-ext}">B</a>&nbsp;<a href="{$alpha-bar-id-prefix}c{$xhtml-ext}">C</a>&nbsp;<a href="{$alpha-bar-id-prefix}d{$xhtml-ext}">D</a>&nbsp;<a href="{$alpha-bar-id-prefix}e{$xhtml-ext}">E</a>&nbsp;<a href="{$alpha-bar-id-prefix}f{$xhtml-ext}">F</a>&nbsp;<a href="{$alpha-bar-id-prefix}g{$xhtml-ext}">G</a>&nbsp;<a href="{$alpha-bar-id-prefix}h{$xhtml-ext}">H</a>&nbsp;<a href="{$alpha-bar-id-prefix}i{$xhtml-ext}">I</a>&nbsp;<a href="{$alpha-bar-id-prefix}j{$xhtml-ext}">J</a>&nbsp;<a href="{$alpha-bar-id-prefix}k{$xhtml-ext}">K</a>&nbsp;<a href="{$alpha-bar-id-prefix}l{$xhtml-ext}">L</a>&nbsp;<a href="{$alpha-bar-id-prefix}m{$xhtml-ext}">M</a>&nbsp;<a href="{$alpha-bar-id-prefix}n{$xhtml-ext}">N</a>&nbsp;<a href="{$alpha-bar-id-prefix}o{$xhtml-ext}">O</a>&nbsp;<a href="{$alpha-bar-id-prefix}p{$xhtml-ext}">P</a>&nbsp;<a href="{$alpha-bar-id-prefix}q{$xhtml-ext}">Q</a>&nbsp;<a href="{$alpha-bar-id-prefix}r{$xhtml-ext}">R</a>&nbsp;<a href="{$alpha-bar-id-prefix}s{$xhtml-ext}">S</a>&nbsp;<a href="{$alpha-bar-id-prefix}t{$xhtml-ext}">T</a>&nbsp;<a href="{$alpha-bar-id-prefix}u{$xhtml-ext}">U</a>&nbsp;<a href="{$alpha-bar-id-prefix}v{$xhtml-ext}">V</a>&nbsp;<a href="{$alpha-bar-id-prefix}w{$xhtml-ext}">W</a>&nbsp;<a href="{$alpha-bar-id-prefix}x{$xhtml-ext}">X</a>&nbsp;<a href="{$alpha-bar-id-prefix}y{$xhtml-ext}">Y</a>&nbsp;<a href="{$alpha-bar-id-prefix}z{$xhtml-ext}">Z</a>]</p>

 </xsl:template>

 <xsl:template name="illustration-noframe">
  <xsl:param name="illustration-width" select="instance[@class='html']/@width" />
  <xsl:param name="illustration-height" select="instance[@class='html']/@height" />
  <xsl:param name="illustration-src" select="instance[@class='html']/@src" />
  <xsl:param name="illustration-alt-text">
   <xsl:choose>
    <xsl:when test="$language='es'">
     <xsl:text>ilustraci&oacute;n</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>illustration</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:param>

   <img src="{$illustration-src}" width="{$illustration-width}" height="{$illustration-height}" alt="[{$illustration-alt-text}]" />
   <xsl:if test="@class='float'">
    <br />
    <strong>
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text>Ilustraci&oacute;n </xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>Illustration </xsl:text>
      </xsl:otherwise>
     </xsl:choose>
     <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
    </strong>
    <xsl:text>&#8212;</xsl:text>
    <xsl:apply-templates select="meta/description" />
   </xsl:if>
   <br /><br />
 </xsl:template>

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
   <xsl:attribute name="href"><xsl:value-of select="ancestor::section[position()=1]/@id" /><xsl:value-of select="$xhtml-ext"/></xsl:attribute>
   <xsl:value-of select="$section-title" />
  </a>
 </xsl:template>

</xsl:transform>
