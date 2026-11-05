FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    flex \
    bison \
    gcc \
    make \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY src/ /src/
# corre en cunado se compila el contenedor para tener listo el ejecutable llamandolo "music"
RUN bison -y -d music.yacc && \
    flex music.lex && \
    gcc y.tab.c lex.yy.c -o music -lfl

CMD ["bash"]
