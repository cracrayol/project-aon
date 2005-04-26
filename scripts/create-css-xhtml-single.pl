#!/usr/local/bin/perl -w

# See the following about font-size-adjust:
# http://www.w3.org/TR/REC-CSS2/fonts.html#font-size-props

#"Verdana, Arial, Helvetica", "Georgia, Times New Roman, Times", "Courier New, Courier". 

#Commonly-installed typefaces on Macs and PCs
# (Windows then Mac)
#
# Serif:
#  Georgia
#  MS Serif
#  Book Antiqua
#  Times New Roman 
#
#  Georgia*
#  New York
#  Palatino
#  Times  
#
# Sans-serif:
#  Verdana
#  MS Sans Serif
#  Arial
#  Trebuchet
#
#  Verdana*
#  Geneva
#  Helvetica
#  Chicago 
#
# Monospace:
#  Courier New
#  Courier 

( $bookPath, $textColor, $backgroundColor, $scrollbarBaseColor, $scrollbarTrackColor, $scrollbarArrowColor, $linkColor, $alinkColor, $hlinkBackgroundColor, $hlinkColor ) = @ARGV;

open( CSSFILE, ">${bookPath}/main.css" ) or die( "Can\'t output to file: \"${bookPath}/main.css\"\n\t$!" );

print CSSFILE << "(END OF CSS)";
html {
 /* scrollbar properties are currently IE specific (24 Aug 2002) */
 scrollbar-base-color: ${scrollbarBaseColor};
 scrollbar-track-color: ${scrollbarTrackColor};
 scrollbar-arrow-color: ${scrollbarArrowColor};
}

html, body {
 background-color: ${backgroundColor};
 color: ${textColor};
 font-family: Souvenir, Georgia, "Times New Roman", Times, serif;
}

#footnotes {
 font-size: 0.8em;
}

hr { margin-left: 0px; }

ul.unbulleted { list-style-type: none }
/* ul { list-style-type: none } */

b { font-weight: bold }

h1, h2, h3, h4, h5, h6 {
 margin-top: 0px;
 border: 0px none;
 padding: 0px;
 text-align: left;
}

div.numbered h3 {
 text-align: center;
}

div.glossary h3 {
 text-align: center;
}

:link:focus, :visited:focus { 
}

:link, :visited {
 background-color: transparent;
 color: ${linkColor};
 text-decoration: none;
 font-weight: bold;
}

:link:hover, :visited:hover {
 background-color: ${hlinkBackgroundColor};
 color: ${hlinkColor};
 text-decoration: none;
 font-weight: bold;
}

:link:active, :visited:active {
 background-color: transparent;
 color: ${alinkColor};
 text-decoration: none;
 font-weight: bold;
}

dt {
 font-weight: bold;
}

.navigation, .signpost, .illustraion, .caption, .center {
 text-align: center;
}

.author {
 text-align: center;
 font-weight: bold;
}

.dedication { 
 text-align: center;
 font-style: italic;
 font-weight: bold;
 margin-top: 15ex;
 margin-bottom: 15ex;
}

.copyright {
 text-align: center;
 font-style: italic;
}

.choice, .combat {
 text-align: left;
 margin-left: 15px;
}

.smallcaps {
 font-size: 0.8em;
}

(END OF CSS)

close CSSFILE;
