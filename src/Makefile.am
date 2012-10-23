NULL =

AUTOMAKE_OPTIONS = subdir-objects

lib_LTLIBRARIES = \
  libpandora-glib.la
  $(NULL)

libpandora_glib_la_SOURCES = \
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

libpandora_glib_la_VALAFLAGS = \
	-H pandora-glib.h --vapi pandora-glib.vapi --vapidir $(srcdir)/../vapi \
	--pkg gobject-2.0 --pkg gee-0.8 --pkg pnd --pkg config \
	--library pandora-glib \
    $(GEE_VALAFLAGS) \
    $(VALAFLAGS) \
	$(NULL)
 
libpandora_glib_la_CPPFLAGS = \
	$(GLIB_CFLAGS) \
	$(GEE_CFLAGS) \
	$(NULL)

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

CLEANFILES = \
  pandora-glib.vapi \
  $(NULL)

