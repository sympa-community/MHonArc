#!/usr/local/bin/perl
##---------------------------------------------------------------------------##
##  File:
##	@(#) mhaadmin.cgi 1.2 99/08/11 22:16:37
##  Author:
##      Earl Hood       mhonarc@pobox.com
##  Description:
##	CGI program for MHonArc archive administration.
##---------------------------------------------------------------------------##
##    Copyright (C) 1998,1999	Earl Hood, mhonarc@pobox.com
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

package MHAHttpAdmin;

use lib qw ( . ./lib );
use CGI;
use CGI::Carp;

##---------------------------------------------------------------------------##
##				Main routine				     ##
##---------------------------------------------------------------------------##

use vars qw( $JSMenuBar $JSIndexPage $JSMesgPage );
BEGIN: {
    jscript_define();
    $ENV{'M2H_USELOCALTIME'} = 1;
}

my $Debug = 0;  # set to 1 for debug mode, messages sent to server log

my $Rc;
my $menulogo;
my $noteicon;
my $query;
my $action;
my $archive;
my $pagesize;

my @body_attr = (
    '-bgcolor'	=> "#dddddd",
    '-text'	=> "#000000",
    '-link'	=> "#0000ee",
    '-vlink'	=> "#551a8b",
    '-alink'	=> "#ff0000",
);

MAIN: {
    $Rc = require 'mhaadmin.rc' or
	croak qq/Error: Unable to require resource file\n/;

    if ($Debug) { warn '@INC=', join(':', @INC), "\n"; }

    $menulogo	= "$Rc->{'iconurl'}/mhaicon.gif";
    $noteicon	= "$Rc->{'iconurl'}/mhanote_s.gif";

    $ENV{'M2H_LOCKMETHOD'} = $Rc->{'lockmethod'}
	if defined($Rc->{'lockmethod'});

    ## Load main MHonArc library
    require 'mhamain.pl';
    if ($Debug) { warn qq/MHonArc version = $mhonarc::VERSION\n/; }
    if ($Debug) { warn qq/lockmethod = $ENV{'M2H_LOCKMETHOD'}\n/; }

    ## Initialize CGI environment
    $query 	= new CGI;

    ## Initialize MHonArc
    mhonarc::initialize();

    ## Get archive
    $archive	= $query->param('archive');
    if ($archive !~ /\S/) {
	$archive = $query->param('archive') ||
		   (sort { $Rc->{archive}{$a}[0] cmp $Rc->{archive}{$b}[0] }
			 keys %{$Rc->{archive}})[0];
    }

    ## Get action
    $action	= $query->param('action');

    if ($Debug) { warn qq/(archive=$archive, action=$action)/; }

    ## Check if deleting messages
    if ($action eq 'delete') {
	my %dup = ();
	my @msgnum = grep { /\S/ && ($dup{$_}++ < 1 ) }
			  $query->param('msgnum');
	if (@msgnum) {
	    mhonarc::process_input(
			    '-outdir', $archive,
			    '-quiet',
			    '-rmm',
			    @msgnum);
	}
	$action = 'index';
    }

    ## Print menubar
    if ($action eq 'menubar') {
	do_menu_bar();
	last MAIN;
    }

    ## Viewing a message
    if ($action eq 'show') {
	do_mesg_view();
	last MAIN;
    }

    ## Showing index
    do_index();

} ## End: MAIN

##---------------------------------------------------------------------------##
##	Subroutines
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------##
##	do_menu_bar outputs the menubar.  Output is targeted to the
##	menubar frame.
##
sub do_menu_bar {
    if ($Debug) { warn qq/do_menu_bar/; }

    print $query->header(
		    '-target'	=> 'mhaMenuBar');
    print $query->start_html(
		    '-title'	=> 'MHonArc Admin: Menubar',
		    '-script'	=> $JSMenuBar,
		    @body_attr);
    print $query->startform(
		    '-name'	=> 'menuBarForm',
		    '-method'	=> 'post',
		    '-action'	=> $query->url());

    print_main_menus();

    print $query->endform();
    print $query->end_html();
}

