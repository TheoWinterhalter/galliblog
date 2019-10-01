(** Article file AST *)

(** Header options *)
type header =
| Title of string
| Authors of string list
| Date of int * int * int
| Default_language of string

(** AST *)
type t = header list * string
