##---------------------------------------------------------------------------##
##  File:
##      mhtxthtml.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	Library defines routine to filter text/html body parts
##	for MHarc.
##	Filter routine can be registered with the following:
##		<MIMEFILTERS>
##		text/html:m2h_text_html'filter:mhtxthtml.pl
##		</MIMEFILTERS>
##---------------------------------------------------------------------------##
##  Copyright (C) 1994  Earl Hood, ehood@convex.com
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##  
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
##---------------------------------------------------------------------------##

package m2h_text_html;

$Url     = '(http://|ftp://|afs://|wais://|telnet://|gopher://|' .
	    'news:|nntp:|mid:|cid:|mailto:|prospero:)';
$UrlExp = $Url . q%[^\s\(\)\|<>"']*[^\.;,"'\|\[\]\(\)\s<>]%;

##---------------------------------------------------------------------------
##	The filter must modify HTML content parts for merging into the
##	final filtered HTML messages.  Modification is needed so the
##	resulting filtered message is valid HTML.
##
sub filter {
    local($header, *fields, *data) = @_;
    local($base, $title, $tmp);

    ## Get/remove title
    if ($data =~ s%<title\s*>([^<]*)</title\s*>%%i) {
        $title = "<hr><address>$1</address><hr>\n";
    }
    ## Get/remove BASE url
    if ($data =~ s%(<base\s[^>]*>)%%i) {
        $tmp = $1;
        ($base) = $tmp =~ m%href\s*=\s*['"]([^'"]+)['"]%i;
        $base =~ s%(.*/).*%$1%;
    }
    ## Strip out certain elements/tags
    $data =~ s%<!doctype\s[^>]*>%%i;
    $data =~ s%</?html[^>]*>%%ig;
    $data =~ s%</?body[^>]*>%%ig;
    $data =~ s%<head\s*>[\s\S]*</head\s*>%%i;

    ## Modify relative urls to absolute using BASE
    if ($base !~ /^\s*$/) {
        $data =~ s%(href\s*=\s*['"])([^'"]+)(['"])%
                   $1 . &addbase($base,$2) . $3%gei;
        $data =~ s%(src\s*=\s*['"])([^'"]+)(['"])%
                   $1 . &addbase($base,$2) . $3%gei;
    }

    $title . $data;
}
##---------------------------------------------------------------------------
sub addbase {
    local($b, $u) = @_;
    local($ret);
    if ($u =~ m%$Url%o) {
        $ret = $u;
    } else {
        $ret = $b . $u;
    }
    $ret;
}
##---------------------------------------------------------------------------

1;
