type type_t =
  | Int_t
  | Func_t of type_t * type_t list

let rec string_of_type_t t =
  match t with
  | Int_t  -> "int"
  | Func_t (r, a) ->
     (if (List.length a) > 1 then "(" else "")
     ^ (String.concat ", " (List.map string_of_type_t a))
     ^ (if (List.length a) > 1 then ")" else "")
     ^ " -> " ^ (string_of_type_t r)


module Syntax = struct
  type ident = string
  type expr =
    | Int  of { value: int
              ; pos: Lexing.position }
    | Var  of { name: ident
              ; pos: Lexing.position }
    | Call of { func: ident
              ; args: expr list
              ; pos: Lexing.position }
  type instr =
    | Assign of { var: ident
                ; expr: expr
                ; pos: Lexing.position }
    | Return of { expr: expr
                ; pos: Lexing.position }
    | Decl of   { type_ : type_t
                    ;var: ident
                    ; pos: Lexing.position }
    | Cond of { cond : expr
                ;blockif : block
                ;blockelse : block
                ; pos: Lexing.position }
    | Loop of { break : expr
                ;block : block
                ; pos: Lexing.position }
  and block = instr list
end

module type Parameters = sig
  type value
end

module V1 = struct
  type value =
    | Nil
    | Bool of bool
    | Int  of int
    | Str  of string
end

module V2 = struct
  type value =
    | Nil
    | Bool of bool
    | Int  of int
    | Data of string
end

module IR (P : Parameters) = struct
  type ident = string
  type expr =
    | Value of P.value
    | Var   of ident
    | Call  of ident * expr list
  type lvalue =
    | LVar  of ident
    | LAddr of expr
  type instr =
    | Decl   of type_t * ident
    | Return of expr
    | Expr   of expr
    | Assign of lvalue * expr
    | Cond   of expr * block * block
    | Loop of expr * block
  and block = instr list
  type def =
    | Func of ident * ident list * block
  type prog = def list
end

module IR1 = IR(V1)
module IR2 = IR(V2)
