# jassi - A Simple and Robust JavaScript Lexer
# Copyright 2011 (c) Konrad Rieck (konrad@mlsec.org)

AC_INIT([jassi], [1.0], [konrad@mlsec.org])
AC_PREFIX_DEFAULT("/usr/local")

# Init automake & config.h
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER([config.h])

# Check for important programs
AC_PROG_CC
AC_PROG_CXX
AC_PROG_LD
AC_PROG_INSTALL
AC_PROG_LEX

# Libtool stuff
AC_CONFIG_MACRO_DIR(m4)
AC_PROG_LIBTOOL

if test "$LEX" = ":" ; then
   AC_MSG_ERROR([ No lex tool available. ])
fi

# Set GCC and C99 flags if present
if test "$GCC" = "yes" ; then
   CFLAGS="$CFLAGS -std=c99 -Wall"
   CXXFLAGS="$CXXFLAGS -Wall"
fi

AC_CONFIG_FILES([ 
   Makefile \
   src/Makefile \
])

AC_OUTPUT

