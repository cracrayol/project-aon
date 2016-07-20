<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
 <!ENTITY % latex.characters SYSTEM "ltexchar.mod">
 %latex.characters;
]>

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  xmlns:date="http://exslt.org/dates-and-times" >

<xsl:import href="../../common/xsl/org.projectaon.format-date-localized.template.xsl" />

<xsl:output method="text" encoding="ISO-8859-1" />

<xsl:strip-space elements="gamebook meta rights section data ol ul dl li dd footnotes footnote illustration instance table tr th td blockquote poetry" />
<xsl:preserve-space elements="p choice description" />

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
<xsl:param name="papersize"><xsl:text>a5paper</xsl:text></xsl:param>
<xsl:param name="pagelayout"><xsl:text>twoside</xsl:text></xsl:param>
<xsl:param name="usesouvenirfont"><xsl:text>yes</xsl:text></xsl:param>
<xsl:param name="usexelatex"><xsl:text>yes</xsl:text></xsl:param>

<!--
  The size of the original paperback books is about 178 mm x 110 mm,
  the scans of the covers are 690 x 425, i.e. the aspect ratio is about
  1:1.6235.
  Scaling the page size to A5 (210 mm x 148.5 mm) on gets about
  210 mm x 129.35 mm -> the binding correction should be set to 19.15 mm.
  Scaling the page size to letter/2 (215.9 mm x 139.7 mm) on gets about
  215.9 mm x 133 mm -> the binding correction should be set to 6.7 mm.
-->

<!-- ======================= includes =========================== -->


<!-- ================= internationalization ===================== -->

<xsl:variable name="i18n" select="document( '../../common/l10n/i18n-pdf.xml' )/messages/message[@lang=$language]"/>

<!-- ======================= variables ========================== -->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="newparagraph">
 <xsl:value-of select="$newline" />
 <xsl:value-of select="$newline" />
</xsl:variable>

  <xsl:variable name="resultBoxWidth">15</xsl:variable><!-- 45pt -->
  <xsl:variable name="resultBoxHeight">15</xsl:variable><!-- 40pt -->
  <xsl:variable name="rnColWidth">6</xsl:variable><!-- 20pt -->
  <xsl:variable name="combatRatioBoxHeight">9</xsl:variable><!-- 30pt -->
  <xsl:variable name="legendHeight">4.5</xsl:variable><!-- 15pt -->
  <xsl:variable name="legendSep">3</xsl:variable><!-- 10pt -->
  <xsl:variable name="topLabelSep">3</xsl:variable><!-- 10pt -->
  <xsl:variable name="topLabelHeight">6</xsl:variable><!-- 20pt -->
  <xsl:variable name="sideLabelWidth">6</xsl:variable><!-- 20pt -->

  <!-- calculate a few positions -->
  <xsl:variable name="randomNumberBoxWidth" select="$rnColWidth" />
  <xsl:variable name="randomNumberBoxHeight" select="$resultBoxHeight" />

  <xsl:variable name="combatRatioBoxWidth" select="$resultBoxWidth" />

  <!-- Random Number Table -->
  <xsl:variable name="RNTWidthOfBox">12</xsl:variable>
  <xsl:variable name="RNTHeightOfBox">15.5</xsl:variable>
  <!-- offsetX = \textwidth / 2 - 5 * widthOfBox = 116.2 / 2 - 60 = - 1.9 -->
  <xsl:variable name="RNTOffsetX">-1.9</xsl:variable>
  <xsl:variable name="RNTOffsetY">0</xsl:variable>

<!-- ======================== Templates ========================= -->

<!-- ================= hierarchical sections ==================== -->

<xsl:template match="meta" />

<!-- ::::::::::::::::::: top-level section :::::::::::::::::::::: -->

<xsl:template match="/gamebook/section[@id='title']">

<xsl:text>\documentclass[</xsl:text><xsl:value-of select="$papersize" /><xsl:text>,12pt,</xsl:text><xsl:value-of select="$pagelayout" /><xsl:text>,BCOR10mm,DIVcalc,headinclude,cleardoubleempty]{scrbook}
</xsl:text>

<xsl:choose>
    <xsl:when test="$usexelatex='yes'">
<xsl:text>
% xltxtra loads fontspec
\usepackage{xltxtra}
</xsl:text>
  </xsl:when>
   <xsl:otherwise>
<xsl:text>
%% TrueType font %%
\usepackage[T1]{fontenc}
</xsl:text>
   </xsl:otherwise>
 </xsl:choose>

<xsl:choose>
<xsl:when test="$usesouvenirfont='yes'">
  <xsl:choose>
    <xsl:when test="$usexelatex='yes'">
     <xsl:text>\setmainfont[Ligatures=TeX]{ITC Souvenir Std Light}</xsl:text>
     <xsl:value-of select="$newline" />
  </xsl:when>
   <xsl:otherwise>
     <xsl:text>\usepackage{souvenir}</xsl:text>
     <xsl:value-of select="$newline" />
   </xsl:otherwise>
 </xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:text>

\typearea[current]{calc}

% list only chapters in the ToC
\setcounter{tocdepth}{1}
</xsl:text>

  <xsl:choose>
    <xsl:when test="$usexelatex='yes'">
     <xsl:text>% Graphicx package is loaded by xltxtra</xsl:text>
     <xsl:value-of select="$newline" />
  </xsl:when>
   <xsl:otherwise>
     <xsl:text>\usepackage[pdftex]{graphicx}</xsl:text>
     <xsl:value-of select="$newline" />
   </xsl:otherwise>
 </xsl:choose>

<xsl:text>
% The eso-pic package helps put objects on the background of pages, without
% respecting margins. This is what we use for the bearer scroll
\usepackage{eso-pic}

