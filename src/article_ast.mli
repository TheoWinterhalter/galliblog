(** Article file AST *)

(** Date [d/m/y] *)
type date = int * int * int

(** Header options *)
type header =
| Title of string
| Authors of string list
| Date of date
| Default_language of string
| Updated of date

(** AST *)
type t = header list * string
