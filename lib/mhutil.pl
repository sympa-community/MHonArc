##---------------------------------------------------------------------------##
##  File:
##	@(#) mhutil.pl 2.9 00/01/17 17:18:15
##  Author:
##      Earl Hood       mhonarc@pobox.com
##  Description:
##      Utility routines for MHonArc
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

package mhonarc;

## RFC 2369 header fields to check for URLs
my %HFieldsList = (
    'list-archive'  	=> 1,
    'list-help'  	=> 1,
    'list-owner'  	=> 1,
    'list-post'  	=> 1,
    'list-subscribe'  	=> 1,
    'list-unsubscribe' 	=> 1,
);

## Header fields that contain addresses
my %HFieldsAddr = (
    'apparently-from'	=> 1,
    'apparently-to'	=> 1,
    'bcc'		=> 1,
    'cc'		=> 1,
    'dcc'		=> 1,
    'from'		=> 1,
    'reply-to'		=> 1,
    'resent-cc'		=> 1,
    'resent-from'	=> 1,
    'resent-sender'	=> 1,
    'resent-to'		=> 1,
    'return-path'	=> 1,
    'sender'		=> 1,
    'to'		=> 1,
);

##---------------------------------------------------------------------------
##	Get an e-mail address from (HTML) $str.
##
sub extract_email_address {
    my($str) = shift;
    my($ret);

    if ($str =~ /<(\S+)>/) {
	$ret = $1;
    } elsif ($str =~ s/\([^\)]+\)//) {
	$str =~ /\s*(\S+)\s*/;  $ret = $1;
    } else {
	$str =~ /\s*(\S+)\s*/;  $ret = $1;
    }
    $ret;
}

##---------------------------------------------------------------------------
##	Get an e-mail name from $str.
##
sub extract_email_name {
    my($str) = shift;
    my($ret);

    if ($str =~ s/<(\S+)>//) {		# Check for: name <addr>
	$ret = $1;
	if ($str =~ /\S/) {
	    $ret = $str;
	} else {			# no name
	    $ret =~ s/@.*//;
	}
    } elsif ($str =~ /"([^"]+)"/) {		# Name in ""'s
	$ret = $1;
    } elsif ($str =~ /\(([^\)]+)\)/) {		# Name in ()'s
	$ret = $1;
    } else {					# Just address
	($ret = $str) =~ s/@.*//;
    }
    $ret =~ s/^["\s]+//g; $ret =~ s/["\s]+$//g;
    $ret;
}

##---------------------------------------------------------------------------
##	Routine to sort messages
##
sub sort_messages {
    my($nosort, $subsort, $authsort, $revsort) = @_;
    $nosort   = $NOSORT    if !defined($nosort);
    $subsort  = $SUBSORT   if !defined($subsort);
    $authsort = $AUTHSORT  if !defined($authsort);
    $revsort  = $REVSORT   if !defined($revsort);

    if ($nosort) {
	## Process order
	if ($revsort) {
	    return sort { $IndexNum{$b} <=> $IndexNum{$a} } keys %Subject;
	} else {
	    return sort { $IndexNum{$a} <=> $IndexNum{$b} } keys %Subject;
	}

    } elsif ($subsort) {
	## Subject order
	my(%sub, $idx, $sub);
	eval {
	    my $hs = scalar(%Subject);  $hs =~ s|^[^/]+/||;
	    keys(%sub) = $hs;
	};
	while (($idx, $sub) = each(%Subject)) {
	    $sub = lc $sub;
	    1 while $sub =~ s/$SubReplyRxp//io;
	    $sub =~ s/$SubArtRxp//io;
	    $sub{$idx} = $sub;
	}
	if ($revsort) {
	    return sort { ($sub{$b} cmp $sub{$a}) ||
			  (get_time_from_index($b) <=> get_time_from_index($a))
			} keys %Subject;
	} else {
	    return sort { ($sub{$a} cmp $sub{$b}) ||
			  (get_time_from_index($a) <=> get_time_from_index($b))
			} keys %Subject;
	}
	
    } elsif ($authsort) {
	## Author order
	my(%from, $idx, $from);
	eval {
	    my $hs = scalar(%From);  $hs =~ s|^[^/]+/||;
	    keys(%from) = $hs;
	};
	while (($idx, $from) = each(%From)) {
	    $from = lc extract_email_name($from);
	    $from{$idx} = $from;
	}
	if ($revsort) {
	    return sort { ($from{$b} cmp $from{$a}) ||
			  (get_time_from_index($b) <=> get_time_from_index($a))
			} keys %Subject;
	} else {
	    return sort { ($from{$a} cmp $from{$b}) ||
			  (get_time_from_index($a) <=> get_time_from_index($b))
			} keys %Subject;
	}

    } else {
	## Date order
	if ($revsort) {
	    return sort { (get_time_from_index($b) <=> get_time_from_index($a))
			  || ($IndexNum{$b} <=> $IndexNum{$a})
			} keys %Subject;
	} else {
	    return sort { (get_time_from_index($a) <=> get_time_from_index($b))
			  || ($IndexNum{$a} <=> $IndexNum{$b})
			} keys %Subject;
	}

    }
}

