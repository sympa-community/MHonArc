<!-- ================================================================== -->
<!--  File:
	$Id: secure.mrc,v 1.2 2011/01/09 05:23:25 ehood Exp $
      Author:
	Earl Hood <earl @ earlhood . com>

      Description:
	MHonArc, <http://www.mhonarc.org/>, resource file for
        providing a more secure archive.
  -->
<!-- ================================================================== -->

<!--  For public archive sites, it is HIGHLY RECOMMENDED to neutralize
      HTML.  HTML messages can be used for XSS attacks.  Although
      mhonarc attempts to neutralize HTML, there is no guarantee that
      it is perfect.

      SIMPLE RULE: If the archive receives messages from untrusted
      sources, HTML data SHOULD be neutralized.
  -->

<!-- Many HTML message have an alternative text/plain part,
     therefore, for such messages, lets give preference to
     text/plain part.
  -->
<MIMEAltPrefs>
text/plain
text/html
</MIMEAltPrefs>

<!-- If there is no text/plain part, we treat text/html as plain
     text.  This way, something will show up, but it may not be
     that pretty depending on how the raw HTML data is formatted.
  -->
<MIMEFilters>
text/html;   m2h_text_plain::filter; mhtxtplain.pl
text/x-html; m2h_text_plain::filter; mhtxtplain.pl
</MIMEFilters>

<!-- We use media-type method to define arguments since we do not
     want to interfere with how text/plain may be processed.
     We disable flowed detection since raw HTML may cause undesired
     results.
  -->
<MIMEArgs>
text/html;   disableflowed
text/x-html; disableflowed
</MIMEArgs>

