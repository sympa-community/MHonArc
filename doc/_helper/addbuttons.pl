#!/usr/local/bin/perl

for ($i=0; $i <= $#ARGV; $i++) {
    $file = $ARGV[$i];
    system("/bin/cp $file $file.$$");
    open(IN, "$file.$$") or die "Unable to open $file\n";
    open(OUT, ">$file") or die "Unable to create $file\n";

    while (<IN>) {
	print OUT $_;
	if (/<!--X-NavButtons-Start-->/) {
	    while (<IN>) {
		last  if /<!--X-NavButtons-End-->/;
	    }
	    print OUT qq|<table width="100%">\n|,
		      qq|<tr valign="top">\n|;
	    print OUT qq|<td align="left"><nobr>|;
	    if ($i > 0) {
		print OUT qq|<a href="|,
			  $ARGV[$i-1],
			  qq|"><img src="prev.png"|,
			  qq|border=0 alt="[Prev]"></a>|;
	    } else {
		print OUT qq|<img src="blank.png"|,
			  qq|border=0 alt="[Prev]">|;
	    }
	    print OUT '&nbsp;&nbsp;&nbsp;</nobr></td>';
	    print OUT qq|<td align="center" width="99%">|,
qq|<a href="mhonarc.html"><img src="up.png" border=0 alt="[TOC]"></a>|,
qq|<a href="faq/faq.html"><img src="faq.png" border=0 alt="[FAQ]"></a>|,
qq|<a href="app-bugs.html"><img src="bug.png" border=0 alt="[Bugs]"></a>|,
qq|<a href="http://www.mhonarc.org/">|,
qq|<img src="home.png" border=0 alt="[Home]"></a>|,
		      qq|</td>|;
	    print OUT qq|<td align="right"><nobr>&nbsp;&nbsp;&nbsp;|;
	    if ($i < $#ARGV) {
		print OUT qq|<a href="|,
			  $ARGV[$i+1],
			  qq|"><img src="next.png" |,
			  qq|border=0 alt="[Next]"></a>|;
	    } else {
		print OUT qq|<img src="blank.png" border=0 alt="[Next]">|;
	    }
	    print OUT qq|</nobr></td></tr></table>\n|;
	    print OUT qq|<!--X-NavButtons-End-->\n|;
	}
    }

    close IN;
    close OUT;
    unlink "$file.$$";
}

exit 0;
