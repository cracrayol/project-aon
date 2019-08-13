#!/usr/bin/perl -p
# Convert accented accents to character entities

s/á/\<ch.aacute\/\>/g;
s/é/\<ch.eacute\/\>/g;
s/í/\<ch.iacute\/\>/g;
s/ó/\<ch.oacute\/\>/g;
s/ú/\<ch.uacute\/\>/g;
s/ñ/\<ch.ntilde\/\>/g;
s/Á/\<ch.Aacute\/\>/g;
s/É/\<ch.Eacute\/\>/g;
s/Í/\<ch.Iacute\/\>/g;
s/Ó/\<ch.Oacute\/\>/g;
s/Ú/\<ch.Uacute\/\>/g;
s/ä/\<ch.auml\/\>/g;
s/ë/\<ch.euml\/\>/g;
s/ï/\<ch.iuml\/\>/g;
s/ö/\<ch.ouml\/\>/g;
s/ü/\<ch.uuml\/\>/g;
s/Ñ/\<ch.Ntilde\/\>/g;
s/´/\<ch.acute\/\>/g;
s/¡/\<ch.iexcl\/\>/g;
s/¿/\<ch.iquest\/\>/g;
s/«/\<ch.laquo\/\>/g;
s/»/\<ch.raquo\/\>/g;
#s/\&/\<ch.ampersand\/\>/g;

