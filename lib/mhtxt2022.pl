##---------------------------------------------------------------------------##
##  File:
##      mhtxt2022.pl
##  Author:
##      NIIBE Yutaka	gniibe@mri.co.jp
##	(adapted from mhtxtplain.pl by Earl Hood <ehood@isogen.com>)
##  Date:
##	Fri Jul 12 08:21:16 CDT 1996
##	Change: Escaped '@' in expression for use in Perl 5.
##		(1996/07/12, ehood@isogen.com)
##  Description:
##	Library defines routine to filter text/plain body parts that
##	use the ISO-2022 Japanese character sets into HTML for MHonArc.
##	Filter routine can be registered with the following:
##
##              <MIMEFILTERS>
##              text/plain:m2h_text_plain_iso2022'filter:mhtxt2022.pl
##              </MIMEFILTERS>
##
##	This will override the default text/plain filter used by
##	MHonArc.
##
##	Filter is based on the following RFCs:
##
##	RFC-1468 I
##		J. Murai, M. Crispin, E. van der Poel, "Japanese Character
##		Encoding for Internet Messages", 06/04/1993. (Pages=6)
##
##	RFC-1554  I
##		M. Ohta, K. Handa, "ISO-2022-JP-2: Multilingual Extension of  
##		ISO-2022-JP", 12/23/1993. (Pages=6)
##
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995	NIIBE Yutaka, gniibe@mri.co.jp
##				Earl Hood, ehood@isogen.com
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

package m2h_text_plain_iso2022;

$Url     = '(http://|ftp://|afs://|wais://|telnet://|gopher://|' .
            'news:|nntp:|mid:|cid:|mailto:|prospero:)';
$UrlExp  = $Url . q%[^\s\(\)\|<>"']*[^\.;,"'\|\[\]\(\)\s<>]%;
$HUrlExp = $Url . q%[^\s\(\)\|<>"'\&]*[^\.;,"'\|\[\]\(\)\s<>\&]%;

##---------------------------------------------------------------------------
##	Filter entitizes special characters, and converts URLs to
##	hyperlinks.
##
sub filter {
    local($header, *fields, *body) = @_;
    local(@data) = split(/\n/,$body);

    $ret = "<PRE>\n";
    for ($i = 0; $i <= $#data; $i++) {
        $_ = $data[$i];

	# Process preceding ASCII text
	while(1) {
	    if (/^[^\033]+/) {	# ASCII plain text
		$ascii_text = $&;
		$_ = $';

		# Replace meta characters in ASCII plain text
		$ascii_text =~ s%\&%\&amp;%g;
		$ascii_text =~ s%<%\&lt;%g;
		$ascii_text =~ s%>%\&gt;%g;
		## Convert URLs to hyperlinks
		$ascii_text =~ s%($HUrlExp)%<A HREF="$1">$1</A>%gio
		    unless $'NOURL;

		$ret .= $ascii_text;
	    } elsif (/\033\.[A-F]/) { # G2 Designate Sequence
		$_ = $';
		$ret .= $&;
	    } elsif (/\033N[ -]/) { # Single Shift Sequence
		$_ = $';
		$ret .= $&;
	    } else {
		last;
	    }
	}

	# Process Each Segment
	while(1) {
	    if (/^\033\([BJ]/) { # Single Byte Segment
		$_ = $';
		$ret .= $&;
		while(1) {
		    if (/^[^\033]+/) {	# ASCII plain text
			$ascii_text = $&;
			$_ = $';

			# Replace meta characters in ASCII plain text
			$ascii_text =~ s%\&%\&amp;%g;
			$ascii_text =~ s%<%\&lt;%g;
			$ascii_text =~ s%>%\&gt;%g;
			## Convert URLs to hyperlinks
			$ascii_text =~ s%($HUrlExp)%<A HREF="$1">$1</A>%gio
			    unless $'NOURL;

			$ret .= $ascii_text;
		    } elsif (/\033\.[A-F]/) { # G2 Designate Sequence
			$_ = $';
			$ret .= $&;
		    } elsif (/\033N[ -]/) { # Single Shift Sequence
			$_ = $';
			$ret .= $&;
		    } else {
			last;
		    }
		}
	    } elsif (/^\033\$[\@AB]|\033\$\([CD]/) { # Double Byte Segment
		$_ = $';
		$ret .= $&;
		while(1) {
		    if (/^([!-~][!-~])+/) { # Double Char plain text
			$_ = $';
			$ret .= $&;
		    } elsif (/\033\.[A-F]/) { # G2 Designate Sequence
			$_ = $';
			$ret .= $&;
		    } elsif (/\033N[ -]/) { # Single Shift Sequence
			$_ = $';
			$ret .= $&;
		    } else {
			last;
		    }
		}
	    } else {
		# Something wrong in text
		$ret .= $_;
		last;
	    }
	}

	$ret .= "\n";
    }

    $ret .= "</PRE>\n";

    ($ret);
}

1;
