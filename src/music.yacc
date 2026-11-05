%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);
%}

%token TOKEN_TEMPO TOKEN_TIME_SIG TOKEN_CLEF
%token TOKEN_DINAMICA TOKEN_BARRA TOKEN_METRICA TOKEN_DURACION
%token TOKEN_NOTA TOKEN_SILENCIO TOKEN_PUNTILLO TOKEN_LIGADURA
%token TOKEN_NUMERO TOKEN_ID TOKEN_ASIGN

%start sesion

%%

sesion:
      /* vacio */
    | sesion linea
    ;

linea:
      '\n'
    | instruccion '\n'      { printf("  [Sintaxis valida]\n"); }
    | error '\n'            { yyerrok; }
    ;

instruccion:
      configuracion
    | secuencia_musical
    ;

configuracion:
      TOKEN_TEMPO TOKEN_ASIGN TOKEN_NUMERO
    | TOKEN_TIME_SIG TOKEN_ASIGN TOKEN_METRICA
    | TOKEN_CLEF TOKEN_ASIGN TOKEN_ID
    ;

secuencia_musical:
      elemento_musical
    | secuencia_musical elemento_musical
    ;

elemento_musical:
      TOKEN_BARRA
    | TOKEN_DINAMICA
    | evento
    ;

evento:
      TOKEN_NOTA duracion_opcional modificadores
    | TOKEN_SILENCIO duracion_opcional
    ;

duracion_opcional:
      /* vacio */
    | TOKEN_DURACION
    ;

modificadores:
      /* vacio */
    | modificadores TOKEN_PUNTILLO
    | modificadores TOKEN_LIGADURA
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "  [Error Sintactico] %s en linea %d\n", s, yylineno);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("Error al abrir archivo");
            return 1;
        }
        yyin = archivo;
    } else {
        printf("Parser interactivo iniciado. Escribe sentencias y presiona Enter:\n");
    }

    yyparse();

    if (argc > 1) {
        fclose(yyin);
    }
    return 0;
}
