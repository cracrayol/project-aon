
This directory contains the rules to convert Gamebook XML files to the
Gettext (PO files) so that they can be translated using standard translator's
tools (such as GNU gettext tools and those available in the translate toolkit at
https://toolkit.translatehouse.org/download.html)


The files included in this directory are:

    - gamebook.its: the rule file to create the XML based on the Internationalization Tag Set standard (ITS, https://www.w3.org/TR/its20/).
    
    - gamebook.loc: the locating rule that associates its with XML

For more information see: https://www.gnu.org/software/gettext/manual/gettext.html#Preparing-ITS-Rules

To convert to/from PO the 'itstool' program is used (see http://itstool.org/)

These rules are provided in order to simplify:

 - The creation of new translations of books which are part of Project Aon
 - The update of existing translations of books 
 - To make it possible for translators to keep a glossary of translators,
   simplifying the creation of new translations


More information about the gettext format is available in https://www.gnu.org/software/gettext/manual/gettext.html

