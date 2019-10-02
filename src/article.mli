(** Blog article *)

open Util

(** Type of blog article *)
type t

(** Problem with parsing *)
exception Error of string

(** Read article from file *)
val from_file : string -> t

(** Title of an article *)
val title : t -> string

(** Authors of an article *)
val authors : t -> string list

(** Publishing date of an article *)
val date : t -> date

(** Default language *)
val default_language : t -> string option

(** Last update date *)
val updated : t -> date option

(** List of tags *)
val tags : t -> string list option

(** Summary *)
val summary : t -> string option

(** Content of an article *)
val content : t -> Html.t list

(** Html page *)
val page : t -> Html.t
