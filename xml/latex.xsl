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

$Id$

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

<xsl:text>
%% Two-sided %%
\documentclass[letterpaper,12pt,twoside]{book}
%\documentclass[a4paper,12pt,twoside]{book}

%% One-sided %%
%\documentclass[letterpaper,12pt,oneside]{book}
%\documentclass[a4paper,12pt,oneside]{book}

 \usepackage[pdftex]{graphicx}
 \usepackage{ifthen}

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
  \fancyhead[LO,RE]{\iffloatpage{}{\thepage}}}%
 {%% One-sided %%
  %\fancyhead[C]{\iffloatpage{}{\bfseries{</xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>:} \normalfont{</xsl:text><xsl:value-of select="/gamebook/meta/creator[@class='short']" /><xsl:text>}}}
  %\fancyhead[R]{\iffloatpage{}{\thepage}}}
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
 \usepackage{souvenir}
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
 <xsl:text>

 Publication Date: </xsl:text>
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
      {\rightmark{} - \leftmark}}
  \ifthenelse{\boolean{@twoside}}%
   {%% Two-sided %%
    \fancyhead[RO,LE]{\iffloatpage{}{\large{\bfseries \aonmarks}}}
    \fancyhead[LO,RE]{\iffloatpage{}{\thepage}}}
   {%% One-sided %%
    %\fancyhead[R]{\iffloatpage{}{\large{\bfseries \aonmarks}}}
    %\fancyhead[L]{\iffloatpage{}{\thepage}}%
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
 <xsl:text>}{Illustration </xsl:text>
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

   <xsl:text>\hypertarget{map}{~}</xsl:text>
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
    <xsl:text>: {\small COMBAT~SKILL}~</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='combatskill']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='closecombatskill']">
    <xsl:text>: {\small CLOSE~COMBAT~SKILL}~</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
   </xsl:when>
  </xsl:choose>
  <xsl:text> ~~{\small ENDURANCE}~</xsl:text>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='target']">
    <xsl:text>~({\small TARGET}~points)~</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='target']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='resistance']">
    <xsl:text>~({\small RESISTANCE}~points)~</xsl:text>
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
    <xsl:text>}{Illustration </xsl:text>
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

</xsl:transform>
