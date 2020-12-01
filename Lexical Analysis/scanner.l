/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;
#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

bool   		true|false
real     	[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?
ws			[ \t\r]+
comment		\-\-.*\n
singleLinecomment  "//".*\n 
line		[\n]
id			[A-Za-z]([_]?[A-Za-z0-9])*
digit		[0-9]
int			{digit}+
punc		[\(\),:;]

%%

{ws}		{ECHO;}
{line}		{ECHO; nextLine(); }
{comment}	{ECHO; nextLine(); }
{singleLinecomment}		{ECHO; nextLine();}
{bool}		{ECHO; yylval.value = strcmp(yytext,"true")==0 ? 1:0; return(BOOL_LITERAL);}
"=>"        {ECHO; return(ARROW);}
"/="        {ECHO; yylval.oper = NOTEQUAL; return(RELOP);}
">="        {ECHO; yylval.oper = GREATEREQUAL; return(RELOP);}
"<="        {ECHO; yylval.oper = LESSEQUAL; return(RELOP);}
">"         {ECHO; yylval.oper = GREATER; return(RELOP);}
"<"		    {ECHO; yylval.oper = LESS; return(RELOP); }
"+"		    {ECHO; yylval.oper = ADD; return(ADDOP);}
"-"		    {ECHO; yylval.oper = MINUS; return(ADDOP);}
"="         {ECHO; yylval.oper = EQUAL; return(RELOP);}
"**"        {ECHO; return(EXPOP);}
"*"		    {ECHO; yylval.oper = MULTIPLY; return(MULOP);}
"/"		    {ECHO; yylval.oper = DIVIDE; return(MULOP);}
rem         {ECHO; return(REMOP);}
or          {ECHO; return(OROP);}
not         {ECHO; return(NOTOP);}
case 		{ECHO; return(CASE);}
else 		{ECHO; return(ELSE);}
endcase 	{ECHO; return(ENDCASE);}
endif 		{ECHO; return(ENDIF);}
if 			{ECHO; return(IF);}
others 		{ECHO; return(OTHERS);}
real 		{ECHO; return(REAL);}
then 		{ECHO; return(THEN);}
when 		{ECHO; return(WHEN);}
begin		{ECHO; return(BEGIN_);}
boolean		{ECHO; return(BOOLEAN);}
end			{ECHO; return(END);}
endreduce	{ECHO; return(ENDREDUCE);}
function	{ECHO; return(FUNCTION);}
integer		{ECHO; return(INTEGER);}
is			{ECHO; return(IS);}
reduce		{ECHO; return(REDUCE);}
returns		{ECHO; return(RETURNS);}
and			{ECHO; return(ANDOP);}
{int}		{ECHO; yylval.value = atof(yytext); return(INT_LITERAL); }
{real}		{ECHO; yylval.value = stod(yytext); return(REAL_LITERAL);}
{id}		{ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{punc}		{ECHO; return(yytext[0]);}
.			{ECHO; appendError(LEXICAL, yytext);}

%%
