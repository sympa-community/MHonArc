##---------------------------------------------------------------------------##
##  File:
##	@(#) mhexternal.pl 2.2 98/03/03 18:47:20
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##	Library defines a routine for MHonArc to filter content-types
##	that cannot be directly filtered into HTML, but a linked to an
##	external file.
##
##	Filter routine can be registered with the following:
##
##		<MIMEFILTERS>
##		*/*:m2h_external'filter:mhexternal.pl
##		</MIMEFILTERS>
##
##	Where '*/*' represents various content-types.  See code below for
##	all types supported.
##
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-1998	Earl Hood, ehood@medusa.acs.uci.edu
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

package m2h_external;

%ExtCnt = ();	# Array of filename counters for generated files
$UnknownExt	= 'bin';
$SubDir		= 0;

%CTExt = (
##-----------------------------------------------------------------------
##  Content-Type			Extension:Description
##-----------------------------------------------------------------------

    'application/astound',		'asd:Astound presentation',
    'application/envoy',		'evy:Envoy file',
    'application/fastman',		'lcc:fastman file',
    'application/fractals',		'fif:Fractal Image Format',
    'application/iges',			'iges:IGES file',
    'application/mac-binhex40', 	'hqx:Mac BinHex archive',
    'application/mathematica', 		'ma:Mathematica Notebook document',
    'application/mbedlet',		'mbd:mbedlet file',
    'application/msword',		'doc:MS-Word document',
    'application/octet-stream', 	'bin:Binary data',
    'application/oda', 			'oda:ODA file',
    'application/pdf', 			'pdf:Adobe PDF document',
    'application/pgp',  		'pgp:PGP message',
    'application/pgp-signature',	'pgp:PGP signature',
    'application/postscript', 		'ps,eps,ai:PostScript document',
    'application/rtf', 			'rtf:RTF file',
    'application/sgml',			'sgml:SGML document',
    'application/studiom',		'smp:Studio M file',
    'application/timbuktu',		'tbt:timbuktu file',
    'application/vnd.hp-hpgl',          'hpg,hpgl:HPGL file',
    'application/vnd.ms-excel',         'xls:MS-Excel spreadsheet',
    'application/vnd.ms-powerpoint',    'ppt:MS-Powerpoint presentation',
    'application/vnd.ms-project',	'mpp:MS-Project file',
    'application/vis5d',		'v5d:Vis5D dataset',
    'application/winhlp',		'hlp:WinHelp document',
    'application/wordperfect5.1',	'hlp:WordPerfect 5.1 document',
    'application/x-net-install',	'ins:Net Install file',
    'application/x-asap',		'asp:asap file',
    'application/x-bcpio', 		'bcpio:BCPIO file',
    'application/x-cpio', 		'cpio:CPIO file',
    'application/x-csh', 		'csh:C-Shell script',
    'application/x-compress', 		'Z:Unix compressed data',
    'application/x-dot',		'dot:dot file',
    'application/x-dvi', 		'dvi:TeX dvi file',
    'application/x-earthtime',		'etc:Earthtime file',
    'application/x-envoy',		'evy:Envoy file',
    'application/x-excel',		'xls:MS-Excel spreadsheet',
    'application/x-gtar', 		'gtar:GNU Unix tar archive',
    'application/x-gzip', 		'gz:GNU Zip compressed data',
    'application/x-hdf', 		'hdf:HDF file',
    'application/x-javascript',		'js:JavaScript source',
    'application/x-ksh',		'ksh:Korn Shell script',
    'application/x-latex', 		'latex:LaTeX document',
    'application/x-maker',		'fm:FrameMaker document',
    'application/x-mif', 		'mif:Frame MIF document',
    'application/x-mocha',		'moc:mocha file',
    'application/x-msaccess',		'mdb:MS-Access database',
    'application/x-mscardfile',		'crd:MS-CardFile',
    'application/x-msclip',		'clp:MS-Clip file',
    'application/x-msmediaview',	'm14:MS-Media View file',
    'application/x-msmetafile',		'wmf:MS-Metafile',
    'application/x-msmoney',		'mny:MS-Money file',
    'application/x-mspublisher',	'pub:MS-Publisher document',
    'application/x-msschedule',		'scd:MS-Schedule file',
    'application/x-msterminal',		'trm:MS-Terminal',
    'application/x-mswrite',		'wri:MS-Write document',
    'application/x-netcdf', 		'cdf:Cdf file',
    'application/x-ns-proxy-autoconfig','proxy:Netscape Proxy Auto Config',
    'application/x-patch',		'patch:Source code patch',
    'application/x-perl',		'pl:Perl program',
    'application/x-pointplus',		'css:pointplus file',
    'application/x-salsa',		'slc:salsa file',
    'application/x-script',		'script:A script file',
    'application/x-sh', 		'sh:Bourne shell script',
    'application/x-shar', 		'shar:Unix shell archive',
    'application/x-sprite',		'spr:sprite file',
    'application/x-stuffit',		'sit:Macintosh archive',
    'application/x-sv4cpio', 		'sv4cpio:SV4Cpio file',
    'application/x-sv4crc', 		'sv4crc:SV4Crc file',
    'application/x-tar', 		'tar:Unix tar archive',
    'application/x-tcl', 		'tcl:Tcl script',
    'application/x-tex', 		'tex:TeX document',
    'application/x-texinfo', 		'texinfo:TeXInfo document',
    'application/x-timbuktu',		'tbp:timbuktu file',
    'application/x-tkined',		'tki:tkined file',
    'application/x-troff', 		'roff:Troff document',
    'application/x-troff-man', 		'man:Unix manual page',
    'application/x-troff-me', 		'me:Troff ME-macros document',
    'application/x-troff-ms', 		'ms:Troff MS-macros document',
    'application/x-ustar', 		'ustar:UStar file',
    'application/x-wais-source', 	'src:WAIS Source',
    'application/x-zip-compressed',	'zip:Zip compressed data',
    'application/zip', 			'zip:Zip archive',

    'audio/basic', 			'snd:Basic audio',
    'audio/echospeech',			'es:Echospeech audio',
    'audio/midi',			'midi:MIDI audio',
    'audio/x-aiff', 			'aif,aiff,aifc:AIF audio',
    'audio/x-epac',			'pae:epac audio',
    'audio/x-midi',			'midi:MIDI audio',
    'audio/x-mpeg',			'mp2:MPEG audio',
    'audio/x-pac',			'pac:pac audio',
    'audio/x-pn-realaudio',		'ra,ram:PN Realaudio',
    'audio/x-wav', 			'wav:Wave audio',

    'chemical/chem3d',			'c3d:Chem3d chemical test',
    'chemical/chemdraw',		'chm:Chemdraw chemical test',
    'chemical/cif',			'cif:CIF chemical test',
    'chemical/cml',			'cml:CML chemical test',
    'chemical/cxf',			'cxf:Chemical Exhange Format file',
    'chemical/daylight-smiles',		'smi:SMILES format file',
    'chemical/embl-dl-nucleotide',	'emb,embl:EMBL nucleotide format file',
    'chemical/gaussian-input',		'gau:Gaussian chemical test',
    'chemical/gcg8-sequence',		'gcg:GCG format file',
    'chemical/genbank',			'gen:GENbank data',
    'chemical/jcamp-dx',		'jdx:Jcamp chemical spectra test',
    'chemical/kinemage',		'kin:Kinemage chemical test',
    'chemical/macromodel-input',	'mmd,mmod:Macromodel chemical test',
    'chemical/mopac-input',		'gau:Mopac chemical test',
    'chemical/mdl-molfile',		'mol:MOL mdl chemical test',
    'chemical/mdl-rdf',			'rdf:RDF chemical test',
    'chemical/mdl-rxn',			'rxn:RXN chemical test',
    'chemical/mdl-sdf',			'sdf:SDF chemical test',
    'chemical/mdl-tgf',			'tgf:TGF chemical test',
    'chemical/mif',			'mif:MIF chemical test',
    'chemical/mopac-input',		'mop:MOPAC data ',
    'chemical/ncbi-asn1',		'asn:NCBI data',
    'chemical/pdb',			'pdb:PDB chemical test',
    'chemical/rosdal',			'ros:Rosdal data',

    'image/bmp',			'bmp:Windows bitmap',
    'image/cgm',			'cgm:Computer Graphics Metafile',
    'image/fif',			'fif:Fractal Image Format image',
    'image/g3fax',			'g3f:Group III FAX image',
    'image/gif',			'gif:GIF image',
    'image/ief',			'ief:IEF image',
    'image/ifs',			'ifs:IFS image',
    'image/jpeg',			'jpg,jpeg,jpe:JPEG image',
    'image/png',			'png:PNG image',
    'image/tiff',			'tif,tiff:TIFF image',
    'image/vnd',			'dwg:VND image',
    'image/wavelet',			'wi:Wavelet image',
    'image/x-cmu-raster',		'ras:CMU raster',
    'image/x-pbm',			'pbm:Portable bitmap',
    'image/x-pcx',			'pcx:PCX image',
    'image/x-pgm',			'pgm:Portable graymap',
    'image/x-pict',			'pict:Mac PICT image',
    'image/x-pnm',			'pnm:Portable anymap',
    'image/x-portable-anymap',		'pnm:Portable anymap',
    'image/x-portable-bitmap',		'pbm:Portable bitmap',
    'image/x-portable-graymap',		'pgm:Portable graymap',
    'image/x-portable-pixmap',		'ppm:Portable pixmap',
    'image/x-ppm',			'ppm:Portable pixmap',
    'image/x-rgb',			'rgb:RGB image',
    'image/x-xbitmap',			'xbm:X bitmap',
    'image/x-xbm',			'xbm:X bitmap',
    'image/x-xpixmap',			'xpm:X pixmap',
    'image/x-xpm',			'xpm:X pixmap',
    'image/x-xwd',			'xwd:X window dump',
    'image/x-xwindowdump',		'xwd:X window dump',

    'model/iges',			'iges:IGES model',
    'model/vrml',			'wrl:VRML model',
    'model/mesh',			'mesh:Mesh model',

    'text/enriched',			'rtx:Text-enriched document',
    'text/html',			'html:HTML document',
    'text/plain',			'txt:Text document',
    'text/richtext',			'rtx:Richtext document',
    'text/setext',			'stx:Setext document',
    'text/sgml',			'sgml:SGML document',
    'text/tab-separated-values',	'tsv:Tab separated values',
    'text/x-speech',			'talk:Speech document',

    'video/isivideo',			'fvi:isi video',
    'video/mpeg',			'mpg,mpeg,mpe:MPEG movie',
    'video/msvideo',			'avi:MS Video',
    'video/quicktime',			'mov,qt:QuickTime movie',
    'video/vivo',			'viv:vivo video',
    'video/wavelet',			'wv:Wavelet video',
    'video/x-sgi-movie',		'movie:SGI movie',

);

