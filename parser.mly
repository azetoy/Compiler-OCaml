%{
  open Ast
  open Ast.Syntax
%}


%token <int>Lint
%token Lsint
%token <string> Lvar
%token Ladd Lsub Lmul Ldiv Lopar Lcpar
%token Lreturn Lassign Lsc Lend
%token Lfunc Op Cp Ob Cb
%token Lloop Lcond Lelcond
%token Lequal Lnotequal Lbigger Lsmaller

%token Lprint

%left Ladd Lsub
%left Lmul Ldiv


%start block

%type <Ast.Syntax.block> block

%%

block:
| e = instr; b = block { 
  [e] @ b 
}
| e = instr{ [e] }

| Lend { [] }
;

expr:
| n = Lint {
    Int {value = n ; pos = $startpos(n) }
}
| v = Lvar {
    Var { name = v; pos = $startpos(v) }
}
| a = expr; Lmul; b = expr {
    Call {  func = "_mul";
            args = [a ; b];
            pos = $startpos($2) }
}
| a = expr; Ladd; b = expr {
    Call {  func = "_add";
            args = [a ; b];
            pos = $startpos($2) }
}
| a = expr; Lsub; b = expr {
    Call {  func = "_sub";
            args = [a ; b];
            pos = $startpos($2) }
}
| a = expr; Ldiv; b = expr {
    Call {  func = "_div";
            args = [a ; b];
            pos = $startpos($2) }
}
|Lprint;Op;e = expr;Cp{
    Call {  func = "puti";
            args = [e];
            pos = $startpos($1) }
}
| a = expr;Lbigger; b = expr{
  Call { func = "bigger";
          args = [a ; b];
          pos = $startpos($2) }
}
| a = expr;Lsmaller; b = expr{
  Call { func = "bigger";
          args = [b ; a];
          pos = $startpos($2) }
}
| a = expr;Lequal; b = expr{
  Call { func = "equal";
          args = [a ; b];
          pos = $startpos($2) }
}
| a = expr;Lnotequal; b = expr{
  Call { func = "notequal";
          args = [a ; b];
          pos = $startpos($2) }
}
;

instr:

|Lcond;Op; e = expr;Cp;Ob;b = block;Cb;Lelcond;Ob;be = block;Cb{
  Cond {cond = e;blockif = b;blockelse = be;pos = $startpos(e)}
}

|Lloop;Op;e = expr;Cp;Ob;b = block;Cb{
  Loop{break = e;block = b;pos = $startpos(e)}
}

|Lsint;v_name = Lvar;Lsc{
Decl {type_ = Int_t;var = v_name ;pos = $startpos(v_name)}
}

|Lsint;v_name = Lvar;Lassign;b = expr;Lsc {
  Decl   {type_ = Int_t;var = v_name ;pos = $startpos(v_name)};
  Assign {var = v_name;expr = b;pos = $startpos(v_name) }
}

| v_name = Lvar; Lassign; b = expr; Lsc { 
    Assign {var = v_name;expr = b;pos = $startpos($2) }
}

| Lreturn; e = expr; Lsc {
  Return {expr = e;pos = $startpos($1) }
}
;
                        
