// Compiler Theory and Design
// Mark Tasker

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>
#include<iostream>
using namespace std;

#include "values.h"
#include "listing.h"

double evaluateReduction(Operators operator_, double head, double tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


int evaluateRelational(double left, Operators operator_, double right)
{
	int result;
	switch (operator_)
	{
		case EQUAL:
		    result = left == right;
			break;
		case LESS:
			result = left < right;
			break;
		case LESSEQUAL:
		     result = left <= right;
			 break;
	    case GREATER:
		     result = left > right;
			 break;
		case GREATEREQUAL:
		     result = left >= right;
			 break;
		case NOTEQUAL:
		     result = left != right;
			 break;
	    
	}
	return result;
}

double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case MINUS:
			result = left - right;
			break;
		case DIVIDE:
             result = left / right;
             break;			 
		
	}
	return result;
}

