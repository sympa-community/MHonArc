<!-- ================================================================== -->
<!--  File:
	$Id: utf-8.mrc,v 1.3 2002/07/27 05:13:13 ehood Exp $
      Author:
	Earl Hood <earl@earlhood.com>

      Description:
	MHonArc, <http://www.mhonarc.org/>, resource file to
	generate UTF-8 pages.

      Dependencies:
	Requires that the Unicode::String and Unicode::MapUTF8 modules are
	installed and the 'use utf8' Perl pragma is supported.

      Notes:
	The following is worth noting if you plan to generate UTF-8
	archives:

	* When defining text-oriented resources, try to stick
	  with ASCII and use numeric character entity references
	  for non-ASCII characters.  This will avoid any possible
	  problems with resource variable expansion since resource
	  variable detection is done in the raw, byte domain (i.e.
	  a "character" is assumned to only comprise a single 8-bit
	  byte).

	* Auto URL detection in text/plain messages could possibly
	  munge characters since it is a non-UTF-8 operation.  However,
	  the probability should be low.  If the problem becomes
	  visible in messages, disable URL detection by specifying
	  the "nourl" argument to m2h_text_plain::filter.

	* If using a search engine with MHonArc, make sure it
	  supports UTF-8.
  -->
<!-- ==================================================================
-->

<!-- MHonArc::UTF8 uses the Unicode::MapUTF8 module to translate
     character data into UTF-8.  Besides US-ASCII data, we default
     that all character data should be converted to UTF-8.  The
     Unicode::MapUTF8 module has a large set of supported characters
     sets, so we should be covered for most locales.
  -->

<CharsetConverters override>
plain;          mhonarc::htmlize;
us-ascii;       mhonarc::htmlize;
default;        MHonArc::UTF8::str2sgml;     MHonArc/UTF8.pm
</CharsetConverters>

<!-- MHonArc v2.5.10 introduced the following resource to control
     how text clipping is performed, mainly for resource variables
     (e.g. $SUBJECTNA:72$).
  -->

<TextClipFunc>
MHonArc::UTF8::clip; MHonArc/UTF8.pm
</TextClipFunc>

<!-- The beginning page markup of MHonArc pages need to be modified
     to tell clients that the pages are in UTF-8 by using a
     <meta http-equiv> tag.

     The following resource settings are just the default settings
     for each resource but with the appropriate <meta http-equiv>
     tag added.
  -->

<IdxPgBegin>
<!doctype html public "-//W3C//DTD HTML//EN">
<html>
<head>
<title>$IDXTITLE$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<h1>$IDXTITLE$</h1>
</IdxPgBegin>

<TIdxPgBegin>
<!doctype html public "-//W3C//DTD HTML//EN">
<html>
<head>
<title>$TIDXTITLE$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<h1>$TIDXTITLE$</h1>
</TIdxPgBegin>


<MsgPgBegin>
<!doctype html public "-//W3C//DTD HTML//EN">
<html>
<head>
<title>$SUBJECTNA$</title>
<link rev="made" href="mailto:$FROMADDR$">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
</MsgPgBegin>
