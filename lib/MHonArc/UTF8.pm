##---------------------------------------------------------------------------##
##  File:
##	$Id: UTF8.pm,v 1.3 2002/07/30 05:10:30 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##  Description:
##	CHARSETCONVERTER module that support conversion to UTF-8 via
##	Unicode::MapUTF8 module.  It also requires versions of perl
##	that support 'use utf8' pragma.
##---------------------------------------------------------------------------##
##    Copyright (C) 2002	Earl Hood, earl@earlhood.com
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

package MHonArc::UTF8;

use strict;
use Unicode::String;
use Unicode::MapUTF8 qw(
    to_utf8 utf8_charset_alias utf8_supported_charset
);

BEGIN {
    utf8_charset_alias({ 'windows-1250' => 'cp1250' });
    utf8_charset_alias({ 'windows-1252' => 'cp1252' });
}

my %HTMLSpecials = (
    '"'	=> '&quot;',
    '&'	=> '&amp;',
    '<'	=> '&lt;',
    '>'	=> '&gt;',
);

sub entify {
    use utf8;
    my $str = shift;
    $str =~ s/(["&<>])/$HTMLSpecials{$1}/g;
    $str;
}

sub str2sgml{
    my $charset = lc($_[1]);
    my $str;

    if ($charset eq 'utf-8' || $charset eq 'utf8') {
	use utf8;
	($str = $_[0]) =~ s/(["&<>])/$HTMLSpecials{$1}/g;
	return $str;
    }

    if (utf8_supported_charset($charset)) {
	$str = to_utf8({-string => $_[0], -charset => $charset});
	{
	    use utf8;
	    $str =~ s/(["&<>])/$HTMLSpecials{$1}/g;
	}

    } else {
	warn qq/Warning: Unable to convert "$charset" to UTF-8\n/;
	($str = $_[0]) =~ s/(["&<>])/$HTMLSpecials{$1}/g;
    }
    $str;
}

sub clip {
    use utf8;
    my $str      = \shift;  # Prevent unnecessary copy.
    my $len      = shift;   # Clip length
    my $is_html  = shift;   # If entity references should be considered
    my $has_tags = shift;   # If html tags should be stripped

    my $u = Unicode::String::utf8($$str);

    if (!$is_html) {
      return $u->substr(0, $len);
    }

    my $text = Unicode::String::utf8("");
    my $subtext;
    my $html_len = $u->length;
    my($pos, $sublen, $erlen, $real_len);
    my $er_len = 0;
    
    for ( $pos=0, $sublen=$len; $pos < $html_len; ) {
	$subtext = $u->substr($pos, $sublen);
	$pos += $sublen;

	# strip tags
	if ($has_tags) {
	    # Strip full tags
	    $subtext =~ s/<[^>]*>//g;
	    # Check if clipped part of a tag
	    if ($subtext =~ s/<[^>]*\Z//) {
		my $gt = $u->index('>', $pos);
		$pos = ($gt < 0) ? $html_len : ($gt+1);
	    }
	}

	# check for clipped entity reference
	if (($pos < $html_len) && ($subtext =~ /\&[^;]*\Z/)) {
	    my $semi = $u->index(';', $pos);
	    if ($semi < 0) {
		# malformed entity reference
		$subtext .= $u->substr($pos);
		$pos = $html_len;
	    } else {
		$subtext .= $u->substr($pos, $semi-$pos+1);
		$pos = $semi+1;
	    }
	}

	# compute entity reference lengths to determine "real" character
	# count and not raw character count.
	while ($subtext =~ /(\&[^;]+);/g) {
	    $er_len += length($1);
	}

	$text .= $subtext;

	# done if we have enough
	$real_len = $text->length - $er_len;
	if ($real_len >= $len) {
	    last;
	}
	$sublen = $len - ($text->length - $er_len);
    }
    $text;
}

##---------------------------------------------------------------------------##
1;
__END__
