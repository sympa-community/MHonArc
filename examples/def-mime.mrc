<!-- ================================================================== -->
<!--    $Id: def-mime.mrc,v 1.13 2002/06/28 03:28:10 ehood Exp $
        Earl Hood <earl@earlhood.com>
  -->
<!--    MHonArc Resource File                                           --
  --                                                                    --
  --    Description:                                                    --
  --	    Default resource settings related to MIME processing	--
  --									-->
<!-- ================================================================== -->

<CharsetConverters>
plain;          mhonarc::htmlize;
us-ascii;       mhonarc::htmlize;
iso-8859-1;     mhonarc::htmlize;
iso-8859-2;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-3;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-4;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-5;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-6;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-7;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-8;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-9;     MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-10;    MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-8859-15;    MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
iso-2022-jp;    iso_2022_jp::str2html;  iso2022jp.pl
latin1;         mhonarc::htmlize;
latin2;         MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
latin3;         MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
latin4;         MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
latin5;         MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
latin6;         MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
latin9;         MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
windows-1250;   MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
windows-1252;   MHonArc::CharEnt::str2sgml;	MHonArc/CharEnt.pm
default;        -ignore-
</CharsetConverters>

<MIMEFilters>
application/ms-tnef;       m2h_null::filter;            mhnull.pl
application/octet-stream;  m2h_external::filter;        mhexternal.pl
application/*;             m2h_external::filter;        mhexternal.pl
application/x-patch;       m2h_text_plain::filter;      mhtxtplain.pl
audio/*;                   m2h_external::filter;        mhexternal.pl
chemical/*;                m2h_external::filter;        mhexternal.pl
model/*;                   m2h_external::filter;        mhexternal.pl
image/*;                   m2h_external::filter;        mhexternal.pl
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
video/*;                   m2h_external::filter;        mhexternal.pl
x-sun-attachment;          m2h_text_plain::filter;      mhtxtplain.pl
</MIMEFilters>

<MIMEArgs>
m2h_external::filter; inline
</MIMEArgs>

<MIMEAltPrefs>
</MIMEAltPrefs>

<MIMEDecoders>
7bit;   	  as-is;
8bit;   	  as-is;
binary;   	  as-is;
base64;   	  base64::b64decode;		base64.pl
quoted-printable; quoted_printable::qprdecode;	qprint.pl
x-uuencode;   	  base64::uudecode;		base64.pl
xuue;   	  base64::uudecode;		base64.pl
uuencode;   	  base64::uudecode;		base64.pl
</MIMEDecoders>
