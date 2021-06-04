##---------------------------------------------------------------------------##
##  File:
##	$Id: Char.pm,v 1.4 2010/12/31 20:34:00 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##  Description:
##	POD after __END__
##---------------------------------------------------------------------------##
##    Copyright (C) 1997-2002	Earl Hood, earl@earlhood.com
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 2 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##---------------------------------------------------------------------------##

package MHonArc::Char;

use strict;
use warnings;

our $VERSION = '2.6.24';

###############################################################################
##	Routines
###############################################################################

##---------------------------------------------------------------------------##
##	map_conv converts a string encoded by $charset to a string
##	defined by a given mapping table.
##
sub map_conv {
    my $data_r    = shift;          # Reference to text
    my $charset   = shift;          # encoding (should be in lowercase
    my $char_maps = shift;          # MHonArc::CharMaps instance
    my @maps      = shift || ();    # Additional maps to use

    # Pre-processing checks
    if ($charset eq 'iso-2022-jp') {
        # iso-2022-jp, convert to euc-jp first
        require MHonArc::Char::JP;
        MHonArc::Char::JP::jp_2022_to_euc($data_r);
        $charset = 'euc-jp';

    } elsif ($charset eq 'iso-2022-kr') {
        # if iso-2022-kr, convert to euc-kr first
        require MHonArc::Char::KR;
        MHonArc::Char::KR::kr_2022_to_euc($data_r);
        $charset = 'cp949';
    }

    # Get mapping
    unshift(@maps, $char_maps->get_map($charset));

    # Convert text
    if ($charset eq 'euc-jp') {
        # Japanese
        _euc_jp_conv($data_r, \@maps);
        return $$data_r;
    }
    if ($charset eq 'cp932') {
        # Japanese ShiftJIS
        _shiftjis_conv($data_r, \@maps);
        return $$data_r;
    }
    if ($charset eq 'cp949') {
        # Korean
        _euc_kr_conv($data_r, \@maps);
        return $$data_r;
    }
    if (   $charset eq 'cp950'
        || $charset eq 'cp936'
        || $charset eq 'gb2312'
        || $charset eq 'big5-eten'
        || $charset eq 'big5-hkscs') {
        # Chinese
        _chinese_conv($data_r, \@maps);
        return $$data_r;
    }

    # Single byte charset
    # Bug #14747: Performance and memory improvement for single byte
    #             charsets.  A regex is dynamically built, specific
    #             to the map(s) provided, so replacement is done
    #             directly by regex engine.
    #             Patch provided by Andrew Shirrayev.
    my ($map, $char, $code, %summap, $summap);
    for ($code = 0x00; $code <= 0xFF; $code++) {
        foreach $map (@maps) {
            $char = $map->{chr($code)};
            last if defined($char);
        }
        unless (defined($char)) {
            next if ($code <= 0x7F);
            $char = '?';
        }
        $summap{chr($code)} = $char;
        $summap .= chr($code);
    }
    # DO NOT use /o here since we need to recompile each time.
    $$data_r =~ s/([$summap])/$summap{$1}/ge;
    $$data_r;
}

sub _euc_jp_conv {
    my $data_r = shift;
    my $maps   = shift;
    my ($map, $char);

    $$data_r =~ s{
	([\x00-\x7E]|
	 [\x8E][\xA1-\xDF]|
	 [\xA1-\xFE][\xA1-\xFE]|
	 \x8F[\xA2-\xFE][\xA1-\xFE])
    }{
	foreach $map (@$maps) {
	    $char = $map->{$1};
	    last  if defined($char);
	}
	$char = (length($1) > 1 ? '?' : $1)  unless defined($char);
	$char;
    }gxe;
}

sub _shiftjis_conv {
    my $data_r = shift;
    my $maps   = shift;
    my ($map, $char);

    $$data_r =~ s{
	([\x00-\x7E]|
	 [\xA1-\xDF]|
	 [\x81-\x9F\xE0-\xEF][\x40-\x7E\x80-\xFC])
    }{
	foreach $map (@$maps) {
	    $char = $map->{$1};
	    last  if defined($char);
	}
	$char = (length($1) > 1 ? '?' : $1)  unless defined($char);
	$char;
    }gxe;
}

sub _euc_kr_conv {
    my $data_r = shift;
    my $maps   = shift;
    my ($map, $char);

    $$data_r =~ s{
	([\x00-\x80]|
	 [\x81-\xFE][\xA1-\xFE])
    }{
	foreach $map (@$maps) {
	    $char = $map->{$1};
	    last  if defined($char);
	}
	$char = (length($1) > 1 ? '?' : $1)  unless defined($char);
	$char;
    }gxe;
}

sub _chinese_conv {
    my $data_r = shift;
    my $maps   = shift;
    my ($map, $char);

    $$data_r =~ s{
	([\x00-\x80]|
	 [\x81-\xFF][\x00-\xFF])
    }{
	foreach $map (@$maps) {
	    $char = $map->{$1};
	    last  if defined($char);
	}
	$char = (length($1) > 1 ? '?' : $1)  unless defined($char);
	$char;
    }gxe;
}

##---------------------------------------------------------------------------##
1;
__END__

=head1 NAME

MHonArc::Char - Character related utilties for MHonArc.

=head1 SYNOPSIS

  use MHonArc::Char;

=head1 DESCRIPTION

MHonArc::Char provides character related utilities.

=head1 VERSION

$Id: Char.pm,v 1.4 2010/12/31 20:34:00 ehood Exp $

=head1 AUTHOR

Earl Hood, earl@earlhood.com

MHonArc comes with ABSOLUTELY NO WARRANTY and MHonArc may be copied only
under the terms of the GNU General Public License, which may be found in
the MHonArc distribution.

=cut

