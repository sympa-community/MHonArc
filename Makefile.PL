#!/usr/bin/perl
# $Id: Makefile.PL,v 1.12 2002/04/04 07:07:48 ehood Exp $
# Pseudo Makefile.PL:  Since MHonArc's history goes back to Perl 4 days,
# it has its own installation process.  This file generates a simple
# Makefile to (paritally) satisfy the standard Perl 5 way to install
# software.

use Config;

open(MAKEFILE, ">Makefile") ||
    die "Unable to create Makefile: $!\n";

## Map variable settings to install.me options
%vars = ( );
foreach (@ARGV) {
  # make sure to only process arguments that look like variables
  if (/=/) {
    ($var, $value) = split(/=/, $_, 2);
    $vars{$var} = $value;
  }
}
my $opt_prefix  = defined($vars{'PREFIX'}) ?
			"-prefix $vars{'PREFIX'}" : "";
my $opt_binpath = defined($vars{'INSTALLSCRIPT'}) ?
			"-prefix $vars{'INSTALLSCRIPT'}" : "";
my $opt_libpath = defined($vars{'LIB'}) ?
			"-libpath $vars{'LIB'}" :
		  defined($vars{'INSTALLSITELIB'}) ?
			"-libpath $vars{'INSTALLSITELIB'}" :
		  defined($vars{'INSTALLPRIVLIB'}) ?
			"-libpath $vars{'INSTALLPRIVLIB'}" : "";
my $opt_manpath = defined($vars{'INSTALLMAN1DIR'}) ?
			"-prefix $vars{'INSTALLMAN1DIR'}" : "";
   $opt_manpath =~ s/man1$//;

my $instme_args = "$opt_prefix $opt_binpath $opt_libpath $opt_manpath";

## Determine which perl should be used
my $perl  = $Config{'perlpath'};
unless (-x $perl) {
  $perl = join('/', $Config{'installbin'}, $Config{'perl'});
}
unless (-x $perl) {
  $perl = 'perl';
}
## Determine other commands that will be used
my $chmod = $Config{'chmod'} || '/bin/chmod';
my $mkdir = $Config{'mkdir'} || '/bin/mkdir';
my $rm    = $Config{'rm'} || '/bin/rm';

## Print Makefile
print MAKEFILE <<EOF;
# This Makefile is for the MHonArc software package.

CHMOD		= $chmod
MKDIR		= $mkdir
RM		= $rm
PRGS		= mhonarc mha-dbrecover mha-dbedit mha-decode
PERL		= $perl
INSTALLPRG	= install.me

.PHONY: default install install-ask pod2man test clean versions relnotes \
	bugs install-doc release-prep autodoc


default: pod2man
	\$(CHMOD) a+x \$(PRGS)
	\$(CHMOD) -R a+r,a+X .

release-prep: autodoc relnotes bugs install-doc

install:
	\$(PERL) \$(INSTALLPRG) -batch $instme_args

install-ask:
	\$(PERL) \$(INSTALLPRG) $instme_args

install-doc:
	w3m doc/install.html -cols 76 > INSTALL

pod2man:
	-\@\$(MKDIR) man
	\@for i in \$(PRGS) ; \\
	    do( \\
		echo "Manifying \$\$i ..."; \\
		pod2man --center="MHonArc Documentation" --release="MHonArc v2.5" \$\$i > man/\$\$i.1; \\
	    ); \\
	done

relnotes:
	w3m doc/relnotes.html -cols 76 > RELNOTES

autodoc: pod2man
	\$(MAKE) -C doc
	\$(MAKE) -C doc/faq

bugs:
	w3m doc/app-bugs.html -cols 76 > BUGS

test:
	\@echo "No tests"

clean:
	\@echo "Nothing to clean"

EOF

close(MAKEFILE);
exit(0);