##---------------------------------------------------------------------------
##	Filter routine.
##
##	Argument string may contain the following values.  Each value
##	should be separated by a space:
##
##	ext=ext 	Use `ext' as the filename extension.
##
##	iconurl="url"	Use "url" for location of icon to use.
##
##	inline  	Inline image data by default if
##			content-disposition not defined.
##
##	subdir		Place derived files in a subdirectory
##
##      target=name     Set TARGET attribute for anchor link to file.
##			Defaults to not defined.
##
##	type="description"
##			Use "description" as type description of the
##			data.  The double quotes are required.
##
##	useicon		Include an icon as part of the link to the
##			extracted file.  Url for icon is obtained
##			ICONS resource or from the iconurl option.
##
##	usename 	Use (file)name attribute for determining name
##			of derived file.  Use this option with caution
##			since it can lead to filename conflicts and
##			security problems.
##
sub filter {
    local($header, *fields, *data, $isdecode, $args) = @_;
    local($ret,
	  $filename, $urlfile,
	  $name, $nameparm,
	  $path,
	  $disp,
	  $ctype, $type, $ext,
	  $iconurl, $icon_mu,
	  $inline,
	  $target,
	  $inext, $intype);
    local($debug) = 0;

    ## Init variables
    $name	= '';
    $ctype	= '';
    $type	= '';
    $ext	= '';
    $inline	=  0;
    $inext	= '';
    $intype	= '';
    $iconurl	= '';
    $icon_mu	= '';
    $target	= '';

    if ($args =~ /debug/i) {
	$debug = 1;
    }

    ## Get content-type
    ($ctype) = $fields{'content-type'} =~ m%^\s*([\w\-\./]+)%;
    $ctype =~ tr/A-Z/a-z/;

    ## Get disposition
    ($disp, $nameparm) = &readmail'MAILhead_get_disposition(*fields);

    if ($debug) {
	&debug("Content-type: $ctype",
	       "Disposition: $disp; filename=$nameparm",
	       "Arg-string: $args");
    }

    ## Check if using name
    if ($args =~ /usename/i) {
	$name = $nameparm;
    } else {
	$name = '';
    }

    ## Chech if file goes in a subdirectory
    if ($args =~ /subdir/i) {
	$path = join('', $mhonarc'MsgPrefix, $mhonarc'MHAmsgnum, '.dir');
    } else {
	$path = '';
    }

    ## Check if inlining (images only)
    if ($disp) {
	$inline = ($disp =~ /inline/i);
    } else {
	$inline = ($args =~ /inline/i);
    }

    ## Check if extension and type description passed in
    if ($args =~ /ext=(\S+)/i)      { $inext  = $1;  $inext =~ s/['"]//g; }
    if ($args =~ /type="([^"]+)"/i) { $intype = $1; }

    ## Check if using icon
    if ($args =~ /useicon/i) {
	$iconurl = $mhonarc'Icons{$ctype} || $mhonarc'Icons{'unknown'};
	if ($args =~ /iconurl="([^"]+)"/i) { $iconurl = $1; }
	$icon_mu = qq{<IMG SRC="$iconurl" BORDER=0 ALT="">}
	    if $iconurl;
    }

    ## Determine default filename extension
    if ($inext) {
	$ext = $inext;
    } else {
	if (defined($CTExt{$ctype})) {
	    ($ext, $type) = split(/:/, $CTExt{$ctype}, 2);
	} else {
	    local($ctype2) = $ctype;
	    $ctype2 =~ s%/x-%/%i;
	    ($ext, $type) = split(/:/, $CTExt{$ctype2}, 2);
	}
	$ext = (split(/,/, $ext))[0];
    }
    $type = $intype  if $intype;
    if (!$ext) {
	$ext = $UnknownExt;
	$type = $ctype;
    }
    $pre = $ext;
    substr($pre, 3) = "" if length($pre) > 3;	# Prune prefix to 3 chars

    ## Check if target specified
    if ($args =~ /target="([^"]+)"/i) { $target = $1; }
        elsif ($args =~ /target=(\S+)/i) { $target = $1; }
    $target =~ s/['"]//g;
    $target = qq/ TARGET="$target"/  if $target;

    ## Write file
    $filename = &write_file(*data, $path, $name, $pre, $ext);
    ($urlfile = $filename) =~ s/([^\w.\-\/])/sprintf("%%%X",unpack("C",$1))/ge;
    if ($debug) {
	&debug("File-written: $filename");
    }

    ## Create HTML markup
    if ($inline && ($ctype =~ /image/i)) {
	$ret  = "<P>" . &htmlize($fields{'content-description'}) . "</P>\n"
	    if ($fields{'content-description'});
	$ret .= qq{<P><A HREF="$urlfile" $target><IMG SRC="$urlfile" } .
		qq{ALT="$type"></A></P>\n};

    } else {
	$ret  = qq{<P><A HREF="$urlfile" $target>$icon_mu } .
		(&htmlize($fields{'content-description'}) ||
		 $nameparm || $type) .
		qq{</A></P>\n};
    }
    ($ret, $path || $filename);
}

