NULL =

AUTOMAKE_OPTIONS = subdir-objects

AM_CPPFLAGS = \
  $(GLIB_CFLAGS) \
  $(GEE_CFLAGS) \
  $(NULL)

BUILT_SOURCES = libpandora_glib_la_vala.stamp

lib_LTLIBRARIES = \
  libpandora-glib.la
  $(NULL)

libpandora_glib_la_VALASOURCES = \
	Apps.vala \
	Config.vala \
	Apps/App.vala \
	Apps/DataCache.vala \
	Apps/enums.vala \
	Apps/Pnd.vala \
	Config/ConfigFile.vala \
	Config/AppsConfigFile.vala \
	Config/DesktopConfigFile.vala \
	$(NULL)

libpandora_glib_la_SOURCES = \
  libpandora_glib_la_vala.stamp \
  $(libpandora_glib_la_VALASOURCES:.vala=.c) \
  $(NULL)

libpandora_glib_la_vala.stamp: $(libpandora_glib_la_VALASOURCES)
	$(VALA_V)$(VALAC) $(VALAFLAGS) -C --vapidir $(srcdir)/../vapi --pkg gobject-2.0 --pkg gee-1.0 --pkg pnd --pkg config -H pandora-glib.h --library pandora-glib $^
	@touch $@

libpandora_glib_la_LIBADD = \
  $(GLIB_LIBS) \
  $(GEE_LIBS) \
	-lstdc++ \
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

