<!-- ================================================================== -->
<!--    $Id: icons.mrc,v 1.6 2003/10/06 22:04:23 ehood Exp $
        Earl Hood <earl @ earlhood  .com>

	This example file makes use of the icons feature of
	MHonArc.  The icon mappings used work with the
	default set of icons provided with the Apache HTTP
	server.
  -->
<!-- ================================================================== -->

<!--	In this example, we only do a chronological index.
  -->
<Main>
<Sort>
<NoThread>
<NoReverse>

<!--	Have LISTBEGIN contain last updated information
  -->
<ListBegin>
<address>
Last update: $LOCALDATE$<br>
$NUMOFMSG$ messages<br>
</address>
<p>
Messages listed in chronological order.  Listing format is the following:
<blockquote>
<img src="/icons/generic.gif" width="20" height="22" alt="* ">
<strong>Subject</strong><code>  </code><em>From</em>
</blockquote>
<p>
<hr>
</ListBegin>

<!--	A listing template with icon usage.  We use $ICONURL$ so
	we can customize the IMG element inorder to specify the
	an alternate ALT attribute value from what $ICON$ would give us.
  -->
<LiTemplate>
<img src="$ICONURL$" width="20" height="22" alt="* "
><strong>$SUBJECT$</strong> <em>$FROMNAME$</em><br>
</LiTemplate>

<ListEnd>

</ListEnd>

<LabelStyles>
-default-
subject:strong
from:strong
</LabelStyles>

<FieldStyles>
-default-
subject:strong
from:strong
</FieldStyles>

<!--	Specify icons for media-types
  -->
<Icons>
*/*;[20x22]/icons/generic.gif
application/*;[20x22]/icons/generic.gif
application/msword;[20x22]/icons/layout.gif
application/octet-stream;[20x22]/icons/binary.gif
application/pdf;[20x22]/icons/pdf.gif
application/postscript;[20x22]/icons/ps.gif
application/rtf;[20x22]/icons/layout.gif
application/x-csh;[20x22]/icons/script.gif
application/x-dvi;[20x22]/icons/dvi.gif
application/x-gtar;[20x22]/icons/tar.gif
application/x-gzip;[20x22]/icons/compressed.gif
application/x-ksh;[20x22]/icons/script.gif
application/x-latex;[20x22]/icons/tex.gif
application/x-patch;[20x22]/icons/patch.gif
application/x-script;[20x22]/icons/script.gif
application/x-sh;[20x22]/icons/script.gif
application/x-tar;[20x22]/icons/tar.gif
application/x-tex;[20x22]/icons/tex.gif
application/x-zip-compressed;[20x22]/icons/compressed.gif
application/zip;[20x22]/icons/compressed.gif
audio/*;[20x22]/icons/sound1.gif
chemical/*;[20x22]/icons/sphere2.gif
image/*;[20x22]/icons/image2.gif
message/external-body;[20x22]/icons/link.gif
multipart/*;[20x22]/icons/layout.gif
text/*;[20x22]/icons/text.gif
video/*;[20x22]/icons/movie.gif
</Icons>

<!--	Override MIMEArgs settings to specify external filter to
	use icons as part of the link to attachments.
  -->
<MIMEArgs override>
m2h_external::filter; useicon inline
</MIMEArgs>
