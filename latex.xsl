<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
 <!ENTITY % latex.characters SYSTEM "ltexchar.mod">
 %latex.characters;
]>

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="ISO-8859-1" />

<xsl:strip-space elements="gamebook meta section data ol ul dl li dd footnotes footnote illustration instance" />
<xsl:preserve-space elements="p choice" />

<!--

$Log$
Revision 1.3  2006/04/04 22:02:14  cvsuser
Fix two bugs (one } too much and a missing line break)

Revision 1.2  2005/04/09 19:51:50  angantyr
Added handling of open-ended quotes.

Revision 1.1  2005/01/30 01:32:52  jonathan.blake
Initial freepository revision of XML support documents.

Revision 1.3  2002/10/30 06:33:22  jblake
Added capability to filter which illustrators' work is included in the output.

Revision 1.2  2002/10/20 06:29:58  jblake
Added support for CLOSE COMBAT SKILL from the Freeway Warrior books.

Revision 1.1  2002/10/15 23:30:23  jblake
Initial revision

-->

<!--

To Implement:

The implementation of tables is incomplete and kludgy.

-->

<!-- ====================== parameters ========================== -->

<xsl:param name="title-color"><xsl:text>0.0,0.0,0.0</xsl:text></xsl:param>
<xsl:param name="use-illustrators" />
<xsl:param name="language"><xsl:text>en</xsl:text></xsl:param>

<!-- ======================= variables ========================== -->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="newparagraph">
 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
</xsl:variable>

<!-- ======================== Templates ========================= -->

<!-- ================= hierarchical sections ==================== -->

<xsl:template match="meta" />

<!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

<xsl:template match="/gamebook/section[@id='title']">

<xsl:choose>
<xsl:when test="$language='es'">
    <xsl:text>
%% Two-sided %%
%\documentclass[letterpaper,12pt,twoside]{book}
% For european books:
\documentclass[a4paper,12pt,twoside]{book}
    </xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>
%% Two-sided %%
\documentclass[letterpaper,12pt,twoside]{book}
% For european books:
%\documentclass[a4paper,12pt,twoside]{book}
</xsl:text>
</xsl:otherwise>
</xsl:choose>

<xsl:text>
%% One-sided %%
%\documentclass[letterpaper,12pt,oneside]{book}
%\documentclass[a4paper,12pt,oneside]{book}

 \usepackage[pdftex]{graphicx}
 \usepackage{ifthen}
</xsl:text>
<xsl:choose>
<xsl:when test="$language='es'">
    <xsl:text>
% Use this if you are compiling spanish PDFs:
\usepackage[spanish]{babel}
    </xsl:text>
