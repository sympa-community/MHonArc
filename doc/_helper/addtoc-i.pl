#!/usr/local/bin/perl
#
# $Id: addtoc-i.pl,v 1.2 1999/09/30 16:56:21 ehood Exp $

my($tocfile, $toctxt);
my $h3 = 0;

foreach $tocfile (@ARGV) {
    if (! -w $tocfile) {
	warn qq/Warning: "$tocfile" is not writable\n/;
	next;
    }
    system("/bin/cp $tocfile $tocfile.$$");
    open(IN, "$tocfile.$$") or die "Unable to open $tocfile\n";
    open(OUT, ">$tocfile") or die "Unable to create $tocfile\n";
    $h3 = 0;

    $toctxt = "";
    while (<IN>) {
	chomp;
	next  unless m|<h([23])|i;
	if ($h3 && $1 eq '2') {
	    $h3 = 0;
	    $toctxt .= "</ul>\n";
	} elsif (!$h3 && $1 eq '3') {
	    $h3 = 1;
	    $toctxt .= "<ul>\n";
	}

	($id) = m|name="([^"]+)"|i;
	s|</?h\d.*?>||gi;
	s|</?a.*?>||gi;
	s|</?b>||gi;
	s|<img[^>]*>||gi;
	$toctxt .= qq|<li>|;
	$toctxt .= qq|<small>|   if $h3;
	$toctxt .= qq|<a href="#$id">$_</a>|;
	$toctxt .= qq|</small>|  if $h3;
	$toctxt .= qq|\n|;
    }
    if ($h3) {
	$toctxt .= "</ul>\n";
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
