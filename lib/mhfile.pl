##---------------------------------------------------------------------------##
##  File:
##	$Id: mhfile.pl,v 2.6 2002/05/14 00:04:40 ehood Exp $
##  Author:
##      Earl Hood       mhonarc@mhonarc.org
##  Description:
##      File routines for MHonArc
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1997-1999	Earl Hood, mhonarc@mhonarc.org
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

use Symbol;

##---------------------------------------------------------------------------##

sub file_open {
    my($file) = shift;
    my($handle) = gensym;
    my($gz) = $file =~ /\.gz$/i;

    if ($gz) {
	return $handle  if open($handle, "$GzipExe -cd $file |");
	die qq/ERROR: Failed to exec "$GzipExe -cd $file |": $!\n/;
    }
    return $handle  if open($handle, $file);
    if (-e "$file.gz") {
	return $handle  if open($handle, "$GzipExe -cd $file.gz |");
	die qq/ERROR: Failed to exec "$GzipExe -cd $file.gz |": $!\n/;
    }
    die qq/ERROR: Failed to open "$file": $!\n/;
}

sub file_create {
    my($file) = shift;
    my($gz) = shift;
    my($handle) = gensym;

    if ($gz) {
	$file .= ".gz"  unless $file =~ /\.gz$/;
	return $handle  if open($handle, "| $GzipExe > $file");
	die qq{ERROR: Failed to exec "| $GzipExe > $file": $!\n};
    }
    return $handle  if open($handle, "> $file");
    die qq{ERROR: Failed to create "$file": $!\n};
}

sub file_exists {
    (-e $_[0]) || (-e "$_[0].gz");
}

sub file_copy {
    my($src, $dst) = ($_[0], $_[1]);
    my($gz) = $src =~ /\.gz$/i;

    if ($gz || (-e "$src.gz")) {
	$src .= ".gz"  unless $gz;
	$dst .= ".gz"  unless $dst =~ /\.gz$/i;
    }
    &cp($src, $dst);
}

sub file_rename {
    my($src, $dst) = ($_[0], $_[1]);
    my($gz) = $src =~ /\.gz$/i;

    if ($gz || (-e "$src.gz")) {
	$src .= ".gz"  unless $gz;
	$dst .= ".gz"  unless $dst =~ /\.gz$/i;
    }
    if (!rename($src, $dst)) {
	die qq/ERROR: Unable to rename "$src" to "$dst": $!\n/;
    }
}

sub file_remove {
    my($file) = shift;

    unlink($file);
    unlink("$file.gz");
}

sub file_utime {
    my($atime) = shift;
    my($mtime) = shift;
    foreach (@_) {
	utime($atime, $mtime, $_, "$_.gz");
    }
}

##---------------------------------------------------------------------------##

sub dir_remove {
    my($file) = shift;

    if (-d $file) {
	local(*DIR);
	local($_);
	if (!opendir(DIR, $file)) {
	    warn qq{Warning: Unable to open "$file"\n};
	    return 0;
	}
	my @files = grep(!/^(\.|\..)$/i, readdir(DIR));
	closedir(DIR);
	foreach (@files) {
	    &dir_remove($file . $mhonarc::DIRSEP . $_);
	}
	if (!rmdir($file)) {
	    warn qq{Warning: Unable to remove "$file": $!\n};
	    return 0;
	}

    } else {
	if (!unlink($file)) {
	    warn qq{Warning: Unable to delete "$file": $!\n};
	    return 0;
	}
    }
    1;
}

##---------------------------------------------------------------------------##
1;
