##---------------------------------------------------------------------------##
##  File:
##      readmail.pl
##  Author:
##      Earl Hood       ehood@isogen.com
##  Description:
##      Library defining routines to parse MIME e-mail messages.  The
##	library is designed so it may be reused for other e-mail
##	filtering programs.  The default behavior is for mail->html
##	filtering, however, the defaults can be overridden to allow
##	mail->whatever filtering.
##  Date:
##	Thu Mar 21 13:31:27 CST 1996
##---------------------------------------------------------------------------##
##    Copyright (C) 1995	Earl Hood, ehood@isogen.com
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

package readmail;

require "base64.pl" || die "ERROR: Unable to require base64.pl\n";
require "qprint.pl" || die "ERROR: Unable to require qprint.pl\n";

##---------------------------------------------------------------------------##
##	Scalar Variables
##

##  Variable storing the mulitple fields separator value for the
##  the read header routines.
##
$main'FieldSep	= "\034";

##---------------------------------------------------------------------------##
##	Variables for folding information related to the functions used
##	for processing MIME data.  Variables are defined in the scope
##	of main.

##  MIMEFilters is the associative array for storing functions that
##  process various content-types in the MAILread_body routine.
##
##	Keys => Content-type (should be in lowercase)
##	Values => function name.
##
##  Function names should be qualified with package identifiers.
##  Functions are called as follows:
##
##	$converted_data = &function($header, *parsed_header_assoc_array,
##				    *message_data, $decoded_flag,
##				    $optional_filter_arguments);
##
##  Functions can be registered for base types.  Example:
##
##	$MIMEFilters{"image/*"} = "mypackage'function";
##
##  To register a fallback function to be called if no function is
##  defined for a specific content-type, do something like the
##  following:
##
##	$MIMEFilters{"*/*"} = "mypackage'function";
##
##  IMPORTANT: If a function specified is not defined when MAILread_body
##  tries to invoke it, MAILread_body will silently ignore.  Make sure
##  that all functions are defined before invoking MAILread_body.
##
%main'MIMEFilters	= ();

##  MIMEDecoders is the associative array for storing functions for
##  decoding mime data.
##
##	Keys => content-transfer-encoding (should be in lowercase)
##	Values => function name.
##
##  Function names should be qualified with package identifiers.
##  Functions are called as follows:
##
##	$decoded_data = &function($data);
##
##  The value "as-is" may be used to allow the data to be passed without
##  decoding to the registered filter, but the decoded flag will be
##  set to true.
##
%main'MIMEDecoders			= ();
##	Default settings:
$main'MIMEDecoders{"7bit"}		= "as-is";
$main'MIMEDecoders{"8bit"}		= "as-is";
$main'MIMEDecoders{"binary"}		= "as-is";
$main'MIMEDecoders{"base64"}		= "base64'b64decode";
$main'MIMEDecoders{"quoted-printable"}	= "quoted_printable'qprdecode";
$main'MIMEDecoders{"x-uuencode"}	= "base64'uudecode";

##  MIMEFiltersArgs is the associative array for storing any optional
##  arguments to functions specified in MIMEFilters (the
##  $optional_filter_arguments from above).
##
##	Keys => Either one of the following: content-type, function name.
##	Values => Argument string (format determined by filter function).
##
##  Arguments listed for a content-type will be used over arguments
##  listed for a function if both are applicable.
##
%main'MIMEFiltersArgs	= ();

##---------------------------------------------------------------------------
##	Variables holding functions for generating processed output
##	for MAILread_body().  The default functions generate HTML.
##	However, the variables can be set to functions that generate
##	a different type of output.
##
##	$FormatHeaderFunc has no default, and must be defined by
##	the calling program.
##
##  Function that returns a message when failing to process a part of a
##  a multipart message.  The content-type of the message is passed
##  as an argument.
##
$CantProcessPartFunc		= "cantProcessPart";

