#!/usr/local/bin/perl
## !!!NO LONGER USED!!!

$bugfile = shift @ARGV;
$file = shift @ARGV;

system("/bin/cp $file $file.$$");
open(IN, "$file.$$") or die "Unable to open $file\n";
open(OUT, ">$file") or die "Unable to create $file\n";
open(BUGS, "$bugfile") or die "Unable to open $bugfile\n";

while (<IN>) {
    print OUT $_;
    if (/<!--X-BugList-Start-->/) {
	while (<IN>) {
	    last  if /<!--X-BugList-End-->/;
	}
	print OUT qq{<table border=0 cellspacing=0 cellpadding=4 width="100%">\n};

	while (<BUGS>) { last  if /^------------------/; }
	%h = ();
	while (<BUGS>) {
	    if (/^------------------/) {
		if (%h) {
		    $text =<<EndOfText;
<tr valign=top>
<td colspan=2><hr noshade size=0></td>
</tr>
<tr valign=top>
<td align=right><strong>Version:</strong></td>
<td align=left>$h{"Version"}</td>
</tr>
<tr valign=top>
<td align=right><strong>Problem:</strong></td>
<td align=left>$h{"Problem"}</td>
</tr>
<tr valign=top>
<td align=right><strong>Solution:</strong></td>
<td align=left>$h{"Solution"}</td>
</tr>
<tr valign=top>
<td align=right><strong>Fixed:</strong></td>
<td align=left>$h{"Version Fixed"}</td>
</tr>
EndOfText
		    print OUT $text;
		}
		%h = ();
		next;
	    }
	    if (/^\S/) {
		/^([^:]+):\s*(.*)$/;
		$key = $1;
		$h{$key} = &htmlize($2);
		next;
	    }
	    s/^\s+//;
	    $h{$key} .= " " . &htmlize($_);
	}
	print OUT qq{</table>\n};
	print OUT "<!--X-BugList-End-->\n";
    }
}

close IN;
close OUT;
close BUGS;
unlink "$file.$$";

exit 0;

sub htmlize {
    my $str = shift;

    $str =~ s/\&/\&amp;/g;
    $str =~ s/</\&lt;/g;
    $str;
}
