/*
 *
 *  Simplest, but really bad grammar
 *  E -> T | E + T
 *  T -> T * F | F
 *  F -> E | ( E ) | number
 *
 */

%language "c++"

%skeleton "lalr1.cc"
%defines
%define api.value.type variant
%param {yy::Driver* driver}

%code requires
{
#include <iostream>
#include <string>

// forward decl of argument to parser
namespace yy { class Driver; }
}

%code
{
#include "driver.hpp"

namespace yy {

parser::token_type yylex(parser::semantic_type* yylval,
                         Driver* driver);
}
}

%token
    PLUS   "+"
    MULT   "*"
    LBRAC  "("
    RBRAC  ")"
    ERR
;

%token <int> NUMBER
%nterm <int> EN
%nterm <int> TN
%nterm <int> FN

%start program

%%

program: EN                   { std::cout << $1 << std::endl; }
;

EN: TN                        { $$ = $1; }
  | EN PLUS TN                { $$ = $1 + $3; }
;

TN: TN MULT FN                { $$ = $1 * $3; }
  | FN                        { $$ = $1; }
;

FN: EN                        { $$ = $1; }
  | LBRAC EN RBRAC            { $$ = $2; }
  | NUMBER                    { $$ = $1; }
;

%%

namespace yy {

parser::token_type yylex(parser::semantic_type* yylval,
                         Driver* driver)
{
    return driver->yylex(yylval);
}

void parser::error(const std::string&){}
}
