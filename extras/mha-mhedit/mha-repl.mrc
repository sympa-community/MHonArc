<!-- $Id: mha-repl.mrc,v 1.1 2002/12/13 07:24:06 ehood Exp $ -->
<!-- Description:
	mha-mhedit MHonArc resource file to facilitate repl to MIME
	messages.
  -->

<!-- Make sure to null out the message header since all we care
     about is the body -->
<FieldOrder>
</FieldOrder>
<Excs>
.
</Excs>
<MsgPgBegin>
<html>
<body>
</MsgPgBegin>
<SubjectHeader>
<!-- -->
</SubjectHeader>
<HeadBodySep>
<!-- -->
</HeadBodySep>
<MsgBodyEnd>
<!-- -->
</MsgBodyEnd>

<!-- For alternative messages, make sure to use text/plain version
     if available -->
<MIMEAltPrefs>
text/plain
text/html
</MIMEAltPrefs>

<!-- We null-out non-textual data.  The m2h_null::filter will
     generate a one line textual description of the attachment that
     has been excluded.
  -->
<MIMEFilters override>
application/octet-stream;  m2h_null::filter;            mhnull.pl
application/*;             m2h_null::filter;            mhnull.pl
application/x-patch;       m2h_text_plain::filter;      mhtxtplain.pl
audio/*;                   m2h_null::filter;            mhnull.pl
chemical/*;                m2h_null::filter;            mhnull.pl
model/*;                   m2h_null::filter;            mhnull.pl
image/*;                   m2h_null::filter;            mhnull.pl
message/delivery-status;   m2h_text_plain::filter;      mhtxtplain.pl
message/external-body;     m2h_msg_extbody::filter;     mhmsgextbody.pl
message/partial;           m2h_text_plain::filter;      mhtxtplain.pl
text/*;                    m2h_text_plain::filter;      mhtxtplain.pl
text/enriched;             m2h_text_enriched::filter;   mhtxtenrich.pl
text/html;                 m2h_text_html::filter;       mhtxthtml.pl
text/plain;                m2h_text_plain::filter;      mhtxtplain.pl
text/richtext;             m2h_text_enriched::filter;   mhtxtenrich.pl
text/setext;               m2h_text_setext::filter;     mhtxtsetext.pl
text/tab-separated-values; m2h_text_tsv::filter;        mhtxttsv.pl
text/x-html;               m2h_text_html::filter;       mhtxthtml.pl
text/x-setext;             m2h_text_setext::filter;     mhtxtsetext.pl
video/*;                   m2h_null::filter;            mhnull.pl
x-sun-attachment;          m2h_text_plain::filter;      mhtxtplain.pl
</MIMEFilters>

<!-- Disable MHTML processing to avoid extra files from being created.
     *NOTE*: This is only works in MHonArc v2.6.0, and later.
  -->
<MIMEArgs override>
m2h_text_html::filter; disablerelated
</MIMEArgs>
