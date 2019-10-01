open Omd

(** Some HTML utils, may be moved later *)

let emph l =
  let open Html in
  let open Attribute in
  span [ classes [ "emph" ] ] l

let bold l =
  let open Html in
  let open Attribute in
  span [ classes [ "bold" ] ] l

let inlinecode lang code =
  (* TODO Deal with lang empty and default lang
     For default lang maybe just use set_default_lang
   *)
  Html.code [ Attribute.classes [ lang ] ] [ Html.text code ]

let codeblock lang c =
  (* TODO Deal with lang empty and default lang
     For default lang maybe just use set_default_lang
   *)
  (* TODO Deal with jscoq *)
  let open Html in
  let open Attribute in
  pre [ classes [ lang ] ] [
    code [ classes [ lang ] ] [
      text c
    ]
  ]

let url lnk ttl t =
  let open Html in
  let open Attribute in
  if ttl <> ""
  then a [ href lnk ; title ttl ] t
  else a [ href lnk ] t

let to_attr (a,v) =
  begin match v with
  | Some v -> Attribute.attr a v
  | None -> Attribute.battr a
  end

(** Transformation to HTML *)

let rec html l =
  List.map element_to_html l

and element_to_html el =
  begin match el with
  | H1 t -> Html.h1 [] (html t)
  | H2 t -> Html.h2 [] (html t)
  | H3 t -> Html.h3 [] (html t)
  | H4 t -> Html.h4 [] (html t)
  | H5 t -> Html.h5 [] (html t)
  | H6 t -> Html.h6 [] (html t)
  | Paragraph [] -> Html.text "" (* TODO Use option to skip (or list?) *)
  | Paragraph t -> Html.p [] (html t)
  | Text t -> Html.text t
  | Emph t -> emph (html t)
  | Bold t -> bold (html t)
  | Ul l | Ulp l -> Html.ul [] (to_li l)
  | Ol l | Olp l -> Html.ol [] (to_li l)
  | Code (lang, code) -> inlinecode lang code
  | Code_block (lang, code) -> codeblock lang code
  | Br -> Html.br []
  | Hr -> Html.hr []
  | NL -> Html.text "\n"
  | Url (href, t, title) -> url href title (html t)
  | Ref (rc, name, text, fallback) -> Html.text "" (* TODO Use option instead or do something *)
  | Img_ref (rc, name, alt, fallback) -> Html.text "" (* TODO idem *)
  | Html (tagname, attrs, body) ->
    Html.custom tagname (List.map to_attr attrs) (html body)
  | Html_block (tagname, attrs, body) ->
    (* TODO Deal with possibly void tags
       It would then be closer to a parser for Html
       instead of custom entries.
     *)
    Html.custom tagname (List.map to_attr attrs) (html body)
  | Html_comment s -> Html.text "" (* TODO *)
  | Raw s -> Html.text s
  | Raw_block s -> Html.text s
  | Blockquote t -> Html.blockquote [] (html t)
  | Img (alt, src, title) ->
    if title <> ""
    then Html.img [ Attribute.src src ; Attribute.title title ]
    else Html.img [ Attribute.src src ]
  | X x -> Html.text "" (* Ignored *)
  end

and to_li l =
  List.map (fun t -> Html.li [] (html t)) l

let md_to_html l = html l
