#!/usr/local/bin/perl
#
# $Date: 2001/09/05 16:04:08 $ 

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
	    print OUT "<p align=center>\n";
	    if ($i > 0) {
		print OUT qq{[<a href="}, $ARGV[$i-1], qq{">Prev</a>]};
	    } else {
		print OUT qq{[Prev]};
	    }
	    if ($i < $#ARGV) {
		print OUT qq{[<a href="}, $ARGV[$i+1], qq{">Next</a>]};
	    } else {
		print OUT qq{[Next]};
	    }
	    print OUT qq{[<a href="faq.html">TOC</a>]};
	    print OUT qq{[<a href="http://www.mhonarc.org/">Home</a>]};
	    print OUT qq{\n</p>\n<!--X-NavButtons-End-->\n};
	}
    }

    close IN;
    close OUT;
    unlink "$file.$$";
}

exit 0;
