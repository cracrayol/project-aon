#!/usr/local/bin/perl -w

( $bookPath, $textColor, $backgroundColor, $linkColor, $alinkColor ) = @ARGV;

open( CSSFILE, ">${bookPath}/main.css" ) or die( "Can\'t output to file: \"${bookPath}/main.css\"\n\t$!" );

print CSSFILE << "(END OF CSS)";
html, body {
 background-color: ${backgroundColor};
 color: ${textColor};
 font-family: Souvenir, Times, serif;
}

#footnotes {
 font-size: 0.8em;
}

p, ol, ul, dl, blockquote { text-align: justify }

ul.unbulleted { list-style-type: none }

b { font-weight: bold }

h1, h2, h3, h4, h5, h6 {
 margin-top: 0px;
 border: 0px none;
 padding: 0px;
 text-align: left;
}

:link:focus, :visited:focus { 
}

:link, :visited {
 background-color: transparent;
 color: ${linkColor};
/* text-decoration: none;*/
 font-weight: bold;
}

:link:hover, :visited:hover {
}

:link:active, :visited:active {
 background-color: transparent;
 color: ${alinkColor};
/* text-decoration: none;*/
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
 margin-left: 5%;
}

.smallcaps {
 font-size: 0.8em;
}

(END OF CSS)

close CSSFILE;
