# -*- indent-tabs-mode: nil; -*-
# vim:ft=perl:et:sw=4

use strict;
use warnings;
use Test::More;

BEGIN {
    eval 'use Test::Compile';
    $Test::Compile::VERSION or plan skip_all => 'Test::Compile required';
}

grep { pl_file_ok $_ }
    qw{mha-dbedit mha-dbrecover mha-decode mhonarc},
    qw{admin/mhaadmin.cgi extras/mha-mhedit/mha-mhedit},
    all_pl_files(qw{contrib examples lib}),
    all_pm_files(qw{lib});

done_testing();

