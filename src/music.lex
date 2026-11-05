%{
#include <stdio.h>
#include <stdlib.h>
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

"tempo"|"TEMPO"         { printf("-> TOKEN_TEMPO: %s\n", yytext); return TOKEN_TEMPO; }
"time"|"TIME"           { printf("-> TOKEN_TIME_SIG: %s\n", yytext); return TOKEN_TIME_SIG; }
"clef"|"CLEF"           { printf("-> TOKEN_CLEF: %s\n", yytext); return TOKEN_CLEF; }

"ppp"|"pp"|"p"|"mp"|"mf"|"f"|"ff"|"fff" { 
                          printf("-> TOKEN_DINAMICA: %s\n", yytext); 
                          return TOKEN_DINAMICA; 
                        }

"|:"|":|"|"||"|"|"     { printf("-> TOKEN_BARRA: %s\n", yytext); return TOKEN_BARRA; }
"="                     { printf("-> TOKEN_ASIGN: %s\n", yytext); return TOKEN_ASIGN; }
"."                     { printf("-> TOKEN_PUNTILLO: %s\n", yytext); return TOKEN_PUNTILLO; }
"~"                     { printf("-> TOKEN_LIGADURA: %s\n", yytext); return TOKEN_LIGADURA; }

{LETRA_NOTA}{ALTERACION}?{OCTAVA} { 
                          printf("-> TOKEN_NOTA: %s\n", yytext); 
                          return TOKEN_NOTA; 
                        }
"R"{OCTAVA}?            { printf("-> TOKEN_SILENCIO: %s\n", yytext); return TOKEN_SILENCIO; }

{DIGITO}+\/{DIGITO}+    { printf("-> TOKEN_METRICA: %s\n", yytext); return TOKEN_METRICA; }
\/(2|4|8|16|32|64)      { printf("-> TOKEN_DURACION: %s\n", yytext); return TOKEN_DURACION; }

{DIGITO}+               { printf("-> TOKEN_NUMERO: %s\n", yytext); return TOKEN_NUMERO; }
[a-zA-Z_][a-zA-Z0-9_]* { printf("-> TOKEN_ID: %s\n", yytext); return TOKEN_ID; }

. {
    fprintf(stderr, "[Error Lexico] Caracter '%s' no reconocido en L:%d C:%d\n", 
            yytext, yylineno, column - (int)yyleng);
}

%%
