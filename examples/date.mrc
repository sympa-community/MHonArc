<!-- MHonArc Resource File -->
<!-- $Id: date.mrc,v 1.3 2002/05/04 04:52:52 ehood Exp $
     Earl Hood <earl@earlhood.com>
  -->
<!-- This resource file utilizes the day grouping feature of MHonArc
     to format the main index.
  -->

<!--	Specify date sorting.
  -->
<Sort>

<!--	Set USELOCALTIME since local date formats are used when displaying
	dates.
  -->
<UseLocalTime>

<!--    Define message local date format to print day of the week, month,
	month day, and year.  Format used for day group heading.
  -->
<MsgLocalDateFmt>
%B %d, %y
</MsgLocalDateFmt>

<!--	Redefine LISTBEGIN since a table will be used for index listing.
  -->
<ListBegin>
<UL>
<LI><A HREF="$TIDXFNAME$">Thread Index</A></LI>
</UL>
<HR>
<table border=0>
</ListBegin>

<!--	DAYBEGIN defines the markup to be printed when a new day group
	is started.
  -->
<DayBegin>
<tr><td colspan=4><strong>$MSGLOCALDATE$</strong></td></tr>
</DayBegin>

<!--	DAYBEND defines the markup to be printed when a day group
	ends.  No markup is needed in this case, so we leave it blank.
  -->
<DayEnd>

</DayEnd>

<!--	Define LITEMPLATE to display the time of day the message was
	sent, message subject, author, and any annotation for the
	message.
  -->
<LiTemplate>
<tr valign=top>
<td>$MSGLOCALDATE(CUR;%H:%M)$</td>
<td><b>$SUBJECT$</b></td>
<td>$FROMNAME$</td>
<td>$NOTE$</td>
</tr>
</LiTemplate>

<!--	Define LISTEND to close table
  -->
<ListEnd>
</table>
</ListEnd>
