#!/usr/local/bin/perl

my %elem = ( );
my %rcvar = ( );

$rclist = shift @ARGV;
open(RC, $rclist) or die "Unable to open $rclist: $!\n";
while (<RC>) {
    next  unless /\S/;
    ($rc, $elems) = (split(/:/, $_, 6))[0,3];
    next  unless $elems =~ /\S/;
    $elems =~ s/[<>]//g;
    @a = map { lc $_ } split(/,/, $elems);
    foreach $elem (@a) {
	$elem{$elem} = $rc;
    }
}
close RC;

$rcvarlist = shift @ARGV;
open(RC, $rcvarlist) or die "Unable to open $rcvarlist: $!\n";
while (<RC>) {
    next  unless /\S/;
    ($rcvar) = (split(/:/, $_, 2))[0];
    $rcvar =~ s/\([^)]*\)//;
    $rcvar{$rcvar} = 1;
}
close RC;

#foreach (sort keys %rcvar) { print STDERR "$_\n"; }

print <<'EOT';
<html>
<body>
<pre>
EOT

LINE: while (<>) {
    ELEM: {
	if (/^\s*<(\w[\w\-]*)[^>]*>\s*$/) {
	    if ($rc = $elem{lc $1}) {
		chomp;
		print qq|<b><a href="../resources/$rc.html">|,
		      htmlize($_),
		      qq|</a></b>\n|;
	    } else {
		last ELEM;
	    }
	    next LINE;
	}

	if (/^\s*<\/(\w[\w\-]*)/) {
	    if ($rc = $elem{lc $1}) {
		chomp;
		print '<b>', htmlize($_), "</b>\n";
	    } else {
		last ELEM;
	    }
	    next LINE;
	}
    }

    @a = split(/(\$[^\$]+\$)/, $_);
    foreach $val (@a) {
	if ( ($val =~ /^\$/) &&
	     ($val =~ /([\w\-]+)/) &&
	     $rcvar{$1}) {
	    print qq|<b><a href="../rcvars.html#$1">|,
		  htmlize($val),
		  qq|</a></b>|;
	    next;
	}
	print htmlize($val);
    }
}

print <<'EOT';
</pre>
</body>
</html>
EOT

sub htmlize {
    my $str = shift;
    $str =~ s/&/&amp;/g;
    $str =~ s/</&lt;/g;
    $str =~ s/>/&gt;/g;
    $str;
}

