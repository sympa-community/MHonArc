# -*- indent-tabs-mode: nil; -*-
# vim:ft=perl:et:sw=4

use strict;
use warnings;
use English qw(no_match_vars);
use Test::More;

require 'mhopt.pl';
require 'readmail.pl';

mhonarc::mhinit_readmail_vars();

my @tests = map { [split /\n[.]\n/, $_] } split /\n[.][.]\n*/,
    do { local $RS; <DATA> };

foreach my $test (@tests) {
    my ($name, $mesg, $result) = @$test;
    my ($fields, $header_txt) = readmail::MAILread_header(\$mesg);
    my ($disp, $file, $raw, $html_name) =
        readmail::MAILhead_get_disposition($fields);

    is $file, $result, $name;
}

done_testing();

__END__
bug #511: Non-ASCII encoded data is not decoded in filename disposition
.
Content-type: application/pdf;
      name="=?iso-8859-1?Q?CT-564.pdf?="
Content-Disposition: attachment; filename="=?iso-8859-1?Q?CT-564.pdf?="
Content-transfer-encoding: base64

XXX

.
CT-564.pdf
..