##---------------------------------------------------------------------------
##	Message-sort routines for sort().
##
sub increase_index {
    (&get_time_from_index($a) <=> &get_time_from_index($b)) ||
	($IndexNum{$a} <=> $IndexNum{$b});
}

##---------------------------------------------------------------------------
##	Routine for formating a message number for use in filenames or links.
##
sub fmt_msgnum {
    sprintf("%05d", $_[0]);
}

##---------------------------------------------------------------------------
##	Routine to get filename of a message number.
##
sub msgnum_filename {
    my($fmtstr) = "$MsgPrefix%05d.$HtmlExt";
    $fmtstr .= ".gz"  if $GzipLinks;
    sprintf($fmtstr, $_[0]);
}

##---------------------------------------------------------------------------
##	Routine to get filename of an index
##
sub get_filename_from_index {
    &msgnum_filename($IndexNum{$_[0]});
}

##---------------------------------------------------------------------------
##	Routine to get time component from index
##
sub get_time_from_index {
    (split(/$X/o, $_[0], 2))[0];
}

##---------------------------------------------------------------------------
##	Routine to get annotation of a message
##
sub get_note {
    my $index = shift;
    my $file = join($DIRSEP, get_note_dir(),
			     msgid_to_filename($Index2MsgId{$index}));
    if (!open(NOTEFILE, $file)) { return ""; }
    my $ret = join("", <NOTEFILE>);
    close NOTEFILE;
    $ret;
}

##---------------------------------------------------------------------------
##	Routine to determine if a message has an annotation
##
sub note_exists {
    my $index = shift;
    -e join($DIRSEP, get_note_dir(),
		     msgid_to_filename($Index2MsgId{$index}));
}

##---------------------------------------------------------------------------
##	Routine to get full pathname to annotation directory
##
sub get_note_dir {
    if (!OSis_absolute_path($NoteDir)) {
	return join($DIRSEP, $OUTDIR, $NoteDir);
    }
    $NoteDir;
}

##---------------------------------------------------------------------------
##	Routine to get lc author name from index
##
sub get_base_author {
    lc extract_email_name($From{$_[0]});
}

##---------------------------------------------------------------------------
##	Determine time from date.  Use %Zone for timezone offsets
##
sub get_time_from_date {
    local($mday, $mon, $yr, $hr, $min, $sec, $zone) = @_;
    local($time) = 0;

    $yr -= 1900  if $yr >= 1900;  # if given full 4 digit year
    $yr += 100   if $yr <= 37;    # in case of 2 digit years
    if (($yr < 70) || ($yr > 137)) {
	warn "Warning: Bad year (", $yr+1900, ") using current\n";
	$yr = (localtime(time))[5];
    }
    $zone =~ tr/a-z/A-Z/;

    ## If $zone, grab gmt time, else grab local
    if ($zone) {
	$time = &timegm($sec,$min,$hr,$mday,$mon,$yr);

	# try to modify time/date based on timezone
	OFFSET: {
	    # numeric timezone
	    if ($zone =~ /^[\+-]\d+$/) {
		$time -= &zone_offset_to_secs($zone);
		last OFFSET;
	    }
	    # Zone
	    if (defined($Zone{$zone})) {
		# timezone abbrev
		$time += &zone_offset_to_secs($Zone{$zone});
		last OFFSET;

	    }
	    # Zone[+-]DDDD
	    if ($zone =~ /^([A-Z]\w+)([\+-]\d+)$/) {
		$time -= &zone_offset_to_secs($2);
		if (defined($Zone{$1})) {
		    $time += &zone_offset_to_secs($Zone{$1});
		    last OFFSET;
		}
	    }
	    # undefined timezone
	    warn qq|Warning: Unrecognized time zone, "$zone"\n|;
	}

    } else {
	$time = &timelocal($sec,$min,$hr,$mday,$mon,$yr);
    }
    $time;
}

