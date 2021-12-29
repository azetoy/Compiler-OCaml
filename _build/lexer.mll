{
  open Lexing
  open Parser

  exception Error of char
}

let alpha = ['a'-'z' 'A'-'Z']
let num = ['0'-'9']
let identifier = alpha (alpha | num | '-' | '_')*

rule token = parse
| eof                       { Lend }
| [ ' ' '\t' ]              { token lexbuf }
| '\n'                      { Lexing.new_line lexbuf; token lexbuf }
| '#'                       { comment lexbuf }
| "return"                  {Lreturn }
| ";"                       {Lsc}
| num+ as n                 {Lint (int_of_string n)}
| "="                       {Lassign}
| "void"                    {Lfunc}
| "print"                   {Lprint}
| "while"                   {Lloop}
| "if"                      {Lcond}
| "else"                    {Lelcond}
| '>'                       {Lbigger}
| '<'                       {Lsmaller}
| "=="                      {Lequal}
| "!="                      {Lnotequal}
| '('                       {Op}
| ')'                       {Cp}
| '{'                       {Ob}
| '}'                       {Cb}
| "int"                     {Lsint}
| "+"                       {Ladd}
| "-"                       {Lsub}
| "/"                       {Ldiv}
| "*"                       {Lmul}
|identifier as v            {Lvar (v)}
| _ as c                    { raise (Error c) }

and comment = parse
| eof  { Lend }
| '\n' { Lexing.new_line lexbuf; token lexbuf }
| _    { comment lexbuf }
