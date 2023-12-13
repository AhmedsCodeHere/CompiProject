#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

typedef struct Symbol {
    char *name;
    char *type;
    int isConst;
    int scopeLevel;
    int lineNumber;
    // Additional attributes as needed
} Symbol;

typedef struct SymbolNode {
    Symbol symbol;
    struct SymbolNode *next;
} SymbolNode;

SymbolNode *symbolTable[TABLE_SIZE];

unsigned int hash(char *str) {
    unsigned int hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c; // hash * 33 + c
    }
    return hash % TABLE_SIZE;
}

SymbolNode* createSymbol(char *name, char *type, int isConst, int scopeLevel, int lineNumber) {
    SymbolNode *newNode = (SymbolNode *)malloc(sizeof(SymbolNode));
    newNode->symbol.name = strdup(name);
    newNode->symbol.type = strdup(type);
    newNode->symbol.isConst = isConst;
    newNode->symbol.scopeLevel = scopeLevel;
    newNode->symbol.lineNumber = lineNumber;
    newNode->next = NULL;
    return newNode;
}

void insertSymbol(SymbolNode *symbol) {
    unsigned int index = hash(symbol->symbol.name);
    SymbolNode *current = symbolTable[index];
    if (current == NULL) {
        symbolTable[index] = symbol;
    } else {
        // Handle collision with chaining
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = symbol;
    }
}

SymbolNode* findSymbol(char *name) {
    unsigned int index = hash(name);
    SymbolNode *current = symbolTable[index];
    while (current != NULL) {
        if (strcmp(current->symbol.name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL; // Not found
}

void deleteSymbol(char *name) {
    unsigned int index = hash(name);
    SymbolNode *current = symbolTable[index];
    SymbolNode *prev = NULL;
    while (current != NULL) {
        if (strcmp(current->symbol.name, name) == 0) {
            if (prev == NULL) {
                symbolTable[index] = current->next;
            } else {
                prev->next = current->next;
            }
            free(current->symbol.name);
            free(current->symbol.type);
            free(current);
            return;
        }
        prev = current;
        current = current->next;
    }
}

void printSymbolTable() {
    printf("Symbol Table:\n");
    for (int i = 0; i < TABLE_SIZE; i++) {
        SymbolNode *current = symbolTable[i];
        while (current != NULL) {
            printf("Name: %s, Type: %s, Const: %d, Scope: %d, Line: %d\n",
                   current->symbol.name,
                   current->symbol.type,
                   current->symbol.isConst,
                   current->symbol.scopeLevel,
                   current->symbol.lineNumber);
            current = current->next;
        }
    }
}

// Example usage
int main() {
    SymbolNode *s1 = createSymbol("x", "int", 0, 1, 10);
    insertSymbol(s1);
    SymbolNode *s2 = createSymbol("y", "float", 1, 1, 15);
    insertSymbol(s2);
    printSymbolTable();
    deleteSymbol("x");
    printSymbolTable();
    return 0;
}