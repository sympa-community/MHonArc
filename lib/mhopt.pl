##---------------------------------------------------------------------------##
##  File:
##      @(#) mhopt.pl 2.3 98/03/03 15:09:40
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##      Routines to set options for MHonArc.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1997-1998	Earl Hood, ehood@medusa.acs.uci.edu
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
##	get_cli_opts() is responsible for grabbing command-line options
##	and also settings the resource file.
##
sub get_cli_opts {
    local($tmp, @array);

    die(qq{Try "$PROG -help" for usage information\n}) unless
    &NGetOpt(
	"add",		# Add a message to archive
	"authsort",	# Sort by author
	"archive",	# Create an archive (the default)
	"conlen",	# Honor Content-Length fields
	"datefields=s",	# Fields that contains the date of a message
	"dbfile=s",	# Database/state filename for mhonarc archive
	"decodeheads",	# Decode all 1522 encoded data in message headers
	"definevars=s",	# Define custom resource variables
	"doc",		# Print link to doc at end of index page
	"docurl=s",	# URL to mhonarc documentation
	"editidx",	# Change index page layout only
	"expiredate=s",	# Message cut-off date
	"expireage=i",	# Time in seconds from current if message expires
	"folrefs",	# Print links to explicit follow-ups/references
	"footer=s",	# File containing user text for bottom of index page
	"force",	# Perform archive operation even if unable to lock
	"fromfields=s",	# Fields that contains the "from" of a message
	"genidx",	# Generate an index based upon archive contents
	"gmtdatefmt=s",	# Date specification for GMT date
	"gzipexe=s",	# Pathname of Gzip executable
	"gzipfiles",	# Gzip files
	"gziplinks",	# Add ".gz" extensions to files
	"header=s",	# File containing user text for top of index page
	"htmlext=s",	# Extension for HTML files
	"idxfname=s",	# Filename of index page
	"idxprefix=s",	# Filename prefix for multi-page main index
	"idxsize=i",	# Maximum number of messages shown in indexes
	"localdatefmt=s", # Date specification for local date
	"lockdelay=i",	# Time delay in seconds between lock tries
	"locktries=i",	# Number of tries in locking an archive
	"mailtourl=s",	# URL to use for e-mail address hyperlinks
	"main",		# Create a main index
	"maxsize=i",	# Maximum number of messages allowed in archive
	"mbox",		# Use mailbox format		(ignored now)
	"mh",		# Use MH mail folders format	(ignored now)
	"mhpattern=s",	# Regular expression for message files in a directory
	"modtime",	# Set modification time on files to message date
	"months=s",	# Month names
	"monthsabr=s",	# Abbreviated month names
	"msgsep=s",	# Message separator for mailbox files
	"msgprefix=s",	# Filename prefix for message files
	"multipg",	# Generate multi-page indexes
	"news",		# Add links to newsgroups
	"noauthsort",	# Do not sort by author
	"noarchive",	# Do not create an archive
	"noconlen",	# Ignore Content-Length fields
	"nodecodeheads",# Do not decode all 1522 encoded data in message headers
	"nodoc",	# Do not print link to doc at end of index page
	"nofolrefs",	# Do not print links to explicit follow-ups/references
	"nogzipfiles",	# Do not Gzip files
	"nogziplinks",	# Do not add ".gz" extensions to files
	"nomailto",	# Do not add in mailto links for e-mail addresses
	"nomain",	# Do not create a main index
	"nomodtime",	# Do no set modification time on files to message date
	"nomultipg",	# Do not generate multi-page indexes
	"nonews",	# Do not add links to newsgroups
	"noreverse",	# List messages in normal order
	"nosort",	# Do not sort
	"nosubsort",	# Do not sort by subject
	"nothread",	# Do not create threaded index
	"notreverse",	# List oldest thread first
	"nourl",	# Do not make URL hyperlinks
	"otherindexes=s", # List of other rcfiles for extra indexes
	"outdir=s",	# Destination of HTML files
	"perlinc=s",	# List of paths to search for MIME filters
	"quiet",	# No status messages while running
	"rcfile=s",	# Resource file for mhonarc
	"reverse",	# List messages in reverse order
	"rmm",		# Remove messages from an archive
	"savemem",	# Write message data while processing
	"scan",		# List out archive contents to terminal
	"single",	# Convert a single message to HTML
	"sort",		# Sort messages in increasing date order
	"subjectarticlerxp=s",	# Regex for leading articles in subjects
	"subjectreplyrxp=s",	# Regex for leading reply string in subjects
	"subsort",	# Sort message by subject
	"tidxfname=s",	# File name of threaded index page
	"tidxprefix=s",	# Filename prefix for multi-page thread index
	"time",		# Print processing time
	"title=s",	# Title of index page
	"ttitle=s",	# Title of threaded index page
	"thread",	# Create threaded index
	"tlevels=i",	# Maximum # of nested lists in threaded index
	"treverse",	# Reverse order of thread listing
	"tslice=s",	# Set size of thread slice listing
	"tsort",	# List threads by date
	"tnosort",	# List threads by ordered processed
	"tsubsort",	# List threads by subject
	"tnosubsort",	# Do not list threads by subject
	"umask=i",	# Set umask of process
	"url",		# Make URL hyperlinks
	"weekdays=s",	# Weekday names
	"weekdaysabr=s",# Abbreviated weekday names

	"v",		# Version information
	"help"		# A brief usage message
    );

    ## Check for help/version options (nothing to do)
    if (defined($opt_help)) {
	&usage();
	return 0;
    }
    if (defined($opt_v)) {
	&version();
	return 0;
    }

    ## These options have NO resource file equivalent.
    ##
    $ADD     = defined($opt_add);
    $RMM     = defined($opt_rmm);
    $SCAN    = defined($opt_scan);
    $QUIET   = defined($opt_quiet);
    $EDITIDX = defined($opt_editidx);
    if (defined($opt_genidx)) {
	$IDXONLY  = 1;  $QUIET = 1;
    } else {
	$IDXONLY  = 0;
    }
    if (defined($opt_single) && !$RMM) {
	$SINGLE  = 1;  $QUIET = 1;
    } else {
	$SINGLE = 0;
    }

    ## Check argv
    &usage() unless ($#ARGV >= 0) || $ADD || $SINGLE ||
		    $EDITIDX || $SCAN || $IDXONLY;

    ## Require needed libraries
    require 'timelocal.pl' || die("ERROR: Unable to require timelocal.pl\n");
    require 'ewhutil.pl'   || die("ERROR: Unable to require ewhutil.pl\n");
    require 'mhinit.pl'    || die("ERROR: Unable to require mhinit.pl\n");
    require 'mhtime.pl'    || die("ERROR: Unable to require mhtime.pl\n");
    require 'mhfile.pl'    || die("ERROR: Unable to require mhfile.pl\n");
    require 'mhutil.pl'    || die("ERROR: Unable to require mhutil.pl\n");

    if ($DefRcFile) {
	&read_fmt_file($DefRcFile);
    } else {
	$tmp = $ENV{'HOME'} . $DIRSEP . $DefRcName;
	$tmp = $INC[0] . $DIRSEP . $DefRcName  unless (-e $tmp);
	if (-e $tmp) {
	    &read_fmt_file($tmp);
	}
    }

    ## Grab a few options
    $FMTFILE   = $opt_rcfile     if $opt_rcfile;
    $LOCKTRIES = $opt_locktries  if ($opt_locktries > 0);
    $LOCKDELAY = $opt_lockdelay  if ($opt_lockdelay > 0);
    $FORCELOCK = defined($opt_force);

    ## These options must be grabbed before reading the database file
    ## since these options may tells us where the database file is.
    ##
    $OUTDIR  = $opt_outdir    if $opt_outdir;
	if (!$SINGLE &&
	    (!(-r $OUTDIR) || !(-w $OUTDIR) || !(-x $OUTDIR))) {
	    die("ERROR: Unable to access $OUTDIR\n");
	}
    $DBFILE  = $opt_dbfile    if $opt_dbfile;

    ## Create lockfile
    ##
    $LOCKFILE  = "${OUTDIR}${DIRSEP}${LOCKFILE}";
    if (!$SINGLE && !&create_lock_file($LOCKFILE, 1, 0, 0)) {
	print STDOUT "Trying to lock mail archive in $OUTDIR ...\n"
	    unless $QUIET;
	if (!&create_lock_file($LOCKFILE,
			       $LOCKTRIES-1,
			       $LOCKDELAY,
			       $FORCELOCK)) {
	    die("ERROR: Unable to create $LOCKFILE after $LOCKTRIES tries\n");
	}
    }

    ## Race condition exists: if process is terminated before termination
    ## handlers set, lock file will not get removed.
    ##
    &set_handler();

    ## Check if we need to access database file
    ##
    if ($ADD || $EDITIDX || $RMM || $SCAN || $IDXONLY) {
	$DBFILE = ".mail2html.db"
	    unless (-e "${OUTDIR}${DIRSEP}${DBFILE}") ||
		   (!-e "${OUTDIR}${DIRSEP}.mail2html.db");
	$DBPathName = join($DIRSEP, $OUTDIR, $DBFILE);
	if (-e $DBPathName) {
	    print STDOUT "Reading database ...\n"  unless $QUIET;
	    require $DBPathName ||
		die("ERROR: Database read error of $DBPathName\n");
	    if ($VERSION ne $DbVERSION) {
		warn "Warning: Database ($DbVERSION) != ",
		     "program ($VERSION) version.\n";
	    }

	    ## Check for 1.x archive, and update data as needed
	    if ($DbVERSION =~ /^1\./) {
		print STDOUT "Updating database data to 2.0 ...\n"
		    unless $QUIET;
		&update_data_1_to_2();
	    }
	}
	if ($#ARGV < 0) { $ADDSINGLE = 1; }	# See if adding single mesg
	else { $ADDSINGLE = 0; }
	$ADD = 'STDIN';
    }
    local($OldMULTIIDX) = $MULTIIDX;

    ## Remove lock file if scanning messages
    ##
    if ($SCAN) {
	&remove_lock_file();
    }

    ##	Read resource file (I initially used the term 'format file').
    ##	Look for resource in outdir if not absolute path or not
    ##	existing according to current value.
    ##
    if ($FMTFILE) {
	$FMTFILE = join($DIRSEP, $OUTDIR, $FMTFILE)
	    unless ($FMTFILE =~ m%^/%) || (-e $FMTFILE);
	&read_fmt_file($FMTFILE);
    }

    ## Check if extension for HTML files defined on the command-line
    $HtmlExt = $opt_htmlext  if defined($opt_htmlext);

    $RFC1522 = 1;	# Always True

    unshift(@OtherIdxs, split(/$PATHSEP/o, $opt_otherindexes))
						if defined($opt_otherindexes);
    unshift(@PerlINC, split(/$PATHSEP/o, $opt_perlinc))
						if defined($opt_perlinc);
    &remove_dups(*OtherIdxs);
    &remove_dups(*PerlINC);

    ## Require MIME filters and other libraries
    ##
    unshift(@INC, @PerlINC);
    if (!$SCAN) {
	## Require readmail library
	require 'readmail.pl' || die("ERROR: Unable to require readmail.pl\n");
	$readmail'FormatHeaderFunc = "mhonarc'htmlize_header";
	$MHeadCnvFunc = "readmail'MAILdecode_1522_str";
    }

    ## Get other command-line options
    ##
    $DBFILE	= $opt_dbfile     if $opt_dbfile; # Set again to override db
	$DBPathName = join($DIRSEP, $OUTDIR, $DBFILE);
    $DOCURL	= $opt_docurl     if $opt_docurl;
    $FOOTER	= $opt_footer     if $opt_footer;
    $FROM	= $opt_msgsep     if $opt_msgsep;
    $HEADER	= $opt_header     if $opt_header;
    $IDXPREFIX	= $opt_idxprefix  if $opt_idxprefix;
    $IDXSIZE	= $opt_idxsize    if defined($opt_idxsize);
	$IDXSIZE *= -1  if $IDXSIZE < 0;
    $OUTDIR	= $opt_outdir     if $opt_outdir; # Set again to override db
    $MAILTOURL	= $opt_mailtourl  if $opt_mailtourl;
    $MAXSIZE	= $opt_maxsize    if defined($opt_maxsize);
	$MAXSIZE = 0  if $MAXSIZE < 0;
    $MHPATTERN	= $opt_mhpattern  if $opt_mhpattern;
    $TIDXPREFIX	= $opt_tidxprefix if $opt_tidxprefix;
    $TITLE	= $opt_title      if $opt_title;
    $TLEVELS	= $opt_tlevels    if $opt_tlevels;
    $TTITLE	= $opt_ttitle     if $opt_ttitle;
    $MsgPrefix	= $opt_msgprefix  if defined($opt_msgprefix);
    $GzipExe	= $opt_gzipexe	  if $opt_gzipexe;

    $IDXNAME	= $opt_idxfname || $IDXNAME || $ENV{'M2H_IDXFNAME'} ||
		  "maillist.$HtmlExt";
    $TIDXNAME	= $opt_tidxfname || $TIDXNAME || $ENV{'M2H_TIDXFNAME'} ||
		  "threads.$HtmlExt";

    $ExpireDate	= $opt_expiredate if $opt_expiredate;
    $ExpireTime	= $opt_expireage  if $opt_expireage;
	$ExpireTime *= -1  if $ExpireTime < 0;

    $GMTDateFmt	= $opt_gmtdatefmt  if $opt_gmtdatefmt;
    $LocalDateFmt = $opt_localdatefmt  if $opt_localdatefmt;

    $SubArtRxp   = $opt_subjectarticlerxp  if $subjectarticlerxp;
    $SubReplyRxp = $opt_subjectreplyrxp    if $subjectreplyrxp;

    ## Parse any rc variable definition from command-line
    %CustomRcVars = (%CustomRcVars, &parse_vardef_str($opt_definevars))
	if ($opt_definevars);

    $CONLEN	= 1  if defined($opt_conlen);
    $CONLEN	= 0  if defined($opt_noconlen);
    $MAIN	= 1  if defined($opt_main);
    $MAIN	= 0  if defined($opt_nomain);
    $MODTIME	= 1  if defined($opt_modtime);
    $MODTIME	= 0  if defined($opt_nomodtime);
    $MULTIIDX	= 1  if defined($opt_multipg);
    $MULTIIDX	= 0  if defined($opt_nomultipg);
    $NODOC	= 0  if defined($opt_doc);
    $NODOC	= 1  if defined($opt_nodoc);
    $NOMAILTO	= 1  if defined($opt_nomailto);
    $NONEWS	= 0  if defined($opt_news);
    $NONEWS	= 1  if defined($opt_nonews);
    $NOURL	= 0  if defined($opt_url);
    $NOURL	= 1  if defined($opt_nourl);
    $SLOW	= 1  if defined($opt_savemem);
    $THREAD	= 1  if defined($opt_thread);
    $THREAD	= 0  if defined($opt_nothread);
    $TREVERSE	= 1  if defined($opt_treverse);
    $TREVERSE	= 0  if defined($opt_notreverse);
    $DoArchive	= 1  if defined($opt_archive);
    $DoArchive	= 0  if defined($opt_noarchive);
    $DoFolRefs	= 1  if defined($opt_folrefs);
    $DoFolRefs	= 0  if defined($opt_nofolrefs);
    $GzipFiles	= 1  if defined($opt_gzipfiles);
    $GzipFiles	= 0  if defined($opt_nogzipfiles);
    $GzipLinks	= 1  if defined($opt_gziplinks);
    $GzipLinks	= 0  if defined($opt_nogziplinks);

    $DecodeHeads = 1 if defined($opt_decodeheads);
    $DecodeHeads = 0 if defined($opt_nodecodeheads);
	$readmail'DecodeHeader = $DecodeHeads;

    @DateFields	 = split(/:/, $opt_datefields)  if $opt_datefields;
    foreach (@DateFields) { s/\s//g; tr/A-Z/a-z/; }
    @FromFields	 = split(/:/, $opt_fromfields)  if $opt_fromfields;
    foreach (@FromFields) { s/\s//g; tr/A-Z/a-z/; }

    ($TSliceNBefore, $TSliceNAfter) = split(/:/, $opt_tslice)  if $opt_tslice;

    @Months   = split(/:/, $opt_months) 	if defined($opt_months);
    @months   = split(/:/, $opt_monthsabr)  	if defined($opt_monthsabr);
    @Weekdays = split(/:/, $opt_weekdays)  	if defined($opt_weekdays);
    @weekdays = split(/:/, $opt_weekdaysabr)  	if defined($opt_weekdaysabr);

    $MULTIIDX	= 0  if $IDXONLY || !$IDXSIZE;

    ##	Set umask
    if ($UNIX) {
	$UMASK = $opt_umask      if $opt_umask;
	eval 'umask oct($UMASK)';
    }

    ##	Get sort method
    ##
    $AUTHSORT = 1  if defined($opt_authsort);
    $AUTHSORT = 0  if defined($opt_noauthsort);
    $SUBSORT  = 1  if defined($opt_subsort);
    $SUBSORT  = 0  if defined($opt_nosubsort);
    $NOSORT   = 1  if defined($opt_nosort);
    $NOSORT   = 0  if defined($opt_sort);
    $REVSORT  = 1  if defined($opt_reverse);
    $REVSORT  = 0  if defined($opt_noreverse);
    if ($NOSORT) {
	$SUBSORT = 0;  $AUTHSORT = 0;
    } elsif ($SUBSORT) {
	$AUTHSORT = 0;
    }

    ## Check for thread listing order
    $TSUBSORT = 1  if defined($opt_tsubsort);
    $TSUBSORT = 0  if defined($opt_tnosubsort);
    $TNOSORT  = 1  if defined($opt_tnosort);
    $TNOSORT  = 0  if defined($opt_tsort);
    $TREVERSE = 1  if defined($opt_treverse);
    $TREVERSE = 0  if defined($opt_notreverse);
    if ($TNOSORT) {
	$TSUBSORT = 0;
    }

    ## Check if all messages must be updated (this has been simplified;
    ## any serious change should be done via editidx).
    ##
    if ($RMM || $EDITIDX || ($OldMULTIIDX != $MULTIIDX)) {
	$UPDATE_ALL = 1;
    } else {
	$UPDATE_ALL = 0;
    }

    ## Set date names
    ##
    &set_date_names(*weekdays, *Weekdays, *months, *Months);

    ## Require some more libaries

    ##	    Set index resources.
    require 'mhidxrc.pl' || die("ERROR: Unable to require mhidxrc.pl\n");

    ##	    Create dynamic subroutines.
    require 'mhdysub.pl' || die("ERROR: Unable to require mhdysub.pl\n");
    &create_routines();

    ##	    Require library for expanding resource variables
    require 'mhrcvars.pl' || die("ERROR: Unable to require mhrcvars.pl\n");

    ##	    Require library containing thread routines
    require 'mhthread.pl' || die("ERROR: Unable to require mhthread.pl\n");

    ## 	    Require database write library if needed
    if (!($SCAN || $IDXONLY)) {
	require 'mhdb.pl' || die("ERROR: Unable to require mhdb.pl\n");
    }

    ## Predefine %Index2TLoc in case of message deletion
    if (@TListOrder) {
	@Index2TLoc{@TListOrder} = (0 .. $#TListOrder);
    }

    ## Set $ExpireDateTime from $ExpireDate
    if ($ExpireDate) {
	if (@array = &parse_date($ExpireDate)) {
	    $ExpireDateTime = &get_time_from_date(@array[1..$#array]);
	} else {
	    warn qq|Warning: Unable to parse EXPIREDATE, "$ExpireDate"\n|;
	}
    }

    ## Get highest message number
    if ($ADD) {
	$LastMsgNum = &get_last_msg_num();
    } else {
	$LastMsgNum = -1;
    }

    ## Delete bogus empty entries in hashes due to bug in earlier
    ## versions to avoid any future problems.
    ##
    delete($IndexNum{''});
    delete($Subject{''});
    delete($From{''});
    delete($MsgId{''});
    delete($FollowOld{''});
    delete($ContentType{''});
    delete($Refs{''});

    ## Check if printing process time
    $TIME = defined($opt_time);

    1;
}

##---------------------------------------------------------------------------
##	Version routine
##
sub version {
    select(STDOUT);
    print $VINFO;
}

##---------------------------------------------------------------------------
##	Usage routine
##
sub usage {
    require 'mhusage.pl' ||
	die("ERROR: Unable to require mhusage.pl.\n",
	    "Did you install MHonArc properly?\n");
}

##---------------------------------------------------------------------------
##	create_lock_file() creates a directory to act as a lock.
##
sub create_lock_file {
    local($file, $tries, $sleep, $force) = @_;
    local($umask, $ret);
    $ret = 0;
    while ($tries > 0) {
	if (mkdir($file, 0777)) {
	    $ISLOCK = 1;
	    $ret = 1;
	    last;
	}
	sleep($sleep)  if $sleep > 0;
	$tries--;
    }
    if ($force) {
	$ISLOCK = 1;  $ret = 1;
    }
    $ret;
}

##---------------------------------------------------------------------------
##	remove_lock_file removes the lock on the archive
##
sub remove_lock_file {
    if ($ISLOCK) {
	if (-d $LOCKFILE) {
	    if (!rmdir($LOCKFILE)) {
		warn "Warning: Unable to remove $LOCKFILE: $!\n";
		return 0;
	    }
	} else {
	    if (!unlink($LOCKFILE)) {
		warn "Warning: Unable to remove $LOCKFILE\n";
		return 0;
	    }
	}
	$ISLOCK = 0;
    }
    1;
}

##---------------------------------------------------------------------------
##	read_fmt_file() requires the library with the resource file
##	read subroutine and calls the routine.
##
sub read_fmt_file {
    require 'mhrcfile.pl' || die("ERROR: Unable to require mhrcfile.pl\n");
    &read_resource_file($_[0]);
}

##---------------------------------------------------------------------------
##	Routine to update 1.x data structures to 2.0.
##
sub update_data_1_to_2 {
    local(%EntName2Char) = (
	'lt',       '<',
	'gt',       '>',
	'amp',      '&',
    );
    #--------------------------------------
    sub entname_to_char {
	local($name) = shift;
	local($ret) = $EntName2Char{$name};
	if (!$ret) {
	    $ret = "&$name;";
	}
	$ret;
    }
    #--------------------------------------
    local($index);
    foreach $index (keys %From) {
	$From{$index} =~ s/\&([\w-.]+);/&entname_to_char($1)/ge;
    }
    foreach $index (keys %Subject) {
	$Subject{$index} =~ s/\&([\w-.]+);/&entname_to_char($1)/ge;
    }
    delete $IndexNum{''};
    $TLITXT = '<LI>' . $TLITXT  unless ($TLITXT) && ($TLITXT =~ /<li>/i);
    $THEAD .= "<UL>\n"   unless ($THEAD) && ($THEAD =~ m%<ul>\s*$%i);
    $TFOOT  = "</UL>\n"  unless ($TFOOT) && ($TFOOT =~ m%^\s*</ul>%i);
}

##---------------------------------------------------------------------------
1;
