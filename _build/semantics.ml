open Ast.V1
open Ast.IR1
open Ast
open Baselib


exception Error of string * Lexing.position

let expr_pos expr =
  match expr with
  | Syntax.Int n  -> n.pos
  | Syntax.Var v  -> v.pos
  | Syntax.Call c -> c.pos

let errt expected given pos =
  raise (Error (Printf.sprintf "expected %s but given %s"
                  (string_of_type_t expected)
                  (string_of_type_t given),
                pos))

(* analyse sémantique *)

let rec analyze_expr expr env =
  match expr with
  | Syntax.Int n  -> Value(Int n.value) ,Int_t
  | Syntax.Var v ->
     if Env.mem v.name env then
       Var v.name, Env.find v.name env
     else
       raise (Error (Printf.sprintf "unbound variable '%s'" v.name,
                     v.pos))
  | Syntax.Call c ->
     match Env.find_opt c.func env with
     | Some (Func_t (rt, at)) ->
        if List.length at != List.length c.args then
          raise (Error (Printf.sprintf "expected %d arguments but given %d"
                          (List.length at) (List.length c.args), c.pos)) ;
        let args = List.map2 (fun eat a -> let aa, at = analyze_expr a env
                                           in if at = eat then aa
                                              else errt eat at (expr_pos a))
                     at c.args in
        Call (c.func, args), rt
     | Some _ -> raise (Error (Printf.sprintf "'%s' is not a function" c.func,
                               c.pos))
     | None -> raise (Error (Printf.sprintf "undefined function '%s'" c.func,
                             c.pos))

let rec analyze_instr instr env =
  match instr with
  | Syntax.Decl d -> Decl (d.type_,d.var), (Env.add d.var d.type_ env)
  | Syntax.Loop d -> let (a,b) = analyze_expr d.break env in Loop (a,analyze_block d.block env) , env
  | Syntax.Cond d -> let (a,b) = analyze_expr d.cond env in Cond (a,analyze_block d.blockif env,analyze_block d.blockelse env) , env
  | Syntax.Assign a ->
      let ae, et = analyze_expr a.expr env in
      Assign (LVar (a.var), ae), Env.add a.var et env
  | Syntax.Return r ->
      let ae, _ = analyze_expr r.expr env in
      Return ae, env
and analyze_block block env =
  match block with
  | [] -> []
  | instr :: rest ->
      let ai, new_env = analyze_instr instr env in
      ai :: (analyze_block rest new_env)

let analyze parsed =
  analyze_block parsed Baselib._types_
