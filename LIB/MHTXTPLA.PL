##---------------------------------------------------------------------------##
##  File:
##      mhtxtplain.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	Library defines routine to filter text/plain body parts to HTML
##	for MHarc.
##	Filter routine can be registered with the following:
##              <MIMEFILTERS>
##              text/plain:m2h_text_plain'filter:mhtxtplain.pl
##              </MIMEFILTERS>
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

package m2h_text_plain;

$Url     = '(http://|ftp://|afs://|wais://|telnet://|gopher://|' .
            'news:|nntp:|mid:|cid:|mailto:|prospero:)';
$UrlExp  = $Url . q%[^\s\(\)\|<>"']*[^\.;,"'\|\[\]\(\)\s<>]%;
$HUrlExp = $Url . q%[^\s\(\)\|<>"'\&]*[^\.;,"'\|\[\]\(\)\s<>\&]%;

##---------------------------------------------------------------------------
##	Filter entitizes special characters, and converts URLs to
##	hyperlinks.
##
sub filter {
    local($header, *fields, *data) = @_;

    $data =~ s%\&%\&amp;%g;
    $data =~ s%<%\&lt;%g;
    $data =~ s%>%\&gt;%g;

    ## Convert URLs to hyperlinks (check $main'NOURL if this should be done)
    $data =~ s%($HUrlExp)%<A HREF="$1">$1</A>%gio  unless $'NOURL;
    "<PRE>\n" . $data . "</PRE>\n";
}

1;
