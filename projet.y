%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *name;
    char *type;
    int isConst;
    // Additional attributes as needed
} Symbol;

Symbol symbolTable[100]; // Simple symbol table
int symbolCount = 0;

void addToSymbolTable(char *name, char *type, int isConst);
Symbol* findInSymbolTable(char *name);
void yyerror(const char *s);
%}

// Token declarations
%token IDF INT_CONST FLT_CONST CONST
%token COMMA SEMICOLON ASSIGN
%token EQUAL GTR GTE LT LE ADD SUB MULT DIV
%token BEGIN END IF FOR ELSE
%token BOOL_TYPE INT_TYPE FLOAT_TYPE

// Start symbol for the grammar
%start program

// Operator precedence and associativity
%left ADD SUB
%left MULT DIV
%left LT LE GTR GTE EQUAL
%nonassoc UMINUS

%%

// Grammar rules
program: declarations BEGIN instructions END ;

declarations:
    | declarations var_declaration
    | declarations const_declaration
    | /* empty */
    ;

var_declaration:
    type id_list SEMICOLON
    ;

id_list:
    IDF
    | id_list COMMA IDF
    ;

const_declaration:
    CONST type IDF ASSIGN constant SEMICOLON
    ;

type:
    INT_TYPE
    | FLOAT_TYPE
    | BOOL_TYPE
    ;

constant:
    INT_CONST
    | FLT_CONST
    ;

instructions:
    | instructions instruction
    | /* empty */
    ;

instruction:
    assignment
    | loop
    | condition
    | SEMICOLON // Empty statement
    ;

assignment:
    IDF ASSIGN expression SEMICOLON
    ;

loop:
    FOR '(' assignment condition ';' IDF ASSIGN expression ')' '{' instructions '}'
    ;

condition:
    IF '(' expression ')' '{' instructions '}' ELSE '{' instructions '}'
    | IF '(' expression ')' '{' instructions '}'
    ;

expression:
    expression ADD expression
    | expression SUB expression
    | expression MULT expression
    | expression DIV expression
    | expression LT expression
    | expression LE expression
    | expression GTR expression
    | expression GTE expression
    | expression EQUAL expression
    | '(' expression ')'
    | IDF
    | constant
    | SUB expression %prec UMINUS
    ;

%%

// C code to manage the symbol table and error handling goes here.

void addToSymbolTable(char *name, char *type, int isConst) {
    // Check if the symbol already exists
    Symbol *symbol = findInSymbolTable(name);
    if (symbol) {
        fprintf(stderr, "Semantic error: Duplicate declaration of '%s'\n", name);
        exit(1);
    }
    // Add the new symbol to the symbol table
    symbolTable[symbolCount].name = strdup(name);
    symbolTable[symbolCount].type = strdup(type);
    symbolTable[symbolCount].isConst = isConst;
    symbolCount++;
}

Symbol* findInSymbolTable(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return &symbolTable[i];
        }
    }
    return NULL;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}

int main() {
    yyparse();
    return 0;
}
