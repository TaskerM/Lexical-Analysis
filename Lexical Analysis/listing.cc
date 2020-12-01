// Compiler Theory and Design
// Mark Tasker

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <queue>
#include <iostream>

using namespace std;

#include "listing.h"

static int lineNumber;
static int totalErrors = 0;
static int lexicalErrors=0;
static int syntacticErrors = 0;
static int semanticErrors = 0;
static queue<string> errorMessagesQueue;
static void displayErrors();


void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
    displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	if(totalErrors!=0){
	    printf("\nLexical Errors %d\n",lexicalErrors);
		printf("Syntax Errors %d\n",syntacticErrors);
		printf("Semantic Errors %d\n",semanticErrors);
	}
	else if(totalErrors==0){
		printf("\nCompiled Successfully\n");
	}
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { 
		 "Lexical Error, Invalid Character "
	    ,""
		,"Semantic Error, "
		,"Semantic Error, Duplicate Identifier: "
		,"Semantic Error, Undeclared " 
	};
	errorMessagesQueue.push(messages[errorCategory] + message);
	if(errorCategory == 0) 
		lexicalErrors++;
	if(errorCategory == 1) 
	    syntacticErrors++;
	if(errorCategory == 2 || errorCategory ==3 || errorCategory == 4)
		semanticErrors++;
	totalErrors++;
}

void displayErrors()
{
	   while(!errorMessagesQueue.empty()){
	   cout << errorMessagesQueue.front() << endl;
	   errorMessagesQueue.pop();
   }
}