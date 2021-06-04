# -*- indent-tabs-mode: nil; -*-
# vim:ft=perl:et:sw=4

use strict;
use warnings;
use English qw(no_match_vars);
use Test::More;

require 'mhopt.pl';
require 'readmail.pl';
require 'ewhutil.pl';    # for htmlize()
# Dummies for tests
sub mhonarc::dir_create {1}
sub mhonarc::file_temp  { my $x; open my $fh, '>', \$x; return ($fh, '') }
sub mhonarc::file_chmod {1}

mhonarc::mhinit_readmail_vars();

my @tests = map { [split /\n[.]\n/, $_] } split /\n[.][.]\n*/,
    do { local $RS; <DATA> };

foreach my $test (@tests) {
    my ($name, $mesg, $result) = @$test;
    my ($fields, $header_txt) = readmail::MAILread_header(\$mesg);
    my ($ret, @files) = readmail::MAILread_body($fields, \$mesg);

    ok $ret =~ /$result/, $name;
    diag "Returned:\n$ret" unless $ret =~ /$result/;
}

done_testing();

__END__
GH#16: Content-Description fields are omitted with inline images
.
Content-type: image/jpeg; name="image.jpg"
Content-Description: This is a JPEG file
Content-Disposition: inline; filename="image.jpg"
Content-transfer-encoding: base64

XXXX

.
This is a JPEG file
..
GH#16: Content-Description fields are omitted with inline images
.
Content-type: image/jpeg; name="image.jpg"
Content-Description: This is a JPEG file
Content-Disposition: attachment; filename="image.jpg"
Content-transfer-encoding: base64

XXXX

.
This is a JPEG file
..

