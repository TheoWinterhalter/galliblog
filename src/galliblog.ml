open Attribute
open Html
open Util

(* mkdir if does not exists *)
let fmkdir dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o777

let () =
  fmkdir "website" ;
  let output = open_out "website/index.html" in
  let page =
    html [] [
      head [] [
        title [] [ text "Galliblog" ] ;
        meta [ charset "utf-8" ]
      ] ;
      body [] [
        h1 [] [ text "Test" ]
      ]
    ]
  in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output
