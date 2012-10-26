#!/usr/bin/perl  -w
# This script recurses a directory and creates a similar structure
# but converting the files from a given format to a different one.
#
# This program is copyright 2009 by Javier Fernandez-Sanguino <jfs@debian.org>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# For more information please see
#  http://www.gnu.org/licenses/licenses.html#GPL


$oldformat="gif";
$newformat="png";
$sourcedir = `pwd`;
chomp($sourcedir);

convert_recurse_dir($sourcedir."/".$oldformat);
exit 0;

sub convert_recurse_dir ($) {
    my ($dir) = @_;
    my $DIRFH;
    print "Looking $dir\n";
    opendir $DIRFH, $dir || die ("Cannot open directory $dir: $!");

    while ( $file = readdir($DIRFH) ) {
        next if $file =~ /^\./; # Skip hidden files and directories
        $filename = $dir."/".$file;
        print "Checking $filename\n";
        if ( -d "$filename" ) {
            $newdir = $filename;
            $newdir =~ s/\/$oldformat\//\/$newformat\//;
            if ( ! -d "$newdir" ) {
                print "Creating $newdir\n";
                `mkdir $newdir`;
            }
            convert_recurse_dir($filename);
        } 
        if ( -f "$filename" ) {
            copy_file($filename);
        }
        print "Done with $filename\n";
    }
    closedir $DIRFH;
    return 0;
}

sub copy_file ($) {
    my ($file) = @_;
    $newfile = $file;
    $newfile =~ s/\/$oldformat\//\/$newformat\//;
    $newfile =~ s/\.$oldformat$/\.$newformat/;
    if ( ! -e "$newfile" ) {
        print "Converting $file to $newfile\n";
        `convert $file $newfile`;
    }
    return 0;
}