\usepackage{array}
% needed for using \centering in tabular environment
\newcommand{\PreserveBackslash}[1]{\let\temp=\\#1\let\\=\temp}

\usepackage{ifthen}
\usepackage{calc}


</xsl:text>

<!-- Review in ../l10n/i18n-pdf.xml but for the meantime define like this -->
  <xsl:choose>
    <xsl:when test="$usexelatex='yes'">
     <xsl:text>
% Polyglossia replaces Babel:
\usepackage{polyglossia}
\setdefaultlanguage{spanish}
     </xsl:text>
  </xsl:when>
   <xsl:otherwise>
     <xsl:value-of select="$i18n[@src='include babel package']"/>
   </xsl:otherwise>
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
{ %% Two-sided %%
  \fancyhead[CO]{\iffloatpage{}{</xsl:text><xsl:value-of select="/gamebook/meta/creator[@class='short']" /><xsl:text>}}
  \fancyhead[CE]{\iffloatpage{}{\bfseries </xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>}}
  \fancyhead[LO,RE]{\iffloatpage{}{\thepage}}%
}
{ %% One-sided %%
  \fancyhead[C]{\iffloatpage{}{\bfseries{</xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>:} \normalfont{</xsl:text><xsl:value-of select="/gamebook/meta/creator[@class='short']" /><xsl:text>}}}
  \fancyhead[R]{\iffloatpage{}{\thepage}}}
  \renewcommand{\headrulewidth}{\iffloatpage{0pt}{0.4pt}%
}

\fancypagestyle{plain}{
 \fancyhf{}
 \renewcommand{\headrulewidth}{0pt}
}

\fancypagestyle{empty}{
 \fancyhf{}
 \renewcommand{\headrulewidth}{0pt}
}

% support for PDF metadata not supported by hyperref package
\usepackage{hyperxmp}
%% hyper-references %%
</xsl:text>
<xsl:choose>
    <xsl:when test="$usexelatex='yes'">
     <xsl:text>\usepackage[xetex,colorlinks=false,bookmarks=true]{hyperref}</xsl:text>
     <xsl:value-of select="$newline" />
  </xsl:when>
   <xsl:otherwise>
     <xsl:text>\usepackage[pdftex,colorlinks=false,pdfborder=0 0 0,bookmarks=true]{hyperref}</xsl:text>
     <xsl:value-of select="$newline" />
   </xsl:otherwise>
 </xsl:choose>
<xsl:text>
\hypersetup{
  pdftitle={</xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>},
  pdfauthor={</xsl:text>
    <xsl:apply-templates select="/gamebook/meta/rights[@class='copyrights']" />
    <xsl:value-of select="$i18n[@src=' Published by ']"/>
    <xsl:apply-templates select="/gamebook/meta/publisher[1]" />
    <xsl:text>.},
  pdfcopyright={</xsl:text>
    <xsl:apply-templates select="/gamebook/meta/rights[@class='copyrights']" />
    <xsl:value-of select="$i18n[@src=' Published by ']"/>
    <xsl:apply-templates select="/gamebook/meta/publisher[1]" />
    <xsl:text>.},
  pdflicenseurl={http://www.projectaon.org/en/Main/License},
%% We need a meta-variable for the series in order to include it here:
  pdfsubject={Lone Wolf Series},
  pdfkeywords={lone wolf, project aon}
}

% \raggedbottom

\usepackage{multicol}

% provides environments for changing the spacing
\usepackage{setspace}

% package ellipsis provides an ellipsis with even spacing before and after the ellipsis
\usepackage{ellipsis}

%% new environments %%
\newenvironment{aonchoice}{\begin{list}{}{\setlength{\topsep}{0pt}} \item}{\end{list}}
\newenvironment{aoncombat}{\begin{list}{}{\setlength{\topsep}{0pt}} \item}{\end{list}}
\newenvironment{aonitemize}{\begin{list}{}{\setlength{\topsep}{0pt} \setlength{\parsep}{0pt} \setlength{\itemsep}{0pt}}}{\end{list}}
\newenvironment{aonordereditemize}{\begin{list}{\arabic{aoncounter}.}{\usecounter{aoncounter} \setlength{\topsep}{0pt} \setlength{\parsep}{0pt} \setlength{\itemsep}{0pt}}}{\end{list}}
\newcounter{aoncounter}

%% new commands %%
\newcommand{\lightgraybox}[2]{{\fboxsep0pt%
  \colorbox{lightgray}{\makebox(#1,#2){}}}}

% set the general style for all sectioning titles
\setkomafont{sectioning}{\normalcolor\bfseries}

% set the color of the title
\addtokomafont{title}{\color{titlecolor}}

% set layout of footnotes
\deffootnote{1em}{1em}{\textsuperscript{\thefootnotemark}}

% define the height of the large illustrations
\newlength{\figureheight}
\setlength{\figureheight}{\textheight+\headsep+\headheight/2}

% mark overfull lines; comment out to disable the marker
%\overfullrule=30pt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\title{</xsl:text><xsl:value-of select="/gamebook/meta/title[1]" /><xsl:text>}
\author{</xsl:text><xsl:apply-templates select="/gamebook/meta/creator[@class='medium']/line" /><xsl:text>}
\date{}

</xsl:text>

<!--
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
-->

  <xsl:text>\uppertitleback{</xsl:text>
    <xsl:apply-templates select="/gamebook/meta/description[@class='blurb']" />
  <xsl:text>}</xsl:text>

  <xsl:value-of select="$newparagraph" />

  <xsl:text>\lowertitleback{</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:apply-templates select="/gamebook/meta/rights[@class='license-notification']/p/line" />

    <xsl:value-of select="$newline" />
    <xsl:text>~\\</xsl:text>
    <xsl:value-of select="$newline" />

    <xsl:value-of select="$i18n[@src='Publication Date: ']"/>

    <xsl:variable name="date-string">
      <xsl:value-of select="/gamebook/meta/date[@class='publication']/year" />
      <xsl:text>-</xsl:text>
      <xsl:if test="/gamebook/meta/date[@class='publication']/month &lt; 10">
        <xsl:text>0</xsl:text>
      </xsl:if>
      <xsl:value-of select="/gamebook/meta/date[@class='publication']/month" />
      <xsl:text>-</xsl:text>
      <xsl:if test="/gamebook/meta/date[@class='publication']/day &lt; 10">
        <xsl:text>0</xsl:text>
      </xsl:if>
      <xsl:value-of select="/gamebook/meta/date[@class='publication']/day" />
    </xsl:variable>

    <xsl:call-template name="date:format-date-localized">
      <xsl:with-param name="date-time" select="$date-string" />
      <xsl:with-param name="pattern" select="$i18n[@src='Format of publication date']" />
    </xsl:call-template>

    <xsl:text>\\</xsl:text>
    <xsl:value-of select="$newparagraph" />

    <xsl:apply-templates select="/gamebook/meta/description[@class='publication']" />
    <xsl:text>~\\</xsl:text>
    <xsl:value-of select="$newline" />

    <xsl:value-of select="$i18n[@src='This PDF was typeset with \LaTeX.']"/>
    <xsl:value-of select="$newline" />
  <xsl:text>}</xsl:text>

  <xsl:value-of select="$newparagraph" />

  <xsl:text>\dedication{</xsl:text>
    <xsl:apply-templates select="/gamebook/section/data/section/data/p[@class='dedication']" />
  <xsl:text>}</xsl:text>

  <xsl:value-of select="$newparagraph" />

  <xsl:text>\maketitle</xsl:text>

  <xsl:value-of select="$newparagraph" />

  <xsl:text>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Bearer Scroll  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following definition is use to put the bearer scroll over the margin.
% Measurement is based on the English bearer scrolls (420 x 597).
% To prevent problems with other scrolls, the scrolls is scaled to 
% this size
% -----------------------------------------------------------------------
% \thispagestyle{empty}
% \newlength{\bearersaveunitlength}
% \setlength{\bearersaveunitlength}{\unitlength}
% \setlength{\unitlength}{1mm}
%\begin{picture}(0,0)
%  \put(-22,-180){\includegraphics[height=597pt,keepaspectratio]{bearer.pdf}}
% \end{picture}%
% \setlength{\unitlength}{\bearersaveunitlength}
% \cleardoublepage
% -----------------------------------------------------------------------
%
% Alternate definition -  [TODO] needs to be tested in English PDF builds
%
% In order to not depend on the *real* size of the PDF
% it is be best to have the size be strictly defined.
% This section uses the eso-pic package to 
% set the bearer scroll as a background picture, centered and 
% scaled to fit in the page.
\AddToShipoutPicture*{
    \put(0,0){
        \parbox[b][\paperheight]{\paperwidth}{
            \vfill
            \centering
            \includegraphics[height=\paperheight,keepaspectratio]{bearer.pdf}
            \vfill
         }
    }
}
\clearpage\mbox{}\clearpage
\ClearShipoutPicture
\cleardoublepage


\tableofcontents

\pagestyle{fancy}

% we do not need the special properties of the frontmatter, e.g.
% separate page numbering with Roman numbers; so we omit the command
% \frontmatter

</xsl:text>

<xsl:text>\addchap{</xsl:text>
<xsl:value-of select="$i18n[@src='About the Author and Illustrator']"/>
<xsl:text>}</xsl:text>

<xsl:apply-templates select="/gamebook/meta/creator[@class='long']" />

<xsl:apply-templates select="data/section[@class='frontmatter']" />

<xsl:text>

% we do not use \frontmatter; so we omit the command \mainmatter as well

</xsl:text>

<xsl:if test="data/section[@class='mainmatter']">
 <xsl:apply-templates select="data/section[@class='mainmatter']" />
</xsl:if>

<xsl:if test="data/section[@class='numbered']">
 <xsl:apply-templates select="data/section[@class='numbered']" />
</xsl:if>

<xsl:text>

\backmatter

\ifthenelse{\boolean{@twoside}}%
{ %% Two-sided %%
  \fancyhead[RO,LE]{}
}
{ %% One-sided %%
  \fancyhead[R]{}
}

\setcounter{topnumber}{6}
\renewcommand{\topfraction}{1}
\renewcommand{\textfraction}{0}
\setlength{\floatsep}{10pt}

</xsl:text>

<!-- insert the backmatter sections in the following order -->

<xsl:apply-templates select="data/section[@class='backmatter' and @id='action']" />
<xsl:apply-templates select="data/section[@class='backmatter' and @id='crsumary']" />
<xsl:apply-templates select="data/section[@class='backmatter' and @id='crtable']" />
<xsl:apply-templates select="data/section[@class='backmatter' and @id='random']" />
<xsl:apply-templates select="data/section[@class='backmatter' and @id='errata']" />
<xsl:apply-templates select="data/section[@class='backmatter' and @id='license']" />
<xsl:apply-templates select="data/section[@class='backmatter' and @id='map']" />

<xsl:text>

\end{document}
</xsl:text>

</xsl:template>

<xsl:template match="/gamebook/section[@id='toc']" />

<xsl:template match="section" />

<!-- ::::::::::: second-level frontmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='frontmatter']">

 <xsl:value-of select="$newline" />

 <xsl:text>\addchap{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>


<!-- override the above for the dedication section -->
<!-- do nothing; the dedication is explicitly handled by <xsl:template match="/gamebook/section[@id='title']"> -->
<xsl:template match="/gamebook/section/data/section[@class='frontmatter' and @id='dedicate']" />


<!-- :::::::::::: third-level front matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter']">

 <xsl:value-of select="$newline" />

 <xsl:text>\addsec{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>


<!-- override the above for the Credits section of the Acknowledgements chapter -->
<!-- do not add the title of the Credits section -->
<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter' and @id='credits']">
  <xsl:apply-templates />
</xsl:template>


<xsl:template match="/gamebook/section/data/section/data/section[@class='frontmatter-separate']">

 <xsl:value-of select="$newline" />

 <!--
 <xsl:text>\newpage</xsl:text><xsl:value-of select="$newline" />
 -->

 <xsl:text>\addsec{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>

<!-- :::::::::::: fourth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='frontmatter']">

 <xsl:value-of select="$newline" />

 <xsl:text>\subsection*{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>

<!-- ::::::::::::: fifth-level front matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='frontmatter']">
 <xsl:text>{\large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
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
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{section}{\protect\numberline{}{</xsl:text>
  <xsl:apply-templates select="meta/title[1]" />
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
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{subsection}{\protect\numberline{}{</xsl:text>
  <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::: fourth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='mainmatter'] | /gamebook/section/data/section/data/section/data/section[@class='mainmatter-separate']">
 <xsl:text>{\Large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::: fifth-level main matter sections :::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section/data/section[@class='mainmatter']">
 <xsl:text>{\large \hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
 <xsl:text>}{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
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
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />
</xsl:template>

<!-- :::::::::::::::::: numbered sections ::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='numbered']">
 <xsl:text>\cleardoublepage</xsl:text>
 <xsl:value-of select="$newparagraph" />

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
    }
   }</xsl:text>
   <xsl:value-of select="$newparagraph" />
 </xsl:if>

 <xsl:choose>
   <xsl:when test="not( self::node()[@id='numbered'] )">
     <xsl:text>\addchap[</xsl:text>
       <xsl:apply-templates select="meta/title[1]" />
     <xsl:text>]{\hfill{}</xsl:text>
       <xsl:apply-templates select="meta/title[1]" />
     <xsl:text>\hfill}</xsl:text>
     <xsl:text>\hypertarget{</xsl:text>
       <xsl:value-of select="@id" />
     <xsl:text>}{}</xsl:text>
   </xsl:when>
   <xsl:otherwise>
     <xsl:text>\phantomsection</xsl:text>
     <xsl:text>\hypertarget{</xsl:text>
       <xsl:value-of select="@id" />
     <xsl:text>}{}</xsl:text>
     <xsl:value-of select="$newline" />
     <xsl:text>\addcontentsline{toc}{chapter}{\protect{</xsl:text>
       <xsl:apply-templates select="meta/title[1]" />
     <xsl:text>}}</xsl:text>
   </xsl:otherwise>
 </xsl:choose>

 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

 <xsl:value-of select="$newparagraph" />
 <xsl:text>\cleardoublepage</xsl:text>
 <xsl:value-of select="$newparagraph" />

</xsl:template>

<xsl:template match="/gamebook/section/data/section[@class='numbered']/data/section[@class='numbered']">

  <xsl:variable name="section-title" select="meta/title[1]" />

  <xsl:value-of select="$newline" />

  <xsl:text>\addsec[</xsl:text>
  <xsl:value-of select="$i18n[@src='Section']" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="$section-title" />
  <xsl:text>]{\hspace*{\fill}</xsl:text>
  <xsl:text>\hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
  <xsl:text>}{}</xsl:text>
  <xsl:value-of select="$section-title" />
  <xsl:text>\hspace*{\fill}}</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:for-each select="data/illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]">
    <xsl:text>\hspace*{\fill} \mbox{\itshape \hyperlink{ill</xsl:text>
    <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" />
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="$i18n[@src='Illustration']" />
    <xsl:text>~</xsl:text>
    <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="I" />
    <xsl:text>}}\hspace*{\fill}\\*[\parskip]</xsl:text>
    <xsl:value-of select="$newline" />

    <!-- insert the illustration -->
    <xsl:text>\begin{figure}[p]</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\centering</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\hypertarget{ill</xsl:text>
      <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" />
    <xsl:text>}{}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\raisebox{0cm}[\textheight]{</xsl:text>
      <xsl:text>\includegraphics[width=\textwidth,height=\figureheight,keepaspectratio]{</xsl:text>
        <xsl:value-of select="instance[@class='pdf']/@src" />
      <xsl:text>}</xsl:text>
    <xsl:text>}%</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\\{\itshape </xsl:text>
      <xsl:apply-templates select="meta/description" />
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\end{figure}</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:for-each>

  <xsl:apply-templates />

</xsl:template>

<!-- :::::::::::: second-level backmatter sections :::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@class='backmatter']">

 <xsl:value-of select="$newline" />

 <xsl:text>\addchap{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>


<!-- override the above for the Footnotes section -->
<!-- do nothing; we do not want a Footnotes in the PDF -->
<xsl:template match="/gamebook/section/data/section[@class='backmatter' and @id='footnotz']" />

<!-- override the above for the Table of Illustrations section -->
<!-- do nothing; we do not want a Table of Illustrations in the PDF -->
<xsl:template match="/gamebook/section/data/section[@class='backmatter' and @id='illstrat']" />

<xsl:template match="/gamebook/section/data/section[@class='backmatter' and ( @id='license' or @id='errata' )]">
  <xsl:value-of select="$newline" />

  <xsl:text>\addchap{</xsl:text>
  <xsl:apply-templates select="meta/title[1]" />
  <xsl:text>}</xsl:text>
  <xsl:text>\hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
  <xsl:text>}{}</xsl:text>
  <xsl:value-of select="$newparagraph" />

<xsl:text>
\addtokomafont{section}{\scriptsize}
\addtokomafont{paragraph}{\tiny}
\begin{multicols}{2}
\tiny
</xsl:text>

  <xsl:apply-templates />

<xsl:text>
\end{multicols}
\addtokomafont{section}{\Large}
\addtokomafont{paragraph}{\normalsize}
</xsl:text>

</xsl:template>


<!-- ::::::::::::: third-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section[@class='backmatter']">

 <xsl:value-of select="$newline" />

 <xsl:text>\addsec*{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>

<!-- ::::::::::::: fourth-level back matter sections ::::::::::::: -->

<xsl:template match="/gamebook/section/data/section/data/section/data/section[@class='backmatter']">

 <xsl:value-of select="$newline" />

 <xsl:text>\subsection*{</xsl:text>
 <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}</xsl:text>
 <xsl:text>\hypertarget{</xsl:text>
 <xsl:value-of select="@id" />
 <xsl:text>}{}</xsl:text>
 <xsl:value-of select="$newline" />

 <xsl:value-of select="$newparagraph" />

 <xsl:apply-templates />

</xsl:template>


<xsl:template match="/gamebook/section/data/section[@id='license']/data/section/data/section[@class='backmatter']">
  <xsl:value-of select="$newline" />

  <xsl:text>\paragraph*{</xsl:text>
  <xsl:apply-templates select="meta/title[1]" />
  <xsl:text>}</xsl:text>
  <xsl:text>\hypertarget{</xsl:text>
  <xsl:value-of select="@id" />
  <xsl:text>}{}</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:apply-templates />
</xsl:template>


<!-- :::::::::::::::::: dedication template ::::::::::::::::::::: -->

<xsl:template match="p[@class='dedication']">
 <xsl:apply-templates />
</xsl:template>

<!-- ::::::::::::::::::::: map template ::::::::::::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@id='map']">
  <xsl:variable name="map-title" select="meta/title" />

  <xsl:text>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Map  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:text>\clearpage</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>\ifthispageodd{\thispagestyle{empty}~\clearpage}{}</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:for-each select="data/illustration[contains( $use-illustrators, concat( ':', meta/creator, ':' ) ) ]">
    <xsl:variable name="illustration-src" select="instance[@class='pdf']/@src" />

    <xsl:text>\phantomsection\hypertarget{map}{}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\addcontentsline{toc}{chapter}{\protect{</xsl:text>
      <xsl:value-of select="$map-title" />
    <xsl:text>}}</xsl:text>
    <xsl:value-of select="$newparagraph" />

    <xsl:text>
\thispagestyle{empty}
\newlength{\saveunitlength}
\setlength{\saveunitlength}{\unitlength}
\setlength{\unitlength}{1mm}
\ifthenelse{\boolean{@twoside}}%
{ %% Two-sided %%
  \begin{picture}(10,10)
  \put(-0.5,-170){\includegraphics[origin=c,width=28cm,height=20cm,keepaspectratio]{</xsl:text><xsl:value-of select="$illustration-src" /><xsl:text>}}
  \end{picture}
  \clearpage
  \thispagestyle{empty}
  \begin{picture}(10,10)
  \put(-151.23,-170){\includegraphics[origin=c,width=28cm,height=20cm,keepaspectratio]{</xsl:text><xsl:value-of select="$illustration-src" /><xsl:text>}}
  \end{picture}
}%
{ %% One-sided %%
  \begin{picture}(10,10)
  \put(-29,-188){\includegraphics[angle=90,origin=c,width=20cm,height=28cm,keepaspectratio]{</xsl:text><xsl:value-of select="$illustration-src" /><xsl:text>}}
  \end{picture}%
}
\setlength{\unitlength}{\saveunitlength}</xsl:text>
    <xsl:value-of select="$newparagraph" />
  </xsl:for-each>
</xsl:template>

<!-- :::::::::::::::::: action chart template ::::::::::::::::::: -->

<!-- TODO: This definition only works if the PDF image is exactly
     one page in its size. This definition could be similar to the
     bearer scroll above -->
<xsl:template match="/gamebook/section/data/section[@id='action']">

  <xsl:text>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Action Chart  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\clearpage
\ifthispageodd{\thispagestyle{empty}~\clearpage}{}

\newlength{\acsaveunitlength}
\setlength{\acsaveunitlength}{\unitlength}
\setlength{\unitlength}{1mm}

\phantomsection\hypertarget{action}{}
\addcontentsline{toc}{chapter}{\protect{</xsl:text><xsl:apply-templates select="meta/title[1]" /><xsl:text>}}</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:for-each select="data/illustration[contains( $use-illustrators, concat( ':', meta/creator, ':' ) ) ]/instance[@class='pdf']">
    <xsl:variable name="src" select="@src" />
    <xsl:variable name="posx" select="@posx" />
    <xsl:variable name="posy" select="@posy" />

    <xsl:text>\thispagestyle{empty}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\begin{picture}(0,0)</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>  \put(</xsl:text><xsl:value-of select="$posx" /><xsl:text>,</xsl:text>
      <xsl:value-of select="$posy" /><xsl:text>){\includegraphics{</xsl:text>
      <xsl:value-of select="$src" /><xsl:text>}}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\end{picture}%</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\clearpage</xsl:text>
    <xsl:value-of select="$newparagraph" />
  </xsl:for-each>

  <xsl:text>\setlength{\unitlength}{\acsaveunitlength}</xsl:text>
  <xsl:value-of select="$newparagraph" />

</xsl:template>

<!-- :::::::::::::: combat results table template ::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@id='crtable']">

 <xsl:text>\clearpage</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\ifthispageodd{\thispagestyle{empty}~\clearpage}{}</xsl:text>
 <xsl:value-of select="$newparagraph" />

 <xsl:text>\phantomsection\hypertarget{crtable}{}</xsl:text>
 <xsl:value-of select="$newline" />
 <xsl:text>\addcontentsline{toc}{chapter}{\protect{</xsl:text>
  <xsl:apply-templates select="meta/title[1]" />
 <xsl:text>}}</xsl:text>
 <xsl:value-of select="$newparagraph" />

  <xsl:choose>
    <xsl:when test="data/illustration/instance[@class='text']">
      <xsl:text>\thispagestyle{empty}</xsl:text>
      <xsl:value-of select="$newparagraph" />
      <xsl:call-template name="combat-ratio-table">
        <xsl:with-param name="title"><xsl:value-of select="$i18n[@src='Negative Combat Ratio']" /></xsl:with-param>
        <xsl:with-param name="startCol" select="1" />
        <xsl:with-param name="endCol" select="7" />
        <xsl:with-param name="colHeaders">
          <th><xsl:text>\shortstack{\footnotesize \textbf{-11} </xsl:text><xsl:value-of select="$i18n[@src='or (as in -11 or less)']" /><xsl:text>\\ \footnotesize </xsl:text><xsl:value-of select="$i18n[@src='less (as in -11 or less)']" /><xsl:text>}</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries -10/-9</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries -8/-7</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries -6/-5</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries -4/-3</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries -2/-1</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries 0</xsl:text></th>
        </xsl:with-param>
        <xsl:with-param name="showLeftLabel" select="1" />
      </xsl:call-template>
      <xsl:text>\clearpage</xsl:text>
      <xsl:value-of select="$newparagraph" />
      <xsl:text>\thispagestyle{empty}</xsl:text>
      <xsl:value-of select="$newparagraph" />
      <xsl:call-template name="combat-ratio-table">
        <xsl:with-param name="title"><xsl:value-of select="$i18n[@src='Positive Combat Ratio']" /></xsl:with-param>
        <xsl:with-param name="startCol" select="7" />
        <xsl:with-param name="endCol" select="13" />
        <xsl:with-param name="colHeaders">
          <th><xsl:text>\footnotesize \bfseries 0</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries 1/2</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries 3/4</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries 5/6</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries 7/8</xsl:text></th>
          <th><xsl:text>\footnotesize \bfseries 9/10</xsl:text></th>
          <th><xsl:text>\shortstack{\footnotesize \textbf{11} </xsl:text><xsl:value-of select="$i18n[@src='or (as in 11 or greater)']" /><xsl:text>\\ \footnotesize </xsl:text><xsl:value-of select="$i18n[@src='greater (as in 11 or greater)']" /><xsl:text>}</xsl:text></th>
        </xsl:with-param>
        <xsl:with-param name="showRightLabel" select="1" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        Error: Instance of random number table of class 'text' is missing.
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ::::::::::::::: random number table template ::::::::::::::: -->

<xsl:template match="/gamebook/section/data/section[@id='random']">
  <xsl:text>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Random Number Table  %%%%%%%%%%%%%%%%%%%%%%%%%%%%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:text>\clearpage</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>\thispagestyle{empty}</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:text>\phantomsection\begin{center}\hypertarget{random}{{\usekomafont{disposition}\usekomafont{chapter}</xsl:text>
    <xsl:apply-templates select="meta/title[1]" />
  <xsl:text>}}\end{center}</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>\addcontentsline{toc}{chapter}{\protect{</xsl:text>
    <xsl:apply-templates select="meta/title[1]" />
  <xsl:text>}}</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:choose>
    <xsl:when test="data/illustration/instance[@class='text']">
      <!-- use a dummy value for the width of the picture environment -->
      <xsl:text>
\setlength{\unitlength}{1mm}
\noindent\begin{picture}(10,</xsl:text><xsl:value-of select="10 * number($RNTHeightOfBox)" /><xsl:text>)(</xsl:text><xsl:value-of select="-1 * number($RNTOffsetX)" /><xsl:text>,</xsl:text><xsl:value-of select="-1 * number($RNTOffsetY)" /><xsl:text>)
  \linethickness{0.25mm}

  %% Boxes %%
  \multiput(0,0)(0,</xsl:text><xsl:value-of select="2 * number($RNTHeightOfBox)" /><xsl:text>){5}{%
    \multiput(0,0)(</xsl:text><xsl:value-of select="2 * number($RNTWidthOfBox)" /><xsl:text>,0){5}{\lightgraybox{</xsl:text><xsl:value-of select="$RNTWidthOfBox" /><xsl:text>}{</xsl:text><xsl:value-of select="$RNTHeightOfBox" /><xsl:text>}}%
  }
  \multiput(0,</xsl:text><xsl:value-of select="$RNTHeightOfBox" /><xsl:text>)(0,</xsl:text><xsl:value-of select="2 * number($RNTHeightOfBox)" /><xsl:text>){5}{%
    \multiput(</xsl:text><xsl:value-of select="$RNTWidthOfBox" /><xsl:text>,0)(</xsl:text><xsl:value-of select="2 * number($RNTWidthOfBox)" /><xsl:text>,0){5}{\lightgraybox{</xsl:text><xsl:value-of select="$RNTWidthOfBox" /><xsl:text>}{</xsl:text><xsl:value-of select="$RNTHeightOfBox" /><xsl:text>}}%
  }

  %% Lines %%
  \multiput(0,0)(0,</xsl:text><xsl:value-of select="$RNTHeightOfBox" /><xsl:text>){11}{%
    \line(1,0){</xsl:text><xsl:value-of select="10 * number($RNTWidthOfBox)" /><xsl:text>}%
  }
  \multiput(0,0)(</xsl:text><xsl:value-of select="$RNTWidthOfBox" /><xsl:text>,0){11}{%
    \line(0,1){</xsl:text><xsl:value-of select="10 * number($RNTHeightOfBox)" /><xsl:text>}%
  }

  %% Numbers %%</xsl:text>
      <xsl:value-of select="$newline" />
      <xsl:for-each select="data/illustration/instance[@class='text']/table/tr">
        <xsl:variable name="row"><xsl:number value="position()" format="1" /></xsl:variable>
        <xsl:text>  %% row </xsl:text><xsl:value-of select="$row" /><xsl:text> %%</xsl:text>
        <xsl:value-of select="$newline" />
        <xsl:for-each select="./td">
          <xsl:variable name="col"><xsl:number value="position()" format="1" /></xsl:variable>
          <xsl:text>  \put(</xsl:text><xsl:value-of select="number($col) * number($RNTWidthOfBox) - number($RNTWidthOfBox) div 2" /><xsl:text>,</xsl:text><xsl:value-of select="(10 - number($row)) * number($RNTHeightOfBox) + number($RNTHeightOfBox) div 2" /><xsl:text>){\makebox(0,0){\bfseries \Huge </xsl:text><xsl:value-of select="." /><xsl:text>}}</xsl:text>
          <xsl:value-of select="$newline" />
        </xsl:for-each>
      </xsl:for-each>
      <xsl:value-of select="$newline" />
      <xsl:text>\end{picture}</xsl:text>
      <xsl:value-of select="$newline" />
      <xsl:text>\setlength{\unitlength}{1pt}</xsl:text>
      <xsl:value-of select="$newparagraph" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        Error: Instance of random number table of class 'text' is missing.
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ==================== block elements ======================== -->

<xsl:template match="p">
  <xsl:apply-templates />
  <xsl:choose>
    <xsl:when test="position()!=last()">
      <xsl:value-of select="$newparagraph" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$newline" />
    </xsl:otherwise>
  </xsl:choose>
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
 <xsl:text>\begin{aonordereditemize}</xsl:text><xsl:value-of select="$newline" />
 <xsl:apply-templates />
 <xsl:text>\end{aonordereditemize}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="dl">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="dt">
 <xsl:text>\minisec{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
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

<xsl:template match="table">
 <xsl:text>\begin{tabular}{*{</xsl:text>
 <xsl:for-each select="tr[1]">
   <xsl:value-of select="count(descendant::*[not(child::*)])" />
 </xsl:for-each>
 <xsl:text>}{l}}</xsl:text>
 <xsl:value-of select="$newline" />
  <xsl:apply-templates />
 <xsl:text>\end{tabular}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="tr">
 <xsl:apply-templates />
 <xsl:text>\\&#10;</xsl:text>
</xsl:template>

<xsl:template match="th">
 <xsl:text>\multicolumn{</xsl:text>
    <xsl:choose>
    <xsl:when test="@colspan!=0"><xsl:value-of select="@colspan" /></xsl:when>
    <xsl:otherwise><xsl:text>1</xsl:text></xsl:otherwise>
    </xsl:choose>
 <xsl:text>}{</xsl:text>
 <xsl:choose>
  <xsl:when test="@align='left'"><xsl:text>l}{\bfseries </xsl:text></xsl:when>
  <xsl:when test="@align='right'"><xsl:text>r}{\bfseries </xsl:text></xsl:when>
  <xsl:when test="@align='center'"><xsl:text>c}{\bfseries </xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>l}{\bfseries </xsl:text></xsl:otherwise>
 </xsl:choose>
  <xsl:apply-templates />
 <xsl:text>} </xsl:text>
 <xsl:if test="position()!=last()"><xsl:text> &amp; </xsl:text></xsl:if>
</xsl:template>

<xsl:template match="td">
 <xsl:text>\multicolumn{</xsl:text>
    <xsl:choose>
    <xsl:when test="@colspan!=0"><xsl:value-of select="@colspan" /></xsl:when>
    <xsl:otherwise><xsl:text>1</xsl:text></xsl:otherwise>
    </xsl:choose>
 <xsl:text>}{</xsl:text>
 <xsl:choose>
  <xsl:when test="@align='left'"><xsl:text>l}{</xsl:text></xsl:when>
  <xsl:when test="@align='right'"><xsl:text>r}{</xsl:text></xsl:when>
  <xsl:when test="@align='center'"><xsl:text>c}{</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>l}{</xsl:text></xsl:otherwise>
 </xsl:choose>
  <xsl:apply-templates />
 <xsl:text>} </xsl:text>
 <xsl:if test="position()!=last()"><xsl:text> &amp; </xsl:text></xsl:if>
</xsl:template>

<xsl:template match="combat">
 <xsl:text>\begin{aoncombat}</xsl:text>
  <xsl:apply-templates select="enemy" />
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='combatskill']">
    <xsl:text>: {\sc </xsl:text>
    <xsl:value-of select="$i18n[@src='Combat~Skill']" />
    <xsl:text>}~</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='combatskill']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='closecombatskill']">
    <xsl:text>: {\sc </xsl:text>
    <xsl:value-of select="$i18n[@src='Close~Combat~Skill']" />
    <xsl:text>}~</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='closecombatskill']" />
   </xsl:when>
  </xsl:choose>
  <xsl:choose>
   <xsl:when test="enemy-attribute[@class='endurance']">
    <xsl:text> ~~{\sc </xsl:text>
    <xsl:value-of select="$i18n[@src='Endurance']" />
    <xsl:text>}~</xsl:text>
    <xsl:value-of select="enemy-attribute[@class='endurance']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='target']">
    <xsl:value-of select="$i18n[@src='~({\sc Target}~points)~']" />
    <xsl:value-of select="enemy-attribute[@class='target']" />
   </xsl:when>
   <xsl:when test="enemy-attribute[@class='resistance']">
    <xsl:value-of select="$i18n[@src='~({\sc Resistance}~points)~']" />
    <xsl:value-of select="enemy-attribute[@class='resistance']" />
   </xsl:when>
  </xsl:choose>
 <xsl:text>\end{aoncombat}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="choice">
 <xsl:variable name="link">
  <xsl:value-of select="@idref" />
 </xsl:variable>

 <xsl:text>\nopagebreak\begin{aonchoice}</xsl:text>
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

<!-- "top-level" signpost element -->
<xsl:template match="data/signpost">
  <!-- CSS for HTML:
       text-align: center;
       padding-top: 0.5em;
       padding-bottom: 0.5em;
       line-height: 1.5em;
  -->
  <xsl:text>\begin{onehalfspace}\begin{center}</xsl:text>
    <xsl:apply-templates />
  <xsl:text>\end{center}\end{onehalfspace}</xsl:text>
  <xsl:value-of select="$newparagraph" />
</xsl:template>

<!-- inline signpost element -->
<xsl:template match="signpost">
  <!-- CSS for HTML:
       font-size: 0.8em
  -->
  <xsl:text>\begin{small}</xsl:text>
    <xsl:apply-templates />
  <xsl:text>\end{small}</xsl:text>
</xsl:template>

<xsl:template match="blockquote">
 <xsl:text>\begin{quote}</xsl:text>
 <xsl:apply-templates />
 <xsl:text>\end{quote}</xsl:text>
 <xsl:value-of select="$newparagraph" />
</xsl:template>

<xsl:template match="poetry">
  <xsl:text>\begin{flushleft}</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>\begin{verse}</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:apply-templates />
  <xsl:text>\end{verse}</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>\end{flushleft}</xsl:text>
  <xsl:value-of select="$newparagraph" />
</xsl:template>

<!-- special treatment of the blockquote in the License section
     since a quote environment does not fit -->
<xsl:template match="section[@id='license']//blockquote">
  <xsl:text>\begin{center}</xsl:text>
  <xsl:value-of select="$newline" />
    <xsl:apply-templates />
  <xsl:text>\end{center}</xsl:text>
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
   <xsl:if test="@class='float'">
    <xsl:text>\hypertarget{ill</xsl:text>
    <xsl:number count="illustration[@class='float' and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )]" from="/" level="any" format="1" />
    <xsl:text>}{}</xsl:text>
    <xsl:value-of select="$newline" />
   </xsl:if>
   <xsl:text>\includegraphics</xsl:text>
   <xsl:choose>
    <xsl:when test="@class='inline'">
     <xsl:text>[width=</xsl:text>
     <xsl:choose>
      <xsl:when test="instance[@class='pdf']/@originalwidth">
       <xsl:value-of select="instance[@class='pdf']/@originalwidth" />
      </xsl:when>
      <xsl:otherwise>\textwidth</xsl:otherwise>
     </xsl:choose>
     <xsl:text>,keepaspectratio]</xsl:text>
    </xsl:when>
    <xsl:when test="@class='float'">
     <xsl:text>[width=\textwidth,height=\textheight,keepaspectratio]</xsl:text>
    </xsl:when>
    <xsl:when test="@class='accent'" />
    <xsl:otherwise><xsl:text>invalid class</xsl:text></xsl:otherwise>
   </xsl:choose>
   <xsl:text>{</xsl:text>
    <xsl:value-of select="instance[@class='pdf']/@src" />
   <xsl:text>} %</xsl:text>
   <xsl:if test="@class='float'">
    <xsl:value-of select="$newline" />
    <xsl:text>\vspace*{\fill}</xsl:text>
    <xsl:value-of select="$newline" />
    <!--
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
    <xsl:text>}}\\[1em]</xsl:text>
    -->
    <xsl:text>\\{\itshape </xsl:text>
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

<!-- override the above template for illustrations in numbered sections;
     they are handled by the template for numbered sections -->
<xsl:template match="/gamebook/section/data/section[@class='numbered']/data/section[@class='numbered']//illustration[@class='float']" />

<!-- override the above template for illustrations for the Equipment section -->
<xsl:template match="section[@id='equipmnt']//illustration[@class='inline']">
  <xsl:if test="instance[@class='pdf'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
    <xsl:text>\vspace{.2\baselineskip}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\begin{center}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\includegraphics</xsl:text>
    <xsl:text>[width=</xsl:text>
    <xsl:choose>
      <xsl:when test="instance[@class='pdf']/@originalwidth">
        <xsl:value-of select="instance[@class='pdf']/@originalwidth" />
      </xsl:when>
      <xsl:otherwise>\textwidth</xsl:otherwise>
    </xsl:choose>
    <xsl:text>,keepaspectratio]{</xsl:text>
      <xsl:value-of select="instance[@class='pdf']/@src" />
    <xsl:text>} %</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\end{center}</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\vspace{.2\baselineskip}</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:if>
</xsl:template>

<!-- override the above template for illustrations for the Weaponskill section -->
<xsl:template match="section[@id='wepnskll']//illustration[@class='inline']">
  <xsl:if test="instance[@class='pdf'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
    <xsl:text>\begin{figure}[!ht]</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\centering</xsl:text>
    <xsl:value-of select="$newline" />

<xsl:text>
  \let\PBS=\PreserveBackslash
  \begin{tabular}{>{\PBS\centering}m{50mm}@{\hspace{0mm}}>{\PBS\centering}m{50mm}}%
    % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=10.5mm,keepaspectratio]{weapons-dagger.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=27mm,keepaspectratio]{weapons-sword.pdf} \\ % \hline
    0 = </xsl:text><xsl:value-of select="$i18n[@src='Dagger']"/><xsl:text> &amp; 5 = </xsl:text><xsl:value-of select="$i18n[@src='Sword']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=39mm,keepaspectratio]{weapons-spear.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=20mm,keepaspectratio]{weapons-axe.pdf} \\ % \hline
    1 = </xsl:text><xsl:value-of select="$i18n[@src='Spear']"/><xsl:text> &amp; 6 = </xsl:text><xsl:value-of select="$i18n[@src='Axe']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=20mm,keepaspectratio]{weapons-mace.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=27mm,keepaspectratio]{weapons-sword.pdf} \\ % \hline
    2 = </xsl:text><xsl:value-of select="$i18n[@src='Mace']"/><xsl:text> &amp; 7 = </xsl:text><xsl:value-of select="$i18n[@src='Sword']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=20mm,keepaspectratio]{weapons-shortsword.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=43.5mm,keepaspectratio]{weapons-quarterstaff.pdf} \\ % \hline
    3 = </xsl:text><xsl:value-of select="$i18n[@src='Short Sword']"/><xsl:text> &amp; 8 = </xsl:text><xsl:value-of select="$i18n[@src='Quarterstaff']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=16mm,keepaspectratio]{weapons-warhammer.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=33mm,keepaspectratio]{weapons-broadsword.pdf} \\ % \hline
    4 = </xsl:text><xsl:value-of select="$i18n[@src='Warhammer']"/><xsl:text> &amp; 9 = </xsl:text><xsl:value-of select="$i18n[@src='Broadsword']"/><xsl:text> \\ % \hline
  \end{tabular}
</xsl:text>

<!--
    <xsl:for-each select="instance[@class='pdf']/table/tr">
      <xsl:variable name="row"><xsl:number value="position()" format="1" /></xsl:variable>
      <xsl:
        <xsl:text>  %% row </xsl:text><xsl:value-of select="$row" /><xsl:text> %%</xsl:text>
        <xsl:value-of select="$newline" />
        <xsl:for-each select="./td">
          <xsl:variable name="col"><xsl:number value="position()" format="1" /></xsl:variable>
          <xsl:text>  \put(</xsl:text><xsl:value-of select="number($col) * number($RNTWidthOfBox) - number($RNTWidthOfBox) div 2" /><xsl:text>,</xsl:text><xsl:value-of select="(10 - number($row)) * number($RNTHeightOfBox) + number($RNTHeightOfBox) div 2" /><xsl:text>){\makebox(0,0){\bfseries \Huge </xsl:text><xsl:value-of select="." /><xsl:text>}}</xsl:text>
          <xsl:value-of select="$newline" />
        </xsl:for-each>
    </xsl:for-each>
-->

    <xsl:text>\end{figure}</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:if>
</xsl:template>

<!-- override the above template for illustrations for the Weaponmastery section -->
<xsl:template match="section[@id='wpnmstry']//illustration[@class='inline']">
  <xsl:if test="instance[@class='pdf'] and contains( $use-illustrators, concat( ':', meta/creator, ':' ) )">
    <xsl:text>\begin{figure}[!ht]</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>\centering</xsl:text>
    <xsl:value-of select="$newline" />

<xsl:text>
  \let\PBS=\PreserveBackslash
  \begin{tabular}{>{\PBS\centering}m{50mm}@{\hspace{0mm}}>{\PBS\centering}m{50mm}}%
    % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=39mm,keepaspectratio]{weapons-spear.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=42.5mm,keepaspectratio]{weapons-bow.pdf} \\ % \hline
    </xsl:text><xsl:value-of select="$i18n[@src='Spear']"/><xsl:text> &amp; </xsl:text><xsl:value-of select="$i18n[@src='Bow']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=10.5mm,keepaspectratio]{weapons-dagger.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=20mm,keepaspectratio]{weapons-axe.pdf} \\ % \hline
    </xsl:text><xsl:value-of select="$i18n[@src='Dagger']"/><xsl:text> &amp; </xsl:text><xsl:value-of select="$i18n[@src='Axe']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=20mm,keepaspectratio]{weapons-mace.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=27mm,keepaspectratio]{weapons-sword.pdf} \\ % \hline
    </xsl:text><xsl:value-of select="$i18n[@src='Mace']"/><xsl:text> &amp; </xsl:text><xsl:value-of select="$i18n[@src='Sword']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=20mm,keepaspectratio]{weapons-shortsword.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=43.5mm,keepaspectratio]{weapons-quarterstaff.pdf} \\ % \hline
    </xsl:text><xsl:value-of select="$i18n[@src='Short Sword']"/><xsl:text> &amp; </xsl:text><xsl:value-of select="$i18n[@src='Quarterstaff']"/><xsl:text> \\ % \hline
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=16mm,keepaspectratio]{weapons-warhammer.pdf} &amp;
    \rule[-1mm]{0mm}{10mm}\includegraphics[width=33mm,keepaspectratio]{weapons-broadsword.pdf} \\ % \hline
    </xsl:text><xsl:value-of select="$i18n[@src='Warhammer']"/><xsl:text> &amp; </xsl:text><xsl:value-of select="$i18n[@src='Broadsword']"/><xsl:text> \\ % \hline
  \end{tabular}
</xsl:text>
    <xsl:text>\end{figure}</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:if>
</xsl:template>

<!-- override the above template for illustrations for the Map section -->
<!-- the map is handled by the template for the map section -->
<xsl:template match="section[@id='map']//illustration" />

<xsl:template match="instance" />

<xsl:template match="footnotes" />

<xsl:template match="footnote">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="hr">
 <xsl:text>\rule{\textwidth}{0.4pt}</xsl:text>
 <xsl:value-of select="$newline" />
</xsl:template>

<!-- ==================== inline elements ======================= -->

<xsl:template match="a">
 <xsl:if test="@href">
  <xsl:text>\href{</xsl:text>
  <xsl:value-of select="@href" />
  <xsl:text>}{</xsl:text>
 </xsl:if>
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

 <xsl:if test="@id">
  <xsl:text>}</xsl:text>
 </xsl:if>
 <xsl:if test="@idref">
  <xsl:text>}</xsl:text>
 </xsl:if>
 <xsl:if test="@href">
  <xsl:text>}</xsl:text>
 </xsl:if>
