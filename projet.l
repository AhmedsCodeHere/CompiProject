%{
#include "PartieSyntax.tab.h" // Include the Bison header file for token definitions
int nbl = 1; // Line number starts at 1
%}

%option noyywrap

%%

// Tokens for identifiers
[A-Z][A-Za-z0-9_]{0,9}     { printf("identifier: %s\n", yytext); return IDF; }

// Tokens for integer constants
[0-9]+                     { printf("integer: %s\n", yytext); return INT_CONST; }

// Tokens for floating-point constants
[0-9]+\.[0-9]+             { printf("float: %s\n", yytext); return FLOAT_CONST; }

// Keywords
"bool"                      { printf("bool\n"); return BOOL_TYPE; }
"int"                       { printf("int\n"); return INT_TYPE; }
"float"                     { printf("float\n"); return FLOAT_TYPE; }
"const"                     { printf("const\n"); return CONST; }
"begin"                     { printf("begin\n"); return BEGIN; }
"end"                       { printf("end\n"); return END; }

// Operators and punctuation
":="                        { printf("assign\n"); return ASSIGN; }
","                         { printf("comma\n"); return COMMA; }
";"                         { printf("semicolon\n"); return SEMICOLON; }
"=="                        { printf("equal\n"); return EQUAL; }
">"                         { printf("greater than\n"); return GT; }
"<"                         { printf("less than\n"); return LT; }
">="                        { printf("greater or equal\n"); return GE; }
"<="                        { printf("less or equal\n"); return LE; }
"+"                         { printf("addition\n"); return ADD; }
"-"                         { printf("subtraction\n"); return SUB; }
"*"                         { printf("multiplication\n"); return MULT; }
"/"                         { printf("division\n"); return DIV; }
"("                         { printf("left parenthesis\n"); return LEFT_PAR; }
")"                         { printf("right parenthesis\n"); return RIGHT_PAR; }

// Rule to ignore comments, including multi-line comments
"{"([^}]|\n)*"}"            { /* Ignore comments */ }

// Ignore whitespace
[ \t]+                      { /* Ignore whitespace */ }

// Increment line number on newlines
\n                          { nbl++; }

// Error handling for unexpected characters
[^ \t\n]+                   { printf("Error at line %d: Unexpected character '%s'\n", nbl, yytext); }

%%
