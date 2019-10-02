(** Article file AST *)

open Util

(** Header options *)
type header =
| Title of string
| Authors of string list
| Date of date
| Default_language of string
| Updated of date
| Tags of string list
| Summary of string

(** AST *)
type t = header list * string