</xsl:when>
</xsl:choose>
<xsl:text>
 %% color info %%
 \usepackage{color}
 \definecolor{titlecolor}{rgb}{</xsl:text><xsl:value-of select="$title-color" /><xsl:text>}
 \definecolor{lightgray}{gray}{0.75}

 %% headers and footers %%
 \usepackage{fancyhdr}

 \renewcommand{\chaptermark}[1]{}
 \renewcommand{\sectionmark}[1]{}
 \fancyhf{}

 \ifthenelse{\boolean{@twoside}}%
 {%% Two-sided %%
  \fancyhead[CO]{\iffloatpage{}{</xsl:text><xsl:value-of select="/gamebook/meta/creator[@class='short']" /><xsl:text>}}
  \fancyhead[CE]{\iffloatpage{}{\bfseries </xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>}}
  \fancyhead[LO,RE]{\iffloatpage{}{\thepage}}}
 {%% One-sided %%
  \fancyhead[C]{\iffloatpage{}{\bfseries{</xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>:} \normalfont{</xsl:text><xsl:value-of select="/gamebook/meta/creator[@class='short']" /><xsl:text>}}}
  \fancyhead[R]{\iffloatpage{}{\thepage}}}
  \renewcommand{\headrulewidth}{\iffloatpage{0pt}{0.4pt}}}

 \fancypagestyle{plain}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
 }

 \fancypagestyle{empty}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
 }

 %% hyper-references %%
 \usepackage[pdftex,colorlinks=true,linkcolor=black,bookmarks=false]{hyperref}

 %% custom style info %%
 \setlength{\parindent}{0pt}
 \setlength{\parskip}{1em}
 \setlength{\headheight}{18pt}
 \addtolength{\headwidth}{\marginparwidth}
 \addtolength{\headwidth}{\marginparsep}
 \setlength{\textheight}{44\baselineskip}
 \ifthenelse{\lengthtest{\paperwidth = 210mm}}%
   {%% if A4 (210.0 mm x 297.0 mm)
   \addtolength{\topmargin}{-1\baselineskip}}%
   {%% else if letter (8.5" x 11" == 215.9 mm x 279.4 mm)
   \addtolength{\topmargin}{-2.5\baselineskip}}

 %% TrueType font %%
 \usepackage[T1]{fontenc}
 % NOTE: This font might not ve available. Uncomment if you have it configured
 % for your LaTeX fonts:
 %\usepackage{souvenir}
 %\renewcommand{\rmdefault}{souvnrttf}

 \raggedbottom

 %% new environments %%
 \newenvironment{aonchoice}{\begin{list}{}{\setlength{\topsep}{0pt}} \item}{\end{list}}
 \newenvironment{aoncombat}{\begin{list}{}{\setlength{\topsep}{0pt}} \item}{\end{list}}
 \newenvironment{aonitemize}{\begin{list}{}{\setlength{\topsep}{0pt} \setlength{\parsep}{0pt} \setlength{\itemsep}{0pt}}}{\end{list}}
 \newenvironment{aonordereditemize}{\begin{list}{\arabic{aoncounter}.}{\usecounter{aoncounter} \setlength{\topsep}{0pt} \setlength{\parsep}{0pt} \setlength{\itemsep}{0pt}}}{\end{list}}
 \newcounter{aoncounter}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\begin{titlepage}

 \vspace*{\stretch{0.7}}
 \begin{center}
  \Huge{\textcolor{titlecolor}{\textbf{</xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>}}} \vspace{-0.8em}\\

  \vspace*{\stretch{1}}
  \normalsize{</xsl:text><xsl:apply-templates select="/gamebook/meta/creator[@class='medium']" /><xsl:text>}
 \end{center}
 \vspace*{\stretch{1.3}}

 \pagestyle{empty}

 \newpage

 \vspace*{\stretch{1}}

 </xsl:text>
 <xsl:apply-templates select="/gamebook/meta/rights[@class='license-notification']" />

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
 <xsl:text>

 </xsl:text>
 <xsl:apply-templates select="/gamebook/meta/description[@class='publication']" />
 <xsl:text>

 \vspace*{\stretch{3}}

 \pagestyle{empty}

\end{titlepage}

\clearpage{\pagestyle{empty}\cleardoublepage}

 \vspace*{\stretch{1}}

 \thispagestyle{empty}
 </xsl:text>
 <xsl:apply-templates select="/gamebook/meta/description[@class='blurb']" />
 <xsl:apply-templates select="/gamebook/meta/creator[@class='long']" />
 <xsl:text>

 \vspace*{\stretch{3}}

\clearpage{\pagestyle{empty}\cleardoublepage}

 \pagestyle{fancy}

\begin{frontmatter}
</xsl:text>

 <xsl:apply-templates select="data/section[@class='frontmatter']" />

<xsl:text>
\end{frontmatter}

</xsl:text>
<xsl:if test="data/section[@class='mainmatter']">
 <xsl:text>\begin{mainmatter}

 </xsl:text>

 <xsl:apply-templates select="data/section[@class='mainmatter']" />

 <xsl:text>
 \end{mainmatter}
 </xsl:text>
</xsl:if>

<xsl:if test="data/section[@class='numbered']">
 <xsl:apply-templates select="data/section[@class='numbered']" />
</xsl:if>

 <xsl:text>
