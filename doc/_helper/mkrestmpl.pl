#!/usr/local/bin/perl

while (<>) {
    chomp;
    s/:.*//;
    $name = $_;
    ($Name = $_) =~ tr/a-z/A-Z/;

    next  if -e "$name.html";

    open(FILE, "> $name.html") || die "Unable to create $name\n";
    select(FILE);
    print <<EndOfText;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML//EN">
<html>
<head>
<title>MHonArc Resources: $Name</title>
</head>
<body>

<em><a href="../resources.html#$name">MHonArc Resource List</a></em> |
<a href="../mhonarc.html">TOC</a>

<hr>
<h1>$Name</h1>

<!-- *************************************************************** -->
<hr>
<h2>Syntax</h2>

<dl>

<dt><strong>Envariable</strong></dt>
<dd><p>
<code>M2H_$Name=</code>
</p>
</dd>

<dt><strong>Element</strong></dt>
<dd><p>
<code>&lt;$Name&gt;</code><br>
<code>&lt;/$Name&gt;</code><br>
</p>
</dd>

<dt><strong>Command-line Option</strong></dt>
<dd><p>
<code>-$name </code>
</p>
</dd>

</dl>

<!-- *************************************************************** -->
<hr>
<h2>Description</h2>

<p>
</p>

<!-- *************************************************************** -->
<hr>
<h2>Default Setting</h2>

<p>
</p>

<!-- *************************************************************** -->
<hr>
<h2>Resource Variables</h2>

<p>N/A
</p>

<!-- *************************************************************** -->
<hr>
<h2>Examples</h2>

<p>None.
</p>

<!-- *************************************************************** -->
<hr>
<h2>Version</h2>

<p>
</p>

<!-- *************************************************************** -->
<hr>
<h2>See Also</h2>

<p>
</p>

<!-- *************************************************************** -->
<hr>
<address>
\$Date\$<br>
<img align="top" src="../monicon.png" alt="">
<a href="http://www.mhonarc.org/"><strong>MHonArc</strong></a><br>
Copyright &#169; 2002, <a href="http://www.earlhood.com/"
>Earl Hood</a>, <a href="mailto:mhonarc\@mhonarc.org"
>mhonarc\@mhonarc.org</a><br>
</address>

</body>
</html>
EndOfText

    close(FILE);
    print STDOUT "Created $name\n";
}
