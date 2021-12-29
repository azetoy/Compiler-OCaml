open Ast
open Mips

module Env = Map.Make(String)
let _types_ =
  Env.of_seq
    (List.to_seq
       [ "_add", Func_t (Int_t, [ Int_t ; Int_t ])
       ; "_sub", Func_t (Int_t, [ Int_t ; Int_t ])
       ; "_mul", Func_t (Int_t, [ Int_t ; Int_t ])
       ; "_div", Func_t (Int_t, [ Int_t ; Int_t ])
       ; "puti", Func_t (Int_t, [ Int_t])
       ; "bigger", Func_t (Int_t, [ Int_t ; Int_t ])
       ; "equal", Func_t (Int_t, [ Int_t ; Int_t ])
       ; "notequal", Func_t (Int_t, [ Int_t ; Int_t ])
    ])

let builtins =
  [ Label "_add"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Add (V0, T0, T1)
  ; Jr RA

  ; Label "_sub"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Sub (V0, T0, T1)
  ; Jr RA
      
  ; Label "_mul"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Mul (V0, T0, T1)
  ; Jr RA

  ; Label "_div"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Div (V0, T0, T1)
  ; Jr RA

  ; Label "bigger"
  ; Lw (T0,Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Slt(V0, T0, T1)
  ; Jr RA

  ; Label "notequal"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Beq ( T0, T1, "eqq")
  ; Li (V0, 1)
  ; Jr RA
  ; Label "eqq"
  ; Li (V0 , 0)
  ; Jr RA

  ; Label "equal"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Beq ( T0, T1, "neqq")
  ; Li (V0, 0)
  ; Jr RA
  ; Label "neqq"
  ; Li (V0 , 1)
  ; Jr RA

  ; Label "puti"
  ; Lw (A0, Mem (SP, 0))
  ; Li (V0, Syscall.print_int)
  ; Syscall
  ; Jr RA

  ; Label "geti"
  ; Lw (A0, Mem (SP, 0))
  ; Li (V0, Syscall.read_int)
  ; Syscall
  ; Jr RA

  ; Label "puts"
  ; Lw (A0, Mem (SP, 0))
  ; Li (V0, Syscall.print_str)
  ; Syscall
  ; Jr RA

  ]
