##---------------------------------------------------------------------------##
##  File:
##      mhdb.pl
##  Author:
##      Earl Hood       ehood@isogen.com
##  Description:
##      MHonArc library defining routines for outputing database.
##  Date:
##	Tue Mar 12 13:07:30 CST 1996
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

##---------------------------------------------------------------------------
##	output_db() spits out the state of mhonarc to a file.  This
##	(database) file contains information to update mail threading
##	when incremental adding is done.  The actual database file
##	is a Perl program defining all the internal data structures.  All
##	mhonarc does is 'require' it when updating.  This is really
##	fast and avoids storing mail threading info in the HTML message
##	files -- which would require opening every file to perform
##	updates.
##
sub output_db {
    if (open(DB, "> ${OUTDIR}${DIRSEP}${DBFILE}")) {

	print DB "## MHonArc ($VERSION) database/state information\n",
		 "## This file is needed to perform updates to the archive\n",
		 "## DO NOT MODIFY.\n",
		 "##\n";
	&print_var(DB, 'DbVERSION', *VERSION);

	&print_assoc(DB, 'ContentType', *ContentType);
	&print_assoc(DB, 'Date', *Date);
	&print_assoc(DB, 'Derived', *Derived);
	&print_assoc(DB, 'FieldODefs', *FieldODefs);
	&print_assoc(DB, 'FollowOld', *Follow);
	&print_assoc(DB, 'From', *From);
	&print_assoc(DB, 'HFieldsExc', *HFieldsExc);
	&print_assoc(DB, 'HeadFields', *HeadFields);
	&print_assoc(DB, 'HeadHeads', *HeadHeads);
	&print_assoc(DB, 'Icons', *Icons);
	&print_assoc(DB, 'IndexNum', *IndexNum);
	&print_assoc(DB, 'MIMEFilters', *MIMEFilters);
	&print_assoc(DB, 'MIMEFiltersArgs', *MIMEFiltersArgs);
	&print_assoc(DB, 'MsgId', *MsgId);
	&print_assoc(DB, 'Refs', *Refs);
	&print_assoc(DB, 'Subject', *Subject);

	&print_array(DB, 'FieldOrder', *FieldOrder);
	&print_array(DB, 'OtherIdxs', *OtherIdxs);
	&print_array(DB, 'PerlINC', *PerlINC);
	&print_array(DB, 'Requires', *Requires);

	&print_var(DB, 'BOTLINKS', *BOTLINKS);
	&print_var(DB, 'DOCURL', *DOCURL);
	&print_var(DB, 'FROM', *FROM);
	&print_var(DB, 'IDXNAME', *IDXNAME);
	&print_var(DB, 'IDXPGBEG', *IDXPGBEG);
	&print_var(DB, 'IDXPGEND', *IDXPGEND);
	&print_var(DB, 'IDXSIZE', *IDXSIZE);
	&print_var(DB, 'LIBEG', *LIBEG);
	&print_var(DB, 'LIEND', *LIEND);
	&print_var(DB, 'LITMPL', *LITMPL);
	&print_var(DB, 'MAILTOURL', *MAILTOURL);
	&print_var(DB, 'MAXSIZE', *MAXSIZE);
	&print_var(DB, 'MSGFOOT', *MSGFOOT);
	&print_var(DB, 'MSGHEAD', *MSGHEAD);
	&print_var(DB, 'MSGPGBEG', *MSGPGBEG);
	&print_var(DB, 'MSGPGEND', *MSGPGEND);
	&print_var(DB, 'NEXTBL', *NEXTBL);
	&print_var(DB, 'NEXTBUTTON', *NEXTBUTTON);
	&print_var(DB, 'NEXTBUTTONIA', *NEXTBUTTONIA);
	&print_var(DB, 'NEXTFL', *NEXTFL);
	&print_var(DB, 'NEXTLINK', *NEXTLINK);
	&print_var(DB, 'NEXTLINKIA', *NEXTLINKIA);
	&print_var(DB, 'NOMAILTO', *NOMAILTO);
	&print_var(DB, 'NONEWS', *NONEWS);
	&print_var(DB, 'NOSORT', *NOSORT);
	&print_var(DB, 'NOURL', *NOURL);
	&print_var(DB, 'NumOfMsgs', *NumOfMsgs);
	&print_var(DB, 'PREVBUTTON', *PREVBUTTON);
	&print_var(DB, 'PREVBUTTONIA', *PREVBUTTONIA);
	&print_var(DB, 'PREVLINK', *PREVLINK);
	&print_var(DB, 'PREVLINKIA', *PREVLINKIA);
	&print_var(DB, 'REVSORT', *REVSORT);
	&print_var(DB, 'SUBSORT', *SUBSORT);
	&print_var(DB, 'TFOOT', *TFOOT);
	&print_var(DB, 'THEAD', *THEAD);
	&print_var(DB, 'THREAD', *THREAD);
	&print_var(DB, 'TIDXNAME', *TIDXNAME);
	&print_var(DB, 'TIDXPGBEG', *TIDXPGBEG);
	&print_var(DB, 'TIDXPGEND', *TIDXPGEND);
	&print_var(DB, 'TITLE', *TITLE);
	&print_var(DB, 'TLEVELS', *TLEVELS);
	&print_var(DB, 'TLITXT', *TLITXT);
	&print_var(DB, 'TOPLINKS', *TOPLINKS);
	&print_var(DB, 'TREVERSE', *TREVERSE);
	&print_var(DB, 'TTITLE', *TTITLE);
	&print_var(DB, 'UMASK', *UMASK);

	print DB "1;\n";
    } else {
	warn "Warning: Unable to create ${OUTDIR}${DIRSEP}${DBFILE}\n";
    }
}
##---------------------------------------------------------------------------
sub print_assoc {
    local($handle, $name, *assoc) = @_;

    print $handle "%$name = (\n";
    foreach (keys %assoc) {
	print $handle qq{'}, &escape_str($_), qq{', '},
		      &escape_str($assoc{$_}), qq{',\n};
    }
    print $handle ");\n";
}
##---------------------------------------------------------------------------
sub print_array {
    local($handle, $name, *array) = @_;

    print $handle "\@$name = (\n";
    foreach (@array) {
	print $handle qq{'}, &escape_str($_), qq{',\n};
    }
    print $handle ");\n";
}
##---------------------------------------------------------------------------
sub print_var {
    local($handle, $name, *var, $d) = @_;

    print $handle qq{\$$name = '}, &escape_str($var), qq{'};
    print $handle qq{  unless defined(\$$name)}  if $d;
    print $handle qq{;\n};
}
##---------------------------------------------------------------------------
sub escape_str {
    local($str) = $_[0];

    $str =~ s/\\/\\\\/g;
    $str =~ s/'/\\'/g;
    $str;
}

##---------------------------------------------------------------------------##
1;
