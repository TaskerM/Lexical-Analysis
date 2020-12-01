// CMSC 430
// Mark Tasker

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {EQUAL, NOTEQUAL, LESS, LESSEQUAL, GREATER, GREATEREQUAL, ADD, MINUS, DIVIDE, MULTIPLY};

double evaluateReduction(Operators operator_, double head, double tail);
int evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);

