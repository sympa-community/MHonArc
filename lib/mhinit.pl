##---------------------------------------------------------------------------##
##  File:
##      mhinit.pl
##  Author:
##      Earl Hood       ehood@isogen.com
##  Date:
##	Fri Jul 12 08:13:02 CDT 1996
##  Description:
##      Initialization stuff for MHonArc.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995,1996	Earl Hood, ehood@isogen.com
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

##---------------------------------------------------------------------------##
##	The %Zone array should be augmented to contain all timezone
##	specifications with the positive/negative hour offset from UTC
##	(GMT).  (There has got to be a better way to handle timezones)
%Zone = (
    "UTC", 0,	# Universal Coordinated Time
    "GMT", 0,	# Greenwich Mean Time
    "AST", 4,	# Atlantic Standard Time
    "ADT", 3,	# Atlantic Daylight Time
    "EST", 5,	# Eastern Standard Time
    "EDT", 4,	# Eastern Daylight Time
    "CST", 6,	# Central Standard Time
    "CDT", 5,	# Central Daylight Time
    "MST", 7,	# Mountain Standard Time
    "MDT", 6,	# Mountain Daylight Time
    "PST", 8,	# Pacific Standard Time
    "PDT", 7,	# Pacific Daylight Time
);
##	Assoc array listing mail header fields to exclude in output.
##	Each key is treated as a regular expression with '^' prepended
##	to it.
%HFieldsExc = (
    'content-', 1,		# Mime headers
    'errors-to', 1,
    'forward', 1,		# Forward lines (MH may add these)
    'lines', 1,
    'message-id', 1,
    'mime-', 1,		# Mime headers
    'nntp-', 1,
    'originator', 1,
    'path', 1,
    'precedence', 1,
    'received', 1,		# MTA added headers
    'replied', 1,
    'return-path', 1,	# MH creates this during inc
    'status', 1,
    'via', 1,
    'x-', 1,		# Non-standard headers
);
##	Asocc arrays defining HTML formats to apply to header fields
%HeadFields = (
    "-default-", "",
);
%HeadHeads = (
    "-default-", "em",
);
@FieldOrder = (
    'to',
    'subject',
    'from',
    'date',
    '-extra-',
);
%FieldODefs = (
    'to', 1,
    'subject', 1,
    'from', 1,
    'date', 1,
);
$NumOfMsgs	=  0;	# Total number of messages
$LastMsgNum	= -1;	# Message number of last message
%Message  	= ();	# Message bodies
%MsgHead  	= ();	# Message heads
%MsgHtml  	= ();	# Flag if message is html
%Subject  	= ();	# Message subjects
%From   	= ();	# Message froms
%Date   	= ();	# Message dates
%MsgId  	= ();	# Message Ids to indexes
%IndexNum 	= ();	# Index key to message number
%Derived  	= ();	# Derived files for messages
%Refs   	= ();	# Message references
%Follow  	= ();	# Message follow-ups
%FolCnt   	= ();	# Number of follow-ups
%ContentType	= ();	# Base content-type of messages
%Icons    	= ();	# Icon URLs for content-types
%AddIndex 	= ();	# Flags for messages that must be written
$bs 	= "\b";
$Url 	= '(http://|ftp://|afs://|wais://|telnet://|gopher://|' .
		   'news:|nntp:|mid:|cid:|mailto:|prospero:)';
$MLCP	= 0;
$ISLOCK	= 0;
$SLOW	= 0;

##	Get date
$curdate	= &getdate(0);
$locdate	= &getdate(1);

##	Set default filter libraries
@Requires = (

    "mhexternal.pl",
    "mhtxthtml.pl",
    "mhtxtplain.pl",
    "mhtxtsetext.pl",

);

