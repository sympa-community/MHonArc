##---------------------------------------------------------------------------##
##  File:
##	@(#) mhfile.pl 2.4 99/06/25 14:13:41
##  Author:
##      Earl Hood       mhonarc@pobox.com
##  Description:
##      File routines for MHonArc
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1997-1999	Earl Hood, mhonarc@pobox.com
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

##---------------------------------------------------------------------------##

sub file_open {
    local($file) = shift;
    local($handle) = q/mhonarc::FOPEN/ . ++$_fo_cnt;
    local($gz) = $file =~ /\.gz$/i;

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
    local($file) = shift;
    local($gz) = shift;
    local($handle) = q/mhonarc::FCREAT/ . ++$_fc_cnt;

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
    local($src, $dst) = ($_[0], $_[1]);
    local($gz) = $src =~ /\.gz$/i;

    if ($gz || (-e "$src.gz")) {
	$src .= ".gz"  unless $gz;
	$dst .= ".gz"  unless $dst =~ /\.gz$/i;
    }
    &cp($src, $dst);
}

sub file_rename {
    local($src, $dst) = ($_[0], $_[1]);
    local($gz) = $src =~ /\.gz$/i;

    if ($gz || (-e "$src.gz")) {
	$src .= ".gz"  unless $gz;
	$dst .= ".gz"  unless $dst =~ /\.gz$/i;
    }
    if (!rename($src, $dst)) {
	die qq/ERROR: Unable to rename "$src" to "$dst": $!\n/;
    }
}

sub file_remove {
    local($file) = shift;

    unlink($file);
    unlink("$file.gz");
}

sub file_utime {
    local($atime) = shift;
    local($mtime) = shift;
    foreach (@_) {
	utime($atime, $mtime, $_, "$_.gz");
    }
}

##---------------------------------------------------------------------------##

sub dir_remove {
    local($file) = shift;

    if (-d $file) {
	local(@files) = ();

	if (!opendir(DIR, $file)) {
	    warn qq{Warning: Unable to open "$file"\n};
	    return 0;
	}
	@files = grep(!/^(\.|\..)$/i, readdir(DIR));
	closedir(DIR);
	foreach (@files) {
	    &dir_remove($file . $mhonarc'DIRSEP . $_);
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
