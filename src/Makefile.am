NULL =

AUTOMAKE_OPTIONS = subdir-objects

lib_LTLIBRARIES =

pandora_glib_VALASOURCES = \
	Apps.vala \
	Config.vala \
	Utility.vala \
	Apps/App.vala \
	Apps/AppList.vala \
	Apps/DataCache.vala \
	Apps/enums.vala \
	Apps/Pnd.vala \
	Config/ConfigFile.vala \
	Config/AppsConfigFile.vala \
	Config/DesktopConfigFile.vala \
	Config/PndOvrAppFile.vala \
	Config/PndOvrFile.vala \
	$(NULL)

pandora_glib_VALAFLAGS = \
	-H pandora-glib.h --vapi pandora-glib.vapi --vapidir ../vapi \
	--pkg gobject-2.0 --pkg gee-0.8 --pkg pnd --pkg config \
	--library pandora-glib \
	$(GEE_VALAFLAGS) \
	$(VALAFLAGS) \
	$(NULL)

if DONT_COMPILE
libpandora_glib_la_vala.stamp: $(pandora_glib_VALASOURCES)
	@$(VALA_V)$(VALAC) -C $(pandora_glib_VALAFLAGS) $^
	@touch $@

BUILT_SOURCES = libpandora_glib_la_vala.stamp
endif

if DO_COMPILE
lib_LTLIBRARIES += \
  libpandora-glib.la
  $(NULL)

libpandora_glib_la_SOURCES = \
	$(pandora_glib_VALASOURCES) \
	$(NULL)

libpandora_glib_la_VALAFLAGS = $(pandora_glib_VALAFLAGS)
 
AM_CPPFLAGS = \
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
endif
