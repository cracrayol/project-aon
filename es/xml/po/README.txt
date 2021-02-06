
¡WARNING! This content is still experimental and needs to be automated. The
files here are not yet ready for production use.
-----------------------------------------------------------------------------------


This directory contains the translations of Lone Wolf gamebooks in PO format.
This format can be used to create and maintain translations, making it
possible to easily detect when the original English XML file has changed
and make the corresponding translations.

PO files are also a standard format that can be used to provide content
to be translated using services such as Pootle
(https://pootle.translatehouse.org/) 

The PO files in this directory can be used to generate a XML file of the
specific language doing the following:


   msgfmt AONDIR/<language>/xml/po/<gamebook>.po -o AONDIR/<language>/xml/po/<gamebook>.mo
   [ Creates a binary MO file, required to convert back to XML ]

  itstool -m AONDIR/<language>/xml/po/<gamebook>.mo -o \
      AONDIR/<language>/xml/po/ AONDIR/en/xml/<gamebook>.xml

    NOTE: The exact name of the gamebook can change across languages so the 
    <gamebook> tag above is not the same content.



