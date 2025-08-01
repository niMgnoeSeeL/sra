## Process this file with automake to produce Makefile.in
bin_PROGRAMS = gif2png
bin_SCRIPTS = web2png
gif2png_SOURCES = 437_l1.c gif2png.c gifread.c memory.c version.c gif2png.h
man_MANS = gif2png.1 web2png.1
# automake is buggy, it ought to include bin_SCRIPTS in the distribution
EXTRA_DIST = Makefile Makefile.bcc Makefile.djgpp gif2png.xml web2png.xml gif2png.1 $(man_MANS) $(bin_SCRIPTS) ChangeLog
CLEANFILES = gif2png.1 web2png.1

gif2png.1: gif2png.xml
	xmlto man gif2png.xml

gif2png.html: gif2png.xml
	xmlto html-nochunks gif2png.xml

web2png.1: web2png.xml
	xmlto man web2png.xml

zip: $(DISTFILES)
	zip @PACKAGE@-@VERSION@.zip $(DISTFILES)

release: gif2png-$(VERSION).tar.gz gif2png.html
	shipper -u -m -t; rm -f *.1 *.html *.rpm MANIFEST SHIPPER.*
