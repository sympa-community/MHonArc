##---------------------------------------------------------------------------##
##  File:
##      $Id: CP1250.pm,v 1.1 2001/09/05 14:16:03 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##  Description:
##      Mappings for Windows-1250 (WinLatin2)
##---------------------------------------------------------------------------##
##    Copyright (C) 2001	Earl Hood, earl@earlhood.com
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

###############################################################################
##	Mapping arrays for characters to entity references
###############################################################################

package MHonArc::CharEnt::CP1250;

##---------------------------------------------------------------------------
##	Windows-1250: WinLatin2
##---------------------------------------------------------------------------

+{
  #--------------------------------------------------------------------------
  # Hex Code	Entity Ref	# ISO external entity and description
  #--------------------------------------------------------------------------
    0x80,	'#x20AC',	# : EURO SIGN
    0x82,	'#x201A',	# : SINGLE LOW-9 QUOTATION MARK
    0x84,	'#x201E',	# : DOUBLE LOW-9 QUOTATION MARK
    0x85,	'#x2026',	# : HORIZONTAL ELLIPSIS
    0x86,	'#x2020',	# : DAGGER
    0x87,	'#x2021',	# : DOUBLE DAGGER
    0x89,	'#x2030',	# : PER MILLE SIGN
    0x8A,	'#x0160',	# : LATIN CAPITAL LETTER S WITH CARON
    0x8B,	'#x2039',	# : SINGLE LEFT-POINTING ANGLE QUOTATION MARK
    0x8C,	'#x015A',	# : LATIN CAPITAL LETTER S WITH ACUTE
    0x8D,	'#x0164',	# : LATIN CAPITAL LETTER T WITH CARON
    0x8E,	'#x017D',	# : LATIN CAPITAL LETTER Z WITH CARON
    0x8F,	'#x0179',	# : LATIN CAPITAL LETTER Z WITH ACUTE
    0x91,	'#x2018',	# : LEFT SINGLE QUOTATION MARK
    0x92,	'#x2019',	# : RIGHT SINGLE QUOTATION MARK
    0x93,	'#x201C',	# : LEFT DOUBLE QUOTATION MARK
    0x94,	'#x201D',	# : RIGHT DOUBLE QUOTATION MARK
    0x95,	'#x2022',	# : BULLET
    0x96,	'#x2013',	# : EN DASH
    0x97,	'#x2014',	# : EM DASH
    0x99,	'#x2122',	# : TRADE MARK SIGN
    0x9A,	'#x0161',	# : LATIN SMALL LETTER S WITH CARON
    0x9B,	'#x203A',	# : SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
    0x9C,	'#x015B',	# : LATIN SMALL LETTER S WITH ACUTE
    0x9D,	'#x0165',	# : LATIN SMALL LETTER T WITH CARON
    0x9E,	'#x017E',	# : LATIN SMALL LETTER Z WITH CARON
    0x9F,	'#x017A',	# : LATIN SMALL LETTER Z WITH ACUTE
    0xA1,	'caron',	# ISOdia : CARON
    0xA2,	'breve',	# ISOdia : BREVE
    0xA3,	'Lstrok',	# ISOlat2: LATIN CAPITAL LETTER L WITH STROKE
    0xA4,	'curren',	# ISOnum : CURRENCY SIGN
    0xA5,	'Aogon',	# ISOlat2: LATIN CAPITAL LETTER A WITH OGONEK
    0xA6,	'brvbar',	# ISOnum : BROKEN BAR
    0xA7,	'sect',		# ISOnum : SECTION SIGN
    0xA8,	'die',		# ISOdia : DIAERESIS
    0xA9,	'copy',		# ISOnum : COPYRIGHT SIGN
    0xAA,	'Scedil',	# ISOlat2: LATIN CAPITAL LETTER S WITH CEDILLA
    0xAB,	'laquo',	# ISOnum : LEFT-POINTING DOUBLE ANGLE
				#	   QUOTATION MARK
    0xAC,	'not',		# ISOnum : NOT SIGN
    0xAD,	'shy',		# ISOnum : SOFT HYPHEN
    0xAE,	'reg',		# ISOnum : REGISTERED SIGN
    0xAF,	'Zdot',		# ISOlat2: LATIN CAPITAL LETTER Z WITH DOT
				#	   ABOVE
    0xB0,	'deg',		# ISOnum : DEGREE SIGN
    0xB1,	'plusmn',	# ISOnum : PLUS-MINUS SIGN
    0xB2,	'ogon',		# ISOdia : OGONEK
    0xB3,	'lstrok',	# ISOlat2: LATIN SMALL LETTER L WITH STROKE
    0xB4,	'acute',	# ISOdia : ACUTE ACCENT
    0xB5,	'micro',	# ISOnum : MICRO SIGN
    0xB6,	'para',		# ISOnum : PILCROW SIGN
    0xB7,	'middot',	# ISOnum : MIDDLE DOT
    0xB8,	'cedil',	# ISOdia : CEDILLA
    0xB9,	'aogon',	# ISOlat2: LATIN SMALL LETTER A WITH OGONEK
    0xBA,	'scedil',	# ISOlat2: LATIN SMALL LETTER S WITH CEDILLA
    0xBB,	'raquo',	# ISOnum : RIGHT-POINTING DOUBLE ANGLE
				#	   QUOTATION MARK
    0xBC,	'Lcaron',	# ISOlat2: LATIN CAPITAL LETTER L WITH CARON
    0xBD,	'dblac',	# ISOdia : DOUBLE ACUTE ACCENT
    0xBE,	'lcaron',	# ISOlat2: LATIN SMALL LETTER L WITH CARON
    0xBF,	'zdot',		# ISOlat2: LATIN SMALL LETTER Z WITH DOT ABOVE
    0xC0,	'Racute',	# ISOlat2: LATIN CAPITAL LETTER R WITH ACUTE
    0xC1,	'Aacute',	# ISOlat1: LATIN CAPITAL LETTER A WITH ACUTE
    0xC2,	'Acirc',	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   CIRCUMFLEX
    0xC3,	'Abreve',	# ISOlat2: LATIN CAPITAL LETTER A WITH BREVE
    0xC4,	'Auml',		# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   DIAERESIS
    0xC5,	'Lacute',	# ISOlat2: LATIN CAPITAL LETTER L WITH ACUTE
    0xC6,	'Cacute',	# ISOlat2: LATIN CAPITAL LETTER C WITH ACUTE
    0xC7,	'Ccedil',	# ISOlat2: LATIN CAPITAL LETTER C WITH CEDILLA
    0xC8,	'Ccaron',	# ISOlat2: LATIN CAPITAL LETTER C WITH CARON
    0xC9,	'Eacute',	# ISOlat1: LATIN CAPITAL LETTER E WITH ACUTE
    0xCA,	'Eogon',	# ISOlat2: LATIN CAPITAL LETTER E WITH OGONEK
    0xCB,	'Euml',		# ISOlat1: LATIN CAPITAL LETTER E WITH
				#	   DIAERESIS
    0xCC,	'Ecaron',	# ISOlat2: LATIN CAPITAL LETTER E WITH CARON
    0xCD,	'Iacute',	# ISOlat1: LATIN CAPITAL LETTER I WITH ACUTE
    0xCE,	'Icirc',	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   CIRCUMFLEX
    0xCF,	'Dcaron',	# ISOlat2: LATIN CAPITAL LETTER D WITH CARON
    0xD0,	'Dstrok',	# ISOlat2: LATIN CAPITAL LETTER D WITH STROKE
    0xD1,	'Nacute',	# ISOlat2: LATIN CAPITAL LETTER N WITH ACUTE
    0xD2,	'Ncaron',	# ISOlat2: LATIN CAPITAL LETTER N WITH CARON
    0xD3,	'Oacute',	# ISOlat1: LATIN CAPITAL LETTER O WITH ACUTE
    0xD4,	'Ocirc',	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   CIRCUMFLEX
    0xD5,	'Odblac',	# ISOlat2: LATIN CAPITAL LETTER O WITH DOUBLE
				#	   ACUTE
    0xD6,	'Ouml',		# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   DIAERESIS
    0xD7,	'times',	# ISOnum : MULTIPLICATION SIGN
    0xD8,	'Rcaron',	# ISOlat2: LATIN CAPITAL LETTER R WITH CARON
    0xD9,	'Uring',	# ISOlat2: LATIN CAPITAL LETTER U WITH RING
				#	   ABOVE
    0xDA,	'Uacute',	# ISOlat1: LATIN CAPITAL LETTER U WITH ACUTE
    0xDB,	'Udblac',	# ISOlat2: LATIN CAPITAL LETTER U WITH DOUBLE
				#	   ACUTE
    0xDC,	'Uuml',		# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   DIAERESIS
    0xDD,	'Yacute',	# ISOlat2: LATIN CAPITAL LETTER Y WITH ACUTE
    0xDE,	'Tcedil',	# ISOlat2: LATIN CAPITAL LETTER T WITH CEDILLA
    0xDF,	'szlig',	# ISOlat1: LATIN SMALL LETTER SHARP S (German)
    0xE0,	'racute',	# ISOlat2: LATIN SMALL LETTER R WITH ACUTE
    0xE1,	'aacute',	# ISOlat1: LATIN SMALL LETTER A WITH ACUTE
    0xE2,	'acirc',	# ISOlat1: LATIN SMALL LETTER A WITH CIRCUMFLEX
    0xE3,	'abreve',	# ISOlat2: LATIN SMALL LETTER A WITH BREVE
    0xE4,	'auml',		# ISOlat1: LATIN SMALL LETTER A WITH DIAERESIS
    0xE5,	'lacute',	# ISOlat2: LATIN SMALL LETTER L WITH ACUTE
    0xE6,	'cacute',	# ISOlat2: LATIN SMALL LETTER C WITH ACUTE
    0xE7,	'ccedil',	# ISOlat1: LATIN SMALL LETTER C WITH CEDILLA
    0xE8,	'ccaron',	# ISOlat2: LATIN SMALL LETTER C WITH CARON
    0xE9,	'eacute',	# ISOlat1: LATIN SMALL LETTER E WITH ACUTE
    0xEA,	'eogon',	# ISOlat2: LATIN SMALL LETTER E WITH OGONEK
    0xEB,	'euml',		# ISOlat1: LATIN SMALL LETTER E WITH DIAERESIS
    0xEC,	'ecaron',	# ISOlat2: LATIN SMALL LETTER E WITH CARON
    0xED,	'iacute',	# ISOlat1: LATIN SMALL LETTER I WITH ACUTE
    0xEE,	'icirc',	# ISOlat1: LATIN SMALL LETTER I WITH CIRCUMFLEX
    0xEF,	'dcaron',	# ISOlat2: LATIN SMALL LETTER D WITH CARON
    0xF0,	'dstrok',	# ISOlat2: LATIN SMALL LETTER D WITH STROKE
    0xF1,	'nacute',	# ISOlat2: LATIN SMALL LETTER N WITH ACUTE
    0xF2,	'ncaron',	# ISOlat2: LATIN SMALL LETTER N WITH CARON
    0xF3,	'oacute',	# ISOlat1: LATIN SMALL LETTER O WITH ACUTE
    0xF4,	'ocirc',	# ISOlat1: LATIN SMALL LETTER O WITH CIRCUMFLEX
    0xF5,	'odblac',	# ISOlat2: LATIN SMALL LETTER O WITH DOUBLE
				#	   ACUTE
    0xF6,	'ouml',		# ISOlat1: LATIN SMALL LETTER O WITH DIAERESIS
    0xF7,	'divide',	# ISOnum : DIVISION SIGN
    0xF8,	'rcaron',	# ISOlat2: LATIN SMALL LETTER R WITH CARON
    0xF9,	'uring',	# ISOlat2: LATIN SMALL LETTER U WITH RING ABOVE
    0xFA,	'uacute',	# ISOlat1: LATIN SMALL LETTER U WITH ACUTE
    0xFB,	'udblac',	# ISOlat2: LATIN SMALL LETTER U WITH DOUBLE
				#	   ACUTE
    0xFC,	'uuml',		# ISOlat1: LATIN SMALL LETTER U WITH DIAERESIS
    0xFD,	'yacute',	# ISOlat1: LATIN SMALL LETTER Y WITH ACUTE
    0xFE,	'tcedil',	# ISOlat2: LATIN SMALL LETTER T WITH CEDILLA
    0xFF,	'dot',		# ISOdia : DOT ABOVE
};
