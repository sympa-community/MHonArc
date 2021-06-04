##---------------------------------------------------------------------------##
##  File:
##	$Id: mhfile.pl,v 2.13 2010/12/31 21:20:41 ehood Exp $
##  Author:
##      Earl Hood       mhonarc@mhonarc.org
##  Description:
##      File routines for MHonArc
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1997-1999	Earl Hood, mhonarc@mhonarc.org
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 2 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##---------------------------------------------------------------------------##

package mhonarc;

use strict;
use warnings;
use Symbol;
use Fcntl;
use File::Basename;

my $_have_File_Temp;

BEGIN {
    # If File::Temp is installed, we will use it for temporary file
    # generation.
    eval { require File::Temp; };
    $_have_File_Temp = scalar($@) ? 0 : 1;

    # Increase File::Temp safety level if setuid
    if ($_have_File_Temp && $UNIX && $TaintMode) {
        File::Temp->safe_level(File::Temp::MEDIUM);
    }

    # Perl <5.004 did not auto-call srand().
    eval { require 5.004; };
    srand(time ^ ($$ + ($$ << 15))) if scalar($@);
}

# Characters to use for home-grown temporay file generation.  We stick to
# basic alphanumerics to avoid OS-specific filename limitations.
my @TEMP_CHARS = qw(
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    0 1 2 3 4 5 6 7 8 9 _
);

# Maximum tries to create a temporary file in home-grown implementation
sub TEMP_MAX_TRIES() { 10; }

##---------------------------------------------------------------------------##

sub file_open {
    my ($file)   = shift;
    my ($handle) = gensym;
    my ($gz)     = $file =~ /\.gz$/i;

    if ($gz) {
        cmd_pipe_open($handle, $GzipExe, '-cd', $file);
        return $handle;
    }
    return $handle if open($handle, $file);
    if (-e "$file.gz") {
        cmd_pipe_open($handle, $GzipExe, '-cd', "$file.gz");
        return $handle;
    }
    die qq/ERROR: Failed to open "$file": $!\n/;
}

sub cmd_pipe_open {
    my $handle = shift;
    my @cmd    = @_;

    if (!$UNIX) {
        return $handle if open($handle, join(' ', @cmd, '|'));
        die qq/ERROR: Failed to exec @cmd: $!\n/;
    }
    my $child_pid = open($handle, '-|');
    if ($child_pid) {    # parent
        return $handle;
    } else {             # child
        #open(STDERR, '>&STDOUT');
        exec(@cmd) || die qq/ERROR: Cannot exec "@cmd": $!\n/;
    }
}

sub file_gzip {
    my $file = shift;
    return if ($file =~ /\.gz$/i);
    if (system($GzipExe, $file) != 0) {
        die qq/ERROR: Failed to exec "$GzipExe $file": $! $?\n/;
    }
}

## This function is currently not used anymore
sub file_create {
    my ($file)   = shift;
    my ($gz)     = shift;
    my ($handle) = gensym;

    if ($gz) {
        $file .= ".gz" unless $file =~ /\.gz$/;
        return $handle if open($handle, "| $GzipExe > $file");
        die qq{ERROR: Failed to exec "| $GzipExe > $file": $!\n};
    }
    return $handle if open($handle, "> $file");
    die qq{ERROR: Failed to create "$file": $!\n};
}

sub file_exists {
    (-e $_[0]) || (-e "$_[0].gz");
}

sub file_copy {
    my ($src, $dst) = ($_[0], $_[1]);
    my ($gz) = $src =~ /\.gz$/i;

    if ($gz || (-e "$src.gz")) {
        $src .= ".gz" unless $gz;
        $dst .= ".gz" unless $dst =~ /\.gz$/i;
    }
    &cp($src, $dst);
}

sub file_rename {
    my ($src, $dst) = ($_[0], $_[1]);
    my ($gz) = $src =~ /\.gz$/i;

    if ($gz || (-e "$src.gz")) {
        $src .= ".gz" unless $gz;
        $dst .= ".gz" unless $dst =~ /\.gz$/i;
    }
    if (!rename($src, $dst)) {
        die qq/ERROR: Unable to rename "$src" to "$dst": $!\n/;
    }
    $dst;
}

sub file_remove {
    my ($file) = shift;

    unlink($file);
    unlink("$file.gz");
}

sub file_utime {
    my ($atime) = shift;
    my ($mtime) = shift;
    foreach (@_) {
        utime($atime, $mtime, $_, "$_.gz");
    }
}

