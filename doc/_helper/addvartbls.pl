#!/usr/local/bin/perl

my $tblbegin =<<EndOfText;
<table border=1>
<tr bgcolor="#C0C0C0">
<th>Variable</th><th>Value</th>
</tr>
EndOfText

my $tblend =<<EndOfText;
</table>
EndOfText

my $rcfile = shift @ARGV;
my $varfile = shift @ARGV;

my %Rc2Type = ();
my %RcExceptions = ();

open(RCFILE, $rcfile) or die "Unable to open $rcfile: $!\n";
while (<RCFILE>) {
    chomp;
    $type = '';
    ($rc, $type, $desc) = (split(/:/, $_, 6))[0,1,5];
    @exceptions = ();
    ($type, @exceptions) = split(/,/, $type);
    $Rc2Type{$rc} = $type;
    $RcExceptions{$rc} = {
      'inc'	=> { },
      'exc'	=> { },
    };
    if (@exceptions) {
	foreach $var (@exceptions) {
	    if ($var =~ s/!//) {
		$RcExceptions{$rc}{'exc'}{$var} = 1;
	    } else {
		$RcExceptions{$rc}{'inc'}{$var} = 1;
	    }
	}
    }
}
close(RCFILE);

open(VARFILE, $varfile) or die "Unable to open $varfile: $!\n";
while (<VARFILE>) {
    chomp;
    ($var, $type, $txt) = split(/:/, $_, 3);
    if ($var =~ s/\((\w+)\)//) {
	$VarType{$var} = $1;
    }
    $Vars{$var} = $txt;
    $IdxVars{$var} = $txt  	if $type =~ /I/; # within listing
    $TIdxVars{$var} = $txt  	if $type =~ /T/; # within listing
    $IdxVarsNM{$var} = $txt  	if $type =~ /i/; # outside of listing
    $TIdxVarsNM{$var} = $txt  	if $type =~ /t/; # outside of listing
    $MsgVars{$var} = $txt  	if $type =~ /M/; # message pages
    $MsgFixVars{$var} = $txt  	if $type =~ /F/; # message pages (fixed areas)
    $MailtoURLVars{$var} = $txt if $type =~ /U/; # MAILTOURL
}
close(VARFILE);

$tmpfile = ",$$";
foreach $file (@ARGV) {
    ($rc = $file) =~ s/\..*//;

    $hash = undef;
    $hash = \%MailtoURLVars  	if $Rc2Type{$rc} =~ /U/;
    $hash = \%IdxVars   	if $Rc2Type{$rc} =~ /I/;
    $hash = \%TIdxVars  	if $Rc2Type{$rc} =~ /T/;
    $hash = \%IdxVarsNM   	if $Rc2Type{$rc} =~ /i/;
    $hash = \%TIdxVarsNM  	if $Rc2Type{$rc} =~ /t/;
    $hash = \%MsgVars   	if $Rc2Type{$rc} =~ /M/;
    $hash = \%MsgFixVars  	if $Rc2Type{$rc} =~ /F/;

    &cp($file, $tmpfile);
    open(IN, $tmpfile) or die "Unable to open $tmpfile: $!\n";
    open(OUT, "> $file") or die "Unable to create $file: $!\n";
    while (<IN>) {
	next  unless /<h2>Resource Variables/i;
	print OUT $_;
	while (<IN>) {
	     next unless /^<!-- \*\*\*/;
	     $divider = $_;
	     last;
	}
	print OUT "\n";
	if (defined($hash)) {
	    print OUT $tblbegin;
	    foreach $var (sort(keys(%$hash),
			       keys(%{$RcExceptions{$rc}{'inc'}}))) {
		next  if $RcExceptions{$rc}{'exc'}{$var};
		print OUT "<tr valign=top>\n",
			  '<td align=center><a name="', $var,
			  '" href="../rcvars.html#', $var,
			  '"><strong><code>$',
			  uc $var, '$</code></strong></a></td>',
			  "\n<td>", $Vars{$var}, "</td>\n</tr>\n";
	    }
	    print OUT $tblend;
	} else {
	    print OUT "<p>N/A\n</p>\n";
	}
	print OUT "\n", $divider;
	$_ = '';
    } continue {
	print OUT $_;
    }
}

unlink $tmpfile;

exit 0;

sub cp {
    my($src, $dst) = @_;
    open(SRC, $src) || die "Unable to open $src: $!\n";
    open(DST, "> $dst") || die "Unable to create $dst: $!\n";
    if (-B $src) { binmode( SRC ); binmode( DST ); }
    print DST <SRC>;
    close(SRC);
    close(DST);
}

