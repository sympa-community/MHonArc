##---------------------------------------------------------------------------##
##  File:
##	@(#) mhexternal.pl 2.8 01/04/10 21:36:40
##  Author:
##      Earl Hood       mhonarc@pobox.com
##  Description:
##	Library defines a routine for MHonArc to filter content-types
##	that cannot be directly filtered into HTML, but a linked to an
##	external file.
##
##	Filter routine can be registered with the following:
##
##		<MIMEFILTERS>
##		*/*:m2h_external'filter:mhexternal.pl
##		</MIMEFILTERS>
##
##	Where '*/*' represents various content-types.  See code below for
##	all types supported.
##
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-1999	Earl Hood, mhonarc@pobox.com
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

package m2h_external;

##---------------------------------------------------------------------------
##	Filter routine.
##
##	Argument string may contain the following values.  Each value
##	should be separated by a space:
##
##	excludeexts="ext1,ext2,..."
##			A comma separated list of message specified filename
##			extensions to exclude.  I.e.  If the filename
##			extension matches an extension in excludeexts,
##			the content will not be written.  The return
##			markup will contain the name of the attachment,
##			but no link to the data.  This option is best
##			used with application/octet-stream to exclude
##			unwanted data that is not tagged with the proper
##			content-type.  The m2h_null::filter can be used
##			to exclude content by content-type.
##
##			Applicable when content-type not image/* and
##			usename or usenameext is in effect.
##
##	ext=ext 	Use `ext' as the filename extension.
##
##	forceattach 	Never inline image data.
##
##	forceinline 	Inline image data, always
##
##	iconurl="url"	Use "url" for location of icon to use.
##
##	inline  	Inline image data by default if
##			content-disposition not defined.
##
##	inlineexts="ext1,ext2,..."
##			A comma separated list of message specified filename
##			extensions to treat as possible inline data.
##			Applicable when content-type not image/* and
##			usename or usenameext is in effect.
##
##	subdir		Place derived files in a subdirectory
##
##      target=name     Set TARGET attribute for anchor link to file.
##			Defaults to not defined.
##
##	type="description"
##			Use "description" as type description of the
##			data.  The double quotes are required.
##
##	useicon		Include an icon as part of the link to the
##			extracted file.  Url for icon is obtained
##			ICONS resource or from the iconurl option.
##
##	usename 	Use (file)name attribute for determining name
##			of derived file.  Use this option with caution
##			since it can lead to filename conflicts and
##			security problems.
##
##	usenameext 	Use (file)name attribute for determining the
##			extension for the derived file.  Use this option
##			with caution since it can lead to security
##			problems.
##
sub filter {
    local($header, *fields, *data, $isdecode, $args) = @_;
    my($ret, $filename, $urlfile, $disp);
    require 'mhmimetypes.pl';

    ## Init variables
    $args	   = ''  unless defined($args);
    my $name	   = '';
    my $nameparm   = '';
    my $ctype	   = '';
    my $type	   = '';
    my $ext	   = '';
    my $inline	   =  0;
    my $inext	   = '';
    my $intype	   = '';
    my $iconurl	   = '';
    my $icon_mu	   = '';
    my $target	   = '';
    my $path       = '';
    my $subdir     = $args =~ /\bsubdir\b/i;
    my $usename    = $args =~ /\busename\b/i;
    my $usenameext = $args =~ /\busenameext\b/i;
    my $debug      = $args =~ /\bdebug\b/i;
    my $inlineexts = '';
    my $excexts    = '';
    if ($args =~ /\binlineexts=(\S+)/) {
	$inlineexts = join("", ',', lc($1), ',');
	$inlineexts =~ s/['"]//g;
    }
    if ($args =~ /\bexcludeexts=(\S+)/) {
	$excexts = join("", ',', lc($1), ',');
	$excexts =~ s/['"]//g;
	&debug("Exclude extensions: $excexts") if $debug;
    }

    ## Get content-type
    ($ctype) = $fields{'content-type'} =~ m%^\s*([\w\-\./]+)%;
    $ctype =~ tr/A-Z/a-z/;
    $type = (mhonarc::get_mime_ext($ctype))[1];

    ## Get disposition
    ($disp, $nameparm) = &readmail::MAILhead_get_disposition(*fields);
    $name = $nameparm  if $usename;
    &debug("Content-type: $ctype",
	   "Disposition: $disp; filename=$nameparm",
	   "Arg-string: $args")  if $debug;

    ## Get filename extension in disposition
    my $dispext = '';
    if ($nameparm && ($nameparm !~ /^\./) && ($nameparm =~ /\.(\w+)$/)) {
      $dispext = lc $1;
      &debug("Disposition filename extension: $dispext") if $debug;
    }

    ## Check if content is excluded based on filename extension
    if ($excexts && index($excexts, ",$dispext,") >= $[) {
      return (qq|<p><tt>&lt&lt;attachment: $nameparm&gt;&gt;</tt></p>\n|);
    }

    ## Check if file goes in a subdirectory
    $path = join('', $mhonarc::MsgPrefix, $mhonarc::MHAmsgnum)
	if $subdir;

    ## Check if extension and type description passed in
    if ($args =~ /\bext=(\S+)/i)      { $inext  = $1;  $inext =~ s/['"]//g; }
    if ($args =~ /\btype="([^"]+)"/i) { $intype = $1; }

    ## Check if utilizing extension from mail header defined filename
    if ($dispext && $usenameext) {
	$inext = $1;
    }

    ## Check if inlining (images only)
    INLINESW: {
	if ($args =~ /\bforceattach\b/i) {
	    $inline = 0;
	    last INLINESW;
	}
	if ($args =~ /\bforceinline\b/i) {
	    $inline = 1;
	    last INLINESW;
	}
	if ($disp) {
	    $inline = ($disp =~ /\binline\b/i);
	    last INLINESW;
	}
	$inline = ($args =~ /\binline\b/i);
    }

    ## Check if using icon
    if ($args =~ /\buseicon\b/i) {
	$iconurl = $mhonarc::Icons{$ctype} || $mhonarc::Icons{'unknown'};
	if ($args =~ /\biconurl="([^"]+)"/i) { $iconurl = $1; }
	$icon_mu = qq/<IMG SRC="$iconurl" BORDER=0 ALT=""> /
	    if $iconurl;
    }

    ## Check if target specified
    if    ($args =~ /target="([^"]+)"/i) { $target = $1; }
    elsif ($args =~ /target=(\S+)/i)     { $target = $1; }
    $target =~ s/['"]//g;
    $target = qq/ TARGET="$target"/  if $target;

    ## Write file
    $filename = mhonarc::write_attachment($ctype, \$data, $path, $name, $inext);
    ($urlfile = $filename) =~ s/([^\w.\-\/])/sprintf("%%%X",unpack("C",$1))/ge;
    &debug("File-written: $filename")  if $debug;

    ## Check if inlining when CT not image/*
    if ($inline && ($ctype !~ /\bimage/i)) {
	if ($inlineexts && ($usename || $usenameext) &&
		($filename =~ /\.(\w+)$/)) {
	    my $fext = lc($1);
	    $inline = 0  if (index($inlineexts, ",$fext,") < $[);
	} else {
	    $inline = 0;
	}
    }

    ## Create HTML markup
    if ($inline) {
	$ret  = "<P>" . &htmlize($fields{'content-description'}) . "</P>\n"
	    if ($fields{'content-description'});
	$ret .= qq|<P><A HREF="$urlfile" $target><IMG SRC="$urlfile" | .
		qq|ALT="$type"></A></P>\n|;

    } else {
	$ret  = qq|<P><A HREF="$urlfile" $target>$icon_mu| .
		(&htmlize($fields{'content-description'}) ||
		 $nameparm || $type) .
		qq|</A></P>\n|;
    }
    ($ret, $path || $filename);
}

##---------------------------------------------------------------------------

sub htmlize {
    my $txt = shift;
    return ""  unless defined($txt);

    $txt =~ s/&/\&amp;/g;
    $txt =~ s/>/&gt;/g;
    $txt =~ s/</&lt;/g;
    $txt;
}

##---------------------------------------------------------------------------

sub debug {
    local($_);
    foreach (@_) {
	print STDERR "m2h_external: ", $_;
	print STDERR "\n"  unless /\n$/;
    }
}

##---------------------------------------------------------------------------
1;
