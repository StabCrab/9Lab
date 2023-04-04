%{
  #include "main.tab.hh"
  extern "C" int yylex(void);
%}

%%

[a-zA-Z][a-zA-Z0-9]* {
  yylval.S = strdup(yytext);
  return STR;
}
[0-9]+ {
  yylval.I = atoi(yytext);
  return INT;
}

\+ { return '+'; }
\= { return '='; }


%%
