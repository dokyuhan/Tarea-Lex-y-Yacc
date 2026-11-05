# Intérprete de Partituras Musicales con Lex y Yacc

## Integrantes del Equipo

- Do Kyu Han - A01025119
- Diego De La Vega Saishio - A01420632
- Fernando Daniel Monroy Sánchez - A01750536

## Descripción del Proyecto

Este proyecto implementa un analizador léxico y sintáctico con semántica de interpretación para un lenguaje formal de partituras musicales, utilizando Flex (Lex) y Bison (Yacc) sobre lenguaje C.

A diferencia de un simple validador de sintaxis, este intérprete realiza evaluación semántica completa:

1. Procesa encabezados de configuración global: tempo en beats por minuto (BPM), compás métrico y clave.
2. Reconoce eventos musicales: notas con alteración y octava, silencios, duraciones relativas, puntillos y ligaduras.
3. Valida la integridad rítmica de cada compás frente a la métrica activa (por ejemplo 4.00 tiempos en compás 4/4).
4. Detecta bloques de repetición y acumula los tiempos de ejecución adicionales.
5. Calcula y reporta la duración estimada total de la pieza musical en segundos y minutos.

## Especificación del Lenguaje

### Tokens de Configuración

- `tempo`: Asigna la velocidad de reproducción en BPM (ejemplo: `tempo = 120`).
- `time`: Asigna el compás métrico fraccionario (ejemplo: `time = 4/4`, `time = 3/4`).
- `clef`: Asigna la clave musical (ejemplo: `clef = treble`).

### Tokens Musicales

- Notas: `[A-G][#b]?[0-8]` (ejemplo: `C4`, `F#5`, `Bb3`).
- Silencios: `R` con duración opcional (ejemplo: `R/4`, `R4`, `R/2`).
- Duraciones: `/1` (redonda, 4 tiempos), `/2` (blanca, 2 tiempos), `/4` (negra, 1 tiempo), `/8` (corchea, 0.5 tiempos), etc.
- Modificadores: `.` (puntillo que suma el 50 por ciento del valor base) y `~` (ligadura de prolongación).
- Dinámicas: `ppp`, `pp`, `p`, `mp`, `mf`, `f`, `ff`, `fff`.
- Barras de compás: `|` (barra simple), `|:` (inicio repetición), `:|` (fin repetición), `||` (barra doble final).

## Compilación y Ejecución Local

Requisitos previos:

- GCC compiler
- Flex
- Bison

Pasos:

```bash
cd src
bison -y -d music.yacc
flex music.lex
gcc y.tab.c lex.yy.c -o music
./music test.txt
```

## Despliegue y Ejecución con Docker

Enlace del repositorio en Docker Hub:
https://hub.docker.com/r/ferdms/tarea-lex-yacc

Descarga y ejecución directa (evaluación):

```bash
docker pull ferdms/tarea-lex-yacc:latest
docker run --rm ferdms/tarea-lex-yacc:latest
```

Construcción local alternativa desde código fuente:

```bash
docker build -t ferdms/tarea-lex-yacc:latest .
```