##	Default filters
%MIMEFilters = (

    "application/mac-binhex40", 	"m2h_external'filter",
    "application/octet-stream", 	"m2h_external'filter",
    "application/oda",  		"m2h_external'filter",
    "application/pdf",  		"m2h_external'filter",
    "application/postscript",   	"m2h_external'filter",
    "application/rtf",  		"m2h_external'filter",
    "application/x-bcpio",		"m2h_external'filter",
    "application/x-cpio",		"m2h_external'filter",
    "application/x-csh",		"m2h_external'filter",
    "application/x-dvi",		"m2h_external'filter",
    "application/x-gtar",		"m2h_external'filter",
    "application/x-hdf",		"m2h_external'filter",
    "application/x-latex",		"m2h_external'filter",
    "application/x-mif",		"m2h_external'filter",
    "application/x-netcdf",		"m2h_external'filter",
    "application/x-patch",		"m2h_text_plain'filter",
    "application/x-sh", 		"m2h_external'filter",
    "application/x-shar",		"m2h_external'filter",
    "application/x-sv4cpio",    	"m2h_external'filter",
    "application/x-sv4crc",		"m2h_external'filter",
    "application/x-tar",		"m2h_external'filter",
    "application/x-tcl",		"m2h_external'filter",
    "application/x-tex",		"m2h_external'filter",
    "application/x-texinfo",    	"m2h_external'filter",
    "application/x-troff",		"m2h_external'filter",
    "application/x-troff-man",  	"m2h_external'filter",
    "application/x-troff-me",   	"m2h_external'filter",
    "application/x-troff-ms",   	"m2h_external'filter",
    "application/x-ustar",		"m2h_external'filter",
    "application/x-wais-source",	"m2h_external'filter",
    "application/zip",   		"m2h_external'filter",
    "audio/basic",			"m2h_external'filter",
    "audio/x-aiff",			"m2h_external'filter",
    "audio/x-wav",			"m2h_external'filter",
    "image/gif",			"m2h_external'filter",
    "image/ief",			"m2h_external'filter",
    "image/jpeg",			"m2h_external'filter",
    "image/tiff",			"m2h_external'filter",
    "image/x-bmp",			"m2h_external'filter",
    "image/x-cmu-raster",		"m2h_external'filter",
    "image/x-pbm",			"m2h_external'filter",
    "image/x-pcx",			"m2h_external'filter",
    "image/x-pgm",			"m2h_external'filter",
    "image/x-pict",			"m2h_external'filter",
    "image/x-pnm",			"m2h_external'filter",
    "image/x-portable-anymap",  	"m2h_external'filter",
    "image/x-portable-bitmap",  	"m2h_external'filter",
    "image/x-portable-graymap", 	"m2h_external'filter",
    "image/x-portable-pixmap",  	"m2h_external'filter",
    "image/x-ppm",			"m2h_external'filter",
    "image/x-rgb",			"m2h_external'filter",
    "image/x-xbitmap",          	"m2h_external'filter",
    "image/x-xbm",			"m2h_external'filter",
    "image/x-xpixmap",   		"m2h_external'filter",
    "image/x-xpm",			"m2h_external'filter",
    "image/x-xwd",			"m2h_external'filter",
    "image/x-xwindowdump",		"m2h_external'filter",
    "message/partial",   		"m2h_text_plain'filter",
    "text/html",			"m2h_text_html'filter",
    "text/plain",			"m2h_text_plain'filter",
    "text/richtext",    		"m2h_text_plain'filter",
    "text/setext",			"m2h_text_setext'filter",
    "text/tab-separated-values",	"m2h_text_plain'filter",
    "text/x-html",			"m2h_text_html'filter",
    "text/x-setext",    		"m2h_text_setext'filter",
    "video/mpeg",			"m2h_external'filter",
    "video/quicktime",  		"m2h_external'filter",
    "video/x-msvideo",  		"m2h_external'filter",
    "video/x-sgi-movie",		"m2h_external'filter",

);

##  Default filter arguments
%MIMEFiltersArgs = (

    "image/gif",		"inline",
    "image/x-xbitmap",  	"inline",
    "image/x-xbm",		"inline",
);

##	Grab environment variable settings
##
$DBFILE    = ($ENV{'M2H_DBFILE'} ? $ENV{'M2H_DBFILE'} :
	      ($MSDOS ? "mhonarc.db" : ".mhonarc.db"));
$DOCURL    = ($ENV{'M2H_DOCURL'} ? $ENV{'M2H_DOCURL'} :
	      'http://www.oac.uci.edu/indiv/ehood/mhonarc.html');
$FOOTER    = ($ENV{'M2H_FOOTER'} ? $ENV{'M2H_FOOTER'} : "");
$HEADER    = ($ENV{'M2H_HEADER'} ? $ENV{'M2H_HEADER'} : "");
$IDXNAME   = ($ENV{'M2H_IDXFNAME'} ? $ENV{'M2H_IDXFNAME'} :
	      "maillist.html");
