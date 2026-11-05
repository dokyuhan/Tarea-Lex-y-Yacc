# Intérprete de Partituras Musicales con Lex y Yacc

## Integrantes del Equipo

- Do Kyu Han - A01025119
- Diego De La Vega Saishio - A01420632
- Fernando Daniel Monroy Sánchez - A01750536

## Compilación y Ejecución Local

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
