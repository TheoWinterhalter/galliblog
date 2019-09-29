(** Blog article *)

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

(** Publishing date of an article, day/month/year *)
val date : t -> int * int * int

(** Content of an article (TODO HTML format)) *)
val content : t -> string
