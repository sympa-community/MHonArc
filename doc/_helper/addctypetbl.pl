#!/usr/local/bin/perl

$filterpl = shift @ARGV;
require $filterpl;

for ($i=0; $i <= $#ARGV; $i++) {
    $file = $ARGV[$i];
    system("/bin/cp $file $file.$$");
    open(IN, "$file.$$") or die "Unable to open $file\n";
    open(OUT, ">$file") or die "Unable to create $file\n";

    while (<IN>) {
	print OUT $_;
	if (/<!--X-Ext-CType-Start-->/) {
	    while (<IN>) {
		last  if /<!--X-Ext-CType-End-->/;
	    }
	    print OUT qq{<table border=1 cellpadding=1>\n},
	    	      qq{<tr bgcolor="#C0C0C0">\n},
		      qq{<th align=left>Content-type</th>},
		      qq{<th align=center>Extension</th>},
		      qq{<th align=left>Description</th>},
		      qq{</tr>\n};
	    foreach $ctype (sort keys %mhonarc::CTExt) {
		($extstr, $desc) = split(/:/, $mhonarc::CTExt{$ctype}, 2);
		$ext = (split(/,/, $extstr))[0];
		print OUT qq{<tr valign="top">\n},
			  qq{<td align=left><strong>$ctype</strong></td>\n},
			  qq{<td align=center><tt>$ext</tt></td>\n},
			  qq{<td>$desc</td></tr>\n};
	    }
	    print OUT "</table>\n";
	    print OUT "<!--X-Ext-CType-End-->\n";
	}
    }

    close IN;
    close OUT;
    unlink "$file.$$";
}

exit 0;
