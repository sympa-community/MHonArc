##---------------------------------------------------------------------------##
##  File:
##	@(#)  mhdysub.pl 2.1 98/03/02 @(#)
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##      Definition of create_routines() that creates routines are
##	runtime.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1996   Earl Hood, ehood@medusa.acs.uci.edu
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

package mhonarc;

##---------------------------------------------------------------------------
##	create_routines is used to dynamically create routines that
##	would benefit from being create at run-time.  Routines
##	that have to check against several regular expressions
##	are candidates.
##
sub create_routines {
    local($sub) = '';

    ##-----------------------------------------------------------------------
    ## exclude_field: Used to determine if field should be excluded from
    ## message header
    ##
    $sub  =<<'EndOfRoutine';
	sub exclude_field {
	    local($f) = shift;
	    local($pat, $ret);
	    $ret = 0;
	    EXC_FIELD_SW: {
EndOfRoutine

	# Create switch block for checking field against regular
	# expressions (a large || statement could also work).
	foreach $pat (keys %HFieldsExc) {
	    $sub .= join('',
			 'if ($f =~ /^',
			 $pat,
			 '/i) { $ret = 1;  last EXC_FIELD_SW; }',
			 "\n");
	}

    $sub .=<<'EndOfRoutine';
	    }
	    $ret;
	}
EndOfRoutine

    eval $sub;
    die("ERROR: Unable to create exclude_field routine:\n$@\n") if $@;
}
##---------------------------------------------------------------------------##
1;
