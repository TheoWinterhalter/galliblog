(** Article file AST *)

open Util

(** Header options *)
type header =
| Title of string
| Authors of string list
| Date of date
| Default_language of string
| Updated of date

(** AST *)
type t = header list * string
