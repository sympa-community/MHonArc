##---------------------------------------------------------------------------##
##  File:
##      $Id: ISO8859_15R.pm,v 1.1 2002/04/13 00:58:11 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##	Jan Kraeber	jmk@kraeber.de
##  Description:
##      Reverse mappings for ISO-8859-15.
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

package MHonArc::CharEnt::ISO8859_15R;

##---------------------------------------------------------------------------
##      ISO-8859-15
##---------------------------------------------------------------------------

+{
  #--------------------------------------------------------------------------
  #  Entity	   Hex Code	# ISO external entity and description
  #--------------------------------------------------------------------------
    'iexcl'	=> 0xA1,	# ISOnum : INVERTED EXCLAMATION MARK
    'cent'	=> 0xA2,	# ISOnum : CENT SIGN
    'pound'	=> 0xA3,	# ISOnum : POUND SIGN
    'euro'	=> 0xA4,	# ISOlat9: CURRENCY SIGN
    'yen'	=> 0xA5,	# ISOnum : YEN SIGN
    'Scaron'	=> 0xA6,	# ISOlat9: SCARON
    'sect'	=> 0xA7,	# ISOnum : SECTION SIGN
    'scaron'	=> 0xA8,	# ISOlat9: SCARON SMALL
    'copy'	=> 0xA9,	# ISOnum : COPYRIGHT SIGN
    'ordf'	=> 0xAA,	# ISOnum : FEMININE ORDINAL INDICATOR
    'laquo'	=> 0xAB,	# ISOnum : LEFT-POINTING DOUBLE ANGLE
				#	   QUOTATION MARK
    'not'	=> 0xAC,	# ISOnum : NOT SIGN
    'shy'	=> 0xAD,	# ISOnum : SOFT HYPHEN
    'reg'	=> 0xAE,	# ISOnum : REGISTERED SIGN
    'macr'	=> 0xAF,	# ISOdia : OVERLINE (MACRON)
    'deg'	=> 0xB0,	# ISOnum : DEGREE SIGN
    'plusmn'	=> 0xB1,	# ISOnum : PLUS-MINUS SIGN
    'sup2'	=> 0xB2,	# ISOnum : SUPERSCRIPT TWO
    'sup3'	=> 0xB3,	# ISOnum : SUPERSCRIPT THREE
    'Zcaron'	=> 0xB4,	# ISOlat9: ZCARON
    'micro'	=> 0xB5,	# ISOnum : MICRO SIGN
    'para'	=> 0xB6,	# ISOnum : PILCROW SIGN
    'middot'	=> 0xB7,	# ISOnum : MIDDLE DOT
    'zcaron'	=> 0xB8,	# ISOlat9: ZCARON SMALL
    'sup1'	=> 0xB9,	# ISOnum : SUPERSCRIPT ONE
    'ordm'	=> 0xBA,	# ISOnum : MASCULINE ORDINAL INDICATOR
    'raquo'	=> 0xBB,	# ISOnum : RIGHT-POINTING DOUBLE ANGLE
				#	   QUOTATION MARK
    'OElig'	=> 0xBC,	# ISOlat9: OELIG
    'oelig'	=> 0xBD,	# ISOlat9: OELIG SMALL
    'Yuml'	=> 0xBE,	# ISOlat9: YUML
    'iquest'	=> 0xBF,	# ISOnum : INVERTED QUESTION MARK
    'Agrave'	=> 0xC0,	# ISOlat1: LATIN CAPITAL LETTER A WITH GRAVE
    'Aacute'	=> 0xC1,	# ISOlat1: LATIN CAPITAL LETTER A WITH ACUTE
    'Acirc'	=> 0xC2,	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   CIRCUMFLEX
    'Atilde'	=> 0xC3,	# ISOlat1: LATIN CAPITAL LETTER A WITH TILDE
    'Auml'	=> 0xC4,	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   DIAERESIS
    'Aring'	=> 0xC5,	# ISOlat1: LATIN CAPITAL LETTER A WITH RING
				#	   ABOVE
    'AElig'	=> 0xC6,	# ISOlat1: LATIN CAPITAL LETTER AE
    'Ccedil'	=> 0xC7,	# ISOlat1: LATIN CAPITAL LETTER C WITH CEDILLA
    'Egrave'	=> 0xC8,	# ISOlat1: LATIN CAPITAL LETTER E WITH GRAVE
    'Eacute'	=> 0xC9,	# ISOlat1: LATIN CAPITAL LETTER E WITH ACUTE
    'Ecirc'	=> 0xCA,	# ISOlat1: LATIN CAPITAL LETTER E WITH
				#	   CIRCUMFLEX
    'Euml'	=> 0xCB,	# ISOlat1: LATIN CAPITAL LETTER E WITH
				#	   DIAERESIS
    'Igrave'	=> 0xCC,	# ISOlat1: LATIN CAPITAL LETTER I WITH GRAVE
    'Iacute'	=> 0xCD,	# ISOlat1: LATIN CAPITAL LETTER I WITH ACUTE
    'Icirc'	=> 0xCE,	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   CIRCUMFLEX
    'Iuml'	=> 0xCF,	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   DIAERESIS
    'ETH'	=> 0xD0,	# ISOlat1: LATIN CAPITAL LETTER ETH (Icelandic)
    'Ntilde'	=> 0xD1,	# ISOlat1: LATIN CAPITAL LETTER N WITH TILDE
    'Ograve'	=> 0xD2,	# ISOlat1: LATIN CAPITAL LETTER O WITH GRAVE
    'Oacute'	=> 0xD3,	# ISOlat1: LATIN CAPITAL LETTER O WITH ACUTE
    'Ocirc'	=> 0xD4,	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   CIRCUMFLEX
    'Otilde'	=> 0xD5,	# ISOlat1: LATIN CAPITAL LETTER O WITH TILDE
    'Ouml'	=> 0xD6,	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   DIAERESIS
    'times'	=> 0xD7,	# ISOnum : MULTIPLICATION SIGN
    'Oslash'	=> 0xD8,	# ISOlat1: LATIN CAPITAL LETTER O WITH STROKE
    'Ugrave'	=> 0xD9,	# ISOlat1: LATIN CAPITAL LETTER U WITH GRAVE
    'Uacute'	=> 0xDA,	# ISOlat1: LATIN CAPITAL LETTER U WITH ACUTE
    'Ucirc'	=> 0xDB,	# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   CIRCUMFLEX
    'Uuml'	=> 0xDC,	# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   DIAERESIS
    'Yacute'	=> 0xDD,	# ISOlat1: LATIN CAPITAL LETTER Y WITH ACUTE
    'THORN'	=> 0xDE,	# ISOlat1: LATIN CAPITAL LETTER THORN
				#	   (Icelandic)
    'szlig'	=> 0xDF,	# ISOlat1: LATIN SMALL LETTER SHARP S (German)
    'agrave'	=> 0xE0,	# ISOlat1: LATIN SMALL LETTER A WITH GRAVE
    'aacute'	=> 0xE1,	# ISOlat1: LATIN SMALL LETTER A WITH ACUTE
    'acirc'	=> 0xE2,	# ISOlat1: LATIN SMALL LETTER A WITH CIRCUMFLEX
    'atilde'	=> 0xE3,	# ISOlat1: LATIN SMALL LETTER A WITH TILDE
    'auml'	=> 0xE4,	# ISOlat1: LATIN SMALL LETTER A WITH DIAERESIS
    'aring'	=> 0xE5,	# ISOlat1: LATIN SMALL LETTER A WITH RING ABOVE
    'aelig'	=> 0xE6,	# ISOlat1: LATIN SMALL LETTER AE
    'ccedil'	=> 0xE7,	# ISOlat1: LATIN SMALL LETTER C WITH CEDILLA
    'egrave'	=> 0xE8,	# ISOlat1: LATIN SMALL LETTER E WITH GRAVE
    'eacute'	=> 0xE9,	# ISOlat1: LATIN SMALL LETTER E WITH ACUTE
    'ecirc'	=> 0xEA,	# ISOlat1: LATIN SMALL LETTER E WITH CIRCUMFLEX
    'euml'	=> 0xEB,	# ISOlat1: LATIN SMALL LETTER E WITH DIAERESIS
    'igrave'	=> 0xEC,	# ISOlat1: LATIN SMALL LETTER I WITH GRAVE
    'iacute'	=> 0xED,	# ISOlat1: LATIN SMALL LETTER I WITH ACUTE
    'icirc'	=> 0xEE,	# ISOlat1: LATIN SMALL LETTER I WITH CIRCUMFLEX
    'iuml'	=> 0xEF,	# ISOlat1: LATIN SMALL LETTER I WITH DIAERESIS
    'eth'	=> 0xF0,	# ISOlat1: LATIN SMALL LETTER ETH (Icelandic)
    'ntilde'	=> 0xF1,	# ISOlat1: LATIN SMALL LETTER N WITH TILDE
    'ograve'	=> 0xF2,	# ISOlat1: LATIN SMALL LETTER O WITH GRAVE
    'oacute'	=> 0xF3,	# ISOlat1: LATIN SMALL LETTER O WITH ACUTE
    'ocirc'	=> 0xF4,	# ISOlat1: LATIN SMALL LETTER O WITH CIRCUMFLEX
    'otilde'	=> 0xF5,	# ISOlat1: LATIN SMALL LETTER O WITH TILDE
    'ouml'	=> 0xF6,	# ISOlat1: LATIN SMALL LETTER O WITH DIAERESIS
    'divide'	=> 0xF7,	# ISOnum : DIVISION SIGN
    'oslash'	=> 0xF8,	# ISOlat1: LATIN SMALL LETTER O WITH STROKE
    'ugrave'	=> 0xF9,	# ISOlat1: LATIN SMALL LETTER U WITH GRAVE
    'uacute'	=> 0xFA,	# ISOlat1: LATIN SMALL LETTER U WITH ACUTE
    'ucirc'	=> 0xFB,	# ISOlat1: LATIN SMALL LETTER U WITH CIRCUMFLEX
    'uuml'	=> 0xFC,	# ISOlat1: LATIN SMALL LETTER U WITH DIAERESIS
    'yacute'	=> 0xFD,	# ISOlat1: LATIN SMALL LETTER Y WITH ACUTE
    'thorn'	=> 0xFE,	# ISOlat1: LATIN SMALL LETTER THORN
				#	   (Icelandic)
    'yuml'	=> 0xFF,	# ISOlat1: LATIN SMALL LETTER Y WITH DIAERESIS
};
