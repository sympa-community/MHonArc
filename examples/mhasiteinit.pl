#!/usr/local/bin/perl
##---------------------------------------------------------------------------##
##  File:
##      $Id: mhasiteinit.pl,v 1.3 2002/03/14 15:30:57 ehood Exp $
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
##  Uncomment the following to set the callback function after a
##  mail message header is read and before any other processing is done.
##  Note, the function is called after any exclusion checks are
##  performed by MHonArc.
##
##  The function is invoked as follows:
##
##    $boolean = &$mhonarc::CBMessageHeadRead(
##				$fields_hash_ref, $raw_header_txt);
##
##  Arguments:
##      $fields_hash_ref
##          Reference to hash containing parsed message header.  Keys
##          are the lowercase field names and the values are references
##          to array contain the values for each field.  If a field
##          is only declared once in the header, the array will only
##          contain one item.
##
##          The hash also contains special keys represented the values
##          MHonArc has extracted when parsing the message header.
##          The values of these keys are regular scalars and NOT
##          array references.  The following summarizes the keys
##          made available:
##
##            x-mha-index
##                The assigned index given to the message by MHonArc.
##            x-mha-message-id
##                The message-id MHonArc extracted.  Note, if the
##                message did not specified a message ID, MHonArc
##                auto-generates one.
##            x-mha-from
##                Who MHonArc thinkgs the message is from.  This value
##                is controled by the FROMFIELDS resource.
##            x-mha-subject
##                The message subject.  If no subject is defined, then
##                the value is the empty string.
##            x-mha-content-type
##                The content-type of the message MHonArc will use for
##                the message.
##
##      $raw_header_txt
##          The raw header data of the message.  This data may be
##          useful if pattern matches are desired against header
##          data.
##
##  Return Value:
##      The return value is used by MHonArc to determine if the
##      message should be excluded from any further processing.
##      If the return value evaluates to true, then MHonArc will
##      continue processing of the message.  If the return value
##      evaluates to false, the message will be excluded.
##
##  Notes:
##      .  To distinquish between SINGLE operation mode and
##         archive operation mode, you can check the $mhonarc::SINGLE
##         variable.  For example:
##
##          if ($mhonarc::SINGLE) {
##              # single message-based processing here
##          } else {
##              # archive-based processing here
##          }
##
##      .  MHonArc resources exist that allow message exclusion
##	   capabilities: CHECKNOARCHIVE, EXPIREAGE, EXPIREDATE,
##	   and MSGEXCFILTER.  If possible, use these resources
##	   to perform message exclusion filtering.

#require 'head_routine.pl';	# make sure source of routine is loaded
#$mhonarc::CBMessageHeadRead = \&your_head_routine_name;

##---------------------------------------------------------------------------
##  Uncomment the following to set the callback function after a
##  mail message body has been read a converted.
##
##  The function is invoked as follows:
##
##    &$mhonarc::CBMessageBodyRead(
##		    $fields_hash_ref, $html_text_ref, $files_array_ref);
##
##  Arguments:
##      $fields_hash_ref
##          Reference to hash containing parsed message header.  The
##	    structure of this hash is the same as described for
##	    the $mhonarc::CBMessageHeadRead callback.
##
##      $html_text_ref
##          Reference to string contain the HTML markup for the
##	    body.  Modifications to the referenced data will be
##	    reflected in the message page generated.  Therefore,
##	    care should be observed when doing any modification.
##
##	    If MHonArc was unable to convert the body of the
##	    message, the following expression will evaluate to
##	    true:
##
##	      $$html_text_ref eq ""
##
##	    If this is the case, you could set the value
##	    of $$html_text_ref to something else to customize
##	    the warning text MHonArc uses in the message page
##	    written.
##
##      $files_array_ref
##	    Reference to array of derived files when the body
##	    was converted.  Each file is typically relative
##	    to $mhonarc::OUTDIR, unless it is a full pathname.
##	    the mhonarc::OSis_absolute_path($filename) can
##	    be used to determine if a file is an absolute
##	    pathname or not.  Note, it is possible that a
##	    file could designate a directory; this indicates
##	    that the directory, and all files in the directory,
##	    are derived.
##
##	    Modifications to the array will affect the list
##	    of derived files MHonArc stores for the message.
##	    You can add files to the array if your routine
##	    creates files, but you can also delete items if
##	    your routine removes files; CAUTION: the HTML markup
##	    typically contains links to derived files so removing
##	    files could cause broken links unless $html_text_ref
##	    is modified to reflect the file deletions.
##
##  Return Value:
##      N/A
##
##  Notes:
##      .  To distinquish between SINGLE operation mode and
##         archive operation mode, you can check the $mhonarc::SINGLE
##         variable.  For example:
##
##          if ($mhonarc::SINGLE) {
##              # single message-based processing here
##          } else {
##              # archive-based processing here
##          }
##
##	.  The $mhonarc::CBMessageBodyRead routine can be used
##	   to trigger automatic virus scanning of attachments.

#require 'body_routine.pl';	# make sure source of routine is loaded
#$mhonarc::CBMessageBodyRead = \&your_body_routine_name;

##---------------------------------------------------------------------------##
## Make sure to return a true value for require().
##---------------------------------------------------------------------------##
1;
