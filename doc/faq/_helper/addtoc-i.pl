#!/usr/local/bin/perl
#
# $Date: 1998/02/18 16:37:07 $ 

my($tocfile, $toctxt);

foreach $tocfile (@ARGV) {
    if (! -w $tocfile) {
	warn qq/Warning: "$tocfile" is not writable\n/;
	next;
    }
    system("/bin/cp $tocfile $tocfile.$$");
    open(IN, "$tocfile.$$") or die "Unable to open $tocfile\n";
    open(OUT, ">$tocfile") or die "Unable to create $tocfile\n";

    $toctxt = "";
    while (<IN>) {
	chomp;
	next  unless m|<h3|i;
	($id) = m|name="([^"]+)"|i;
	s|</?h\d.*?>||gi;
	s|</?a.*?>||gi;
	s|</?b>||gi;
	s|<img[^>]*>||gi;
	$toctxt .= qq{<li><a href="#$id">$_</a></li>\n};
    }
    seek IN, 0, 0;
    while (<IN>) {
	print OUT $_;
	if (/<!--X-TOC-Start-->/) {
	    while (<IN>) {
		last if (/<!--X-TOC-End-->/);
	    }
	    print OUT "<ul>\n", $toctxt, "</ul>\n",
		      "<!--X-TOC-End-->\n";
	}
    }

    close IN;
    close OUT;
    unlink "$tocfile.$$";
}

exit 0;
