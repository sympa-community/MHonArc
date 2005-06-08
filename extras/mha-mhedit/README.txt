mha-mhedit - MH/nmh reply editor for multipart, non-text/plain messages

mha-mhedit nicely formats MIME messages for use with MH/nmh's repl(1)
command.

A big deficiency with MH/nmh's repl is that it is not MIME aware,
or more technically, repl filters are not MIME aware. Consequently,
if replying to a multipart, non-plain text message, and your repl
filter includes the body of the message being replied to, all the
MIME formatting is included, which can be messing for binary data,
like images, and for quoted-printable text.

Read mha-mhedit.html or run 'mha-mhedit -man' for full usage
information.

-----------------------------------------------------------------------
$Date: 2005/05/21 21:38:59 $
