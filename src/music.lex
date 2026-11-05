%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int column = 1;

#define YY_USER_ACTION column += yyleng;
%}

%option noyywrap
%option yylineno

DIGITO        [0-9]
LETRA_NOTA    [A-G]
ALTERACION    [#b]
OCTAVA        [0-8]
ESPACIO       [ \t\r]

%%

"//".*                  { /* Comentario: omitir */ }
\n                      { column = 1; return '\n'; }
{ESPACIO}+              { /* Descartar espacios */ }

"tempo"|"TEMPO"         { return TOKEN_TEMPO; }
"time"|"TIME"           { return TOKEN_TIME_SIG; }
"clef"|"CLEF"           { return TOKEN_CLEF; }

"ppp"|"pp"|"p"|"mp"|"mf"|"f"|"ff"|"fff" { 
                          strncpy(yylval.sval, yytext, sizeof(yylval.sval) - 1);
                          yylval.sval[sizeof(yylval.sval) - 1] = '\0';
                          return TOKEN_DINAMICA; 
                        }

"|:"|":|"|"||"|"|"     { 
                          strncpy(yylval.sval, yytext, sizeof(yylval.sval) - 1);
                          yylval.sval[sizeof(yylval.sval) - 1] = '\0';
                          return TOKEN_BARRA; 
                        }
"="                     { return TOKEN_ASIGN; }
"."                     { return TOKEN_PUNTILLO; }
"~"                     { return TOKEN_LIGADURA; }

{LETRA_NOTA}{ALTERACION}?{OCTAVA} { 
                          strncpy(yylval.sval, yytext, sizeof(yylval.sval) - 1);
                          yylval.sval[sizeof(yylval.sval) - 1] = '\0';
                          return TOKEN_NOTA; 
                        }

"R"([0-9]+)?            { 
                          strncpy(yylval.sval, yytext, sizeof(yylval.sval) - 1);
                          yylval.sval[sizeof(yylval.sval) - 1] = '\0';
                          return TOKEN_SILENCIO; 
                        }

{DIGITO}+\/{DIGITO}+    { 
                          strncpy(yylval.sval, yytext, sizeof(yylval.sval) - 1);
                          yylval.sval[sizeof(yylval.sval) - 1] = '\0';
                          return TOKEN_METRICA; 
                        }

\/(1|2|4|8|16|32|64)     { 
                          int den = atoi(yytext + 1);
                          yylval.dval = (den > 0) ? (4.0 / (double)den) : 1.0;
                          return TOKEN_DURACION; 
                        }

{DIGITO}+               { 
                          yylval.ival = atoi(yytext); 
                          return TOKEN_NUMERO; 
                        }

[a-zA-Z_][a-zA-Z0-9_]* { 
                          strncpy(yylval.sval, yytext, sizeof(yylval.sval) - 1);
                          yylval.sval[sizeof(yylval.sval) - 1] = '\0';
                          return TOKEN_ID; 
                        }

. {
    fprintf(stderr, "[Error Léxico] Carácter '%s' no reconocido en L:%d C:%d\n", 
            yytext, yylineno, column - (int)yyleng);
}

%%
