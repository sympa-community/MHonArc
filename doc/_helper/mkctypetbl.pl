#!/usr/local/bin/perl

select(STDOUT);

print <<'END';
<table border=1 cellspacing=1>
<tr align=left><th>Content-type</th><th>Description</th></tr>
END

while (<>) {
    next  unless /\S/;
    chomp;
    ($ctype, $ext, $desc) = split(/:/, $_, 3);
    print "<tr><td>$ctype</td><td>$desc</td></tr>\n";
}

print <<'END';
</table>
END

