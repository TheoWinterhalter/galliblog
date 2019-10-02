(** HTML util *)

(** Produces html from a list of authors *)
val authors_html : string list -> Html.t list

(** Blog header *)
val blog_header : index:bool -> Html.t

(** Html of a list of tags *)
val tags_html : string list -> Html.t

(** Template for a website page *)
val template : Html.t list -> Html.t