##---------------------------------------------------------------------------
##	Routine to check if time has expired.
##
sub expired_time {
    ($ExpireTime && (time - $_[0] > $ExpireTime)) ||
    ($_[0] < $ExpireDateTime);
}

##---------------------------------------------------------------------------
##      Get HTML tags for formatting message headers
##
sub get_header_tags {
    my($f) = shift;
    my($ftago, $ftagc, $tago, $tagc);
 
    ## Get user specified tags (this is one funcky looking code)
    $tag = (defined($HeadHeads{$f}) ?
            $HeadHeads{$f} : $HeadHeads{"-default-"});
    $ftag = (defined($HeadFields{$f}) ?
             $HeadFields{$f} : $HeadFields{"-default-"});
    if ($tag) { $tago = "<$tag>";  $tagc = "</$tag>"; }
    else { $tago = $tagc = ''; }
    if ($ftag) { $ftago = "<$ftag>";  $ftagc = "</$ftag>"; }
    else { $ftago = $ftagc = ''; }
 
    ($tago, $tagc, $ftago, $ftagc);
}

##---------------------------------------------------------------------------
##	Format message headers in HTML.
##
sub htmlize_header {
    local(*fields, *l2o) = @_;
    my($key,
       $tago, $tagc,
       $ftago, $ftagc,
       $mesg, $item,
       @array, %hf);
    local($tmp);

    $mesg = "";
    %hf = %fields;
    foreach $item (@FieldOrder) {
	if ($item eq '-extra-') {
	    foreach $key (sort keys %hf) {
		next  if $FieldODefs{$key};
		delete $hf{$key}, next  if &exclude_field($key);

		@array = split(/$readmail::FieldSep/o, $hf{$key});
		foreach $tmp (@array) {
		    $tmp = $HFieldsList{$key} ? mlist_field_add_links($tmp) :
						&$MHeadCnvFunc($tmp);
		    &field_add_links($key, *tmp);
		    ($tago, $tagc, $ftago, $ftagc) = &get_header_tags($key);
		    $mesg .= join('', $LABELBEG,
				  $tago, $l2o{$key}, $tagc, $LABELEND,
				  $FLDBEG, $ftago, $tmp, $ftagc, $FLDEND,
				  "\n");
		}
		delete $hf{$key};
	    }
	} else {
	    if (!&exclude_field($item) && $hf{$item}) {
		@array = (split(/$readmail::FieldSep/o, $hf{$item}));
		foreach $tmp (@array) {
		    $tmp = $HFieldsList{$item} ? mlist_field_add_links($tmp) :
						 &$MHeadCnvFunc($tmp);
		    &field_add_links($item, *tmp);
		    ($tago, $tagc, $ftago, $ftagc) = &get_header_tags($item);
		    $mesg .= join('', $LABELBEG,
				  $tago, $l2o{$item}, $tagc, $LABELEND,
				  $FLDBEG, $ftago, $tmp, $ftagc, $FLDEND,
				  "\n");
		}
	    }
	    delete $hf{$item};
	}
    }
    if ($mesg) { $mesg = $FIELDSBEG . $mesg . $FIELDSEND; }
    $mesg;
}

##---------------------------------------------------------------------------

sub mlist_field_add_links {
    my $txt	= shift;
    my $ret	= "";
    local($_);
    foreach (split(/(<[^>]+>)/, $txt)) {
	if (/^</) {
	    chop; substr($_, 0, 1) = "";
	    $ret .= qq|&lt;<A HREF="$_">$_</A>&gt;|;
	} else {
	    $ret .= &$MHeadCnvFunc($_);
	}
    }
    $ret;
}

##---------------------------------------------------------------------------
##	Routine to add mailto/news links to a message header string.
##
sub field_add_links {
    my $label = lc shift;
    local(*fld_text) = shift;

    LBLSW: {
	if ($HFieldsAddr{$label}) {
	    if (!$NOMAILTO) {
		$fld_text =~ s|([\!\%\w\.\-+=/]+@[\w\.\-]+)|&mailUrl($1)|ge;
	    } else {
		$fld_text =~ s|([\!\%\w\.\-+=/]+@[\w\.\-]+)
			      |&htmlize(&rewrite_address($1))
			      |gex;
	    }
	    last LBLSW;
	}
	if ($label eq 'newsgroup') {
	    &newsurl(*fld_text)  unless $NONEWS;
	    last LBLSW;
	}
	last LBLSW;
    }
}


