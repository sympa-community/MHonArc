<!-- ================================================================== -->
<!--  File:
	$Id: utf-8.mrc,v 1.7 2004/03/15 21:07:18 ehood Exp $
      Author:
	Earl Hood <earl @ earlhood . com>

      Description:
	MHonArc, <http://www.mhonarc.org/>, resource file to
	generate UTF-8 pages.

      Notes:
	* If using v2.6.0, or later, you may want to use
	  utf-8-encode.mrc instead.
  -->
<!-- ==================================================================
-->

<CharsetConverters override>
plain;          mhonarc::htmlize;
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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>$IDXTITLE$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<h1>$IDXTITLE$</h1>
</IdxPgBegin>

<TIdxPgBegin>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>$TIDXTITLE$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<h1>$TIDXTITLE$</h1>
</TIdxPgBegin>


<MsgPgBegin>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>$SUBJECTNA$</title>
<link rev="made" href="mailto:$FROMADDR$">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
</MsgPgBegin>
