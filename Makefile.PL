#!/usr/bin/perl
# @(#) Makefile.PL 1.4 00/10/28 11:26:52
# Pseudo Makefile.PL:  Since MHonArc's history goes back to Perl 4 days,
# it has its own installation process.  This file generates a simple
# Makefile to (paritally) satisfy the standard Perl 5 way to install
# software.

open(MAKEFILE, ">Makefile") ||
    die "Unable to create Makefile: $!\n";

%vars = ( map { split(/=/, $_) } @ARGV );
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


print MAKEFILE <<EOF;
# This Makefile is for the MHonArc software package.

CHMOD		= /bin/chmod
RM		= /bin/rm
PRGS		= mhonarc mha-dbrecover mha-dbedit mha-decode
PERL		= perl
INSTALLPRG	= install.me

.PHONY		= default install install-ask pod2man test clean versions


default: pod2man
	\$(CHMOD) a+x \$(PRGS)
	\$(CHMOD) -R a+r,a+X .

install:
	\$(PERL) \$(INSTALLPRG) -batch $instme_args

install-ask:
	\$(PERL) \$(INSTALLPRG) $instme_args

pod2man:
	\@for i in \$(PRGS) ; \\
	    do( \\
		echo "Manifying \$\$i ..."; \\
		pod2man \$\$i > man/\$\$i.1; \\
	    ); \\
	done

versions:
	\@echo "SCCS Version Numbers" > VERSIONS
	\@echo "====================" >> VERSIONS
	\@echo "Note: SCCS versions do not correspond to product version" \\
	    >> VERSIONS
	\@echo "--------------------------------------------------------" \\
	    >> VERSIONS
	\@what mhonarc mha-* lib/*.pl >> VERSIONS
	\@echo "Created VERSIONS"

test:
	\@echo "No tests"

clean:
	\@echo "Nothing to clean"

EOF

close(MAKEFILE);
exit(0);
