open Attribute
open Html
open Util

(* mkdir if does not exists *)
let fmkdir dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o777

let authors_text l =
  "By " ^ String.concat " and " l ^ "."

(* TODO Improve *)
let date_text (d,m,y) =
  Printf.sprintf "On %d/%d/%d." d m y

let () =
  fmkdir "website" ;
  let output = open_out "website/index.html" in
  let entry = Article.from_file "content/test.md" in
  let page =
    html [] [
      head [] [
        title [] [ text (Article.title entry ^ " – Galliblog") ] ;
        meta [ charset "utf-8" ]
      ] ;
      body [] [
        h1 [] [ text (Article.title entry) ] ;
        p [] [ text (authors_text (Article.authors entry))] ;
        p [] [ text (date_text (Article.date entry))] ;
        p [] [ text (Article.content entry) ]
      ]
    ]
  in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output