##---------------------------------------------------------------------------##
##	do_index display the message index.  Output is targeted to
##	the main window frame.
##
sub do_index {
    if ($Debug) { warn qq/do_index/; }

    my $page	 = $query->param('page');
    my $pagenum	 = $query->param('pagenum');
    my $pagesize = $query->param('pagesize') || 50;
    my $sort	 = $query->param('sort') || 'sort';

    my $thread = ($sort =~ /^t/ ? 1 : 0);

    ## Print header
    print $query->header(
		    '-target'	=> 'mhaWorkArea');
    print $query->start_html(
		    '-title'	=> 'MHonArc Admin: Message Index',
		    '-script'	=> $JSIndexPage,
		    @body_attr);
    #print $query->dump;

    print $query->startform(
		    '-name'	=> 'listForm',
		    '-method'	=> 'post',
		    '-action'	=> $query->url());

    ## Write some hidden fields
    $action = 'index';
    $query->param('action', $action);
    print $query->hidden(
		    '-name'	=> 'action',
		    '-value'	=> $action), "\n";
    $query->param('archive', $archive);
    print $query->hidden(
		    '-name'	=> 'archive',
		    '-value'	=> $archive), "\n";
    $query->param('pagesize', $pagesize);
    print $query->hidden(
		    '-name'	=> 'pagesize',
		    '-value'	=> $pagesize), "\n";
    $query->param('sort', $sort);
    print $query->hidden(
		    '-name'	=> 'sort',
		    '-value'	=> $sort), "\n";
    $query->param('page', 'cur');
    print $query->hidden(
		    '-name'	=> 'page',
		    '-value'	=> $page), "\n";

    ## Open archive
    mhonarc::open_archive(
		    '-nolock',
		    '-outdir', $archive,
		    '-quiet',
		    '-nodoc',
		    '-multipg',
		    '-idxsize', $pagesize,
		    "-$sort",
		    $thread ? ('-nomain', '-thread') :
			      ('-nothread', '-main'),
		    '-genidx');
    mhonarc::close_archive();

    ## Set index resources
    set_resources();
    $thread ? set_thread_idx_resources($sort) : set_main_idx_resources($sort);
    mhonarc::compute_threads()  if $thread;

    ## Figure out what index page to print
    my $totalpgs;
    if ($pagesize == 0) {
	$totalpgs = 1;
    } else {
	  $totalpgs = int($mhonarc::NumOfMsgs/$pagesize);
	++$totalpgs      if ($mhonarc::NumOfMsgs/$pagesize) > $totalpgs;
	  $totalpgs = 1  if $totalpgs == 0;
    }
    $pagenum = 1  unless $pagenum;
    PAGENUM: {
	if ($page =~ /first/i) { $pagenum = 1; 	       last PAGENUM; }
	if ($page =~ /last/i)  { $pagenum = $totalpgs; last PAGENUM; }
	if ($page =~ /next/i)  { ++$pagenum; 	       last PAGENUM; }
	if ($page =~ /prev/i)  { --$pagenum; 	       last PAGENUM; }
    }
    $pagenum = $totalpgs  if $pagenum > $totalpgs;
    $pagenum = 1	  if $pagenum < 1;
    $query->param('pagenum', $pagenum);
    print $query->hidden(
		    '-name'	=> 'pagenum',
		    '-value'	=> $pagenum);

    ## Print index
    $thread ? mhonarc::write_thread_index($pagenum) :
	      mhonarc::write_main_index($pagenum);

    ## Done
    print $query->endform();
    print $query->end_html();
}

##---------------------------------------------------------------------------##
##	do_mesg_view displays message(s).  Output is targeted to the
##	message view frame/window.
##
sub do_mesg_view {
    if ($Debug) { warn qq/do_mesg_view/; }

    my %dup	= ();
    my @msgnum	= grep { /\S/ && ($dup{$_}++ < 1 ) }
		       $query->param('msgnum');

    ## Print header
    print $query->header(
		    '-target'	=> 'mhaMesgView');
    print $query->start_html(
		    '-title'	=> "MHonArc Admin: Message View",
		    '-script'	=> $JSMesgPage,
		    '-onload'	=> 'window.focus();',
		    @body_attr);
    print $query->startform(
		    '-name'	=> 'listForm',
		    '-method'	=> 'post',
		    '-action'	=> $query->url());

    ## Open archive (just to load db and routines)
    mhonarc::open_archive(
		    '-outdir', $archive,
		    '-nolock',
		    '-readdb',
		    '-quiet');
    mhonarc::close_archive();

    ## Print message
    foreach (@msgnum) {
	print_mha_mesg($archive, $_,
		       "$archive/" . mhonarc::msgnum_filename($_));
	print "<hr noshade>\n";
    }

    print '<center>',
	  $query->button(
		    '-name'	=> 'closeBtn',
		    '-value'	=> 'Close',
		    '-onClick'	=> 'window.close();'),
	  "<center>\n";

    print $query->endform();
    print $query->end_html();
}

