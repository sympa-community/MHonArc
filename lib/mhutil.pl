##---------------------------------------------------------------------------##
##  File:
##	@(#) mhutil.pl 2.1 98/03/02 20:24:31
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##      Utility routines for MHonArc
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-1998	Earl Hood, ehood@medusa.acs.uci.edu
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

##---------------------------------------------------------------------------
##	Get an e-mail address from (HTML) $str.
##
sub extract_email_address {
    local($str) = shift;
    local($ret);

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
    local($str) = shift;
    local($ret);

    if ($str =~ s/<(\S+)>//) {		# Check for: name <addr>
	$ret = $1;
	if ($str !~ /^\s*$/) {		# strip extra whitespace
	    ($ret = $str) =~ s/\s+/ /g;
	} else {			# no name
	    $ret =~ s/@.*//;
	}
	$ret =~ s/^\s*"//;
	$ret =~ s/"\s*$//;
    } elsif ($str =~ /"([^"]+)"/) {		# Name in ""'s
	$ret = $1;
    } elsif ($str =~ /\(([^\)]+)\)/) {		# Name in ()'s
	$ret = $1;
    } else {					# Just address
	($ret = $str) =~ s/@.*//;
    }
    $ret;
}

##---------------------------------------------------------------------------
##	Routine to sort messages
##
sub sort_messages {
    if ($NOSORT) {				# Processed order
	if ($REVSORT) { return sort decrease_msgnum keys %Subject; }
	else { return sort increase_msgnum keys %Subject; }

    } elsif ($SUBSORT) {			# Subject order
	if ($REVSORT) { return sort decrease_subject keys %Subject; }
	else { return sort increase_subject keys %Subject; }

    } elsif ($AUTHSORT) {			# Author order
	if ($REVSORT) { return sort decrease_author keys %Subject; }
	else { return sort increase_author keys %Subject; }

    } else {					# Date order
	if ($REVSORT) { return sort decrease_index keys %Subject; }
	else { return sort increase_index keys %Subject; }
    }
}

##---------------------------------------------------------------------------
##	Routine to sort messages based on thread resources.
##
sub t_sort_messages {
    if ($TNOSORT) {				# Processed order
	if ($TREVERSE) { return sort decrease_msgnum keys %Subject; }
	else { return sort increase_msgnum keys %Subject; }

    } elsif ($TSUBSORT) {			# Subject order
	if ($TREVERSE) { return sort decrease_subject keys %Subject; }
	else { return sort increase_subject keys %Subject; }

    } else {					# Date order
	if ($TREVERSE) { return sort decrease_index keys %Subject; }
	else { return sort increase_index keys %Subject; }
    }
}

##---------------------------------------------------------------------------
##	Message-sort routines for sort_messages
##
sub increase_msgnum {
    $IndexNum{$a} <=> $IndexNum{$b};
}
sub decrease_msgnum {
    $IndexNum{$b} <=> $IndexNum{$a};
}
sub increase_index {
    (&get_time_from_index($a) <=> &get_time_from_index($b)) ||
	($IndexNum{$a} <=> $IndexNum{$b});
}
sub decrease_index {
    (&get_time_from_index($b) <=> &get_time_from_index($a)) ||
	($IndexNum{$b} <=> $IndexNum{$a});
}
sub increase_subject {
    local($A, $B) = ($Subject{$a}, $Subject{$b});
    $A =~ tr/A-Z/a-z/;  $B =~ tr/A-Z/a-z/; 
    1 while $A =~ s/$SubReplyRxp//io;
    1 while $B =~ s/$SubReplyRxp//io;
    $A =~ s/$SubArtRxp//io;  $B =~ s/$SubArtRxp//io;
    ($A cmp $B) || (&get_time_from_index($a) <=> &get_time_from_index($b));
}
sub decrease_subject {
    local($A, $B) = ($Subject{$a}, $Subject{$b});
    $A =~ tr/A-Z/a-z/;  $B =~ tr/A-Z/a-z/; 
    1 while $A =~ s/$SubReplyRxp//io;
    1 while $B =~ s/$SubReplyRxp//io;
    $A =~ s/$SubArtRxp//io;  $B =~ s/$SubArtRxp//io;
    ($A cmp $B) || (&get_time_from_index($b) <=> &get_time_from_index($a));
}
sub increase_author {
    local($A, $B) = (&extract_email_name($From{$a}),
		     &extract_email_name($From{$b}));
    $A =~ tr/A-Z/a-z/;  $B =~ tr/A-Z/a-z/;
    ($A cmp $B) || (&get_time_from_index($a) <=> &get_time_from_index($b));
}
sub decrease_author {
    local($A, $B) = (&extract_email_name($From{$a}),
		     &extract_email_name($From{$b}));
    $A =~ tr/A-Z/a-z/;  $B =~ tr/A-Z/a-z/;
    ($A cmp $B) || (&get_time_from_index($b) <=> &get_time_from_index($a));
}

