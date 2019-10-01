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
  if lang <> ""
  then Html.code [ Attribute.classes [ lang ] ] [ Html.text code ]
  else Html.code [] [ Html.text code ]

let codeblock lang c =
  (* TODO Deal with jscoq *)
  let open Html in
  let open Attribute in
  let attr = if lang <> "" then [ classes [ lang ] ] else [] in
  pre attr [
    code attr [
      text c
    ]
  ]

let url lnk ttl t =
  let open Html in
  let open Attribute in
  if ttl <> ""
  then a [ href lnk ; title ttl ] t
  else a [ href lnk ] t

let img _alt _src _title =
  let open Html in
  let open Attribute in
  if _title <> ""
  then img [ alt _alt ; src _src ; title _title ]
  else img [ alt _alt ; src _src ]

let to_attr (a,v) =
  begin match v with
  | Some v -> Attribute.attr a v
  | None -> Attribute.battr a
  end

(** Transformation to HTML *)

let ret t = [ t ]

let rec html l =
  List.concat @@ List.map element_to_html l

and element_to_html el =
  begin match el with
  | H1 t -> ret @@ Html.h1 [] (html t)
  | H2 t -> ret @@ Html.h2 [] (html t)
  | H3 t -> ret @@ Html.h3 [] (html t)
  | H4 t -> ret @@ Html.h4 [] (html t)
  | H5 t -> ret @@ Html.h5 [] (html t)
  | H6 t -> ret @@ Html.h6 [] (html t)
  | Paragraph [] -> []
  | Paragraph t -> ret @@ Html.p [] (html t)
  | Text t -> ret @@ Html.text t
  | Emph t -> ret @@ emph (html t)
  | Bold t -> ret @@ bold (html t)
  | Ul l | Ulp l -> ret @@ Html.ul [] (to_li l)
  | Ol l | Olp l -> ret @@ Html.ol [] (to_li l)
  | Code (lang, code) -> ret @@ inlinecode lang code
  | Code_block (lang, code) -> ret @@ codeblock lang code
  | Br -> ret @@ Html.br []
  | Hr -> ret @@ Html.hr []
  | NL -> ret @@ Html.text "\n"
  | Url (href, t, title) -> ret @@ url href title (html t)
  | Ref (rc, name, text, fallback) ->
    begin match rc#get_ref name with
    | Some (href, title) -> ret @@ url href title [ Html.text text ]
    | None -> html fallback#to_t
    end
  | Img_ref (rc, name, alt, fallback) ->
    begin match rc#get_ref name with
    | Some (src, title) -> ret @@ img alt src title
    | None -> html fallback#to_t
    end
  | Html (tagname, attrs, body) ->
    ret @@ Html.custom tagname (List.map to_attr attrs) (html body)
  | Html_block (tagname, attrs, body) ->
    (* TODO Deal with possibly void tags
       It would then be closer to a parser for Html
       instead of custom entries.
     *)
    ret @@ Html.custom tagname (List.map to_attr attrs) (html body)
  | Html_comment s -> []
  | Raw s -> ret @@ Html.text s
  | Raw_block s -> ret @@ Html.text s
  | Blockquote t -> ret @@ Html.blockquote [] (html t)
  | Img (alt, src, title) -> ret @@ img alt src title
  | X x -> []
  end

and to_li l =
  List.map (fun t -> Html.li [] (html t)) l

let md_to_html l = html l
