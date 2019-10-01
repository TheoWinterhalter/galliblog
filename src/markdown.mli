(** Wrapper around omd to use the Html module and more *)

(** Convert internal omd representation to Html *)
val md_to_html : Omd.t -> Html.t list