$IDXSIZE   = ($ENV{'M2H_IDXSIZE'} ? $ENV{'M2H_IDXSIZE'} : "");
$TIDXNAME  = ($ENV{'M2H_TIDXFNAME'} ? $ENV{'M2H_TIDXFNAME'} :
	      "threads.html");
$OUTDIR    = ($ENV{'M2H_OUTDIR'} ? $ENV{'M2H_OUTDIR'} : $CURDIR);
$FMTFILE   = ($ENV{'M2H_RCFILE'} ? $ENV{'M2H_RCFILE'} : "");
$TTITLE    = ($ENV{'M2H_TTITLE'} ? $ENV{'M2H_TTITLE'} :
	      "Mail Thread Index");
$TITLE     = ($ENV{'M2H_TITLE'} ? $ENV{'M2H_TITLE'} : "Mail Index");
$MAILTOURL = ($ENV{'M2H_MAILTOURL'} ? $ENV{'M2H_MAILTOURL'} : "");
$FROM      = ($ENV{'M2H_MSGSEP'} ? $ENV{'M2H_MSGSEP'} : '^From ');
$LOCKFILE  = ($ENV{'M2H_LOCKFILE'} ? $ENV{'M2H_LOCKFILE'} : 
	      ($MSDOS ? "mhonarc.lck" : ".mhonarc.lck"));
$LOCKTRIES = ($ENV{'M2H_LOCKTRIES'} ? $ENV{'M2H_LOCKTRIES'} : 10);
$LOCKDELAY = ($ENV{'M2H_LOCKDELAY'} ? $ENV{'M2H_LOCKDELAY'} : 3);
$MAXSIZE   = ($ENV{'M2H_MAXSIZE'} ? $ENV{'M2H_MAXSIZE'} : "");
$THREAD    = (defined($ENV{'M2H_THREAD'}) ? $ENV{'M2H_THREAD'} : 1);
$TLEVELS   = ($ENV{'M2H_TLEVELS'} ? $ENV{'M2H_TLEVELS'} : 3);

$LIBEG  	= '';		# List open template for main index
$LIEND  	= '';		# List close template for main index
$LITMPL 	= '';		# List item template
$TFOOT  	= '';		# Thread index footer
$THEAD  	= '';		# Thread index header
$TLITXT 	= '';		# Thread index list item template

$MSGFOOT	= '';		# Message footer
$MSGHEAD	= '';		# Message header
$TOPLINKS	= '';		# Message links at top of message
$BOTLINKS	= '';		# Message links at bottom of message
$NEXTBUTTON	= '';   	# Next button template
$NEXTBUTTONIA	= '';   	# Next inactive button template
$PREVBUTTON	= '';   	# Previous button template
$PREVBUTTONIA	= '';   	# Previous inactive button template
$NEXTLINK	= '';   	# Next link template
$NEXTLINKIA	= '';   	# Next inactive link template
$PREVLINK	= '';   	# Previous link template
$PREVLINKIA	= '';   	# Previous inactive link template

$IDXPGBEG	= '';		# Beginning of main index page
$IDXPGEND	= '';		# Ending of main index page
$TIDXPGBEG	= '';		# Beginning of thread index page
$TIDXPGEND	= '';		# Ending of thread index page

$MSGPGBEG	= '';		# Beginning of message page
$MSGPGEND	= '';		# Ending of message page

# $PREVBL	= '[Prev]';	# No longer used
# $NEXTBL	= '[Next]';	# No longer used
# $IDXBL	= '[Index]';	# No longer used
# $TIDXBL	= '[Thread]';	# No longer used

# $PREVFL	= 'Prev';	# No longer used
# $NEXTFL	= 'Next';	# No longer used
# $IDXFL	= 'Index';	# No longer used
# $TIDXFL	= 'Thread';	# No longer used

##	Init some flags
##
$NOSORT   = 0;  $REVSORT  = 0;  $NONEWS  = 0;  $TREVERSE  = 0;
$NOMAILTO = 0;  $NOURL    = 0;  $SUBSORT = 0;  $NODOC     = 0;
$TSUBSORT = 0;
$UMASK = sprintf("%o",umask)  if $UNIX;

$X = "\034";	# Value separator (should equal $;)
		# NOTE: Older versions used this variable for
		#	the multiple field separator in parsed
		#	message headers.  $'FieldSep should
		#	now be used (readmail.pl).

##---------------------------------------------------------------------------##

1;
