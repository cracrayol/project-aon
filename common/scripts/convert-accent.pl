#!/usr/bin/perl -p
# Convert accented accents to character entities

s/�/\<ch.aacute\/\>/g;
s/�/\<ch.eacute\/\>/g;
s/�/\<ch.iacute\/\>/g;
s/�/\<ch.oacute\/\>/g;
s/�/\<ch.uacute\/\>/g;
s/�/\<ch.ntilde\/\>/g;
s/�/\<ch.Aacute\/\>/g;
s/�/\<ch.Eacute\/\>/g;
s/�/\<ch.Iacute\/\>/g;
s/�/\<ch.Oacute\/\>/g;
s/�/\<ch.Uacute\/\>/g;
s/�/\<ch.auml\/\>/g;
s/�/\<ch.euml\/\>/g;
s/�/\<ch.iuml\/\>/g;
s/�/\<ch.ouml\/\>/g;
s/�/\<ch.uuml\/\>/g;
s/�/\<ch.Ntilde\/\>/g;
s/�/\<ch.acute\/\>/g;
s/�/\<ch.iexcl\/\>/g;
s/�/\<ch.iquest\/\>/g;
s/�/\<ch.laquo\/\>/g;
s/�/\<ch.raquo\/\>/g;
#s/\&/\<ch.ampersand\/\>/g;

