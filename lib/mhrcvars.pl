##---------------------------------------------------------------------------##
##  File:
##	@(#) mhrcvars.pl 2.2 98/03/03 14:31:22
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##      Defines routine for expanding resource variables.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1996-1998	Earl Hood, ehood@medusa.acs.uci.edu
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
##	replace_li_var() is used to substitute vars to current
##	values.  This routine relies on some variables being set by the
##	calling routine or as globals.
##
sub replace_li_var {
    local($val, $index) = ($_[0], $_[1]);
    local($var,$len,$canclip,$raw,$isurl,$tmp,$ret) = ('',0,0,0,0,'','');
    local($expand) = (0);
    local($n) = (0);
    local($pi, $ni, $tni, $tpi,
	  $isfirst, $islast, $tisfirst, $tislast);

    ##	Get length specifier (if defined)
    ($var, $len) = split(/:/, $val, 2);

    ##	Check if variable in a URL string
    $isurl = 1  if ($len =~ s/u//ig);	

    ##	Set index related variables
    if ($index ne '') {
	if ($REVSORT) {
	    $ni 	= $MListOrder[$Index2MLoc{$index}-1];
	    $pi 	= $MListOrder[$Index2MLoc{$index}+1];
	    $isfirst	= ($Index2MLoc{$index} == $#MListOrder);
	    $islast	= ($Index2MLoc{$index} == 0);
	} else {
	    $ni 	= $MListOrder[$Index2MLoc{$index}+1];
	    $pi 	= $MListOrder[$Index2MLoc{$index}-1];
	    $isfirst	= ($Index2MLoc{$index} == 0);
	    $islast	= ($Index2MLoc{$index} == $#MListOrder);
	}
	$tni		= $TListOrder[$Index2TLoc{$index}+1];
	$tpi		= $TListOrder[$Index2TLoc{$index}-1];
	$tisfirst	= ($Index2TLoc{$index} == 0);
	$tislast	= ($Index2TLoc{$index} == $#TListOrder);
    }

    ##	Do variable replacement
    REPLACESW: {
	if ($var eq 'SUBJECT') {
	    $canclip = 1; $raw = 1; $isurl = 0;
	    $tmp = $Subject{$index};
	    last REPLACESW;
	}
    	if ($var eq 'SUBJECTNA') {
	    $canclip = 1; $raw = 1;
	    $tmp = $Subject{$index};
	    last REPLACESW;
	}
    	if ($var eq 'A_ATTR') {
	    $isurl = 0;
	    $tmp = qq{NAME="} . &fmt_msgnum($IndexNum{$index}) .
		   qq{" HREF="} .
		   &msgnum_filename($IndexNum{$index}) .
		   qq{"};
	    last REPLACESW;
	}
    	if ($var eq 'A_NAME') {
	    $isurl = 0;
	    $tmp = qq{NAME="} . &fmt_msgnum($IndexNum{$index}) . qq{"};
	    last REPLACESW;
	}
    	if ($var eq 'A_HREF') {
	    $isurl = 0;
	    $tmp = qq{HREF="} . &msgnum_filename($IndexNum{$index}) . qq{"};
	    last REPLACESW;
	}
    	if ($var eq 'DATE') {
	    $tmp = $Date{$index};
	    last REPLACESW;
	}
    	if ($var eq 'DDMMYY') {
	    $tmp = &time2mmddyy((split(/$X/o, $index))[0], 'ddmmyy');
	    last REPLACESW;
	}
    	if ($var eq 'DOCURL') {
	    $isurl = 0;
	    $tmp = $DOCURL;
	    last REPLACESW;
	}
    	if ($var eq 'FROM') {
	    $canclip = 1; $raw = 1;
	    $tmp = $From{$index};
	    last REPLACESW;
	}
    	if ($var eq 'FROMADDR') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_address($From{$index});
	    last REPLACESW;
	}
    	if ($var eq 'FROMNAME') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_name($From{$index});
	    last REPLACESW;
	}
    	if ($var eq 'GMTDATE') {
	    $tmp = &time2str($GMTDateFmt, time, 0);
	    last REPLACESW;
	}
    	if ($var eq 'ICON') {
	    if ($Icons{$ContentType{$index}}) {
		$tmp = qq|<IMG SRC="$Icons{$ContentType{$index}}" | .
		       qq|ALT="[$ContentType{$index}]">|;
	    } else {
		$tmp = qq|<IMG SRC="$Icons{'unknown'}" ALT="[unknown]">|;
	    }
	    last REPLACESW;
	}
    	if ($var eq 'ICONURL') {
	    $isurl = 0;
	    if ($Icons{$ContentType{$index}}) {
		$tmp = $Icons{$ContentType{$index}};
	    } else {
		$tmp = $Icons{'unknown'};
	    }
	    last REPLACESW;
	}
    	if ($var eq 'IDXFNAME') {
	    if ($MULTIIDX &&
		($n = int($Index2MLoc{$index}/$IDXSIZE)+1) > 1) {

		$tmp = sprintf("%s%d.$HtmlExt",
			       $IDXPREFIX, $index ne '' ? $n : 1);

	    } else {
		$tmp = $IDXNAME;
	    }
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
    	if ($var eq 'IDXLABEL') {
	    $tmp = $IDXLABEL;
	    last REPLACESW;
	}
    	if ($var eq 'IDXSIZE') {
	    $tmp = $IDXSIZE;
	    last REPLACESW;
	}
    	if ($var eq 'IDXTITLE') {
	    $canclip = 1; $expand = 1;
	    $tmp = $TITLE;
	    last REPLACESW;
	}
    	if ($var eq 'LOCALDATE') {
	    $tmp = &time2str($LocalDateFmt, time, 1);
	    last REPLACESW;
	}
    	if ($var eq 'MMDDYY') {
	    $tmp = &time2mmddyy((split(/$X/o, $index))[0], 'mmddyy');
	    last REPLACESW;
	}
    	if ($var eq 'MSGGMTDATE') {
	    $tmp = &time2str($MsgGMTDateFmt, &get_time_from_index($index), 0);
	    last REPLACESW;
	}
    	if ($var eq 'MSGID') {
	    &defineIndex2MsgId();
	    $tmp = $Index2MsgId{$index};
	    last REPLACESW;
	}
    	if ($var eq 'MSGLOCALDATE') {
	    $tmp = &time2str($MsgLocalDateFmt, &get_time_from_index($index), 1);
	    last REPLACESW;
	}
    	if ($var eq 'MSGNUM') {
	    $tmp = &fmt_msgnum($IndexNum{$index});
	    last REPLACESW;
	}
    	if ($var eq 'MSGPREFIX') {
	    $tmp = $MsgPrefix;
	    last REPLACESW;
	}
    	if ($var eq 'NEXTFROM') {
	    $canclip = 1; $raw = 1;
	    $tmp = $From{$ni};
	    last REPLACESW;
	}
    	if ($var eq 'NEXTFROMADDR') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_address($From{$ni});
	    last REPLACESW;
	}
    	if ($var eq 'NEXTFROMNAME') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_name($From{$ni});
	    last REPLACESW;
	}
    	if ($var eq 'NEXTMSG') {
	    $tmp = &msgnum_filename($IndexNum{$ni});
	    last REPLACESW;
	}
    	if ($var eq 'NEXTMSGNUM') {
	    $tmp = &fmt_msgnum($IndexNum{$ni});
	    last REPLACESW;
	}
	if ($var eq 'NEXTSUBJECT') {
	    $canclip = 1; $raw = 1;
	    $tmp = $Subject{$ni};
	    last REPLACESW;
	}
    	if ($var eq 'NUMFOLUP') {
	    $tmp = $FolCnt{$index};
	    last REPLACESW;
	}
    	if ($var eq 'NUMOFIDXMSG') {
	    $tmp = ($NumOfMsgs > $IDXSIZE ? $IDXSIZE : $NumOfMsgs);
	    last REPLACESW;
	}
    	if ($var eq 'NUMOFMSG') {
	    $tmp = $NumOfMsgs;
	    last REPLACESW;
	}
    	if ($var eq 'ORDNUM') {
	    $tmp = $i+1;
	    last REPLACESW;
	}
    	if ($var eq 'OUTDIR') {
	    $tmp = $OUTDIR;
	    last REPLACESW;
	}
    	if ($var eq 'PREVFROM') {
	    $canclip = 1; $raw = 1;
	    $tmp = $From{$pi};
	    last REPLACESW;
	}
    	if ($var eq 'PREVFROMADDR') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_address($From{$pi});
	    last REPLACESW;
	}
    	if ($var eq 'PREVFROMNAME') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_name($From{$pi});
	    last REPLACESW;
	}
    	if ($var eq 'PREVMSG') {
	    $tmp = &msgnum_filename($IndexNum{$pi});
	    last REPLACESW;
	}
    	if ($var eq 'PREVMSGNUM') {
	    $tmp = &fmt_msgnum($IndexNum{$pi});
	    last REPLACESW;
	}
	if ($var eq 'PREVSUBJECT') {
	    $canclip = 1; $raw = 1;
	    $tmp = $Subject{$pi};
	    last REPLACESW;
	}
    	if ($var eq 'PROG') {
	    $tmp = $PROG;
	    last REPLACESW;
	}
    	if ($var eq 'TIDXFNAME') {
	    if ($MULTIIDX &&
		($n = int($Index2TLoc{$index}/$IDXSIZE)+1) > 1) {

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
    	if ($var eq 'TSLICE') {
	    $tmp = &make_thread_slice($index, $TSliceNBefore, $TSliceNAfter);
	    last REPLACESW;
	}
    	if ($var eq 'VERSION') {
	    $tmp = $VERSION;
	    last REPLACESW;
	}
    	if ($var eq 'YYMMDD') {
	    $tmp = &time2mmddyy((split(/$X/o, $index))[0], 'yymmdd');
	    last REPLACESW;
	}
    	if ($var eq '') {
	    $tmp = '$';
	    last REPLACESW;
	}

	##
	## Next/Prev buttons/links
	##
	if ($var eq 'NEXTBUTTON') {
	    $expand = 1;
	    $tmp = (!$islast) ? $NEXTBUTTON : $NEXTBUTTONIA;
	    last REPLACESW;
	}
	if ($var eq 'NEXTLINK') {
	    $expand = 1;
	    $tmp = (!$islast) ? $NEXTLINK : $NEXTLINKIA;
	    last REPLACESW;
	}
	if ($var eq 'PREVBUTTON') {
	    $expand = 1;
	    $tmp = (!$isfirst) ? $PREVBUTTON : $PREVBUTTONIA;
	    last REPLACESW;
	}
	if ($var eq 'PREVLINK') {
	    $expand = 1;
	    $tmp = (!$isfirst) ? $PREVLINK : $PREVLINKIA;
	    last REPLACESW;
	}

	##
	## Thread Next/Prev buttons/links
	##
	if ($var eq 'TNEXTBUTTON') {
	    $expand = 1;
	    $tmp = (!$tislast) ? $TNEXTBUTTON : $TNEXTBUTTONIA;
	    last REPLACESW;
	}
	if ($var eq 'TNEXTLINK') {
	    $expand = 1;
	    $tmp = (!$tislast) ? $TNEXTLINK : $TNEXTLINKIA;
	    last REPLACESW;
	}
	if ($var eq 'TPREVBUTTON') {
	    $expand = 1;
	    $tmp = (!$tisfirst) ? $TPREVBUTTON : $TPREVBUTTONIA;
	    last REPLACESW;
	}
	if ($var eq 'TPREVLINK') {
	    $expand = 1;
	    $tmp = (!$tisfirst) ? $TPREVLINK : $TPREVLINKIA;
	    last REPLACESW;
	}

	##
	## Thread related variables
	##
    	if ($var eq 'TNEXTFROM') {
	    $canclip = 1; $raw = 1;
	    $tmp = $From{$tni};
	    last REPLACESW;
	}
    	if ($var eq 'TNEXTFROMADDR') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_address($From{$tni});
	    last REPLACESW;
	}
    	if ($var eq 'TNEXTFROMNAME') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_name($From{$tni});
	    last REPLACESW;
	}
    	if ($var eq 'TNEXTMSG') {
	    $tmp = &msgnum_filename($IndexNum{$tni});
	    last REPLACESW;
	}
    	if ($var eq 'TNEXTMSGNUM') {
	    $tmp = &fmt_msgnum($IndexNum{$tni});
	    last REPLACESW;
	}
	if ($var eq 'TNEXTSUBJECT') {
	    $canclip = 1; $raw = 1;
	    $tmp = $Subject{$tni};
	    last REPLACESW;
	}
    	if ($var eq 'TPREVFROM') {
	    $canclip = 1; $raw = 1;
	    $tmp = $From{$tpi};
	    last REPLACESW;
	}
    	if ($var eq 'TPREVFROMADDR') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_address($From{$tpi});
	    last REPLACESW;
	}
    	if ($var eq 'TPREVFROMNAME') {
	    $canclip = 1; $raw = 1;
	    $tmp = &extract_email_name($From{$tpi});
	    last REPLACESW;
	}
    	if ($var eq 'TPREVMSG') {
	    $tmp = &msgnum_filename($IndexNum{$tpi});
	    last REPLACESW;
	}
    	if ($var eq 'TPREVMSGNUM') {
	    $tmp = &fmt_msgnum($IndexNum{$tpi});
	    last REPLACESW;
	}
	if ($var eq 'TPREVSUBJECT') {
	    $canclip = 1; $raw = 1;
	    $tmp = $Subject{$tpi};
	    last REPLACESW;
	}

	##
	## Multi-page index variables
	##
	if ($var eq 'NEXTPGLINK') {
	    $expand = 1;
	    $tmp = $PageNum < $NumOfPages ? $NEXTPGLINK : $NEXTPGLINKIA;
	    last REPLACESW;
	}
	if ($var eq 'PREVPGLINK') {
	    $expand = 1;
	    $tmp = $PageNum > 1 ? $PREVPGLINK : $PREVPGLINKIA;
	    last REPLACESW;
	}
	if ($var eq 'TNEXTPGLINK') {
	    $expand = 1;
	    $tmp = $PageNum < $NumOfPages ? $TNEXTPGLINK : $TNEXTPGLINKIA;
	    last REPLACESW;
	}
	if ($var eq 'TPREVPGLINK') {
	    $expand = 1;
	    $tmp = $PageNum > 1 ? $TPREVPGLINK : $TPREVPGLINKIA;
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
	if ($var eq 'NEXTPG') {
	    $tmp = sprintf("%s%d.$HtmlExt", $IDXPREFIX, $PageNum+1);
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'PREVPG') {
	    $tmp = $PageNum > 2 ?
		   sprintf("%s%d.$HtmlExt", $IDXPREFIX, $PageNum-1) :
		   $IDXNAME;
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'TNEXTPG') {
	    $tmp = sprintf("%s%d.$HtmlExt", $TIDXPREFIX, $PageNum+1);
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'TPREVPG') {
	    $tmp = $PageNum > 2 ?
		   sprintf("%s%d.$HtmlExt", $TIDXPREFIX, $PageNum-1) :
		   $TIDXNAME;
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'FIRSTPG') {
	    $tmp = $IDXNAME;
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'LASTPG') {
	    $tmp = ($MULTIIDX && $NumOfPages > 1 ? sprintf("%s%d.$HtmlExt",
					$IDXPREFIX, $NumOfPages) :
				$IDXNAME);
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'TFIRSTPG') {
	    $tmp = $TIDXNAME;
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'TLASTPG') {
	    $tmp = ($MULTIIDX && $NumOfPages > 1 ? sprintf("%s%d.$HtmlExt",
					$TIDXPREFIX, $NumOfPages) :
				$TIDXNAME);
	    $tmp .= ".gz"  if $GzipLinks;
	    last REPLACESW;
	}
	if ($var eq 'IDXPREFIX') {
	    $tmp = $IDXPREFIX;
	    last REPLACESW;
	}
	if ($var eq 'TIDXPREFIX') {
	    $tmp = $TIDXPREFIX;
	    last REPLACESW;
	}

	##
	## User defined variable check
	##
	if (defined($CustomRcVars{$var})) {
	    $expand = 1;
	    $tmp = $CustomRcVars{$var};
	    last REPLACESW;
	}

	warn qq{Warning: Unrecognized variable: "$val"\n};
	return "\$$val\$";
    }

    ##	Check if string needs to be expanded again
    if ($expand) {
	$tmp =~ s/\$([^\$]*)\$/&replace_li_var($1,$index)/ge;
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
	if ($len > 0 && $canclip) {
	    # Check for entity refs and modify clip length accordingly
	    foreach ($ret =~ /(\&[^;\s]*;)/g) {
		$len += length($_) -1;
	    }
	    $ret = substr($ret, 0, $len);
	}
    }

    ##	Check for subject link
    $ret = qq{<A NAME="} .
	   &fmt_msgnum($IndexNum{$index}) .
	   qq{" HREF="} .
	   &msgnum_filename($IndexNum{$index}) .
	   qq{">$ret</A>}
	if $var eq 'SUBJECT';

    $ret;
}

##---------------------------------------------------------------------------##
1;
