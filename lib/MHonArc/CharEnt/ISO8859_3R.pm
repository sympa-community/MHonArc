##---------------------------------------------------------------------------##
##  File:
##      $Id: ISO8859_3R.pm,v 1.1 2001/08/19 09:53:55 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##  Description:
##      Mappings for ISO-8859-1.
##---------------------------------------------------------------------------##
##    Copyright (C) 1997,2001	Earl Hood, earl@earlhood.com
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

package MHonArc::CharEnt::ISO8859_3R;

##---------------------------------------------------------------------------
##      ISO-8859-3
##---------------------------------------------------------------------------

+{
  #--------------------------------------------------------------------------
  #  Entity	   Hex Code	# ISO external entity and description
  #--------------------------------------------------------------------------
    'Hstrok'	=> 0xA1,	# ISOlat2: LATIN CAPITAL LETTER H WITH STROKE
    'breve'	=> 0xA2,	# ISOdia : BREVE
    'pound'	=> 0xA3,	# ISOnum : POUND SIGN
    'curren'	=> 0xA4,	# ISOnum : CURRENCY SIGN
    'Hcirc'	=> 0xA6,	# ISOlat2: LATIN CAPITAL LETTER H WITH
				#	   CIRCUMFLEX
    'sect'	=> 0xA7,	# ISOnum : SECTION SIGN
    'die'	=> 0xA8,	# ISOdia : DIAERESIS
    'Idot'	=> 0xA9,	# ISOlat2: LATIN CAPITAL LETTER I WITH DOT
				#	   ABOVE
    'Scedil'	=> 0xAA,	# ISOlat2: LATIN CAPITAL LETTER S WITH CEDILLA
    'Gbreve'	=> 0xAB,	# ISOlat2: LATIN CAPITAL LETTER G WITH BREVE
    'Jcirc'	=> 0xAC,	# ISOlat2: LATIN CAPITAL LETTER J WITH
				#	   CIRCUMFLEX
    'shy'	=> 0xAD,	# ISOnum : SOFT HYPHEN
    'Zdot'	=> 0xAF,	# ISOlat2: LATIN CAPITAL LETTER Z WITH DOT
				#	   ABOVE
    'deg'	=> 0xB0,	# ISOnum : DEGREE SIGN
    'hstrok'	=> 0xB1,	# ISOlat2: LATIN SMALL LETTER H WITH STROKE
    'sup2'	=> 0xB2,	# ISOnum : SUPERSCRIPT TWO
    'sup3'	=> 0xB3,	# ISOnum : SUPERSCRIPT THREE
    'acute'	=> 0xB4,	# ISOdia : ACUTE ACCENT
    'micro'	=> 0xB5,	# ISOnum : MICRO SIGN
    'hcirc'	=> 0xB6,	# ISOlat2: LATIN SMALL LETTER H WITH
				#	   CIRCUMFLEX
    'middot'	=> 0xB7,	# ISOnum : MIDDLE DOT
    'cedil'	=> 0xB8,	# ISOdia : CEDILLA
    'inodot'	=> 0xB9,	# ISOlat2: LATIN SMALL LETTER I DOTLESS
    'scedil'	=> 0xBA,	# ISOlat2: LATIN SMALL LETTER S WITH CEDILLA
    'gbreve'	=> 0xBB,	# ISOlat2: LATIN SMALL LETTER G WITH BREVE
    'jcirc'	=> 0xBC,	# ISOlat2: LATIN SMALL LETTER J WITH CIRCUMFLEX
    'frac12'	=> 0xBD,	# ISOnum : VULGAR FRACTION ONE HALF
    'half'	=> 0xBD,	# ISOnum : VULGAR FRACTION ONE HALF
    'zdot'	=> 0xBF,	# ISOlat2: LATIN SMALL LETTER Z WITH DOT ABOVE
    'Agrave'	=> 0xC0,	# ISOlat1: LATIN CAPITAL LETTER A WITH GRAVE
    'Aacute'	=> 0xC1,	# ISOlat1: LATIN CAPITAL LETTER A WITH ACUTE
    'Acirc'	=> 0xC2,	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   CIRCUMFLEX
    'Auml'	=> 0xC4,	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   DIAERESIS
    'Cdot'	=> 0xC5,	# ISOlat2: LATIN CAPITAL LETTER C WITH DOT
				#	   ABOVE
    'Ccirc'	=> 0xC6,	# ISOlat2: LATIN CAPITAL LETTER C WITH
				#	   CIRCUMFLEX
    'Ccedil'	=> 0xC7,	# ISOlat2: LATIN CAPITAL LETTER C WITH CEDILLA
    'Egrave'	=> 0xC8,	# ISOlat1: LATIN CAPITAL LETTER E WITH GRAVE
    'Eacute'	=> 0xC9,	# ISOlat1: LATIN CAPITAL LETTER E WITH ACUTE
    'Ecirc'	=> 0xCA,	# ISOlat2: LATIN CAPITAL LETTER E WITH
				#	   CIRCUMFLEX
    'Euml'	=> 0xCB,	# ISOlat1: LATIN CAPITAL LETTER E WITH
				#	   DIAERESIS
    'Igrave'	=> 0xCC,	# ISOlat1: LATIN CAPITAL LETTER I WITH GRAVE
    'Iacute'	=> 0xCD,	# ISOlat1: LATIN CAPITAL LETTER I WITH ACUTE
    'Icirc'	=> 0xCE,	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   CIRCUMFLEX
    'Iuml'	=> 0xCF,	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   DIAERESIS
    'Ntilde'	=> 0xD1,	# ISOlat1: LATIN CAPITAL LETTER N WITH TILDE
    'Ograve'	=> 0xD2,	# ISOlat1: LATIN CAPITAL LETTER O WITH GRAVE
    'Oacute'	=> 0xD3,	# ISOlat1: LATIN CAPITAL LETTER O WITH ACUTE
    'Ocirc'	=> 0xD4,	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   CIRCUMFLEX
    'Gdot'	=> 0xD5,	# ISOlat2: LATIN CAPITAL LETTER G WITH DOT
				#	   ABOVE
    'Ouml'	=> 0xD6,	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   DIAERESIS
    'times'	=> 0xD7,	# ISOnum : MULTIPLICATION SIGN
    'Gcirc'	=> 0xD8,	# ISOlat2: LATIN CAPITAL LETTER G WITH
				#	   CIRCUMFLEX
    'Ugrave'	=> 0xD9,	# ISOlat1: LATIN CAPITAL LETTER U WITH GRAVE
				#	   ABOVE
    'Uacute'	=> 0xDA,	# ISOlat1: LATIN CAPITAL LETTER U WITH ACUTE
    'Ucirc'	=> 0xDB,	# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   CIRCUMFLEX
    'Uuml'	=> 0xDC,	# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   DIAERESIS
    'Ubreve'	=> 0xDD,	# ISOlat2: LATIN CAPITAL LETTER U WITH BREVE
    'Scirc'	=> 0xDE,	# ISOlat2: LATIN CAPITAL LETTER S WITH
				#	   CIRCUMFLEX
    'szlig'	=> 0xDF,	# ISOlat1: LATIN SMALL LETTER SHARP S (German)
    'agrave'	=> 0xE0,	# ISOlat1: LATIN SMALL LETTER A WITH GRAVE
    'aacute'	=> 0xE1,	# ISOlat1: LATIN SMALL LETTER A WITH ACUTE
    'acirc'	=> 0xE2,	# ISOlat1: LATIN SMALL LETTER A WITH CIRCUMFLEX
    'auml'	=> 0xE4,	# ISOlat1: LATIN SMALL LETTER A WITH DIAERESIS
    'cdot'	=> 0xE5,	# ISOlat2: LATIN SMALL LETTER C WITH DOT ABOVE
    'ccirce'	=> 0xE6,	# ISOlat2: LATIN SMALL LETTER C WITH
				#	   CIRCUMFLEX
    'ccedil'	=> 0xE7,	# ISOlat1: LATIN SMALL LETTER C WITH CEDILLA
    'egrave'	=> 0xE8,	# ISOlat1: LATIN SMALL LETTER E WITH GRAVE
    'eacute'	=> 0xE9,	# ISOlat2: LATIN SMALL LETTER E WITH ACUTE
    'ecirc'	=> 0xEA,	# ISOlat2: LATIN SMALL LETTER E WITH
				#	   CIRCUMFLEX
    'euml'	=> 0xEB,	# ISOlat1: LATIN SMALL LETTER E WITH DIAERESIS
    'igrave'	=> 0xEC,	# ISOlat1: LATIN SMALL LETTER I WITH GRAVE
    'iacute'	=> 0xED,	# ISOlat1: LATIN SMALL LETTER I WITH ACUTE
    'icirc'	=> 0xEE,	# ISOlat1: LATIN SMALL LETTER I WITH CIRCUMFLEX
    'iuml'	=> 0xEF,	# ISOlat1: LATIN SMALL LETTER I WITH DIAERESIS
    'ntilde'	=> 0xF1,	# ISOlat1: LATIN SMALL LETTER N WITH TILDE
    'ograve'	=> 0xF2,	# ISOlat1: LATIN SMALL LETTER O WITH GRAVE
    'oacute'	=> 0xF3,	# ISOlat1: LATIN SMALL LETTER O WITH ACUTE
    'ocirc'	=> 0xF4,	# ISOlat1: LATIN SMALL LETTER O WITH CIRCUMFLEX
    'gdot'	=> 0xF5,	# ISOlat2: LATIN SMALL LETTER G WITH DOT ABOVE
    'ouml'	=> 0xF6,	# ISOlat1: LATIN SMALL LETTER O WITH DIAERESIS
    'divide'	=> 0xF7,	# ISOnum : DIVISION SIGN
    'gcirc'	=> 0xF8,	# ISOlat2: LATIN SMALL LETTER G WITH
				#	   CIRCUMFLEX
    'ugrave'	=> 0xF9,	# ISOlat1: LATIN SMALL LETTER U WITH GRAVE
    'uacute'	=> 0xFA,	# ISOlat1: LATIN SMALL LETTER U WITH ACUTE
    'ucirc'	=> 0xFB,	# ISOlat1: LATIN SMALL LETTER U WITH
				#	   CIRCUMFLEX
    'uuml'	=> 0xFC,	# ISOlat1: LATIN SMALL LETTER U WITH DIAERESIS
    'ubreve'	=> 0xFD,	# ISOlat2: LATIN SMALL LETTER U WITH BREVE
    'scirc'	=> 0xFE,	# ISOlat2: LATIN SMALL LETTER S WITH
				#	   CIRCUMFLEX
    'dot'	=> 0xFF,	# ISOdia : DOT ABOVE
};
