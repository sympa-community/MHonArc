<!-- ================================================================== -->
<!-- File:
	$Id: blog.mrc,v 1.2 2002/05/04 04:57:23 ehood Exp $
     Author:
	Earl Hood <earl@earlhood.com>

     Description:
	MHonArc, <http://www.mhonarc.org/>, resource file to
	generate a "blogger"-style archive.  I.e.  All messages
	are displayed on a single page.

     Dependencies:
	For things to work, server-side includes must be enabled
	for .shtml files in the directory the archive will exist.
  -->
<!-- ================================================================== -->

<!-- Sort messages by date. -->
<Sort>

<!-- We do not care for threading here. -->
<NoThread>

<!-- ================================================================== -->
<!--  Main Index Page							-->
<!-- ================================================================== -->

<!-- Make sure main index page has proper extension for SSI. -->
<IdxFname>
index.shtml
</IdxFname>

<!-- We define beginning markup to include style definitions. -->
<IdxPgBegin>
<!doctype html public "-//W3C//DTD HTML//EN">
<html>
<head>
<title>$IDXTITLE$</title>
</head>
<style type="text/css">
.msg_subject {
  border-color: black;
  border-style: solid;
  border-width: thin;
  color: white;
  background-color: gray;
  font-weight: bold;
  padding-bottom: 0em;
  margin-bottom: 0.25em;
}
.msg_fields {
  font-size: 0.9em;
  font-style: italic;
  margin: 0em 0em 0em 0em;
  padding: 0em 0em 0em 1em;
}
</style>
<body>
<h1>$IDXTITLE$</h1>
</IdxPgBegin>

<!-- The index listing will just be a list of SSI directives. -->
<ListBegin>

</ListBegin>
<LiTemplate>
<!--#include virtual="$MSG$" -->
</LiTemplate>
<ListEnd>

</ListEnd>

<!-- ================================================================== -->
<!--  Message Page							-->
<!-- ================================================================== -->
<!--	For message pages, we remove any <html>, et. al. markup
	since they will not be stand-alone documents but included
	by the index page.
  -->

<!-- Disable follow-up/references section.  This is probably a matter
     of personal preference,  If enabled, the FOLUPLITXT and REFSLITXT
     resources will need to be modified to have relative links to
     messages.
  -->
<NoFolRefs>

<!-- Make sure message-id links (e.g. in-reply-to, references) are
     relative since all messages are on the same page.
  -->
<MsgIdLink>
<a href="#$MSGNUM$">$MSGID$</a>
</MsgIdLink>

<!-- Clear out beginning markup. -->
<MsgPgBegin>

</MsgPgBegin>
<TopLinks>

</TopLinks>

<!-- This will be are physical separator for messages. -->
<SubjectHeader>
<h3 class="msg_subject"><a name="$MSGNUM$">$SUBJECTNA$</a></h3>
<p class="msg_fields">
<b>Date:</b> $MSGLOCALDATE$<br>
<b>From:</b> $FROM$
</p>
</SubjectHeader>

<!-- Only display a very minimal message header.  We already
     rolled a mini-header in SUBJECTHEADER, so we only include
     any additional fields that cannot be referenced via resource
     variables.
     
     We make the style the same as the mini-header above.
  -->
<FieldsBeg>
<p class="msg_fields">
</FieldsBeg>
<LabelBeg>
<b>
</LabelBeg>
<LabelEnd>
:</b>
</LabelEnd>
<FldBeg>

</FldBeg>
<FldEnd>
<br>
</FldEnd>
<FieldsEnd>
</p>
</FieldsEnd>

<FieldOrder>
in-reply-to
references
</FieldOrder>

<HeadBodySep>

</HeadBodySep>

<!-- Clear out ending markup. -->
<MsgBodyEnd>

</MsgBodyEnd>
<BotLinks>

</BotLinks>
<MsgPgEnd>

</MsgPgEnd>

