##---------------------------------------------------------------------------##
##  File:
##	@(#) mhamain.pl 2.2 98/03/03 15:12:11
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##	Main library for MHonArc.
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

$VERSION = "2.2.0";
$VINFO =<<EndOfInfo;
  MHonArc v$VERSION
  Copyright (C) 1995-1998  Earl Hood, ehood\@medusa.acs.uci.edu
  MHonArc comes with ABSOLUTELY NO WARRANTY and MHonArc may be copied only
  under the terms of the GNU General Public License, which may be found in
  the MHonArc distribution.
EndOfInfo

$ERROR = "";

###############################################################################
##	Public routines
###############################################################################

##---------------------------------------------------------------------------
##	initialize() does some initialization stuff.
##
sub initialize {
    ##	Turn off buffered I/O to terminal
    local($curfh) = select(STDOUT);
    $| = 1;
    select($curfh);

    ##	Check what system we are executing under
    require 'osinit.pl'	   || die("ERROR: Unable to require osinit.pl\n");
    &OSinit();

    ##	Require essential libraries
    require 'newgetopt.pl' || die("ERROR: Unable to require newgetopt.pl\n");
    require 'mhopt.pl'     || die("ERROR: Unable to require mhopt.pl\n");

    ##	Init some variables
    $ISLOCK     = 0;	# Database lock flag

    $StartTime	= 0;	# CPU start time of processing
    $EndTime	= 0;	# CPU end time of processing
}

##---------------------------------------------------------------------------
##	Routine to process input.  If no errors, routine returns the
##	CPU time taken.  If an error, returns undef.
##
sub process_input {
    $StartTime = (times)[0];

    ## Set @ARGV if options passed in
    local(@argv)  = ();
    if (@_) { @argv = @ARGV; @ARGV = @_; }

    ## Do processing
    eval q{
	if (&get_cli_opts()) { &doit(); }
    };

    ## Restore @ARGV
    if (@_) { @ARGV = @argv; }

    ## Check for error
    if ($@) {
	&clean_up();
	warn $@;
	$ERROR = $@;
	return undef;
    }

    ## Cleanup
    &clean_up();
}

###############################################################################
##	Private routines
###############################################################################

