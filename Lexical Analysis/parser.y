/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>
#include <iostream>
#include <vector>
#include <map>
#include<cmath>
#include<cstring>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
Symbols<double> symbols;
double result;
double* global;
int i=1;


%}

%define parse.error verbose
%union
{
	CharPtr iden;
	Operators oper;
	double value;
}
%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token <oper> ADDOP MULOP RELOP 
%token ANDOP 
%token IF ARROW EXPOP REMOP OROP NOTOP CASE 
%token ELSE ENDCASE ENDIF OTHERS REAL THEN WHEN 
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%type <value> body statement_ case cases statement reductions term term2 term3 term4
              expression expression2 expression3 expression4 relation
%type <oper> operator

%%

	
function:	
	function_header variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';';
	
variable:
	IDENTIFIER ':' type IS statement_  {symbols.insert($1, $5);} variable |
	;
	
	
parameters: parameter  |
            parameter ',' parameters |
;			

parameter: IDENTIFIER ':' type {symbols.insert($1, global[i++]);} ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' {$$ = $1;} |
	error ';' {$$ = 0;} ;

statement:
	REDUCE operator reductions ENDREDUCE  {$$ = $3;} |
	expression {$$ = $1;} |
	CASE expression IS cases OTHERS ARROW statement_  ENDCASE  {$$ = isnan($4) ? $7 : $4;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = ((bool)$2==true ? $4 : $6);}
	;

cases:  cases case {$$ = isnan($1) ? $2 : $1;} |
          {$$ = NAN;}
         ;
		 
case:  WHEN INT_LITERAL ARROW statement_ {$$ = ($<value>-2 == $2) ? $4 : NAN ;}
       ;
       
operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
    {$$ = $<oper>0 == ADD ? 0 : 1;}
	;
			  		  
expression:
	expression OROP expression2 {$$ = $1 || $3;} |
	expression2 {$$ = $1;};
	;

expression2: 
     expression2 ANDOP expression3 {$$ = $1 && $3;} |
	  expression3 {$$ = $1;};
      ;
expression3: NOTOP expression3 {$$ = !$2;} |
			  expression4 {$$ = $1;}
			  
expression4 : '('expression')' {$$ = $2;}|
               relation {$$ = $1;} |
			   term {$$ = $1;};
			  
						   		 
relation:
    term RELOP term {$$ = evaluateRelational($1, $2, $3);}
	;
		   
term:
	term ADDOP term2 {$$ = evaluateArithmetic($1, $2, $3);}|
	term2 ;
 
term2:
	term2 MULOP term3 {$$ = evaluateArithmetic($1, $2, $3);} |
	term2 REMOP term3 {$$ = (int)$1 % (int)$3;} |
	term3;
	
term3: 
       term4 EXPOP term3 {$$ = pow($1,$3);}|
	   term4 
	   ;

term4: 
   '('term')' {$$ = $2;} |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);};	
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
    global = (double *)malloc(sizeof(double)*argc);
	for(int i =1;i<argc;i++) {
	     if(!strcmp(argv[i], "true"))
		    global[i]=1;
		 else
	        global[i] = atof(argv[i]);
	}
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 