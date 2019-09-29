(** Markdown files *)

(** Markdown file *)
type t

(** Problem with parsing *)
exception Error of string

(** Parse from string *)
val from_string : string -> t

(** Get HTML *)
val to_html : t -> Html.t list
