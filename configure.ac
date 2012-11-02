AC_INIT([pandora-glib],[m4_esyscmd(build-aux/git-version-gen .tarball-version)],[nuhrin@oceanic.to],[pandora-glib])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([no-dist-gzip dist-bzip2 tar-ustar])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AM_MAINTAINER_MODE

# Add config arguments.
AC_ARG_ENABLE(devhelp, AS_HELP_STRING([--enable-devhelp], [Enable devhelp book generation]), enable_devhelp=$enableval, enable_devhelp=no)
AM_CONDITIONAL(ENABLE_DEVHELP, test x$enable_devhelp = xyes)


# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
LT_INIT

AM_PROG_VALAC([0.18.0])
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

AS_IF([test "x$enable_devhelp" != xno],
  [AC_PATH_PROG(VALADOC, valadoc, :)
   AC_SUBST(VALADOC)
   AS_IF([test "$VALADOC" = :],
	 if test -f "doc/pandora-glib/index.htm"; then
       AC_MSG_WARN([valadoc not found: You will not be able to rebuild devhelp documentation.])
     else
       AC_MSG_ERROR([valadoc not found])
     fi)])

# Checks for packages
GLIB_REQUIRED=2.18.0
PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

# Check for libgee superproject, then system
GEE_SEARCH

# Check for libpnd.	
AC_SEARCH_LIBS([pnd_box_new], [pnd], [], [AC_MSG_ERROR([libpnd not found.])], [-lstdc++])
AC_CHECK_HEADERS([pnd_container.h], [], [AC_MSG_ERROR([libpnd headers not found.])])
PND_LIBS="$LIBS -lstdc++"
AC_SUBST(PND_LIBS)


AC_CONFIG_FILES([
	pandora-glib.pc
	Makefile
	src/Makefile
	doc/Makefile
	vapi/Makefile
])

AC_OUTPUT

