/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TOKEN_TEMPO = 258,             /* TOKEN_TEMPO  */
    TOKEN_TIME_SIG = 259,          /* TOKEN_TIME_SIG  */
    TOKEN_CLEF = 260,              /* TOKEN_CLEF  */
    TOKEN_DINAMICA = 261,          /* TOKEN_DINAMICA  */
    TOKEN_BARRA = 262,             /* TOKEN_BARRA  */
    TOKEN_METRICA = 263,           /* TOKEN_METRICA  */
    TOKEN_DURACION = 264,          /* TOKEN_DURACION  */
    TOKEN_NOTA = 265,              /* TOKEN_NOTA  */
    TOKEN_SILENCIO = 266,          /* TOKEN_SILENCIO  */
    TOKEN_PUNTILLO = 267,          /* TOKEN_PUNTILLO  */
    TOKEN_LIGADURA = 268,          /* TOKEN_LIGADURA  */
    TOKEN_NUMERO = 269,            /* TOKEN_NUMERO  */
    TOKEN_ID = 270,                /* TOKEN_ID  */
    TOKEN_ASIGN = 271              /* TOKEN_ASIGN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define TOKEN_TEMPO 258
#define TOKEN_TIME_SIG 259
#define TOKEN_CLEF 260
#define TOKEN_DINAMICA 261
#define TOKEN_BARRA 262
#define TOKEN_METRICA 263
#define TOKEN_DURACION 264
#define TOKEN_NOTA 265
#define TOKEN_SILENCIO 266
#define TOKEN_PUNTILLO 267
#define TOKEN_LIGADURA 268
#define TOKEN_NUMERO 269
#define TOKEN_ID 270
#define TOKEN_ASIGN 271

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
