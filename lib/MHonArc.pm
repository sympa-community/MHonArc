##---------------------------------------------------------------------------##
##  File:
##	$Id: MHonArc.pm,v 2.6.19 2020/06/29 21:40:15 ldidry Exp $
##  Author:
##      Luc Didry <luc@framasoft.org> for Framasoft and Sympa community
##  Description:
##	POD after __END__.
##---------------------------------------------------------------------------##
##    Copyright (C) 2020	Sympa community
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

package MHonArc;

use strict;

BEGIN {
    use Exporter ();
    our $VERSION     = '2.6.19';
    our @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    our @EXPORT      = qw($VERSION);
    our @EXPORT_OK   = qw();
    our %EXPORT_TAGS = ();
}
1;