</xsl:template>

<xsl:template match="a[@idref='action']">
 <xsl:text>\hyperlink{action}{\emph{</xsl:text>
  <xsl:apply-templates />
 <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="a[@idref='random']">
 <xsl:text>\hyperlink{random}{\emph{</xsl:text>
  <xsl:apply-templates />
 <xsl:text>}}</xsl:text>
</xsl:template>

<!-- This template is obsolete, the "footref" element should be used instead -->
<xsl:template match="a[@class='footnote']">
 <xsl:apply-templates />
 <xsl:text>\footnote{</xsl:text>
 <xsl:for-each select="id( @idref )">
  <xsl:apply-templates />
 </xsl:for-each>
 <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="footref">
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

<xsl:template match="cite">
 <xsl:text>{\itshape </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="code">
 <xsl:text>{\ttfamily </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="line">
 <xsl:apply-templates />
 <xsl:if test="following-sibling::line">\\</xsl:if>
 <xsl:value-of select="$newline" />
</xsl:template>

<xsl:template match="br">
 <xsl:text>\\</xsl:text>
</xsl:template>

<xsl:template match="typ[@class='attribute']">
 <xsl:choose>
  <xsl:when test="contains(self::node(),'ENDURANCE')">
   <xsl:text>{\sc Endurance}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'COMBAT SKILL')">
   <xsl:text>{\sc Combat Skill}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'WILLPOWER')">
   <xsl:text>{\sc Willpower}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'TARGET')">
   <xsl:text>{\sc Target}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'CS')">
   <xsl:text>{\small CS}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'EP')">
   <xsl:text>{\small EP}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'RESISTANCE')">
   <xsl:text>{\sc Resistance}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'DESTREZA EN EL COMBATE')">
   <xsl:text>{\sc DESTREZA EN EL COMBATE}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'RESISTENCIA')">
   <xsl:text>{\sc RESISTENCIA}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'BLANCOS')">
   <xsl:text>{\sc BLANCOS}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'DC')">
   <xsl:text>{\small DC}</xsl:text>
  </xsl:when>
  <xsl:when test="contains(self::node(),'PR')">
   <xsl:text>{\small PR}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
   <xsl:message terminate="yes">
     Error: Unknown attribute "<xsl:value-of select="self::node()" />"
   </xsl:message>
  </xsl:otherwise>
 </xsl:choose>