\begin{backmatter}
\ifthenelse{\boolean{@twoside}}%
 {%% Two-sided %%
  \fancyhead[RO,LE]{}}
 {%% One-sided %%
  \fancyhead[R]{}}

 \setcounter{topnumber}{6}
 \renewcommand{\topfraction}{1}
 \renewcommand{\textfraction}{0}
 \setlength{\floatsep}{10pt}

 </xsl:text>
 <xsl:apply-templates select="data/section[@class='backmatter']" />
 <xsl:text>

\end{backmatter}

\end{document}
</xsl:text>

</xsl:template>

<xsl:template match="/gamebook/section[@id='toc']" />

<xsl:template match="section" />

<!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='frontmatter']">

 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:text>{\huge \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{section}{\protect\numberline{}{</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>

<!-- :::::::::::: third-level front matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter']">

 <xsl:text>{\LARGE \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate']">

 <xsl:text>\newpage</xsl:text><xsl:value-of select="$newline" />
 <xsl:text>{\LARGE \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{subsection}{\protect\numberline{}{</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: fourth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">
 <xsl:text>{\Large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
 <xsl:text>{\large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::: second-level main matter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='mainmatter']">
 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:text>{\huge \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{section}{\protect\numberline{}{</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>

<!-- :::::::::::: third-level main matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='mainmatter'] | /gamebook/section/data/section/data/section[@class='mainmatter-separate']">

 <xsl:text>\newpage</xsl:text><xsl:value-of select="$newline" />
 <xsl:text>{\LARGE \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{subsection}{\protect\numberline{}{</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: fourth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter'] | /gamebook/section/data/section/data/section/data/section[@class='mainmatter-separate']">
 <xsl:text>{\Large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
 <xsl:text>{\large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: third-level glossary sections ::::::::::::: -->
<!-- Glossary sections should be contained in a second level section. -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='glossary'] | /gamebook/section/data/section/data/section[@class='glossary-separate']">

 <xsl:text>\newpage</xsl:text><xsl:value-of select="$newline" />
 <xsl:text>{\LARGE \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text> <xsl:value-of select="$newparagraph" />

 <xsl:if test="position() = 1">
  <xsl:text>\newcommand{\aonmarks}{
    \ifthenelse{\equal{\leftmark}{\rightmark}}
      {\rightmark}
      {\rightmark{} - \leftmark}
  \ifthenelse{\boolean{@twoside}}%
   {%% Two-sided %%
    \fancyhead[RO,LE]{\iffloatpage{}{\large{\bfseries \aonmarks}}}
    \fancyhead[LO,RE]{\iffloatpage{}{\thepage}}}
   {%% One-sided %%
    \fancyhead[R]{\iffloatpage{}{\large{\bfseries \aonmarks}}}
    \fancyhead[L]{\iffloatpage{}{\thepage}}%
    }</xsl:text> <xsl:value-of select="$newparagraph" />
 </xsl:if>

 <xsl:if test="not( self::node()[@id='numbered'] )">
  <xsl:text>{\huge \hypertarget{</xsl:text>
   <xsl:value-of select="@id" />
  <xsl:text>}{</xsl:text>
  <xsl:value-of select="meta/title" />
  <xsl:text>}}</xsl:text>
  <xsl:value-of select="$newline" />
 </xsl:if>
 <xsl:text>\addcontentsline{toc}{section}{\protect\numberline{}{</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

 <xsl:value-of select="$newparagraph" />
 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text>
</xsl:template>

<xsl:template match="/gamebook/section/data/section[@class='numbered']/data/section[@class='numbered']">
 <xsl:variable name="section-title" select="meta/title[1]" />

<xsl:value-of select="$newline" />
<xsl:text>\vspace{\parskip} \hypertarget{</xsl:text>
<xsl:value-of select="@id" />
<xsl:text>}{} \hspace*{\fill} \markboth{</xsl:text>
<xsl:value-of select="$section-title" />
<xsl:text>}{</xsl:text>
<xsl:value-of select="$section-title" />
<xsl:text>} {\Large \bfseries </xsl:text>
<xsl:value-of select="$section-title" />
<xsl:text>} \hspace*{\fill}\\*[\parskip]</xsl:text>
<xsl:value-of select="$newline" />

<xsl:for-each select="data/illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]">
 <xsl:text>\hspace*{\fill} \mbox{\itshape \hyperlink{ill</xsl:text>
 <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" />
       <xsl:choose>
        <xsl:when test="$language='es'">
 <xsl:text>}{Ilustraci&oacute;n </xsl:text>
        </xsl:when>
        <xsl:otherwise>
 <xsl:text>}{Illustration </xsl:text>
        </xsl:otherwise>
       </xsl:choose>
 <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
 <xsl:text>}}\hspace*{\fill}\\*[\parskip]</xsl:text>
</xsl:for-each>

 <xsl:apply-templates />

</xsl:template>

<!-- :::::::::::: second-level backmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='backmatter']">

 <xsl:text>\clearpage{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:text>{\huge \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{section}{\protect\numberline{}{</xsl:text>
  <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: third-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">
 <xsl:text>{\LARGE \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">
 <xsl:text>{\Large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:value-of select="meta/title" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::::::::: dedication template ::::::::::::::::::::: -->

<xsl:template match="id( 'dedicate' )">
 
 <xsl:text>\vspace*{\stretch{1}}</xsl:text>
 <xsl:value-of select="$newparagraph" />
 <xsl:text>\begin{center}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\thispagestyle{empty}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\itshape </xsl:text>
 <xsl:apply-templates select="data/p" />
 <xsl:value-of select="$newline" />
 <xsl:text>\end{center}</xsl:text>
 <xsl:value-of select="$newparagraph" />
 <xsl:text>\vspace*{\stretch{3}}</xsl:text>
 <xsl:value-of select="$newline" />

 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\tableofcontents</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text>
 <xsl:value-of select="$newline" />

 <xsl:text>\setcounter{page}{1}</xsl:text><xsl:value-of select="$newline" />
 <xsl:text>\pagenumbering{arabic}</xsl:text><xsl:value-of select="$newline" />

</xsl:template>

<!-- ::::::::::::::::::::: map template ::::::::::::::::::::::::: -->

<xsl:template match="id( 'map' )">
 <xsl:variable name="map-title" select="meta/title" />

 <xsl:text>\clearpage{\pagestyle{empty}\cleardoublepage}</xsl:text>
 <xsl:value-of select="$newparagraph" />

  <xsl:for-each select="data/illustration[contains( $use-illustrators, concat( ':', meta/creator, ':' ) ) ]">
   <xsl:variable name="illustration-src" select="instance[@class='pdf']/@src" />

   <xsl:text>\hypertarget{map}{map}</xsl:text>
   <xsl:value-of select="$newline" />
   <xsl:text>\addcontentsline{toc}{section}{\protect\numberline{}{</xsl:text>
    <xsl:value-of select="$map-title" />
   <xsl:text>}}</xsl:text>
   <xsl:value-of select="$newparagraph" />

<!--   <xsl:value-of select="$newline" />
   <xsl:text>\begin{figure}[!h]</xsl:text>
   <xsl:value-of select="$newline" />
    <xsl:text>\centering</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\thispagestyle{empty}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\rotatebox{90}{\includegraphics[width=550pt,keepaspectratio]{</xsl:text><xsl:value-of select="$illustration-src" /><xsl:text>}}%</xsl:text>
    <xsl:value-of select="$newline" />
   <xsl:text>\end{figure}</xsl:text> -->

   <xsl:text>\thispagestyle{empty}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>\newlength{\saveunitlength}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>\setlength{\saveunitlength}{\unitlength}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>\setlength{\unitlength}{1mm}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>\ifthenelse{\boolean{@twoside}}%</xsl:text><xsl:value-of select="$newline" />
   <xsl:text> {%% Two-sided %%</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>  \begin{picture}(10,10)</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>  \put(-23,-188){\includegraphics[angle=90,origin=c,width=20cm,height=28cm,keepaspectratio]{map.pdf}}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>  \end{picture}}%</xsl:text><xsl:value-of select="$newline" />
   <xsl:text> {%% One-sided %%</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>  \begin{picture}(10,10)</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>  \put(-29,-188){\includegraphics[angle=90,origin=c,width=20cm,height=28cm,keepaspectratio]{map.pdf}}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>  \end{picture}}</xsl:text><xsl:value-of select="$newline" />
   <xsl:text>\setlength{\unitlength}{\saveunitlength}</xsl:text><xsl:value-of select="$newline" />

  </xsl:for-each>
</xsl:template>

<!-- ==================== block elements ======================== -->

<xsl:template match="p">
 <xsl:apply-templates />
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="ul">
 <xsl:text>\begin{aonitemize}</xsl:text><xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:text>\end{aonitemize}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="ul[@class='unbulleted']">
 <xsl:text>\begin{aonitemize}</xsl:text><xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:text>\end{aonitemize}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="ol">
 <xsl:text>\begin{enumerate}</xsl:text><xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:text>\end{enumerate}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="dl">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="table">
 <xsl:text>\begin{tabular}{*{</xsl:text>
 <xsl:for-each select="tr[1]">
  <xsl:for-each select="th[1]">
   <xsl:number count="th" />
  </xsl:for-each>
 </xsl:for-each>
 <xsl:text>}{l}}</xsl:text>
 <xsl:value-of select="$newline" />
  <xsl:apply-templates />
 <xsl:text>\end{tabular}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="tr">
 <xsl:apply-templates />
 <xsl:text> \\</xsl:text>
</xsl:template>

<xsl:template match="th">
 <xsl:text>\multicolumn{1}{</xsl:text>
 <xsl:choose>
  <xsl:when test="@align='left'"><xsl:text>l}{\bfseries </xsl:text></xsl:when>
  <xsl:when test="@align='right'"><xsl:text>r}{\bfseries </xsl:text></xsl:when>
  <xsl:when test="@align='center'"><xsl:text>c}{\bfseries </xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>l}{\bfseries </xsl:text></xsl:otherwise>
 </xsl:choose>
  <xsl:apply-templates />
 <xsl:text>} </xsl:text>
 <xsl:if test="position != last()"><xsl:text>&amp;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="td">
 <xsl:text>\multicolumn{1}{</xsl:text>
 <xsl:choose>
  <xsl:when test="@align='left'"><xsl:text>l}{</xsl:text></xsl:when>
  <xsl:when test="@align='right'"><xsl:text>r}{</xsl:text></xsl:when>
  <xsl:when test="@align='center'"><xsl:text>c}{</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>l}{</xsl:text></xsl:otherwise>
 </xsl:choose>
  <xsl:apply-templates />
 <xsl:text>} </xsl:text>
 <xsl:if test="position != last()"><xsl:text>&amp;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="combat">
 <xsl:text>\begin{aoncombat}</xsl:text>
  <xsl:apply-templates select="enemy" />
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='combatskill']">
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text>: {\small DESTREZA~EN~EL~COMBATE}~</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>: {\small COMBAT~SKILL}~</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
    <xsl:value-of select="enemy-attribute[@class='combatskill']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='closecombatskill']">
     <xsl:choose>
      <xsl:when test="$language='es'">
       <xsl:text>: {\small DESTREZA~EN~EL~COMBATE~DE~PROXIMIDAD}~</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>: {\small CLOSE~COMBAT~SKILL}~</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
    <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
   </xsl:when>
  </xsl:choose>
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text> ~~{\small RESISTENCIA}~</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text> ~~{\small ENDURANCE}~</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='target']">
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text>~(puntos~de~{\small OBJETIVO})~</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>~({\small TARGET}~points)~</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
    <xsl:value-of select="enemy-attribute[@class='target']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='resistance']">
    <xsl:choose>
     <xsl:when test="$language='es'">
      <xsl:text>~(puntos~de~{\small RESISTENCIA})~</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>~({\small RESISTANCE}~points)~</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
    <xsl:value-of select="enemy-attribute[@class='resistance']" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="enemy-attribute[@class='endurance']" />
   </xsl:otherwise>
  </xsl:choose>
 <xsl:text>\end{aoncombat}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="choice">
 <xsl:variable name="link">
  <xsl:value-of select="@idref" />
 </xsl:variable>

 <xsl:text>\begin{aonchoice}</xsl:text>
  <xsl:for-each select="* | text()">
   <xsl:choose>
    <xsl:when test="self::link-text">
     <xsl:text>\hyperlink{</xsl:text>
     <xsl:value-of select="$link" />
     <xsl:text>}{\bfseries </xsl:text>
      <xsl:apply-templates />
     <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:apply-templates select="." />
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
 <xsl:text>\end{aonchoice}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="signpost">
 <xsl:text>\begin{center}</xsl:text><xsl:apply-templates /><xsl:text>\end{center}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="blockquote">
 <xsl:text>\begin{quote}</xsl:text><xsl:apply-templates /><xsl:text>\end{quote}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="illustration">
 <xsl:choose>
  <xsl:when test="instance[@class='pdf'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:text>\begin{figure}[</xsl:text>
   <xsl:choose>
    <xsl:when test="@class='inline'">!ht</xsl:when>
    <xsl:when test="@class='float'">p</xsl:when>
    <xsl:when test="@class='accent'">bt</xsl:when>
    <xsl:otherwise><xsl:text>invalid class</xsl:text></xsl:otherwise>
   </xsl:choose>
   <xsl:text>]</xsl:text>
   <xsl:value-of select="$newline" />
   <xsl:text>\centering</xsl:text>
   <xsl:value-of select="$newline" />
   <xsl:text>\includegraphics</xsl:text>
   <xsl:if test="@class='float'">
    <!--<xsl:text>[width=\textwidth,keepaspectratio]</xsl:text>-->
    <xsl:text>[width=\textwidth,height=570pt,keepaspectratio]</xsl:text>
   </xsl:if>
   <xsl:text>{</xsl:text>
    <xsl:value-of select="instance[@class='pdf']/@src" />
   <xsl:text>} %</xsl:text>
   <xsl:if test="@class='float'">
    <xsl:value-of select="$newline" />
    <xsl:text>\vspace*{\fill}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\\ \mbox{ \hypertarget{ill</xsl:text>
     <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" />
       <xsl:choose>
        <xsl:when test="$language='es'">
            <xsl:text>}{Ilustraci&oacute;n </xsl:text>
        </xsl:when>
        <xsl:otherwise>
	    <xsl:text>}{Illustration </xsl:text>
        </xsl:otherwise>
       </xsl:choose>
     <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
    <xsl:text>}}\\[1em]{\itshape </xsl:text>
    <xsl:apply-templates select="meta/description" />
    <xsl:text>}</xsl:text>
   </xsl:if>
   <xsl:value-of select="$newline" />
   <xsl:text>\end{figure}</xsl:text>
   <xsl:value-of select="$newline" />
  </xsl:when>

  <xsl:when test="instance[@class='tex'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
   <xsl:value-of select="$newline" />
   <xsl:text>\begin{figure}[!h]</xsl:text>
   <xsl:value-of select="$newline" />
    <xsl:text>\centering</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\input{</xsl:text><xsl:value-of select="instance[@class='tex']/@src" /><xsl:text>}</xsl:text>
    <xsl:value-of select="$newline" />
   <xsl:text>\end{figure}</xsl:text>
   <xsl:value-of select="$newline" />

   <xsl:text>\clearpage{}</xsl:text>   
   <xsl:value-of select="$newparagraph" />
  </xsl:when>

  <xsl:otherwise />

 </xsl:choose>
</xsl:template>

<xsl:template match="instance" />

<xsl:template match="footnotes" />

<xsl:template match="footnote">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="hr">
 <xsl:text>\rule{\textwidth}{0.4pt}</xsl:text>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dt">
 <xsl:text>{\bfseries </xsl:text><xsl:apply-templates /><xsl:text>}\\*\\*</xsl:text>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="dd">
 <xsl:apply-templates />
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="li">
 <xsl:text>\item </xsl:text><xsl:apply-templates />
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ==================== inline elements ======================= -->

<xsl:template match="a">
 <xsl:if test="@idref">
  <xsl:text>\hyperlink{</xsl:text>
  <xsl:value-of select="@idref" />
  <xsl:text>}{</xsl:text>
 </xsl:if>
 <xsl:if test="@id">
  <xsl:text>\hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
  <xsl:text>}{</xsl:text>
 </xsl:if>

 <xsl:apply-templates />

 <xsl:if test="@idref">
  <xsl:text>}</xsl:text>
 </xsl:if>
 <xsl:if test="@id">
  <xsl:text>}</xsl:text>
 </xsl:if>
</xsl:template>

<xsl:template match="a[@class='footnote']">
 <xsl:apply-templates />
 <xsl:text>\footnote{</xsl:text>
 <xsl:for-each select="id( @idref )">
  <xsl:apply-templates />
 </xsl:for-each>
 <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="em">
 <xsl:text>\emph{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="strong">
 <xsl:text>{\bfseries </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="cite">
 <xsl:text>{\itshape </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="thought">
 <xsl:text>{\itshape </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="onomatopoeia">
 <xsl:text>{\itshape </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="spell">
 <xsl:text>{\itshape </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="item">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="foreign">
 <xsl:text>{\itshape </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
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
 <xsl:text>{\ttfamily </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="br">
 <xsl:text>\\</xsl:text>
</xsl:template>

<xsl:template match="typ[@class='attribute']">
 <xsl:text>{\small </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="footnote//typ[@class='attribute']">
 <xsl:text>{\scriptsize </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
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

<!-- JFS: TODO - probably the \definitions need to be in {} to prevent 
     issues if followed by text -->

<xsl:template match="ch.apos"><xsl:text>&#39;</xsl:text></xsl:template><!-- apostrophe = single quotation mark -->
<xsl:template match="ch.nbsp"><xsl:text>~</xsl:text></xsl:template><!-- no-break space = non-breaking space, U+00A0 ISOnum -->
<xsl:template match="ch.iexcl"><xsl:text>{\textexclamdown}</xsl:text></xsl:template><!-- inverted exclamation mark, U+00A1 ISOnum -->
<xsl:template match="ch.cent"><xsl:text>\textcent</xsl:text></xsl:template><!-- cent sign, U+00A2 ISOnum -->
<xsl:template match="ch.pound"><xsl:text>\pounds</xsl:text></xsl:template><!-- pound sign, U+00A3 ISOnum -->
<xsl:template match="ch.curren"><xsl:text>\textcurrency</xsl:text></xsl:template><!-- currency sign, U+00A4 ISOnum -->
<xsl:template match="ch.yen"><xsl:text>\textyen</xsl:text></xsl:template><!-- yen sign = yuan sign, U+00A5 ISOnum -->
<xsl:template match="ch.brvbar"><xsl:text>\textbar</xsl:text></xsl:template><!-- broken bar = broken vertical bar, U+00A6 ISOnum -->
<xsl:template match="ch.sect"><xsl:text>\textsection</xsl:text></xsl:template><!-- section sign, U+00A7 ISOnum -->
<xsl:template match="ch.uml"><xsl:text>\ddot{}</xsl:text></xsl:template><!-- diaeresis = spacing diaeresis, U+00A8 ISOdia -->
<xsl:template match="ch.copy"><xsl:text>\copyright</xsl:text></xsl:template><!-- copyright sign, U+00A9 ISOnum -->
<xsl:template match="ch.ordf"><xsl:text>\textordfeminine</xsl:text></xsl:template><!-- feminine ordinal indicator, U+00AA ISOnum -->
<xsl:template match="ch.laquo"><xsl:text>{\guillemotleft}</xsl:text></xsl:template><!-- left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum -->
<xsl:template match="ch.not"><xsl:text>\textlnot</xsl:text></xsl:template><!-- not sign, U+00AC ISOnum -->
<xsl:template match="ch.shy"><xsl:text>\-</xsl:text></xsl:template><!-- soft hyphen = discretionary hyphen, U+00AD ISOnum -->
<xsl:template match="ch.reg"><xsl:text>{\texttrademark}</xsl:text></xsl:template><!-- registered sign = registered trade mark sign, U+00AE ISOnum -->
<xsl:template match="ch.macr"><xsl:text>\textasciimacron</xsl:text></xsl:template><!-- macron = spacing macron = overline = APL overbar, U+00AF ISOdia -->
<xsl:template match="ch.deg"><xsl:text>\textdegree</xsl:text></xsl:template><!-- degree sign, U+00B0 ISOnum -->
<xsl:template match="ch.plusmn"><xsl:text>\textpm</xsl:text></xsl:template><!-- plus-minus sign = plus-or-minus sign, U+00B1 ISOnum -->
<xsl:template match="ch.sup2"><xsl:text>^2</xsl:text></xsl:template><!-- superscript two = superscript digit two = squared, U+00B2 ISOnum -->
<xsl:template match="ch.sup3"><xsl:text>^3</xsl:text></xsl:template><!-- superscript three = superscript digit three = cubed, U+00B3 ISOnum -->
<xsl:template match="ch.acute"><xsl:text>\'</xsl:text></xsl:template><!-- acute accent = spacing acute, U+00B4 ISOdia -->
<xsl:template match="ch.micro"><xsl:text>\textmu</xsl:text></xsl:template><!-- micro sign, U+00B5 ISOnum -->
<xsl:template match="ch.para"><xsl:text>\textparagraph</xsl:text></xsl:template><!-- pilcrow sign  = paragraph sign, U+00B6 ISOnum -->
<xsl:template match="ch.middot"><xsl:text>\textperiodcentered</xsl:text></xsl:template><!-- middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum -->
<xsl:template match="ch.cedil"><xsl:text>\c{c}</xsl:text></xsl:template><!-- cedilla = spacing cedilla, U+00B8 ISOdia -->
<xsl:template match="ch.sup1"><xsl:text>^1</xsl:text></xsl:template><!-- superscript one = superscript digit one, U+00B9 ISOnum -->
<xsl:template match="ch.ordm"><xsl:text>\textordmasculine</xsl:text></xsl:template><!-- masculine ordinal indicator, U+00BA ISOnum -->
<xsl:template match="ch.raquo"><xsl:text>{\guillemotright}</xsl:text></xsl:template><!-- right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum -->
<xsl:template match="ch.frac14"><xsl:text>\frac{1}{4}</xsl:text></xsl:template><!-- vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum -->
<xsl:template match="ch.frac12"><xsl:text>\frac{1}{2}</xsl:text></xsl:template><!-- vulgar fraction one half = fraction one half, U+00BD ISOnum -->
<xsl:template match="ch.frac34"><xsl:text>\frac{3}{4}</xsl:text></xsl:template><!-- vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum -->
<xsl:template match="ch.iquest"><xsl:text>{\textquestiondown}</xsl:text></xsl:template><!-- inverted question mark = turned question mark, U+00BF ISOnum -->
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

<xsl:template match="ch.ampersand">\&amp;</xsl:template><!-- ampersand -->
<xsl:template match="ch.lsquot">\textquoteleft</xsl:template><!-- opening left quotation mark -->
<xsl:template match="ch.rsquot">\textquoteright</xsl:template><!-- closing right quotation mark -->
<xsl:template match="ch.ldquot">``</xsl:template><!-- opening left double quotation mark -->
<xsl:template match="ch.rdquot">''</xsl:template><!-- closing right double quotation mark -->
<xsl:template match="ch.minus">\-</xsl:template><!-- mathematical minus -->
<xsl:template match="ch.emdash">\-</xsl:template><!-- emdash -->
<xsl:template match="ch.ellips">&nbsp;\ldots </xsl:template><!-- ellipsis -->
<xsl:template match="ch.lellips">\ldots&nbsp; </xsl:template><!-- left ellipsis, used at the beginning of edited material -->
<xsl:template match="ch.blankline">\_\_\_\_\_\_\_</xsl:template><!-- blank line to be filled in -->
<xsl:template match="ch.percent"><xsl:text>\%</xsl:text></xsl:template><!-- percent sign -->
<xsl:template match="ch.thinspace"><xsl:text>\ </xsl:text></xsl:template><!-- small horizontal space for use between adjacent quotation marks - added mainly for LaTeX's sake -->
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
