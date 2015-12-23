/* 
 * jassi - A Simple and Robust JavaScript Lexer
 * Copyright 2011 (c) Konrad Rieck (konrad@mlsec.org)
 */

#include <config.h>
#include <stdlib.h>
#include <stdio.h>

#include "jslex.h"
#include "util.h"

int show_str = 1;
int show_num = 1;
int show_id = 0;

/**
 * Main function of Lexer
 * @param argc Number of arguments
 * @param argv Argument values
 * @return Exit code
 */
int main(int argc, char **argv)
{
    char *fbuf;

    if (argc == 1) 
        fbuf = load_stdin();
    else if (argc == 2)
        fbuf = load_file(argv[1], NULL);    
    else
        fatal("jassi takes one argument");
    
    if (!fbuf)
        fatal("Failed to load content");
    
    char *lbuf = jslex_string(fbuf);
    printf("%s\n", lbuf);
    free(lbuf);
    free(fbuf);            

    return EXIT_SUCCESS;
}
