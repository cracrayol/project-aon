<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY % xhtml.characters SYSTEM "../../en/xml/htmlchar.mod">
  %xhtml.characters;
]>
<!--

Todo:

* Add Spanish in the navbar
* Add blank whitespace handling to the paragraphed list template

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:redirect="http://xml.apache.org/xalan/redirect" extension-element-prefixes="redirect" xmlns:xalan="http://xml.apache.org/xslt" exclude-result-prefixes="xalan">
  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="utf-8" indent="yes" xalan:indent-amount="1"/>
  <xsl:strip-space elements="section"/>

  <!-- ====================== parameters ========================== -->
  <xsl:param name="use-illustrators"/>
  <xsl:param name="language">
    <xsl:text>en</xsl:text>
  </xsl:param>
  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~ colors ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
  <xsl:param name="link-color">
    <xsl:text>#ff0000</xsl:text>
  </xsl:param>
  <xsl:param name="alink-color">
    <xsl:value-of select="$link-color"/>
  </xsl:param>
  <xsl:param name="vlink-color">
    <xsl:value-of select="$link-color"/>
  </xsl:param>
  <xsl:param name="text-color">
    <xsl:text>#000000</xsl:text>
  </xsl:param>
  <xsl:param name="background-color">
    <xsl:text>#ffffe4</xsl:text>
  </xsl:param>

  <!-- ======================= variables ========================== -->
  <xsl:variable name="newline">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <!-- ======================== Templates ========================= -->

  <!-- ================= hierarchical sections ==================== -->
  <xsl:template match="meta"/>
  <xsl:template match="section"/>
  <!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->
  <xsl:template match="/gamebook/section[@id='title']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">top-level</xsl:with-param>
      <xsl:with-param name="filename">title</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/gamebook/section[@id='toc']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">toc</xsl:with-param>
      <xsl:with-param name="filename">toc</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section[@class='frontmatter']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">second-level-frontmatter</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::: third-level front matter sections ::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter']">
    <h3>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">third-level-frontmatter-separate</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::: fourth-level front matter sections :::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">
    <h4>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h4>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
    <h5>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h5>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ::::::::::: second-level main matter sections :::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section[@class='mainmatter']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">second-level-mainmatter</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::: third-level main matter sections ::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter']">
    <h3>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter-separate']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">third-level-mainmatter-separate</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::: fourth-level main matter sections :::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter']">
    <h4>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h4>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
    <h5>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h5>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- :::::::::::: second-level glossary sections ::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section[@class='glossary']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">second-level-glossary</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
      <xsl:with-param name="glossary-id-prefix">topics</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::: third-level glossary sections ::::::::::::: -->
  <!-- glossary sections should be enclosed in a second level glossary section -->
  <xsl:template match="/gamebook/section/data/section/data/section[@class='glossary']">
    <h3>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/gamebook/section/data/section/data/section[@class='glossary-separate']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">third-level-glossary-separate</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
      <xsl:with-param name="glossary-id-prefix">topics</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section[@class='numbered']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">second-level-numbered</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/gamebook/section/data/section/data/section[@class='numbered']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">third-level-numbered</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- :::::::::::: second-level backmatter sections :::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section[@class='backmatter']">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">second-level-backmatter</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- ::::::::::::: third-level back matter sections ::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">
    <h3>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->
  <xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
    <h4>
      <a>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
    </h4>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ::::::::::::::::::::: map template ::::::::::::::::::::::::: -->
  <xsl:template match="id( 'map' )">
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">map-adjusted</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="xhtml-wrapper">
      <xsl:with-param name="document-type">map</xsl:with-param>
      <xsl:with-param name="filename">
        <xsl:value-of select="@id"/>
        <xsl:text>large</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- ::::::::::::::::::::: footnotes template ::::::::::::::::::::::::: -->
  <xsl:template match="id( 'footnotz' )">
    <xsl:choose>
      <!-- Backwards compatibility measure - if there is data content, use that, otherwise generate footnotes list -->
      <xsl:when test="count( data/p ) = 0">
        <xsl:call-template name="xhtml-wrapper">
          <xsl:with-param name="document-type">footnotz</xsl:with-param>
          <xsl:with-param name="filename">
            <xsl:value-of select="@id"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xhtml-wrapper">
          <xsl:with-param name="document-type">second-level-backmatter</xsl:with-param>
          <xsl:with-param name="filename">
            <xsl:value-of select="@id"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ==================== block elements ======================== -->
  <xsl:template match="p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="p[@class='dedication']">
    <p class="dedication">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="dl[@class='paragraphed']/dd/node() | ol[@class='paragraphed']/li/node() | ul[@class='paragraphed']/li/node()">
    <xsl:choose>
      <xsl:when test="self::p">
        <xsl:apply-templates/>
        <br/>
        <br/>
      </xsl:when>
      <xsl:when test="self::dl">
        <dl>
          <xsl:apply-templates/>
        </dl>
        <br/>
        <br/>
      </xsl:when>
      <xsl:when test="self::ol">
        <ol>
          <xsl:apply-templates/>
        </ol>
        <br/>
        <br/>
      </xsl:when>
      <xsl:when test="self::ul">
        <ul>
          <xsl:if test="self::*[@class='unbulleted']">
            <xsl:attribute name="class">
              <xsl:text>unbulleted</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </ul>
        <br/>
        <br/>
      </xsl:when>
      <xsl:when test="self::blockquote">
        <blockquote>
          <xsl:apply-templates/>
        </blockquote>
      </xsl:when>
      <xsl:when test="self::poetry">
        <blockquote class="poetry">
          <p>
            <xsl:apply-templates/>
          </p>
        </blockquote>
      </xsl:when>
      <xsl:when test="self::illustration">
        <!-- Backwards compatibility code -->
        <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
        <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
        <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
        <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
          <xsl:call-template name="illustration-framed">
            <xsl:with-param name="illustration-width">
              <xsl:value-of select="$illustration-width"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-height">
              <xsl:value-of select="$illustration-height"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-src">
              <xsl:value-of select="$illustration-src"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:when test="self::illref">
        <xsl:if test="@class='html'">
          <xsl:for-each select="id( @idref )">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:if>
      </xsl:when><xsl:when test="self::text() and normalize-space(.)=''">
        <!-- strip whitespace here -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[error: paragraphed list template]</xsl:text>
        <xsl:message>
          <xsl:text>error: paragraphed list template</xsl:text>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="ol">
    <ol>
      <xsl:if test="@start">
        <xsl:attribute name="start">
          <xsl:value-of select="@start"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  <xsl:template match="ul">
    <ul>
      <xsl:if test="self::*[@class='unbulleted']">
        <xsl:attribute name="class">
          <xsl:text>unbulleted</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="dl">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>
  <xsl:template match="dt">
    <dt>
      <xsl:apply-templates/>
    </dt>
  </xsl:template>
  <xsl:template match="dd">
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>
  <xsl:template match="li">
    <li>
      <xsl:if test="@value">
        <xsl:attribute name="value">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="table">
    <table class="table table-condensed">
      <xsl:if test="@summary">
        <xsl:attribute name="summary">
          <xsl:value-of select="@summary"/>
        </xsl:attribute>
      </xsl:if><xsl:if test="@class">
        <xsl:attribute name="class">
          <xsl:value-of select="@class"/>
          <xsl:text> table table-condensed</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="caption">
    <caption>
      <xsl:apply-templates/>
    </caption>
  </xsl:template>
  <xsl:template match="colgroup[@scope]">
    <colgroup>
      <xsl:attribute name="scope">
        <xsl:value-of select="@scope"/>
      </xsl:attribute>
    </colgroup>
  </xsl:template>
  <xsl:template match="thead">
    <thead>
      <xsl:apply-templates/>
    </thead>
  </xsl:template>
  <xsl:template match="tfoot">
    <tfoot>
      <xsl:apply-templates/>
    </tfoot>
  </xsl:template>
  <xsl:template match="tbody">
    <tbody>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>
  <xsl:template match="tr">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  <xsl:template match="th">
    <th>
      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@char">
        <xsl:attribute name="char">
          <xsl:value-of select="@char"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@rowspan">
        <xsl:attribute name="rowspan">
          <xsl:value-of select="@rowspan"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan">
          <xsl:value-of select="@colspan"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@axis">
        <xsl:attribute name="axis">
          <xsl:value-of select="@axis"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@scope">
        <xsl:attribute name="scope">
          <xsl:value-of select="@scope"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@class">
        <xsl:attribute name="class">
          <xsl:value-of select="@class"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </th>
  </xsl:template>
  <xsl:template match="td">
    <td>
      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@char">
        <xsl:attribute name="char">
          <xsl:value-of select="@char"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@rowspan">
        <xsl:attribute name="rowspan">
          <xsl:value-of select="@rowspan"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan">
          <xsl:value-of select="@colspan"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@axis">
        <xsl:attribute name="axis">
          <xsl:value-of select="@axis"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@scope">
        <xsl:attribute name="scope">
          <xsl:value-of select="@scope"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@scope">
        <xsl:attribute name="scope">
          <xsl:value-of select="@scope"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@class">
        <xsl:attribute name="class">
          <xsl:value-of select="@class"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <xsl:template match="combat">
    <p class="combat">
      <xsl:apply-templates select="enemy"/>
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
          <xsl:value-of select="enemy-attribute[@class='combatskill']"/>
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
          <xsl:value-of select="enemy-attribute[@class='closecombatskill']"/>
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
              <xsl:text> (o </xsl:text>
              <span class="smallcaps">BLANCOS</span>
              <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> (</xsl:text>
              <span class="smallcaps">TARGET</span>
              <xsl:text> points)</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>&nbsp;</xsl:text>
          <xsl:value-of select="enemy-attribute[@class='target']"/>
        </xsl:when>
        <xsl:when test="enemy-attribute[@class='resistance']">
          <xsl:choose>
            <xsl:when test="$language='es'"/>
            <xsl:otherwise>
              <xsl:text> (</xsl:text>
              <span class="smallcaps">RESISTANCE</span>
              <xsl:text> points)</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>&nbsp;</xsl:text>
          <xsl:value-of select="enemy-attribute[@class='resistance']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&nbsp;</xsl:text>
          <xsl:value-of select="enemy-attribute[@class='endurance']"/>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>
  <xsl:template match="choice">
    <xsl:variable name="link">
      <xsl:value-of select="@idref"/>
    </xsl:variable>
    <p class="choice">
      <xsl:for-each select="* | text()">
        <xsl:choose>
          <xsl:when test="self::link-text">
            <a href="{$link}.htm">
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </p>
  </xsl:template>
  <xsl:template match="puzzle">
    <p class="puzzle">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="deadend">
    <p class="deadend">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="data/signpost">
    <div class="signpost">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="signpost">
    <span class="signpost">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="blockquote">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  <xsl:template match="poetry">
    <blockquote class="poetry">
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  <xsl:template match="illref">
    <!-- It is important that the class is not checked right in the template - that would make this template match with higher priority, which will turn a few things upside down -->
    <xsl:if test="@class='html'">
      <xsl:for-each select="id( @idref )">
        <!-- This creates unneccessary regeneration of float illustration pages, but it is easiest to keep things this way as long as we have to be backwards compatible... -->
        <!-- When backwards compatibility can be dropped, most of (all?) the <illustration> processing can happen here -->
        <xsl:apply-templates select="."/>
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
                <xsl:attribute name="href">
                  <xsl:text>ill</xsl:text>
                  <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1"/>
                  <xsl:text>.htm</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$language='es'">
                    <xsl:text>Ilustraci&oacute;n </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Illustration </xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I"/>
              </a>
              <!-- List the sections that the illustration appears in -->
              <xsl:text> (</xsl:text>
              <xsl:for-each select="//illref[@class='html' and @idref=current()/@id]">
                <xsl:call-template name="section-title-link"/>
                <xsl:if test="position()!=last()">
                  <xsl:text>, </xsl:text>
                </xsl:if>
              </xsl:for-each>
              <xsl:text>)</xsl:text>
            </li>
            <!-- Call the backwards compatible template for generating the illustration page -->
            <xsl:call-template name="xhtml-wrapper">
              <xsl:with-param name="document-type">illustration</xsl:with-param>
              <xsl:with-param name="filename">
                <xsl:text>ill</xsl:text>
                <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) ) ]" from="/" level="any" format="1"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="self::illustration">
            <!-- inline and map -->
            <!-- List the sections that the illustration appears in -->
            <li>
              <!-- TODO: fix this so that sections that do not represent separate XHTML files are not linked to? -->
              <xsl:for-each select="//illref[@class='html' and @idref=current()/@id]">
                <xsl:call-template name="section-title-link"/>
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
                  <xsl:attribute name="href">
                    <xsl:value-of select="@idref"/>
                    <xsl:text>.htm</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="id(@idref)/meta/title[1]"/>
                </a>
              </li>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>
  <xsl:template match="illustration">
    <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
    <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
    <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
    <xsl:variable name="illustration-width-adjusted">
      <xsl:number value="$illustration-width div 2"/>
    </xsl:variable>
    <xsl:variable name="illustration-height-adjusted">
      <xsl:number value="$illustration-height div 2"/>
    </xsl:variable>
    <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
      <xsl:choose>
        <xsl:when test="@class='float'">
          <xsl:call-template name="illustration-framed">
            <xsl:with-param name="illustration-width">
              <xsl:value-of select="$illustration-width-adjusted"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-height">
              <xsl:value-of select="$illustration-height-adjusted"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-src">
              <xsl:value-of select="$illustration-src"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-href">
              <xsl:text>ill</xsl:text>
              <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1"/>
              <xsl:text>.htm</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="xhtml-wrapper">
            <xsl:with-param name="document-type">illustration</xsl:with-param>
            <xsl:with-param name="filename">
              <xsl:text>ill</xsl:text>
              <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) ) ]" from="/" level="any" format="1"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@class='accent'"/>
        <xsl:otherwise>
          <xsl:call-template name="illustration-framed">
            <xsl:with-param name="illustration-width">
              <xsl:value-of select="$illustration-width"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-height">
              <xsl:value-of select="$illustration-height"/>
            </xsl:with-param>
            <xsl:with-param name="illustration-src">
              <xsl:value-of select="$illustration-src"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="instance"/>
  <xsl:template match="footnotes"/>
  <xsl:template match="footnote"/>
  <xsl:template match="hr">
    <hr/>
  </xsl:template>
  <xsl:template match="choose">
    <xsl:choose>
      <xsl:when test="@test='has-numbered-section-list'">
        <xsl:choose>
          <xsl:when test="when[@value='true']">
            <xsl:apply-templates select="when[@value='true'][1]/node()"/>
          </xsl:when>
          <xsl:when test="otherwise">
            <!-- this should only be applied when there is no option for "true" -->
            <xsl:apply-templates select="otherwise/node()"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>choose: unrecognized test "</xsl:text>
          <xsl:value-of select="@test"/>
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
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          <xsl:if test="@id">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:if test="@idref">
            <xsl:variable name="my-idref" select="@idref"/>
            <xsl:attribute name="href">
              <xsl:choose>
                <!-- The order of these tests is deliberate. They are ordered roughly from most to least specific. -->
                <xsl:when test="/gamebook/section[@id=$my-idref] | /gamebook/section/data/section[@id=$my-idref]">
                  <xsl:value-of select="$my-idref"/>
                  <xsl:text>.htm</xsl:text>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and @id=$my-idref]">
                  <xsl:value-of select="$my-idref"/>
                  <xsl:text>.htm</xsl:text>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and @id=$my-idref]">
                  <xsl:value-of select="$my-idref"/>
                  <xsl:text>.htm</xsl:text>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='numbered' and @id=$my-idref]">
                  <xsl:value-of select="$my-idref"/>
                  <xsl:text>.htm</xsl:text>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='glossary-separate' and @id=$my-idref]">
                  <xsl:value-of select="$my-idref"/>
                  <xsl:text>.htm</xsl:text>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and descendant::*[@id=$my-idref]]">
                  <xsl:value-of select="/gamebook/section/data/section/data/section[@class='frontmatter-separate' and descendant::*[@id=$my-idref]]/@id"/>
                  <xsl:text>.htm#</xsl:text>
                  <xsl:value-of select="$my-idref"/>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and descendant::*[@id=$my-idref]]">
                  <xsl:value-of select="/gamebook/section/data/section/data/section[@class='mainmatter-separate' and descendant::*[@id=$my-idref]]/@id"/>
                  <xsl:text>.htm#</xsl:text>
                  <xsl:value-of select="$my-idref"/>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section/data/section[@class='glossary-separate' and descendant::*[@id=$my-idref]]">
                  <xsl:value-of select="/gamebook/section/data/section/data/section[@class='glossary-separate' and descendant::*[@id=$my-idref]]/@id"/>
                  <xsl:text>.htm#</xsl:text>
                  <xsl:value-of select="$my-idref"/>
                </xsl:when>
                <xsl:when test="/gamebook/section/data/section[descendant::*[@id=$my-idref]]">
                  <xsl:value-of select="/gamebook/section/data/section[descendant::*[@id=$my-idref]]/@id"/>
                  <xsl:text>.htm#</xsl:text>
                  <xsl:value-of select="$my-idref"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>[error: a template]</xsl:text>
                  <xsl:message>
                    <xsl:text>error: a template</xsl:text>
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@id">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- TODO: can this be made more uniform with illrefs? -->
  <xsl:template match="a[@class='accent-illustration']">
    <xsl:for-each select="id( @idref )">
      <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
      <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
      <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
      <xsl:if test="instance[@class='html'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
        <img src="{$illustration-src}" class="accent" width="{$illustration-width}" height="{$illustration-height}" alt="" border="" align="left"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="bookref">
    <a>
      <xsl:attribute name="href">
        <xsl:variable name="my-section">
          <xsl:choose>
            <xsl:when test="@section">
              <xsl:value-of select="@section"/>
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
              <xsl:text>/../</xsl:text>
              <xsl:value-of select="@series"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:text>..</xsl:text>
        <xsl:value-of select="$my-series"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="@book"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$my-section"/>
        <xsl:text>.htm</xsl:text>
      </xsl:attribute>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  <xsl:template match="footref">
    <xsl:apply-templates/>
    <sup>
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="@idref"/>
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:number count="footref" from="/" level="any" format="1"/>
      </a>
    </sup>
  </xsl:template>
  <xsl:template match="em">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="strong">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  <xsl:template match="thought">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  <xsl:template match="onomatopoeia">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  <xsl:template match="spell">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  <xsl:template match="item">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  <xsl:template match="foreign">
    <i>
      <xsl:attribute name="xml:lang">
        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  <xsl:template match="quote">
    <xsl:text>&#x2018;</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="not(self::*[@class='open-ended'])">
      <xsl:text>&#x2019;</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template match="quote//quote">
    <xsl:text>&#x201C;</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="not(self::*[@class='open-ended'])">
      <xsl:text>&#x201D;</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template match="cite">
    <cite>
      <xsl:apply-templates/>
    </cite>
  </xsl:template>
  <xsl:template match="code">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>
  <xsl:template match="line">
    <xsl:apply-templates/>
    <xsl:if test="position( ) != last( )">
      <br/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="br">
    <br/>
  </xsl:template>
  <xsl:template match="typ[@class='attribute']">
    <span class="smallcaps">
      <xsl:apply-templates/>
    </span>
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
  <xsl:template match="ch.apos">
    <xsl:text>&#x2019;</xsl:text>
  </xsl:template>
  <!-- apostrophe = single quotation mark -->
  <xsl:template match="ch.nbsp">
    <xsl:text>&#xA0;</xsl:text>
  </xsl:template>
  <!-- no-break space = non-breaking space, U+00A0 ISOnum -->
  <xsl:template match="ch.iexcl">
    <xsl:text>&#xA1;</xsl:text>
  </xsl:template>
  <!-- inverted exclamation mark, U+00A1 ISOnum -->
  <xsl:template match="ch.cent">
    <xsl:text>&#xA2;</xsl:text>
  </xsl:template>
  <!-- cent sign, U+00A2 ISOnum -->
  <xsl:template match="ch.pound">
    <xsl:text>&#xA3;</xsl:text>
  </xsl:template>
  <!-- pound sign, U+00A3 ISOnum -->
  <xsl:template match="ch.curren">
    <xsl:text>&#xA4;</xsl:text>
  </xsl:template>
  <!-- currency sign, U+00A4 ISOnum -->
  <xsl:template match="ch.yen">
    <xsl:text>&#xA5;</xsl:text>
  </xsl:template>
  <!-- yen sign = yuan sign, U+00A5 ISOnum -->
  <xsl:template match="ch.brvbar">
    <xsl:text>&#xA6;</xsl:text>
  </xsl:template>
  <!-- broken bar = broken vertical bar, U+00A6 ISOnum -->
  <xsl:template match="ch.sect">
    <xsl:text>&#xA7;</xsl:text>
  </xsl:template>
  <!-- section sign, U+00A7 ISOnum -->
  <xsl:template match="ch.uml">
    <xsl:text>&#xA8;</xsl:text>
  </xsl:template>
  <!-- diaeresis = spacing diaeresis, U+00A8 ISOdia -->
  <xsl:template match="ch.copy">
    <xsl:text>&#xA9;</xsl:text>
  </xsl:template>
  <!-- copyright sign, U+00A9 ISOnum -->
  <xsl:template match="ch.ordf">
    <xsl:text>&#xAA;</xsl:text>
  </xsl:template>
  <!-- feminine ordinal indicator, U+00AA ISOnum -->
  <xsl:template match="ch.laquo">
    <xsl:text>&#xAB;</xsl:text>
  </xsl:template>
  <!-- left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum -->
  <xsl:template match="ch.not">
    <xsl:text>&#xAC;</xsl:text>
  </xsl:template>
  <!-- not sign, U+00AC ISOnum -->
  <xsl:template match="ch.shy">
    <xsl:text>&#xAD;</xsl:text>
  </xsl:template>
  <!-- soft hyphen = discretionary hyphen, U+00AD ISOnum -->
  <xsl:template match="ch.reg">
    <xsl:text>&#xAE;</xsl:text>
  </xsl:template>
  <!-- registered sign = registered trade mark sign, U+00AE ISOnum -->
  <xsl:template match="ch.macr">
    <xsl:text>&#xAF;</xsl:text>
  </xsl:template>
  <!-- macron = spacing macron = overline = APL overbar, U+00AF ISOdia -->
  <xsl:template match="ch.deg">
    <xsl:text>&#xB0;</xsl:text>
  </xsl:template>
  <!-- degree sign, U+00B0 ISOnum -->
  <xsl:template match="ch.plusmn">
    <xsl:text>&#xB1;</xsl:text>
  </xsl:template>
  <!-- plus-minus sign = plus-or-minus sign, U+00B1 ISOnum -->
  <xsl:template match="ch.sup2">
    <xsl:text>&#xB2;</xsl:text>
  </xsl:template>
  <!-- superscript two = superscript digit two = squared, U+00B2 ISOnum -->
  <xsl:template match="ch.sup3">
    <xsl:text>&#xB3;</xsl:text>
  </xsl:template>
  <!-- superscript three = superscript digit three = cubed, U+00B3 ISOnum -->
  <xsl:template match="ch.acute">
    <xsl:text>&#xB4;</xsl:text>
  </xsl:template>
  <!-- acute accent = spacing acute, U+00B4 ISOdia -->
  <xsl:template match="ch.micro">
    <xsl:text>&#xB5;</xsl:text>
  </xsl:template>
  <!-- micro sign, U+00B5 ISOnum -->
  <xsl:template match="ch.para">
    <xsl:text>&#xB6;</xsl:text>
  </xsl:template>
  <!-- pilcrow sign  = paragraph sign, U+00B6 ISOnum -->
  <xsl:template match="ch.middot">
    <xsl:text>&#xB7;</xsl:text>
  </xsl:template>
  <!-- middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum -->
  <xsl:template match="ch.cedil">
    <xsl:text>&#xB8;</xsl:text>
  </xsl:template>
  <!-- cedilla = spacing cedilla, U+00B8 ISOdia -->
  <xsl:template match="ch.sup1">
    <xsl:text>&#xB9;</xsl:text>
  </xsl:template>
  <!-- superscript one = superscript digit one, U+00B9 ISOnum -->
  <xsl:template match="ch.ordm">
    <xsl:text>&#xBA;</xsl:text>
  </xsl:template>
  <!-- masculine ordinal indicator, U+00BA ISOnum -->
  <xsl:template match="ch.raquo">
    <xsl:text>&#xBB;</xsl:text>
  </xsl:template>
  <!-- right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum -->
  <xsl:template match="ch.frac14">
    <xsl:text>&#xBC;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum -->
  <xsl:template match="ch.frac12">
    <xsl:text>&#xBD;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction one half = fraction one half, U+00BD ISOnum -->
  <xsl:template match="ch.frac34">
    <xsl:text>&#xBE;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum -->
  <xsl:template match="ch.frac13">
    <xsl:text>&#x2153;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/3, U+2153 ISOnum -->
  <xsl:template match="ch.frac23">
    <xsl:text>&#x2154;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 2/3, U+2154 ISOnum -->
  <xsl:template match="ch.frac15">
    <xsl:text>&#x2155;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/5, U+2155 ISOnum -->
  <xsl:template match="ch.frac25">
    <xsl:text>&#x2156;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 2/5, U+2156 ISOnum -->
  <xsl:template match="ch.frac35">
    <xsl:text>&#x2157;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 3/5, U+2157 ISOnum -->
  <xsl:template match="ch.frac45">
    <xsl:text>&#x2158;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 4/5, U+2158 ISOnum -->
  <xsl:template match="ch.frac16">
    <xsl:text>&#x2159;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/6, U+2159 ISOnum -->
  <xsl:template match="ch.frac56">
    <xsl:text>&#x215A;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 5/6, U+215A ISOnum -->
  <xsl:template match="ch.frac17">
    <xsl:text>&#x2150;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/7, U+2150 ISOnum -->
  <xsl:template match="ch.frac18">
    <xsl:text>&#x215B;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/8, U+215B ISOnum -->
  <xsl:template match="ch.frac38">
    <xsl:text>&#x215C;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 3/8, U+215C ISOnum -->
  <xsl:template match="ch.frac58">
    <xsl:text>&#x215D;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 5/8, U+215D ISOnum -->
  <xsl:template match="ch.frac78">
    <xsl:text>&#x215E;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 7/8, U+215E ISOnum -->
  <xsl:template match="ch.frac19">
    <xsl:text>&#x2151;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/9, U+2151 ISOnum -->
  <xsl:template match="ch.frac110">
    <xsl:text>&#x2152;</xsl:text>
  </xsl:template>
  <!-- vulgar fraction 1/10, U+2152 ISO num -->
  <xsl:template match="ch.iquest">
    <xsl:text>&#xBF;</xsl:text>
  </xsl:template>
  <!-- inverted question mark = turned question mark, U+00BF ISOnum -->
  <xsl:template match="ch.Agrave">
    <xsl:text>&#xC0;</xsl:text>
  </xsl:template>
  <!-- latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1 -->
  <xsl:template match="ch.Aacute">
    <xsl:text>&#xC1;</xsl:text>
  </xsl:template>
  <!-- latin capital letter A with acute, U+00C1 ISOlat1 -->
  <xsl:template match="ch.Acirc">
    <xsl:text>&#xC2;</xsl:text>
  </xsl:template>
  <!-- latin capital letter A with circumflex, U+00C2 ISOlat1 -->
  <xsl:template match="ch.Atilde">
    <xsl:text>&#xC3;</xsl:text>
  </xsl:template>
  <!-- latin capital letter A with tilde, U+00C3 ISOlat1 -->
  <xsl:template match="ch.Auml">
    <xsl:text>&#xC4;</xsl:text>
  </xsl:template>
  <!-- latin capital letter A with diaeresis, U+00C4 ISOlat1 -->
  <xsl:template match="ch.Aring">
    <xsl:text>&#xC5;</xsl:text>
  </xsl:template>
  <!-- latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1 -->
  <xsl:template match="ch.AElig">
    <xsl:text>&#xC6;</xsl:text>
  </xsl:template>
  <!-- latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1 -->
  <xsl:template match="ch.Ccedil">
    <xsl:text>&#xC7;</xsl:text>
  </xsl:template>
  <!-- latin capital letter C with cedilla, U+00C7 ISOlat1 -->
  <xsl:template match="ch.Egrave">
    <xsl:text>&#xC8;</xsl:text>
  </xsl:template>
  <!-- latin capital letter E with grave, U+00C8 ISOlat1 -->
  <xsl:template match="ch.Eacute">
    <xsl:text>&#xC9;</xsl:text>
  </xsl:template>
  <!-- latin capital letter E with acute, U+00C9 ISOlat1 -->
  <xsl:template match="ch.Ecirc">
    <xsl:text>&#xCA;</xsl:text>
  </xsl:template>
  <!-- latin capital letter E with circumflex, U+00CA ISOlat1 -->
  <xsl:template match="ch.Euml">
    <xsl:text>&#xCB;</xsl:text>
  </xsl:template>
  <!-- latin capital letter E with diaeresis, U+00CB ISOlat1 -->
  <xsl:template match="ch.Igrave">
    <xsl:text>&#xCC;</xsl:text>
  </xsl:template>
  <!-- latin capital letter I with grave, U+00CC ISOlat1 -->
  <xsl:template match="ch.Iacute">
    <xsl:text>&#xCD;</xsl:text>
  </xsl:template>
  <!-- latin capital letter I with acute, U+00CD ISOlat1 -->
  <xsl:template match="ch.Icirc">
    <xsl:text>&#xCE;</xsl:text>
  </xsl:template>
  <!-- latin capital letter I with circumflex, U+00CE ISOlat1 -->
  <xsl:template match="ch.Iuml">
    <xsl:text>&#xCF;</xsl:text>
  </xsl:template>
  <!-- latin capital letter I with diaeresis, U+00CF ISOlat1 -->
  <xsl:template match="ch.ETH">
    <xsl:text>&#xD0;</xsl:text>
  </xsl:template>
  <!-- latin capital letter ETH, U+00D0 ISOlat1 -->
  <xsl:template match="ch.Ntilde">
    <xsl:text>&#xD1;</xsl:text>
  </xsl:template>
  <!-- latin capital letter N with tilde, U+00D1 ISOlat1 -->
  <xsl:template match="ch.Ograve">
    <xsl:text>&#xD2;</xsl:text>
  </xsl:template>
  <!-- latin capital letter O with grave, U+00D2 ISOlat1 -->
  <xsl:template match="ch.Oacute">
    <xsl:text>&#xD3;</xsl:text>
  </xsl:template>
  <!-- latin capital letter O with acute, U+00D3 ISOlat1 -->
  <xsl:template match="ch.Ocirc">
    <xsl:text>&#xD4;</xsl:text>
  </xsl:template>
  <!-- latin capital letter O with circumflex, U+00D4 ISOlat1 -->
  <xsl:template match="ch.Otilde">
    <xsl:text>&#xD5;</xsl:text>
  </xsl:template>
  <!-- latin capital letter O with tilde, U+00D5 ISOlat1 -->
  <xsl:template match="ch.Ouml">
    <xsl:text>&#xD6;</xsl:text>
  </xsl:template>
  <!-- latin capital letter O with diaeresis, U+00D6 ISOlat1 -->
  <xsl:template match="ch.times">
    <xsl:text>&#xD7;</xsl:text>
  </xsl:template>
  <!-- multiplication sign, U+00D7 ISOnum -->
  <xsl:template match="ch.Oslash">
    <xsl:text>&#xD8;</xsl:text>
  </xsl:template>
  <!-- latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1 -->
  <xsl:template match="ch.Ugrave">
    <xsl:text>&#xD9;</xsl:text>
  </xsl:template>
  <!-- latin capital letter U with grave, U+00D9 ISOlat1 -->
  <xsl:template match="ch.Uacute">
    <xsl:text>&#xDA;</xsl:text>
  </xsl:template>
  <!-- latin capital letter U with acute, U+00DA ISOlat1 -->
  <xsl:template match="ch.Ucirc">
    <xsl:text>&#xDB;</xsl:text>
  </xsl:template>
  <!-- latin capital letter U with circumflex, U+00DB ISOlat1 -->
  <xsl:template match="ch.Uuml">
    <xsl:text>&#xDC;</xsl:text>
  </xsl:template>
  <!-- latin capital letter U with diaeresis, U+00DC ISOlat1 -->
  <xsl:template match="ch.Yacute">
    <xsl:text>&#xDD;</xsl:text>
  </xsl:template>
  <!-- latin capital letter Y with acute, U+00DD ISOlat1 -->
  <xsl:template match="ch.THORN">
    <xsl:text>&#xDE;</xsl:text>
  </xsl:template>
  <!-- latin capital letter THORN, U+00DE ISOlat1 -->
  <xsl:template match="ch.szlig">
    <xsl:text>&#xDF;</xsl:text>
  </xsl:template>
  <!-- latin small letter sharp s = ess-zed, U+00DF ISOlat1 -->
  <xsl:template match="ch.agrave">
    <xsl:text>&#xE0;</xsl:text>
  </xsl:template>
  <!-- latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1 -->
  <xsl:template match="ch.aacute">
    <xsl:text>&#xE1;</xsl:text>
  </xsl:template>
  <!-- latin small letter a with acute, U+00E1 ISOlat1 -->
  <xsl:template match="ch.acirc">
    <xsl:text>&#xE2;</xsl:text>
  </xsl:template>
  <!-- latin small letter a with circumflex, U+00E2 ISOlat1 -->
  <xsl:template match="ch.atilde">
    <xsl:text>&#xE3;</xsl:text>
  </xsl:template>
  <!-- latin small letter a with tilde, U+00E3 ISOlat1 -->
  <xsl:template match="ch.auml">
    <xsl:text>&#xE4;</xsl:text>
  </xsl:template>
  <!-- latin small letter a with diaeresis, U+00E4 ISOlat1 -->
  <xsl:template match="ch.aring">
    <xsl:text>&#xE5;</xsl:text>
  </xsl:template>
  <!-- latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1 -->
  <xsl:template match="ch.aelig">
    <xsl:text>&#xE6;</xsl:text>
  </xsl:template>
  <!-- latin small letter ae = latin small ligature ae, U+00E6 ISOlat1 -->
  <xsl:template match="ch.ccedil">
    <xsl:text>&#xE7;</xsl:text>
  </xsl:template>
  <!-- latin small letter c with cedilla, U+00E7 ISOlat1 -->
  <xsl:template match="ch.egrave">
    <xsl:text>&#xE8;</xsl:text>
  </xsl:template>
  <!-- latin small letter e with grave, U+00E8 ISOlat1 -->
  <xsl:template match="ch.eacute">
    <xsl:text>&#xE9;</xsl:text>
  </xsl:template>
  <!-- latin small letter e with acute, U+00E9 ISOlat1 -->
  <xsl:template match="ch.ecirc">
    <xsl:text>&#xEA;</xsl:text>
  </xsl:template>
  <!-- latin small letter e with circumflex, U+00EA ISOlat1 -->
  <xsl:template match="ch.euml">
    <xsl:text>&#xEB;</xsl:text>
  </xsl:template>
  <!-- latin small letter e with diaeresis, U+00EB ISOlat1 -->
  <xsl:template match="ch.igrave">
    <xsl:text>&#xEC;</xsl:text>
  </xsl:template>
  <!-- latin small letter i with grave, U+00EC ISOlat1 -->
  <xsl:template match="ch.iacute">
    <xsl:text>&#xED;</xsl:text>
  </xsl:template>
  <!-- latin small letter i with acute, U+00ED ISOlat1 -->
  <xsl:template match="ch.icirc">
    <xsl:text>&#xEE;</xsl:text>
  </xsl:template>
  <!-- latin small letter i with circumflex, U+00EE ISOlat1 -->
  <xsl:template match="ch.iuml">
    <xsl:text>&#xEF;</xsl:text>
  </xsl:template>
  <!-- latin small letter i with diaeresis, U+00EF ISOlat1 -->
  <xsl:template match="ch.eth">
    <xsl:text>&#xF0;</xsl:text>
  </xsl:template>
  <!-- latin small letter eth, U+00F0 ISOlat1 -->
  <xsl:template match="ch.ntilde">
    <xsl:text>&#xF1;</xsl:text>
  </xsl:template>
  <!-- latin small letter n with tilde, U+00F1 ISOlat1 -->
  <xsl:template match="ch.ograve">
    <xsl:text>&#xF2;</xsl:text>
  </xsl:template>
  <!-- latin small letter o with grave, U+00F2 ISOlat1 -->
  <xsl:template match="ch.oacute">
    <xsl:text>&#xF3;</xsl:text>
  </xsl:template>
  <!-- latin small letter o with acute, U+00F3 ISOlat1 -->
  <xsl:template match="ch.ocirc">
    <xsl:text>&#xF4;</xsl:text>
  </xsl:template>
  <!-- latin small letter o with circumflex, U+00F4 ISOlat1 -->
  <xsl:template match="ch.otilde">
    <xsl:text>&#xF5;</xsl:text>
  </xsl:template>
  <!-- latin small letter o with tilde, U+00F5 ISOlat1 -->
  <xsl:template match="ch.ouml">
    <xsl:text>&#xF6;</xsl:text>
  </xsl:template>
  <!-- latin small letter o with diaeresis, U+00F6 ISOlat1 -->
  <xsl:template match="ch.divide">
    <xsl:text>&#xF7;</xsl:text>
  </xsl:template>
  <!-- division sign, U+00F7 ISOnum -->
  <xsl:template match="ch.oslash">
    <xsl:text>&#xF8;</xsl:text>
  </xsl:template>
  <!-- latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1 -->
  <xsl:template match="ch.ugrave">
    <xsl:text>&#xF9;</xsl:text>
  </xsl:template>
  <!-- latin small letter u with grave, U+00F9 ISOlat1 -->
  <xsl:template match="ch.uacute">
    <xsl:text>&#xFA;</xsl:text>
  </xsl:template>
  <!-- latin small letter u with acute, U+00FA ISOlat1 -->
  <xsl:template match="ch.ucirc">
    <xsl:text>&#xFB;</xsl:text>
  </xsl:template>
  <!-- latin small letter u with circumflex, U+00FB ISOlat1 -->
  <xsl:template match="ch.uuml">
    <xsl:text>&#xFC;</xsl:text>
  </xsl:template>
  <!-- latin small letter u with diaeresis, U+00FC ISOlat1 -->
  <xsl:template match="ch.yacute">
    <xsl:text>&#xFD;</xsl:text>
  </xsl:template>
  <!-- latin small letter y with acute, U+00FD ISOlat1 -->
  <xsl:template match="ch.thorn">
    <xsl:text>&#xFE;</xsl:text>
  </xsl:template>
  <!-- latin small letter thorn, U+00FE ISOlat1 -->
  <xsl:template match="ch.yuml">
    <xsl:text>&#xFF;</xsl:text>
  </xsl:template>
  <!-- latin small letter y with diaeresis, U+00FF ISOlat1 -->
  <!-- ~~~~~~~~~~~~~~~~~~~~~ Special Characters ~~~~~~~~~~~~~~~~~~~~ -->
  <xsl:template match="ch.ampersand">&amp;</xsl:template>
  <!-- ampersand -->
  <xsl:template match="ch.lsquot">&#x2018;</xsl:template>
  <!-- opening left quotation mark -->
  <xsl:template match="ch.rsquot">&#x2019;</xsl:template>
  <!-- closing right quotation mark -->
  <xsl:template match="ch.ldquot">&#x201C;</xsl:template>
  <!-- opening left double quotation mark -->
  <xsl:template match="ch.rdquot">&#x201D;</xsl:template>
  <!-- closing right double quotation mark -->
  <xsl:template match="ch.minus">&#x2212;</xsl:template>
  <!-- mathematical minus -->
  <xsl:template match="ch.endash">&#x2013;</xsl:template>
  <!-- endash -->
  <xsl:template match="ch.emdash">&#x2014;</xsl:template>
  <!-- emdash -->
  <xsl:template match="ch.ellips">&#x2009;&#x2026;&#x2009;</xsl:template>
  <!-- ellipsis -->
  <xsl:template match="ch.lellips">&#x2026;&#x2009;</xsl:template>
  <!-- left ellipsis, used at the beginning of edited material -->
  <xsl:template match="ch.blankline">_______</xsl:template>
  <!-- blank line to be filled in -->
  <xsl:template match="ch.percent">
    <xsl:text>%</xsl:text>
  </xsl:template>
  <!-- percent sign -->
  <xsl:template match="ch.thinspace">
    <xsl:text>&#x2009;</xsl:text>
  </xsl:template>
  <!-- small horizontal space for use between adjacent quotation marks - added mainly for LaTeX's sake -->
  <xsl:template match="ch.frac116">
    <xsl:text>1/16</xsl:text>
  </xsl:template>
  <!-- vulgar fraction one sixteenth = fraction one sixteenth -->
  <xsl:template match="ch.plus">
    <xsl:text>+</xsl:text>
  </xsl:template>
  <!-- mathematical plus -->
  <xsl:template match="ch.lte">
    <xsl:text>&#x2264;</xsl:text>
  </xsl:template>
  <!-- less-than or equal to -->
  <xsl:template match="ch.gte">
    <xsl:text>&#x2265;</xsl:text>
  </xsl:template>
  <!-- greater-than or equal to -->

  <!-- ==================== named templates ======================= -->
  <xsl:template name="xhtml-wrapper">
    <xsl:param name="document-type">undefined</xsl:param>
    <xsl:param name="filename">undefined</xsl:param>
    <xsl:param name="glossary-id-prefix"/>
    <redirect:write file="{$filename}.htm">
      <xsl:fallback>
        <xsl:text>xhtml-wrapper: Cannot write to filename: "</xsl:text>
        <xsl:value-of select="$filename"/>
        <xsl:text>.htm"</xsl:text>
      </xsl:fallback>
      <html xml:lang="en-UK" lang="en-UK">
        <head>
          <!-- <meta charset...> generated automatically by HTML5 output -->
          <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
          <meta name="viewport" content="width=device-width, initial-scale=1"/>
          <title>
            <xsl:apply-templates select="/gamebook/meta/title[1]"/>
            <xsl:text>: </xsl:text>
            <xsl:choose>
              <xsl:when test="$document-type='illustration'">
                <xsl:choose>
                  <xsl:when test="$language='es'">
                    <xsl:text>Ilustraci&oacute;n </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Illustration </xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="meta/title[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </title>
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"/>
          <xsl:comment>HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries</xsl:comment>
          <xsl:comment>WARNING: Respond.js doesn't work if you view the page via file://</xsl:comment>
          <xsl:comment>[if lt IE 9]&gt;
    &lt;script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"&gt;&lt;/script&gt;
    &lt;script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"&gt;&lt;/script&gt;
  &lt;![endif]</xsl:comment>
          <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
          <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
          <link rel="stylesheet" href="main.css" type="text/css"/>
          <meta name="robots" content="noindex,nofollow"/>
        </head>
        <body>
          <div class="container">
          <header id="main-header">
            <div id="logos"><img id="logo" src="lonewolf.png" alt="" /><img id="project-aon-logo" src="palogo.png" /></div>
            <h1><xsl:apply-templates select="/gamebook/meta/title[1]"/></h1>
            <h2><xsl:apply-templates select="/gamebook/meta/creator[@class='short']"/></h2>
          </header>

          <article>
            <xsl:choose>
              <!-- ~~~~~~~~~~~~~~~~~~~~~~~~ top-level ~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='top-level'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
                    <xsl:apply-templates select="/gamebook/meta/description[@class='blurb']"/>
                    <xsl:apply-templates select="/gamebook/meta/creator[@class='long']"/>
                    <hr/>
                    <xsl:apply-templates select="/gamebook/meta/description[@class='publication']"/>
                    <p>
                      <xsl:choose>
                        <xsl:when test="$language='es'">
                          <xsl:text>Fecha de Publicaci&oacute;n: </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>Publication Date: </xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="/gamebook/meta/date[@class='publication']/day"/>
                      <xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 1">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de enero de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>January</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 2">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de febrero de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>February</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 3">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de marzo de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>March</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 4">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de abril de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>April</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 5">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de mayo de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>May</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 6">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de junio de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>June</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 7">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de julio de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>July</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 8">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de agosto de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>August</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 9">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de septiembre de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>September</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 10">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de octubre de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>October</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 11">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de noviembre de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>November</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="/gamebook/meta/date[@class='publication']/month = 12">
                          <xsl:choose>
                            <xsl:when test="$language='es'">
                              <xsl:text>de diciembre de</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>December</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>Invalid Month</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="/gamebook/meta/date[@class='publication']/year"/>
                    </p>
                    <xsl:apply-templates select="/gamebook/meta/rights[@class='license-notification']"/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~ toc ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='toc'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
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
                      <li>
                        <a href="title.htm">
                          <xsl:value-of select="$title-page"/>
                        </a>
                      </li>
                      <xsl:for-each select="/gamebook/section/data/section">
                        <li>
                          <a>
                            <xsl:attribute name="href">
                              <xsl:value-of select="@id"/>
                              <xsl:text>.htm</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select="meta/title[1]"/>
                          </a>
                          <xsl:if test="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
                            <ul>
                              <xsl:for-each select="data/section[@class='frontmatter-separate' or @class='mainmatter-separate']">
                                <li>
                                  <a>
                                    <xsl:attribute name="href">
                                      <xsl:value-of select="@id"/>
                                      <xsl:text>.htm</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="meta/title[1]"/>
                                  </a>
                                </li>
                              </xsl:for-each>
                            </ul>
                          </xsl:if>
                        </li>
                      </xsl:for-each>
                    </ul>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~ second-level-frontmatter ~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='second-level-frontmatter'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~ third-level-frontmatter-separate ~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='third-level-frontmatter-separate'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
                    <h3>
                      <xsl:apply-templates select="meta/title"/>
                    </h3>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~ second-level-mainmatter ~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='second-level-mainmatter'">
                <div class="mainmatter">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~ third-level-mainmatter-separate ~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='third-level-mainmatter-separate'">
                <div class="mainmatter">
                  <div class="maintext table-responsive">
                    <h3>
                      <xsl:apply-templates select="meta/title"/>
                    </h3>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~ second-level-glossary ~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='second-level-glossary'">
                <div class="mainmatter">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="alpha-bar">
                    <xsl:with-param name="alpha-bar-id-prefix">
                      <xsl:value-of select="$glossary-id-prefix"/>
                    </xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~ third-level-glossary-separate ~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='third-level-glossary-separate'">
                <div class="glossary">
                  <div class="maintext table-responsive">
                    <h3>
                      <xsl:apply-templates select="meta/title"/>
                    </h3>
                    <xsl:call-template name="alpha-bar">
                      <xsl:with-param name="alpha-bar-id-prefix">
                        <xsl:value-of select="$glossary-id-prefix"/>
                      </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~ second-level-numbered ~~~~~~~~~~~~~~~~~~~~ -->
              <!--

              The following automatically generated section list requires that the
              title of each section be a simple number.

              -->
              <xsl:when test="$document-type='second-level-numbered'">
                <div class="numbered">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
                    <xsl:variable name="base-section-number" select="number( data/section[1]/meta/title ) - 1"/>
                    <p>
                      <xsl:for-each select="data/section">
                        <xsl:if test="position( ) mod 10 = 1">
                          <b>
                            <a>
                              <xsl:attribute name="id">
                                <xsl:value-of select="position( ) + $base-section-number"/>
                              </xsl:attribute>
                              <xsl:value-of select="position( ) + $base-section-number"/>
                              <xsl:if test="not( position( ) = last( ) )">
                                <xsl:text>-</xsl:text>
                                <xsl:choose>
                                  <xsl:when test="position( ) + 9 &lt;= last( )">
                                    <xsl:value-of select="position( ) + 9 + $base-section-number"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="last( ) + $base-section-number"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:if>
                            </a>
                            <xsl:text>: </xsl:text>
                          </b>
                        </xsl:if>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:value-of select="@id"/>
                            <xsl:text>.htm</xsl:text>
                          </xsl:attribute>
                          <xsl:apply-templates select="meta/title"/>
                        </a>
                        <xsl:choose>
                          <xsl:when test="position( ) mod 10 = 0">
                            <br/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text> </xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </p>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~ third-level-numbered ~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='third-level-numbered'">
                <div class="numbered">
                  <div class="maintext table-responsive">
                    <h3>
                      <xsl:apply-templates select="meta/title"/>
                    </h3>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~ footnotes ~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='footnotz'">
                <div class="backmatter">
                  <div class="maintext table-responsive">
                    <!-- No particular reason to code title here -->
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
                    <!-- Generate list of footnotes -->
                    <xsl:for-each select="//footnotes/footnote">
                      <div class="footnote">
                        <!-- will the list always contain the closest ancestor first? -->
                        <xsl:variable name="footnote-section">
                          <xsl:value-of select="ancestor::section[position()=1]/@id"/>
                        </xsl:variable>
                        <xsl:variable name="footnote-marker">
                          <xsl:number count="footnotes/footnote" from="/" level="any" format="1"/>
                        </xsl:variable>
                        <xsl:variable name="footnote-idref">
                          <xsl:value-of select="@idref"/>
                        </xsl:variable>
                        <xsl:for-each select="*[1]">
                          <p>
                            <xsl:text>[</xsl:text>
                            <a>
                              <xsl:attribute name="href">
                                <xsl:value-of select="$footnote-section"/>
                                <xsl:text>.htm#</xsl:text>
                                <xsl:value-of select="$footnote-idref"/>
                              </xsl:attribute>
                              <xsl:value-of select="$footnote-marker"/>
                            </a>
                            <xsl:text>] </xsl:text>
                            <xsl:text> (</xsl:text>
                            <xsl:call-template name="section-title-link"/>
                            <xsl:text>) </xsl:text>
                            <xsl:apply-templates select="child::* | child::text()"/>
                          </p>
                        </xsl:for-each>
                        <xsl:for-each select="*[position() != 1]">
                          <xsl:apply-templates select="."/>
                        </xsl:for-each>
                      </div>
                    </xsl:for-each>
                    <!-- Backwards compatibility... needed? Probably not. -->
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~ second-level-backmatter ~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='second-level-backmatter'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
                    <xsl:apply-templates/>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~~~~~~ map-adjusted ~~~~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='map-adjusted'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
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
                          <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
                          <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
                          <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
                          <xsl:variable name="illustration-width-adjusted">
                            <xsl:number value="386"/>
                          </xsl:variable>
                          <xsl:variable name="illustration-height-adjusted">
                            <xsl:number value="$illustration-height * $illustration-width-adjusted div $illustration-width"/>
                          </xsl:variable>
                          <xsl:call-template name="illustration-framed">
                            <xsl:with-param name="illustration-width">
                              <xsl:value-of select="$illustration-width-adjusted"/>
                            </xsl:with-param>
                            <xsl:with-param name="illustration-height">
                              <xsl:value-of select="$illustration-height-adjusted"/>
                            </xsl:with-param>
                            <xsl:with-param name="illustration-src">
                              <xsl:value-of select="$illustration-src"/>
                            </xsl:with-param>
                            <xsl:with-param name="illustration-href">maplarge.htm</xsl:with-param>
                            <xsl:with-param name="illustration-alt-text">
                              <xsl:text>[</xsl:text>
                              <xsl:value-of select="$map-illustration-alt-text"/>
                              <xsl:text>]</xsl:text>
                            </xsl:with-param>
                          </xsl:call-template>
                          <xsl:if test="instance[@class='text']">
                            <xsl:apply-templates select="instance[@class='text']/*"/>
                          </xsl:if>
                        </xsl:when>
                        <xsl:when test="self::illref and @class='html'">
                          <xsl:for-each select="id( @idref )">
                            <xsl:if test="contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
                              <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
                              <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
                              <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
                              <xsl:variable name="illustration-width-adjusted">
                                <xsl:number value="386"/>
                              </xsl:variable>
                              <xsl:variable name="illustration-height-adjusted">
                                <xsl:number value="$illustration-height * $illustration-width-adjusted div $illustration-width"/>
                              </xsl:variable>
                              <xsl:call-template name="illustration-framed">
                                <xsl:with-param name="illustration-width">
                                  <xsl:value-of select="$illustration-width-adjusted"/>
                                </xsl:with-param>
                                <xsl:with-param name="illustration-height">
                                  <xsl:value-of select="$illustration-height-adjusted"/>
                                </xsl:with-param>
                                <xsl:with-param name="illustration-src">
                                  <xsl:value-of select="$illustration-src"/>
                                </xsl:with-param>
                                <xsl:with-param name="illustration-href">maplarge.htm</xsl:with-param>
                                <xsl:with-param name="illustration-alt-text">
                                  <xsl:text>[</xsl:text>
                                  <xsl:value-of select="$map-illustration-alt-text"/>
                                  <xsl:text>]</xsl:text>
                                </xsl:with-param>
                              </xsl:call-template>
                              <xsl:if test="instance[@class='text']">
                                <xsl:apply-templates select="instance[@class='text']/*"/>
                              </xsl:if>
                            </xsl:if>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~ map ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='map'">
                <div class="frontmatter">
                  <div class="maintext table-responsive">
                    <h2>
                      <xsl:apply-templates select="meta/title"/>
                    </h2>
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
                          <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
                          <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
                          <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
                          <xsl:call-template name="illustration-framed">
                            <xsl:with-param name="illustration-width">
                              <xsl:value-of select="$illustration-width"/>
                            </xsl:with-param>
                            <xsl:with-param name="illustration-height">
                              <xsl:value-of select="$illustration-height"/>
                            </xsl:with-param>
                            <xsl:with-param name="illustration-src">
                              <xsl:value-of select="$illustration-src"/>
                            </xsl:with-param>
                            <xsl:with-param name="illustration-href">map.htm</xsl:with-param>
                            <xsl:with-param name="illustration-alt-text">
                              <xsl:text>[</xsl:text>
                              <xsl:value-of select="$map-illustration-alt-text"/>
                              <xsl:text>]</xsl:text>
                            </xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="self::illref and @class='html'">
                          <xsl:for-each select="id( @idref )">
                            <xsl:if test="contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
                              <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
                              <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
                              <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
                              <xsl:call-template name="illustration-framed">
                                <xsl:with-param name="illustration-width">
                                  <xsl:value-of select="$illustration-width"/>
                                </xsl:with-param>
                                <xsl:with-param name="illustration-height">
                                  <xsl:value-of select="$illustration-height"/>
                                </xsl:with-param>
                                <xsl:with-param name="illustration-src">
                                  <xsl:value-of select="$illustration-src"/>
                                </xsl:with-param>
                                <xsl:with-param name="illustration-href">map.htm</xsl:with-param>
                                <xsl:with-param name="illustration-alt-text">
                                  <xsl:text>[</xsl:text>
                                  <xsl:value-of select="$map-illustration-alt-text"/>
                                  <xsl:text>]</xsl:text>
                                </xsl:with-param>
                              </xsl:call-template>
                            </xsl:if>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </div>
                  <xsl:call-template name="navigation-bar"/>
                </div>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~~~~~ illustration ~~~~~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:when test="$document-type='illustration'">
                <xsl:variable name="illustration-width" select="instance[@class='html']/@width"/>
                <xsl:variable name="illustration-height" select="instance[@class='html']/@height"/>
                <xsl:variable name="illustration-src" select="instance[@class='html']/@src"/>
                <h3>
                  <xsl:choose>
                    <xsl:when test="$language='es'">
                      <xsl:text>Ilustraci&oacute;n </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Illustration </xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I"/>
                </h3>
                <xsl:call-template name="illustration-framed">
                  <xsl:with-param name="illustration-width">
                    <xsl:value-of select="$illustration-width"/>
                  </xsl:with-param>
                  <xsl:with-param name="illustration-height">
                    <xsl:value-of select="$illustration-height"/>
                  </xsl:with-param>
                  <xsl:with-param name="illustration-src">
                    <xsl:value-of select="$illustration-src"/>
                  </xsl:with-param>
                </xsl:call-template>
                <figcaption><xsl:apply-templates select="meta/description"/></figcaption>
              </xsl:when>
              <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ error ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
              <xsl:otherwise>
                <xsl:message>
                  <xsl:text>xhtml-wrapper: Cannot process document of type "</xsl:text>
                  <xsl:value-of select="$document-type"/>
                  <xsl:text>".</xsl:text>
                </xsl:message>
                <p>
                  <xsl:text>xhtml-wrapper: Cannot process document of type "</xsl:text>
                  <xsl:value-of select="$document-type"/>
                  <xsl:text>".</xsl:text>
                </p>
              </xsl:otherwise>
            </xsl:choose>
         <xsl:call-template name="process-footnotes"/>
        </article>

      <footer>
       <nav id="page-actions" class="navbar navbar-dever">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#page-actions-navbar-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <div class="collapse navbar-collapse" id="page-actions-navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="toc.htm" title="Table of Contents">Contents</a></li>
            <li><a href="action.htm" title="Action Chart">Action</a></li>
            <li><a href="map.htm" title="Map">Map</a></li>
            <li><a href="random.htm" title="Random Number Table">RNT</a></li>
            <li><a href="crtable.htm" title="Combar Results Table">CRT</a></li>
          </ul>
        </div>
       </nav>
       <div id="license">
         <xsl:apply-templates select="/gamebook/meta/rights[@class='license-notification']"/>
       </div>
      </footer>
    </div>
  </body>
      </html>
    </redirect:write>
  </xsl:template>
  <xsl:template name="process-footnotes">
    <xsl:if test="footnotes/footnote">
      <section id="footnotes">
        <h4>Footnotes</h4>
        <xsl:for-each select="footnotes/footnote">
          <xsl:variable name="footnote-idref" select="@idref"/>
          <xsl:variable name="footnote-id" select="@id"/>
          <xsl:variable name="footnote-marker">
            <xsl:number count="footnotes/footnote" from="/" level="any" format="1"/>
          </xsl:variable>
          <xsl:for-each select="*[1]">
            <p>
              <xsl:text>[</xsl:text>
              <a href="#{$footnote-idref}" name="{$footnote-id}">
                <xsl:value-of select="$footnote-marker"/>
              </a>
              <xsl:text>] </xsl:text>
              <xsl:apply-templates select="child::* | child::text()"/>
            </p>
          </xsl:for-each>
          <xsl:for-each select="*[position() != 1]">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:for-each>
      </section>
    </xsl:if>
  </xsl:template>
  <xsl:template name="navigation-bar">
    <xsl:variable name="table-of-contents">
      <xsl:choose>
        <xsl:when test="$language='es'">
          <xsl:text>&Iacute;ndice de Contenidos</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Table of Contents</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p id="page-navigation">
      <xsl:choose>
        <xsl:when test="meta/link[@class='prev']">
          <xsl:text>&lt; </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:apply-templates select="meta/link[@class='prev']/@idref"/>
              <xsl:text>.htm</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="id( meta/link[@class='prev']/@idref )/meta/title"/>
          </a>
          <xsl:text> &middot; </xsl:text>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="meta/link[@class='next']">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="meta/link[@class='next']/@idref"/>
              <xsl:text>.htm</xsl:text>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="meta/link[@class='next']/@idref = 'sect1'">
                <xsl:choose>
                  <xsl:when test="$language='es'">
                    <xsl:text>Secci&oacute;n 1</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Section 1</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="id( meta/link[@class='next']/@idref )/meta/title"/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
          <xsl:text> &gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>
  <xsl:template name="alpha-bar">
    <xsl:param name="alpha-bar-id-prefix"/>
    <p id="page-navigation">[<a href="{$alpha-bar-id-prefix}a.htm">A</a>&nbsp;<a href="{$alpha-bar-id-prefix}b.htm">B</a>&nbsp;<a href="{$alpha-bar-id-prefix}c.htm">C</a>&nbsp;<a href="{$alpha-bar-id-prefix}d.htm">D</a>&nbsp;<a href="{$alpha-bar-id-prefix}e.htm">E</a>&nbsp;<a href="{$alpha-bar-id-prefix}f.htm">F</a>&nbsp;<a href="{$alpha-bar-id-prefix}g.htm">G</a>&nbsp;<a href="{$alpha-bar-id-prefix}h.htm">H</a>&nbsp;<a href="{$alpha-bar-id-prefix}i.htm">I</a>&nbsp;<a href="{$alpha-bar-id-prefix}j.htm">J</a>&nbsp;<a href="{$alpha-bar-id-prefix}k.htm">K</a>&nbsp;<a href="{$alpha-bar-id-prefix}l.htm">L</a>&nbsp;<a href="{$alpha-bar-id-prefix}m.htm">M</a>&nbsp;<a href="{$alpha-bar-id-prefix}n.htm">N</a>&nbsp;<a href="{$alpha-bar-id-prefix}o.htm">O</a>&nbsp;<a href="{$alpha-bar-id-prefix}p.htm">P</a>&nbsp;<a href="{$alpha-bar-id-prefix}q.htm">Q</a>&nbsp;<a href="{$alpha-bar-id-prefix}r.htm">R</a>&nbsp;<a href="{$alpha-bar-id-prefix}s.htm">S</a>&nbsp;<a href="{$alpha-bar-id-prefix}t.htm">T</a>&nbsp;<a href="{$alpha-bar-id-prefix}u.htm">U</a>&nbsp;<a href="{$alpha-bar-id-prefix}v.htm">V</a>&nbsp;<a href="{$alpha-bar-id-prefix}w.htm">W</a>&nbsp;<a href="{$alpha-bar-id-prefix}x.htm">X</a>&nbsp;<a href="{$alpha-bar-id-prefix}y.htm">Y</a>&nbsp;<a href="{$alpha-bar-id-prefix}z.htm">Z</a>]</p>
  </xsl:template>
  <xsl:template name="illustration-framed">
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
    <xsl:param name="illustration-width"/>
    <xsl:param name="illustration-height"/>
    <xsl:param name="illustration-src"/>
    <xsl:param name="illustration-href"/>
    <figure>
      <xsl:choose>
        <xsl:when test="$illustration-href">
          <a href="{$illustration-href}"><img src="{$illustration-src}" class="img-responsive" alt="{$illustration-alt-text}"/></a>
        </xsl:when>
        <xsl:otherwise>
          <img src="{$illustration-src}" class="img-responsive" alt="{$illustration-alt-text}"/>
        </xsl:otherwise>
      </xsl:choose>
    </figure>
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
      <xsl:apply-templates select="ancestor::section[position()=1]/meta/title[1]"/>
    </xsl:variable>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="ancestor::section[position()=1]/@id"/>
        <xsl:text>.htm</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$section-title"/>
    </a>
  </xsl:template>
</xsl:stylesheet>
