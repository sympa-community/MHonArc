#!/usr/local/bin/perl
#
# $Date: 1997/05/15 16:06:29 $ 

$tocfile = shift @ARGV;
system("/bin/cp $tocfile $tocfile.$$");
open(IN, "$tocfile.$$") or die "Unable to open $tocfile\n";
open(OUT, ">$tocfile") or die "Unable to create $tocfile\n";

while (<IN>) {
    print OUT $_;
    if (/<!--X-TOC-Start-->/) {
	while (<IN>) {
	    last if (/<!--X-TOC-End-->/);
	}
	foreach $file (@ARGV) {
	    open(FILE, $file) or die "Unable to open $file\n";

	    print OUT "<ul>\n";
	    while (<FILE>) {
		chomp;
		next  unless m|<h2|i;
		($id) = m|name="(.*?)"|i;
		s|</?h\d.*?>||gi; s|</?a.*?>||gi;
		s|<img[^>]*>||gi;
		print OUT qq{<li><a name="$id" href="$file">$_</a>\n<ul>\n};
		last;
	    }
	    while (<FILE>) {
		chomp;
		next  unless m|<h3|i;
		($id) = m|name="(.*?)"|i;
		s|</?h\d.*?>||gi; s|</?a.*?>||gi;
		s|</?b>||gi;
		s|<img[^>]*>||gi;
		print OUT qq{<li><a name="$id" href="$file#$id">$_</a></li>\n};
	    }
	    print OUT "</ul>\n</ul>\n";
	    close FILE;
	}
	print OUT "<!--X-TOC-End-->\n";
    }
}
close IN;
close OUT;
unlink "$tocfile.$$";

exit 0;
