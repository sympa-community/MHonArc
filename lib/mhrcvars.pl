##---------------------------------------------------------------------------##
##  File:
##	@(#) mhrcvars.pl 2.13 01/04/10 21:36:41
##  Author:
##      Earl Hood       mhonarc@pobox.com
##  Description:
##      Defines routine for expanding resource variables.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1996-1999	Earl Hood, mhonarc@pobox.com
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

## Mapping of old resource variables to current versions.
my %old2new = (
    'FIRSTPG'    	=> [ 'PG', 'FIRST' ],
    'LASTPG'    	=> [ 'PG', 'LAST' ],
    'NEXTBUTTON'    	=> [ 'BUTTON', 'NEXT' ],
    'NEXTFROM'    	=> [ 'FROM', 'NEXT' ],
    'NEXTFROMADDR'    	=> [ 'FROMADDR', 'NEXT' ],
    'NEXTFROMNAME'    	=> [ 'FROMNAME', 'NEXT' ],
    'NEXTLINK'    	=> [ 'LINK', 'NEXT' ],
    'NEXTMSG'    	=> [ 'MSG', 'NEXT' ],
    'NEXTMSGNUM'    	=> [ 'MSGNUM', 'NEXT' ],
    'NEXTPG'    	=> [ 'PG', 'NEXT' ],
    'NEXTPGLINK'    	=> [ 'PGLINK', 'NEXT' ],
    'NEXTSUBJECT'	=> [ 'SUBJECT', 'NEXT' ],
    'PREVBUTTON'    	=> [ 'BUTTON', 'PREV' ],
    'PREVFROM'    	=> [ 'FROM', 'PREV' ],
    'PREVFROMADDR'    	=> [ 'FROMADDR', 'PREV' ],
    'PREVFROMNAME'    	=> [ 'FROMNAME', 'PREV' ],
    'PREVLINK'    	=> [ 'LINK', 'PREV' ],
    'PREVMSG'    	=> [ 'MSG', 'PREV' ],
    'PREVMSGNUM'    	=> [ 'MSGNUM', 'PREV' ],
    'PREVPGLINK'    	=> [ 'PGLINK', 'PREV' ],
    'PREVPG'    	=> [ 'PG', 'PREV' ],
    'PREVSUBJECT'	=> [ 'SUBJECT', 'PREV' ],
    'TFIRSTPG'    	=> [ 'PG', 'TFIRST' ],
    'TLASTPG'    	=> [ 'PG', 'TLAST' ],
    'TNEXTBUTTON'    	=> [ 'BUTTON', 'TNEXT' ],
    'TNEXTFROM'    	=> [ 'FROM', 'TNEXT' ],
    'TNEXTFROMADDR'    	=> [ 'FROMADDR', 'TNEXT' ],
    'TNEXTFROMNAME'    	=> [ 'FROMNAME', 'TNEXT' ],
    'TNEXTLINK'    	=> [ 'LINK', 'TNEXT' ],
    'TNEXTMSG'    	=> [ 'MSG', 'TNEXT' ],
    'TNEXTMSGNUM'    	=> [ 'MSGNUM', 'TNEXT' ],
    'TNEXTPGLINK'    	=> [ 'PGLINK', 'TNEXT' ],
    'TNEXTPG'    	=> [ 'PG', 'TNEXT' ],
    'TNEXTSUBJECT'	=> [ 'SUBJECT', 'TNEXT' ],
    'TPREVBUTTON'    	=> [ 'BUTTON', 'TPREV' ],
    'TPREVFROM'    	=> [ 'FROM', 'TPREV' ],
    'TPREVFROMADDR'    	=> [ 'FROMADDR', 'TPREV' ],
    'TPREVFROMNAME'    	=> [ 'FROMNAME', 'TPREV' ],
    'TPREVLINK'    	=> [ 'LINK', 'TPREV' ],
    'TPREVMSG'    	=> [ 'MSG', 'TPREV' ],
    'TPREVMSGNUM'    	=> [ 'MSGNUM', 'TPREV' ],
    'TPREVPGLINK'    	=> [ 'PGLINK', 'TPREV' ],
    'TPREVPG'    	=> [ 'PG', 'TPREV' ],
    'TPREVSUBJECT'	=> [ 'SUBJECT', 'TPREV' ],
);

