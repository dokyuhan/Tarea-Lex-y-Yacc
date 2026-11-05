%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern int yylex(void);
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);

/* Parametros globales de la partitura */
static int score_tempo = 120;
static int time_sig_num = 4;
static int time_sig_den = 4;
static char score_clef[32] = "treble";
static char current_dynamic[16] = "mf";

/* Metricas por compas y acumuladas */
static int current_measure = 1;
static double current_measure_beats = 0.0;
static double expected_measure_beats = 4.0;

static int total_measures_processed = 0;
static int total_valid_measures = 0;
static int total_flagged_measures = 0;
static int total_notes = 0;
static int total_rests = 0;
static int total_repeats = 0;

static int in_repeat_block = 0;
static double repeat_block_beats = 0.0;
static double total_score_beats = 0.0;

static void update_time_signature(const char *sig) {
    int num = 4, den = 4;
    if (sscanf(sig, "%d/%d", &num, &den) == 2 && den > 0) {
        time_sig_num = num;
        time_sig_den = den;
        expected_measure_beats = (double)num * (4.0 / (double)den);
    }
}

static void process_note(const char *note, double dur, int dots, int tied) {
    (void)note;
    (void)tied;
    if (dur <= 0.0) dur = 1.0;
    if (dots > 0) dur *= 1.5;
    current_measure_beats += dur;
    total_score_beats += dur;
    total_notes++;
    if (in_repeat_block) {
        repeat_block_beats += dur;
    }
}

static void process_rest(const char *rest_str, double dur, int dots) {
    if (dur <= 0.0) {
        if (strlen(rest_str) > 1) {
            int den = atoi(rest_str + 1);
            dur = (den > 0) ? (4.0 / (double)den) : 1.0;
        } else {
            dur = 1.0;
        }
    }
    if (dots > 0) dur *= 1.5;
    current_measure_beats += dur;
    total_score_beats += dur;
    total_rests++;
    if (in_repeat_block) {
        repeat_block_beats += dur;
    }
}

static void process_bar(const char *bar) {
    if (strcmp(bar, "|:") == 0) {
        in_repeat_block = 1;
        repeat_block_beats = 0.0;
    }

    if (current_measure_beats > 0.001) {
        total_measures_processed++;
        if (fabs(current_measure_beats - expected_measure_beats) < 0.01) {
            printf("  [Compás %2d] Métrica válida: %.2f/%.2f tiempos\n",
                   current_measure, current_measure_beats, expected_measure_beats);
            total_valid_measures++;
        } else {
            printf("  [Compás %2d] Aviso rítmico: %.2f tiempos (esperados: %.2f tiempos)\n",
                   current_measure, current_measure_beats, expected_measure_beats);
            total_flagged_measures++;
        }
        current_measure++;
        current_measure_beats = 0.0;
    }

    if (strcmp(bar, ":|") == 0) {
        total_repeats++;
        total_score_beats += repeat_block_beats;
        printf("  [Repetición] Bloque repetido sumado (+%.2f tiempos)\n", repeat_block_beats);
        in_repeat_block = 0;
        repeat_block_beats = 0.0;
    }
}

static void print_interpretation_summary(void) {
    double total_duration_sec = 0.0;
    if (score_tempo > 0) {
        total_duration_sec = total_score_beats * (60.0 / (double)score_tempo);
    }

    printf("\n===========================================================\n");
    printf("   REPORTE DE INTERPRETACIÓN Y ANÁLISIS DE PARTITURA\n");
    printf("===========================================================\n");
    printf("Parámetros Globales:\n");
    printf("  Tempo:              %d BPM\n", score_tempo);
    printf("  Compás:             %d/%d (%.2f tiempos por compás)\n",
           time_sig_num, time_sig_den, expected_measure_beats);
    printf("  Clave musical:      %s\n", score_clef);
    printf("  Última dinámica:    %s\n", current_dynamic);
    printf("-----------------------------------------------------------\n");
    printf("Métricas de Ejecución:\n");
    printf("  Compases totales:   %d (%d válidos, %d con avisos)\n",
           total_measures_processed, total_valid_measures, total_flagged_measures);
    printf("  Notas procesadas:   %d\n", total_notes);
    printf("  Silencios:          %d\n", total_rests);
    printf("  Secciones repeat:   %d\n", total_repeats);
    printf("  Tiempos totales:    %.2f tiempos de negra\n", total_score_beats);
    printf("-----------------------------------------------------------\n");
    printf("Duración Estimada de Interpretación:\n");
    printf("  Segundos:           %.2f s\n", total_duration_sec);
    printf("  Minutos:            %.2f min\n", total_duration_sec / 60.0);
    printf("===========================================================\n\n");
}
%}

%union {
    int ival;
    double dval;
    char sval[64];
    struct {
        int dots;
        int tied;
    } modval;
}

%token TOKEN_TEMPO TOKEN_TIME_SIG TOKEN_CLEF
%token <sval> TOKEN_DINAMICA TOKEN_BARRA TOKEN_METRICA
%token <dval> TOKEN_DURACION
%token <sval> TOKEN_NOTA TOKEN_SILENCIO
%token TOKEN_PUNTILLO TOKEN_LIGADURA
%token <ival> TOKEN_NUMERO
%token <sval> TOKEN_ID
%token TOKEN_ASIGN

%type <dval> duracion_opcional
%type <modval> modificadores

%start sesion

%%

sesion:
      /* vacio */
    | sesion linea
    ;

linea:
      '\n'
    | instruccion '\n'
    | error '\n'            { yyerrok; }
    ;

instruccion:
      configuracion
    | secuencia_musical
    ;

configuracion:
      TOKEN_TEMPO TOKEN_ASIGN TOKEN_NUMERO {
          score_tempo = $3;
          if (score_tempo <= 0) score_tempo = 120;
      }
    | TOKEN_TIME_SIG TOKEN_ASIGN TOKEN_METRICA {
          update_time_signature($3);
      }
    | TOKEN_CLEF TOKEN_ASIGN TOKEN_ID {
          strncpy(score_clef, $3, sizeof(score_clef) - 1);
          score_clef[sizeof(score_clef) - 1] = '\0';
      }
    ;

secuencia_musical:
      elemento_musical
    | secuencia_musical elemento_musical
    ;

elemento_musical:
      TOKEN_BARRA {
          process_bar($1);
      }
    | TOKEN_DINAMICA {
          strncpy(current_dynamic, $1, sizeof(current_dynamic) - 1);
          current_dynamic[sizeof(current_dynamic) - 1] = '\0';
      }
    | evento
    ;

evento:
      TOKEN_NOTA duracion_opcional modificadores {
          process_note($1, $2, $3.dots, $3.tied);
      }
    | TOKEN_SILENCIO duracion_opcional modificadores {
          process_rest($1, $2, $3.dots);
      }
    ;

duracion_opcional:
      /* vacio */ { $$ = 1.0; }
    | TOKEN_DURACION { $$ = $1; }
    ;

modificadores:
      /* vacio */ {
          $$.dots = 0;
          $$.tied = 0;
      }
    | modificadores TOKEN_PUNTILLO {
          $$ = $1;
          $$.dots++;
      }
    | modificadores TOKEN_LIGADURA {
          $$ = $1;
          $$.tied = 1;
      }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "  [Error Sintáctico] %s en línea %d\n", s, yylineno);
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

    /* Si quedo un compas pendiente sin barra de cierre final */
    if (current_measure_beats > 0.001) {
        process_bar("|");
    }

    print_interpretation_summary();

    if (argc > 1) {
        fclose(yyin);
    }
    return 0;
}
