#!/usr/local/bin/perl
##---------------------------------------------------------------------------##
##  File:
##      $Id: mhasiteinit.pl,v 1.4 2005/06/02 02:12:30 ehood Exp $
##  Description:
##      Site-specific initialization code for MHonArc.  If used, it
##	should be place in the MHonArc library directory as specified
##	during initialization, or in a directory that perl checks
##	when requiring libraries.
##
##	>>> THE EXPRESSIONS IN THIS FILE ARE EXECUTED EVERYTIME AN
##	>>> ARCHIVE IS OPENED FOR PROCESSING.
##
##	Note, it is recommended to use a default resource file when
##	possible.
##---------------------------------------------------------------------------##

##  Set package to something other than "mhonarc" to protect ourselves
##  from unintentionally screwing with MHonArc's internals

package mhonarc_site_init;

##---------------------------------------------------------------------------
##  Uncomment the following to set the default LOCKMETHOD to flock.
##  Flock is better than the directory file method if flock() is supported
##  by your system.  If using NFS mounted filesystems, make sure flock()
##  under Perl works reliable over NFS.  See the LOCKMETHOD resource
##  page of the documentation for more information.

#&mhonarc::set_lock_mode(&mhonarc::MHA_LOCK_MODE_FLOCK);

##---------------------------------------------------------------------------
##  The following are callback functions that you can register
##  for all instances of mhonarc.  See the Application Programming
##  Interface appendix of the documentation for a complate list
##  of available callbacks and how they are invoked.

#require 'head_routine.pl';	# make sure source of routine is loaded
#$mhonarc::CBMessageHeadRead = \&your_head_routine_name;

#require 'raw_body_routine.pl';	# make sure source of routine is loaded
#$mhonarc::CBRawMessageBodyRead = \&your_raw_body_routine_name;

#require 'body_routine.pl';	# make sure source of routine is loaded
#$mhonarc::CBMessageBodyRead = \&your_body_routine_name;

##---------------------------------------------------------------------------##
## Make sure to return a true value for require().
##---------------------------------------------------------------------------##
1;
