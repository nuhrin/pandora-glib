NULL =

SRC_FILES = \
	$(top_srcdir)/src/*.vala \
	$(top_srcdir)/src/Apps/*.vala \
	$(top_srcdir)/src/Config/*.vala \
	$(NULL)

bookdir=$(datadir)/devhelp/books/pandora-glib
imgdir=$(datadir)/devhelp/books/pandora-glib/img

book_data = \
	pandora-glib/pandora-glib.devhelp2 \
	pandora-glib/*.css \
	pandora-glib/*.js \
	pandora-glib/*.html \
	pandora-glib/*.png \
	$(NULL)

book_DATA = \
	pandora-glib/index.htm \
	$(book_data) \
	$(NULL)

img_DATA = \
	pandora-glib/img/*.png \
	$(NULL)

$(book_data) $(img_DATA): pandora-glib/index.htm

if ENABLE_DEVHELP
devhelp_dist = \
	$(book_DATA) \
	$(img_DATA) \
	$(NULL)
endif

pandora-glib/index.htm:
	$(VALADOC) $(VALADOC_OPTIONS) --doclet=devhelp --driver=0.18.x --vapidir=$(top_srcdir)/vapi --pkg gee-0.8 --pkg pnd -o pandora-glib/ --force -b $(top_srcdir) $(SRC_FILES)
	mv pandora-glib tmp
	mv tmp/pandora-glib .
	rmdir tmp

EXTRA_DIST = $(devhelp_dist)

clean-local:         
	-rm -rf pandora-glib