sub file_temp {
    my $template = shift;               # Filename template
    my $dir      = shift || $CURDIR;    # Where to write the file
    my $suffix   = shift;               # Required suffix (optional)
    my ($handle, $tmpfile);

MKTEMP: {
        # Do not honor FASTTEMPFILES if a suffix is required, mainly
        # because things like attachment writing will not work with
        # FASTTEMPFILES.
        if ($FastTempFiles && !defined($suffix)) {
            $handle = gensym;
            $tmpfile = join($DIRSEP, $dir, $template . $$);
            if (!sysopen(
                    $handle, $tmpfile, (O_WRONLY | O_EXCL | O_CREAT), 0600
                )
            ) {
                die qq/ERROR: Unable to create temp file "$tmpfile": $!\n/;
            }
            last MKTEMP;
        }

        # Use File::Temp when at all possible
        if ($_have_File_Temp) {
            my @tf_opts = ('DIR' => $dir, 'UNLINK' => 0);
            push(@tf_opts, 'SUFFIX' => $suffix) if $suffix;
            ($handle, $tmpfile) = File::Temp::tempfile($template, @tf_opts);
            last MKTEMP;
        }

        $handle = gensym;
        my ($i);
        for ($i = 0; $i < TEMP_MAX_TRIES; ++$i) {
            ($tmpfile = $template) =~
                s/X/$TEMP_CHARS[int(rand($#TEMP_CHARS))]/ge;
            $tmpfile = join($DIRSEP, $dir, $tmpfile);
            $tmpfile .= $suffix if defined($suffix);
            last
                if sysopen($handle, $tmpfile,
                (O_WRONLY | O_EXCL | O_CREAT), 0600);
        }
        if ($i >= TEMP_MAX_TRIES) {
            die qq/ERROR: Unable to create temp file "$tmpfile": $!\n/;
        }
    }
    ($handle, $tmpfile);
}

sub file_chmod {
    my $file = shift;
    my $perm = shift || $FilePermsOct;
    ## Capture any die's in case chmod not supported.
    eval {
        if (chmod(($perm & ~umask), $file) < 1) {
            warn qq/Warning: Unable to change "$file" permissions to "/,
                sprintf('%o' . $perm),
                qq/": $!\n/;
        }
    };
}

##---------------------------------------------------------------------------##

sub dir_create {
    my $path = shift;
    my $perms = shift || 0777;

    if (!$UNIX) {
        ## Non-Unix OS's do not have symlinks
        return if (-e $path);
        if (!mkdir($path, $perms)) {
            die qq/ERROR: Unable to create "$path": $!\n/;
        }
        return;
    }

    ## Check if $path is a symlink
    if (-l $path) {
        if ($FollowSymlinks) {
            # Symlinks allowed, so we check if symlink is to a directory
            die qq/ERROR: "$path" is not a directory: $!\n/ if !(-d $path);
            return;
        }
        # symlink, try to delete
        warn qq/Warning: "$path" is a symlink, will try to replace...\n/;
        if (!unlink($path)) {
            die qq/ERROR: "$path" is a symlink, unable to remove: $!\n/;
        }
    } elsif (-e $path) {
        die qq/ERROR: "$path" is not a directory: $!\n/ if !(-d _);
        # already exists, nothing to do
        return;
    }

    my $dirname = dirname($path);
    my @info    = stat($dirname);
    if ($info[2] & Fcntl::S_IWGRP || $info[2] & Fcntl::S_IWOTH) {
        my ($i, $errstr, $tmpdir);
        for ($i = 0; $i < TEMP_MAX_TRIES; ++$i) {
            $tmpdir = dir_temp('dirXXXXXXXXXX', $dirname);
            if (!rename($tmpdir, $path)) {
                $errstr = "$!";
                rmdir($tmpdir);
                if (-l $path) {
                    # hmmmm, somone trying to so something malicious?
                    warn qq/Warning: Possible symlink attack attempted with /,
                        qq/"$path"\n/;
                    die
                        qq/ERROR: "$path" is a symlink, unable to remove: $!\n/
                        unless unlink $path;
                } elsif (-d $path) {
                    # somebody snuck in and created it
                    return;
                } elsif (-e _) {
                    die qq/ERROR: "$path" exists, but it did not before, /,
                        qq/and it is not a directory!\n/;
                }
            } else {
                last;
            }
        }
        if ($i >= TEMP_MAX_TRIES) {
            die qq/ERROR: Unable to rename "$tmpdir" to "$path": $errstr\n/;
        }

    } else {
        if (!mkdir($path, $perms)) {
            die qq/ERROR: Unable to create "$path": $!\n/;
        }
    }
    chmod(($perms & ~umask), $path);
}

sub dir_temp {
    my $template = shift;
    my $dir = shift || $CURDIR;
    my ($tmpdir);

MKTEMP: {
        if ($_have_File_Temp) {
            $tmpdir =
                File::Temp::tempdir($template, 'DIR' => $dir, 'CLEANUP' => 0);
            last MKTEMP;
        }

        my ($i);
        for ($i = 0; $i < TEMP_MAX_TRIES; ++$i) {
            ($tmpdir = $template) =~
                s/X/$TEMP_CHARS[int(rand($#TEMP_CHARS))]/ge;
            $tmpdir = join($DIRSEP, $dir, $tmpdir);
            last if mkdir $tmpdir, 0700;
        }
        if ($i >= TEMP_MAX_TRIES) {
            die qq/ERROR: Unable to create temp dir "$tmpdir": $!\n/;
        }
    }
    $tmpdir;
}

sub dir_remove {
    my ($file) = shift;

    if (-d $file) {
        local (*DIR);
        local ($_);
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

sub rand_string {
    my $template = shift;
    $template =~ s/X/$TEMP_CHARS[int(rand($#TEMP_CHARS))]/ge;
    $template;
}

##---------------------------------------------------------------------------##
1;
