##---------------------------------------------------------------------------##
##  File:
##	$Id: CharEnt.pm,v 1.3 2002/04/13 00:58:09 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##  Description:
##	Module to deal with 8-bit character data conversion to
##	(SGML) entity references.
##---------------------------------------------------------------------------##
##    Copyright (C) 1997-2002	Earl Hood, earl@earlhood.com
##
##    This program is free software; you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation; either version 2 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program; if not, write to the Free Software
##    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
##    02111-1307, USA
##---------------------------------------------------------------------------##

package MHonArc::CharEnt;

use strict;

##---------------------------------------------------------------------------
##      US-ASCII/Common characters
##---------------------------------------------------------------------------

my %ASCIIMap = (
  #--------------------------------------------------------------------------
  # Hex Code	Entity Ref	# ISO external entity and description
  #--------------------------------------------------------------------------
    0x22 =>	"quot",   	# ISOnum : Quotation mark
    0x26 =>	"amp",  	# ISOnum : Ampersand
    0x3C =>	"lt",   	# ISOnum : Less-than sign
    0x3E =>	"gt",   	# ISOnum : Greater-than sign

    0xA0 =>	"nbsp",  	# ISOnum : NO-BREAK SPACE
);

my %ASCIIMapReverse = reverse %ASCIIMap;

##---------------------------------------------------------------------------
##      Loaded Maps
##---------------------------------------------------------------------------

# character => entity
my %char2ent_maps = (
    'us-ascii'	=> \%ASCIIMap,
);
# entity => character
my %ent2char_maps = (
    'us-ascii'	=> \%ASCIIMapReverse,
);

##---------------------------------------------------------------------------
##      Charset specification to mapping
##---------------------------------------------------------------------------

my %CharsetMaps = (
    'iso-8859-1'  =>	'MHonArc/CharEnt/ISO8859_1.pm',
    'iso-8859-2'  =>	'MHonArc/CharEnt/ISO8859_2.pm',
    'iso-8859-3'  =>	'MHonArc/CharEnt/ISO8859_3.pm',
    'iso-8859-4'  =>	'MHonArc/CharEnt/ISO8859_4.pm',
    'iso-8859-5'  =>	'MHonArc/CharEnt/ISO8859_5.pm',
    'iso-8859-6'  =>	'MHonArc/CharEnt/ISO8859_6.pm',
    'iso-8859-7'  =>	'MHonArc/CharEnt/ISO8859_7.pm',
    'iso-8859-8'  =>	'MHonArc/CharEnt/ISO8859_8.pm',
    'iso-8859-9'  =>	'MHonArc/CharEnt/ISO8859_9.pm',
    'iso-8859-10' =>	'MHonArc/CharEnt/ISO8859_10.pm',
    'iso-8859-15' =>	'MHonArc/CharEnt/ISO8859_15.pm',
    'latin1'      =>	'MHonArc/CharEnt/ISO8859_1.pm',
    'latin2'      =>	'MHonArc/CharEnt/ISO8859_2.pm',
    'latin3'      =>	'MHonArc/CharEnt/ISO8859_3.pm',
    'latin4'      =>	'MHonArc/CharEnt/ISO8859_4.pm',
    'latin5'      =>	'MHonArc/CharEnt/ISO8859_9.pm',
    'latin6'      =>	'MHonArc/CharEnt/ISO8859_10.pm',
    'latin9'      =>	'MHonArc/CharEnt/ISO8859_15.pm',
    'windows-1250'=>	'MHonArc/CharEnt/CP1250.pm',
    'windows-1252'=>	'MHonArc/CharEnt/CP1252.pm',
);

