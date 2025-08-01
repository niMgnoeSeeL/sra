#!/bin/sh

version=`sed -n -e "/AM_INIT_AUTOMAKE(gif2png, \(.*\))/s//\\1/p" <configure.in`

cat >gif2png.spec <<EOF
Name: gif2png
Version: $version
Release: 1
Summary: tools for converting websites from using GIFs to using PNGs
Source: locke.ccil.org:/pub/esr/gif2png/gif2png-${version}.tar.gz
Copyright: MIT-like
Group: Graphics
%undefine __check_files

%%description 
Tools for converting GIFs to PNGs.  The program gif2png converts GIF files 
to PNG files.  The Python script web2png converts an entire web tree, 
also patching HTML pages to keep IMG SRC references correct.

%prep

%setup

%build
CFLAGS="$RPM_OPT_FLAGS" LDFLAGS="-s" # Add  --enable-nls --without-included-gettext for internationalization
export CFLAGS LDFLAGS
./configure -prefix=/usr
make

%install
rm -f /usr/bin/gif2png
cp gif2png web2png /usr/bin
cp gif2png.1 /usr/man/man1/gif2png.1
cp web2png.1 /usr/man/man1/web2png.1

%files
%doc README NEWS COPYING
/usr/man/man1/gif2png.1
/usr/man/man1/web2png.1
/usr/bin/gif2png
/usr/bin/web2png
EOF
