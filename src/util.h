/* 
 * jassi - A Simple and Robust JavaScript Lexer
 * Copyright 2011 (c) Konrad Rieck (konrad@mlsec.org)
 */

#ifndef UTIL_H
#define UTIL_H

#include "config.h"

/* Fatal message */
#ifndef fatal
#define fatal(...)     {err_msg("Error", __func__, __VA_ARGS__); exit(-1);}
#endif
/* Error message */
#ifndef error
#define error(...)     {err_msg("Error", __func__, __VA_ARGS__);}
#endif
/* Warning message */
#ifndef warning
#define warning(...)   {err_msg("Warning", __func__, __VA_ARGS__);}
#endif

#define BLOCK_SIZE	(1<<16)

/* Utility functions */
void err_msg(char *, const char *, char *, ...);
void info_msg(int, char *, ...);
char *load_file(char *path, char *name);
char *load_stdin();

#endif                          /* UTIL_H */
