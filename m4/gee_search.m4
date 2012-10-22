AC_DEFUN([GEE_SEARCH],
[dnl
# Check for libgee as super-project
if test -d "$srcdir/../libgee"; then
	GEE_CFLAGS='-I$(top_srcdir)/../libgee/gee/'
	GEE_LIBS='$(top_builddir)/../libgee/gee/libgee-0.8.la'
	GEE_VALAFLAGS='--vapidir $(top_builddir)/../libgee/gee/'
	AC_SUBST(GEE_VALAFLAGS)
else
	GEE_REQUIRED=0.7.2
	PKG_CHECK_MODULES(GEE, gee-0.8 >= $GEE_REQUIRED)
fi
AC_SUBST(GEE_CFLAGS)
AC_SUBST(GEE_LIBS)[]dnl
])# GEE_SEARCH