##---------------------------------------------------------------------------
##	Routine to add news links of newsgroups names
##
sub newsurl {
    local(*str) = shift;
    my(@groups) = ();
    my $h = "";

    if ($str =~ s/^([^:]*:\s*)//) {
	$h = $1;
    }
    $str =~ s/\s//g;			# Strip whitespace
    @groups = split(/,/, $str);		# Split groups
    foreach (@groups) {			# Make hyperlinks
	s|(.*)|<A HREF="news:$1">$1</A>|;
    }
    $str = $h . join(', ', @groups);	# Rejoin string
}

##---------------------------------------------------------------------------
##	$sub, $msgid, $from come from read_mail_header() (ugly!!!!)
##
sub mailUrl {
    my($eaddr) = shift;

    local $_;
    my($url) = ($MAILTOURL);
    my($to) = (&urlize($eaddr));
    my($toname, $todomain) = map { urlize($_) } split(/@/,$eaddr,2);
    my($froml, $msgidl) = (&urlize($from), &urlize($msgid));
    my($fromaddrl) = (&extract_email_address($from));
    my($faddrnamel, $faddrdomainl) = map { urlize($_) } split(/@/,$fromaddrl,2);
    $fromaddrl = &urlize($fromaddrl);
    my($subjectl);

    # Add "Re:" to subject if not present
    if ($sub !~ /^\s*Re:/) {
	$subjectl = &urlize("Re: ") . &urlize($sub);
    } else {
	$subjectl = &urlize($sub);
    }
    $url =~ s/\$FROM\$/$froml/g;
    $url =~ s/\$FROMADDR\$/$fromaddrl/g;
    $url =~ s/\$FROMADDRNAME\$/$faddrnamel/g;
    $url =~ s/\$FROMADDRDOMAIN\$/$faddrdomainl/g;
    $url =~ s/\$MSGID\$/$msgidl/g;
    $url =~ s/\$SUBJECT\$/$subjectl/g;
    $url =~ s/\$SUBJECTNA\$/$subjectl/g;
    $url =~ s/\$TO\$/$to/g;
    $url =~ s/\$TOADDRNAME\$/$toname/g;
    $url =~ s/\$TOADDRDOMAIN\$/$todomain/g;
    $url =~ s/\$ADDR\$/$to/g;
    qq|<A HREF="$url">| . &htmlize(&rewrite_address($eaddr)) . q|</A>|;
}

##---------------------------------------------------------------------------##
##	Routine to parse variable definitions in a string.  The
##	function returns a list of variable/value pairs.  The format of
##	the string is similiar to attribute specification lists in
##	SGML, but NAMEs are any non-whitespace character.
##
sub parse_vardef_str {
    my($org) = shift;
    my($lower) = shift;
    my(%hash) = ();
    my($str, $q, $var, $value);

    ($str = $org) =~ s/^\s+//;
    while ($str =~ s/^([^=\s]+)\s*=\s*//) {
	$var = $1;
	if ($str =~ s/^(['"])//) {
	    $q = $1;
	    if (!($q eq "'" ? $str =~ s/^([^']*)'// :
			      $str =~ s/^([^"]*)"//)) {
		warn "Warning: Unclosed quote in: $org\n";
		return ();
	    }
	    $value = $1;

	} else {
	    if ($str =~ s/^(\S+)//) {
		$value = $1;
	    } else {
		warn "Warning: No value after $var in: $org\n";
		return ();
	    }
	}
	$str =~ s/^\s+//;
	$hash{$lower? lc($var): $var} = $value;
    }
    if ($str =~ /\S/) {
	warn "Warning: Trailing characters in: $org\n";
    }
    %hash;
}

##---------------------------------------------------------------------------##

sub msgid_to_filename {
    my $msgid = shift;
    if ($VMS) {
	$msgid =~ s/([^\w\-])/sprintf("=%02X",unpack("C",$1))/geo;
    } else {
	$msgid =~ s/([^\w.\-\@])/sprintf("=%02X",unpack("C",$1))/geo;
    }
    $msgid;
}

##---------------------------------------------------------------------------##
1;
