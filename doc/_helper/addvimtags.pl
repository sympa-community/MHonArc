#!/usr/local/bin/perl

$rclist = shift @ARGV;
open(RC, $rclist) or die "Unable to open $rclist: $!\n";
while (<RC>) {
    next  unless /\S/;
    chomp;
    ($rc, $type, $env, $elem, $clopt, $text) = split(/:/, $_, 6);
    $elem =~ s/[<>]//g;  $elem =~ tr/A-Z/a-z/;
    push(@elem, split(/,/, $elem));
}
close RC;

foreach $file (@ARGV) {
    print STDOUT "$file ...\n";

    system("/bin/cp $file $file.$$");
    open(IN, "$file.$$") or die "Unable to open $file.$$: $!\n";
    open(OUT, ">$file") or die "Unable to create $file: $!\n";

    while (<IN>) {
	print OUT $_;
	if (/^" BEGIN: MHonArc Tags/) {
	    while (<IN>) {
		last if (/^" END: MHonArc Tags/);
	    }
	    foreach $elem (@elem) {
		print OUT qq|syn keyword mhaTagName contained $elem\n|;
	    }
	    print OUT qq/" END: MHonArc Tags\n/;
	    next;
	}
    }

    close IN;
    close OUT;
    unlink "$file.$$";
}

exit 0;

sub htmlize {
    $str = shift;
    $str =~ s/\&/\&amp;/g;
    $str =~ s/</\&lt;/g;
    $str =~ s/>/\&gt;/g;
    $str;
}
