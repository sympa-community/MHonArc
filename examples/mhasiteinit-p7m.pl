##---------------------------------------------------------------------------##
##  File:
##      $Id: mhasiteinit-p7m.pl,v 1.1 2011/01/02 11:14:55 ehood Exp $
##  Description:
##      A mhasiteinit.pl example for supporting application/x-pkcs7-mime
##      messages.
##
##      If used, it should be copied into the MHonArc library directory
##      as specified during initialization, or in a directory that
##      perl checks when requiring libraries.
##
##      IMPORTANT: The file must be named "mhasiteinit.pl" for mhonarc
##      to load it.
##
##      More Info:
##      <http://www.mhonarc.org/archive/cgi-bin/mesg.cgi?a=mhonarc-users&i=4c798002.c61fe70a.1893.5ea8%40mx.google.com>
##---------------------------------------------------------------------------##
##    Copyright (C) 2010	Earl Hood, earl@earlhood.com
##    This program is free software; you can redistribute it and/or modify
##    it under the same terms as MHonArc itself.
##---------------------------------------------------------------------------##

##  Set package to something other than "mhonarc" to protect ourselves
##  from unintentionally screwing with MHonArc's internals

package mhonarc_site_init;

use Symbol;
use File::Temp;

my $openssl = '/usr/bin/openssl';

# Variable that holds the raw header text of the current message
my $current_header_txt = '';

# Message head callback function to capture raw header text.
# This is needed so we can print it out to temp file when openssl
# is used to extract signed message
#
$mhonarc::CBMessageHeadRead = sub {
  my $fields = shift;
  $current_header_txt = shift;
  $current_header_txt .= "\n";
};

# Raw message body read callback: If application/x-pkcs7-mime signed
# data, openssl used to extract contents and then we replace
# body variable to extracted contents for mhonarc to parse and archive.
#
$mhonarc::CBRawMessageBodyRead = sub {
  my $fields = shift;
  my $data_ref = shift;
  my $ctype = $fields->{'content-type'}[0];

  # If not signed-data, we return immediately
  if (!$ctype || $ctype !~ m{application/x-pkcs7-mime} ||
      $ctype !~ m{signed-data}) {
    return 1;
  }

  # Get here, use openssl to extract main data.

  # Write input data to temp file for use by openssl.
  my $tmp = new File::Temp();
  syswrite($tmp, $current_header_txt);  # openssl requires mail headers
  syswrite($tmp, $$data_ref);

  # Open pipe to openssl to extract the data: The command-line
  # options to make this work is non-intuitive.  Luckily, I found
  # a page on the web that listed the right options for extracting
  # the content w/o the need to validate the signature.
  my $handle = gensym;
  mhonarc::cmd_pipe_open($handle,
                $openssl, 'smime',
                '-verify',
                '-in', $tmp->filename,
                '-noverify');
  my $new_data = join('', <$handle>);
  close($handle);
  close($tmp);

  # Parse the sub-header from extracted data and update
  # main fields to use them over original fields.
  my($sub_header, $txt) = readmail::MAILread_header(\$new_data);
  foreach my $key (keys %$sub_header) {
    $fields->{$key} = $sub_header->{$key};
  }
  if ($sub_header->{'content-type'}) {
    # Make sure update mhonarc's meta field for content-type
    my $ctype = $sub_header->{'content-type'}[0];
    if ($ctype =~ m%^\s*([\w\-\./]+)%) {
      $fields->{'x-mha-content-type'} = $1;
    }
  }
  # IMPORTANT: Make sure CTE is adjusted to reflect extracted data
  if (!$sub_header->{'content-transfer-encoding'}) {
    $fields->{'content-transfer-encoding'} = [ '7bit' ];
  }

  # Replace message data to what was extracted and let mhonarc parse it.
  $$data_ref = $new_data;

  return 1;
};

##---------------------------------------------------------------------------##
## Make sure to return a true value for require().
##---------------------------------------------------------------------------##
1;
