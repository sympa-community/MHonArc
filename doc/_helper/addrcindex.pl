#!/usr/local/bin/perl

$rclist = shift @ARGV;
open(RC, $rclist) or die "Unable to open $rclist: $!\n";
while (<RC>) {
    next  unless /\S/;
    chomp;
    ($rc, $type, $env, $elem, $clopt, $text) = split(/:/, $_, 6);
    $rc{$rc} = $text;
    $env{$env} = [ $rc, $text ]  if $env =~ /\S/;
    $elem{$elem} = [ $rc, $text ]  if $elem =~ /\S/;
    $clopt{$clopt} = [ $rc, $text ]  if $clopt =~ /\S/;
}
close RC;

foreach $file (@ARGV) {
    print STDOUT "$file ...\n";

    system("/bin/cp $file $file.$$");
    open(IN, "$file.$$") or die "Unable to open $file.$$: $!\n";
    open(OUT, ">$file") or die "Unable to create $file: $!\n";

    while (<IN>) {
	print OUT $_;
	if (/<!--X-Resource-Index-Start-->/) {
	    while (<IN>) {
		last if (/<!--X-Resource-Index-End-->/);
	    }
	    select(OUT);
	    print <<EndOfText;
<table border=0>
<tr>
<td align="right"><b>Resource</b></td><td><b>Description</b></td>
</tr>
EndOfText

	    foreach $rc (sort keys %rc) {
		$urc = uc $rc;
		print qq|<tr valign="top">|,
		      qq|<td align="right"><b><a name="$rc" href="resources/$rc.html">|,
		      qq|$urc</a></b></td>|,
		      qq|<td>&nbsp;$rc{$rc}</td></tr>\n|;
	    }

	    print <<EndOfText;
</table>
EndOfText
	    print "<!--X-Resource-Index-End-->\n";
	    next;
	}

	if (/<!--X-Envars-Start-->/) {
	    while (<IN>) {
		last if (/<!--X-Envars-End-->/);
	    }
	    select(OUT);
	    print <<EndOfText;
<table border=0>
<tr>
<td align='right'><b>Envariable</b></td><td><b>Description</b></td>
</tr>
EndOfText
	    foreach $env (sort keys %env) {
		@a = map { "<tt>" . htmlize($_) . "</tt>" }
			 split(/,/, $env);
		($rc, $desc) = @{$env{$env}};
		print qq|<tr valign="top">|,
		      qq|<td align="right"><b><a href="resources/$rc.html">|,
		      join('<br>', @a),
		      qq|</a></b></td>|,
		      qq|<td>&nbsp;$desc</td></tr>\n|;
	    }
	    print "</table>\n<!--X-Envars-End-->\n";
	    next;
	}

	if (/<!--X-Elements-Start-->/) {
	    while (<IN>) {
		last if (/<!--X-Elements-End-->/);
	    }
	    select(OUT);
	    print <<EndOfText;
<table border=0>
<tr>
<td align='right'><b>Element</b></td><td><b>Description</b></td>
</tr>
EndOfText
	    foreach $elem (sort keys %elem) {
		@a = map { "<tt>" . htmlize($_) . "</tt>" }
			 split(/,/, $elem);
		($rc, $desc) = @{$elem{$elem}};
		print qq|<tr valign="top">|,
		      qq|<td align="right"><b><a href="resources/$rc.html">|,
		      join('<br>', @a),
		      qq|</a></b></td>|,
		      qq|<td>&nbsp;$desc</td></tr>\n|;
	    }
	    print "</table>\n<!--X-Elements-End-->\n";
	    next;
	}

	if (/<!--X-CLOpts-Start-->/) {
	    while (<IN>) {
		last if (/<!--X-CLOpts-End-->/);
	    }
	    select(OUT);
	    print <<EndOfText;
<table border=0>
<tr>
<td align='right'><b>Option</b></td><td><b>Description</b></td>
</tr>
EndOfText
	    foreach $clopt (sort keys %clopt) {
		@a = map { "<tt>" . htmlize($_) . "</tt>" }
			 split(/,/, $clopt);
		($rc, $desc) = @{$clopt{$clopt}};
		print qq|<tr valign="top">|,
		      qq|<td align="right"><b><a href="resources/$rc.html">|,
		      join('<br>', @a),
		      qq|</a></b></td>|,
		      qq|<td>&nbsp;$desc</td></tr>\n|;
	    }
	    print "</table>\n<!--X-CLOpts-End-->\n";
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