##  Function that returns a message when a part is unrecognized in a
##  multipart/alternative message.  I.e. No part could be processed.
##  No arguments are passed to function.
##
$UnrecognizedAltPartFunc	= "unrecognizedAltPart";

##  Function that returns a string to go before any data generated generating
##  from processing an embedded message (message/rfc822 or message/news).
##  No arguments are passed to function.
##
$BeginEmbeddedMesgFunc		= "beginEmbeddedMesg";

##  Function that returns a string to go after any data generated generating
##  from processing an embedded message (message/rfc822 or message/news).
##  No arguments are passed to function.
##
$EndEmbeddedMesgFunc		= "endEmbeddedMesg";

##  Function to return a string that is a result of the functions
##  processing of a message header.  The function is called for
##  embedded messages (message/rfc822 and message/news).  The
##  arguments to function are:
##
##   1.	Pointer to associative array representing message header
##	contents with the keys as field labels (in all lower-case)
##	and the values as field values of the labels.
##
##   2. Pointer to associative array mapping lower-case keys of
##	argument 1 to original case.
##
##  Prototype: $return_data = &function(*fields, *lower2orig_fields);
##
$FormatHeaderFunc		= "";

###############################################################################
##	Public Routines							     ##
###############################################################################
##---------------------------------------------------------------------------
##	MAILread_body() parses a MIME message body.  $header is the
##	header of the message.  $body is the actual message body.
##	$ctypeArg is the value of the Content-Type field and $encodingArg
##	is the value of the Content-Transfer-Encoding field (both
##	should be obtained from $header from the calling routine).  The
##	return value is an array:  The first item is the converted data
##	generated, and the other items are filenames of any derived
##	files.
##
sub main'MAILread_body {
    local($header, $body, $ctypeArg, $encodingArg) = @_;

    local($type, $subtype, $boundary, $ret, $tmp, $content, $ctype);
    local($part, $parthead, $partcontent, $partencoding);
    local(@parts, %partfields, %partl2o) = ();
    local(@files) = ();
    local(@array) = ();

    ## Get type/subtype
    $content = $ctypeArg || 'text/plain';	# Default to text/plain 
						# 	if no content-type
    ($ctype) = $content =~ m%^\s*([\w-/]+)%;	# Extract content-type
    $ctype =~ tr/A-Z/a-z/;			# Convert to lowercase
    if ($ctype =~ m%/%) {			# Extract base and sub types
	($type,$subtype) = split(/\//, $ctype, 2);
    } elsif ($ctype =~ /text/) {
	$ctype = 'text/plain';
	$type = 'text';  $subtype = 'plain';
    } else {
	$type = $subtype = '';
    }

    ## Process message
    $filter = $'MIMEFilters{$ctype};			# Specific filter
    $filter = $'MIMEFilters{"$type/*"}	unless $filter; # Base type filter
    $filter = $'MIMEFilters{"*/*"}	unless $filter;	# Last resort

    ## A filter is defined for given content-type
    if ($filter && defined(&$filter)) {
	local($tmphead) = ($header . "\n"); # Bogus header for MAILread_header
	local($encoding) = ($encodingArg);
	local($decodefunc, $decoded, $args) = ('', '', '');

	## Check for filter arguments
	$args = $'MIMEFiltersArgs{$ctype};
	$args = $'MIMEFiltersArgs{"$type/*"} if $args eq '';
	$args = $'MIMEFiltersArgs{$filter} if $args eq '';

	## Parse message header for filter
	&'MAILread_header(*tmphead, *partfields, *partl2o);

	## Check encoding and decode data
	$encoding =~ s/\s//g;  $encoding =~ tr/A-Z/a-z/;
	$decodefunc = $'MIMEDecoders{$encoding};
	if (defined(&$decodefunc)) {
	    $decoded = &$decodefunc($body);
	    @array = &$filter($header, *partfields, *decoded, 1, $args);
	} else {
	    @array = &$filter($header, *partfields, *body,
			      $decodefunc =~ /as-is/i, $args);
	}

	## Setup return variables
	$ret = shift @array;				# Return string
	push(@files, @array);				# Derived files

    ## No filter defined for given content-type
    } else {
	## If multipart, recursively process each part
	if ($type =~ /multipart/i) {

	    ## Get boundary
	    if ($content =~ m%boundary\s*=\s*"([^"]*)"%i) {
		$boundary = $1;
	    } else {
		($boundary) = $content =~ m%boundary\s*=\s*(\S+)%;
	    }
	    $boundary =~ s/(\W)/\\$1/g;

	    ## Split parts and process each
	    $body = "\r\n" . $body;	# Pad data for splitting
	    if ($subtype =~ /alternative/i) {	# Go in reverse order
		@parts = reverse split(/\r?\n--$boundary/, $body);
		pop @parts;
		while (@parts && ($parts[0] !~ /^--/)) { shift @parts; }
		shift @parts;
	    } else {
		@parts = split(/\r?\n--$boundary/, $body);
		shift @parts;
		while (@parts && ($parts[$#parts] !~ /^--/)) { pop @parts; }
		pop @parts;
	    }

	    ## Process parts
	    foreach $part (@parts) {
		$part =~ s/^\r?\n//;	# Drop begining newline

		## Read header to get content-type
		$parthead = &'MAILread_header(*part, *partfields, *partl2o);
		$partcontent = $partfields{'content-type'};
		$partencoding = $partfields{'content-transfer-encoding'};

		## If content-type not defined for part, then determine
		## content-type based upon mulipart subtype.
		if (!$partcontent) {
		    if ($subtype =~ /digest/) {
			$partcontent = 'message/rfc822';
		    }
		    else {
			$partcontent = 'text/plain';
		    }
		}

		## Process part
		@array = &'MAILread_body($parthead, $part,
					 $partcontent, $partencoding);

		## Only use last filterable part in alternate
		if ($subtype =~ /alternative/) {
		    $ret = shift @array;
		    if ($ret) {
			push(@files, @array);
			last;
		    }
		} else {
		    if (!$array[0]) {
			$array[0] = &$CantProcessPartFunc(
					$partfields{'content-type'});
		    }
		    $ret .= shift @array;
		}
		push(@files, @array);
	    }
	    if (!$ret && ($subtype =~ /alternative/)) {
		$ret = &$UnrecognizedAltPartFunc();
	    }

	## Else if message/rfc822 or message/news
	} elsif ($ctype =~ m%message/(rfc822|news)%i) {
	    $parthead = &'MAILread_header(*body, *partfields, *partl2o);
	    $partcontent = $partfields{'content-type'};
	    $partencoding = $partfields{'content-transfer-encoding'};

	    $ret = &$BeginEmbeddedMesgFunc();
	    if ($FormatHeaderFunc && defined(&$FormatHeaderFunc)) {
		$ret .= &$FormatHeaderFunc(*partfields, *partl2o);
	    } else {
		warn "WARNING: readmail.pl: No message header formatting ",
		     "function defined\n";
	    }
	    @array = &'MAILread_body($parthead, $body,
				     $partcontent, $partencoding);
	    $ret .= shift @array ||
		    &$CantProcessPartFunc($partfields{'content-type'});
	    $ret .= &$EndEmbeddedMesgFunc();

	    push(@files, @array);

	## Else cannot do anything
	} else {
	    $ret = '';
	}
    }
    ($ret, @files);
}
##---------------------------------------------------------------------------
##	MAILread_header reads (and strips) a mail message header from the
##	variable *mesg.  *mesg is a pointer to the mail message.
##
##	*fields is a pointer to an associative array to put field
##	values indexed by field labels that have been converted to all
##	lowercase.  If a field repeats (eg Received fields), then each
##	value in $fields{$fieldname} will be a $'FieldSep separated
##	string representing the multiple values.
##
##	*l2o is an associative array to get the original label text
##	from the lowercase field label keys.
##	
##	The return value is the original (extracted) header text.
##
sub main'MAILread_header {
    local(*mesg, *fields, *l2o) = @_; local($label, $olabel, $value,
    $tmp, $header);

    $header = '';  %fields = ();  %l2o = ();  $label = '';

    ## Read a line at a time.
    while ($mesg =~ s/^([^\n]*\n)//) {
	$tmp = $1;
	last  if $tmp =~ /^[\r]?$/;	# Done if blank line
	$header .= $tmp;
	$tmp =~ s/\n/ /g;

	## Check for continuation of a field
	if ($tmp =~ /^\s/) {
	    $fields{$label} .= $tmp  if $label;
	    next;
	}

	## Separate head from field text
	if ($tmp =~ /^([^:\s]+):\s*([\s\S]*)$/) {
	    ($olabel, $value) = ($1, $2);
	    ($label = $olabel) =~ tr/A-Z/a-z/;
	    $l2o{$label} = $olabel;
	    if ($fields{$label}) {
		$fields{$label} .= $'FieldSep . $value;
	    } else {
		$fields{$label} = $value;
	    }
	}
    }
    $header;
}
##---------------------------------------------------------------------------
##	MAILread_file_header reads (and strips) a mail message header
##	from the filehandle $handle.  The routine behaves in the
##	same manner as MAILread_header;
##	
sub main'MAILread_file_header {
    local($handle, *fields, *l2o) = @_;
    local($label, $olabel, $value, $tmp, $header);
    local($d) = ($/);

    $/ = "\n";  $label = '';
    $header = '';  %fields = ();  %l2o = ();
    while (($tmp = <$handle>) !~ /^[\r]?$/) {
	$header .= $tmp;
	$tmp =~ s/\n/ /g;

	## Check for continuation of a field
	if ($tmp =~ /^\s/) {
	    $fields{$label} .= $tmp  if $label;
	    next;
	}

	## Separate head from field text
	if ($tmp =~ /^([^:\s]+):\s*([\s\S]*)$/) {
	    ($olabel, $value) = ($1, $2);
	    ($label = $olabel) =~ tr/A-Z/a-z/;
	    $l2o{$label} = $olabel;
	    if ($fields{$label}) {
		$fields{$label} .= $'FieldSep . $value;
	    } else {
		$fields{$label} = $value;
	    }
	}
    }
    $/ = $d;
    $header;
}

