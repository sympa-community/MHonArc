##---------------------------------------------------------------------------##
##  File:
##	$Id: mhtxtplain.pl,v 2.22 2002/07/20 03:07:35 ehood Exp $
##  Author:
##      Earl Hood       mhonarc@mhonarc.org
##  Description:
##	Library defines routine to filter text/plain body parts to HTML
##	for MHonArc.
##	Filter routine can be registered with the following:
##              <MIMEFILTERS>
##              text/plain:m2h_text_plain'filter:mhtxtplain.pl
##              </MIMEFILTERS>
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-2001	Earl Hood, mhonarc@mhonarc.org
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

package m2h_text_plain;

require 'readmail.pl';

$Url    	= '(http://|https://|ftp://|afs://|wais://|telnet://|ldap://' .
		   '|gopher://|news:|nntp:|mid:|cid:|mailto:|prospero:)';
$UrlExp 	= $Url . q/[^\s\(\)\|<>"']*[^\.?!;,"'\|\[\]\(\)\s<>]/;
$HUrlExp        = $Url . q/(?:&(?![gl]t;)|[^\s\(\)\|<>"'\&])+/ .
			 q/[^\.?!;,"'\|\[\]\(\)\s<>\&]/;
$QuoteChars	= '[>\|\]+:]';
$HQuoteChars	= '&gt;|[\|\]+:]';

$StartFlowedQuote =
  '<blockquote style="border-left: #0000FF solid 0.1em; '.
                     'margin-left: 0.0em; padding-left: 1.0em">';
$EndFlowedQuote   = "</blockquote>";

##---------------------------------------------------------------------------##
##	Text/plain filter for mhonarc.  The following filter arguments
##	are recognized ($args):
##
##	asis=set1:set2:...
##			Colon separated lists of charsets to leave as-is.
##			Only HTML special characters will be converted into
##			entities.  The default value is "us-ascii:iso-8859-1".
##
##	attachcheck	Honor attachment disposition.  By default,
##			all text/plain data is displayed inline on
##			the message page.  If attachcheck is specified
##			and Content-Disposition specifies the data as
##			an attachment, the data is saved to a file
##			with a link to it from the message page.
##
##	default=set 	Default charset to use if not set.
##
##      inlineexts="ext1,ext2,..."
##                      A comma separated list of message specified filename
##                      extensions to treat as inline data.
##                      Applicable only when uudecode options specified.
##
##	htmlcheck	Check if message is actually an HTML message
##			(to get around abhorrent MUAs).  The message
##			is treated as HTML if the first non-whitespace
##			data looks like the start of an HTML document.
##
##	keepspace	Preserve whitespace if nonfixed
##
##	nourl		Do hyperlink URLs
##
##	nonfixed	Use normal typeface
##
##	maxwidth=#	Set the maximum width of lines.  Lines exceeding
##			the maxwidth will be broken up across multiple lines.
##
##	quote		Italicize quoted message text
##
##	target=name  	Set TARGET attribute for links if converting URLs
##			to links.  Defaults to _top.
##
##	usename		Use filename specified in uuencoded data when
##			converting uuencoded data.  This option is only
##			applicable of uudecode is specified.
##
##	uudecode	Decoded any embedded uuencoded data.
##
##	All arguments should be separated by at least one space
##
sub filter {
    my($fields, $data, $isdecode, $args) = @_;
    local($_);

    ## Parse arguments
    $args	= ""  unless defined($args);

    ## Check if content-disposition should be checked
    if ($args =~ /\battachcheck\b/i) {
	my($disp, $nameparm) = readmail::MAILhead_get_disposition($fields);
	if ($disp =~ /\battachment\b/i) {
	    require 'mhexternal.pl';
	    return (m2h_external::filter(
		      $fields, $data, $isdecode,
		      readmail::get_filter_args('m2h_external::filter')));
	}
    }

    ## Check if decoding uuencoded data.  The implementation chosen here
    ## for decoding uuencoded data was done so when uudecode is not
    ## specified, there is no extra overhead (besides the $args check for
    ## uudecode).  However, when uudecode is specified, more overhead may
    ## exist over other potential implementations.
    ## I.e.  We only try to penalize performance when uudecode is specified.
    if ($args =~ s/\buudecode\b//ig) {
	# $args has uudecode stripped out for recursive calls

	# Make sure we have needed routines
	my $decoder = readmail::load_decoder("uuencode");
	if (!defined($decoder) || !defined(&$decoder)) {
	    require 'base64.pl';
	    $decoder = \&base64::uudecode;
	}
	require 'mhmimetypes.pl';

	# Grab any filename extensions that imply inlining
	my $inlineexts = '';
	if ($args =~ /\binlineexts=(\S+)/) {
	    $inlineexts = ',' . lc($1) . ',';
	    $inlineexts =~ s/['"]//g;
	}
	my $usename = $args =~ /\busename\b/;

	my($pdata);	# have to use local() since typeglobs used
	my($inext, $uddata, $file, $urlfile);
	my @files = ( );
	my $ret = "";
	my $i = 0;

	# <CR><LF> => <LF> to make parsing easier
	$$data =~ s/\r\n/\n/g;

	# Split on uuencoded data.  For text portions, recursively call
	# filter to convert text data: makes it easier to handle all
	# the various formatting options.
	foreach $pdata
		(split(/^(begin\s+\d\d\d\s+[^\n]+\n[!-M].*?\nend\n)/sm,
		       $$data)) {
	    if ($i % 2) {	# uuencoded data
		# extract filename extension
		($file) = $pdata =~ /^begin\s+\d\d\d\s+([^\n]+)/;
		if ($file =~ /\.(\w+)$/) { $inext = $1; } else { $inext = ""; }

		# decode data
		$uddata = &$decoder($pdata);

		# save to file
		if (readmail::MAILis_excluded('application/octet-stream')) {
		    $ret .= &$readmail::ExcludedPartFunc($file);
		} else {
		    push(@files,
			 mhonarc::write_attachment(
			    'application/octet-stream', \$uddata, '',
			    ($usename?$file:''), $inext));
		    $urlfile = mhonarc::htmlize($files[$#files]);

		    # create link to file
		    if (index($inlineexts, ','.lc($inext).',') >= $[) {
			$ret .= qq|<a href="$urlfile"><img src="$urlfile">| .
				qq|</a><br>\n|;
		    } else {
			$ret .= qq|<a href="$urlfile">| .
				mhonarc::htmlize($file) .  qq|</a><br>\n|;
		    }
		}

	    } elsif ($pdata =~ /\S/) {	# plain text
		my(@subret) = filter($fields, \$pdata, $isdecode, $args);
		$ret .= shift @subret;
		push(@files, @subret);
	    } else {
		# Make sure readmail thinks we processed
		$ret .= " ";
	    }
	    ++$i;
	}

	## Done with uudecode
	return ($ret, @files);
    }

    
    ## Check for HTML data if requested
    if ($args =~ s/\bhtmlcheck\b//i &&
	    $$data =~ /\A\s*<(?:html\b|x-html\b|!doctype\s+html\s)/i) {
	if (readmail::MAILis_excluded('text/html')) {
	  return (&$readmail::ExcludedPartFunc('text/plain HTML'));
	}
	my $html_filter = readmail::load_filter('text/html');
	if (defined($html_filter) && defined(&$html_filter)) {
	    return (&$html_filter($fields, $data, $isdecode, $args));
	} else {
	    require 'mhtxthtml.pl';
	    return (m2h_text_html::filter($fields, $data, $isdecode, $args));
	}
    }

    my($charset, $nourl, $doquote, $igncharset, $nonfixed, $textformat,
       $keepspace, $maxwidth, $target, $defset, $xhtml);
    my(%asis) = (
	'us-ascii'   => 1,
	'iso-8859-1' => 1,
    );

    $nourl	= ($mhonarc::NOURL || ($args =~ /\bnourl\b/i));
    $doquote	= ($args =~ /\bquote\b/i);
    $nonfixed	= ($args =~ /\bnonfixed\b/i);
    $keepspace	= ($args =~ /\bkeepspace\b/i);
    if ($args =~ /\bmaxwidth=(\d+)/i) { $maxwidth = $1; }
	else { $maxwidth = 0; }
    if ($args =~ /\bdefault=(\S+)/i) { $defset = lc $1; }
	else { $defset = 'us-ascii'; }
    $target = "";
    if ($args =~ /\btarget="([^"]+)"/i) { $target = $1; }
	elsif ($args =~ /\btarget=(\S+)/i) { $target = $1; }
    $target =~ s/['"]//g;
    if ($target) {
	$target = qq/target="$target"/;
    }
    $defset =~ s/['"\s]//g;

    ## Grab charset parameter (if defined)
    if ( defined($fields->{'content-type'}[0]) and
	 $fields->{'content-type'}[0] =~ /\bcharset\s*=\s*([^\s;]+)/i ) {
	$charset = lc $1;
	$charset =~ s/['";\s]//g;
    } else {
	$charset = $defset;
    }
    ## Grab format parameter (if defined)
    if ( defined($fields->{'content-type'}[0]) and
	 $fields->{'content-type'}[0] =~ /\bformat\s*=\s*([^\s;]+)/i ) {
	$textformat = lc $1;
	$textformat =~ s/['";\s]//g;
    } else {
	$textformat = "fixed";
    }

    ## Check if certain charsets should be left alone
    if ($args =~ /\basis=(\S+)/i) {
	my $t = lc $1;  $t =~ s/['"]//g;
	%asis = ('us-ascii' => 1);  # XXX: Should us-ascii always be "as-is"?
	local($_);  foreach (split(':', $t)) { $asis{$_} = 1; }
    }

    ## Check MIMECharSetConverters if charset should be left alone
    my $charcnv = &readmail::load_charset($charset);
    if (!defined($charcnv)) {
      $charcnv = &readmail::load_charset('default');
    }
    if (defined($charcnv) && $charcnv eq '-decode-') {
	$asis{$charset} = 1;
    }

    ## Check if max-width set
    if ($maxwidth && $textformat eq 'fixed') {
	$$data =~ s/^(.*)$/&break_line($1, $maxwidth)/gem;
    }

    ## Convert data according to charset
    if (!$asis{$charset}) {
	# Registered in CHARSETCONVERTERS
	if (defined($charcnv) && defined(&$charcnv)) {
	    $$data = &$charcnv($$data, $charset);

	# Other
	} else {
	    warn qq/\n/,
		 qq/Warning: Unrecognized character set: $charset\n/,
		 qq/         Message-Id: <$mhonarc::MHAmsgid>\n/,
		 qq/         Message Number: $mhonarc::MHAmsgnum\n/;
	    esc_chars_inplace($data);
	}

    } else {
	esc_chars_inplace($data);
    }

    if ($textformat eq 'flowed') {
	# Initial code for format=flowed contributed by Ken Hirsch (May 2002).
	# text/plain; format=flowed defined in RFC2646

	my $currdepth = 0;
	my $ret='';
	s!^</?x-flowed>\r?\n>!!mg; # we don't know why Eudora puts these in
	while (length($$data)) {
	    $$data =~ /^((?:&gt;)*)/;
	    my $qd = $1;
	    if ($$data =~ s/^(.*(?:(?:\n|\r\n?)$qd(?!&gt;).*)*\n?)//) {
		# divide message into chunks by "quote-depth",
		# which is the number of leading > signs
		my $chunk = $1;
		$chunk =~ s/^$qd ?//mg;  # N.B. also takes care of
					 # space-stuffing
		$chunk =~ s/^-- $/--/mg; # special case for '-- '

		if ($chunk =~ / \r?\n/) {
		    # Treat this chunk as format=flowed
		    # Lines that end with spaces are
		    # considered to have soft line breaks.
		    # Lines that end with no spaces are
		    # considered to have hard line breaks.
		    # XXX: Negative look-behind assertion not supported
		    #	   on older versions of Perl 5 (<5.6)
		    #$chunk =~ s/(?<! )(\r?\n|\Z)/<br>$1/g;
		    $chunk =~ s/(^|[^ ])(\r?\n|\Z)/$1<br>$2/mg;

		} else {
		    # Treat this chunk as format=fixed
		    if ($nonfixed) {
			$chunk =~ s/(\r?\n)/<br>$1/g;
			if ($keepspace) {
			    $chunk =~ s/^(.*)$/&preserve_space($1)/gem;
			}
		    } else {
			$chunk = "<pre>" . $chunk . "</pre>\n";
		    }
		}
		my $newdepth = length($qd)/length('&gt;');
		if ($currdepth < $newdepth) {
		    $chunk = $StartFlowedQuote x
			     ($newdepth - $currdepth) . $chunk;
		} elsif ($currdepth > $newdepth) {
		    $chunk = $EndFlowedQuote x
			     ($currdepth - $newdepth) . $chunk;
		}
		$currdepth = $newdepth;
		$ret .= $chunk;

	    } else {
		# The above regex should always match, but just in case...
		warn qq/\n/,
		     qq/Warning: Dequoting problem with format=flowed data\n/,
		     qq/         Message-Id: <$MHAmsgid>\n/,
		     qq/         Message Number: $MHAmsgnum\n/;
		$ret .= $$data;
		last;
	    }
	}
	if ($currdepth > 0) {
	    $ret .= $EndFlowedQuote x $currdepth;
	}

	## Post-processing cleanup: makes things look nicer
	$ret =~ s/<br><\/blockquote>/<\/blockquote>/g;
	$ret =~ s/<\/blockquote><br>/<\/blockquote>/g;

	$$data = $ret;

    } else {
	## Check for quoting
	if ($doquote) {
	    $$data =~ s@^( ?${HQuoteChars})(.*)$@$1<i>$2</i>@gom;
	}

	## Check if using nonfixed font
	if ($nonfixed) {
	    $$data =~ s/(\r?\n)/<br>$1/g;
	    if ($keepspace) {
		$$data =~ s/^(.*)$/&preserve_space($1)/gem;
	    }
	} else {
	    $$data = "<pre>" . $$data . "</pre>\n";
	}
    }

    ## Convert URLs to hyperlinks
    $$data =~ s@($HUrlExp)@<a $target href="$1">$1</a>@gio
	unless $nourl;

    ($$data);
}

##---------------------------------------------------------------------------##

sub esc_chars_inplace {
    my($foo) = shift;
    $$foo =~ s/&/&amp;/g;
    $$foo =~ s/</&lt;/g;
    $$foo =~ s/>/&gt;/g;
    $$foo =~ s/"/&quot;/g;
    1;
}

##---------------------------------------------------------------------------##

sub preserve_space {
    my($str) = shift;

    1 while
    $str =~ s/^([^\t]*)(\t+)/$1 . ' ' x (length($2) * 8 - length($1) % 8)/e;
    $str =~ s/ /\&nbsp;/g;
    $str;
}

##---------------------------------------------------------------------------##

sub break_line {
    my($str) = shift;
    my($width) = shift;
    my($q, $new) = ('', '');
    my($try, $trywidth, $len);

    ## Translate tabs to spaces
    1 while
    $str =~ s/^([^\t]*)(\t+)/$1 . ' ' x (length($2) * 8 - length($1) % 8)/e;

    ## Do nothing if str <= width
    return $str  if length($str) <= $width;

    ## See if str begins with a quote char
    if ($str =~ s/^( ?$QuoteChars)//o) {
	$q = $1;
	--$width;
    }

    ## Create new string by breaking up str
    while ($str ne "") {

	# If $str less than width, break out
	if (length($str) <= $width) {
	    $new .= $q . $str;
	    last;
	}

	# handle case where no-whitespace line larger than width
	if (($str =~ /^(\S+)/) && (($len = length($1)) >= $width)) {
	    $new .= $q . $1;
	    substr($str, 0, $len) = "";
	    next;
	}

	# Break string at whitespace
	$try = '';
	$trywidth = $width;
	$try = substr($str, 0, $trywidth);
	if ($try =~ /(\S+)$/) {
	    $trywidth -= length($1);
	    $new .= $q . substr($str, 0, $trywidth);
	} else {
	    $new .= $q . $try;
	}
	substr($str, 0, $trywidth) = '';

    } continue {
	$new .= "\n"  if $str;
    }
    $new;
}

##---------------------------------------------------------------------------##
1;