###############################################################################

##---------------------------------------------------------------------------##
##	print_mha_mesg() outputs the message data part of a message
##	page in an archive.
##
sub print_mha_mesg {
    my $arch	 = shift;
    my $msgnum	 = shift;
    my $filename = shift;

    if (!open(MHAMESG, $filename)) {
	my $errstr = qq/Unable to open "$filename"\n/;
	carp $errstr;
	print html_error($errstr);
	return 0;
    }

    ## Get URL to archive
    my $base = $Rc->{archive}{$arch}[1];

    ## Read header comments and print them.
    my %field = (); my @field = (); my $field;

    while (<MHAMESG>) {
	last  if /^<!--X-Head-End-->/;
	if (/^<!--X-([^:]+):\s([^-]+)\s-->/) {
	    push(@field, $1);
	    push(@{$field{$1}}, mhonarc::entify(mhonarc::uncommentize($2)));
	}
    }

    my $atitle = $Rc->{archive}{$arch}[0];
    print <<EOT;
<table border=0 width="100%">
<tr valign=top>
<td colspan=2 align=center bgcolor="#88BBFF">$atitle: <b>$msgnum</b></td>
</tr>
EOT

    my %printed = ();
    foreach $field (@field) {
	next  if $printed{$field};
	$printed{$field} = 1;
	print qq(<tr valign=top>\n),
	      qq(<th bgcolor="#88BBFF" align=right>$field </th>\n),
	      qq(<td bgcolor="#FFBB88" align=left>);
	print join(",<br>", @{$field{$field}});
	print qq(</td></tr>\n);
    }
    print "</table>\n";

    ## Just extract the message header and body part of the page.  Adjust
    ## relative URLs so links to derived files will work.
    my $replsub = sub {
	my $url = shift;
	unless ($url =~ /^[\w]+:/ or $url =~ /^\// or $url =~ /^#/) {
	    return $base . $url;
	}
	$url;
    };
    while (<MHAMESG>) {
	next  unless /^<!--X-Subject-Header-Begin-->/i;
	while (<MHAMESG>) {
	    last  if /^<!--X-MsgBody-End-->/i;
	    s/(href\s*=\s*["'])([^"']+)(["'])
	     /join("",$1,&$replsub($2),$3)
	     /xgei;
	    s/(src\s*=\s*["'])([^"']+)(["'])
	     /join("",$1,&$replsub($2),$3)
	     /xgei;
	    print;
	}
	last;
    }
    close MHAMESG;

    ## Done
    1;
}

##---------------------------------------------------------------------------##

sub set_resources {
    my $cgiurl = $query->url() . "?archive=$archive";

    $mhonarc::NOTE	=<<'EOT';
<table border=1 bgcolor="#FFFF88">
<tr><td>$NOTETEXT$</td></tr>
</table>
EOT
    $mhonarc::NOTEIA	= "";
    $mhonarc::NOTEICON	=<<EOT;
<IMG ALIGN=bottom SRC="$noteicon" BORDER=0 ALT="Note">
EOT
    $mhonarc::NOTEICONIA='';
}

##---------------------------------------------------------------------------##

