(** Article file AST *)

(** Header options *)
type header =
| Title of string
| Authors of string list
| Date of int * int * int

(** AST *)
type t = header list * string
