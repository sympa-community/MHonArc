#!/usr/local/bin/perl
##---------------------------------------------------------------------------##
##  File:
##      @(#) mhasiteinit.pl 1.1 99/08/11 23:21:53
##  Description:
##      Site-specific initialization code for MHonArc.  If used, it
##	should be place in the MHonArc library directory as specified
##	during initialization.  The expressions in this file are
##	executed everytime an archive is opened for processing.
##
##	Note, it is recommended to use a default resource file when
##	at all possible.  The file should only be used when a
##	default resource file is not sufficient.
##---------------------------------------------------------------------------##

## Set package to something other than "mhonarc" to protect ourselves
## from unintentially screwing with MHonArc's internals

package mhonarc_site_init;

## Uncomment the following to set the default LOCKMETHOD to flock.
## Flock is better than the directory file method if flock() is supported
## by your system.  If using NFS mounted filesystems, make sure flock()
## under Perl works reliable over NFS.  See the LOCKMETHOD resource
## page of the documentation for more information.

#&mhonarc::set_lock_mode(&mhonarc::MHA_LOCK_MODE_DIR);

##---------------------------------------------------------------------------##
## Make sure to return a true value for require().
1;
