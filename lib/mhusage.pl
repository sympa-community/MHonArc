##---------------------------------------------------------------------------##
##  File:
##      @(#) mhusage.pl 1.1 97/02/06 19:14:31 @(#)
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##      Usage output.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-1997   Earl Hood, ehood@medusa.acs.uci.edu
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

select(STDOUT);
print <<EndOfUsage;
Usage:  $PROG [<options>] <file> ... 
        $PROG [<options>] -rmm <msg #> ...
Options:
  -add                  : Add message(s) to archive
  -authsort             : Sort messages by author
  -conlen               : Honor Content-Length fields
  -decodeheads          : Decode 1522 decode-only data when reading mail
  -definevars <varlist> : Define custom resource variables
  -dbfile <name>        : Name of MHonArc database file
                            (def: ".mhonarc.db")
  -doc                  : Print link to doc at end of index page
  -docurl <url>         : URL to MHonArc documentation
                            (def: "http://www.oac.uci.edu/indiv/ehood/
				   mhonarc.html")
  -editidx              : Only edit/change index page and messages
  -expiredate <date>    : Message cut-off date
  -expireage <secs>     : Time in seconds from current if message expires
  -folrefs              : Print links to explicit follow-ups/references
  -force                : Perform archive operation even if unable to lock
  -footer <file>        : File containing user text for bottom of index page
  -genidx               : Output index to stdout based upon archive contents
  -gmtdatefmt <fmt>     : Format for GMT date
  -header <file>        : User text to include at top of index page
  -help                 : This message
  -idxfname <name>      : Name of index page
                            (def: "maillist.html")
  -idxprefix <string>   : Filename prefix for multi-page main index
                            (def: "mail")
  -idxsize <#>          : Maximum number of messages shown in indexes
  -localdatefmt <fmt>   : Format for local date
  -lockdelay <#>        : Time delay, in seconds, between lock tries
                            (def: "3")
  -locktries <#>        : Maximum number of tries in locking an archive
                            (def: "10")
  -mailtourl <url>      : URL to use for e-mail address hyperlinks
                            (def: "mailto:\$TO\$")
  -main                 : Create a main index
  -maxsize <#>          : Maximum number of messages allowed in archive
  -mhpattern <exp>      : Perl expression for message files in a directory
                            (def: "^\\d+$")
  -modtime              : Set modification time on files to message date
  -months <list>        : Month names
  -monthsabr <list>     : Abbreviated month names
  -msgsep <exp>         : Message separator (Perl) expression for mbox files
                            (def: "^From ")
  -multipg              : Generate multi-page indexes
  -news                 : Add links to newsgroups
  -noauthsort           : Do not sort messages by author
  -noconlen             : Ignore Content-Length fields
  -nodecodeheads        : Leave message headers "as is" when read
  -nodoc                : Do not print link to doc at end of index page
  -nofolrefs            : Do not print links to explicit follow-ups/references
  -nomailto             : Do not add in mailto links for e-mail addresses
  -nomain               : Do not create a main index
  -nomodtime            : Do not set mod time on files to message date
  -nomultipg            : Do not generate multi-page indexes
  -nonews               : Do not add links to newsgroups
  -noreverse            : List messages in normal order
  -nosort               : Do not sort messages
  -nosubsort            : Do not sort messages by subject
  -nothread             : Do not create threaded index
  -nourl                : Do not make URL hyperlinks
  -otherindexes <list>  : List of other rcfiles for extra indexes
  -outdir <path>        : Destination/location of HTML mail archive
                            (def: ".")
  -perlinc <list>       : List of paths to search for MIME filters
  -quiet                : Suppress status messages during execution
  -rcfile <file>        : Resource file for MHonArc
  -reverse              : List messages in reverse order
  -rmm                  : Remove messages from archive
  -savemem              : Write message data while processing
  -scan                 : List out archive contents to stdout
  -single               : Convert a single message to HTML
  -sort                 : Sort messages by date (this is the default)
  -subsort              : Sort message by subject
  -thread               : Create threaded index
  -tidxfname <name>     : Filename of threaded index page
                            (def: "threads.html")
  -tidxprefix <string>  : Filename prefix for multi-page thread index
                            (def: "thrd")
  -time                 : Print to stderr CPU time used to process mail
  -title <string>       : Title of main index page
                            (def: "Mail Index")
  -tlevels <#>          : Maximum # of nested lists in threaded index
                            (def: "3")
  -treverse             : List threads with newest thread first
  -ttitle <string>      : Title of thread index page
                            (def: "Mail Thread Index")
  -umask <umask>        : Umask of MHonArc process (Unix only)
  -url                  : Make URL hyperlinks
  -v                    : Print version information
  -weekdays <list>      : Weekday names
  -weekdaysabr <list>   : Abbreviated weekday names

Description:
  MHonArc is a highly customizable Perl program for converting e-mail,
  encoded with MIME, into HTML.  MHonArc supports the conversion of UUCP
  style mailbox files or MH mail folders into HTML with an index linking
  to each mail message.  The -single option can be used to convert a
  single mail message.

  Read the documentation for more complete usage information.

Version:
$VINFO
EndOfUsage

1;