##---------------------------------------------------------------------------
##	replace_li_var() is used to substitute vars to current
##	values.  This routine relies on some variables being set by the
##	calling routine or as globals.
##
sub replace_li_var {
    my($val, $index) = ($_[0], $_[1]);
    my($var,$len,$canclip,$raw,$isurl,$tmp,$ret) = ('',0,0,0,0,'','');
    my($jstr) = (0);
    my($expand) = (0);
    my($n) = (0);
    my($isfirst, $islast, $tisfirst, $tislast);
    my($lref, $key, $pos);
    my($arg, $opt) = ("", "");

    ##	Get variable argument string
    if ($val =~ s/\(([^()]*)\)//) {
	$arg = $1;
    }

    ##	Get length specifier (if defined)
    ($var, $len) = split(/:/, $val, 2);
    $len = -1  unless defined $len;

    ##	Check for old resource variables and map to new
    ($var, $arg) = @{$old2new{$var}}  if defined($old2new{$var});

    ##	Check if variable in a URL string
    $isurl = 1  if ($len =~ s/u//ig);	
    $jstr  = 1  if ($len =~ s/j//ig);	

    ##	Set index related variables
    if ($index ne '') {
	if ($REVSORT) {
	    $isfirst	= ($Index2MLoc{$index} == $#MListOrder);
	    $islast	= ($Index2MLoc{$index} == 0);
	} else {
	    $isfirst	= ($Index2MLoc{$index} == 0);
	    $islast	= ($Index2MLoc{$index} == $#MListOrder);
	}
	$tisfirst	= ($Index2TLoc{$index} == 0);
	$tislast	= ($Index2TLoc{$index} == $#TListOrder);
    }

    ##	Do variable replacement
    REPLACESW: {

	## -------------------------------------- ##
	## Message information resource variables ##
	## -------------------------------------- ##
    	if ($var eq 'DATE') {		## Message "Date:"
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? $Date{$key} : "";
	    last REPLACESW;
	}
    	if ($var eq 'DDMMYY' || $var eq 'DDMMYYYY' ||
	    $var eq 'MMDDYY' || $var eq 'MMDDYYYY' ||
	    $var eq 'YYMMDD' || $var eq 'YYYYMMDD') {
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ?
			&time2mmddyy((split(/$X/o, $key))[0], lc $var) :
			"";
	    last REPLACESW;
	}
	my($cnd1, $cnd2, $cnd3) = (0,0,0);
    	if (($cnd1 = ($var eq 'FROM')) ||	## Message "From:"
	    ($cnd2 = ($var eq 'FROMADDR')) ||	## Message from mail address
	    ($cnd3 = ($var eq 'FROMNAME'))) {	## Message from name
	    my $esub = $cnd1 ? sub { $_[0]; } :
		       $cnd2 ? \&extract_email_address :
			       \&extract_email_name;
	    $canclip = 1; $raw = 1;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? &$esub($From{$key}) : "(nil)";
	    last REPLACESW;
	}
    	if ( ($cnd1 = ($var eq 'FROMADDRNAME')) ||
	     ($cnd2 = ($var eq 'FROMADDRDOMAIN')) ) {
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    if (!defined($key)) {
		$tmp = "";
		last REPLACESW;
	    }
	    my @a = split(/@/, extract_email_address($From{$key}), 2);
	    if ($cnd1) {
		$tmp = $a[0];
		last REPLACESW;
	    }
	    $tmp = defined($a[1]) ? $a[1] : "";
	    last REPLACESW;
	}
    	if ($var eq 'ICON') {		## Message icon
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    if (!defined($key)) { $tmp = ""; last REPLACESW; }
	    $tmp = $Icons{$ContentType{$key}} ?
			join("", qq|<img src="$Icons{$ContentType{$key}}" |,
			     qq|alt="[$ContentType{$key}]">|) :
			qq|<img src="$Icons{'unknown'}" alt="[unknown]">|;
	    last REPLACESW;
	}
    	if ($var eq 'ICONURL') {	## URL to message icon
	    $isurl = 0;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    if ($Icons{$ContentType{$key}}) {
		$tmp = $Icons{$ContentType{$key}};
	    } else {
		$tmp = $Icons{'unknown'};
	    }
	    last REPLACESW;
	}
    	if ($var eq 'MSG') {		## Filename of message page
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? &msgnum_filename($IndexNum{$key}) : "";
	    last REPLACESW;
	}
    	if ($var eq 'MSGGMTDATE') {	## Message GMT date
	    ($lref, $key, $pos, $opt) = compute_msg_pos($index, $var, $arg);
	    $tmp = &time2str($opt || $MsgGMTDateFmt,
			     &get_time_from_index($key), 0);
	    last REPLACESW;
	}
    	if ($var eq 'MSGID') {		## Message-ID
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? $Index2MsgId{$index} : "";
	    last REPLACESW;
	}
    	if ($var eq 'MSGLOCALDATE') {	## Message local date
	    ($lref, $key, $pos, $opt) = compute_msg_pos($index, $var, $arg);
	    $tmp = &time2str($opt || $MsgLocalDateFmt,
			     &get_time_from_index($key), 1);
	    last REPLACESW;
	}
    	if ($var eq 'MSGNUM') {		## Message number
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? &fmt_msgnum($IndexNum{$key}) : "";
	    last REPLACESW;
	}
    	if ($var eq 'MSGTORDNUM') {	## Message ordinal num in cur thread
	    # Some form of optimization should be done here since
	    # computation can degrade to n^2 (where n is size of thread)
	    # if variable is referenced for each message on thread index
	    # page.
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg, 1);
	    $tmp = 1;
	    my $level = $ThreadLevel{$key};
	    for (--$pos ; ($level > 0) && ($pos >= 0); --$pos, ++$tmp ) {
		$level = $ThreadLevel{$TListOrder[$pos]};
	    }
	    last REPLACESW;
	}
    	if ($var eq 'NOTE') {		## Annotation template markup
	    $expand = 1;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = note_exists($key) ? $NOTE : $NOTEIA;
	    last REPLACESW;
	}
    	if ($var eq 'NOTEICON') {	## Annotation ICON (HTML markup)
	    $expand = 1;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = note_exists($key) ? $NOTEICON : $NOTEICONIA;
	    last REPLACESW;
	}
    	if ($var eq 'NOTETEXT') {	## Annotation text
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = get_note($key);
	    last REPLACESW;
	}
    	if ($var eq 'NUMFOLUP') {	## Number of explicit follow-ups
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? $FolCnt{$key} : "";
	    last REPLACESW;
	}
    	if ($var eq 'ORDNUM') {		## Sort order number of message
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? $pos+1 : -1;
	    last REPLACESW;
	}
    	if ($var eq 'SUBJECT') {	## Message subject
	    $canclip = 1; $raw = 1; $isurl = 0;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? $Subject{$key} : "";
	    last REPLACESW;
	}
    	if ($var eq 'SUBJECTNA') {	## Message subject (not linked)
	    $canclip = 1; $raw = 1;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    $tmp = defined($key) ? $Subject{$key} : "";
	    last REPLACESW;
	}

	## ------------------------------------- ##
	## Message navigation resource variables ##
	## ------------------------------------- ##
	if ($var eq 'BUTTON') {
	    $expand = 1;
	    SW: {
		if ($arg eq 'NEXT') {
		    $tmp = (!$islast) ? $NEXTBUTTON : $NEXTBUTTONIA;
		    last SW; }
		if ($arg eq 'PREV') {
		    $tmp = (!$isfirst) ? $PREVBUTTON : $PREVBUTTONIA;
		    last SW; }
		if ($arg eq 'TNEXT') {
		    $tmp = (!$tislast) ? $TNEXTBUTTON : $TNEXTBUTTONIA;
		    last SW; }
		if ($arg eq 'TPREV') {
		    $tmp = (!$tisfirst) ? $TPREVBUTTON : $TPREVBUTTONIA;
		    last SW; }
	    }
	    last REPLACESW;
	}
	if ($var eq 'LINK') {
	    $expand = 1;
	    SW: {
		if ($arg eq 'NEXT') {
		    $tmp = (!$islast) ? $NEXTLINK : $NEXTLINKIA;
		    last SW; }
		if ($arg eq 'PREV') {
		    $tmp = (!$isfirst) ? $PREVLINK : $PREVLINKIA;
		    last SW; }
		if ($arg eq 'TNEXT') {
		    $tmp = (!$tislast) ? $TNEXTLINK : $TNEXTLINKIA;
		    last SW; }
		if ($arg eq 'TPREV') {
		    $tmp = (!$tisfirst) ? $TPREVLINK : $TPREVLINKIA;
		    last SW; }
	    }
	    last REPLACESW;
	}

    	if ($var eq 'TSLICE') {
	    $tmp = &make_thread_slice($index, $TSliceNBefore, $TSliceNAfter)
	    	if ($TSliceNBefore != 0 || $TSliceNAfter != 0);
	    last REPLACESW;
	}

	## -------------------------------- ##
	## Index related resource variables ##
	## -------------------------------- ##
    	if ($var eq 'A_ATTR') {		## Anchor attrs to link to message
	    $isurl = 0;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    if (!defined($key)) { $tmp = ""; last REPLACESW; }
	    $tmp = qq/name="/ . &fmt_msgnum($IndexNum{$key}) .
		   qq/" href="/ .
		   &msgnum_filename($IndexNum{$key}) .
		   qq/"/;
	    last REPLACESW;
	}
    	if ($var eq 'A_NAME') {		## Anchor name for message position
	    $isurl = 0;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    if (!defined($key)) { $tmp = ""; last REPLACESW; }
	    $tmp = qq/name="/ . &fmt_msgnum($IndexNum{$key}) . qq/"/;
	    last REPLACESW;
	}
    	if ($var eq 'A_HREF') {		## Anchor href to link to message
	    $isurl = 0;
	    ($lref, $key, $pos) = compute_msg_pos($index, $var, $arg);
	    if (!defined($key)) { $tmp = ""; last REPLACESW; }
	    $tmp = qq/href="/ . &msgnum_filename($IndexNum{$key}) . qq/"/;
	    last REPLACESW;
	}
    	if ($var eq 'IDXFNAME') {	## Filename of index page
	    if ($MULTIIDX && ($n = int($Index2MLoc{$index}/$IDXSIZE)+1) > 1) {
		$tmp = sprintf("%s%d.$HtmlExt",
			       $IDXPREFIX, $index ne '' ? $n : 1);
	    } else {
		$tmp = $IDXNAME;
	    }
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
    	if ($var eq 'IDXLABEL') {	## Label for main index
	    $tmp = $IDXLABEL;
	    last REPLACESW;
	}
    	if ($var eq 'IDXSIZE') {	## Index page size
	    $tmp = $IDXSIZE;
	    last REPLACESW;
	}
    	if ($var eq 'IDXTITLE') {	## Main index title
	    $canclip = 1; $expand = 1;
	    $tmp = $TITLE;
	    last REPLACESW;
	}
    	if ($var eq 'NUMOFIDXMSG') {	## Number of items on the index page
	    $tmp = $PageSize;
	    last REPLACESW;
	}
    	if ($var eq 'NUMOFMSG') {	## Total number of messages
	    $tmp = $NumOfMsgs;
	    last REPLACESW;
	}
    	if ($var eq 'SORTTYPE') {	## Sort type of index
	    SORTTYPE: {
		if ($NOSORT)   { $tmp = 'Number';  last SORTTYPE; }
		if ($AUTHSORT) { $tmp = 'Author';  last SORTTYPE; }
		if ($SUBSORT)  { $tmp = 'Subject'; last SORTTYPE; }
		$tmp = 'Date';
		last SORTTYPE;
	    }
	    last REPLACESW;
	}
    	if ($var eq 'TIDXFNAME') {
	    if ($MULTIIDX && ($n = int($Index2TLoc{$index}/$IDXSIZE)+1) > 1) {
		$tmp = sprintf("%s%d.$HtmlExt",
			       $TIDXPREFIX, $index ne '' ? $n : 1);
	    } else {
		$tmp = $TIDXNAME;
	    }
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
    	if ($var eq 'TIDXLABEL') {
	    $tmp = $TIDXLABEL;
	    last REPLACESW;
	}
    	if ($var eq 'TIDXTITLE') {
	    $canclip = 1; $expand = 1;
	    $tmp = $TTITLE;
	    last REPLACESW;
	}
    	if ($var eq 'TSORTTYPE') {
	    TSORTTYPE: {
		if ($TNOSORT)   { $tmp = 'Number';  last TSORTTYPE; }
		if ($TSUBSORT)  { $tmp = 'Subject'; last TSORTTYPE; }
		$tmp = 'Date';
		last TSORTTYPE;
	    }
	    last REPLACESW;
	}

	if ($var eq 'PGLINK') {
	    $expand = 1;
	    SW: {
		if ($arg eq 'NEXT') {
		    $tmp = $PageNum < $NumOfPages ?
		    			$NEXTPGLINK : $NEXTPGLINKIA;
		    last SW; }
		if ($arg eq 'PREV') {
		    $tmp = $PageNum > 1 ? $PREVPGLINK : $PREVPGLINKIA;
		    last SW; }
		if ($arg eq 'TNEXT') {
		    $tmp = $PageNum < $NumOfPages ?
		    			$TNEXTPGLINK : $TNEXTPGLINKIA;
		    last SW; }
		if ($arg eq 'TPREV') {
		    $tmp = $PageNum > 1 ? $TPREVPGLINK : $TPREVPGLINKIA;
		    last SW; }
	    }
	    last REPLACESW;
	}
	if ($var eq 'PGLINKLIST') {
	    my $num = $PageNum;
	    my $t = $arg =~ s/T//gi;
	    my($before, $after) = split(/;/, $arg);
	    my $prefix  = $t ? $TIDXPREFIX : $IDXPREFIX;
	    my $suffix  = $HtmlExt;
	       $suffix .= '.gz'  if $GzipLinks;
	    $before = $num - abs($before);
	    $after  = $num + abs($after);
	    $tmp = "";
	    for ($i=$before; $i < $num; ++$i) {
		next  if $i < 1;
		if ($i < 2) {
		    $tmp .= sprintf('<a href="%s%s">%d</a> | ',
				    ($t ? $TIDXNAME : $IDXNAME),
				    ($GzipLinks ? '.gz' : ""), $i);
		    next;
		}
		$tmp .= sprintf('<a href="%s%d.%s">%d</a> | ',
			        $prefix, $i, $suffix, $i);
	    }
	    $tmp .= $num;
	    for ($i=$num+1; $i <= $after && $i <= $NumOfPages; ++$i) {
		$tmp .= sprintf(' | <a href="%s%d.%s">%d</a>',
			        $prefix, $i, $suffix, $i);
	    }
	    last REPLACESW;
	}

	if ($var eq 'PAGENUM') {
	    $tmp = $PageNum;
	    last REPLACESW;
	}
	if ($var eq 'NUMOFPAGES') {
	    $tmp = $NumOfPages;
	    last REPLACESW;
	}

	if ($var eq 'PG') {
	    my $num = $PageNum;
	    my $t = ($arg =~ s/^T//);
	    my $prefix = $t ? $TIDXPREFIX : $IDXPREFIX;
	    SW: {
		if ($arg eq 'NEXT')    { $num = $PageNum+1; last SW; }
		if ($arg eq 'PREV')    { $num = $PageNum-1; last SW; }
		if ($arg eq 'FIRST')   { $num = 0; last SW; }
		if ($arg eq 'LAST')    { $num = $NumOfPages; last SW; }
		if ($arg =~ /^-?\d+$/) { $num = $PageNum+$arg; last SW; }
	    }
	    if ($num < 2) {
		$tmp = $t ? $TIDXNAME : $IDXNAME;
	    } else {
		$num = $NumOfPages  if $num > $NumOfPages;
		$tmp = sprintf("%s%d.$HtmlExt", $prefix, $num);
	    }
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}

	## -------------------------------- ##
	## Miscellaneous resource variables ##
	## -------------------------------- ##
    	if ($var eq 'DOCURL') {
	    $isurl = 0;
	    $tmp = $DOCURL;
	    last REPLACESW;
	}
	if ($var eq 'ENV') {
	    $tmp = htmlize($ENV{$arg});
	    last REPLACESW;
	}
    	if ($var eq 'GMTDATE') {
	    $tmp = &time2str($arg || $GMTDateFmt, time, 0);
	    last REPLACESW;
	}
    	if ($var eq 'HTMLEXT') {
	    $tmp = $HtmlExt;
	    last REPLACESW;
	}
	if ($var eq 'IDXPREFIX') {
	    $tmp = $IDXPREFIX;
	    last REPLACESW;
	}
    	if ($var eq 'LOCALDATE') {
	    $tmp = &time2str($arg || $LocalDateFmt, time, 1);
	    last REPLACESW;
	}
    	if ($var eq 'MSGPREFIX') {
	    $tmp = $MsgPrefix;
	    last REPLACESW;
	}
    	if ($var eq 'OUTDIR') {
	    $tmp = $OUTDIR;
	    last REPLACESW;
	}
    	if ($var eq 'PROG') {
	    $tmp = $PROG;
	    last REPLACESW;
	}
	if ($var eq 'TIDXPREFIX') {
	    $tmp = $TIDXPREFIX;
	    last REPLACESW;
	}
    	if ($var eq 'VERSION') {
	    $tmp = $VERSION;
	    last REPLACESW;
	}
    	if ($var eq '') {
	    $tmp = '$';
	    last REPLACESW;
	}

	## --------------------------- ##
	## User defined variable check ##
	## --------------------------- ##
	if (defined($CustomRcVars{$var})) {
	    $expand = 1;
	    $tmp = $CustomRcVars{$var};
	    last REPLACESW;
	}

	warn qq/Warning: Unrecognized variable: "$val"\n/;
	return "\$$val\$";
    }

    ##	Check if string needs to be expanded again
    if ($expand) {
	$tmp =~ s/$VarExp/&replace_li_var($1,$index)/geo;
    }

    ##	Check if URL text specifier is set
    if ($isurl) {
	$ret = &urlize($tmp);

    } else {
	if ($raw) {
	    $ret = &$MHeadCnvFunc($tmp);
	} else {
	    $ret = $tmp;
	}

	# Check for clipping
	$ret = join("", ($ret =~ /(\&[^;\s]*;|.)/g)[0 .. $len - 1])
	    if ($len > 0 && $canclip);

	# Check if JavaScript string
	if ($jstr) {
	    $ret =~ s/\\/\\\\/g;	# escape backslashes
	    $ret =~ s/(["'])/\\$1/g;	# escape quotes
	    $ret =~ s/\n/\\n/g;		# escape newlines
	    $ret =~ s/\r/\\r/g;		# escape returns
	}
    }

    ##	Check for subject link
    $ret = qq|<a name="| .
	   &fmt_msgnum($IndexNum{$index}) .
	   qq|" href="| .
	   &msgnum_filename($IndexNum{$index}) .
	   qq|">$ret</a>|
	if $var eq 'SUBJECT' && $arg eq "";

    $ret;
}

##---------------------------------------------------------------------------##
##	compute_msg_pos(): Get message location data.
##
sub compute_msg_pos {
    my($idx, $var, $arg, $usethread) = @_;
    my($ofs, $pos, $aref, $href, $key);
    my $opt  = undef;
    my $flip = 0;

    ## Determine what list type
    if (($arg =~ s/^T//) || $usethread) {
	$aref = \@TListOrder;
	$href = \%Index2TLoc;
    } else {
	$aref = \@MListOrder;
	$href = \%Index2MLoc;
	$flip = $REVSORT;
    }

    ## Extract out optional data
    ($arg, $opt) = split(/;/, $arg);

    SW: {
	$ofs =  0, last SW
	    if $arg eq "" or $arg eq 'CUR';
	$ofs = ($flip ? 1 : -1), last SW
	    if $arg eq 'PREV';
	$ofs = ($flip ? -1 : 1), last SW
	    if $arg eq 'NEXT';
	$ofs = ($flip ? -$arg : $arg), last SW
	    if $arg =~ /^-?\d+$/;

	if ($arg eq 'FIRST') {
	    $pos = $flip ? $#$aref : 0;
	    undef $ofs;
	    last SW;
	}
	if ($arg eq 'LAST') {
	    $pos = $flip ? 0 : $#$aref;
	    undef $ofs;
	    last SW;
	}
	if ($arg eq 'PARENT') {
	    undef $ofs;
	    my $level = $ThreadLevel{$idx};
	    $pos = $Index2TLoc{$idx};
	    last SW  if ($level <= 0);
	    for (--$pos; $pos >= 0; --$pos) {
		last  if $ThreadLevel{$TListOrder[$pos]} < $level;
	    }
	    last SW;
	}
	if ($arg eq 'TOP') {
	    undef $ofs;
	    $pos = $Index2TLoc{$idx};
	    for (; $pos >= 0; --$pos) {
		last  if $ThreadLevel{$TListOrder[$pos]} <= 0;
	    }
	    last SW;
	}
	if ($arg eq 'END') {
	    undef $ofs;
	    $pos = $Index2TLoc{$idx};
	    for (; $pos < $#TListOrder; ++$pos) {
		last  if $ThreadLevel{$TListOrder[$pos+1]} <= 0;
	    }
	    last SW;
	}
	warn qq/Warning: $var: Unrecognized variable argument: "$arg"\n/;
	$ofs = 0;
    }
    $pos = $href->{$idx} + $ofs  if defined($ofs);
    if (($pos > $#$aref) || ($pos < 0)) {
	$pos = -1;
	$key = undef;
    } else {
	$key = $aref->[$pos];
    }

    ($aref, $key, $pos, $opt);
}

##---------------------------------------------------------------------------##
1;
