##---------------------------------------------------------------------------##
##  File:
##	@(#)  mhtxthtml.pl 1.1 96/09/17 @(#)
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##	Library defines routine to filter text/html body parts
##	for MHonArc.
##	Filter routine can be registered with the following:
##		<MIMEFILTERS>
##		text/html:m2h_text_html'filter:mhtxthtml.pl
##		</MIMEFILTERS>
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995	Earl Hood, ehood@medusa.acs.uci.edu
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
##    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
##---------------------------------------------------------------------------##


package m2h_text_html;

$Url	= '(\w+://|\w+:)';	# Beginning of URL match expression

##---------------------------------------------------------------------------
##	The filter must modify HTML content parts for merging into the
##	final filtered HTML messages.  Modification is needed so the
##	resulting filtered message is valid HTML.
##
sub filter {
    local($header, *fields, *data, $isdecode, $args) = @_;
    local($base, $title, $tmp);

    ## Get/remove title
    if ($data =~ s%<title\s*>([^<]*)</title\s*>%%i) {
        $title = "<ADDRESS>Title: <STRONG>$1</STRONG></ADDRESS>\n";
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
		   &addbase($base,$1,$2,$3)%gei;
        $data =~ s%(src\s*=\s*['"])([^'"]+)(['"])%
                   &addbase($base,$1,$2,$3)%gei;
    }

    ($title . $data);
}
##---------------------------------------------------------------------------
sub addbase {
    local($b, $pre, $u, $suf) = @_;
    local($ret);
    $u =~ s/^\s+//;
    if ($u =~ m%^$Url%o) {	# Non-relative URL, do nothing
        $ret = $pre . $u . $suf;
    } else {			# Relative URL
	if ($u =~ m%^/%) {		# Check for "/..."
	    $b =~ s%^(${Url}[^/]*)/.*%$1%o;	# Get hostname:port number
	}
        $ret = $pre . $b . $u . $suf;
    }
    $ret;
}
##---------------------------------------------------------------------------

1;
