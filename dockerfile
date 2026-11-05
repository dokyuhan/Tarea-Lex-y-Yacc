FROM gcc:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends flex bison && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY src/ /app/

RUN bison -y -d music.yacc && \
    flex music.lex && \
    gcc y.tab.c lex.yy.c -o music

CMD ["./music", "test.txt"]
