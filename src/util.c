/* 
 * jassi - A Simple and Robust JavaScript Lexer
 *  Copyright 2011 (c) Konrad Rieck (konrad@mlsec.org)
 */
 
/**
 * @defgroup util Utility functions
 * The module contains utility functions.
 * @author Konrad Rieck (konrad.rieck@tu-berlin.de)
 * @{
 */

#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdarg.h>
#include <errno.h>
#include <string.h>

#include "config.h"
#include "util.h"

/* External variable */
extern int verbose;

/**
 * Loads a textual file into a string. The string is allocated 
 * and need to be free'd later by the caller.
 * @param path Path to file
 * @param name File name or NULL
 * @return string data
 */
char *load_file(char *path, char *name)
{
    assert(path);
    long len, read, i;
    char *x = NULL, file[512];
    struct stat st;

    /* snprintf is not necessary thread-safe. good to know. */
    if (name)
        snprintf(file, 512, "%s/%s", path, name);
    else
        snprintf(file, 512, "%s", path);

    /* Open file */
    FILE *fptr = fopen(file, "r");
    if (!fptr) {
        error("Could not open file '%s'", file);
        return NULL;
    }

    /* Allocate memory */
    stat(file, &st);
    len = st.st_size;
    if (!(x = malloc((len + 1) * sizeof(char)))) {
        error("Could not allocate memory for file data");
        return NULL;
    }

    /* Read data */
    read = fread(x, sizeof(char), len, fptr);
    fclose(fptr);
    if (len != read)
        warning("Could not read all data from file '%s'", file);

    /* Replace null bytes by space */
    for (i = 0; i < len; i++) 
        if (x[i] == 0)
            x[i] = ' ';

    /* Terminate string */
    x[len] = '\0';
    return x;
}


/**
 * Loads a data from stdin into a string. The string is allocated 
 * and need to be free'd later by the caller.
 * @return string data
 */
char *load_stdin()
{
    long len = 0, read = 0, i;
    char *p, *x = NULL;

    /* Open file */
    while(!feof(stdin)) {

        len += BLOCK_SIZE;
        x = realloc(x, len);
        p = x + len - BLOCK_SIZE;
        if (!x) {
            error("Could not allocate data");
            return NULL;
        }
            
        read += fread(p, sizeof(char), BLOCK_SIZE, stdin);
    }

    /* Replace null bytes by space */
    for (i = 0; i < read; i++) 
        if (x[i] == 0)
            x[i] = ' ';

    /* Terminate string */
    x[read] = '\0';
    return x;
}

/**
 * Print a formated error/warning message. See the macros error and 
 * warning in util.h
 * @param p Prefix string, e.g. "Error"
 * @param f Function name
 * @param m Format string
 */
void err_msg(char *p, const char *f, char *m, ...) 
{
    va_list ap;
    char s[256] = { " " };
    
    va_start(ap, m);
    vsnprintf(s, 256, m, ap);
    va_end(ap);

    fprintf(stderr, "%s: %s (", p, s);
    if (errno)
        fprintf(stderr, "%s, ", strerror(errno));
    fprintf(stderr, "%s)\n", f);
    errno = 0;
}

/** @} */

