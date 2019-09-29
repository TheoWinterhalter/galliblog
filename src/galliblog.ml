open Attribute
open Html
open Util

(* mkdir if does not exists *)
let fmkdir dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o777

let copy src dest =
  let command = Printf.sprintf "cp %s %s" src dest in
  (* if not (Sys.file_exists dest) then *)
  Unix.system command |> ignore

let authors_text l =
  "By " ^ String.concat " and " l ^ "."

let month = function
  | 1 -> "January"
  | 2 -> "February"
  | 3 -> "March"
  | 4 -> "April"
  | 5 -> "May"
  | 6 -> "June"
  | 7 -> "July"
  | 8 -> "August"
  | 9 -> "September"
  | 10 -> "October"
  | 11 -> "November"
  | 12 -> "December"
  | _ -> "???"

let date_text (d,m,y) =
  Printf.sprintf "On %d %s %d." d (month m) y

let () =
  fmkdir "website" ;
  copy "content/blog.css" "website/blog.css" ;
  let entry = Article.from_file "content/test.md" in
  let output = open_out "website/index.html" in
  let page =
    html [] [
      head [] [
        title [] [ text (Article.title entry ^ " – Galliblog") ] ;
        meta [ charset "utf-8" ] ;
        link [
          href "https://fonts.googleapis.com/css?family=Open+Sans:300,400,700" ;
          rel "stylesheet" ;
          typ "text/css"
        ] ;
        link [ rel "stylesheet" ; href ("blog.css") ] ;
      ] ;
      body [] [
        article [] [
          header [] [
            h1 [] [ text (Article.title entry) ] ;
            p [] [ text (authors_text (Article.authors entry))] ;
            p [] [ text (date_text (Article.date entry))]
          ] ;
          p [] [ text (Article.content entry) ]
        ]
      ]
    ]
  in
  Printf.fprintf output "%s" (Html.document_to_string page) ;
  close_out output