##---------------------------------------------------------------------------
##	Routine that does the work
##
sub doit {
    ## Check for non-archive modification modes.
    if ($SCAN) {
	&scan();
	return 1;
    } elsif ($SINGLE) {
	&single();
	return 1;
    }

    ## Following (may) cause changes to an archive
    local($mesg, $tmp, $index, $sub, $from, $i, $date, $fh, $tmp2);
    local(@array, @array2);
    local(%fields);

    $i = $NumOfMsgs;
    ##-------------------##
    ## Read mail folders ##
    ##-------------------##

    ## Just editing pages
    if ($EDITIDX || $IDXONLY) {
	print STDOUT "Editing $OUTDIR layout ...\n"  unless $QUIET;

    ## Removing messages
    } elsif ($RMM) {
	print STDOUT "Removing messages from $OUTDIR ...\n"
	    unless $QUIET;
	&rmm(@ARGV);

    ## Adding a single message
    } elsif ($ADDSINGLE) {
	print STDOUT "Adding message to $OUTDIR\n"  unless $QUIET;
	$handle = $ADD;

	## Read mail head
	($index,$from,$date,$sub,$header) =
	    &read_mail_header($handle, *mesg, *fields);

	if ($index ne '') {
	    ($From{$index},$Date{$index},$Subject{$index}) =
		($from,$date,$sub);

	    $AddIndex{$index} = 1;
	    $IndexNum{$index} = &getNewMsgNum();

	    $MsgHead{$index} = $mesg;

	    ## Read rest of message
	    $Message{$index} = &read_mail_body(
					$handle,
					$index,
					$header,
				        *fields);
	}

    ## Adding/converting mail{boxes,folders}
    } else {
	print STDOUT ($ADD ? "Adding" : "Converting"), " messages to $OUTDIR"
	    unless $QUIET;
	local($mbox, $mesgfile, @files);

	foreach $mbox (@ARGV) {

	    ## MH mail folder (a directory)
	    if (-d $mbox) {
		if (!opendir(MAILDIR, $mbox)) {
		    warn "\nWarning: Unable to open $mbox\n";
		    next;
		}
		$MBOX = 0;  $MH = 1;
		print STDOUT "\nReading $mbox "  unless $QUIET;
		@files = sort numerically grep(/$MHPATTERN/o,
					       readdir(MAILDIR));
		closedir(MAILDIR);
		foreach (@files) {
		    $mesgfile = "${mbox}${DIRSEP}${_}";
		    if (!($fh = &file_open($mesgfile))) {
			warn "\nWarning: Unable to open message $mesgfile\n";
			next;
		    }
		    print STDOUT "."  unless $QUIET;
		    $mesg = '';
		    ($index,$from,$date,$sub,$header) =
			&read_mail_header($fh, *mesg, *fields);

		    #  Process message if valid
		    if ($index ne '') {
			($From{$index},$Date{$index},$Subject{$index}) =
			    ($from,$date,$sub);
			$MsgHead{$index} = $mesg;

			if ($ADD && !$SLOW) { $AddIndex{$index} = 1; }
			$IndexNum{$index} = &getNewMsgNum();

			$Message{$index} = &read_mail_body(
						$fh,
						$index,
						$header,
					        *fields);
			#  Check if conserving memory
			if ($SLOW && $DoArchive) {
			    &output_mail($index, 1, 1);
			    $Update{$IndexNum{$index}} = 1;
			    undef $MsgHead{$index};
			    undef $Message{$index};
			}
		    }
		    close($fh);
		}

	    ## UUCP mail box file
	    } else {
		if ($mbox eq "-") {
		    $fh = 'STDIN';
		} elsif (!($fh = &file_open($mbox))) {
		    warn "\nWarning: Unable to open $mbox\n";
		    next;
		}

		$MBOX = 1;  $MH = 0;
		print STDOUT "\nReading $mbox "  unless $QUIET;
		while (<$fh>) { last if /$FROM/o; }
		MBOX: while (!eof($fh)) {
		    print STDOUT "."  unless $QUIET;
		    $mesg = '';
		    ($index,$from,$date,$sub,$header) =
			&read_mail_header($fh, *mesg, *fields);

		    if ($index ne '') {
			($From{$index},$Date{$index},$Subject{$index}) =
			    ($from,$date,$sub);
			$MsgHead{$index} = $mesg;

			if ($ADD && !$SLOW) { $AddIndex{$index} = 1; }
			$IndexNum{$index} = &getNewMsgNum();

			$Message{$index} = &read_mail_body(
						$fh,
						$index,
						$header,
						*fields);
			if ($SLOW && $DoArchive) {
			    &output_mail($index, 1, 1);
			    $Update{$IndexNum{$index}} = 1;
			    delete($MsgHead{$index});
			    delete($Message{$index});
			}
		    } else {
			&read_mail_body($fh, $index, $header, *fields, 1);
		    }
		}
		close($fh);

	    } # END: else UUCP mailbox
	} # END: foreach $mbox
    } # END: Else converting mailboxes

    ## All done if not creating an archive
    if (!$DoArchive) {
	return 1;
    }

    ## Check if there are any new messages
    if (!$EDITIDX && !$IDXONLY && $i == $NumOfMsgs) {
	print STDOUT "\nNo new messages\n"  unless $QUIET;
	return 1;
    }

    ##---------------------------------------------##
    ## Setup data structures for final HTML output ##
    ##---------------------------------------------##

    ## Remove old message if hit maximum size or expiration
    if (!$IDXONLY && (($MAXSIZE && ($NumOfMsgs > $MAXSIZE)) ||
		      $ExpireTime || $ExpireDateTime)) {

	@array = sort increase_index keys %Subject;

	&ign_signals();		# Ignore termination signals

	while ($index = shift(@array)) {
	    last  unless
		    ($MAXSIZE && ($NumOfMsgs > $MAXSIZE)) ||
		    (&expired_time(&get_time_from_index($index)));

	    &delmsg($index);
	    $IdxMinPg = 0;
	    $TIdxMinPg = 0;
	    $Update{$IndexNum{$array[0]}} = 1;		  # Update next
	    foreach (split(/$bs/o, $FollowOld{$index})) { # Update any replies
		$Update{$IndexNum{$_}} = 1;
	    }
	    $Update{$IndexNum{$TListOrder[$Index2TLoc{$index}-1]}} = 1;
	    $Update{$IndexNum{$TListOrder[$Index2TLoc{$index}+1]}} = 1;
	}
    }

    ## Set MListOrder
    @MListOrder = &sort_messages();

    ## Compute follow up messages with side-effect of setting %Index2MLoc
    $i = 0;
    foreach $index (@MListOrder) {
	$Index2MLoc{$index} = $i;  $i++;

	$FolCnt{$index} = 0  unless $FolCnt{$index};
	if (@array2 = split(/$X/o, $Refs{$index})) {
	    $tmp2 = $array2[$#array2];
	    next unless defined($IndexNum{$MsgId{$tmp2}});
	    $tmp = $MsgId{$tmp2};
	    if ($Follow{$tmp}) { $Follow{$tmp} .= $bs . $index; }
	    else { $Follow{$tmp} = $index; }
	    $FolCnt{$tmp}++;
	}
    }

    ##	Compute thread information (sets ThreadList, TListOrder, Index2TLoc)
    &compute_threads();

    ## Check for which messages to update when adding to archive
    if (!$IDXONLY && $ADD) {
	if ($UPDATE_ALL) {
	    foreach $index (@MListOrder) { $Update{$IndexNum{$index}} = 1; }
	    $IdxMinPg = 0;
	    $TIdxMinPg = 0;

	} else {
	    $i = 0;
	    foreach $index (@MListOrder) {
		## Check for New follow-up links
		if ($FollowOld{$index} ne $Follow{$index}) {
		    $Update{$IndexNum{$index}} = 1;
		}
		## Check if new message; must update links in prev/next msgs
		if ($AddIndex{$index}) {

		    # Mark where main index page updates start
		    if ($MULTIIDX) {
			$tmp = int($Index2MLoc{$index}/$IDXSIZE)+1;
			$IdxMinPg = $tmp
			    if ($tmp < $IdxMinPg || $IdxMinPg < 0);
		    }

		    # Mark previous/next messages
		    $Update{$IndexNum{$MListOrder[$i-1]}} = 1
			if $i > 0;
		    $Update{$IndexNum{$MListOrder[$i+1]}} = 1
			if $i < $#MListOrder;
		}
		## Check for New reference links
		foreach (split(/$X/o, $Refs{$index})) {
		    $tmp = $MsgId{$_};
		    if (defined($IndexNum{$tmp}) && $AddIndex{$tmp}) {
			$Update{$IndexNum{$index}} = 1;
		    }
		}
		$i++;
	    }
	    $i = 0;
	    foreach $index (@TListOrder) {
		## Check if new message; must update links in prev/next msgs
		if ($AddIndex{$index}) {

		    # Mark where thread index page updates start
		    if ($MULTIIDX) {
			$tmp = int($Index2TLoc{$index}/$IDXSIZE)+1;
			$TIdxMinPg = $tmp
			    if ($tmp < $TIdxMinPg || $TIdxMinPg < 0);
		    }

		    # Mark previous/next message in thread
		    $Update{$IndexNum{$TListOrder[$i-1]}} = 1
			if $i > 0;
		    $Update{$IndexNum{$TListOrder[$i+1]}} = 1
			if $i < $#TListOrder;
		}
		$i++;
	    }
	}
    }

    ##	Compute total number of pages
    $i = $NumOfPages;
    if ($MULTIIDX && $IDXSIZE) {
	$NumOfPages   = int($NumOfMsgs/$IDXSIZE);
	++$NumOfPages      if ($NumOfMsgs/$IDXSIZE) > $NumOfPages;
	$NumOfPages   = 1  if $NumOfPages == 0;
    } else {
	$NumOfPages = 1;
    }

    ## Update all pages for $LASTPG$
    if ($UsingLASTPG && ($i != $NumOfPages)) {
	$IdxMinPg = 0;
	$TIdxMinPg = 0;
    }

    ##------------##
    ## Write Data ##
    ##------------##
    &ign_signals();		# Ignore termination signals
    print STDOUT "\n"  unless $QUIET;

    ## Write indexes and mail
    if (!$IDXONLY) {
	&write_mail();
	&write_main_index()	if $MAIN;
	&write_thread_index()	if $THREAD;

    } elsif ($THREAD) {
	&write_thread_index();

    } elsif ($MAIN) {
	&write_main_index();
    }

    ## Write any alternate indexes
    if (!$IDXONLY) {

	## Write database
	print STDOUT "Writing database ...\n"  unless $QUIET;
	&output_db($DBPathName);

	$IdxMinPg = 0; $TIdxMinPg = 0;

	foreach $tmp (@OtherIdxs) {
	    $THREAD = 0;
	    $tmp = "${OUTDIR}${DIRSEP}$tmp"
		unless ($tmp =~ m%^/%) || (-e $tmp);

	    if (&read_fmt_file($tmp)) {
		if ($THREAD) {
		    &write_thread_index();
		} else {
		    &write_main_index();
		}
	    }
	}

	print STDOUT "$NumOfMsgs messages\n"  unless $QUIET;
    }

    1;
}

##---------------------------------------------------------------------------
##	Function to do scan feature.
##
sub scan {
    local($key, $num, $index, $day, $mon, $year, $from, $date,
	  $subject, $time, @array);

    print STDOUT "$NumOfMsgs messages in $OUTDIR:\n\n";
    print STDOUT sprintf("%5s  %s  %-15s  %-43s\n",
			 "Msg #", "YYYY/MM/DD", "From", "Subject");
    print STDOUT sprintf("%5s  %s  %-15s  %-43s\n",
			 "-" x 5, "----------", "-" x 15, "-" x 43);

    @array = &sort_messages();
    foreach $index (@array) {
	$date = &time2mmddyy((split(/$X/o, $index))[0], 'yyyymmdd');
	$num = $IndexNum{$index};
	$from = substr(&extract_email_name($From{$index}), 0, 15);
	$subject = substr($Subject{$index}, 0, 43);
	print STDOUT sprintf("%5d  %s  %-15s  %-43s\n",
			     $num, $date, $from, $subject);
    }
}

##---------------------------------------------------------------------------
##	Routine to perform conversion of a single mail message to
##	HTML.
##
sub single {
    local($mhead,$index,$from,$date,$sub,$header,$handle,$mesg,
	  $template,$filename,%fields);

    ## Prevent any verbose output
    $QUIET = 1;

    ## See where input is coming from
    if ($ARGV[0]) {
	($handle = &file_open($ARGV[0])) ||
	    die("ERROR: Unable to open $ARGV[0]\n");
	$filename = $ARGV[0];
    } else {
	$handle = 'STDIN';
    }

    ## Read header
    ($index,$from,$date,$sub,$header) =
	&read_mail_header($handle, *mhead, *fields);

    ($From{$index},$Date{$index},$Subject{$index}) = ($from,$date,$sub);
    $MsgHead{$index} = $mhead;

    ## Read rest of message
    $Message{$index} = &read_mail_body($handle, $index, $header, *fields);

    ## Output mail
    &output_mail($index, 1, 0);

    close($handle);
}

##---------------------------------------------------------------------------
##	Function for removing messages.
##
sub rmm {
    local(@numbers) = ();
    local($key, %Num2Index, $num);
    local($_);

    ## Create list of messages to remove
    foreach (@_) {
	# range
	if (/^(\d+)-(\d+)$/) {
	    push(@numbers, $1 .. $2);	# range op removes leading zeros
	    next;
	}
	# single number
	if (/^\d+$/) {
	    push(@numbers, int($_));	# int() removes leading zeros
	    next;
	}
	# probably message-id
	push(@numbers, $_);
    }

    if ($#numbers < 0) {
	die("ERROR: No messages specified\n");
    }

    ## Make hash to perform deletions
    foreach $key (keys %IndexNum) {
	$Num2Index{$IndexNum{$key}} = $key;
    }

    ## Remove messages
    foreach $num (@numbers) {
	# message number
	if (($num =~ /^\d+$/) && ($key = $Num2Index{$num})) {
	    &delmsg($key);
	    next;
	}

	# message-id
	$num =~ s/[<>]//g;  # remove <>'s in case message-id
	if ($key = $MsgId{$num}) {
	    &delmsg($key);
	    next;
	}

	# message not in archive
	warn qq/Warning: Message "$num" not in archive\n/;
    }
}

##---------------------------------------------------------------------------
sub delmsg {
    local($key) = @_;
    local($filename);
    local($pathname);

    &defineIndex2MsgId();
    $msgnum = $IndexNum{$key};  return 0  if ($msgnum eq '');
    $filename = join($DIRSEP, $OUTDIR, &msgnum_filename($msgnum));
    delete $ContentType{$key};
    delete $Date{$key};
    delete $From{$key};
    delete $IndexNum{$key};
    delete $Refs{$key};
    delete $Subject{$key};
    delete $MsgId{$Index2MsgId{$key}};
    &file_remove($filename);
    foreach $filename (split(/$X/o, $Derived{$key})) {
	$pathname = "${OUTDIR}${DIRSEP}${filename}";
	if (-d $pathname) {
	    &dir_remove($pathname);
	} else {
	    &file_remove("${OUTDIR}${DIRSEP}${filename}");
	}
    }
    delete $Derived{$key};
    $NumOfMsgs--;
    1;
}

##---------------------------------------------------------------------------
##	write_mail outputs converted mail.  It takes a reference to an
##	array containing indexes of messages to output.
##
sub write_mail {
    local($hack) = (0);
    print STDOUT "Writing mail "  unless $QUIET;

    if ($SLOW && !$ADD) {
	$ADD = 1;
	$hack = 1;
    }

    foreach $index (@MListOrder) {
	print STDOUT "."  unless $QUIET;
	&output_mail($index, $AddIndex{$index}, 0);
    }

    if ($hack) {
	$ADD = 0;
    }

    print STDOUT "\n"  unless $QUIET;
}

##---------------------------------------------------------------------------
##	write_main_index outputs main index of archive
##
sub write_main_index {
    local(@array) = ();
    local($outhandle, $i, $i_p0, $filename, $tmpl, $isfirst, $tmp,
	  $mlfh, $mlinfh);
    local(@a, $PageNum);

    @array = &sort_messages();

    for ($PageNum = 1; $PageNum <= $NumOfPages; $PageNum++) {
	if ($MULTIIDX) {
	    @a = splice(@array, 0, $IDXSIZE);
	}
	next  if $PageNum < $IdxMinPg;

	$isfirst = 1;

	if ($MULTIIDX) {
	    if ($PageNum > 1) {
		$IDXPATHNAME = join("", $OUTDIR, $DIRSEP,
				    $IDXPREFIX, $PageNum, ".", $HtmlExt);
	    } else {
		$IDXPATHNAME = ${OUTDIR} . ${DIRSEP} . ${IDXNAME};
	    }
	} else {
	    if ($IDXSIZE && (($i = ($#array+1) - $IDXSIZE) > 0)) {
		if ($REVSORT) {
		    splice(@array, $IDXSIZE);
		} else {
		    splice(@array, 0, $i);
		}
	    }
	    $IDXPATHNAME = ${OUTDIR} . ${DIRSEP} . ${IDXNAME};
	    *a = *array;
	}
	    
	## Open/create index file
	if ($ADD) {
	    if (&file_exists($IDXPATHNAME)) {
		&file_copy($IDXPATHNAME, "${OUTDIR}${DIRSEP}tmp.$$");
		($mlinfh = &file_open("${OUTDIR}${DIRSEP}tmp.$$"))
		    || die("ERROR: Unable to open ${OUTDIR}${DIRSEP}tmp.$$\n");
		$MLCP = 1;
	    } else {
		$MLCP = 0;
	    }
	}
	if ($IDXONLY) {
	   $outhandle = STDOUT;
	} else {
	    ($outhandle = &file_create($IDXPATHNAME, $GzipFiles)) ||
		die("ERROR: Unable to create $IDXPATHNAME\n");
	}
	print STDOUT "Writing $IDXPATHNAME ...\n"  unless $QUIET;

	## Print top part of index
	&output_maillist_head($outhandle, $mlinfh);

	## Output links to messages

	if ($NOSORT) {
	    foreach $index (@a) {
		($tmpl = $LITMPL) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
		print $outhandle $tmpl;
	    }

	} elsif ($SUBSORT) {
	    local($prevsub) = '';
	    foreach $index (@a) {
		if (($tmp = &get_base_subject($index)) ne $prevsub) {
		    $prevsub = $tmp;
		    if (!$isfirst) {
			($tmpl = $SUBJECTEND) =~
				s/$VarExp/&replace_li_var($1,$index)/geo;
			print $outhandle $tmpl;
		    } else {
			$isfirst = 0;
		    }
		    ($tmpl = $SUBJECTBEG) =~
			s/$VarExp/&replace_li_var($1,$index)/geo;
		    print $outhandle $tmpl;
		}
		($tmpl = $LITMPL) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
		print $outhandle $tmpl;
	    }
	    ($tmpl = $SUBJECTEND) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	    print $outhandle $tmpl;

	} elsif ($AUTHSORT) {
	    local($prevauth) = '';
	    foreach $index (@a) {
		if (($tmp = &get_base_author($index)) ne $prevauth) {
		    $prevauth = $tmp;
		    if (!$isfirst) {
			($tmpl = $AUTHEND) =~
			    s/$VarExp/&replace_li_var($1,$index)/geo;
			print $outhandle $tmpl;
		    } else {
			$isfirst = 0;
		    }
		    ($tmpl = $AUTHBEG) =~
			s/$VarExp/&replace_li_var($1,$index)/geo;
		    print $outhandle $tmpl;
		}
		($tmpl = $LITMPL) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
		print $outhandle $tmpl;
	    }
	    ($tmpl = $AUTHEND) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	    print $outhandle $tmpl;

	} else {
	    local($prevdate) = '';
	    local($time);
	    foreach $index (@a) {
		$time = &get_time_from_index($index);
		$tmp = join("", (localtime($time))[3,4,5]);
		if ($tmp ne $prevdate) {
		    $prevdate = $tmp;
		    if (!$isfirst) {
			($tmpl = $DAYEND) =~
			    s/$VarExp/&replace_li_var($1,$index)/geo;
			print $outhandle $tmpl;
		    } else {
			$isfirst = 0;
		    }
		    ($tmpl = $DAYBEG) =~
			s/$VarExp/&replace_li_var($1,$index)/geo;
		    print $outhandle $tmpl;
		}
		($tmpl = $LITMPL) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
		print $outhandle $tmpl;
	    }
	    ($tmpl = $DAYEND) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	    print $outhandle $tmpl;
	}

	## Print bottom part of index
	&output_maillist_foot($outhandle, $mlinfh);
	close($outhandle)  unless $IDXONLY;
	if ($MLCP) {
	    close($mlinfh);
	    &file_remove("${OUTDIR}${DIRSEP}tmp.$$");
	}
    }
}

##---------------------------------------------------------------------------
##	read_mail_header() is responsible for parsing the header of
##	a mail message.
##
sub read_mail_header {
    local($handle, *mesg, *fields) = @_;
    local(%l2o, $header, $index, $from, $sub, $date, $tmp, $msgid,
	  @refs, @array);

    $header = &readmail'MAILread_file_header($handle, *fields, *l2o);
    @refs = ();
    @array = ();

    ##------------##
    ## Get Msg-ID ##
    ##------------##
    $msgid = $fields{'message-id'} || $fields{'msg-id'} || 
	     $fields{'content-id'};
    if (!($msgid =~ s/\s*<([^>]*)>\s*/$1/g)) {
	$msgid =~ s/^\s*//;
	$msgid =~ s/\s*$//;
    }

    ## Return if message already exists in archive ##
    if ($msgid && defined($MsgId{$msgid})) {
	return ("", "", "", "", "");
    }

    ##----------##
    ## Get date ##
    ##----------##
    $date = "";  $index = "";
    foreach (@DateFields) {
	next  unless $fields{$_};

	## Treat received field specially
	if ($_ eq 'received') {
	    @array = split(/;/,
			   (split(/$readmail'FieldSep/o, $fields{$_}))[0]);
	    $date = pop @array;
	## Any other field should just be a date
	} else {
	    $date = (split(/$readmail'FieldSep/o, $fields{$_}))[0];
	}

	## See if time_t can be determined.
	if (($date =~ /\w/) && (@array = &parse_date($date))) {
	    $index = &get_time_from_date(@array[1..$#array]);
	    last;
	}
    }
    if ($index eq "") {
	warn "\nWarning: Could not parse date for message\n",
	     "         Message-Id: <$msgid>\n";
	$date  = "" unless $date =~ /\S/;
	$index = time;	# Use current time
    }

    ## Return if message too old to add ##
    if (&expired_time($index)) {
	return ("", "", "", "", "");
    }

    ##-------------##
    ## Get Subject ##
    ##-------------##
    if ($fields{'subject'} !~ /^\s*$/) {
	($sub = $fields{'subject'}) =~ s/\s*$//;
    } else {
	$sub = 'No Subject';
    }

    ##----------##
    ## Get From ##
    ##----------##
    $from = "";
    foreach (@FromFields) {
	next  unless $fields{$_};
	$from = $fields{$_};
	last;
    }
    $from = 'No Author'  unless $from;

    ##----------------##
    ## Get References ##
    ##----------------##
    $tmp = $fields{'references'};
    while ($tmp =~ s/<([^>]+)>//) {
	push(@refs, $1);
    }
    $tmp = $fields{'in-reply-to'};
    if ($tmp =~ s/^[^<]*<([^>]*)>.*$/$1/) {
	push(@refs, $tmp)  unless $tmp =~ /^\s*$/;
    }

    ##------------------------##
    ## Create HTML for header ##
    ##------------------------##
    $mesg .= &htmlize_header(*fields, *l2o);

    ## Insure uniqueness of msg-id
    $index .= $X . sprintf("%d",$LastMsgNum+1);

    if ($fields{'content-type'}) {
	($tmp = $fields{'content-type'}) =~ m%^\s*([\w-\./]+)%;
	$tmp = $1 || 'text/plain';
	$tmp =~ tr/A-Z/a-z/;
    } else {
	$tmp = 'text/plain';
    }
    $ContentType{$index} = $tmp;

    if ($msgid) {
	$MsgId{$msgid} = $index;
	$NewMsgId{$msgid} = $index;	# Track new message-ids
    }
    &remove_dups(*refs);                # Remove duplicate msg-ids
    $Refs{$index} = join($X, @refs)  if (@refs);

    ($index,$from,$date,$sub,$header);
}

##---------------------------------------------------------------------------
##	read_mail_body() reads in the body of a message.  The returned
##	filtered body is in $ret.
##
sub read_mail_body {
    local($handle, $index, $header, *fields, $skip) = @_;
    local($ret, $data) = ('', '');
    local(@files) = ();

    ## Define "globals" for use by filters
    ##	NOTE: This stuff can be handled better, and will be done
    ##	      when/if I get around to rewriting mhonarc in Perl 5.
    ##
    $MHAmsgnum = &fmt_msgnum($IndexNum{$index}) unless $skip;

    ## Slurp of message body
    ##	UUCP mailbox
    if ($MBOX) {
	if ($CONLEN && $fields{"content-length"}) { # Check for content-length
	    local($len, $cnt) = ($fields{"content-length"}, 0);
	    if ($len) {
		while (<$handle>) {
		    $cnt += length($_);			# Increment byte count
		    $data .= $_;			# Save data
		    last  if $cnt >= $len		# Last if hit length
		}
	    }
	    # Slurp up bogus data if required (should I do this?)
	    while (!/$FROM/o && !eof($handle)) {
		$_ = <$handle>;
	    }

	} else {				    # No content-length
	    while (<$handle>) {
		last  if /$FROM/o;
		$data .= $_;
	    }
	}

    ##	MH message file
    } else {
	while (<$handle>) {
	    $data .= $_;
	}
    }

    ## Filter data
    return ''  if $skip;
    $fields{'content-type'} = 'text/plain'
	if $fields{'content-type'} =~ /^\s*$/;
    ($ret, @files) = &readmail'MAILread_body($header, $data,
				    $fields{'content-type'},
				    $fields{'content-transfer-encoding'});
    $ret = join('',
		"<DL>\n",
		"<DT><STRONG>Warning</STRONG></DT>\n",
		"<DD>Could not process message with given Content-Type: \n",
		"<CODE>", $fields{'content-type'}, "</CODE>\n",
		"</DD>\n",
		"</DL>\n"
		)  unless $ret;
    if (@files) {
	$Derived{$index} = join($X, @files);
    }
    $ret;
}

##---------------------------------------------------------------------------
##	Output/edit a mail message.
##	    $index	=> current index (== $array[$i])
##	    $force	=> flag if mail is written and not editted, regardless
##	    $nocustom	=> ignore sections with user customization
##
sub output_mail {
    local($index, $force, $nocustom) = @_;
    local($msgi, $tmp, $tmp2, $template, @array2);
    local($filepathname, $tmppathname, $i_p0, $filename, $msghandle,
	  $msginfh, $drvfh);
    local($adding) = ($ADD && !$force && !$SINGLE);

    $i_p0 = &fmt_msgnum($IndexNum{$index});

    $filename     = &msgnum_filename($IndexNum{$index});
    $filepathname = join($DIRSEP, $OUTDIR, $filename);
    $tmppathname  = join($DIRSEP, $OUTDIR, "msgtmp.$$");

    if ($adding) {
	return ($i_p0,$filename)  unless $Update{$IndexNum{$index}};
	&file_copy($filepathname, $tmppathname);
	($msginfh = &file_open($tmppathname)) ||
	    die("ERROR: Unable to open $tmppathname\n");
    }
    if ($SINGLE) {
	$msghandle = 'STDOUT';
    } else {
	($msghandle = &file_create($filepathname, $GzipFiles)) ||
	    die("ERROR: Unable to create $filepathname\n");
    }

    ## Output HTML header
    if ($adding) {
	while (<$msginfh>) {
	    last  if /<!--X-Body-Begin/;
	}
    }
    if (!$nocustom) {
	&defineIndex2MsgId();

	# Output comments -- more informative, but can be used for
	#		     error recovering.
	print $msghandle 
		      "<!-- ",
		      &commentize("MHonArc v$VERSION"), " -->\n",
		      "<!--X-Subject: ",
		      &commentize($Subject{$index}), " -->\n",
		      "<!--X-From: ",
		      &commentize($From{$index}), " -->\n",
		      "<!--X-Date: ",
		      &commentize($Date{$index}), " -->\n",
		      "<!--X-Message-Id: ",
		      &commentize($Index2MsgId{$index}), " -->\n",
		      "<!--X-ContentType: ",
		      &commentize($ContentType{$index}), " -->\n";
	foreach (split(/$X/o, $Refs{$index})) {
	    print $msghandle
		      "<!--X-Reference-Id: ", &commentize($_), " -->\n";
	}
	print $msghandle "<!--X-Head-End-->\n";

	# Add in user defined markup
	($template = $MSGPGBEG) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
    }
    print $msghandle "<!--X-Body-Begin-->\n";

    ## Output header
    if ($adding) {
	while (<$msginfh>) {
	    last  if /<!--X-User-Header-End/ || /<!--X-TopPNI--/;
	}
    }
    print $msghandle "<!--X-User-Header-->\n";
    if (!$nocustom) {
	($template = $MSGHEAD) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
    }
    print $msghandle "<!--X-User-Header-End-->\n";

    ## Output Prev/Next/Index links at top
    if ($adding) {
	while (<$msginfh>) { last  if /<!--X-TopPNI-End/; }
    }
    print $msghandle "<!--X-TopPNI-->\n";
    if (!$nocustom && !$SINGLE) {
	($template = $TOPLINKS) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
    }
    print $msghandle "\n<!--X-TopPNI-End-->\n";

    ## Output message body
    if ($adding) {
	$tmp2 = '';
	while (<$msginfh>) {
	    $tmp2 .= $_;
	    last  if /<!--X-MsgBody-End/;
	}
	$tmp2 =~ s%($AddrExp)%&link_refmsgid($1,1)%geo;
	print $msghandle $tmp2;

    } else {
	print $msghandle "<!--X-MsgBody-->\n";
	print $msghandle "<!--X-Subject-Header-Begin-->\n";
	($template = $SUBJECTHEADER) =~
	    s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
	print $msghandle "<!--X-Subject-Header-End-->\n";

	$MsgHead{$index} =~ s%($AddrExp)%&link_refmsgid($1)%geo;
	$Message{$index} =~ s%($AddrExp)%&link_refmsgid($1)%geo;

	print $msghandle $MsgHead{$index};
	print $msghandle "<!--X-Head-Body-Sep-Begin-->\n";
	($template = $HEADBODYSEP) =~
	    s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
	print $msghandle "<!--X-Head-Body-Sep-End-->\n";
	print $msghandle "<!--X-Body-of-Message-->\n";
	print $msghandle $Message{$index}, "\n";
	print $msghandle "<!--X-Body-of-Message-End-->\n";
	print $msghandle "<!--X-MsgBody-End-->\n";
    }

    ## Output any followup messages
    if ($adding) {
	while (<$msginfh>) { last  if /<!--X-Follow-Ups-End/; }
    }
    print $msghandle "<!--X-Follow-Ups-->\n";
    ($template = $MSGBODYEND) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
    print $msghandle $template;
    if (!$nocustom && $DoFolRefs) {
	@array2 = split(/$bs/o, $Follow{$index});
	if ($#array2 >= 0) {
	    ($template = $FOLUPBEGIN) =~
		s/$VarExp/&replace_li_var($1,$index)/geo;
	    print $msghandle $template;
	    foreach (@array2) {
		($template = $FOLUPLITXT) =~
		    s/$VarExp/&replace_li_var($1,$_)/geo;
		print $msghandle $template;
	    }
	    ($template = $FOLUPEND) =~
		s/$VarExp/&replace_li_var($1,$index)/geo;
	    print $msghandle $template;
	}
    }
    print $msghandle "<!--X-Follow-Ups-End-->\n";

    ## Output any references
    if ($adding) {
	while (<$msginfh>) { last  if /<!--X-References-End/; }
    }
    print $msghandle "<!--X-References-->\n";
    if (!$nocustom && $DoFolRefs) {
	@array2 = split(/$X/o, $Refs{$index});
	$tmp2 = 0;	# flag for when first ref printed
	if ($#array2 >= 0) {
	    foreach (@array2) {
		if (defined($IndexNum{$MsgId{$_}})) {
		    if (!$tmp2) {
			($template = $REFSBEGIN) =~
			    s/$VarExp/&replace_li_var($1,$index)/geo;
			print $msghandle $template;
			$tmp2 = 1;
		    }
		    ($template = $REFSLITXT) =~
			s/$VarExp/&replace_li_var($1,$MsgId{$_})/geo;
		    print $msghandle $template;
		}
	    }
	    if ($tmp2) {
		($template = $REFSEND) =~
		    s/$VarExp/&replace_li_var($1,$index)/geo;
		print $msghandle $template;
	    }
	}
    }
    print $msghandle "<!--X-References-End-->\n";

    ## Output verbose links to prev/next message in list
    if ($adding) {
	while (<$msginfh>) { last  if /<!--X-BotPNI-End/; }
    }
    print $msghandle "<!--X-BotPNI-->\n";
    if (!$nocustom && !$SINGLE) {
	($template = $BOTLINKS) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
    }
    print $msghandle "\n<!--X-BotPNI-End-->\n";

    ## Output footer
    if ($adding) {
	while (<$msginfh>) {
	    last  if /<!--X-User-Footer-End/;
	}
    }
    print $msghandle "<!--X-User-Footer-->\n";
    if (!$nocustom) {
	($template = $MSGFOOT) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
    }
    print $msghandle "<!--X-User-Footer-End-->\n";

    if (!$nocustom) {
	($template = $MSGPGEND) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	print $msghandle $template;
    }

    close($msghandle)  if (!$SINGLE);
    if ($adding) {
	close($msginfh);
	&file_remove($tmppathname);
    }

    ## Create user defined files
    foreach (keys %UDerivedFile) {
	($tmp = $_) =~ s/$VarExp/&replace_li_var($1,$index)/geo;
	$tmp2 = join($DIRSEP, $OUTDIR, $tmp);
	if ($drvfh = &file_create($tmp2, $GzipFiles)) {
	    ($template = $UDerivedFile{$_}) =~
		s/$VarExp/&replace_li_var($1,$index)/geo;
	    print $drvfh $template;
	    close($drvfh);
	    if ($Derived{$index}) {
		$Derived{$index} .= $X . $tmp;
	    } else {
		$Derived{$index} = $tmp;
	    }
	} else {
	    warn "Warning: Unable to create $tmp2\n";
	}
    }
    if (@array2 = split(/$X/o, $Derived{$index})) {
	&remove_dups(*array2);
	$Derived{$index} = join($X, @array2);
    }

    ## Set modification times -- Use eval incase OS does not support utime.
    if ($MODTIME && !$SINGLE) {
	eval q%
	    $tmp = &get_time_from_index($index);
	    @array2 = split(/$X/o, $Derived{$index});
	    grep($_ = $OUTDIR . $DIRSEP . $_, @array2);
	    unshift(@array2, $filepathname);
	    &file_utime($tmp, $tmp, @array2);
	%;
    }

    ($i_p0, $filename);
}

##---------------------------------------------------------------------------
##	Routine to convert a msgid to an anchor
##
sub link_refmsgid {
    local($refmsgid, $onlynew) = @_;

    if (defined($IndexNum{$MsgId{$refmsgid}}) &&
	(!$onlynew || $NewMsgId{$refmsgid})) {
	local($lreftmpl) = $MSGIDLINK;
	$lreftmpl =~ s/$VarExp/&replace_li_var($1,$MsgId{$refmsgid})/geo;
	$lreftmpl;
    } else {
	$refmsgid;
    }
}

##---------------------------------------------------------------------------
##	output_maillist_head() outputs the beginning of the index page.
##
sub output_maillist_head {
    local($handle, $cphandle) = @_;
    local($tmp, $index, $headfh);
    $index = "";

    print $handle "<!-- ", &commentize("MHonArc v$VERSION"), " -->\n";

    ## Output title
    ($tmp = $IDXPGBEG) =~ s/$VarExp/&replace_li_var($1,'')/geo;
    print $handle $tmp;
    print $handle "<!--X-ML-Title-H1-End-->\n";

    if ($MLCP) {
	while (<$cphandle>) { last  if /<!--X-ML-Title-H1-End/; }
    }

    ## Output header file
    if ($HEADER) {				# Read external header
	print $handle "<!--X-ML-Header-->\n";
	if ($headfh = &file_open($HEADER)) {
	    while (<$headfh>) { print $handle $_; }
	    close($headfh);
	} else {
	    warn "Warning: Unable to open header: $HEADER\n";
	}
	if ($MLCP) {
	    while (<$cphandle>) { last  if /<!--X-ML-Header-End/; }
	}
	print $handle "<!--X-ML-Header-End-->\n";
    } elsif ($MLCP) {				# Preserve maillist header
	while (<$cphandle>) {
	    print $handle $_;
	    last  if /<!--X-ML-Header-End/;
	}
    } else {					# No header
	print $handle "<!--X-ML-Header-->\n",
		      "<!--X-ML-Header-End-->\n";
    }

    print $handle "<!--X-ML-Index-->\n";
    ($tmp = $LIBEG) =~ s/$VarExp/&replace_li_var($1,'')/geo;
    print $handle $tmp;
}

##---------------------------------------------------------------------------
##	output_maillist_foot() outputs the end of the index page.
##
sub output_maillist_foot {
    local($handle, $cphandle) = @_;
    local($tmp, $index, $footfh);
    $index = "";

    ($tmp = $LIEND) =~ s/$VarExp/&replace_li_var($1,'')/geo;
    print $handle $tmp;
    print $handle "<!--X-ML-Index-End-->\n";

    ## Skip past index in old maillist file
    if ($MLCP) {
	while (<$cphandle>) { last  if /<!--X-ML-Index-End/; }
    }

    ## Output footer file
    if ($FOOTER) {				# Read external footer
	print $handle "<!--X-ML-Footer-->\n";
	if ($footfh = &file_open($FOOTER)) {
	    while (<$footfh>) { print $handle $_; }
	    close($footfh);
	} else {
	    warn "Warning: Unable to open footer: $FOOTER\n";
	}
	if ($MLCP) {
	    while (<$cphandle>) { last  if /<!--X-ML-Footer-End/; }
	}
	print $handle "<!--X-ML-Footer-End-->\n";
    } elsif ($MLCP) {				# Preserve maillist footer
	while (<$cphandle>) {
	    print $handle $_;
	    last  if /<!--X-ML-Footer-End/;
	}
    } else {					# No footer
	print $handle "<!--X-ML-Footer-->\n",
		      "<!--X-ML-Footer-End-->\n";
    }

    &output_doclink($handle);

    ## Close document
    ($tmp = $IDXPGEND) =~ s/$VarExp/&replace_li_var($1,'')/geo;
    print $handle $tmp;

    print $handle "<!-- ", &commentize("MHonArc v$VERSION"), " -->\n";
}

##---------------------------------------------------------------------------
##	Output link to documentation, if specified
##
sub output_doclink {
    local($handle) = ($_[0]);
    if (!$NODOC && $DOCURL) {
	print $handle "<HR>\n";
	print $handle
		"<ADDRESS>\n",
		"Mail converted by ",
		qq|<A HREF="$DOCURL"><CODE>MHonArc</CODE></A> $VERSION\n|,
		"</ADDRESS>\n";
    }
}

#############################################################################
## Miscellaneous routines
#############################################################################
##---------------------------------------------------------------------------
sub getNewMsgNum {
    $NumOfMsgs++; $LastMsgNum++;
    $LastMsgNum;
}

##---------------------------------------------------------------------------
##	ign_signals() sets mhonarc to ignore termination signals.  This
##	routine is called right before an archive is written/editted to
##	help prevent archive corruption.
##
sub ign_signals {
    $SIG{'ABRT'} = 'IGNORE';
    $SIG{'HUP'}  = 'IGNORE';
    $SIG{'INT'}  = 'IGNORE';
    $SIG{'PIPE'} = 'IGNORE';
    $SIG{'QUIT'} = 'IGNORE';
    $SIG{'TERM'} = 'IGNORE';
    $SIG{'USR1'} = 'IGNORE';
    $SIG{'USR2'} = 'IGNORE';
}

##---------------------------------------------------------------------------
##	set_handler() sets up the quit() routine to be called when
##	a termination signal is sent to mhonarc.
##
sub set_handler {
    $SIG{'ABRT'} = q/mhonarc'quit/;
    $SIG{'HUP'}  = q/mhonarc'quit/;
    $SIG{'INT'}  = q/mhonarc'quit/;
    $SIG{'PIPE'} = q/mhonarc'quit/;
    $SIG{'QUIT'} = q/mhonarc'quit/;
    $SIG{'TERM'} = q/mhonarc'quit/;
    $SIG{'USR1'} = q/mhonarc'quit/;
    $SIG{'USR2'} = q/mhonarc'quit/;
}

##---------------------------------------------------------------------------
##	Routine to clean up stuff
##
sub clean_up {
    &remove_lock_file();
    $EndTime = (times)[0];
    local($cputime) = $EndTime - $StartTime;
    if ($TIME) {
	printf(STDERR "\nTime: %.2f CPU seconds\n", $cputime);
    }
    $cputime;
}

##---------------------------------------------------------------------------
##	Quit execution
##
sub quit {
    &clean_up();
    exit 0;
}

##---------------------------------------------------------------------------
##	Create Index2MsgId if not defined
##
sub defineIndex2MsgId {
    if (!defined(%Index2MsgId)) {
	foreach (keys %MsgId) {
	    $Index2MsgId{$MsgId{$_}} = $_;
	}
    }
}

##---------------------------------------------------------------------------
1;