sub set_main_idx_resources {
    my $sort = shift;
    my $cgiurl = $query->url() . "?archive=$archive";

    $mhonarc::IDXPGBEG	 = '';
    $mhonarc::IDXPGEND	 = '';

    $mhonarc::LIBEG =<<EOT;
<center>
<table border=0 cellpadding=0 width="100%">
<tr><th bgcolor="#88BBFF">
<big><a target="_top" href="$Rc->{archive}{$archive}[1]">\$IDXTITLE\$</a></big>
</th></tr>
</table>
<table border=0 cellpadding=0 width="100%">
<tr>
<td align=left width="100"><small><b>\$NUMOFIDXMSG\$</b>/<b>\$NUMOFMSG\$</b>
by \$SORTTYPE\$</small></td>
<td align=center
><small><input type=button name="pageBtn" value=" First "
	onClick="changePage(this.form, 'first');">
<input type=button name="pageBtn" value=" Prev "
	onClick="changePage(this.form, 'prev');">
<input type=button name="pageBtn" value=" Next "
	onClick="changePage(this.form, 'next');">
<input type=button name="pageBtn" value=" Last "
	onClick="changePage(this.form, 'last');"></small></td>
<td align=right width="100"
><small>Page <b>\$PAGENUM\$</b>/<b>\$NUMOFPAGES\$</b></small></td>
</tr>
</table>
<table border=0 cellpadding=1 cellspacing=2 width="100%">
<tr valign=top bgcolor="#88BBFF">
<th>Number</th>
EOT

    $mhonarc::LIEND =<<'EOT';
<tr valign=top bgcolor="#88BBFF">
<th>Number</th>
EOT

    my $colheads, $colcnt;
    my @col = ();

    $col[0] =<<EOT;
<tr valign=top bgcolor="#FFBB88">
<td align=right>
    <table border=0 cellpadding=2 cellspacing=0>
    <tr valign=top>
    <td><a \$A_NAME\$>\$NOTEICON\$</a></td>
    <td align=right><small><tt><input
    type=checkbox name=msgnum value="\$MSGNUM\$"></tt></small></td>
    <td align=left><small><b><a
    href="javascript:open_mesg_view('$cgiurl&action=show&msgnum=\$MSGNUM\$')"
    >\$MSGNUM\$</a></b></small></td>
    </tr>
    </table>
</td>
EOT

    if ($sort eq 'authsort') {
	$colheads = '<th>Date</th><th>Subject</th></tr>';
	$col[1] = '<td align=center><small>$YYYYMMDD$</small></td>';
	$col[2] = '<td><small><b>$SUBJECTNA$</b></small></td>';
    } elsif ($sort eq 'subsort') {
	$colheads = '<th>Date</th><th>From</th></tr>';
	$col[1] = '<td align=center><small>$YYYYMMDD$</small></td>';
	$col[2] = '<td><small>$FROMNAME$</small></td>';
    } elsif ($sort eq 'nosort') {
	$colheads = '<th>Date</th><th>From</th><th>Subject</th></tr>';
	$col[1] = '<td align=center><small>$YYYYMMDD$</small></td>';
	$col[2] = '<td><small>$FROMNAME$</small></td>';
	$col[3] = '<td><small><b>$SUBJECTNA$</b></small></td>';
    } else {
	$colheads = '<th>Date</th><th>From</th><th>Subject</th></tr>';
	$col[1] = '<td align=center><small>$MSGLOCALDATE(;%H:%M)$</small></td>';
	$col[2] = '<td><small>$FROMNAME$</small></td>';
	$col[3] = '<td><small><b>$SUBJECTNA$</b></small></td>';
    }
    $colcnt = scalar(@col);
    $mhonarc::LIBEG .= $colheads;
    $mhonarc::LIEND .= $colheads;

    $mhonarc::LIEND .=<<'EOT';
</table>
<table border=0 cellpadding=0 width="100%">
<tr>
<td align=left width="100"><small><b>$NUMOFIDXMSG$</b>/<b>$NUMOFMSG$</b>
by $SORTTYPE$</small></td>
<td align=center
><small><input type=button name="pageBtn" value=" First "
	onClick="changePage(this.form, 'first');">
<input type=button name="pageBtn" value=" Prev "
	onClick="changePage(this.form, 'prev');">
<input type=button name="pageBtn" value=" Next "
	onClick="changePage(this.form, 'next');">
<input type=button name="pageBtn" value=" Last "
	onClick="changePage(this.form, 'last');"></small></td>
<td align=right width="100"
><small>Page <b>$PAGENUM$</b>/<b>$NUMOFPAGES$</b></small></td>
</tr>
</table>
</center>
EOT

    $mhonarc::LITMPL = join("", @col);

    $mhonarc::NOTEICONIA='&nbsp;&nbsp;&nbsp;';

    $mhonarc::AUTHBEG	 =<<EOT;
<tr><th align=left bgcolor="#88BBFF" colspan=$colcnt>
<input type=checkbox name=msgnum value="" onClick="checkGroup(this);">
\$FROMNAME\$</th><tr>
EOT
    $mhonarc::AUTHEND	 =<<EOT;
<input type=hidden name="endGroup" value="">
EOT

    $mhonarc::DAYBEG	 =<<EOT;
<tr><th align=left bgcolor="#88BBFF" colspan=$colcnt>
<input type=checkbox name=msgnum value="" onClick="checkGroup(this);">
\$MSGLOCALDATE(;%B %d, %Y)\$</th><tr>
EOT
    $mhonarc::DAYEND	 =<<EOT;
<input type=hidden name="endGroup" value="">
EOT

    $mhonarc::SUBJECTBEG =<<EOT;
<tr><th align=left bgcolor="#88BBFF" colspan=$colcnt>
<input type=checkbox name=msgnum value="" onClick="checkGroup(this);">
\$SUBJECTNA\$</th><tr>
EOT
    $mhonarc::SUBJECTEND =<<EOT;
<input type=hidden name="endGroup" value="">
EOT


}

