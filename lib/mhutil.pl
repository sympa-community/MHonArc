##---------------------------------------------------------------------------##
##  File:
##      mhutil.pl
##  Author:
##      Earl Hood       ehood@isogen.com
##  Date:
##	Wed Apr 17 00:46:26 CDT 1996
##  Description:
##      Utility routines for MHonArc
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995	Earl Hood, ehood@isogen.com
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

package main;

%Month2Num = (
    'Jan', 0, 'Feb', 1, 'Mar', 2, 'Apr', 3, 'May', 4, 'Jun', 5, 'Jul', 6,
    'Aug', 7, 'Sep', 8, 'Oct', 9, 'Nov', 10, 'Dec', 11,
);
%WDay2Num = (
    'Sun', 0, 'Mon', 1, 'Tue', 2, 'Wed', 3, 'Thu', 4, 'Fri', 5, 'Sat', 6,
);

##---------------------------------------------------------------------------##
##	MHonArc based routines
##---------------------------------------------------------------------------##
##---------------------------------------------------------------------------
##	read_fmt_file() parses the resource file.  The name is misleading.
##	(The code for this routine could probably be simplified).
##
sub read_fmt_file {
    local($file) = shift;
    local($line, $tag, $label, $acro, $hr, $type, $routine, $plfile,
	  $url, $arg);
    local($elem, $attr, $override);

    if (!open(FMT, $file)) {
	warn "Warning: Unable to open resource file: $file\n";
	return 0;
    }
    print STDOUT "Reading resource file: $file ...\n"  unless $QUIET;
    while ($line = <FMT>) {
	next unless $line =~ /^\s*<([^>]+)>/;
	($elem, $attr) = split(' ', $1, 2);
	$elem =~ tr/A-Z/a-z/;
	$override = ($attr =~ /override/i);
	FMTSW: {
	if ($elem eq "botlinks") {		# Bottom links in message
	    $BOTLINKS = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/botlinks\s*>/i;
		$BOTLINKS .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "docurl") {		# Doc URL
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/docurl\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g; $DOCURL = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "dbfile") {		# Database file
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/dbfile\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g; $DBFILE = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "excs") {			# Exclude header fields
	    %HFieldsExc = ()  if $override;
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/excs\s*>/i;
		$line =~ s/\s//g;  $line =~ tr/A-Z/a-z/;
		$HFieldsExc{$line} = 1  if $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "fieldstyles") {		# Field text style
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/fieldstyles\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;  $line =~ tr/A-Z/a-z/;
		($label, $tag) = split(/:/,$line);
		$HeadFields{$label} = $tag;
	    }
	    last FMTSW;
	}
	if ($elem eq "fieldorder") {		# Field order
	    @FieldOrder = ();  %FieldODefs = ();
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/fieldorder\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;  $line =~ tr/A-Z/a-z/;
		push(@FieldOrder, $line);
		$FieldODefs{$line} = 1;
	    }
	    push(@FieldOrder,'-extra-')  if (!$FieldODefs{'-extra-'});
	    last FMTSW;
	}
	if ($elem eq "footer") {		# Footer file
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/footer\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$FOOTER = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "header") {		# Header file
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/header\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$HEADER = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "icons") {			# Icons
	    %Icons = ()  if $override;
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/icons\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		($type, $url) = split(/:/,$line,2);
		$type =~ tr/A-Z/a-z/;
		$Icons{$type} = $url;
	    }
	    last FMTSW;
	}
	if ($elem eq "idxfname") {		# Index filename
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/idxfname\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$IDXNAME = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "idxpgbegin") {		# Opening markup of index
	    $IDXPGBEG = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/idxpgbegin\s*>/i;
		$IDXPGBEG .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "idxpgend") {		# Closing markup of index
	    $IDXPGEND = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/idxpgend\s*>/i;
		$IDXPGEND .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "idxsize") {		# Size of index
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/idxsize\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$IDXSIZE = $line  if ($line =~ /^\d+$/);
	    }
	    last FMTSW;
	}
	if ($elem eq "labelstyles") {		# Field label style
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/labelstyles\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;  $line =~ tr/A-Z/a-z/;
		($label, $tag) = split(/:/,$line);
		$HeadHeads{$label} = $tag;
	    }
	    last FMTSW;
	}
	if ($elem eq "listbegin") {		# List begin
	    $LIBEG = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/listbegin\s*>/i;
		$LIBEG .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "listend") {		# List end
	    $LIEND = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/listend\s*>/i;
		$LIEND .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "litemplate") {		# List item template
	    $LITMPL = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/litemplate\s*>/i;
		$LITMPL .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "mailtourl") {		# mailto URL
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/mailtourl\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$MAILTOURL = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "maxsize") {		# Size of archive
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/maxsize\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$MAXSIZE = $line  if ($line =~ /^\d+$/);
	    }
	    last FMTSW;
	}
	if ($elem eq "mimefilters") {		# Mime filters
	    @Requires = (), %MIMEFilters = ()  if $override;
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/mimefilters\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		($type,$routine,$plfile) = split(/:/,$line,3);
		$type =~ tr/A-Z/a-z/;
		$MIMEFilters{$type} = $routine;
		push(@Requires, $plfile);
	    }
	    last FMTSW;
	}
	if ($elem eq "mimeargs") {		# Mime arguments
	    %MIMEFiltersArgs = ()  if $override;
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/mimeargs\s*>/i;
		next  if $line =~ /^\s*$/;
		($type,$arg) = split(/:/,$line,2);
		$type =~ tr/A-Z/a-z/  if $type =~ m%/%;
		$MIMEFiltersArgs{$type} = $arg;
	    }
	    last FMTSW;
	}
	if ($elem eq "msgfoot") {		# Message footer text
	    $MSGFOOT = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/msgfoot\s*>/i;
		$MSGFOOT .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "msghead") {		# Message header text
	    $MSGHEAD = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/msghead\s*>/i;
		$MSGHEAD .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "msgpgbegin") {		# Opening markup of message
	    $MSGPGBEG = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/msgpgbegin\s*>/i;
		$MSGPGBEG .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "msgpgend") {		# Closing markup of message
	    $MSGPGEND = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/msgpgend\s*>/i;
		$MSGPGEND .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "msgsep") {		# Message separator
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/msgsep\s*>/i;
		next  if $line =~ /^\s*$/;
		chop $line;
		$FROM = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "nextbutton") {		# Next button link in message
	    $NEXTBUTTON = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/nextbutton\s*>/i;
		$NEXTBUTTON .= $line;
	    }
	    chop $NEXTBUTTON;
	    last FMTSW;
	}
	if ($elem eq "nextbuttonia") {
	    $NEXTBUTTONIA = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/nextbuttonia\s*>/i;
		$NEXTBUTTONIA .= $line;
	    }
	    chop $NEXTBUTTONIA;
	    last FMTSW;
	}
	if ($elem eq "nextlink") {		# Next link in message
	    $NEXTLINK = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/nextlink\s*>/i;
		$NEXTLINK .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "nextlinkia") {
	    $NEXTLINKIA = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/nextlinkia\s*>/i;
		$NEXTLINKIA .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "nodoc") {
	    $NODOC = 1; last FMTSW;
	}
	if ($elem eq "nonews") {
	    $NONEWS = 1; last FMTSW;
	}
	if ($elem eq "nomailto") {
	    $NOMAILTO = 1; last FMTSW;
	}
	if ($elem eq "noreverse") {
	    $REVSORT = 0; last FMTSW;
	}
	if ($elem eq "nosort") {
	    $NOSORT = 1;  $SUBSORT = 0; last FMTSW;
	}
	if ($elem eq "nothread") {
	    $THREAD = 0; last FMTSW;
	}
	if ($elem eq "notreverse") {
	    $TREVERSE = 0; last FMTSW;
	}
	if ($elem eq "notsubsort") {
	    $TSUBSORT = 0; last FMTSW;
	}
	if ($elem eq "nourl") {
	    $NOURL = 1; last FMTSW;
	}
	if ($elem eq "otherindexes") {		# Other indexes
	    @OtherIdxs = ();
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/otherindexes\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		push(@OtherIdxs, $line);
	    }
	    last FMTSW;
	}
	if ($elem eq "perlinc") {		# Message separator
	    @PerlINC = ()  if $override;
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/perlinc\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		unshift(@PerlINC, $line);
	    }
	    last FMTSW;
	}
	if ($elem eq "prevbutton") {		# Prev button link in message
	    $PREVBUTTON = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/prevbutton\s*>/i;
		$PREVBUTTON .= $line;
	    }
	    chop $PREVBUTTON;
	    last FMTSW;
	}
	if ($elem eq "prevbuttonia") {
	    $PREVBUTTONIA = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/prevbuttonia\s*>/i;
		$PREVBUTTONIA .= $line;
	    }
	    chop $PREVBUTTONIA;
	    last FMTSW;
	}
	if ($elem eq "prevlink") {		# Prev link in message
	    $PREVLINK = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/prevlink\s*>/i;
		$PREVLINK .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "prevlinkia") {
	    $PREVLINKIA = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/prevlinkia\s*>/i;
		$PREVLINKIA .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "reverse") {
	    $REVSORT = 1; last FMTSW;
	}
	if ($elem eq "sort") {
	    $NOSORT = 0;  $SUBSORT = 0; last FMTSW;
	}
	if ($elem eq "subsort") {
	    $NOSORT = 0;  $SUBSORT = 1; last FMTSW;
	}
	if ($elem eq "thead") {			# Thread idx head
	    $THEAD = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/thead\s*>/i;
		$THEAD .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "tfoot") {			# Thread idx foot
	    $TFOOT = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/tfoot\s*>/i;
		$TFOOT .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "tidxfname") {		# Threaded idx filename
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/tidxfname\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$TIDXNAME = $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "tidxpgbegin") {		# Opening markup of thread idx
	    $TIDXPGBEG = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/tidxpgbegin\s*>/i;
		$TIDXPGBEG .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "tidxpgend") {		# Closing markup of thread idx
	    $TIDXPGEND = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/tidxpgend\s*>/i;
		$TIDXPGEND .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "timezones") {		# Time zones
	    %Zone = ()  if $override;
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/timezones\s*>/i;
		$line =~ s/\s//g;  $line =~ tr/a-z/A-Z/;
		($acro,$hr) = split(/:/,$line);
		$Zone{$acro} = $hr;
	    }
	    last FMTSW;
	}
	if ($elem eq "title") {			# Title of index page
	    $TITLE = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/title\s*>/i;
		$TITLE .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "tlevels") {		# Level of threading
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/tlevels\s*>/i;
		next  if $line =~ /^\s*$/;
		$line =~ s/\s//g;
		$TLEVELS = $line  if ($line =~ /^\d+$/);
	    }
	    last FMTSW;
	}
	if ($elem eq "tlitxt") {		# Thread idx <li> txt
	    $TLITXT = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/tlitxt\s*>/i;
		$TLITXT .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "toplinks") {		# Top links in message
	    $TOPLINKS = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/toplinks\s*>/i;
		$TOPLINKS .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "tsubsort") {
	    $TSUBSORT = 1; last FMTSW;
	}
	if ($elem eq "ttitle") {		# Title of threaded idx
	    $TTITLE = '';
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/ttitle\s*>/i;
		$TTITLE .= $line;
	    }
	    last FMTSW;
	}
	if ($elem eq "thread") {
	    $THREAD = 1; last FMTSW;
	}
	if ($elem eq "treverse") {
	    $TREVERSE = 1; last FMTSW;
	}
	if ($elem eq "umask") {		# Umask of process
	    while ($line = <FMT>) {
		last  if $line =~ /^\s*<\/umask\s*>/i;
		next  if $line =~ /^\s*$/;
		chop $line;
		$UMASK = $line;
	    }
	    last FMTSW;
	}

	} ## End FMTSW
    }
    close(FMT);
    1;
}
##---------------------------------------------------------------------------
##	Get an e-mail address from (HTML) $str.
##
sub extract_email_address {
    local($str) = shift;
    local($ret);

    if ($str =~ /\&lt;(\S+)\&gt;/) {
	$ret = $1;
    } elsif ($str =~ s/\([^\)]+\)//) {
	$str =~ /\s*(\S+)\s*/;  $ret = $1;
    } else {
	$str =~ /\s*(\S+)\s*/;  $ret = $1;
    }
    $ret;
}
##---------------------------------------------------------------------------
##	Get an e-mail name from (HTML) $str.
##
sub extract_email_name {
    local($str) = shift;
    local($ret);

    if ($str =~ s/\&lt;(\S+)\&gt;//) {		# Check for: name <addr>
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
    local(@a);
    if ($NOSORT) {				# Message processed order
	if ($REVSORT) { @a = sort decrease_msgnum keys %Subject; }
	else { @a = sort increase_msgnum keys %Subject; }

    } elsif ($SUBSORT) {			# Subject order
	if ($REVSORT) { @a = sort decrease_subject keys %Subject; }
	else { @a = sort increase_subject keys %Subject; }

    } else {					# Date order
	if ($REVSORT) { @a = sort decrease_index keys %Subject; }
	else { @a = sort increase_index keys %Subject; }
    }
    @a;
}
##---------------------------------------------------------------------------
##	Message-sort routines for sort_messages
##
sub increase_msgnum {
    local(@A) = split(/$'X/o, $a);
    local(@B) = split(/$'X/o, $b);
    local($sret);
    $sret = $A[1] <=> $B[1];
    ($sret == 0 ? $A[0] <=> $B[0] : $sret);
}
sub decrease_msgnum {
    local(@A) = split(/$'X/o, $a);
    local(@B) = split(/$'X/o, $b);
    local($sret);
    $sret = $B[1] <=> $A[1];
    ($sret == 0 ? $B[0] <=> $A[0] : $sret);
}
sub increase_index {
    local(@A) = split(/$'X/o, $a);
    local(@B) = split(/$'X/o, $b);
    local($sret);
    $sret = $A[0] <=> $B[0];
    ($sret == 0 ? $A[1] <=> $B[1] : $sret);
}
sub decrease_index {
    local(@A) = split(/$'X/o, $a);
    local(@B) = split(/$'X/o, $b);
    local($sret);
    $sret = $B[0] <=> $A[0];
    ($sret == 0 ? $B[1] <=> $A[1] : $sret);
}
sub increase_subject {
    local($A, $B) = ($Subject{$a}, $Subject{$b});
    local($at, $bt) = ((split(/$'X/o, $a))[0], (split(/$'X/o, $b))[0]);
    $A =~ tr/A-Z/a-z/;  $B =~ tr/A-Z/a-z/; 
    1 while $A =~ s/^\s*(re|sv|fwd|fw)[:>-]+\s*//i;
    1 while $B =~ s/^\s*(re|sv|fwd|fw)[:>-]+\s*//i;
    $A =~ s/^(the|a|an)\s+//i;  $B =~ s/^(the|a|an)\s+//i;
    local($sret) = ($A cmp $B);
    ($sret == 0 ? $at <=> $bt : $sret);
}
sub decrease_subject {
    local($A, $B) = ($Subject{$a}, $Subject{$b});
    local($at, $bt) = ((split(/$'X/o, $a))[0], (split(/$'X/o, $b))[0]);
    $A =~ tr/A-Z/a-z/;  $B =~ tr/A-Z/a-z/; 
    1 while $A =~ s/^\s*(re|sv|fwd|fw)[:>-]+\s*//i;
    1 while $B =~ s/^\s*(re|sv|fwd|fw)[:>-]+\s*//i;
    $A =~ s/^(the|a|an)\s+//i;  $B =~ s/^(the|a|an)\s+//i;
    local($sret) = ($B cmp $A);
    ($sret == 0 ? $bt <=> $at : $sret);
}
##---------------------------------------------------------------------------
##	Routine to determine last message number in use.
##
sub get_last_msg_num {
    local(@files) = ();
    local($n);
    opendir(DIR, $'OUTDIR) || &error("ERROR: Unable to open $'OUTDIR");
    @files = sort by_msgnum grep(/^msg\d+\.html?$/i, readdir(DIR));
    grep(s/msg0+(\d)/msg$1/i, @files);
    close(DIR);
    if (@files) {
	($n) = $files[$#files] =~ /(\d+)/;
    } else {
	$n = -1;
    }
    $n;
}
sub by_msgnum {
    ($A) = $a =~ /(\d+)/;
    ($B) = $b =~ /(\d+)/;
    $A <=> $B;
}
##---------------------------------------------------------------------------
##	Routine for formating a message number for use in filenames or links.
##
sub fmt_msgnum {
    local($num) = $_[0];
    sprintf("%05d", $num);
}
##---------------------------------------------------------------------------
##	Routine to get filename of a message number.
##
sub msgnum_filename {
    local($num) = $_[0];
    sprintf("msg%05d.html", $num);
}
##---------------------------------------------------------------------------##
##	MHonArc independent routines
##---------------------------------------------------------------------------##
##---------------------------------------------------------------------------
##	parse_date takes a string date specified like the output of
##	date(1) into its components.
##
sub parse_date {
    local($date) = $_[0];
    local($wday, $mday, $mon, $yr, $time, $hr, $min, $sec, $zone);
    local(@array);

    $date =~ s/^\s*//;
    @array = split(' ', $date);
    if ($array[0] =~ /\d/) {        # DD Mon YY HH:MM:SS Zone
	($mday, $mon, $yr, $time, $zone) = @array;
    } elsif ($array[1] =~ /\d/) {   # Wdy DD Mon YY HH:MM:SS Zone
	($wday, $mday, $mon, $yr, $time, $zone) = @array;
    } else {                        # Wdy Mon DD HH:MM:SS Zone YYYY
	($wday, $mon, $mday, $time, $zone, $yr) = @array;
	if ($zone =~ /\d/) {        # No zone
	    $yr = $zone;
	    $zone = '';
	}
    }
    ($hr, $min, $sec) = split(/:/, $time);
    $sec = 0  unless $sec;          # Sometime seconds not defined

    ($WDay2Num{$wday}, $mday, $Month2Num{$mon}, $yr, $hr, $min, $sec, $zone);
}
##---------------------------------------------------------------------------
##
sub time2mmddyy {
    local($time, $fmt) = ($_[0], $_[1]);
    local($day,$mon,$year);
    if ($time) {
	($day,$mon,$year) = (localtime($time))[3,4,5];
	if ($fmt =~ /ddmmyy/i) {
	    $tmp = sprintf("%02d/%02d/%02d", $day, $mon+1, $year);
	} elsif ($fmt =~ /yymmdd/i) {
	    $tmp = sprintf("%02d/%02d/%02d", $year, $mon+1, $day);
	} else {
	    $tmp = sprintf("%02d/%02d/%02d", $mon+1, $day, $year);
	}
    } else {
	$tmp = "--/--/--";
    }
}
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
sub htmlize {			# Older name, variable passed by reference
    local(*txt) = $_[0];
    $txt =~ s/&/\&amp;/g;
    $txt =~ s/>/&gt;/g;
    $txt =~ s/</&lt;/g;
    $txt;
}
sub entify {			# Newer name, variable passed by copy
    local($txt) = $_[0];
    $txt =~ s/&/\&amp;/g;
    $txt =~ s/>/&gt;/g;
    $txt =~ s/</&lt;/g;
    $txt;
}
##---------------------------------------------------------------------------
##	Copy a file.
##
sub cp {
    local($src, $dst) = @_;
    open(SRC, $src) || &error("ERROR: Unable to open $src");
    open(DST, "> $dst") || &error("ERROR: Unable to create $dst");
    print DST <SRC>;
    close(SRC);
    close(DST);
}
##---------------------------------------------------------------------------
##	Get date in date(1)-like format.  $local flag is if local time
##	should be used.
##
sub getdate {
    local($local) = $_[0];
    local($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
    local($curtime) = (time());

    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
	($local ? localtime($curtime) : gmtime($curtime));
    sprintf("%s %s %02d %02d:%02d:%02d " . ($local ? "%s" : "GMT %s"),
	    (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday],
	    (Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec)[$mon],
	    $mday, $hour, $min, $sec, $year);
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
    $url =~ s/([{}\[\]\\^~<>\?%=\+ \t])/sprintf("%%%X",unpack("C",$1))/ge;
    $url;
}
##---------------------------------------------------------------------------##

1;
