#!/usr/local/bin/perl -w
#==========================================================================
# $Id: addrcnav.pl,v 1.1 2002/07/27 05:13:10 ehood Exp $
# Description:
#	Generate nav links for resource reference pages.
#==========================================================================

my $tblbegin =<<EndOfText;
<!--x-rc-nav-->
<table border=0><tr valign="top">
EndOfText

my $tblend =<<EndOfText;
</tr></table>
<!--/x-rc-nav-->
EndOfText

$tmpfile = ",$$";
for ($i=0; $i < scalar(@ARGV); ++$i) {
  $file = $ARGV[$i];
  print STDOUT qq/Processing "$file" ...\n/;
  ($rcname = $file) =~ s/\.html$//;
  #$rcname_uc = uc $rcname;

  if ($i != 0) {
    ($prev_rcname = $ARGV[$i-1]) =~ s/\.html$//;
    $prev_rcname_uc = uc $prev_rcname;
  } else {
    $prev_rcname = undef;
    $prev_rcname_uc = undef;
  }
  if ($i != $#ARGV) {
    ($next_rcname = $ARGV[$i+1]) =~ s/\.html$//;
    $next_rcname_uc = uc $next_rcname;
  } else {
    $next_rcname = undef;
    $next_rcname_uc = undef;
  }

  $link_text = $tblbegin . '<td align="left" width="50%">';
  if (defined($prev_rcname)) {
    $link_text .= qq|[Prev:&nbsp;| .
		  qq|<a href="$prev_rcname.html">$prev_rcname_uc</a>]|;
  } else {
    $link_text .= "&nbsp;\n";
  }
  $link_text .= qq|</td>|.
      qq|<td><nobr>[<a href="../resources.html#$rcname">Resources</a>]|.
      qq|[<a href="../mhonarc.html">TOC</a>]|.
      qq|</nobr></td><td align="right" width="50%">|;
  if (defined($next_rcname)) {
    $link_text .= qq|[Next:&nbsp;|.
		  qq|<a href="$next_rcname.html">$next_rcname_uc</a>]|;
  } else {
    $link_text .= "&nbsp;\n";
  }
  $link_text .= '</td>'. $tblend;

  open(IN, $file) || die qq/Unable to open "$file": $!/;
  open(OUT, ">$tmpfile") || die qq/Unable to create "$tmpfile": $!/;

  $okay = 0;
  while (<IN>) {
    if (/<!--x-rc-nav-->/) {
      while (<IN>) {
	if (/<!--\/x-rc-nav-->/) {
	  print OUT $link_text;
	  $okay = 1;
	  last;
	}
      }
      if (!$okay) {
	die qq/Hit EOF early for "$file"/;
      }
      next;
    }
    print OUT $_;
  }
  close(OUT);
  close(IN);
  rename($tmpfile, $file) ||
      die qq/Unable to rename "$tmpfile" to "$file": $!/;
}