sub write_file {
    local(*stuff, $path, $fname, $pre, $ext) = @_;
    local($tmp, $cnt) = ('', '');

    $tmp  = $mhonarc'OUTDIR;
    if ($path) {
	$tmp .= $mhonarc'DIRSEP . $path;
	mkdir($tmp, 0777);
    }

    if (!$fname) {
	if (!$ExtCnt{$ext}) { &set_cnt($tmp); }
	$cnt = $ExtCnt{$ext}++;
	$fname = $pre . sprintf("%05d.",$cnt) . $ext;
	$ExtCnt{$ext} = 0  if $path;
    }
    $tmp .= $mhonarc'DIRSEP . $fname;

    if (open(OUTFILE, "> $tmp")) {
	binmode(OUTFILE);		# For MS-DOS
	print OUTFILE $stuff;
	close(OUTFILE);
    } else {
	warn "Warning: Unable to create $tmp\n";
    }

    join("",
	 ($mhonarc'SINGLE ? $mhonarc'OUTDIR.$mhonarc'DIRSEP : ""),
	 ($path ? join($mhonarc'DIRSEP,$path,$fname) : $fname));
}

sub set_cnt {
    local(@files) = ();
    if (opendir(DIR, $_[0])) {
	@files = sort numerically grep(/^$pre\d+\.$ext$/i, readdir(DIR));
	close(DIR);
	if (@files) {
	    ($ExtCnt{$ext}) = $files[$#files] =~ /(\d+)/;
	    $ExtCnt{$ext}++;
	} else {
	    $ExtCnt{$ext} = 0;
	}
    } else {
	$ExtCnt{$ext} = 0;
    }
}

sub numerically {
    ($A) = $a =~ /(\d+)/;
    ($B) = $b =~ /(\d+)/;
    $A <=> $B;
}

sub htmlize {
    local($txt) = shift;
    $txt =~ s/&/\&amp;/g;
    $txt =~ s/>/&gt;/g;
    $txt =~ s/</&lt;/g;
    $txt;
}

sub dump_ctext_hash {
    foreach (sort keys %CTExt) {
	print STDERR $_,":",$CTExt{$_},"\n";
    }
}

sub debug {
    foreach (@_) {
	print STDERR "m2h_external: ", $_;
	print STDERR "\n"  unless /\n$/;
    }
}

##---------------------------------------------------------------------------
1;