###############################################################################
##	Private Routines
###############################################################################
##---------------------------------------------------------------------------##
##	Default function for unable to process a part of a multipart
##	message.
##
sub cantProcessPart {
    local($ctype) = $_[0];

    warn "Warning: Could not process part with given Content-Type: ",
	 "$ctype\n";
    join('',"<DL>\n",
	    "<DT><STRONG>Warning</STRONG></DT>\n",
	    "<DD>Could not process part with given ",
	    "Content-Type: <CODE>", $ctype, "</CODE>\n",
	    "</DD>\n",
	    "</DL>\n"
	    );
}
##---------------------------------------------------------------------------##
##	Default function for unrecognizeable part in multipart/alternative.
##
sub unrecognizedAltPart {
    warn "Warning: No recognizable part in multipart/alternative\n";
    join('',"<HR>\n",
	    "<P>No recognizable part in ",
	    "<CODE>multipart/alternative</CODE>.</P>\n",
	    "<HR>\n");
}
##---------------------------------------------------------------------------##
##	Default function for beggining of embedded message
##	(ie message/rfc822 or message/news).
##
sub beginEmbeddedMesg {
    join('',"<P><EM>-- BEGIN included message</EM></P>\n",
	    "<BLOCKQUOTE>\n");
}
##---------------------------------------------------------------------------##
##	Default function for end of embedded message
##	(ie message/rfc822 or message/news).
##
sub endEmbeddedMesg {
    join('',"</BLOCKQUOTE>\n",
	    "<P><EM>-- END included message</EM></P>\n");
	    
}
##---------------------------------------------------------------------------##
1; # for require