##---------------------------------------------------------------------------##

sub set_thread_idx_resources {
    my $cgiurl = $query->url() . "?archive=$archive";

    $mhonarc::TIDXPGBEG = '';
    $mhonarc::TIDXPGEND = '';

    $mhonarc::THEAD	=<<EOT;
<center>
<table border=0 cellpadding=0 width="100%">
<tr><th bgcolor="#88BBFF">
<big><a target="_top" href="$Rc->{archive}{$archive}[1]">\$TIDXTITLE\$</a></big>
</th></tr>
</table>
<table border=0 cellpadding=0 width="100%">
<tr>
<td align=left width="100"><small><b>\$NUMOFIDXMSG\$</b>/<b>\$NUMOFMSG\$</b>
by \$SORTTYPE\$</small></td>
<td align=center
><small><input type=button name="pageBtn" value=" First "
	onClick="changePage(this.form, 'first');">
<input type=button name="pageBtn" value=" Prev "
	onClick="changePage(this.form, 'prev');">
<input type=button name="pageBtn" value=" Next "
	onClick="changePage(this.form, 'next');">
<input type=button name="pageBtn" value=" Last "
	onClick="changePage(this.form, 'last');"></small></td>
<td align=right width="100"
><small>Page <b>\$PAGENUM\$</b>/<b>\$NUMOFPAGES\$</b></small></td>
</tr>
</table>
EOT
    $mhonarc::TFOOT	=<<'EOT';
<table border=0 cellpadding=0 width="100%">
<tr>
<td align=left width="100"><small><b>$NUMOFIDXMSG$</b>/<b>$NUMOFMSG$</b>
by $SORTTYPE$</small></td>
<td align=center
><small><input type=button name="pageBtn" value=" First "
	onClick="changePage(this.form, 'first');">
<input type=button name="pageBtn" value=" Prev "
	onClick="changePage(this.form, 'prev');">
<input type=button name="pageBtn" value=" Next "
	onClick="changePage(this.form, 'next');">
<input type=button name="pageBtn" value=" Last "
	onClick="changePage(this.form, 'last');"></small></td>
<td align=right width="100"
><small>Page <b>$PAGENUM$</b>/<b>$NUMOFPAGES$</b></small></td>
</tr>
</table>
EOT

    $mhonarc::TSINGLETXT =<<EOT;
<table border=0 width="100%" cellpadding=0>
<tr valign=top bgcolor="#EEEEEE">
<td><small><input type=checkbox name=msgnum value="\$MSGNUM\$"
><a \$A_NAME\$>\$NOTEICON\$</a><b><a
href="javascript:open_mesg_view('$cgiurl&action=show&msgnum=\$MSGNUM\$')"
>\$MSGNUM\$</a></b>,
<b>\$SUBJECTNA\$</b>, <i>\$FROMNAME\$</i></small></td>
</tr></table>
EOT
    $mhonarc::TTOPBEG	=<<EOT;
<table border=0 width="100%" cellpadding=0>
<tr valign=top bgcolor="#88BBFF">
<td><input type=checkbox name=msgnum value="" onClick="checkGroup(this);">
<b>\$SUBJECTNA\$</b></td>
<tr valign=top bgcolor="#FFBB88">
<td><dl>
<dd><small><input type=checkbox name=msgnum value="\$MSGNUM\$">
<b><a \$A_NAME\$>\$NOTEICON\$</a><a
href="javascript:open_mesg_view('$cgiurl&action=show&msgnum=\$MSGNUM\$')"
>\$MSGNUM\$</a></b>,
<i>\$FROMNAME\$</i></small>
EOT
    $mhonarc::TTOPEND	=<<'EOT';
</dd></dl></small></td></tr></table>
<input type=hidden name="endGroup" value="">
EOT
    $mhonarc::TLITXT	=<<EOT;
<dd><small><input type=checkbox name=msgnum value="\$MSGNUM\$">
<b><a \$A_NAME\$>\$NOTEICON\$</a><a
href="javascript:open_mesg_view('$cgiurl&action=show&msgnum=\$MSGNUM\$')"
>\$MSGNUM\$</a></b>,
<i>\$FROMNAME\$</i></small>
EOT
    $mhonarc::TLIEND	=<<'EOT';
</dd>
EOT
    $mhonarc::TSUBLISTBEG =<<'EOT';
<dl>
EOT
    $mhonarc::TSUBLISTEND =<<'EOT';
</dl>
EOT
    $mhonarc::TSUBJECTBEG =<<'EOT';
<small>Possible follow-ups</small>
EOT
    $mhonarc::TSUBJECTEND =<<'EOT';
EOT
    $mhonarc::TLINONE =<<'EOT';
<dd><small><i>Message not available</i></small>
EOT
    $mhonarc::TLINONEEND =<<'EOT';
</dd>
EOT
    $mhonarc::TINDENTBEG =<<'EOT';
<dl><dd>
EOT
    $mhonarc::TINDENTEND =<<'EOT';
</dd></dl>
EOT
    $mhonarc::TCONTBEG =<<'EOT';
<table border=0 cellpadding=0 width="100%">
<tr valign=top bgcolor="#88BBFF">
<td><input type=checkbox name=msgnum value="" onClick="checkGroup(this);">
<b>$SUBJECTNA$</b> <i>(continued)</i></td>
</tr>
<tr valign=top bgcolor="#FFBB88">
<td><dl><dd>
EOT
    $mhonarc::TCONTEND =<<'EOT';
</dd></dl></td></tr></table>
<input type=hidden name="endGroup" value="">
EOT

}

