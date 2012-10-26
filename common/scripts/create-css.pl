#!/usr/bin/perl -w

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

#( $bookPath, $textColor, $backgroundColor, $scrollbarBaseColor, $scrollbarTrackColor, $scrollbarArrowColor, $linkColor, $alinkColor, $hlinkBackgroundColor, $hlinkColor, $hlinkLightBorderColor, $hlinkDarkBorderColor ) = @ARGV;

( $bookPath, $textColor, $backgroundColor, $linkColor, $alinkColor, $hlinkBackgroundColor, $hlinkColor ) = @ARGV;

open( CSSFILE, ">${bookPath}/main.css" ) or die( "Can\'t output to file: \"${bookPath}/main.css\"\n\t$!" );

print CSSFILE << "(END OF CSS)";
\@import url( more.css );

html, body {
 background-color: ${backgroundColor};
 color: ${textColor};
 font-family: Souvenir, Georgia, "Times New Roman", Times, serif;
}

#title {
 position: absolute;
 top: 0px;
 left: 0px;
 width: 550px;
 height: 100px;
 padding: 0px;
 border: 0px none;
 margin: 0px;
}

#body {
 position: absolute;
 top: 95px;
 left: 100px;
 width: 450px;
 padding: 0px;
 border: 0px none;
 margin: 0px;
}

#footnotes {
 font-size: 0.8em;
}

hr { margin-left: 0px; }

p, ol, ul, dl, blockquote { text-align: justify }

ul.unbulleted { list-style-type: none }

b { font-weight: bold }

h1, h2, h3, h4, h5, h6 {
 margin-top: 0px;
 border: 0px none;
 padding: 0px;
 clear: left;
 text-align: left;
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

.navigation :link:hover, .navigation :visited:hover {
 background-color: transparent;
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

.signpost {
 padding-top: 0.5em;
 padding-bottom: 0.5em;
 line-height: 1.5em;
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
 width: 435px;
}

.smallcaps {
 font-size: 0.8em;
}

ul .illustration { margin-left: -2.5em; }
(END OF CSS)

close CSSFILE;

open( CSSFILE, ">${bookPath}/more.css" ) or die( "Can\'t output to file: \"${bookPath}/more.css\"\n\t$!" );

print CSSFILE << "(END OF MORE CSS)";
p {
  padding-top: 1px;
  padding-bottom: 1px;
}

div.numbered h3 {
 position: absolute;
 top: -56px;
 left: 404px;
 width: 39px;
 height: 18pt;
 margin: 0px;
 border: 0px none;
 padding: 0px;
 font-size: 14pt;
 background-color: transparent;
 text-align: center;
 vertical-align: middle;
}

div.glossary h3 {
 position: absolute;
 top: -56px;
 left: 404px;
 width: 39px;
 height: 18pt;
 margin: 0px;
 border: 0px none;
 padding: 0px;
 font-size: 14pt;
 background-color: transparent;
 text-align: center;
 vertical-align: middle;
}

img.accent {
  margin-top: 5px;
  margin-right: 10px;
  margin-bottom: 5px;
}
(END OF MORE CSS)

close CSSFILE;
