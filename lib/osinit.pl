##---------------------------------------------------------------------------##
##  File:
##	@(#) osinit.pl 1.2 97/01/28 12:19:10 @(#)
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##	A library for setting up a script based upon the OS the script
##	is running under.  The main routine defined is OSinit.  See
##	the routine for specific information.
##---------------------------------------------------------------------------##
##    Copyright (C) 1995-1997	Earl Hood, ehood@medusa.acs.uci.edu
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

package os_init;

##---------------------------------------------------------------------------##
##	OSinit() checks what operating system we are running on set
##	some global variables that can be used by the calling routine.
##	All global variables are exported to package main.
##
##	Variables set:
##
##	    $'MSDOS	=> Set to 1 if running under MS-DOS/Windows
##	    $'MACOS	=> Set to 1 if running under Mac
##	    $'UNIX	=> Set to 1 if running under Unix
##	    $'DIRSEP	=> Directory separator character
##	    $'DIRSEPREX	=> Directory separator character for use in
##			   regular expressions.
##	    $'PATHSEP	=> Recommend path list separator
##	    $'CURDIR	=> Current working directory
##	    $'PROG	=> Program name with leading pathname component
##			   stripped off.
##
##	If running under a Mac and the script is a droplet, command-line
##	options will be prompted for unless $noOptions argument is
##	set to true.
##
sub main'OSinit {
    local($noOptions) = shift;

    ##  Check what system we are executing under
    local($tmp);
    if (($tmp = $ENV{'COMSPEC'}) && ($tmp =~ /[a-zA-Z]:\\/) && (-e $tmp)) {
        $'MSDOS = 1;  $'MACOS = 0;  $'UNIX = 0;
	$'DIRSEP = '\\';  $'CURDIR = '.';
	$'PATHSEP = ';';
    } elsif (defined($MacPerl'Version)) {
        $'MSDOS = 0;  $'MACOS = 1;  $'UNIX = 0;
	$'DIRSEP = ':';  $'CURDIR = ':';
	$'PATHSEP = ';';
    } else {
        $'MSDOS = 0;  $'MACOS = 0;  $'UNIX = 1;
	$'DIRSEP = '/';  $'CURDIR = '.';
	$'PATHSEP = ':';
    }
    ##	Store name of program
    ($'DIRSEPREX = $'DIRSEP) =~ s/(\W)/\\$1/g;
    ($'PROG = $0) =~ s%.*[$'DIRSEPREX]%%o;

    ##	Ask for command-line options if script is a Mac droplet
    ##		Code taken from the MacPerl FAQ
    if (!$noOptions && ( $MacPerl'Version =~ /Application$/ )) {
	# we're running from the app
	local( $cmdLine, @args );
	$cmdLine = &MacPerl'Ask( "Enter command line options:" );
	require "shellwords.pl";
	@args = &shellwords( $cmdLine );
	unshift( @'ARGV, @args );
    }
}

##---------------------------------------------------------------------------##
1;