##---------------------------------------------------------------------------##

sub print_main_menus {
    print <<EOT;
<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td><a href="http://www.oac.uci.edu/indiv/ehood/mhonarc.html" target="_top"
><img src="$menulogo" alt="MHonArc" border=0></a>&nbsp;</td>

<td><select name="file_menu" onChange="process_file_menu(this);">
<option value="title" selected>File</option>
<option value="">--------</option>
EOT

    my $i = 1;
    foreach (sort { $Rc->{archive}{$a}[0] cmp $Rc->{archive}{$b}[0] }
		  keys %{$Rc->{archive}}) {
	print qq(<option value="arch:$_">$i: ),
	      $Rc->{archive}{$_}[0],
	      qq(</option>\n);
	++$i;
    }
    print <<'EOT';
</select>&nbsp;</td>

<td><select name="edit_menu" onChange="process_edit_menu(this);">
<option value="title" selected>Edit</option>
<option value=""           >--------</option>
<option value="selectAll"  >Select All</option>
<option value="unselectAll">Unselect All</option>
<option value=""           >--------</option>
<option value="show"       >Show Selected</option>
<option value=""           >--------</option>
<option value="delete"     >Delete Selected</option>
</select>&nbsp;</td>

<td><select name="view_menu" onChange="process_view_menu(this);">
<option value="title" selected>View</option>
<option value=""	     >--------</option>
<option value="sort:sort"    >by Date</option>
<option value="sort:subsort" >by Subject</option>
<option value="sort:authsort">by Author</option>
<option value="sort:nosort"  >by Number</option>
<option value=""	     >--------</option>
<option value="sort:tsort"   >by Date (t)</option>
<option value="sort:tsubsort">by Subject (t)</option>
<option value="sort:tnosort" >by Number (t)</option>
<option value=""	     >--------</option>
<option value="pgsz:setsize" >Set size...</option>
<option value=""	     >--------</option>
<option value="page:first"   >First Page</option>
<option value="page:prev"    >Previous Page</option>
<option value="page:next"    >Next Page</option>
<option value="page:last"    >Last Page</option>
<option value=""	     >--------</option>
<option value="rfsh:refresh" >Refresh</option>
</select>&nbsp;</td>

</tr>
</table>
EOT

}

##---------------------------------------------------------------------------##

