%{
#include <string>
#include <unordered_map>
#include <iostream>
#include <stdio.h>

std::unordered_map<std::string, int> hashtable;

extern "C" int yylex(void);
extern int yyparse();
extern FILE *yyin;
extern "C" void yyerror(const char *s);

static int value = 0;
std::string var_name;
bool postincr = false;
%}

%token  END 0
%token STR INT 

%union{
  // 
  char* S;
  int I;
  } //
%type <I> INT 
%type <S> STR

// E ::= ++S E1 | S E2 | I
// E1 ::= ε | = E
// E2 ::= ε | = E | ++

%%

e0: '+' '+' STR e1 {
  var_name = std::string($3);
  hashtable[var_name] = value;
  hashtable[var_name]++;
  value++;
  postincr = false;
};
e0: STR e2 {
  std::cout << "\ne02\n";
  var_name = std::string($1);
  hashtable[var_name] = value;
  if ( postincr )
    hashtable[var_name]++;
  postincr = false;
};
e0: INT {
  std::cout << "value:"<< value;
  value = $1;
  std::cout << "; value_new:"<< value << "\n";
};

e1:  '=' e0 ;
e1: %empty ;

e2:  '=' e0 ;
e2: '+' '+' {
  postincr = true;
  std::cout << "\n02 ++++++\n";
};
e2: %empty ;


%%

int main(int, char**) {
  FILE *myfile = fopen("test", "r");
  if (!myfile) {
    std::cout << "I can't open test file!" << std::endl;
    return -1;
  }
  //yyin = myfile;
  yyin = stdin;

  yyparse();

  for (const auto &p : hashtable) {
    std::cout << p.first << " : " << p.second << std::endl;
  }
}


void yyerror(const char *s) {
  std::cout << "EEK, parse error!  Message: " << s << std::endl;
  exit(-1);
}
