AC_INIT([pandora-glib],[m4_esyscmd(build-aux/git-version-gen .tarball-version)],[nuhrin@oceanic.to],[pandora-glib])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([no-dist-gzip dist-bzip2])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AM_MAINTAINER_MODE

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
LT_INIT

AM_PROG_VALAC([0.11.0])
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

GLIB_REQUIRED=2.16.0
PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

GEE_REQUIRED=0.6.1
PKG_CHECK_MODULES(GEE, gee-1.0 >= $GEE_REQUIRED)
AC_SUBST(GEE_CFLAGS)
AC_SUBST(GEE_LIBS)

have_libpnd=no
AC_SEARCH_LIBS([pnd_box_new], [pnd], [have_libpnd=yes], [], [-lstdc++])
if test "x${have_libpnd}" = xyes; then
  AC_CHECK_HEADERS([pnd_container.h], [], [have_libpnd=no])
fi
if test "x${have_libpnd}" = xno; then
  AC_MSG_ERROR([libpnd not found.])
fi
PND_LIBS="$LIBS -lstdc++"
AC_SUBST(PND_LIBS)

AC_ARG_ENABLE(doc, AS_HELP_STRING([--enable-doc], [Enable documentation generation]), enable_doc=$enableval, enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test x$enable_doc = xyes)

AS_IF([test "x$enable_doc" != xno],
  [AC_PATH_PROG(VALADOC, valadoc, :)
   AC_SUBST(VALADOC)
   AS_IF([test "$VALADOC" = :],
    [AC_MSG_ERROR([valadoc not found])])])


AC_CONFIG_FILES([
	pandora-glib.pc
	Makefile
	src/Makefile
	doc/Makefile
	vapi/Makefile
])
AC_OUTPUT
