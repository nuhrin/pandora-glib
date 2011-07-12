NULL =

AUTOMAKE_OPTIONS = subdir-objects

AM_CPPFLAGS = \
  $(GLIB_CFLAGS) \
#  $(GEE_CFLAGS) \
  $(NULL)

BUILT_SOURCES = libpandora-glib_la_vala.stamp

lib_LTLIBRARIES = \
  libpandora-glib.la
  $(NULL)

libpandora-glib_la_VALASOURCES = \
	Pandora.vala \
	$(NULL)

libpandora-glib_la_SOURCES = \
  libpandora-glib_la_vala.stamp \
  $(libpandora-glib_la_VALASOURCES:.vala=.c) \
  $(NULL)

libpandora-glib_la_vala.stamp: $(libpandora-glib_la_VALASOURCES)
	$(VALA_V)$(VALAC) $(VALAFLAGS) -C --vapidir $(srcdir)/../vapi --pkg gobject-2.0 --pkg gobject-patch --pkg pnd --pkg config -H pandora-glib.h --library pandora-glib $^
	@touch $@
 
libpandora-glib_la_LIBADD = \
  $(YAML_LIBS) \
  $(GLIB_LIBS) \
#  $(GEE_LIBS) \
  $(NULL)

pandora-glibincludedir = $(includedir)/pandora-glib

pandora-glibinclude_HEADERS = \
  pandora-glib.h \
  $(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
  pandora-glib.vapi \
  $(NULL)

EXTRA_DIST = $(libpandora-glib_la_VALASOURCES) pandora-glib.vapi libpandora-glib_la_vala.stamp

MAINTAINERCLEANFILES = \
  pandora-glib.vapi \
  pandora-glib.h \
  $(libpandora-glib_la_VALASOURCES:.vala=.c) \
  $(NULL)

