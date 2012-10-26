#!/usr/bin/perl -p
# Convert character entities to accented accents 

s/\<ch.aacute\/\>/á/g;
s/\<ch.eacute\/\>/é/g;
s/\<ch.iacute\/\>/í/g;
s/\<ch.oacute\/\>/ó/g;
s/\<ch.uacute\/\>/ú/g;
s/\<ch.ntilde\/\>/ñ/g;
s/\<ch.Aacute\/\>/Á/g;
s/\<ch.Eacute\/\>/É/g;
s/\<ch.Iacute\/\>/Í/g;
s/\<ch.Oacute\/\>/Ó/g;
s/\<ch.Uacute\/\>/Ú/g;
s/\<ch.auml\/\>/ä/g;
s/\<ch.euml\/\>/ë/g;
s/\<ch.iuml\/\>/ï/g;
s/\<ch.ouml\/\>/ö/g;
s/\<ch.uuml\/\>/ü/g;
s/\<ch.Ntilde\/\>/Ñ/g;
s/\<ch.acute\/\>/´/g;
s/\<ch.iexcl\/\>/¡/g;
s/\<ch.iquest\/\>/¿/g;
s/\<ch.laquo\/\>/«/g;
s/\<ch.raquo\/\>/»/g;
#s/\&/\<ch.ampersand\/\>/g;

