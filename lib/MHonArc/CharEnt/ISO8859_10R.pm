##---------------------------------------------------------------------------##
##  File:
##      $Id: ISO8859_10R.pm,v 1.1 2001/08/19 09:53:55 ehood Exp $
##  Author:
##      Earl Hood       earl@earlhood.com
##  Description:
##      Reverse mappings for ISO-8859-1.
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

package MHonArc::CharEnt::ISO8859_10R;

##---------------------------------------------------------------------------
##      ISO-8859-10
##---------------------------------------------------------------------------

+{
  #--------------------------------------------------------------------------
  #  Entity	   Hex Code	# ISO external entity and description
  #--------------------------------------------------------------------------
    'Aogon'	=> 0xA1,	# ISOlat1: LATIN CAPITAL LETTER A WITH OGONEK
    'Emacr'	=> 0xA2,	# ISOlat2: LATIN CAPITAL LETTER E WITH MACRON
    'Gcedil'	=> 0xA3,	# ISOlat2: LATIN CAPITAL LETTER G WITH CEDILLA
    'Imacr'	=> 0xA4,	# ISOlat2: LATIN CAPITAL LETTER I WITH MACRON
    'Itilde'	=> 0xA5,	# ISOlat2: LATIN CAPITAL LETTER I WITH TILDE
    'Kcedil'	=> 0xA6,	# ISOlat2: LATIN CAPITAL LETTER K WITH CEDILLA
    'Lcedil'	=> 0xA7,	# ISOlat2: LATIN CAPITAL LETTER L WITH CEDILLA
    'Nacute'	=> 0xA8,	# ISOlat2: LATIN CAPITAL LETTER N WITH ACUTE
    'Rcedil'	=> 0xA9,	# ISOlat2: LATIN CAPITAL LETTER R WITH CEDILLA
    'Scaron'	=> 0xAA,	# ISOlat2: LATIN CAPITAL LETTER S WITH CARON
    'Tstrok'	=> 0xAB,	# ISOlat2: LATIN CAPITAL LETTER T WITH STROKE
    'Zcaron'	=> 0xAC,	# ISOlat2: LATIN CAPITAL LETTER Z WITH CARON
    'shy'	=> 0xAD,	# ISOnum : SOFT HYPHEN
    'kgreen'	=> 0xAE,	# ISOlat2: LATIN SMALL LETTER KRA (Greenlandic)
    'end'	=> 0xAF,	# ISOlat?: LATIN SMALL LETTER END (Lappish)
    'dstrok'	=> 0xB0,	# ISOlat2: LATIN SMALL LETTER d WITH STROKE
    'aogon'	=> 0xB1,	# ISOlat2: LATIN SMALL LETTER a WITH OGONEK
    'emacr'	=> 0xB2,	# ISOlat2: LATIN SMALL LETTER e WITH MACRON
    'gcedil'	=> 0xB3,	# ISOlat2: LATIN SMALL LETTER g WITH CEDILLA
    'imacr'	=> 0xB4,	# ISOlat2: LATIN SMALL LETTER i WITH MACRON
    'itilde'	=> 0xB5,	# ISOlat2: LATIN SMALL LETTER i WITH TILDE
    'kcedil'	=> 0xB6,	# ISOlat2: LATIN SMALL LETTER k WITH CEDILLA
    'lcedil'	=> 0xB7,	# ISOlat2: LATIN SMALL LETTER l WITH CEDILLA
    'nacute'	=> 0xB8,	# ISOlat2: LATIN SMALL LETTER n WITH ACUTE
    'rcedil'	=> 0xB9,	# ISOlat2: LATIN SMALL LETTER r WITH CEDILLA
    'scaron'	=> 0xBA,	# ISOlat2: LATIN SMALL LETTER s WITH CARON
    'tstrok'	=> 0xBB,	# ISOlat2: LATIN SMALL LETTER t WITH STROKE
    'zcaron'	=> 0xBC,	# ISOlat2: LATIN SMALL LETTER z WITH CARON
    'sect'	=> 0xBD,	# ISOnum : SECTION SIGN
    'szlig'	=> 0xBE,	# ISOlat1: LATIN SMALL LETTER SHARP s (German)
    'eng'	=> 0xBF,	# ISOlat2: LATIN SMALL LETTER ENG (Lappish)
    'Amacr'	=> 0xC0,	# ISOlat2: LATIN CAPITAL LETTER A WITH MACRON
    'Aacute'	=> 0xC1,	# ISOlat1: LATIN CAPITAL LETTER A WITH ACUTE
    'Acirc'	=> 0xC2,	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   CIRCUMFLEX
    'Atilde'	=> 0xC3,	# ISOlat1: LATIN CAPITAL LETTER A WITH TILDE
    'Auml'	=> 0xC4,	# ISOlat1: LATIN CAPITAL LETTER A WITH
				#	   DIAERESIS
    'Aring'	=> 0xC5,	# ISOlat1: LATIN CAPITAL LETTER A WITH RING
				#	   ABOVE
    'AElig'	=> 0xC6,	# ISOlat1: LATIN CAPITAL LETTER AE
    'Iogon'	=> 0xC7,	# ISOlat2: LATIN CAPITAL LETTER I WITH OGONEK
    'Ccaron'	=> 0xC8,	# ISOlat2: LATIN CAPITAL LETTER C WITH CARON
    'Eacute'	=> 0xC9,	# ISOlat1: LATIN CAPITAL LETTER E WITH ACUTE
    'Eogon'	=> 0xCA,	# ISOlat2: LATIN CAPITAL LETTER E WITH OGONEK
    'Euml'	=> 0xCB,	# ISOlat1: LATIN CAPITAL LETTER E WITH
				#	   DIAERESIS
    'Edot'	=> 0xCC,	# ISOlat2: LATIN CAPITAL LETTER E WITH
				#	   DOT ABOVE
    'Iacute'	=> 0xCD,	# ISOlat1: LATIN CAPITAL LETTER I WITH ACUTE
    'Icirc'	=> 0xCE,	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   CIRCUMFLEX
    'Iuml'	=> 0xCF,	# ISOlat1: LATIN CAPITAL LETTER I WITH
				#	   DIAERESIS
    'Dstrok'	=> 0xD0,	# ISOlat2: LATIN CAPITAL LETTER D WITH STROKE
    'Ncedil'	=> 0xD1,	# ISOlat2: LATIN CAPITAL LETTER N WITH CEDILLA
    'Omacr'	=> 0xD2,	# ISOlat2: LATIN CAPITAL LETTER O WITH MACRON
    'Oacute'	=> 0xD3,	# ISOlat1: LATIN CAPITAL LETTER O WITH ACUTE
    'Ocirc'	=> 0xD4,	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   CIRCUMFLEX
    'Otilde'	=> 0xD5,	# ISOlat1: LATIN CAPITAL LETTER O WITH TILDE
    'Ouml'	=> 0xD6,	# ISOlat1: LATIN CAPITAL LETTER O WITH
				#	   DIAERESIS
    'Utilde'	=> 0xD7,	# ISOlat2: LATIN CAPITAL LETTER U WITH TILDE
    'Oslash'	=> 0xD8,	# ISOlat1: LATIN CAPITAL LETTER O WITH STROKE
    'Uogon'	=> 0xD9,	# ISOlat2: LATIN CAPITAL LETTER U WITH OGONEK
    'Uacute'	=> 0xDA,	# ISOlat1: LATIN CAPITAL LETTER U WITH ACUTE
    'Ucirc'	=> 0xDB,	# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   CIRCUMFLEX
    'Uuml'	=> 0xDC,	# ISOlat1: LATIN CAPITAL LETTER U WITH
				#	   DIAERESIS
    'Yacute'	=> 0xDD,	# ISOlat1: LATIN CAPITAL LETTER Y WITH ACUTE
    'THORN'	=> 0xDE,	# ISOlat1: LATIN CAPITAL LETTER THORN
				#	   (Icelandic)
    'Umacr'	=> 0xDF,	# ISOlat2: LATIN CAPITAL LETTER U WITH MACRON
    'amacr'	=> 0xE0,	# ISOlat2: LATIN SMALL LETTER a WITH MACRON
    'aacute'	=> 0xE1,	# ISOlat1: LATIN SMALL LETTER a WITH ACUTE
    'acirc'	=> 0xE2,	# ISOlat1: LATIN SMALL LETTER a WITH CIRCUMFLEX
    'atilde'	=> 0xE3,	# ISOlat1: LATIN SMALL LETTER a WITH TILDE
    'auml'	=> 0xE4,	# ISOlat1: LATIN SMALL LETTER a WITH DIAERESIS
    'aring'	=> 0xE5,	# ISOlat1: LATIN SMALL LETTER a WITH RING ABOVE
    'aelig'	=> 0xE6,	# ISOlat1: LATIN SMALL LETTER ae
    'iogon'	=> 0xE7,	# ISOlat2: LATIN SMALL LETTER i WITH OGONEK
    'ccaron'	=> 0xE8,	# ISOlat2: LATIN SMALL LETTER c WITH CARON
    'eacute'	=> 0xE9,	# ISOlat1: LATIN SMALL LETTER e WITH ACUTE
    'eogon'	=> 0xEA,	# ISOlat2: LATIN SMALL LETTER e WITH OGONEK
    'euml'	=> 0xEB,	# ISOlat1: LATIN SMALL LETTER e WITH DIAERESIS
    'edot'	=> 0xEC,	# ISOlat2: LATIN SMALL LETTER e WITH DOT ABOVE
    'iacute'	=> 0xED,	# ISOlat1: LATIN SMALL LETTER i WITH ACUTE
    'icirc'	=> 0xEE,	# ISOlat1: LATIN SMALL LETTER i WITH CIRCUMFLEX
    'iuml'	=> 0xEF,	# ISOlat1: LATIN SMALL LETTER i WITH DIAERESIS
    'eth'	=> 0xF0,	# ISOlat1: LATIN SMALL LETTER ETH (Icelandic)
    'ncedil'	=> 0xF1,	# ISOlat2: LATIN SMALL LETTER n WITH CEDILLA
    'omacr'	=> 0xF2,	# ISOlat2: LATIN SMALL LETTER o WITH MACRON
    'oacute'	=> 0xF3,	# ISOlat1: LATIN SMALL LETTER o WITH ACUTE
    'ocirc'	=> 0xF4,	# ISOlat1: LATIN SMALL LETTER o WITH CIRCUMFLEX
    'otilde'	=> 0xF5,	# ISOlat1: LATIN SMALL LETTER o WITH TILDE
    'ouml'	=> 0xF6,	# ISOlat1: LATIN SMALL LETTER o WITH DIAERESIS
    'utilde'	=> 0xF7,	# ISOlat2: LATIN SMALL LETTER u WITH TILDE
    'oslash'	=> 0xF8,	# ISOlat1: LATIN SMALL LETTER o WITH STROKE
    'uogon'	=> 0xF9,	# ISOlat2: LATIN SMALL LETTER u WITH OGONEK
    'uacute'	=> 0xFA,	# ISOlat1: LATIN SMALL LETTER u WITH ACUTE
    'ucirc'	=> 0xFB,	# ISOlat1: LATIN SMALL LETTER u WITH CIRCUMFLEX
    'uuml'	=> 0xFC,	# ISOlat1: LATIN SMALL LETTER u WITH DIAERESIS
    'yacute'	=> 0xFD,	# ISOlat1: LATIN SMALL LETTER y WITH ACUTE
    'thorn'	=> 0xFE,	# ISOlat1: LATIN SMALL LETTER THORN (Icelandic)
    'umacr'	=> 0xFF,	# ISOlat2: LATIN SMALL LETTER u WITH MACRON
};
