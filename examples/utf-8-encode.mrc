<!-- ================================================================== -->
<!--  File:
	$Id: utf-8-encode.mrc,v 1.1 2002/12/21 07:26:33 ehood Exp $
      Author:
	Earl Hood <earl@earlhood.com>

      Description:
	MHonArc, <http://www.mhonarc.org/>, resource file to
	encode message text data into Unicode UTF-8.  This only
	works with v2.6.0, or later, of MHonArc.

      Notes:
	* This is a more general version of utf-8.mrc.	Where
	  utf-8.mrc basis its conversion via CHARSETCONVERTERS,
	  this does it via TEXTENCODE.

	  The advantage of TEXTENCODE, is that message text data,
	  including headers, are converted to UTF-8 when read.	This
	  provides a performance advantage over the CHARSETCONVERTERS
	  method, and TEXTENCODE affects all text entities in a
	  message bodies.  The CHARSETCONVERTERS method depends on
	  individual text-based MIMEFILTERS to explicitly support
	  CHARSETCONVERTERS.  TEXTENCODE is transparent to MIMEFILTERS.

  -->
<!-- ================================================================== -->

<TextEncode>
utf-8; MHonArc::UTF8::to_utf8; MHonArc/UTF8.pm
</TextEncode>

<-- With data translated to UTF-8, it simplifies CHARSETCONVERTERS -->
<CharsetConverters override>
default; mhonarc::htmlize
</CharsetConverters>

<-- Need to also register UTF-8-aware text clipping function -->
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