sub html_error {
    print <<'EOT';
<center>
<table border=0 width="50%">
<tr><th bgcolor="#88BBFF">Note</th></tr>
<tr><td bgcolor="#FFBB88">
EOT;
    print $query->p(@_);
    print <<'EOT';
</td></tr>
</table>
</center>
EOT
}

##---------------------------------------------------------------------------##
##	JavaScript Code
##---------------------------------------------------------------------------##

sub jscript_define {

    ## JavaScript for main index page
    ##-----------------------------------------------------------------------##
    $JSMenuBar =<<'EOJS';

// Set the selection of all messages
function checkAll (form, val) {
    var i;
    for (i=0; i < form.elements.length; ++i) {
	if (form.elements[i].name == 'msgnum') {
	    form.elements[i].checked = val;
	}
    }
}

// Process Archive menu selection
function process_file_menu (menu) {
    var choice	  = menu.options[menu.selectedIndex].value;
    var text 	  = menu.options[menu.selectedIndex].text;
    var list_form = parent.mhaWorkArea.document.listForm;
    var type	  = choice.substr(0,4);
    var val	  = choice.substr(5);

    if (choice != "title") {
	list_form.archive.value = val;
	parent.defaultStatus = text;
	parent.status = text;
	list_form.action.value = 'index';
	list_form.submit();
    }
    menu.options[menu.selectedIndex].selected = false;
    menu.options[0].selected = true;
}

// Process Edit menu selection
function process_edit_menu (menu) {
    var choice = menu.options[menu.selectedIndex].value;
    var list_form = parent.mhaWorkArea.document.listForm;

    menu.options[menu.selectedIndex].selected = false;
    menu.options[0].selected = true;

    if (choice == "selectAll") {
        checkAll(list_form, true);

    } else if (choice == "unselectAll") {
        checkAll(list_form, false);

    } else if (choice == "reset") {
        list_form.reset();

    } else if (choice == "show") {
	list_form.action.value = 'show';
	window.open('javascript:void(0)',
		    'mhaMesgView',
		    'menubar=0,resizable=1,toolbar=0,scrollbars=1');
	list_form.submit();

    } else if (choice == "delete") {
	if (window.confirm("Delete selected messages?")) {
	    list_form.action.value = 'delete';
	    list_form.submit();
	}
    }
}

// Process View menu selection
function process_view_menu (menu) {
    var choice = menu.options[menu.selectedIndex].value;
    var list_form = parent.mhaWorkArea.document.listForm;
    var type = choice.substr(0,4);
    var val = choice.substr(5);
    var n;

    menu.options[menu.selectedIndex].selected = false;
    menu.options[0].selected = true;

    if (type == "sort") {
	list_form.sort.value = val;
	list_form.action.value = 'index';
        list_form.submit();

    } else if (type == "rfsh") {
	list_form.action.value = 'index';
        list_form.submit();

    } else if (type == "pgsz") {
	n = parseInt(
		window.prompt(
		    "Maximum number of message listed per page:",
		    list_form.pagesize.value));
	if ((!isNaN(n)) && (n >= 0) && (n != list_form.pagesize.value)) {
	    list_form.pagesize.value = n;
	    list_form.action.value = 'index';
	    list_form.submit();
	}

    } else if (type == "page") {
	list_form.page.value = val;
	list_form.action.value = 'index';
	list_form.submit();
    }
}
EOJS

    ## JavaScript for main index page
    ##-----------------------------------------------------------------------##
    $JSIndexPage =<<'EOJS';

// Handle button navigation
function changePage (f, val) {
    f.page.value = val;
    f.action.value = 'index';
    f.submit();
}

// Set the selection of all messages in a group
function checkGroup (topmesg) {
    var val   = topmesg.checked;
    var i;
    for (i=0; i < topmesg.form.elements.length; ++i) {
	if (topmesg.form.elements[i] == topmesg) {
	    break;
	}
    }
    ++i;
    if (i >= topmesg.form.elements.length) {
	return;
    }
    while (topmesg.form.elements[i].name == 'msgnum') {
	topmesg.form.elements[i].checked = val;
	++i;
    }
}

// Open a message view window for a message
function open_mesg_view (cgiurl) {
    window.open(cgiurl,
	'mhaMesgView',
	'menubar=0,resizable=1,toolbar=0,scrollbars=1');
}

EOJS

}
