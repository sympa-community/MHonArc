##---------------------------------------------------------------------------##
##  File:
##      $Id: ISO8859_7R.pm,v 1.1 2001/08/19 09:53:56 ehood Exp $
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

package MHonArc::CharEnt::ISO8859_7R;

##---------------------------------------------------------------------------
##      ISO-8859-7
##---------------------------------------------------------------------------

+{
  #--------------------------------------------------------------------------
  #  Entity	   Hex Code	# ISO external entity and description
  #--------------------------------------------------------------------------
    'lsquo'	=> 0xA1,	# ISOnum : SINGLE HIGH-REVERSED-9 QUOTATION
				#	   MARK
    'rsquo'	=> 0xA2,	# ISOnum : RIGHT SINGLE QUOTATION MARK
    'pound'	=> 0xA3,	# ISOnum : POUND SIGN
    'brvbar'	=> 0xA6,	# ISOnum : BROKEN BAR
    'sect'	=> 0xA7,	# ISOnum : SECTION SIGN
    'die'	=> 0xA8,	# ISOdia : DIAERESIS
    'copy'	=> 0xA9,	# ISOnum : COPYRIGHT SIGN
    'laquo'	=> 0xAB,	# ISOnum : LEFT-POINTING DOUBLE ANGLE
				#	   QUOTATION MARK
    'not'	=> 0xAC,	# ISOnum : NOT SIGN
    'shy'	=> 0xAD,	# ISOnum : SOFT HYPHEN
    'mdash'	=> 0xAF,	# ISOpub : EM DASH
    'deg'	=> 0xB0,	# ISOnum : DEGREE SIGN
    'plusmn'	=> 0xB1,	# ISOnum : PLUS-MINUS SIGN
    'sup2'	=> 0xB2,	# ISOnum : SUPERSCRIPT TWO
    'sup3'	=> 0xB3,	# ISOnum : SUPERSCRIPT THREE
    'acute'	=> 0xB4,	# ISOdia : ACUTE ACCENT
    'diagr'	=> 0xB5,	# ISOgrk?: ACUTE ACCENT AND DIAERESIS
				#	   (Tonos and Dialytika)
    'Aacgr'	=> 0xB6,	# ISOgrk2: GREEK CAPITAL LETTER ALPHA WITH
				#	   ACUTE
    'middot'	=> 0xB7,	# ISOnum : MIDDLE DOT
    'Eacgr'	=> 0xB8,	# ISOgrk2: GREEK CAPITAL LETTER EPSILON WITH
				#	   ACUTE
    'EEacgr'	=> 0xB9,	# ISOgrk2: GREEK CAPITAL LETTER ETA WITH ACUTE
    'Iacgr'	=> 0xBA,	# ISOgrk2: GREEK CAPITAL LETTER IOTA WITH ACUTE
    'raquo'	=> 0xBB,	# ISOnum : RIGHT-POINTING DOUBLE ANGLE
				#	   QUOTATION MARK
    'Oacgr'	=> 0xBC,	# ISOgrk2: GREEK CAPITAL LETTER OMICRON WITH
				#	   ACUTE
    'frac12'	=> 0xBD,	# ISOnum : VULGAR FRACTION ONE HALF
    'half'	=> 0xBD,	# ISOnum : VULGAR FRACTION ONE HALF
    'Uacgr'	=> 0xBE,	# ISOgrk2: GREEK CAPITAL LETTER UPSILON WITH
				#	   ACUTE
    'OHacgr'	=> 0xBF,	# ISOgrk2: GREEK CAPITAL LETTER OMEGA WITH
				#	   ACUTE
    'idiagr'	=> 0xC0,	# ISOgrk2: GREEK SMALL LETTER IOTA WITH ACUTE
				#	   AND DIAERESIS
    'Agr'	=> 0xC1,	# ISOgrk1: GREEK CAPITAL LETTER ALPHA
    'Bgr'	=> 0xC2,	# ISOgrk1: GREEK CAPITAL LETTER BETA
    'Ggr'	=> 0xC3,	# ISOgrk1: GREEK CAPITAL LETTER GAMMA
    'Dgr'	=> 0xC4,	# ISOgrk1: GREEK CAPITAL LETTER DELTA
    'Egr'	=> 0xC5,	# ISOgrk1: GREEK CAPITAL LETTER EPSILON
    'Zgr'	=> 0xC6,	# ISOgrk1: GREEK CAPITAL LETTER ZETA
    'EEgr'	=> 0xC7,	# ISOgrk1: GREEK CAPITAL LETTER ETA
    'THgr'	=> 0xC8,	# ISOgrk1: GREEK CAPITAL LETTER THETA
    'Igr'	=> 0xC9,	# ISOgrk1: GREEK CAPITAL LETTER IOTA
    'Kgr'	=> 0xCA,	# ISOgrk1: GREEK CAPITAL LETTER KAPPA
    'Lgr'	=> 0xCB,	# ISOgrk1: GREEK CAPITAL LETTER LAMDA
    'Mgr'	=> 0xCC,	# ISOgrk1: GREEK CAPITAL LETTER MU
    'Ngr'	=> 0xCD,	# ISOgrk1: GREEK CAPITAL LETTER NU
    'Xgr'	=> 0xCE,	# ISOgrk1: GREEK CAPITAL LETTER XI
    'Ogr'	=> 0xCF,	# ISOgrk1: GREEK CAPITAL LETTER OMICRON
    'Pgr'	=> 0xD0,	# ISOgrk1: GREEK CAPITAL LETTER PI
    'Rgr'	=> 0xD1,	# ISOgrk1: GREEK CAPITAL LETTER RHO
    'Sgr'	=> 0xD3,	# ISOgrk1: GREEK CAPITAL LETTER SIGMA
    'Tgr'	=> 0xD4,	# ISOgrk1: GREEK CAPITAL LETTER TAU
    'Ugr'	=> 0xD5,	# ISOgrk1: GREEK CAPITAL LETTER UPSILON
    'PHgr'	=> 0xD6,	# ISOgrk1: GREEK CAPITAL LETTER PHI
    'KHgr'	=> 0xD7,	# ISOgrk1: GREEK CAPITAL LETTER CHI
    'PSgr'	=> 0xD8,	# ISOgrk1: GREEK CAPITAL LETTER PSI
    'OHgr'	=> 0xD9,	# ISOgrk1: GREEK CAPITAL LETTER OMEGA
    'Idigr'	=> 0xDA,	# ISOgrk2: GREEK CAPITAL LETTER IOTA WITH
				#	   DIAERESIS
    'Udigr'	=> 0xDB,	# ISOgrk2: GREEK CAPITAL LETTER UPSILON WITH
				#	   DIAERESIS
    'aacgr'	=> 0xDC,	# ISOgrk2: GREEK SMALL LETTER ALPHA WITH ACUTE
    'eacgr'	=> 0xDD,	# ISOgrk2: GREEK SMALL LETTER EPSILON WITH
				#	   ACUTE
    'eeacgr'	=> 0xDE,	# ISOgrk2: GREEK SMALL LETTER ETA WITH ACUTE
    'iacgr'	=> 0xDF,	# ISOgrk2: GREEK SMALL LETTER IOTA WITH ACUTE
    'udiagr'	=> 0xE0,	# ISOgrk2: GREEK SMALL LETTER UPSILON WITH
				#	   ACUTE AND DIAERESIS
    'agr'	=> 0xE1,	# ISOgrk1: GREEK SMALL LETTER ALPHA
    'bgr'	=> 0xE2,	# ISOgrk1: GREEK SMALL LETTER BETA
    'ggr'	=> 0xE3,	# ISOgrk1: GREEK SMALL LETTER GAMMA
    'dgr'	=> 0xE4,	# ISOgrk1: GREEK SMALL LETTER DELTA
    'egr'	=> 0xE5,	# ISOgrk1: GREEK SMALL LETTER EPSILON
    'zgr'	=> 0xE6,	# ISOgrk1: GREEK SMALL LETTER ZETA
    'eegr'	=> 0xE7,	# ISOgrk1: GREEK SMALL LETTER ETA
    'thgr'	=> 0xE8,	# ISOgrk1: GREEK SMALL LETTER THETA
    'igr'	=> 0xE9,	# ISOgrk1: GREEK SMALL LETTER IOTA
    'kgr'	=> 0xEA,	# ISOgrk1: GREEK SMALL LETTER KAPPA
    'lgr'	=> 0xEB,	# ISOgrk1: GREEK SMALL LETTER LAMDA
    'mgr'	=> 0xEC,	# ISOgrk1: GREEK SMALL LETTER MU
    'ngr'	=> 0xED,	# ISOgrk1: GREEK SMALL LETTER NU
    'xgr'	=> 0xEE,	# ISOgrk1: GREEK SMALL LETTER XI
    'ogr'	=> 0xEF,	# ISOgrk1: GREEK SMALL LETTER OMICRON
    'pgr'	=> 0xF0,	# ISOgrk1: GREEK SMALL LETTER PI
    'rgr'	=> 0xF1,	# ISOgrk1: GREEK SMALL LETTER RHO
    'sfgr'	=> 0xF2,	# ISOgrk1: GREEK SMALL LETTER FINAL SIGMA
    'sgr'	=> 0xF3,	# ISOgrk1: GREEK SMALL LETTER SIGMA
    'tgr'	=> 0xF4,	# ISOgrk1: GREEK SMALL LETTER TAU
    'ugr'	=> 0xF5,	# ISOgrk1: GREEK SMALL LETTER UPSILON
    'phgr'	=> 0xF6,	# ISOgrk1: GREEK SMALL LETTER PHI
    'khgr'	=> 0xF7,	# ISOgrk1: GREEK SMALL LETTER CHI
    'psgr'	=> 0xF8,	# ISOgrk1: GREEK SMALL LETTER PSI
    'ohgr'	=> 0xF9,	# ISOgrk1: GREEK SMALL LETTER OMEGA
    'idigr'	=> 0xFA,	# ISOgrk2: GREEK SMALL LETTER IOTA WITH
				#	   DIAERESIS
    'udigr'	=> 0xFB,	# ISOgrk2: GREEK SMALL LETTER UPSILON WITH
				#	   DIAERESIS
    'oacgr'	=> 0xFC,	# ISOgrk2: GREEK SMALL LETTER OMICRON WITH
				#	   ACUTE
    'uacgr'	=> 0xFD,	# ISOgrk2: GREEK SMALL LETTER UPSILON WITH
				#	   ACUTE
    'ohacgr'	=> 0xFE,	# ISOgrk2: GREEK SMALL LETTER OMEGA WITH ACUTE
};