my %ReverseCharsetMaps = (
    'iso-8859-1'  =>	'MHonArc/CharEnt/ISO8859_1R.pm',
    'iso-8859-3'  =>	'MHonArc/CharEnt/ISO8859_3R.pm',
    'iso-8859-7'  =>	'MHonArc/CharEnt/ISO8859_7R.pm',
    'iso-8859-8'  =>	'MHonArc/CharEnt/ISO8859_8R.pm',
    'iso-8859-9'  =>	'MHonArc/CharEnt/ISO8859_9R.pm',
    'iso-8859-15' =>	'MHonArc/CharEnt/ISO8859_15R.pm',
    'latin1'      =>	'MHonArc/CharEnt/ISO8859_1R.pm',
    'latin3'      =>	'MHonArc/CharEnt/ISO8859_3R.pm',
    'latin5'      =>	'MHonArc/CharEnt/ISO8859_9R.pm',
    'latin9'      =>	'MHonArc/CharEnt/ISO8859_15R.pm',
);

###############################################################################
##	Routines
###############################################################################

##---------------------------------------------------------------------------##
##	str2sgml converts a string encoded by $charset to an sgml
##	string where special characters are converted to entity
##	references.
##
##	$return_data = MHonArc::CharEnt::str2sgml($data, $charset, $only8bit);
##
##	If $only8bit is non-zero, than only 8-bit characters are
##	translated.
##
sub str2sgml {
    my $data 	 =    shift;
    my $charset  = lc shift;
    my $only8bit =    shift;

    my($ret, $offset, $len) = ('', 0, 0);
    my($map, $char);
    $charset =~ tr/_/-/;

    # Get mapping
    $map = $char2ent_maps{$charset};
    $map = _load_charmap($charset)  unless defined $map;

    # Convert string
    $len = length($data);
    while ($offset < $len) {
	$char = unpack("C", substr($data, $offset++, 1));
	if ($only8bit && $char < 0xA0) {
	    $ret .= pack("C", $char);
	} elsif ($map->{$char}) {
	    $ret .= join('', '&', $map->{$char}, ';');
	} elsif ($ASCIIMap{$char}) {
	    $ret .= join('', '&', $ASCIIMap{$char}, ';');
	} else {
	    $ret .= pack("C", $char);
	}
    }
    $ret;
}

##---------------------------------------------------------------------------##
##	sgml2str converts a string with sdata character entity references
##	to the raw character values denoted by a character set.
##
##	$return_data = MHonArc::CharEnt::sgml2str($data, $charset);
##
sub sgml2str {
    my $data 	 =    shift;
    my $charset  = lc shift;
    my($map);
    $charset =~ tr/_/-/;

    # Get mapping
    $map = $ent2char_maps{$charset};
    $map = _reverse_load_charmap($charset)  unless defined $map;

    # Convert character entites to raw values
    $data =~ s/\&([\w\.\-]+);
	      /defined($map->{$1}) ? sprintf("%c", $map->{$1}) :
		   defined($ASCIIMapReverse{$1}) ?
		       sprintf("%c", $ASCIIMapReverse{$1}) : "&$1;"
	      /gex;
    $data;
}

##---------------------------------------------------------------------------##

sub _load_charmap {
  my $charset	= shift;
  my $map	= undef;

  my $file = $CharsetMaps{$charset};
  if (!defined($file)) {
      warn 'Warning: MHonArc::CharEnt: Unknown charset: ', $charset, "\n";
      $map = $char2ent_maps{$charset} = { };

  } else {
      delete $INC{$file};
      eval {
	  $map = $char2ent_maps{$charset} = require $file;
      };
      if ($@) {
	  warn 'Warning: MHonArc::CharEnt: ', $@, "\n";
	  $map = $char2ent_maps{$charset} = { };
      }
  }
  $map;
}

sub _reverse_load_charmap {
  my $charset	= shift;
  my $map	= undef;

  my $file = $ReverseCharsetMaps{$charset};
  if (!defined($file)) {
      if (!defined($map = $char2ent_maps{$charset})) {
	  $map = _load_charmap($charset);
      }
      $map = $ent2char_maps{$charset} = { reverse %$map };

  } else {
      delete $INC{$file};
      eval {
	  $map = $ent2char_maps{$charset} = require $file;
      };
      if ($@) {
	  warn 'Warning: MHonArc::CharEnt: ', $@, "\n";
	  $map = $ent2char_maps{$charset} = { };
      }
  }
  $map;
}

##---------------------------------------------------------------------------##
1;