<!--
 <xsl:text>{\small </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
-->
</xsl:template>

<xsl:template match="footnote//typ[@class='attribute']">
 <xsl:text>{\scriptsize </xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
</xsl:template>

<!-- ====================== text elements ======================= -->

<!-- Special template for discarding (whitespace) text between <line>
     elements in illustration captions; this is done to avoid potentially
     harmful (for the layout) line breaks.
     Note: Since <description> elements either contain "verbatim" text or
           text structured with <line> or <p> elements, but never a mix of
           non-whitespace text elements and <line> elements, I decided
           to leave out more complicated code that ensures that only
           whitespace is discarded.
-->
<xsl:template match="illustration/meta/description/text()">
  <xsl:choose>
    <xsl:when test="following-sibling::line|preceding-sibling::line" />
    <xsl:otherwise>
      <xsl:copy />
    </xsl:otherwise>
  </xsl:choose>
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
<xsl:template match="ch.copy"><xsl:text>{\copyright}</xsl:text></xsl:template><!-- copyright sign, U+00A9 ISOnum -->
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
<xsl:template match="ch.frac14"><xsl:text>$\frac{1}{4}$</xsl:text></xsl:template><!-- vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum -->
<xsl:template match="ch.frac12"><xsl:text>$\frac{1}{2}$</xsl:text></xsl:template><!-- vulgar fraction one half = fraction one half, U+00BD ISOnum -->
<xsl:template match="ch.frac34"><xsl:text>$\frac{3}{4}$</xsl:text></xsl:template><!-- vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum -->
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
<xsl:template match="ch.lsquot">\textquoteleft </xsl:template><!-- opening left quotation mark -->
<xsl:template match="ch.rsquot">\textquoteright </xsl:template><!-- closing right quotation mark -->
<xsl:template match="ch.ldquot">``</xsl:template><!-- opening left double quotation mark -->
<xsl:template match="ch.rdquot">''</xsl:template><!-- closing right double quotation mark -->
<xsl:template match="ch.minus">$-$</xsl:template><!-- mathematical minus -->
<xsl:template match="ch.endash">--</xsl:template><!-- endash -->
<xsl:template match="ch.emdash">---</xsl:template><!-- emdash -->
<xsl:template match="ch.ellips">...</xsl:template><!-- ellipsis -->
<xsl:template match="ch.lellips">...</xsl:template><!-- left ellipsis, used at the beginning of edited material -->
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
   <xsl:value-of select="$i18n[@src='Section']" />
   <xsl:text>~</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="ancestor::section[position()=1]/meta/title[1]" />
 </xsl:variable>
 
 <a>
  <xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="ancestor::section[position()=1]/@id" /></xsl:attribute>
  <xsl:value-of select="$section-title" />
 </a>
</xsl:template>

<!--
        Subroutines to generate the combat ratio tables.
-->

<xsl:template name="combat-ratio-table">
  <xsl:param name="title" />
  <xsl:param name="startCol" />
  <xsl:param name="endCol" />
  <xsl:param name="colHeaders" />
  <xsl:param name="showLeftLabel" select="0" />
  <xsl:param name="showRightLabel" select="0" />

  <xsl:variable name="offsetX">0</xsl:variable>
  <xsl:variable name="offsetY">10</xsl:variable>

  <!-- calculate a few sizes and positions -->
  <xsl:variable name="leftLabelWidth" select="number($showLeftLabel) * number($sideLabelWidth)" />
  <xsl:variable name="rightLabelWidth" select="number($showRightLabel) * number($sideLabelWidth)" />

  <xsl:variable name="legendWidth" select="2 * number($rnColWidth) + 7 * number($resultBoxWidth)" />
  <xsl:variable name="legendX" select="$leftLabelWidth" />
  <xsl:variable name="legendY" select="0" />

  <xsl:variable name="topLabelX" select="number($leftLabelWidth) + number($legendWidth) div 2" />
  <xsl:variable name="topLabelY" select="number($legendHeight) + number($legendSep) + 2 * number($combatRatioBoxHeight) + 10 * number($resultBoxHeight) + number($topLabelSep)" />

  <xsl:variable name="leftLabelX" select="number($leftLabelWidth) div 2" />
  <xsl:variable name="leftLabelY" select="number($legendHeight) + number($legendSep) + number($combatRatioBoxHeight) + 5 * number($resultBoxHeight)" />
  <xsl:variable name="rightLabelX" select="number($leftLabelWidth) + 2 * number($rnColWidth) + 7 * number($resultBoxWidth) + number($rightLabelWidth) div 2" />
  <xsl:variable name="rightLabelY" select="number($legendHeight) + number($legendSep) + number($combatRatioBoxHeight) + 5 * number($resultBoxHeight)" />

  <xsl:variable name="randomNumberBoxesLeftX" select="$leftLabelWidth" />
  <xsl:variable name="randomNumberBoxesRightX" select="number($leftLabelWidth) + number($rnColWidth) + 7 * number($resultBoxWidth)" />
  <xsl:variable name="randomNumberBoxesY" select="number($legendHeight) + number($legendSep) + number($combatRatioBoxHeight)" />

  <xsl:variable name="resultBoxesX" select="number($leftLabelWidth) + number($rnColWidth)" />
  <xsl:variable name="resultBoxesY" select="number($legendHeight) + number($legendSep) + number($combatRatioBoxHeight)" />

  <xsl:variable name="combatRatioBoxesX" select="number($leftLabelWidth) + number($rnColWidth)" />
  <xsl:variable name="combatRatioBoxesBottomY" select="number($legendHeight) + number($legendSep)" />
  <xsl:variable name="combatRatioBoxesTopY" select="number($legendHeight) + number($legendSep) + number($combatRatioBoxHeight) + 10 * number($resultBoxHeight)" />

  <xsl:variable name="totalWidth" select="number($sideLabelWidth) + 2 * number($rnColWidth) + 7 * number($resultBoxWidth)" />
  <xsl:variable name="totalHeight" select="number($legendHeight) + number($legendSep) + 2 * number($combatRatioBoxHeight) + 10 * number($resultBoxHeight) + number($topLabelSep) + number($topLabelHeight)" />

<xsl:text>\setlength{\unitlength}{1mm}
\vspace*{\stretch{1}}
\begin{center}
\begin{picture}(0,0)(</xsl:text><xsl:value-of select="0.5 * number($totalWidth) - number($offsetX)" /><xsl:text>,</xsl:text><xsl:value-of select="0.5 * number($totalHeight) - number($offsetY)" /><xsl:text>)

  %% the legend %%
  \put(</xsl:text><xsl:value-of select="$legendX" /><xsl:text>,</xsl:text><xsl:value-of select="$legendY" /><xsl:text>){%
    \makebox(</xsl:text><xsl:value-of select="$legendWidth" /><xsl:text>,</xsl:text><xsl:value-of select="$legendHeight" /><xsl:text>){%
      \mbox{\footnotesize </xsl:text><xsl:value-of select="$i18n[@src='E = Enemy EP loss']" /><xsl:text>}%
      \hfill%
      \mbox{\footnotesize </xsl:text><xsl:value-of select="$i18n[@src='LW = Lone Wolf EP loss']" /><xsl:text>}%
      \hfill%
      \mbox{\footnotesize </xsl:text><xsl:value-of select="$i18n[@src='K = Automatic Kill']" /><xsl:text>}%
    }%
  }

  %% the labels %%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:if test="number($showLeftLabel) = 1">
    <xsl:text>  \put(</xsl:text><xsl:value-of select="$leftLabelX" /><xsl:text>,</xsl:text><xsl:value-of select="$leftLabelY" /><xsl:text>){\makebox(0,0){\rotatebox{90}{\bfseries \large </xsl:text><xsl:value-of select="$i18n[@src='Random Number']" /><xsl:text>}}}</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:if>
  <xsl:if test="number($showRightLabel) = 1">
    <xsl:text>  \put(</xsl:text><xsl:value-of select="$rightLabelX" /><xsl:text>,</xsl:text><xsl:value-of select="$rightLabelY" /><xsl:text>){\makebox(0,0){\rotatebox{270}{\bfseries \large </xsl:text><xsl:value-of select="$i18n[@src='Random Number']" /><xsl:text>}}}</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:if>
  <xsl:text>  \put(</xsl:text><xsl:value-of select="$topLabelX" /><xsl:text>,</xsl:text><xsl:value-of select="$topLabelY" /><xsl:text>){\makebox(0,0)[b]{\bfseries \large </xsl:text><xsl:value-of select="$title" /><xsl:text>}}

  %% random number boxes %%
  \multiput(</xsl:text><xsl:value-of select="$randomNumberBoxesLeftX" /><xsl:text>,</xsl:text><xsl:value-of select="$randomNumberBoxesY" /><xsl:text>)(0,</xsl:text><xsl:value-of select="2 * number($randomNumberBoxHeight)" /><xsl:text>){5}{%
    \lightgraybox{</xsl:text><xsl:value-of select="$randomNumberBoxWidth" /><xsl:text>}{</xsl:text><xsl:value-of select="$randomNumberBoxHeight" /><xsl:text>}%
  }
  \multiput(</xsl:text><xsl:value-of select="$randomNumberBoxesRightX" /><xsl:text>,</xsl:text><xsl:value-of select="$randomNumberBoxesY" /><xsl:text>)(0,</xsl:text><xsl:value-of select="2 * number($randomNumberBoxHeight)" /><xsl:text>){5}{%
    \lightgraybox{</xsl:text><xsl:value-of select="$randomNumberBoxWidth" /><xsl:text>}{</xsl:text><xsl:value-of select="$randomNumberBoxHeight" /><xsl:text>}%
  }

  %% results boxes %%
  \multiput(</xsl:text><xsl:value-of select="$resultBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="$resultBoxesY" /><xsl:text>)(0,</xsl:text><xsl:value-of select="2 * number($resultBoxHeight)" /><xsl:text>){5}{%
    \multiput(</xsl:text><xsl:value-of select="$resultBoxWidth" /><xsl:text>,0)(</xsl:text><xsl:value-of select="2 * number($resultBoxWidth)" /><xsl:text>,0){3}{%
      \lightgraybox{</xsl:text><xsl:value-of select="$resultBoxWidth" /><xsl:text>}{</xsl:text><xsl:value-of select="$resultBoxHeight" /><xsl:text>}%
    }%
  }
  \multiput(</xsl:text><xsl:value-of select="$resultBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="number($resultBoxesY) + number($resultBoxHeight)" /><xsl:text>)(0,</xsl:text><xsl:value-of select="2 * number($resultBoxHeight)" /><xsl:text>){5}{%
    \multiput(0,0)(</xsl:text><xsl:value-of select="2 * number($resultBoxWidth)" /><xsl:text>,0){4}{%
      \lightgraybox{</xsl:text><xsl:value-of select="$resultBoxWidth" /><xsl:text>}{</xsl:text><xsl:value-of select="$resultBoxHeight" /><xsl:text>}%
    }%
  }

  %% combat ratio boxes %%
  \multiput(</xsl:text><xsl:value-of select="number($combatRatioBoxesX) + number($combatRatioBoxWidth)" /><xsl:text>,</xsl:text><xsl:value-of select="$combatRatioBoxesTopY" /><xsl:text>)(</xsl:text><xsl:value-of select="2 * number($combatRatioBoxWidth)" /><xsl:text>,0){3}{%
    \lightgraybox{</xsl:text><xsl:value-of select="$combatRatioBoxWidth" /><xsl:text>}{</xsl:text><xsl:value-of select="$combatRatioBoxHeight" /><xsl:text>}%
  }
  \multiput(</xsl:text><xsl:value-of select="$combatRatioBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="$combatRatioBoxesBottomY" /><xsl:text>)(</xsl:text><xsl:value-of select="2 * number($combatRatioBoxWidth)" /><xsl:text>,0){4}{%
    \lightgraybox{</xsl:text><xsl:value-of select="$combatRatioBoxWidth" /><xsl:text>}{</xsl:text><xsl:value-of select="$combatRatioBoxHeight" /><xsl:text>}%
  }

  %% lines %%
  \put(</xsl:text><xsl:value-of select="$combatRatioBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="$combatRatioBoxesBottomY" /><xsl:text>){%
    \line(1,0){</xsl:text><xsl:value-of select="7 * number($combatRatioBoxWidth)" /><xsl:text>}%
  }
  \multiput(</xsl:text><xsl:value-of select="$randomNumberBoxesLeftX" /><xsl:text>,</xsl:text><xsl:value-of select="$randomNumberBoxesY" /><xsl:text>)(0,</xsl:text><xsl:value-of select="$randomNumberBoxHeight" /><xsl:text>){11}{%
    \line(1,0){</xsl:text><xsl:value-of select="2 * number($randomNumberBoxWidth) + 7 * number($resultBoxWidth)" /><xsl:text>}%
  }
  \multiput(</xsl:text><xsl:value-of select="$resultBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="number($resultBoxesY) + number($resultBoxHeight) div 2" /><xsl:text>)(0,</xsl:text><xsl:value-of select="$resultBoxHeight" /><xsl:text>){10}{%
    \line(1,0){</xsl:text><xsl:value-of select="7 * number($resultBoxWidth)" /><xsl:text>}%
  }
  \put(</xsl:text><xsl:value-of select="$combatRatioBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="number($combatRatioBoxesTopY) + number($combatRatioBoxHeight)" /><xsl:text>){%
    \line(1,0){</xsl:text><xsl:value-of select="7 * number($combatRatioBoxWidth)" /><xsl:text>}%
  }

  \put(</xsl:text><xsl:value-of select="$randomNumberBoxesLeftX" /><xsl:text>,</xsl:text><xsl:value-of select="$randomNumberBoxesY" /><xsl:text>){%
    \line(0,1){</xsl:text><xsl:value-of select="10 * number($randomNumberBoxHeight)" /><xsl:text>}%
  }
  \multiput(</xsl:text><xsl:value-of select="$combatRatioBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="$combatRatioBoxesBottomY" /><xsl:text>)(</xsl:text><xsl:value-of select="$combatRatioBoxWidth" /><xsl:text>,0){8}{%
    \line(0,1){</xsl:text><xsl:value-of select="2 * number($combatRatioBoxHeight) + 10 * number($randomNumberBoxHeight)" /><xsl:text>}%
  }
  \put(</xsl:text><xsl:value-of select="number($randomNumberBoxesRightX) + number($randomNumberBoxWidth)" /><xsl:text>,</xsl:text><xsl:value-of select="$randomNumberBoxesY" /><xsl:text>){%
    \line(0,1){</xsl:text><xsl:value-of select="10 * number($randomNumberBoxHeight)" /><xsl:text>}%
  }</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:text>  %% random numbers %%</xsl:text>
  <xsl:value-of select="$newline" />
  <!-- xsltproc does not understand select="1 to 10"; so we abuse the fact that the
       <tbody> element contains more than 10 <tr> elements. -->
  <xsl:for-each select="data/illustration/instance[@class='text']/table/tbody/tr">
    <xsl:if test="position() &lt; 11">
      <xsl:text>  \multiput(</xsl:text><xsl:value-of select="number($randomNumberBoxesLeftX) + number($randomNumberBoxWidth) div 2" /><xsl:text>,</xsl:text><xsl:value-of select="number($randomNumberBoxesY) + ( 10.5 - position() ) * number($randomNumberBoxHeight)" /><xsl:text>)(</xsl:text><xsl:value-of select="number($randomNumberBoxWidth) + 7 * number($resultBoxWidth)" /><xsl:text>,0){2}{\makebox(0,0){\bfseries </xsl:text><xsl:value-of select="position() mod 10" /><xsl:text>}}</xsl:text>
      <xsl:value-of select="$newline" />
    </xsl:if>
  </xsl:for-each>
  <xsl:value-of select="$newline" />

  <xsl:text>  %% combat ratios %%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:for-each select="exslt:node-set($colHeaders)/*">
    <xsl:text>  \multiput(</xsl:text><xsl:value-of select="number($combatRatioBoxesX) + ( position() - 0.5 ) * number($combatRatioBoxWidth)" /><xsl:text>,</xsl:text><xsl:value-of select="number($combatRatioBoxesBottomY) + number($combatRatioBoxHeight) div 2" /><xsl:text>)(0,</xsl:text><xsl:value-of select="10 * number($resultBoxHeight) + number($combatRatioBoxHeight)" /><xsl:text>){2}{%</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>    \makebox(0,0){</xsl:text><xsl:value-of select="." /><xsl:text>}%</xsl:text>
    <xsl:value-of select="$newline" />
    <xsl:text>  }</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:for-each>
  <xsl:value-of select="$newline" />

  <xsl:text>  %% E &amp; LW %%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>  \multiput(</xsl:text><xsl:value-of select="$resultBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="$resultBoxesY" /><xsl:text>)(0,</xsl:text><xsl:value-of select="$resultBoxHeight" /><xsl:text>){10}{%
    \multiput(0,0)(</xsl:text><xsl:value-of select="$resultBoxWidth" /><xsl:text>,0){7}{%
      \makebox(0,</xsl:text><xsl:value-of select="number($resultBoxHeight) div 2" /><xsl:text>)[l]{\footnotesize ~</xsl:text><xsl:value-of select="$i18n[@src='LW']" /><xsl:text>}%
    }%
  }
  \multiput(</xsl:text><xsl:value-of select="$resultBoxesX" /><xsl:text>,</xsl:text><xsl:value-of select="number($resultBoxesY) + number($resultBoxHeight) div 2" /><xsl:text>)(0,</xsl:text><xsl:value-of select="$resultBoxHeight" /><xsl:text>){10}{%
    \multiput(0,0)(</xsl:text><xsl:value-of select="$resultBoxWidth" /><xsl:text>,0){7}{%
      \makebox(0,</xsl:text><xsl:value-of select="number($resultBoxHeight) div 2" /><xsl:text>)[l]{\footnotesize ~</xsl:text><xsl:value-of select="$i18n[@src='E (abbr. of Enemy EP loss)']" /><xsl:text>}%
    }%
  }</xsl:text>
  <xsl:value-of select="$newparagraph" />

  <xsl:text>  %% losses %%</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:for-each select="data/illustration/instance[@class='text']/table/tbody/tr">
    <!-- the actual data is in row 3..12 -->
    <xsl:variable name="row" select="position() - 2" />
    <xsl:for-each select="./td">
      <xsl:if test="position() = 1">
        <xsl:text>  %% row </xsl:text><xsl:value-of select="$row" /><xsl:text> %%</xsl:text>
        <xsl:value-of select="$newline" />
      </xsl:if>
      <xsl:if test="position() &gt;= number($startCol) and position() &lt;= number($endCol)">
        <xsl:variable name="col" select="position() - number($startCol) + 1" />
        <xsl:variable name="losses"><xsl:value-of select="." /></xsl:variable>
        <xsl:variable name="lossE" select="substring-before($losses,'/')" />
        <xsl:text>  \put(</xsl:text><xsl:value-of select="number($resultBoxesX) + number($col) * number($resultBoxWidth)" /><xsl:text>,</xsl:text><xsl:value-of select="number($resultBoxesY) + ( 10.5 - number($row) ) * number($resultBoxHeight)" /><xsl:text>){\makebox(0,</xsl:text><xsl:value-of select="number($resultBoxHeight) div 2" /><xsl:text>)[r]{\footnotesize </xsl:text>
        <xsl:choose>
          <xsl:when test="$lossE='k'">
            <xsl:value-of select="$i18n[@src='K (abbr. of Automatic Kill)']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lossE" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>~}}</xsl:text>
        <xsl:value-of select="$newline" />
        <xsl:variable name="lossLW" select="substring-after($losses,'/')" />
        <xsl:text>  \put(</xsl:text><xsl:value-of select="number($resultBoxesX) + number($col) * number($resultBoxWidth)" /><xsl:text>,</xsl:text><xsl:value-of select="number($resultBoxesY) + ( 10 - number($row) ) * number($resultBoxHeight)" /><xsl:text>){\makebox(0,</xsl:text><xsl:value-of select="number($resultBoxHeight) div 2" /><xsl:text>)[r]{\footnotesize </xsl:text>
        <xsl:choose>
          <xsl:when test="$lossLW='k'">
            <xsl:text>K</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lossLW" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>~}}</xsl:text>
        <xsl:value-of select="$newline" />
      </xsl:if>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:text>\end{picture}
\end{center}
\vspace*{\stretch{1}}</xsl:text>
  <xsl:value-of select="$newline" />
  <xsl:text>\setlength{\unitlength}{1pt}</xsl:text>
  <xsl:value-of select="$newparagraph" />

</xsl:template>

</xsl:transform>
