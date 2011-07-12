NULL =

AUTOMAKE_OPTIONS = subdir-objects

AM_CPPFLAGS = \
  $(GLIB_CFLAGS) \
  $(NULL)

BUILT_SOURCES = libpandora_glib_la_vala.stamp

lib_LTLIBRARIES = \
  libpandora-glib.la
  $(NULL)

libpandora_glib_la_VALASOURCES = \
	Pandora.vala \
	$(NULL)

libpandora_glib_la_SOURCES = \
  libpandora_glib_la_vala.stamp \
  $(libpandora_glib_la_VALASOURCES:.vala=.c) \
  $(NULL)

libpandora_glib_la_vala.stamp: $(libpandora_glib_la_VALASOURCES)
	$(VALA_V)$(VALAC) $(VALAFLAGS) -C --vapidir $(srcdir)/../vapi --pkg gobject-2.0 --pkg pnd --pkg config -H pandora-glib.h --library pandora-glib $^
	@touch $@
 
libpandora_glib_la_LIBADD = \
  $(YAML_LIBS) \
  $(GLIB_LIBS) \
  $(NULL)

pandoraglibincludedir = $(includedir)/pandora-glib

pandoraglibinclude_HEADERS = \
  pandora-glib.h \
  $(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
  pandora-glib.vapi \
  $(NULL)

EXTRA_DIST = $(libpandora_glib_la_VALASOURCES) pandora-glib.vapi libpandora_glib_la_vala.stamp

MAINTAINERCLEANFILES = \
  pandora-glib.vapi \
  pandora-glib.h \
  $(libpandora_glib_la_VALASOURCES:.vala=.c) \
  $(NULL)

