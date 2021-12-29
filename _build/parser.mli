
(* The type of tokens. *)

type token = 
  | Op
  | Ob
  | Lvar of (string)
  | Lsub
  | Lsmaller
  | Lsint
  | Lsc
  | Lreturn
  | Lprint
  | Lopar
  | Lnotequal
  | Lmul
  | Lloop
  | Lint of (int)
  | Lfunc
  | Lequal
  | Lend
  | Lelcond
  | Ldiv
  | Lcpar
  | Lcond
  | Lbigger
  | Lassign
  | Ladd
  | Cp
  | Cb

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val block: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.Syntax.block)
