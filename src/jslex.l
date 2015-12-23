%{

/*
 * jassi - A Simple and Robust JavaScript Lexer
 * Copyright 2011 (c) Konrad Rieck (konrad@mlsec.org)
 */

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include "config.h"
#include "util.h"

#undef YYLMAX
#define YYLMAX	4000
#undef ECHO
#define ECHO {}

extern int show_str;
extern int show_num;
extern int show_id;

static void yyerror(char *);
static void yycomment(char *);
static void append(char *);
static char *queue = NULL;
static int qlen = 0;
static int qalloc = 0;

%}
%option noyywrap

DIGIT			[0-9]
HEXDIGIT		[a-fA-F0-9]
NUMBER			{DIGIT}+|0[xX]{HEXDIGIT}+|{DIGIT}+\.{DIGIT}+
LETTER			[a-zA-Z]
IDENTIFIER		{LETTER}({LETTER}|{DIGIT}|[$_])*
STRING			"\""("\\\""|[^"\""])*"\""|"'"("\\'"|[^"'"])*"'"

%%

"<![".*"["|"]]>"	/* Ignore CDATA and similar stuff */ ;
"<!--"|"-->"		/* Ignore HTML comments */ ;
("<"|"</"){LETTER}+">"	/* Ignore HTML tags from ResourceGetter */ ;
"<p "{LETTER}+"=\""	;
"\"></p>"		;

";"			{ append("; "); }
","			{ append(", "); }
"="			{ append("= "); }
"?"			{ append("? "); }
":"			{ append(": "); }
"||"			{ append("|| "); }
"&&"			{ append("&& "); }
"|"			{ append("| "); }
"^"			{ append("^ "); }
"&"			{ append("& "); }
"=="			{ append("== "); }
"!="			{ append("!= "); }
"==="			{ append("=== "); }
"!=="			{ append("!== "); }
"<"			{ append("< "); }
"<="			{ append("<= "); }
">="			{ append(">= "); }
">"			{ append("> "); }
"<<"			{ append("<< "); }
">>"			{ append(">> "); }
">>>"			{ append(">>> "); }
"+"			{ append("+ "); }
"-"			{ append("- "); }
"*"			{ append("* "); }
"/"			{ append("/ "); }
"%"			{ append("% "); }
"!"			{ append("! "); }
"~"			{ append("~ "); }
"++"			{ append("++ "); }
"--"			{ append("-- "); }
"."			{ append(". "); }
"["			{ append("[ "); }
"]"			{ append("] "); }
"{"			{ append("{ "); }
"}"			{ append("} "); }
"("			{ append("( "); }
")"			{ append(") "); }

"break"			{ append("BREAK "); }
"case" 			{ append("CASE "); }
"catch"			{ append("CATCH "); }
"const"			{ append("CONST "); }
"continue"		{ append("CONTINUE "); }
"debugger"		{ append("DEBUGGER "); }
"default"		{ append("DEFAULT "); }
"delete"		{ append("DELETE "); }
"do"			{ append("DO "); }
"else"			{ append("ELSE "); }
"enum"			{ append("ENUM "); }
"eval"			{ append("EVAL "); }
"false" 		{ append("FALSE "); }
"finally"		{ append("FINALLY "); }
"for"			{ append("FOR "); }
"function"		{ append("FUNCTION "); }
"if" 			{ append("IF "); }
"in"			{ append("IN "); }
"instanceof"		{ append("INSTANCEOF "); }
"new" 			{ append("NEW "); }
"null"			{ append("NULL "); }
"append"		{ append("APPEND "); }
"switch"		{ append("SWITCH "); }
"this" 			{ append("THIS "); }
"throw"			{ append("THROW "); }
"true"			{ append("TRUE "); }
"try"			{ append("TRY "); }
"typeof"		{ append("TYPEOF "); }
"var" 			{ append("VAR "); }
"void"			{ append("VOID "); }
"while"			{ append("WHILE "); }
"with"			{ append("WITH "); }

{NUMBER}		{
    if (show_num) {
        append(yytext); append(" ");
    } else {
        append("NUM ");
    }
}
{IDENTIFIER}		{
    if (show_id) {
        append(yytext); append(" ");
    } else {
        append("ID ");
    }
}

{STRING}		{
    if (show_str) {
        append(yytext); append(" ");
    } else {
        append("STR ");
    }
}

"/*"	   		yycomment("*/");
"//".*\n   		;

.                       { /* ignore remaining characters */ }

%%


char *jslex_string(char *x)
{
    queue = NULL;
    qalloc = 0;
    qlen = 0;

    /* Set intput and lex */
    yy_scan_string(x);
    yylex();

    return queue;
}

/*
 * Comment function called by lexer
 */
void yycomment(char *mat)
{
    int c;
    char *cp;

    for (cp = mat; *cp != 0; ) {
        c = input();
        if (c == EOF) {
            yyerror("end of file in comment");
            break;
        }
        if (c != *cp++) {
            cp = mat;
            if (c == *cp)
      	    cp++;
        }
    }
}

/*
 * Error function called by lexer
 */
void yyerror(char *s)
{
    fatal("%s\n", s);
}

/*
 * Append function called by lexer
 */
void append(char *token)
{
    assert(token);
    int n = strlen(token);

    if (queue == NULL || qlen + n + 1 > qalloc) {
        qalloc += 4096;
        queue = realloc(queue, qalloc * sizeof(char));
        if (!queue)
            fatal("Could not realloc lexer buffer");
    }

    strcpy(queue + qlen, token);
    qlen += strlen(token);
}
