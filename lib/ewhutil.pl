##---------------------------------------------------------------------------##
##  File:
##	@(#) ewhutil.pl 2.1 98/03/02 20:24:24
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##      Generic utility routines
##---------------------------------------------------------------------------##
##    Copyright (C) 1996-1998	Earl Hood, ehood@medusa.acs.uci.edu
##
##    This program is free software; you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation; either version 2 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program; if not, write to the Free Software
##    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
##    02111-1307, USA
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	Remove duplicates in an array.
##
sub remove_dups {
    local(*array) = shift;
    local(%dup);
    @array = grep($dup{$_}++ < 1, @array);
    %dup = ();
}

##---------------------------------------------------------------------------
##	numerically() is used to tell 'sort' to sort by numbers.
##
sub numerically {
    $a <=> $b;
}

##---------------------------------------------------------------------------
##	"Entify" special characters
##
sub htmlize {			# Older name
    local($txt) = $_[0];
    $txt =~ s/&/\&amp;/g; $txt =~ s/>/&gt;/g; $txt =~ s/</&lt;/g;
    $txt;
}
sub entify {			# Newer name
    local($txt) = $_[0];
    $txt =~ s/&/\&amp;/g; $txt =~ s/>/&gt;/g; $txt =~ s/</&lt;/g;
    $txt;
}
##	commentize entifies the  '-' character to avoid problems when a
##	string will be included in a comment declaration
sub commentize {
    local($txt) = $_[0];
    $txt =~ s/-/\&#45;/g;
    $txt;
}

##---------------------------------------------------------------------------
##	Copy a file.
##
sub cp {
    local($src, $dst) = @_;
    open(SRC, $src) || die("ERROR: Unable to open $src\n");
    open(DST, "> $dst") || die("ERROR: Unable to create $dst\n");
    print DST <SRC>;
    close(SRC);
    close(DST);
}

##---------------------------------------------------------------------------
##	Translate html string back to regular string
##
sub dehtmlize {
    local($str) = shift;
    $str =~ s/\&lt;/</g;
    $str =~ s/\&gt;/>/g;
    $str =~ s/\&amp;/\&/g;
    $str;
}

##---------------------------------------------------------------------------
##	Escape special characters in string for URL use.
##
sub urlize {
    local($url) = shift;
    $url =~ s/([^\w])/sprintf("%%%X",unpack("C",$1))/ge;
    $url;
}

##---------------------------------------------------------------------------##
1;