##---------------------------------------------------------------------------
##	Routine to determine last message number in use.
##
sub get_last_msg_num {
    opendir(DIR, $mhonarc'OUTDIR) ||
	die("ERROR: Unable to open $mhonarc'OUTDIR\n");
    local($max) = -1;

    local($htmlext) = $HtmlExt;
    local($msgpre) = $MsgPrefix;
    $htmlext =~ s/\W/\\$1/g;
    $msgpre =~ s/\W/\\$1/g;

    local($regexp) = '^' . $msgpre . '0*(\d+)\.'. $htmlext;
    chop $regexp  if ($htmlext =~ /html$/i);

    foreach (readdir(DIR)) {
	if (/$regexp/io) {
	    $max = $1  if $1 > $max;
	}
    }
    close(DIR);
    $max;
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
    local($fmtstr) = "$MsgPrefix%05d.$HtmlExt";
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
    (split(/$X/o, $_[0]))[0];
}

##---------------------------------------------------------------------------
##	Routine to get lc author name from index
##
sub get_base_author {
    local($ret) = (&extract_email_name($From{$_[0]}));
    $ret =~ tr/A-Z/a-z/;
    $ret;
}

##---------------------------------------------------------------------------
##	Routine to get base subject text from index
##
sub get_base_subject {
    local($ret) = ($Subject{$_[0]});
    1 while $ret =~ s/$SubReplyRxp//io;
    $ret;
}

##---------------------------------------------------------------------------
##	Determine time from date.  Use %Zone for timezone offsets
##
sub get_time_from_date {
    local($mday, $mon, $yr, $hr, $min, $sec, $zone) = @_;
    local($time) = 0;

    $yr -= 1900  if $yr >= 1900;
    if (($yr < 70) || ($yr > 137)) {
	warn "Warning: Bad year (", $yr+1900, ") using current\n";
	$yr = (localtime(time))[5];
    }
    $zone =~ tr/a-z/A-Z/;

    ## If $zone, grab gmt time, else grab local
    if ($zone) {
	$time = &timegm($sec,$min,$hr,$mday,$mon,$yr);

	# try to modify time/date based on timezone
	if ($zone =~ /^[\+-]\d+$/) {	# numeric timezone
	    $time -= &zone_offset_to_secs($zone);

	# timezone abbrev
	} elsif (defined($Zone{$zone})) {
	    $time += ($Zone{$zone}*3600);

	# undefined timezone
	} else {
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
    local($f) = shift;
    local($ftago, $ftagc, $tago, $tagc);
 
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
    local($tmp,
	  $key,
	  $tago,
	  $tagc,
	  $ftago,
	  $ftagc,
	  $mesg,
	  $item,
	  @array,
	  %hf);

    $mesg = "";
    %hf = %fields;
    foreach $item (@FieldOrder) {
	if ($item eq '-extra-') {
	    foreach $key (sort keys %hf) {
		next  if $FieldODefs{$key};
		delete $hf{$key}, next  if &exclude_field($key);

		@array = split(/$readmail'FieldSep/o, $hf{$key});
		foreach $tmp (@array) {
		    $tmp = &$MHeadCnvFunc($tmp);
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
		@array = (split(/$readmail'FieldSep/o, $hf{$item}));
		foreach $tmp (@array) {
		    $tmp = &$MHeadCnvFunc($tmp);
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
##	Routine to add mailto/news links to a message header string.
##
sub field_add_links {
    local($label, *fld_text) = @_;
    &mailto(*fld_text)
	if !$NOMAILTO &&
	    $label =~ /^(to|from|cc|sender|reply-to|resent-to|resent-cc)/i;
    &newsurl(*fld_text)
	if !$NONEWS && $label =~ /^newsgroup/i;
}


##---------------------------------------------------------------------------
##	Routine to add news links of newsgroups names
##
sub newsurl {
    local(*str) = shift;
    local($h, @groups);
    $str =~ s/^([^:]*:\s*)//;  $h = $1;
    $str =~ s/\s//g;			# Strip whitespace
    @groups = split(/,/, $str);		# Split groups
    foreach (@groups) {			# Make hyperlinks
	s|(.*)|<A HREF="news:$1">$1</A>|;
    }
    $str = $h . join(', ', @groups);	# Rejoin string
}

##---------------------------------------------------------------------------
##	Add mailto URLs to $str.
##
sub mailto {
    local(*str) = shift;
    if ($MAILTOURL) {
	$str =~ s|([\!\%\w\.\-+=/]+@[\w\.\-]+)|&mailUrl($1)|ge;
    } else {
	$str =~ s|([\!\%\w\.\-+=/]+@[\w\.\-]+)|<A HREF="mailto:$1">$1</A>|g;
    }
}

##---------------------------------------------------------------------------
##	$sub, $msgid, $from come from read_mail_header() (ugly!!!!)
##
sub mailUrl {
    local($eaddr) = shift;

    local($url) = ($MAILTOURL);
    local($to) = (&urlize($eaddr));
    local($froml, $msgidl) = (&urlize($from), &urlize($msgid));
    local($fromaddrl) = (&urlize(&extract_email_address($from)));
    local($subjectl);

    # Add "Re:" to subject if not present
    if ($sub !~ /^\s*Re:/) {
	$subjectl = &urlize("Re: ") . &urlize($sub);
    } else {
	$subjectl = &urlize($sub);
    }
    $url =~ s/\$FROM\$/$froml/g;
    $url =~ s/\$FROMADDR\$/$froml/g;
    $url =~ s/\$MSGID\$/$msgidl/g;
    $url =~ s/\$SUBJECT\$/$subjectl/g;
    $url =~ s/\$SUBJECTNA\$/$subjectl/g;
    $url =~ s/\$TO\$/$to/g;
    $url =~ s/\$ADDR\$/$to/g;
    qq|<A HREF="$url">$eaddr</A>|;
}

##---------------------------------------------------------------------------##
##	Routine to parse variable definitions in a string.  The
##	function returns a list of variable/value pairs.  The format of
##	the string is similiar to attribute specification lists in
##	SGML, but NAMEs are any non-whitespace character.
##
sub parse_vardef_str {
    local($org) = shift;
    local(%hash) = ();
    local($str, $q, $var, $value);

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
	$hash{$var} = $value;
    }
    if ($str =~ /\S/) {
	warn "Warning: Illegal variable definition syntax in: $org\n";
	return ();
    }
    %hash;
}

##---------------------------------------------------------------------------##
1;
