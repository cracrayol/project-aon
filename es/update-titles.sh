#!/bin/sh -e

# Update title skins based on the gif files contributed 

for dir in gif/ls/*; do
    book=`basename $dir` 
    title_gif="gif/ls/${book}/skins/standard/title.gif"
    title_png="png/ls/${book}/skins/standard/title.png"
    if [ -e "$title_gif" ] ; then
        echo "Book $book - updating PNG title with GIF version"
        convert "$title_gif" "$title_png"
    fi
done
